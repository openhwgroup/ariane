// Copyright 2017-2019 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: Florian Zaruba, ETH Zurich
// Date: 19.03.2017
// Description: CVA6 Top-level module

`include "rvfi_types.svh"
`include "cvxif_types.svh"

module cva6
  import ariane_pkg::*;
#(
    // CVA6 config
    parameter config_pkg::cva6_cfg_t CVA6Cfg = build_config_pkg::build_config(
        cva6_config_pkg::cva6_cfg
    ),

    // RVFI PROBES
    parameter type rvfi_probes_instr_t = `RVFI_PROBES_INSTR_T(CVA6Cfg),
    parameter type rvfi_probes_csr_t = `RVFI_PROBES_CSR_T(CVA6Cfg),
    parameter type rvfi_probes_t = struct packed {
      rvfi_probes_csr_t   csr;
      rvfi_probes_instr_t instr;
    },

    // branchpredict scoreboard entry
    // this is the struct which we will inject into the pipeline to guide the various
    // units towards the correct branch decision and resolve
    localparam type branchpredict_sbe_t = struct packed {
      cf_t                     cf;               // type of control flow prediction
      logic [CVA6Cfg.VLEN-1:0] predict_address;  // target address at which to jump, or not
    },

    localparam type exception_t = struct packed {
      logic [CVA6Cfg.XLEN-1:0] cause;  // cause of exception
      logic [CVA6Cfg.XLEN-1:0] tval;  // additional information of causing exception (e.g.: instruction causing it),
      // address of LD/ST fault
      logic [CVA6Cfg.GPLEN-1:0] tval2;  // additional information when the causing exception in a guest exception
      logic [31:0] tinst;  // transformed instruction information
      logic gva;  // signals when a guest virtual address is written to tval
      logic valid;
    },

    // cache request ports
    // I$ address translation requests
    localparam type icache_areq_t = struct packed {
      logic                    fetch_valid;      // address translation valid
      logic [CVA6Cfg.PLEN-1:0] fetch_paddr;      // physical address in
      exception_t              fetch_exception;  // exception occurred during fetch
    },
    localparam type icache_arsp_t = struct packed {
      logic                    fetch_req;    // address translation request
      logic [CVA6Cfg.VLEN-1:0] fetch_vaddr;  // virtual address out
    },

    // I$ data requests
    localparam type icache_dreq_t = struct packed {
      logic                    req;      // we request a new word
      logic                    kill_s1;  // kill the current request
      logic                    kill_s2;  // kill the last request
      logic                    spec;     // request is speculative
      logic [CVA6Cfg.VLEN-1:0] vaddr;    // 1st cycle: 12 bit index is taken for lookup
    },
    localparam type icache_drsp_t = struct packed {
      logic                                ready;  // icache is ready
      logic                                valid;  // signals a valid read
      logic [CVA6Cfg.FETCH_WIDTH-1:0]      data;   // 2+ cycle out: tag
      logic [CVA6Cfg.FETCH_USER_WIDTH-1:0] user;   // User bits
      logic [CVA6Cfg.VLEN-1:0]             vaddr;  // virtual address out
      exception_t                          ex;     // we've encountered an exception
    },

    // IF/ID Stage
    // store the decompressed instruction
    localparam type fetch_entry_t = struct packed {
      logic [CVA6Cfg.VLEN-1:0] address;  // the address of the instructions from below
      logic [31:0] instruction;  // instruction word
      branchpredict_sbe_t     branch_predict; // this field contains branch prediction information regarding the forward branch path
      exception_t             ex;             // this field contains exceptions which might have happened earlier, e.g.: fetch exceptions
    },

    // ID/EX/WB Stage
    localparam type scoreboard_entry_t = struct packed {
      logic [CVA6Cfg.VLEN-1:0] pc;  // PC of instruction
      logic [CVA6Cfg.TRANS_ID_BITS-1:0] trans_id;      // this can potentially be simplified, we could index the scoreboard entry
      // with the transaction id in any case make the width more generic
      fu_t fu;  // functional unit to use
      fu_op op;  // operation to perform in each functional unit
      logic [REG_ADDR_SIZE-1:0] rs1;  // register source address 1
      logic [REG_ADDR_SIZE-1:0] rs2;  // register source address 2
      logic [REG_ADDR_SIZE-1:0] rd;  // register destination address
      logic [CVA6Cfg.XLEN-1:0] result;  // for unfinished instructions this field also holds the immediate,
      // for unfinished floating-point that are partly encoded in rs2, this field also holds rs2
      // for unfinished floating-point fused operations (FMADD, FMSUB, FNMADD, FNMSUB)
      // this field holds the address of the third operand from the floating-point register file
      logic valid;  // is the result valid
      logic use_imm;  // should we use the immediate as operand b?
      logic use_zimm;  // use zimm as operand a
      logic use_pc;  // set if we need to use the PC as operand a, PC from exception
      exception_t ex;  // exception has occurred
      branchpredict_sbe_t bp;  // branch predict scoreboard data structure
      logic                     is_compressed; // signals a compressed instructions, we need this information at the commit stage if
                                               // we want jump accordingly e.g.: +4, +2
      logic is_macro_instr;  // is an instruction executed as predefined sequence of instructions called macro definition
      logic is_last_macro_instr;  // is last decoded 32bit instruction of macro definition
      logic is_double_rd_macro_instr;  // is double move decoded 32bit instruction of macro definition
      logic vfp;  // is this a vector floating-point instruction?
    },
    localparam type writeback_t = struct packed {
      logic valid;  // wb data is valid
      logic [CVA6Cfg.XLEN-1:0] data;  //wb data
      logic ex_valid;  // exception from WB
      logic [CVA6Cfg.TRANS_ID_BITS-1:0] trans_id;  //transaction ID
    },

    // branch-predict
    // this is the struct we get back from ex stage and we will use it to update
    // all the necessary data structures
    // bp_resolve_t
    localparam type bp_resolve_t = struct packed {
      logic                    valid;           // prediction with all its values is valid
      logic [CVA6Cfg.VLEN-1:0] pc;              // PC of predict or mis-predict
      logic [CVA6Cfg.VLEN-1:0] target_address;  // target address at which to jump, or not
      logic                    is_mispredict;   // set if this was a mis-predict
      logic                    is_taken;        // branch is taken
      cf_t                     cf_type;         // Type of control flow change
    },

    // All information needed to determine whether we need to associate an interrupt
    // with the corresponding instruction or not.
    localparam type irq_ctrl_t = struct packed {
      logic [CVA6Cfg.XLEN-1:0] mie;
      logic [CVA6Cfg.XLEN-1:0] mip;
      logic [CVA6Cfg.XLEN-1:0] mideleg;
      logic [CVA6Cfg.XLEN-1:0] hideleg;
      logic                    sie;
      logic                    global_enable;
    },

    localparam type lsu_ctrl_t = struct packed {
      logic                             valid;
      logic [CVA6Cfg.VLEN-1:0]          vaddr;
      logic [31:0]                      tinst;
      logic                             hs_ld_st_inst;
      logic                             hlvx_inst;
      logic                             overflow;
      logic                             g_overflow;
      logic [CVA6Cfg.XLEN-1:0]          data;
      logic [(CVA6Cfg.XLEN/8)-1:0]      be;
      fu_t                              fu;
      fu_op                             operation;
      logic [CVA6Cfg.TRANS_ID_BITS-1:0] trans_id;
    },

    localparam type fu_data_t = struct packed {
      fu_t                              fu;
      fu_op                             operation;
      logic [CVA6Cfg.XLEN-1:0]          operand_a;
      logic [CVA6Cfg.XLEN-1:0]          operand_b;
      logic [CVA6Cfg.XLEN-1:0]          imm;
      logic [CVA6Cfg.TRANS_ID_BITS-1:0] trans_id;
    },

    localparam type icache_req_t = struct packed {
      logic [CVA6Cfg.ICACHE_SET_ASSOC_WIDTH-1:0] way;  // way to replace
      logic [CVA6Cfg.PLEN-1:0] paddr;  // physical address
      logic nc;  // noncacheable
      logic [CVA6Cfg.MEM_TID_WIDTH-1:0] tid;  // threadi id (used as transaction id in Ariane)
    },
    localparam type icache_rtrn_t = struct packed {
      wt_cache_pkg::icache_in_t rtype;  // see definitions above
      logic [CVA6Cfg.ICACHE_LINE_WIDTH-1:0] data;  // full cache line width
      logic [CVA6Cfg.ICACHE_USER_LINE_WIDTH-1:0] user;  // user bits
      struct packed {
        logic                                      vld;  // invalidate only affected way
        logic                                      all;  // invalidate all ways
        logic [CVA6Cfg.ICACHE_INDEX_WIDTH-1:0]     idx;  // physical address to invalidate
        logic [CVA6Cfg.ICACHE_SET_ASSOC_WIDTH-1:0] way;  // way to invalidate
      } inv;  // invalidation vector
      logic [CVA6Cfg.MEM_TID_WIDTH-1:0] tid;  // threadi id (used as transaction id in Ariane)
    },

    // D$ data requests
    localparam type dcache_req_i_t = struct packed {
      logic [CVA6Cfg.DCACHE_INDEX_WIDTH-1:0] address_index;
      logic [CVA6Cfg.DCACHE_TAG_WIDTH-1:0]   address_tag;
      logic [CVA6Cfg.XLEN-1:0]               data_wdata;
      logic [CVA6Cfg.DCACHE_USER_WIDTH-1:0]  data_wuser;
      logic                                  data_req;
      logic                                  data_we;
      logic [(CVA6Cfg.XLEN/8)-1:0]           data_be;
      logic [1:0]                            data_size;
      logic [CVA6Cfg.DcacheIdWidth-1:0]      data_id;
      logic                                  kill_req;
      logic                                  tag_valid;
    },

    localparam type dcache_req_o_t = struct packed {
      logic                                 data_gnt;
      logic                                 data_rvalid;
      logic [CVA6Cfg.DcacheIdWidth-1:0]     data_rid;
      logic [CVA6Cfg.XLEN-1:0]              data_rdata;
      logic [CVA6Cfg.DCACHE_USER_WIDTH-1:0] data_ruser;
    },

    // AXI types
    parameter type axi_ar_chan_t = struct packed {
      logic [CVA6Cfg.AxiIdWidth-1:0]   id;
      logic [CVA6Cfg.AxiAddrWidth-1:0] addr;
      axi_pkg::len_t                   len;
      axi_pkg::size_t                  size;
      axi_pkg::burst_t                 burst;
      logic                            lock;
      axi_pkg::cache_t                 cache;
      axi_pkg::prot_t                  prot;
      axi_pkg::qos_t                   qos;
      axi_pkg::region_t                region;
      logic [CVA6Cfg.AxiUserWidth-1:0] user;
    },
    parameter type axi_aw_chan_t = struct packed {
      logic [CVA6Cfg.AxiIdWidth-1:0]   id;
      logic [CVA6Cfg.AxiAddrWidth-1:0] addr;
      axi_pkg::len_t                   len;
      axi_pkg::size_t                  size;
      axi_pkg::burst_t                 burst;
      logic                            lock;
      axi_pkg::cache_t                 cache;
      axi_pkg::prot_t                  prot;
      axi_pkg::qos_t                   qos;
      axi_pkg::region_t                region;
      axi_pkg::atop_t                  atop;
      logic [CVA6Cfg.AxiUserWidth-1:0] user;
    },
    parameter type axi_w_chan_t = struct packed {
      logic [CVA6Cfg.AxiDataWidth-1:0]     data;
      logic [(CVA6Cfg.AxiDataWidth/8)-1:0] strb;
      logic                                last;
      logic [CVA6Cfg.AxiUserWidth-1:0]     user;
    },
    parameter type b_chan_t = struct packed {
      logic [CVA6Cfg.AxiIdWidth-1:0]   id;
      axi_pkg::resp_t                  resp;
      logic [CVA6Cfg.AxiUserWidth-1:0] user;
    },
    parameter type r_chan_t = struct packed {
      logic [CVA6Cfg.AxiIdWidth-1:0]   id;
      logic [CVA6Cfg.AxiDataWidth-1:0] data;
      axi_pkg::resp_t                  resp;
      logic                            last;
      logic [CVA6Cfg.AxiUserWidth-1:0] user;
    },
    parameter type noc_req_t = struct packed {
      axi_aw_chan_t aw;
      logic         aw_valid;
      axi_w_chan_t  w;
      logic         w_valid;
      logic         b_ready;
      axi_ar_chan_t ar;
      logic         ar_valid;
      logic         r_ready;
    },
    parameter type noc_resp_t = struct packed {
      logic    aw_ready;
      logic    ar_ready;
      logic    w_ready;
      logic    b_valid;
      b_chan_t b;
      logic    r_valid;
      r_chan_t r;
    },
    //
    parameter type acc_cfg_t = logic,
    parameter acc_cfg_t AccCfg = '0,
    // CVXIF Types
    parameter type readregflags_t = `READREGFLAGS_T(CVA6Cfg),
    parameter type writeregflags_t = `WRITEREGFLAGS_T(CVA6Cfg),
    parameter type id_t = `ID_T(CVA6Cfg),
    parameter type hartid_t = `HARTID_T(CVA6Cfg),
    parameter type x_compressed_req_t = `X_COMPRESSED_REQ_T(CVA6Cfg, hartid_t),
    parameter type x_compressed_resp_t = `X_COMPRESSED_RESP_T(CVA6Cfg),
    parameter type x_issue_req_t = `X_ISSUE_REQ_T(CVA6Cfg, hartit_t, id_t),
    parameter type x_issue_resp_t = `X_ISSUE_RESP_T(CVA6Cfg, writeregflags_t, readregflags_t),
    parameter type x_register_t = `X_REGISTER_T(CVA6Cfg, hartid_t, id_t, readregflags_t),
    parameter type x_commit_t = `X_COMMIT_T(CVA6Cfg, hartid_t, id_t),
    parameter type x_result_t = `X_RESULT_T(CVA6Cfg, hartid_t, id_t, writeregflags_t),
    parameter type cvxif_req_t =
    `CVXIF_REQ_T(CVA6Cfg, x_compressed_req_t, x_issue_req_t, x_register_req_t, x_commit_t),
    parameter type cvxif_resp_t =
    `CVXIF_RESP_T(CVA6Cfg, x_compressed_resp_t, x_issue_resp_t, x_result_t)
) (
    // Subsystem Clock - SUBSYSTEM
    input logic clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input logic rst_ni,
    // Reset boot address - SUBSYSTEM
    input logic [CVA6Cfg.VLEN-1:0] boot_addr_i,
    // Hard ID reflected as CSR - SUBSYSTEM
    input logic [CVA6Cfg.XLEN-1:0] hart_id_i,
    // Level sensitive (async) interrupts - SUBSYSTEM
    input logic [1:0] irq_i,
    // Inter-processor (async) interrupt - SUBSYSTEM
    input logic ipi_i,
    // Timer (async) interrupt - SUBSYSTEM
    input logic time_irq_i,
    // Debug (async) request - SUBSYSTEM
    input logic debug_req_i,
    // Probes to build RVFI, can be left open when not used - RVFI
    output rvfi_probes_t rvfi_probes_o,
    // CVXIF request - SUBSYSTEM
    output cvxif_req_t cvxif_req_o,
    // CVXIF response - SUBSYSTEM
    input cvxif_resp_t cvxif_resp_i,
    // noc request, can be AXI or OpenPiton - SUBSYSTEM
    output noc_req_t noc_req_o,
    // noc response, can be AXI or OpenPiton - SUBSYSTEM
    input noc_resp_t noc_resp_i
);

  localparam type interrupts_t = struct packed {
    logic [CVA6Cfg.XLEN-1:0] S_SW;
    logic [CVA6Cfg.XLEN-1:0] VS_SW;
    logic [CVA6Cfg.XLEN-1:0] M_SW;
    logic [CVA6Cfg.XLEN-1:0] S_TIMER;
    logic [CVA6Cfg.XLEN-1:0] VS_TIMER;
    logic [CVA6Cfg.XLEN-1:0] M_TIMER;
    logic [CVA6Cfg.XLEN-1:0] S_EXT;
    logic [CVA6Cfg.XLEN-1:0] VS_EXT;
    logic [CVA6Cfg.XLEN-1:0] M_EXT;
    logic [CVA6Cfg.XLEN-1:0] HS_EXT;
  };

  localparam interrupts_t INTERRUPTS = '{
      S_SW: (1 << (CVA6Cfg.XLEN - 1)) | CVA6Cfg.XLEN'(riscv::IRQ_S_SOFT),
      VS_SW: (1 << (CVA6Cfg.XLEN - 1)) | CVA6Cfg.XLEN'(riscv::IRQ_VS_SOFT),
      M_SW: (1 << (CVA6Cfg.XLEN - 1)) | CVA6Cfg.XLEN'(riscv::IRQ_M_SOFT),
      S_TIMER: (1 << (CVA6Cfg.XLEN - 1)) | CVA6Cfg.XLEN'(riscv::IRQ_S_TIMER),
      VS_TIMER: (1 << (CVA6Cfg.XLEN - 1)) | CVA6Cfg.XLEN'(riscv::IRQ_VS_TIMER),
      M_TIMER: (1 << (CVA6Cfg.XLEN - 1)) | CVA6Cfg.XLEN'(riscv::IRQ_M_TIMER),
      S_EXT: (1 << (CVA6Cfg.XLEN - 1)) | CVA6Cfg.XLEN'(riscv::IRQ_S_EXT),
      VS_EXT: (1 << (CVA6Cfg.XLEN - 1)) | CVA6Cfg.XLEN'(riscv::IRQ_VS_EXT),
      M_EXT: (1 << (CVA6Cfg.XLEN - 1)) | CVA6Cfg.XLEN'(riscv::IRQ_M_EXT),
      HS_EXT: (1 << (CVA6Cfg.XLEN - 1)) | CVA6Cfg.XLEN'(riscv::IRQ_HS_EXT)
  };

  // ------------------------------------------
  // Global Signals
  // Signals connecting more than one module
  // ------------------------------------------
  riscv::priv_lvl_t                             priv_lvl;
  logic                                         v;
  exception_t                                   ex_commit;  // exception from commit stage
  bp_resolve_t                                  resolved_branch;
  logic             [         CVA6Cfg.VLEN-1:0] pc_commit;
  logic                                         eret;
  logic             [CVA6Cfg.NrCommitPorts-1:0] commit_ack;
  logic             [CVA6Cfg.NrCommitPorts-1:0] commit_macro_ack;

  localparam NumPorts = 4;

  // CVXIF
  cvxif_req_t cvxif_req;
  // CVXIF OUTPUTS
  logic x_compressed_valid;
  x_compressed_req_t x_compressed_req;
  logic x_issue_valid;
  x_issue_req_t x_issue_req;
  logic x_register_valid;
  x_register_t x_register;
  logic x_commit_valid;
  x_commit_t x_commit;
  logic x_result_ready;
  // CVXIF INPUTS
  logic x_compressed_ready;
  x_compressed_resp_t x_compressed_resp;
  logic x_issue_ready;
  x_issue_resp_t x_issue_resp;
  logic x_register_ready;
  logic x_result_valid;
  x_result_t x_result;

  // --------------
  // PCGEN <-> CSR
  // --------------
  logic [CVA6Cfg.VLEN-1:0] trap_vector_base_commit_pcgen;
  logic [CVA6Cfg.VLEN-1:0] epc_commit_pcgen;
  // --------------
  // IF <-> ID
  // --------------
  fetch_entry_t [CVA6Cfg.NrIssuePorts-1:0] fetch_entry_if_id;
  logic [CVA6Cfg.NrIssuePorts-1:0] fetch_valid_if_id;
  logic [CVA6Cfg.NrIssuePorts-1:0] fetch_ready_id_if;

  // --------------
  // ID <-> ISSUE
  // --------------
  scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0] issue_entry_id_issue, issue_entry_id_issue_prev;
  logic [CVA6Cfg.NrIssuePorts-1:0][31:0] orig_instr_id_issue;
  logic [CVA6Cfg.NrIssuePorts-1:0] issue_entry_valid_id_issue;
  logic [CVA6Cfg.NrIssuePorts-1:0] is_ctrl_fow_id_issue;
  logic [CVA6Cfg.NrIssuePorts-1:0] issue_instr_issue_id;

  // --------------
  // ISSUE <-> EX
  // --------------
  logic [CVA6Cfg.NrIssuePorts-1:0][CVA6Cfg.VLEN-1:0] rs1_forwarding_id_ex;  // unregistered version of fu_data_o.operanda
  logic [CVA6Cfg.NrIssuePorts-1:0][CVA6Cfg.VLEN-1:0] rs2_forwarding_id_ex;  // unregistered version of fu_data_o.operandb

  fu_data_t [CVA6Cfg.NrIssuePorts-1:0] fu_data_id_ex;
  logic [CVA6Cfg.VLEN-1:0] pc_id_ex;
  logic is_compressed_instr_id_ex;
  logic [CVA6Cfg.NrIssuePorts-1:0][31:0] tinst_ex;
  // fixed latency units
  logic flu_ready_ex_id;
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] flu_trans_id_ex_id;
  logic flu_valid_ex_id;
  logic [CVA6Cfg.XLEN-1:0] flu_result_ex_id;
  exception_t flu_exception_ex_id;
  // ALU
  logic [CVA6Cfg.NrIssuePorts-1:0] alu_valid_id_ex;
  // Branches and Jumps
  logic [CVA6Cfg.NrIssuePorts-1:0] branch_valid_id_ex;

  branchpredict_sbe_t branch_predict_id_ex;
  logic resolve_branch_ex_id;
  // LSU
  logic [CVA6Cfg.NrIssuePorts-1:0] lsu_valid_id_ex;
  logic lsu_ready_ex_id;

  logic [CVA6Cfg.TRANS_ID_BITS-1:0] load_trans_id_ex_id;
  logic [CVA6Cfg.XLEN-1:0] load_result_ex_id;
  logic load_valid_ex_id;
  exception_t load_exception_ex_id;

  logic [CVA6Cfg.XLEN-1:0] store_result_ex_id;
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] store_trans_id_ex_id;
  logic store_valid_ex_id;
  exception_t store_exception_ex_id;
  // MULT
  logic [CVA6Cfg.NrIssuePorts-1:0] mult_valid_id_ex;
  // FPU
  logic fpu_ready_ex_id;
  logic [CVA6Cfg.NrIssuePorts-1:0] fpu_valid_id_ex;
  logic [1:0] fpu_fmt_id_ex;
  logic [2:0] fpu_rm_id_ex;
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] fpu_trans_id_ex_id;
  logic [CVA6Cfg.XLEN-1:0] fpu_result_ex_id;
  logic fpu_valid_ex_id;
  exception_t fpu_exception_ex_id;
  // ALU2
  logic [CVA6Cfg.NrIssuePorts-1:0] alu2_valid_id_ex;
  // Accelerator
  logic stall_acc_id;
  scoreboard_entry_t issue_instr_id_acc;
  logic issue_instr_hs_id_acc;
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] acc_trans_id_ex_id;
  logic [CVA6Cfg.XLEN-1:0] acc_result_ex_id;
  logic acc_valid_ex_id;
  exception_t acc_exception_ex_id;
  logic halt_acc_ctrl;
  logic [4:0] acc_resp_fflags;
  logic acc_resp_fflags_valid;
  logic single_step_acc_commit;
  // CSR
  logic [CVA6Cfg.NrIssuePorts-1:0] csr_valid_id_ex;
  logic csr_hs_ld_st_inst_ex;
  // CVXIF
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] x_trans_id_ex_id;
  logic [CVA6Cfg.XLEN-1:0] x_result_ex_id;
  logic x_valid_ex_id;
  exception_t x_exception_ex_id;
  logic x_we_ex_id;
  logic [4:0] x_rd_ex_id;
  logic [CVA6Cfg.NrIssuePorts-1:0] x_issue_valid_id_ex;
  logic x_issue_ready_ex_id;
  logic [31:0] x_off_instr_id_ex;
  logic x_transaction_rejected;
  // --------------
  // EX <-> COMMIT
  // --------------
  // CSR Commit
  logic csr_commit_commit_ex;
  logic dirty_fp_state;
  logic dirty_v_state;
  // LSU Commit
  logic lsu_commit_commit_ex;
  logic lsu_commit_ready_ex_commit;
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] lsu_commit_trans_id;
  logic stall_st_pending_ex;
  logic no_st_pending_ex;
  logic no_st_pending_commit;
  logic amo_valid_commit;
  // ACCEL Commit
  logic acc_valid_acc_ex;
  // --------------
  // ID <-> COMMIT
  // --------------
  scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr_id_commit;
  logic [CVA6Cfg.NrCommitPorts-1:0] commit_drop_id_commit;
  logic [CVA6Cfg.NrCommitPorts-1:0] commit_ack_commit_id;

  // --------------
  // RVFI
  // --------------
  logic [CVA6Cfg.NrIssuePorts-1:0][CVA6Cfg.TRANS_ID_BITS-1:0] rvfi_issue_pointer;
  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.TRANS_ID_BITS-1:0] rvfi_commit_pointer;
  // --------------
  // COMMIT <-> ID
  // --------------
  logic [CVA6Cfg.NrCommitPorts-1:0][4:0] waddr_commit_id;
  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.XLEN-1:0] wdata_commit_id;
  logic [CVA6Cfg.NrCommitPorts-1:0] we_gpr_commit_id;
  logic [CVA6Cfg.NrCommitPorts-1:0] we_fpr_commit_id;
  // --------------
  // CSR <-> *
  // --------------
  logic [4:0] fflags_csr_commit;
  riscv::xs_t fs;
  riscv::xs_t vfs;
  logic [2:0] frm_csr_id_issue_ex;
  logic [6:0] fprec_csr_ex;
  riscv::xs_t vs;
  logic enable_translation_csr_ex;
  logic enable_g_translation_csr_ex;
  logic en_ld_st_translation_csr_ex;
  logic en_ld_st_g_translation_csr_ex;
  riscv::priv_lvl_t ld_st_priv_lvl_csr_ex;
  logic ld_st_v_csr_ex;
  logic sum_csr_ex;
  logic vs_sum_csr_ex;
  logic mxr_csr_ex;
  logic vmxr_csr_ex;
  logic [CVA6Cfg.PPNW-1:0] satp_ppn_csr_ex;
  logic [CVA6Cfg.ASID_WIDTH-1:0] asid_csr_ex;
  logic [CVA6Cfg.PPNW-1:0] vsatp_ppn_csr_ex;
  logic [CVA6Cfg.ASID_WIDTH-1:0] vs_asid_csr_ex;
  logic [CVA6Cfg.PPNW-1:0] hgatp_ppn_csr_ex;
  logic [CVA6Cfg.VMID_WIDTH-1:0] vmid_csr_ex;
  logic [11:0] csr_addr_ex_csr;
  fu_op csr_op_commit_csr;
  logic [CVA6Cfg.XLEN-1:0] csr_wdata_commit_csr;
  logic [CVA6Cfg.XLEN-1:0] csr_rdata_csr_commit;
  exception_t csr_exception_csr_commit;
  logic tvm_csr_id;
  logic tw_csr_id;
  logic vtw_csr_id;
  logic tsr_csr_id;
  logic hu;
  irq_ctrl_t irq_ctrl_csr_id;
  logic dcache_en_csr_nbdcache;
  logic csr_write_fflags_commit_cs;
  logic icache_en_csr;
  logic acc_cons_en_csr;
  logic debug_mode;
  logic single_step_csr_commit;
  riscv::pmpcfg_t [(CVA6Cfg.NrPMPEntries > 0 ? CVA6Cfg.NrPMPEntries-1 : 0):0] pmpcfg;
  logic [(CVA6Cfg.NrPMPEntries > 0 ? CVA6Cfg.NrPMPEntries-1 : 0):0][CVA6Cfg.PLEN-3:0] pmpaddr;
  logic [31:0] mcountinhibit_csr_perf;
  // ----------------------------
  // Performance Counters <-> *
  // ----------------------------
  logic [11:0] addr_csr_perf;
  logic [CVA6Cfg.XLEN-1:0] data_csr_perf, data_perf_csr;
  logic we_csr_perf;

  logic icache_flush_ctrl_cache;
  logic itlb_miss_ex_perf;
  logic dtlb_miss_ex_perf;
  logic dcache_miss_cache_perf;
  logic icache_miss_cache_perf;
  logic [NumPorts-1:0][CVA6Cfg.DCACHE_SET_ASSOC-1:0] miss_vld_bits;
  logic stall_issue;
  // --------------
  // CTRL <-> *
  // --------------
  logic set_pc_ctrl_pcgen;
  logic flush_csr_ctrl;
  logic flush_unissued_instr_ctrl_id;
  logic flush_ctrl_if;
  logic flush_ctrl_id;
  logic flush_ctrl_ex;
  logic flush_ctrl_bp;
  logic flush_tlb_ctrl_ex;
  logic flush_tlb_vvma_ctrl_ex;
  logic flush_tlb_gvma_ctrl_ex;
  logic fence_i_commit_controller;
  logic fence_commit_controller;
  logic sfence_vma_commit_controller;
  logic hfence_vvma_commit_controller;
  logic hfence_gvma_commit_controller;
  logic halt_ctrl;
  logic halt_csr_ctrl;
  logic dcache_flush_ctrl_cache;
  logic dcache_flush_ack_cache_ctrl;
  logic set_debug_pc;
  logic flush_commit;
  logic flush_acc;

  icache_areq_t icache_areq_ex_cache;
  icache_arsp_t icache_areq_cache_ex;
  icache_dreq_t icache_dreq_if_cache;
  icache_drsp_t icache_dreq_cache_if;

  amo_req_t amo_req;
  amo_resp_t amo_resp;
  logic sb_full;

  // ----------------
  // DCache <-> *
  // ----------------
  dcache_req_i_t [2:0] dcache_req_ports_ex_cache;
  dcache_req_o_t [2:0] dcache_req_ports_cache_ex;
  dcache_req_i_t [1:0] dcache_req_ports_acc_cache;
  dcache_req_o_t [1:0] dcache_req_ports_cache_acc;
  logic dcache_commit_wbuffer_empty;
  logic dcache_commit_wbuffer_not_ni;

  //RVFI
  lsu_ctrl_t rvfi_lsu_ctrl;
  logic [CVA6Cfg.PLEN-1:0] rvfi_mem_paddr;
  logic [CVA6Cfg.NrIssuePorts-1:0] rvfi_is_compressed;
  rvfi_probes_csr_t rvfi_csr;

  // Accelerator port
  logic [63:0] inval_addr;
  logic inval_valid;
  logic inval_ready;

  // --------------
  // Frontend
  // --------------
  frontend #(
      .CVA6Cfg(CVA6Cfg),
      .bp_resolve_t(bp_resolve_t),
      .fetch_entry_t(fetch_entry_t),
      .icache_dreq_t(icache_dreq_t),
      .icache_drsp_t(icache_drsp_t)
  ) i_frontend (
      .clk_i,
      .rst_ni,
      .boot_addr_i        (boot_addr_i[CVA6Cfg.VLEN-1:0]),
      .flush_bp_i         (1'b0),
      .flush_i            (flush_ctrl_if),                  // not entirely correct
      .halt_i             (halt_ctrl),
      .set_pc_commit_i    (set_pc_ctrl_pcgen),
      .pc_commit_i        (pc_commit),
      .ex_valid_i         (ex_commit.valid),
      .resolved_branch_i  (resolved_branch),
      .eret_i             (eret),
      .epc_i              (epc_commit_pcgen),
      .trap_vector_base_i (trap_vector_base_commit_pcgen),
      .set_debug_pc_i     (set_debug_pc),
      .debug_mode_i       (debug_mode),
      .icache_dreq_o      (icache_dreq_if_cache),
      .icache_dreq_i      (icache_dreq_cache_if),
      .fetch_entry_o      (fetch_entry_if_id),
      .fetch_entry_valid_o(fetch_valid_if_id),
      .fetch_entry_ready_i(fetch_ready_id_if)
  );

  // ---------
  // ID
  // ---------
  id_stage #(
      .CVA6Cfg(CVA6Cfg),
      .branchpredict_sbe_t(branchpredict_sbe_t),
      .exception_t(exception_t),
      .fetch_entry_t(fetch_entry_t),
      .irq_ctrl_t(irq_ctrl_t),
      .scoreboard_entry_t(scoreboard_entry_t),
      .interrupts_t(interrupts_t),
      .INTERRUPTS(INTERRUPTS),
      .x_compressed_req_t(x_compressed_req_t),
      .x_compressed_resp_t(x_compressed_resp_t)
  ) id_stage_i (
      .clk_i,
      .rst_ni,
      .flush_i(flush_ctrl_if),
      .debug_req_i,

      .fetch_entry_i      (fetch_entry_if_id),
      .fetch_entry_valid_i(fetch_valid_if_id),
      .fetch_entry_ready_o(fetch_ready_id_if),

      .issue_entry_o      (issue_entry_id_issue),
      .issue_entry_o_prev (issue_entry_id_issue_prev),
      .orig_instr_o       (orig_instr_id_issue),
      .issue_entry_valid_o(issue_entry_valid_id_issue),
      .is_ctrl_flow_o     (is_ctrl_fow_id_issue),
      .issue_instr_ack_i  (issue_instr_issue_id),

      .rvfi_is_compressed_o(rvfi_is_compressed),

      .priv_lvl_i        (priv_lvl),
      .v_i               (v),
      .fs_i              (fs),
      .vfs_i             (vfs),
      .frm_i             (frm_csr_id_issue_ex),
      .vs_i              (vs),
      .irq_i             (irq_i),
      .irq_ctrl_i        (irq_ctrl_csr_id),
      .debug_mode_i      (debug_mode),
      .tvm_i             (tvm_csr_id),
      .tw_i              (tw_csr_id),
      .vtw_i             (vtw_csr_id),
      .tsr_i             (tsr_csr_id),
      .hu_i              (hu),
      .hart_id_i         (hart_id_i),
      .compressed_ready_i(x_compressed_ready),
      .compressed_resp_i (x_compressed_resp),
      .compressed_valid_o(x_compressed_valid),
      .compressed_req_o  (x_compressed_req)
  );

  logic [CVA6Cfg.NrWbPorts-1:0][CVA6Cfg.TRANS_ID_BITS-1:0] trans_id_ex_id;
  logic [CVA6Cfg.NrWbPorts-1:0][CVA6Cfg.XLEN-1:0] wbdata_ex_id;
  exception_t [CVA6Cfg.NrWbPorts-1:0] ex_ex_ex_id;  // exception from execute, ex_stage to id_stage
  logic [CVA6Cfg.NrWbPorts-1:0] wt_valid_ex_id;

  assign trans_id_ex_id[FLU_WB] = flu_trans_id_ex_id;
  assign wbdata_ex_id[FLU_WB]   = flu_result_ex_id;
  assign ex_ex_ex_id[FLU_WB]    = flu_exception_ex_id;
  assign wt_valid_ex_id[FLU_WB] = flu_valid_ex_id;

  assign trans_id_ex_id[STORE_WB] = store_trans_id_ex_id;
  assign wbdata_ex_id[STORE_WB]   = store_result_ex_id;
  assign ex_ex_ex_id[STORE_WB]    = store_exception_ex_id;
  assign wt_valid_ex_id[STORE_WB] = store_valid_ex_id;

  assign trans_id_ex_id[LOAD_WB] = load_trans_id_ex_id;
  assign wbdata_ex_id[LOAD_WB]   = load_result_ex_id;
  assign ex_ex_ex_id[LOAD_WB]    = load_exception_ex_id;
  assign wt_valid_ex_id[LOAD_WB] = load_valid_ex_id;

  assign trans_id_ex_id[FPU_WB] = fpu_trans_id_ex_id;
  assign wbdata_ex_id[FPU_WB]   = fpu_result_ex_id;
  assign ex_ex_ex_id[FPU_WB]    = fpu_exception_ex_id;
  assign wt_valid_ex_id[FPU_WB] = fpu_valid_ex_id;

  always_comb begin : gen_cvxif_input_assignement
    x_compressed_ready = cvxif_resp_i.compressed_ready;
    x_compressed_resp  = cvxif_resp_i.compressed_resp;
    x_issue_ready      = cvxif_resp_i.issue_ready;
    x_issue_resp       = cvxif_resp_i.issue_resp;
    x_register_ready   = cvxif_resp_i.register_ready;
    x_result_valid     = cvxif_resp_i.result_valid;
    x_result           = cvxif_resp_i.result;
  end
  if (CVA6Cfg.CvxifEn) begin
    always_comb begin : gen_cvxif_output_assignement
      cvxif_req.compressed_valid = x_compressed_valid;
      cvxif_req.compressed_req   = x_compressed_req;
      cvxif_req.issue_valid      = x_issue_valid;
      cvxif_req.issue_req        = x_issue_req;
      cvxif_req.register_valid   = x_register_valid;
      cvxif_req.register         = x_register;
      cvxif_req.commit_valid     = x_commit_valid;
      cvxif_req.commit           = x_commit;
      cvxif_req.result_ready     = x_result_ready;
    end
    assign trans_id_ex_id[X_WB] = x_trans_id_ex_id;
    assign wbdata_ex_id[X_WB]   = x_result_ex_id;
    assign ex_ex_ex_id[X_WB]    = x_exception_ex_id;
    assign wt_valid_ex_id[X_WB] = x_valid_ex_id;
  end else if (CVA6Cfg.EnableAccelerator) begin
    assign cvxif_req = '0;
    assign trans_id_ex_id[ACC_WB] = acc_trans_id_ex_id;
    assign wbdata_ex_id[ACC_WB]   = acc_result_ex_id;
    assign ex_ex_ex_id[ACC_WB]    = acc_exception_ex_id;
    assign wt_valid_ex_id[ACC_WB] = acc_valid_ex_id;
  end else begin
    assign cvxif_req = '0;
  end

  if (CVA6Cfg.CvxifEn && CVA6Cfg.EnableAccelerator) begin : gen_err_xif_and_acc
    $error("X-interface and accelerator port cannot be enabled at the same time.");
  end

  // ---------
  // Issue
  // ---------
  issue_stage #(
      .CVA6Cfg(CVA6Cfg),
      .bp_resolve_t(bp_resolve_t),
      .branchpredict_sbe_t(branchpredict_sbe_t),
      .exception_t(exception_t),
      .fu_data_t(fu_data_t),
      .scoreboard_entry_t(scoreboard_entry_t),
      .writeback_t(writeback_t),
      .x_issue_req_t(x_issue_req_t),
      .x_issue_resp_t(x_issue_resp_t),
      .x_register_t(x_register_t),
      .x_commit_t(x_commit_t)
  ) issue_stage_i (
      .clk_i,
      .rst_ni,
      .sb_full_o               (sb_full),
      .flush_unissued_instr_i  (flush_unissued_instr_ctrl_id),
      .flush_i                 (flush_ctrl_id),
      .stall_i                 (stall_acc_id),
      // ID Stage
      .decoded_instr_i         (issue_entry_id_issue),
      .decoded_instr_i_prev    (issue_entry_id_issue_prev),
      .orig_instr_i            (orig_instr_id_issue),
      .decoded_instr_valid_i   (issue_entry_valid_id_issue),
      .is_ctrl_flow_i          (is_ctrl_fow_id_issue),
      .decoded_instr_ack_o     (issue_instr_issue_id),
      // Functional Units
      .rs1_forwarding_o        (rs1_forwarding_id_ex),
      .rs2_forwarding_o        (rs2_forwarding_id_ex),
      .fu_data_o               (fu_data_id_ex),
      .pc_o                    (pc_id_ex),
      .is_compressed_instr_o   (is_compressed_instr_id_ex),
      .tinst_o                 (tinst_ex),
      // fixed latency unit ready
      .flu_ready_i             (flu_ready_ex_id),
      // ALU
      .alu_valid_o             (alu_valid_id_ex),
      // Branches and Jumps
      .branch_valid_o          (branch_valid_id_ex),            // branch is valid
      .branch_predict_o        (branch_predict_id_ex),          // branch predict to ex
      .resolve_branch_i        (resolve_branch_ex_id),          // in order to resolve the branch
      // LSU
      .lsu_ready_i             (lsu_ready_ex_id),
      .lsu_valid_o             (lsu_valid_id_ex),
      // Multiplier
      .mult_valid_o            (mult_valid_id_ex),
      // FPU
      .fpu_ready_i             (fpu_ready_ex_id),
      .fpu_valid_o             (fpu_valid_id_ex),
      .fpu_fmt_o               (fpu_fmt_id_ex),
      .fpu_rm_o                (fpu_rm_id_ex),
      // ALU2
      .alu2_valid_o            (alu2_valid_id_ex),
      // CSR
      .csr_valid_o             (csr_valid_id_ex),
      // CVXIF
      .xfu_valid_o             (x_issue_valid_id_ex),
      .xfu_ready_i             (x_issue_ready_ex_id),
      .x_off_instr_o           (x_off_instr_id_ex),
      .hart_id_i               (hart_id_i),
      .x_issue_ready_i         (x_issue_ready),
      .x_issue_resp_i          (x_issue_resp),
      .x_issue_valid_o         (x_issue_valid),
      .x_issue_req_o           (x_issue_req),
      .x_register_ready_i      (x_register_ready),
      .x_register_valid_o      (x_register_valid),
      .x_register_o            (x_register),
      .x_commit_valid_o        (x_commit_valid),
      .x_commit_o              (x_commit),
      .x_transaction_rejected_o(x_transaction_rejected),
      // Accelerator
      .issue_instr_o           (issue_instr_id_acc),
      .issue_instr_hs_o        (issue_instr_hs_id_acc),
      // Commit
      .trans_id_i              (trans_id_ex_id),
      .resolved_branch_i       (resolved_branch),
      .wbdata_i                (wbdata_ex_id),
      .ex_ex_i                 (ex_ex_ex_id),
      .wt_valid_i              (wt_valid_ex_id),
      .x_we_i                  (x_we_ex_id),
      .x_rd_i                  (x_rd_ex_id),

      .waddr_i              (waddr_commit_id),
      .wdata_i              (wdata_commit_id),
      .we_gpr_i             (we_gpr_commit_id),
      .we_fpr_i             (we_fpr_commit_id),
      .commit_instr_o       (commit_instr_id_commit),
      .commit_drop_o        (commit_drop_id_commit),
      .commit_ack_i         (commit_ack_commit_id),
      // Performance Counters
      .stall_issue_o        (stall_issue),
      //RVFI
      .rvfi_issue_pointer_o (rvfi_issue_pointer),
      .rvfi_commit_pointer_o(rvfi_commit_pointer)
  );

  // ---------
  // EX
  // ---------
  ex_stage #(
      .CVA6Cfg   (CVA6Cfg),
      .bp_resolve_t(bp_resolve_t),
      .branchpredict_sbe_t(branchpredict_sbe_t),
      .dcache_req_i_t(dcache_req_i_t),
      .dcache_req_o_t(dcache_req_o_t),
      .exception_t(exception_t),
      .fu_data_t(fu_data_t),
      .icache_areq_t(icache_areq_t),
      .icache_arsp_t(icache_arsp_t),
      .icache_dreq_t(icache_dreq_t),
      .icache_drsp_t(icache_drsp_t),
      .lsu_ctrl_t(lsu_ctrl_t),
      .x_result_t(x_result_t)
  ) ex_stage_i (
      .clk_i(clk_i),
      .rst_ni(rst_ni),
      .debug_mode_i(debug_mode),
      .flush_i(flush_ctrl_ex),
      .rs1_forwarding_i(rs1_forwarding_id_ex),
      .rs2_forwarding_i(rs2_forwarding_id_ex),
      .fu_data_i(fu_data_id_ex),
      .pc_i(pc_id_ex),
      .is_compressed_instr_i(is_compressed_instr_id_ex),
      .tinst_i(tinst_ex),
      // fixed latency units
      .flu_result_o(flu_result_ex_id),
      .flu_trans_id_o(flu_trans_id_ex_id),
      .flu_valid_o(flu_valid_ex_id),
      .flu_exception_o(flu_exception_ex_id),
      .flu_ready_o(flu_ready_ex_id),
      // ALU
      .alu_valid_i(alu_valid_id_ex),
      // Branches and Jumps
      .branch_valid_i(branch_valid_id_ex),
      .branch_predict_i(branch_predict_id_ex),  // branch predict to ex
      .resolved_branch_o(resolved_branch),
      .resolve_branch_o(resolve_branch_ex_id),
      // CSR
      .csr_valid_i(csr_valid_id_ex),
      .csr_addr_o(csr_addr_ex_csr),
      .csr_commit_i(csr_commit_commit_ex),  // from commit
      .csr_hs_ld_st_inst_o(csr_hs_ld_st_inst_ex),  // signals a Hypervisor Load/Store Instruction
      // MULT
      .mult_valid_i(mult_valid_id_ex),
      // LSU
      .lsu_ready_o(lsu_ready_ex_id),
      .lsu_valid_i(lsu_valid_id_ex),

      .load_result_o   (load_result_ex_id),
      .load_trans_id_o (load_trans_id_ex_id),
      .load_valid_o    (load_valid_ex_id),
      .load_exception_o(load_exception_ex_id),

      .store_result_o   (store_result_ex_id),
      .store_trans_id_o (store_trans_id_ex_id),
      .store_valid_o    (store_valid_ex_id),
      .store_exception_o(store_exception_ex_id),

      .lsu_commit_i            (lsu_commit_commit_ex),           // from commit
      .lsu_commit_ready_o      (lsu_commit_ready_ex_commit),     // to commit
      .commit_tran_id_i        (lsu_commit_trans_id),            // from commit
      .stall_st_pending_i      (stall_st_pending_ex),
      .no_st_pending_o         (no_st_pending_ex),
      // FPU
      .fpu_ready_o             (fpu_ready_ex_id),
      .fpu_valid_i             (fpu_valid_id_ex),
      .fpu_fmt_i               (fpu_fmt_id_ex),
      .fpu_rm_i                (fpu_rm_id_ex),
      .fpu_frm_i               (frm_csr_id_issue_ex),
      .fpu_prec_i              (fprec_csr_ex),
      .fpu_trans_id_o          (fpu_trans_id_ex_id),
      .fpu_result_o            (fpu_result_ex_id),
      .fpu_valid_o             (fpu_valid_ex_id),
      .fpu_exception_o         (fpu_exception_ex_id),
      // ALU2
      .alu2_valid_i            (alu2_valid_id_ex),
      .amo_valid_commit_i      (amo_valid_commit),
      .amo_req_o               (amo_req),
      .amo_resp_i              (amo_resp),
      // CoreV-X-Interface
      .x_valid_i               (x_issue_valid_id_ex),
      .x_ready_o               (x_issue_ready_ex_id),
      .x_off_instr_i           (x_off_instr_id_ex),
      .x_transaction_rejected_i(x_transaction_rejected),
      .x_trans_id_o            (x_trans_id_ex_id),
      .x_exception_o           (x_exception_ex_id),
      .x_result_o              (x_result_ex_id),
      .x_valid_o               (x_valid_ex_id),
      .x_we_o                  (x_we_ex_id),
      .x_rd_o                  (x_rd_ex_id),
      .x_result_valid_i        (x_result_valid),
      .x_result_i              (x_result),
      .x_result_ready_o        (x_result_ready),
      // Accelerator
      .acc_valid_i             (acc_valid_acc_ex),
      // Performance counters
      .itlb_miss_o             (itlb_miss_ex_perf),
      .dtlb_miss_o             (dtlb_miss_ex_perf),
      // Memory Management
      .enable_translation_i    (enable_translation_csr_ex),      // from CSR
      .enable_g_translation_i  (enable_g_translation_csr_ex),    // from CSR
      .en_ld_st_translation_i  (en_ld_st_translation_csr_ex),
      .en_ld_st_g_translation_i(en_ld_st_g_translation_csr_ex),
      .flush_tlb_i             (flush_tlb_ctrl_ex),
      .flush_tlb_vvma_i        (flush_tlb_vvma_ctrl_ex),
      .flush_tlb_gvma_i        (flush_tlb_gvma_ctrl_ex),
      .priv_lvl_i              (priv_lvl),                       // from CSR
      .v_i                     (v),                              // from CSR
      .ld_st_priv_lvl_i        (ld_st_priv_lvl_csr_ex),          // from CSR
      .ld_st_v_i               (ld_st_v_csr_ex),                 // from CSR
      .sum_i                   (sum_csr_ex),                     // from CSR
      .vs_sum_i                (vs_sum_csr_ex),                  // from CSR
      .mxr_i                   (mxr_csr_ex),                     // from CSR
      .vmxr_i                  (vmxr_csr_ex),                    // from CSR
      .satp_ppn_i              (satp_ppn_csr_ex),                // from CSR
      .asid_i                  (asid_csr_ex),                    // from CSR
      .vsatp_ppn_i             (vsatp_ppn_csr_ex),               // from CSR
      .vs_asid_i               (vs_asid_csr_ex),                 // from CSR
      .hgatp_ppn_i             (hgatp_ppn_csr_ex),               // from CSR
      .vmid_i                  (vmid_csr_ex),                    // from CSR
      .icache_areq_i           (icache_areq_cache_ex),
      .icache_areq_o           (icache_areq_ex_cache),
      // DCACHE interfaces
      .dcache_req_ports_i      (dcache_req_ports_cache_ex),
      .dcache_req_ports_o      (dcache_req_ports_ex_cache),
      .dcache_wbuffer_empty_i  (dcache_commit_wbuffer_empty),
      .dcache_wbuffer_not_ni_i (dcache_commit_wbuffer_not_ni),
      // PMP
      .pmpcfg_i                (pmpcfg),
      .pmpaddr_i               (pmpaddr),
      //RVFI
      .rvfi_lsu_ctrl_o         (rvfi_lsu_ctrl),
      .rvfi_mem_paddr_o        (rvfi_mem_paddr)
  );

  // ---------
  // Commit
  // ---------

  // we have to make sure that the whole write buffer path is empty before
  // used e.g. for fence instructions.
  assign no_st_pending_commit = no_st_pending_ex & dcache_commit_wbuffer_empty;

  commit_stage #(
      .CVA6Cfg(CVA6Cfg),
      .exception_t(exception_t),
      .scoreboard_entry_t(scoreboard_entry_t)
  ) commit_stage_i (
      .clk_i,
      .rst_ni,
      .halt_i            (halt_ctrl),
      .flush_dcache_i    (dcache_flush_ctrl_cache),
      .exception_o       (ex_commit),
      .dirty_fp_state_o  (dirty_fp_state),
      .single_step_i     (single_step_csr_commit || single_step_acc_commit),
      .commit_instr_i    (commit_instr_id_commit),
      .commit_drop_i     (commit_drop_id_commit),
      .commit_ack_o      (commit_ack_commit_id),
      .commit_macro_ack_o(commit_macro_ack),
      .waddr_o           (waddr_commit_id),
      .wdata_o           (wdata_commit_id),
      .we_gpr_o          (we_gpr_commit_id),
      .we_fpr_o          (we_fpr_commit_id),
      .amo_resp_i        (amo_resp),
      .pc_o              (pc_commit),
      .csr_op_o          (csr_op_commit_csr),
      .csr_wdata_o       (csr_wdata_commit_csr),
      .csr_rdata_i       (csr_rdata_csr_commit),
      .csr_write_fflags_o(csr_write_fflags_commit_cs),
      .csr_exception_i   (csr_exception_csr_commit),
      .commit_lsu_o      (lsu_commit_commit_ex),
      .commit_lsu_ready_i(lsu_commit_ready_ex_commit),
      .commit_tran_id_o  (lsu_commit_trans_id),
      .amo_valid_commit_o(amo_valid_commit),
      .no_st_pending_i   (no_st_pending_commit),
      .commit_csr_o      (csr_commit_commit_ex),
      .fence_i_o         (fence_i_commit_controller),
      .fence_o           (fence_commit_controller),
      .flush_commit_o    (flush_commit),
      .sfence_vma_o      (sfence_vma_commit_controller),
      .hfence_vvma_o     (hfence_vvma_commit_controller),
      .hfence_gvma_o     (hfence_gvma_commit_controller)
  );

  assign commit_ack = commit_macro_ack & ~commit_drop_id_commit;

  // ---------
  // CSR
  // ---------
  csr_regfile #(
      .CVA6Cfg           (CVA6Cfg),
      .exception_t       (exception_t),
      .irq_ctrl_t        (irq_ctrl_t),
      .scoreboard_entry_t(scoreboard_entry_t),
      .rvfi_probes_csr_t (rvfi_probes_csr_t),
      .MHPMCounterNum    (MHPMCounterNum)
  ) csr_regfile_i (
      .clk_i,
      .rst_ni,
      .time_irq_i,
      .flush_o                 (flush_csr_ctrl),
      .halt_csr_o              (halt_csr_ctrl),
      .commit_instr_i          (commit_instr_id_commit[0]),
      .commit_ack_i            (commit_ack),
      .boot_addr_i             (boot_addr_i[CVA6Cfg.VLEN-1:0]),
      .hart_id_i               (hart_id_i[CVA6Cfg.XLEN-1:0]),
      .ex_i                    (ex_commit),
      .csr_op_i                (csr_op_commit_csr),
      .csr_addr_i              (csr_addr_ex_csr),
      .csr_wdata_i             (csr_wdata_commit_csr),
      .csr_rdata_o             (csr_rdata_csr_commit),
      .dirty_fp_state_i        (dirty_fp_state),
      .csr_write_fflags_i      (csr_write_fflags_commit_cs),
      .dirty_v_state_i         (dirty_v_state),
      .pc_i                    (pc_commit),
      .csr_exception_o         (csr_exception_csr_commit),
      .epc_o                   (epc_commit_pcgen),
      .eret_o                  (eret),
      .trap_vector_base_o      (trap_vector_base_commit_pcgen),
      .priv_lvl_o              (priv_lvl),
      .v_o                     (v),
      .acc_fflags_ex_i         (acc_resp_fflags),
      .acc_fflags_ex_valid_i   (acc_resp_fflags_valid),
      .fs_o                    (fs),
      .vfs_o                   (vfs),
      .fflags_o                (fflags_csr_commit),
      .frm_o                   (frm_csr_id_issue_ex),
      .fprec_o                 (fprec_csr_ex),
      .vs_o                    (vs),
      .irq_ctrl_o              (irq_ctrl_csr_id),
      .en_translation_o        (enable_translation_csr_ex),
      .en_g_translation_o      (enable_g_translation_csr_ex),
      .en_ld_st_translation_o  (en_ld_st_translation_csr_ex),
      .en_ld_st_g_translation_o(en_ld_st_g_translation_csr_ex),
      .ld_st_priv_lvl_o        (ld_st_priv_lvl_csr_ex),
      .ld_st_v_o               (ld_st_v_csr_ex),
      .csr_hs_ld_st_inst_i     (csr_hs_ld_st_inst_ex),
      .sum_o                   (sum_csr_ex),
      .vs_sum_o                (vs_sum_csr_ex),
      .mxr_o                   (mxr_csr_ex),
      .vmxr_o                  (vmxr_csr_ex),
      .satp_ppn_o              (satp_ppn_csr_ex),
      .asid_o                  (asid_csr_ex),
      .vsatp_ppn_o             (vsatp_ppn_csr_ex),
      .vs_asid_o               (vs_asid_csr_ex),
      .hgatp_ppn_o             (hgatp_ppn_csr_ex),
      .vmid_o                  (vmid_csr_ex),
      .irq_i,
      .ipi_i,
      .debug_req_i,
      .set_debug_pc_o          (set_debug_pc),
      .tvm_o                   (tvm_csr_id),
      .tw_o                    (tw_csr_id),
      .vtw_o                   (vtw_csr_id),
      .tsr_o                   (tsr_csr_id),
      .hu_o                    (hu),
      .debug_mode_o            (debug_mode),
      .single_step_o           (single_step_csr_commit),
      .icache_en_o             (icache_en_csr),
      .dcache_en_o             (dcache_en_csr_nbdcache),
      .acc_cons_en_o           (acc_cons_en_csr),
      .perf_addr_o             (addr_csr_perf),
      .perf_data_o             (data_csr_perf),
      .perf_data_i             (data_perf_csr),
      .perf_we_o               (we_csr_perf),
      .pmpcfg_o                (pmpcfg),
      .pmpaddr_o               (pmpaddr),
      .mcountinhibit_o         (mcountinhibit_csr_perf),
      //RVFI
      .rvfi_csr_o              (rvfi_csr)
  );

  // ------------------------
  // Performance Counters
  // ------------------------
  if (CVA6Cfg.PerfCounterEn) begin : gen_perf_counter
    perf_counters #(
        .CVA6Cfg(CVA6Cfg),
        .bp_resolve_t(bp_resolve_t),
        .exception_t(exception_t),
        .scoreboard_entry_t(scoreboard_entry_t),
        .icache_dreq_t(icache_dreq_t),
        .dcache_req_i_t(dcache_req_i_t),
        .dcache_req_o_t(dcache_req_o_t),
        .NumPorts(NumPorts)
    ) perf_counters_i (
        .clk_i         (clk_i),
        .rst_ni        (rst_ni),
        .debug_mode_i  (debug_mode),
        .addr_i        (addr_csr_perf),
        .we_i          (we_csr_perf),
        .data_i        (data_csr_perf),
        .data_o        (data_perf_csr),
        .commit_instr_i(commit_instr_id_commit),
        .commit_ack_i  (commit_ack),

        .l1_icache_miss_i   (icache_miss_cache_perf),
        .l1_dcache_miss_i   (dcache_miss_cache_perf),
        .itlb_miss_i        (itlb_miss_ex_perf),
        .dtlb_miss_i        (dtlb_miss_ex_perf),
        .sb_full_i          (sb_full),
        // TODO this is more complex that that
        // If superscalar then we additionally have to check [1] when transaction 0 succeeded
        .if_empty_i         (~fetch_valid_if_id[0]),
        .ex_i               (ex_commit),
        .eret_i             (eret),
        .resolved_branch_i  (resolved_branch),
        .branch_exceptions_i(flu_exception_ex_id),
        .l1_icache_access_i (icache_dreq_if_cache),
        .l1_dcache_access_i (dcache_req_ports_ex_cache),
        .miss_vld_bits_i    (miss_vld_bits),
        .i_tlb_flush_i      (flush_tlb_ctrl_ex),
        .stall_issue_i      (stall_issue),
        .mcountinhibit_i    (mcountinhibit_csr_perf)
    );
  end : gen_perf_counter
  else begin : gen_no_perf_counter
    assign data_perf_csr = '0;
  end : gen_no_perf_counter

  // ------------
  // Controller
  // ------------
  controller #(
      .CVA6Cfg(CVA6Cfg),
      .bp_resolve_t(bp_resolve_t)
  ) controller_i (
      .clk_i,
      .rst_ni,
      // virtualization mode
      .v_i                   (v),
      // flush ports
      .set_pc_commit_o       (set_pc_ctrl_pcgen),
      .flush_if_o            (flush_ctrl_if),
      .flush_unissued_instr_o(flush_unissued_instr_ctrl_id),
      .flush_id_o            (flush_ctrl_id),
      .flush_ex_o            (flush_ctrl_ex),
      .flush_bp_o            (flush_ctrl_bp),
      .flush_icache_o        (icache_flush_ctrl_cache),
      .flush_dcache_o        (dcache_flush_ctrl_cache),
      .flush_dcache_ack_i    (dcache_flush_ack_cache_ctrl),
      .flush_tlb_o           (flush_tlb_ctrl_ex),
      .flush_tlb_vvma_o      (flush_tlb_vvma_ctrl_ex),
      .flush_tlb_gvma_o      (flush_tlb_gvma_ctrl_ex),
      .halt_csr_i            (halt_csr_ctrl),
      .halt_acc_i            (halt_acc_ctrl),
      .halt_o                (halt_ctrl),
      // control ports
      .eret_i                (eret),
      .ex_valid_i            (ex_commit.valid),
      .set_debug_pc_i        (set_debug_pc),
      .resolved_branch_i     (resolved_branch),
      .flush_csr_i           (flush_csr_ctrl),
      .fence_i_i             (fence_i_commit_controller),
      .fence_i               (fence_commit_controller),
      .sfence_vma_i          (sfence_vma_commit_controller),
      .hfence_vvma_i         (hfence_vvma_commit_controller),
      .hfence_gvma_i         (hfence_gvma_commit_controller),
      .flush_commit_i        (flush_commit),
      .flush_acc_i           (flush_acc)
  );

  // -------------------
  // Cache Subsystem
  // -------------------

  // Acc dispatcher and store buffer share a dcache request port.
  // Store buffer always has priority access over acc dipsatcher.
  dcache_req_i_t [NumPorts-1:0] dcache_req_to_cache;
  dcache_req_o_t [NumPorts-1:0] dcache_req_from_cache;

  // D$ request
  assign dcache_req_to_cache[0] = dcache_req_ports_ex_cache[0];
  assign dcache_req_to_cache[1] = dcache_req_ports_ex_cache[1];
  assign dcache_req_to_cache[2] = dcache_req_ports_acc_cache[0];
  assign dcache_req_to_cache[3] = dcache_req_ports_ex_cache[2].data_req ? dcache_req_ports_ex_cache [2] :
                                                                          dcache_req_ports_acc_cache[1];

  // D$ response
  assign dcache_req_ports_cache_ex[0] = dcache_req_from_cache[0];
  assign dcache_req_ports_cache_ex[1] = dcache_req_from_cache[1];
  assign dcache_req_ports_cache_acc[0] = dcache_req_from_cache[2];
  always_comb begin : gen_dcache_req_store_data_gnt
    dcache_req_ports_cache_ex[2]  = dcache_req_from_cache[3];
    dcache_req_ports_cache_acc[1] = dcache_req_from_cache[3];

    // Set gnt signal
    dcache_req_ports_cache_ex[2].data_gnt &= dcache_req_ports_ex_cache[2].data_req;
    dcache_req_ports_cache_acc[1].data_gnt &= !dcache_req_ports_ex_cache[2].data_req;
  end

  if (CVA6Cfg.DCacheType == config_pkg::WT) begin : gen_cache_wt
    // this is a cache subsystem that is compatible with OpenPiton
    wt_cache_subsystem #(
        .CVA6Cfg   (CVA6Cfg),
        .icache_areq_t(icache_areq_t),
        .icache_arsp_t(icache_arsp_t),
        .icache_dreq_t(icache_dreq_t),
        .icache_drsp_t(icache_drsp_t),
        .icache_req_t(icache_req_t),
        .icache_rtrn_t(icache_rtrn_t),
        .dcache_req_i_t(dcache_req_i_t),
        .dcache_req_o_t(dcache_req_o_t),
        .NumPorts  (NumPorts),
        .noc_req_t (noc_req_t),
        .noc_resp_t(noc_resp_t)
    ) i_cache_subsystem (
        // to D$
        .clk_i             (clk_i),
        .rst_ni            (rst_ni),
        // I$
        .icache_en_i       (icache_en_csr),
        .icache_flush_i    (icache_flush_ctrl_cache),
        .icache_miss_o     (icache_miss_cache_perf),
        .icache_areq_i     (icache_areq_ex_cache),
        .icache_areq_o     (icache_areq_cache_ex),
        .icache_dreq_i     (icache_dreq_if_cache),
        .icache_dreq_o     (icache_dreq_cache_if),
        // D$
        .dcache_enable_i   (dcache_en_csr_nbdcache),
        .dcache_flush_i    (dcache_flush_ctrl_cache),
        .dcache_flush_ack_o(dcache_flush_ack_cache_ctrl),
        // to commit stage
        .dcache_amo_req_i  (amo_req),
        .dcache_amo_resp_o (amo_resp),
        // from PTW, Load Unit  and Store Unit
        .dcache_miss_o     (dcache_miss_cache_perf),
        .miss_vld_bits_o   (miss_vld_bits),
        .dcache_req_ports_i(dcache_req_to_cache),
        .dcache_req_ports_o(dcache_req_from_cache),
        // write buffer status
        .wbuffer_empty_o   (dcache_commit_wbuffer_empty),
        .wbuffer_not_ni_o  (dcache_commit_wbuffer_not_ni),
        // memory side
        .noc_req_o         (noc_req_o),
        .noc_resp_i        (noc_resp_i),
        .inval_addr_i      (inval_addr),
        .inval_valid_i     (inval_valid),
        .inval_ready_o     (inval_ready)
    );
  end else if (CVA6Cfg.DCacheType inside {
      config_pkg::HPDCACHE_WT,
      config_pkg::HPDCACHE_WB,
      config_pkg::HPDCACHE_WT_WB})
  begin : gen_cache_hpd
    cva6_hpdcache_subsystem #(
        .CVA6Cfg   (CVA6Cfg),
        .icache_areq_t(icache_areq_t),
        .icache_arsp_t(icache_arsp_t),
        .icache_dreq_t(icache_dreq_t),
        .icache_drsp_t(icache_drsp_t),
        .icache_req_t(icache_req_t),
        .icache_rtrn_t(icache_rtrn_t),
        .dcache_req_i_t(dcache_req_i_t),
        .dcache_req_o_t(dcache_req_o_t),
        .NumPorts  (NumPorts),
        .axi_ar_chan_t(axi_ar_chan_t),
        .axi_aw_chan_t(axi_aw_chan_t),
        .axi_w_chan_t (axi_w_chan_t),
        .axi_b_chan_t (b_chan_t),
        .axi_r_chan_t (r_chan_t),
        .noc_req_t (noc_req_t),
        .noc_resp_t(noc_resp_t),
        .cmo_req_t (logic  /*FIXME*/),
        .cmo_rsp_t (logic  /*FIXME*/)
    ) i_cache_subsystem (
        .clk_i (clk_i),
        .rst_ni(rst_ni),

        .icache_en_i   (icache_en_csr),
        .icache_flush_i(icache_flush_ctrl_cache),
        .icache_miss_o (icache_miss_cache_perf),
        .icache_areq_i (icache_areq_ex_cache),
        .icache_areq_o (icache_areq_cache_ex),
        .icache_dreq_i (icache_dreq_if_cache),
        .icache_dreq_o (icache_dreq_cache_if),

        .dcache_enable_i   (dcache_en_csr_nbdcache),
        .dcache_flush_i    (dcache_flush_ctrl_cache),
        .dcache_flush_ack_o(dcache_flush_ack_cache_ctrl),
        .dcache_miss_o     (dcache_miss_cache_perf),

        .dcache_amo_req_i (amo_req),
        .dcache_amo_resp_o(amo_resp),

        .dcache_cmo_req_i ('0  /*FIXME*/),
        .dcache_cmo_resp_o(  /*FIXME*/),

        .dcache_req_ports_i(dcache_req_to_cache),
        .dcache_req_ports_o(dcache_req_from_cache),

        .wbuffer_empty_o (dcache_commit_wbuffer_empty),
        .wbuffer_not_ni_o(dcache_commit_wbuffer_not_ni),

        .hwpf_base_set_i    ('0  /*FIXME*/),
        .hwpf_base_i        ('0  /*FIXME*/),
        .hwpf_base_o        (  /*FIXME*/),
        .hwpf_param_set_i   ('0  /*FIXME*/),
        .hwpf_param_i       ('0  /*FIXME*/),
        .hwpf_param_o       (  /*FIXME*/),
        .hwpf_throttle_set_i('0  /*FIXME*/),
        .hwpf_throttle_i    ('0  /*FIXME*/),
        .hwpf_throttle_o    (  /*FIXME*/),
        .hwpf_status_o      (  /*FIXME*/),

        .noc_req_o (noc_req_o),
        .noc_resp_i(noc_resp_i)
    );
    assign inval_ready = 1'b1;
  end else begin : gen_cache_wb
    std_cache_subsystem #(
        // note: this only works with one cacheable region
        // not as important since this cache subsystem is about to be
        // deprecated
        .CVA6Cfg       (CVA6Cfg),
        .icache_areq_t (icache_areq_t),
        .icache_arsp_t (icache_arsp_t),
        .icache_dreq_t (icache_dreq_t),
        .icache_drsp_t (icache_drsp_t),
        .icache_req_t  (icache_req_t),
        .icache_rtrn_t (icache_rtrn_t),
        .dcache_req_i_t(dcache_req_i_t),
        .dcache_req_o_t(dcache_req_o_t),
        .NumPorts      (NumPorts),
        .axi_ar_chan_t (axi_ar_chan_t),
        .axi_aw_chan_t (axi_aw_chan_t),
        .axi_w_chan_t  (axi_w_chan_t),
        .axi_req_t     (noc_req_t),
        .axi_rsp_t     (noc_resp_t)
    ) i_cache_subsystem (
        // to D$
        .clk_i             (clk_i),
        .rst_ni            (rst_ni),
        .priv_lvl_i        (priv_lvl),
        // I$
        .icache_en_i       (icache_en_csr),
        .icache_flush_i    (icache_flush_ctrl_cache),
        .icache_miss_o     (icache_miss_cache_perf),
        .icache_areq_i     (icache_areq_ex_cache),
        .icache_areq_o     (icache_areq_cache_ex),
        .icache_dreq_i     (icache_dreq_if_cache),
        .icache_dreq_o     (icache_dreq_cache_if),
        // D$
        .dcache_enable_i   (dcache_en_csr_nbdcache),
        .dcache_flush_i    (dcache_flush_ctrl_cache),
        .dcache_flush_ack_o(dcache_flush_ack_cache_ctrl),
        // to commit stage
        .amo_req_i         (amo_req),
        .amo_resp_o        (amo_resp),
        .dcache_miss_o     (dcache_miss_cache_perf),
        // this is statically set to 1 as the std_cache does not have a wbuffer
        .wbuffer_empty_o   (dcache_commit_wbuffer_empty),
        // from PTW, Load Unit  and Store Unit
        .dcache_req_ports_i(dcache_req_to_cache),
        .dcache_req_ports_o(dcache_req_from_cache),
        // memory side
        .axi_req_o         (noc_req_o),
        .axi_resp_i        (noc_resp_i)
    );
    assign dcache_commit_wbuffer_not_ni = 1'b1;
    assign inval_ready                  = 1'b1;
  end

  // ----------------
  // Accelerator
  // ----------------

  if (CVA6Cfg.EnableAccelerator) begin : gen_accelerator
    acc_dispatcher #(
        .CVA6Cfg           (CVA6Cfg),
        .fu_data_t         (fu_data_t),
        .dcache_req_i_t    (dcache_req_i_t),
        .dcache_req_o_t    (dcache_req_o_t),
        .exception_t       (exception_t),
        .scoreboard_entry_t(scoreboard_entry_t),
        .acc_cfg_t         (acc_cfg_t),
        .AccCfg            (AccCfg),
        .acc_req_t         (cvxif_req_t),
        .acc_resp_t        (cvxif_resp_t)
    ) i_acc_dispatcher (
        .clk_i                 (clk_i),
        .rst_ni                (rst_ni),
        .flush_unissued_instr_i(flush_unissued_instr_ctrl_id),
        .flush_ex_i            (flush_ctrl_ex),
        .flush_pipeline_o      (flush_acc),
        .single_step_o         (single_step_acc_commit),
        .acc_cons_en_i         (acc_cons_en_csr),
        .acc_fflags_valid_o    (acc_resp_fflags_valid),
        .acc_fflags_o          (acc_resp_fflags),
        .ld_st_priv_lvl_i      (ld_st_priv_lvl_csr_ex),
        .sum_i                 (sum_csr_ex),
        .pmpcfg_i              (pmpcfg),
        .pmpaddr_i             (pmpaddr),
        .fcsr_frm_i            (frm_csr_id_issue_ex),
        .dirty_v_state_o       (dirty_v_state),
        .issue_instr_i         (issue_instr_id_acc),
        .issue_instr_hs_i      (issue_instr_hs_id_acc),
        .issue_stall_o         (stall_acc_id),
        .fu_data_i             (fu_data_id_ex[0]),
        .commit_instr_i        (commit_instr_id_commit),
        .commit_st_barrier_i   (fence_i_commit_controller | fence_commit_controller),
        .acc_trans_id_o        (acc_trans_id_ex_id),
        .acc_result_o          (acc_result_ex_id),
        .acc_valid_o           (acc_valid_ex_id),
        .acc_exception_o       (acc_exception_ex_id),
        .acc_valid_ex_o        (acc_valid_acc_ex),
        .commit_ack_i          (commit_ack),
        .acc_stall_st_pending_o(stall_st_pending_ex),
        .acc_no_st_pending_i   (no_st_pending_commit),
        .dcache_req_ports_i    (dcache_req_ports_ex_cache),
        .ctrl_halt_o           (halt_acc_ctrl),
        .csr_addr_i            (csr_addr_ex_csr),
        .acc_dcache_req_ports_o(dcache_req_ports_acc_cache),
        .acc_dcache_req_ports_i(dcache_req_ports_cache_acc),
        .inval_ready_i         (inval_ready),
        .inval_valid_o         (inval_valid),
        .inval_addr_o          (inval_addr),
        .acc_req_o             (cvxif_req_o),
        .acc_resp_i            (cvxif_resp_i)
    );
  end : gen_accelerator
  else begin : gen_no_accelerator
    assign acc_trans_id_ex_id         = '0;
    assign acc_result_ex_id           = '0;
    assign acc_valid_ex_id            = '0;
    assign acc_exception_ex_id        = '0;
    assign acc_resp_fflags            = '0;
    assign acc_resp_fflags_valid      = '0;
    assign stall_acc_id               = '0;
    assign dirty_v_state              = '0;
    assign acc_valid_acc_ex           = '0;
    assign halt_acc_ctrl              = '0;
    assign stall_st_pending_ex        = '0;
    assign flush_acc                  = '0;
    assign single_step_acc_commit     = '0;

    // D$ connection is unused
    assign dcache_req_ports_acc_cache = '0;

    // No invalidation interface
    assign inval_valid                = '0;
    assign inval_addr                 = '0;

    // Feed through cvxif
    assign cvxif_req_o                = cvxif_req;
  end : gen_no_accelerator

  // -------------------
  // Parameter Check
  // -------------------
  // pragma translate_off
  initial config_pkg::check_cfg(CVA6Cfg);
  // pragma translate_on

  // -------------------
  // Instruction Tracer
  // -------------------

  //pragma translate_off
`ifdef PITON_ARIANE
  localparam PC_QUEUE_DEPTH = 16;

  logic                                               piton_pc_vld;
  logic [         CVA6Cfg.VLEN-1:0]                   piton_pc;
  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.VLEN-1:0] pc_data;
  logic [CVA6Cfg.NrCommitPorts-1:0] pc_pop, pc_empty;

  for (genvar i = 0; i < CVA6Cfg.NrCommitPorts; i++) begin : gen_pc_fifo
    fifo_v3 #(
        .DATA_WIDTH(64),
        .DEPTH(PC_QUEUE_DEPTH),
        .FPGA_EN(CVA6Cfg.FpgaEn)
    ) i_pc_fifo (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .flush_i   ('0),
        .testmode_i('0),
        .full_o    (),
        .empty_o   (pc_empty[i]),
        .usage_o   (),
        .data_i    (commit_instr_id_commit[i].pc),
        .push_i    (commit_ack[i] & ~commit_instr_id_commit[i].ex.valid),
        .data_o    (pc_data[i]),
        .pop_i     (pc_pop[i])
    );
  end

  rr_arb_tree #(
      .NumIn(CVA6Cfg.NrCommitPorts),
      .DataWidth(64)
  ) i_rr_arb_tree (
      .clk_i  (clk_i),
      .rst_ni (rst_ni),
      .flush_i('0),
      .rr_i   ('0),
      .req_i  (~pc_empty),
      .gnt_o  (pc_pop),
      .data_i (pc_data),
      .gnt_i  (piton_pc_vld),
      .req_o  (piton_pc_vld),
      .data_o (piton_pc),
      .idx_o  ()
  );
`endif  // PITON_ARIANE

`ifndef VERILATOR
  instr_tracer #(
      .CVA6Cfg(CVA6Cfg),
      .bp_resolve_t(bp_resolve_t),
      .scoreboard_entry_t(scoreboard_entry_t),
      .interrupts_t(interrupts_t),
      .exception_t(exception_t),
      .INTERRUPTS(INTERRUPTS)
  ) instr_tracer_i (
      // .tracer_if(tracer_if),
      .pck(clk_i),
      .rstn(rst_ni),
      .flush_unissued(flush_unissued_instr_ctrl_id),
      .flush_all(flush_ctrl_ex),
      .instruction(id_stage_i.fetch_entry_i[0].instruction),
      .fetch_valid(id_stage_i.fetch_entry_valid_i[0]),
      .fetch_ack(id_stage_i.fetch_entry_ready_o[0]),
      .issue_ack(issue_stage_i.i_scoreboard.issue_ack_i),
      .issue_sbe(issue_stage_i.i_scoreboard.issue_instr_o),
      .waddr(waddr_commit_id),
      .wdata(wdata_commit_id),
      .we_gpr(we_gpr_commit_id),
      .we_fpr(we_fpr_commit_id),
      .commit_instr(commit_instr_id_commit),
      .commit_ack(commit_ack),
      .st_valid(ex_stage_i.lsu_i.i_store_unit.store_buffer_i.valid_i),
      .st_paddr(ex_stage_i.lsu_i.i_store_unit.store_buffer_i.paddr_i),
      .ld_valid(ex_stage_i.lsu_i.i_load_unit.req_port_o.tag_valid),
      .ld_kill(ex_stage_i.lsu_i.i_load_unit.req_port_o.kill_req),
      .ld_paddr(ex_stage_i.lsu_i.i_load_unit.paddr_i),
      .resolve_branch(resolved_branch),
      .commit_exception(commit_stage_i.exception_o),
      .priv_lvl(priv_lvl),
      .debug_mode(debug_mode),
      .hart_id_i(hart_id_i)
  );

  // mock tracer for Verilator, to be used with spike-dasm
`else

  int f;
  logic [63:0] cycles;

  initial begin
    string fn;
    $sformat(fn, "trace_hart_%0.0f.dasm", hart_id_i);
    f = $fopen(fn, "w");
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      cycles <= 0;
    end else begin
      byte mode = "";
      if (CVA6Cfg.DebugEn && debug_mode) mode = "D";
      else begin
        case (priv_lvl)
          riscv::PRIV_LVL_M: mode = "M";
          riscv::PRIV_LVL_S: if (CVA6Cfg.RVS) mode = "S";
          riscv::PRIV_LVL_U: mode = "U";
          default: ;  // Do nothing
        endcase
      end
      for (int i = 0; i < CVA6Cfg.NrCommitPorts; i++) begin
        if (commit_ack[i] && !commit_instr_id_commit[i].ex.valid) begin
          $fwrite(f, "%d 0x%0h %s (0x%h) DASM(%h)\n", cycles, commit_instr_id_commit[i].pc, mode,
                  commit_instr_id_commit[i].ex.tval[31:0], commit_instr_id_commit[i].ex.tval[31:0]);
        end else if (commit_ack[i] && commit_instr_id_commit[i].ex.valid) begin
          if (commit_instr_id_commit[i].ex.cause == 2) begin
            $fwrite(f, "Exception Cause: Illegal Instructions, DASM(%h) PC=%h\n",
                    commit_instr_id_commit[i].ex.tval[31:0], commit_instr_id_commit[i].pc);
          end else begin
            if (CVA6Cfg.DebugEn && debug_mode) begin
              $fwrite(f, "%d 0x%0h %s (0x%h) DASM(%h)\n", cycles, commit_instr_id_commit[i].pc,
                      mode, commit_instr_id_commit[i].ex.tval[31:0],
                      commit_instr_id_commit[i].ex.tval[31:0]);
            end else begin
              $fwrite(f, "Exception Cause: %5d, DASM(%h) PC=%h\n",
                      commit_instr_id_commit[i].ex.cause, commit_instr_id_commit[i].ex.tval[31:0],
                      commit_instr_id_commit[i].pc);
            end
          end
        end
      end
      cycles <= cycles + 1;
    end
  end

  final begin
    $fclose(f);
  end
`endif  // VERILATOR
  //pragma translate_on


  //RVFI INSTR
  logic [CVA6Cfg.NrIssuePorts-1:0][31:0] rvfi_fetch_instr;
  for (genvar i = 0; i < CVA6Cfg.NrIssuePorts; i++) begin
    assign rvfi_fetch_instr[i] = fetch_entry_if_id[i].instruction;
  end

  cva6_rvfi_probes #(
      .CVA6Cfg            (CVA6Cfg),
      .exception_t        (exception_t),
      .scoreboard_entry_t (scoreboard_entry_t),
      .lsu_ctrl_t         (lsu_ctrl_t),
      .rvfi_probes_instr_t(rvfi_probes_instr_t),
      .rvfi_probes_csr_t  (rvfi_probes_csr_t),
      .rvfi_probes_t      (rvfi_probes_t)
  ) i_cva6_rvfi_probes (

      .flush_i            (flush_ctrl_if),
      .issue_instr_ack_i  (issue_instr_issue_id),
      .fetch_entry_valid_i(fetch_valid_if_id),
      .instruction_i      (rvfi_fetch_instr),
      .is_compressed_i    (rvfi_is_compressed),

      .issue_pointer_i (rvfi_issue_pointer),
      .commit_pointer_i(rvfi_commit_pointer),

      .flush_unissued_instr_i(flush_unissued_instr_ctrl_id),
      .decoded_instr_valid_i (issue_entry_valid_id_issue),
      .decoded_instr_ack_i   (issue_instr_issue_id),

      .rs1_forwarding_i(rs1_forwarding_id_ex),
      .rs2_forwarding_i(rs2_forwarding_id_ex),

      .commit_instr_i(commit_instr_id_commit),
      .commit_drop_i (commit_drop_id_commit),
      .ex_commit_i   (ex_commit),
      .priv_lvl_i    (priv_lvl),

      .lsu_ctrl_i  (rvfi_lsu_ctrl),
      .wbdata_i    (wbdata_ex_id),
      .commit_ack_i(commit_ack),
      .mem_paddr_i (rvfi_mem_paddr),
      .debug_mode_i(debug_mode),
      .wdata_i     (wdata_commit_id),

      .csr_i(rvfi_csr),

      .rvfi_probes_o(rvfi_probes_o)

  );

  //pragma translate_off
  initial begin
    assert (!(CVA6Cfg.SuperscalarEn && CVA6Cfg.EnableAccelerator))
    else $fatal(1, "Accelerator is not supported by superscalar pipeline");
  end
  //pragma translate_on

endmodule  // ariane
