// Copyright 2024 Thales DIS France SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Yannick Casamatta - Thales
// Date: 09/01/2024


module cva6_rvfi
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type rvfi_instr_t = logic,
    parameter type rvfi_csr_t = logic,
    parameter type rvfi_probes_instr_t = logic,
    parameter type rvfi_probes_csr_t = logic,
    parameter type rvfi_probes_t = logic

) (

    input logic clk_i,
    input logic rst_ni,

    input rvfi_probes_t rvfi_probes_i,
    output rvfi_instr_t [CVA6Cfg.NrCommitPorts-1:0] rvfi_instr_o,
    output rvfi_csr_t rvfi_csr_o

);

  localparam logic [CVA6Cfg.XLEN-1:0] IsaCode =
    (CVA6Cfg.XLEN'(CVA6Cfg.RVA) << 0)   // A - Atomic Instructions extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVB) << 1)  // C - Bitmanip extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVC) << 2)  // C - Compressed extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVD) << 3)  // D - Double precision floating-point extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVF) << 5)  // F - Single precision floating-point extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVH) << 7)  // H - Hypervisor extension
  | (CVA6Cfg.XLEN'(1) << 8)  // I - RV32I/64I/128I base ISA
  | (CVA6Cfg.XLEN'(1) << 12)  // M - Integer Multiply/Divide extension
  | (CVA6Cfg.XLEN'(0) << 13)  // N - User level interrupts supported
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVS) << 18)  // S - Supervisor mode implemented
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVU) << 20)  // U - User mode implemented
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVV) << 21)  // V - Vector extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.NSX) << 23)  // X - Non-standard extensions present
  | ((CVA6Cfg.XLEN == 64 ? 2 : 1) << CVA6Cfg.XLEN - 2);  // MXL

  localparam logic [CVA6Cfg.XLEN-1:0] hart_id_i = '0;

  localparam logic [63:0] SMODE_STATUS_READ_MASK = ariane_pkg::smode_status_read_mask(CVA6Cfg);

  logic flush;
  logic [CVA6Cfg.NrIssuePorts-1:0] issue_instr_ack;
  logic [CVA6Cfg.NrIssuePorts-1:0] fetch_entry_valid;
  logic [CVA6Cfg.NrIssuePorts-1:0][31:0] instruction;
  logic [CVA6Cfg.NrIssuePorts-1:0] is_compressed;
  logic [CVA6Cfg.NrIssuePorts-1:0][31:0] truncated;

  logic [CVA6Cfg.NrIssuePorts-1:0][CVA6Cfg.TRANS_ID_BITS-1:0] issue_pointer;
  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.TRANS_ID_BITS-1:0] commit_pointer;

  logic flush_unissued_instr;
  logic [CVA6Cfg.NrIssuePorts-1:0] decoded_instr_valid;
  logic [CVA6Cfg.NrIssuePorts-1:0] decoded_instr_ack;

  logic [CVA6Cfg.NrIssuePorts-1:0][CVA6Cfg.XLEN-1:0] rs1_forwarding;
  logic [CVA6Cfg.NrIssuePorts-1:0][CVA6Cfg.XLEN-1:0] rs2_forwarding;

  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.XLEN-1:0] rvfi_intr;

  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.VLEN-1:0] commit_instr_pc;
  fu_op [CVA6Cfg.NrCommitPorts-1:0] commit_instr_op;
  logic [CVA6Cfg.NrCommitPorts-1:0][REG_ADDR_SIZE-1:0] commit_instr_rs1;
  logic [CVA6Cfg.NrCommitPorts-1:0][REG_ADDR_SIZE-1:0] commit_instr_rs2;
  logic [CVA6Cfg.NrCommitPorts-1:0][REG_ADDR_SIZE-1:0] commit_instr_rd;
  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.XLEN-1:0] commit_instr_result;
  logic [CVA6Cfg.NrCommitPorts-1:0] commit_instr_valid;
  logic [CVA6Cfg.NrCommitPorts-1:0] commit_drop;

  logic [CVA6Cfg.XLEN-1:0] ex_commit_cause;
  logic ex_commit_valid;

  riscv::priv_lvl_t priv_lvl;

  logic [CVA6Cfg.VLEN-1:0] lsu_ctrl_vaddr;
  fu_t lsu_ctrl_fu;
  logic [(CVA6Cfg.XLEN/8)-1:0] lsu_ctrl_be;
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] lsu_ctrl_trans_id;

  logic [((CVA6Cfg.CvxifEn || CVA6Cfg.RVV) ? 5 : 4)-1:0][CVA6Cfg.XLEN-1:0] wbdata;
  logic [CVA6Cfg.NrCommitPorts-1:0] commit_ack;
  logic [CVA6Cfg.PLEN-1:0] mem_paddr;
  logic debug_mode;
  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.XLEN-1:0] wdata;

  logic [CVA6Cfg.VLEN-1:0] lsu_addr;
  logic [(CVA6Cfg.XLEN/8)-1:0] lsu_rmask;
  logic [(CVA6Cfg.XLEN/8)-1:0] lsu_wmask;
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] lsu_addr_trans_id;

  riscv::pmpcfg_t [15:0] pmpcfg_q, pmpcfg_d;

  rvfi_probes_csr_t   csr;
  rvfi_probes_instr_t instr;

  always_comb begin
    csr   = '0;
    instr = '0;

    if ($bits(rvfi_probes_i.instr) == $bits(instr)) begin
      instr = rvfi_probes_i.instr;
    end

    if ($bits(rvfi_probes_i.csr) == $bits(csr)) begin
      csr = rvfi_probes_i.csr;
    end

  end


  assign flush = instr.flush;
  assign issue_instr_ack = instr.issue_instr_ack;
  assign fetch_entry_valid = instr.fetch_entry_valid;
  assign instruction = instr.instruction;
  assign is_compressed = instr.is_compressed;

  assign issue_pointer = instr.issue_pointer;
  assign commit_pointer = instr.commit_pointer;

  assign flush_unissued_instr = instr.flush_unissued_instr;
  assign decoded_instr_valid = instr.decoded_instr_valid;
  assign decoded_instr_ack = instr.decoded_instr_ack;

  assign rs1_forwarding = instr.rs1_forwarding;
  assign rs2_forwarding = instr.rs2_forwarding;

  assign commit_instr_pc = instr.commit_instr_pc;
  assign commit_instr_op = instr.commit_instr_op;
  assign commit_instr_rs1 = instr.commit_instr_rs1;
  assign commit_instr_rs2 = instr.commit_instr_rs2;
  assign commit_instr_rd = instr.commit_instr_rd;
  assign commit_instr_result = instr.commit_instr_result;
  assign commit_instr_valid = instr.commit_instr_valid;
  assign commit_drop = instr.commit_drop;

  assign ex_commit_cause = instr.ex_commit_cause;
  assign ex_commit_valid = instr.ex_commit_valid;

  assign priv_lvl = instr.priv_lvl;

  assign wbdata = instr.wbdata;
  assign commit_ack = instr.commit_ack;
  assign mem_paddr = instr.mem_paddr;
  assign debug_mode = instr.debug_mode;
  assign wdata = instr.wdata;

  assign lsu_addr = instr.lsu_ctrl_vaddr;
  assign lsu_rmask = instr.lsu_ctrl_fu == LOAD ? instr.lsu_ctrl_be : '0;
  assign lsu_wmask = instr.lsu_ctrl_fu == STORE ? instr.lsu_ctrl_be : '0;
  assign lsu_addr_trans_id = instr.lsu_ctrl_trans_id;


  //ID STAGE

  for (genvar i = 0; i < CVA6Cfg.NrIssuePorts; i++) begin
    assign truncated[i] = (is_compressed[i]) ? {16'b0, instruction[i][15:0]} : instruction[i];
  end

  typedef struct packed {
    logic        valid;
    logic [31:0] instr;
  } issue_struct_t;
  issue_struct_t [CVA6Cfg.NrIssuePorts-1:0] issue_n, issue_q;
  logic took0;

  always_comb begin
    issue_n = issue_q;
    took0   = 1'b0;

    for (int unsigned i = 0; i < CVA6Cfg.NrIssuePorts; i++) begin
      if (issue_instr_ack[i]) begin
        issue_n[i].valid = 1'b0;
      end
    end

    if (!issue_n[CVA6Cfg.NrIssuePorts-1].valid) begin
      issue_n[CVA6Cfg.NrIssuePorts-1].valid = fetch_entry_valid[0];
      issue_n[CVA6Cfg.NrIssuePorts-1].instr = truncated[0];
      took0 = 1'b1;
    end

    if (!issue_n[0].valid) begin
      issue_n[0] = issue_n[CVA6Cfg.NrIssuePorts-1];
      issue_n[CVA6Cfg.NrIssuePorts-1].valid = 1'b0;
    end

    if (!issue_n[CVA6Cfg.NrIssuePorts-1].valid) begin
      if (took0) begin
        issue_n[CVA6Cfg.NrIssuePorts-1].valid = fetch_entry_valid[CVA6Cfg.NrIssuePorts-1];
        issue_n[CVA6Cfg.NrIssuePorts-1].instr = truncated[CVA6Cfg.NrIssuePorts-1];
      end else begin
        issue_n[CVA6Cfg.NrIssuePorts-1].valid = fetch_entry_valid[0];
        issue_n[CVA6Cfg.NrIssuePorts-1].instr = truncated[0];
      end
    end

    if (flush) begin
      for (int unsigned i = 0; i < CVA6Cfg.NrIssuePorts; i++) begin
        issue_n[i].valid = 1'b0;
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      issue_q <= '0;
    end else begin
      issue_q <= issue_n;
    end
  end

  //ISSUE STAGE

  // this is the FIFO struct of the issue queue
  typedef struct packed {
    logic [CVA6Cfg.XLEN-1:0] rs1_rdata;
    logic [CVA6Cfg.XLEN-1:0] rs2_rdata;
    logic [CVA6Cfg.VLEN-1:0] lsu_addr;
    logic [(CVA6Cfg.XLEN/8)-1:0] lsu_rmask;
    logic [(CVA6Cfg.XLEN/8)-1:0] lsu_wmask;
    logic [CVA6Cfg.XLEN-1:0] lsu_wdata;
    logic [31:0] instr;
  } sb_mem_t;
  sb_mem_t [CVA6Cfg.NR_SB_ENTRIES-1:0] mem_q, mem_n;

  always_comb begin : issue_fifo
    mem_n = mem_q;

    for (int unsigned i = 0; i < CVA6Cfg.NrIssuePorts; i++) begin
      if (decoded_instr_valid[i] && decoded_instr_ack[i] && !flush_unissued_instr) begin
        mem_n[issue_pointer[i]] = '{
            rs1_rdata: rs1_forwarding[i],
            rs2_rdata: rs2_forwarding[i],
            lsu_addr: '0,
            lsu_rmask: '0,
            lsu_wmask: '0,
            lsu_wdata: '0,
            instr: issue_q[i].instr
        };
      end
    end

    if (lsu_rmask != 0) begin
      mem_n[lsu_addr_trans_id].lsu_addr  = lsu_addr;
      mem_n[lsu_addr_trans_id].lsu_rmask = lsu_rmask;
    end else if (lsu_wmask != 0) begin
      mem_n[lsu_addr_trans_id].lsu_addr  = lsu_addr;
      mem_n[lsu_addr_trans_id].lsu_wmask = lsu_wmask;
      mem_n[lsu_addr_trans_id].lsu_wdata = wbdata[STORE_WB];
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : regs
    if (!rst_ni) begin
      mem_q <= '{default: sb_mem_t'(0)};
    end else begin
      mem_q <= mem_n;
    end
  end

  //----------------------------------------------------------------------------------------------------------
  // PACK
  //----------------------------------------------------------------------------------------------------------

  always_ff @(posedge clk_i) begin
    for (int i = 0; i < CVA6Cfg.NrCommitPorts; i++) begin
      logic exception;
      logic valid;
      exception = (i == 0) && commit_instr_valid[i] && ex_commit_valid && !commit_drop[i];
      valid     = (commit_ack[i] && !ex_commit_valid && !commit_drop[i]) ||
        (exception && (ex_commit_cause == riscv::ENV_CALL_MMODE ||
                  ex_commit_cause == riscv::ENV_CALL_SMODE ||
                  ex_commit_cause == riscv::ENV_CALL_UMODE));
      rvfi_instr_o[i].valid <= valid;
      rvfi_instr_o[i].insn  <= mem_q[commit_pointer[i]].instr;
      // when synchronous trap, the instruction is not executed
      rvfi_instr_o[i].trap  <= exception && !ex_commit_cause[31];

      if (exception && ex_commit_cause[31]) begin
        rvfi_intr[i] <= 'b101;
      end else if (exception) begin
        rvfi_intr[i] <= 'b11;
      end
      if (valid) begin
        rvfi_intr[i] <= 0;
      end

      rvfi_instr_o[i].intr <= rvfi_intr[i];

      rvfi_instr_o[i].cause <= ex_commit_cause;
      rvfi_instr_o[i].mode <= (CVA6Cfg.DebugEn && debug_mode) ? 2'b10 : priv_lvl;
      rvfi_instr_o[i].ixl <= CVA6Cfg.XLEN == 64 ? 2 : 1;
      rvfi_instr_o[i].rs1_addr <= commit_instr_rs1[i];
      rvfi_instr_o[i].rs2_addr <= commit_instr_rs2[i];
      rvfi_instr_o[i].rd_addr <= commit_instr_rd[i];
      rvfi_instr_o[i].rd_wdata <= (CVA6Cfg.FpPresent && is_rd_fpr(
          commit_instr_op[i]
      )) ? commit_instr_result[i] : wdata[i];
      rvfi_instr_o[i].pc_rdata <= commit_instr_pc[i];
      rvfi_instr_o[i].mem_addr <= mem_q[commit_pointer[i]].lsu_addr;
      // So far, only write paddr is reported. TODO: read paddr
      rvfi_instr_o[i].mem_paddr <= mem_paddr;
      rvfi_instr_o[i].mem_wmask <= mem_q[commit_pointer[i]].lsu_wmask;
      rvfi_instr_o[i].mem_wdata <= mem_q[commit_pointer[i]].lsu_wdata;
      rvfi_instr_o[i].mem_rmask <= mem_q[commit_pointer[i]].lsu_rmask;
      rvfi_instr_o[i].mem_rdata <= commit_instr_result[i];
      rvfi_instr_o[i].rs1_rdata <= mem_q[commit_pointer[i]].rs1_rdata;
      rvfi_instr_o[i].rs2_rdata <= mem_q[commit_pointer[i]].rs2_rdata;
    end
  end


  //----------------------------------------------------------------------------------------------------------
  // CSR
  //----------------------------------------------------------------------------------------------------------

  `define CONNECT_RVFI_FULL(CSR_ENABLE_COND, CSR_NAME,
                            CSR_SOURCE_NAME) \
    always_ff @(posedge clk_i) begin \
        if (CSR_ENABLE_COND) begin \
            rvfi_csr_o.``CSR_NAME``.rdata <= {{CVA6Cfg.XLEN - $bits(CSR_SOURCE_NAME)}, CSR_SOURCE_NAME}; \
        end \
    end \
    assign rvfi_csr_o.``CSR_NAME``.wdata = CSR_ENABLE_COND ? { {{CVA6Cfg.XLEN-$bits(CSR_SOURCE_NAME)}, CSR_SOURCE_NAME} } : 0; \
    assign rvfi_csr_o.``CSR_NAME``.rmask = CSR_ENABLE_COND ? 1 : 0; \
    assign rvfi_csr_o.``CSR_NAME``.wmask = (rvfi_csr_o.``CSR_NAME``.rdata != {{CVA6Cfg.XLEN - $bits(CSR_SOURCE_NAME)}, CSR_SOURCE_NAME}) && CSR_ENABLE_COND;

  `define COMMA ,

  `define CONNECT_RVFI_SAME(CSR_ENABLE_COND, CSR_NAME) \
            `CONNECT_RVFI_FULL(CSR_ENABLE_COND, CSR_NAME, csr.``CSR_NAME``_q)

  `CONNECT_RVFI_FULL(CVA6Cfg.FpPresent, fflags, csr.fcsr_q.fflags)
  `CONNECT_RVFI_FULL(CVA6Cfg.FpPresent, frm, csr.fcsr_q.frm)
  `CONNECT_RVFI_FULL(CVA6Cfg.FpPresent, fcsr, { csr.fcsr_q.frm `COMMA csr.fcsr_q.fflags})

  `CONNECT_RVFI_FULL(CVA6Cfg.FpPresent, ftran, csr.fcsr_q.fprec)
  `CONNECT_RVFI_SAME(CVA6Cfg.FpPresent, dcsr)

  `CONNECT_RVFI_SAME(CVA6Cfg.DebugEn, dpc)

  `CONNECT_RVFI_SAME(CVA6Cfg.DebugEn, dscratch0)
  `CONNECT_RVFI_SAME(CVA6Cfg.DebugEn, dscratch1)

  `CONNECT_RVFI_FULL(CVA6Cfg.RVS, sstatus,
                     csr.mstatus_extended & SMODE_STATUS_READ_MASK[CVA6Cfg.XLEN-1:0])

  `CONNECT_RVFI_FULL(CVA6Cfg.RVS, sie, csr.mie_q & csr.mideleg_q)
  `CONNECT_RVFI_FULL(CVA6Cfg.RVS, sip, csr.mip_q & csr.mideleg_q)

  `CONNECT_RVFI_SAME(CVA6Cfg.RVS, stvec)

  `CONNECT_RVFI_SAME(CVA6Cfg.RVS, scounteren)

  `CONNECT_RVFI_SAME(CVA6Cfg.RVS, sscratch)
  `CONNECT_RVFI_SAME(CVA6Cfg.RVS, sepc)

  `CONNECT_RVFI_SAME(CVA6Cfg.RVS, scause)

  `CONNECT_RVFI_SAME(CVA6Cfg.RVS, stval)
  `CONNECT_RVFI_SAME(CVA6Cfg.RVS, satp)

  `CONNECT_RVFI_FULL(1'b1, mstatus, csr.mstatus_extended)

  bit [31:0] mstatush_q;
  `CONNECT_RVFI_FULL(1'b1, mstatush, mstatush_q)

  `CONNECT_RVFI_FULL(1'b1, misa, IsaCode)

  `CONNECT_RVFI_SAME(CVA6Cfg.RVS, medeleg)
  `CONNECT_RVFI_SAME(CVA6Cfg.RVS, mideleg)

  `CONNECT_RVFI_SAME(1'b1, mie)
  `CONNECT_RVFI_SAME(1'b1, mtvec)
  `CONNECT_RVFI_SAME(1'b1, mcounteren)

  `CONNECT_RVFI_SAME(1'b1, mscratch)

  `CONNECT_RVFI_SAME(1'b1, mepc)
  `CONNECT_RVFI_SAME(1'b1, mcause)
  `CONNECT_RVFI_SAME(1'b1, mtval)
  `CONNECT_RVFI_SAME(1'b1, mip)

  `CONNECT_RVFI_FULL(1'b1, menvcfg, csr.fiom_q)

  `CONNECT_RVFI_FULL(CVA6Cfg.XLEN == 32, menvcfgh, 32'h0)

  `CONNECT_RVFI_FULL(1'b1, mvendorid, OPENHWGROUP_MVENDORID)
  `CONNECT_RVFI_FULL(1'b1, marchid, ARIANE_MARCHID)
  `CONNECT_RVFI_FULL(1'b1, mhartid, hart_id_i)

  `CONNECT_RVFI_SAME(1'b1, mcountinhibit)

  `CONNECT_RVFI_FULL(1'b1, mcycle, csr.cycle_q[CVA6Cfg.XLEN-1:0])
  `CONNECT_RVFI_FULL(CVA6Cfg.XLEN == 32, mcycleh, csr.cycle_q[63:32])

  `CONNECT_RVFI_FULL(1'b1, minstret, csr.instret_q[CVA6Cfg.XLEN-1:0])
  `CONNECT_RVFI_FULL(CVA6Cfg.XLEN == 32, minstreth, csr.instret_q[63:32])

  `CONNECT_RVFI_FULL(1'b1, cycle, csr.cycle_q[CVA6Cfg.XLEN-1:0])
  `CONNECT_RVFI_FULL(CVA6Cfg.XLEN == 32, cycleh, csr.cycle_q[63:32])

  `CONNECT_RVFI_FULL(1'b1, instret, csr.instret_q[CVA6Cfg.XLEN-1:0])
  `CONNECT_RVFI_FULL(CVA6Cfg.XLEN == 32, instreth, csr.instret_q[63:32])

  `CONNECT_RVFI_SAME(1'b1, dcache)
  `CONNECT_RVFI_SAME(1'b1, icache)

  `CONNECT_RVFI_SAME(CVA6Cfg.EnableAccelerator, acc_cons)

  `CONNECT_RVFI_FULL(1'b1, pmpcfg0, csr.pmpcfg_q[CVA6Cfg.XLEN/8-1:0])
  `CONNECT_RVFI_FULL(CVA6Cfg.XLEN == 32, pmpcfg1, csr.pmpcfg_q[7:4])

  `CONNECT_RVFI_FULL(1'b1, pmpcfg2, csr.pmpcfg_q[8+:CVA6Cfg.XLEN/8])
  `CONNECT_RVFI_FULL(CVA6Cfg.XLEN == 32, pmpcfg3, csr.pmpcfg_q[15:12])

  bit [CVA6Cfg.XLEN-1:0] pmpaddr_q;
  genvar i;
  generate
    for (i = 0; i < 16; i++) begin
      `CONNECT_RVFI_FULL(1'b1, pmpaddr[i], csr.pmpaddr_q[i][CVA6Cfg.PLEN-3:0])
    end
  endgenerate
  ;

endmodule
