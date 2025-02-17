// Copyright 2020 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Authors: Matheus Cavalcante, ETH Zurich
//          Nils Wistoff, ETH Zurich
// Date: 20.11.2020
// Description: Functional unit that dispatches CVA6 instructions to accelerators.

module acc_dispatcher
  import ariane_pkg::*;
  import riscv::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type dcache_req_i_t = logic,
    parameter type dcache_req_o_t = logic,
    parameter type exception_t = logic,
    parameter type fu_data_t = logic,
    parameter type scoreboard_entry_t = logic,
    parameter type acc_req_t = logic,
    parameter type acc_resp_t = logic,
    parameter type accelerator_req_t = logic,
    parameter type accelerator_resp_t = logic,
    parameter type acc_mmu_req_t = logic,
    parameter type acc_mmu_resp_t = logic,
    parameter type acc_cfg_t = logic,
    parameter acc_cfg_t AccCfg = '0
) (
    input logic clk_i,
    input logic rst_ni,
    // Interface with the CSR regfile
    input logic acc_cons_en_i,  // Accelerator memory consistent mode
    output logic acc_fflags_valid_o,
    output logic [4:0] acc_fflags_o,
    // Interface with the CSRs
    input priv_lvl_t ld_st_priv_lvl_i,
    input logic sum_i,
    input pmpcfg_t [avoid_neg(CVA6Cfg.NrPMPEntries-1):0] pmpcfg_i,
    input logic [avoid_neg(CVA6Cfg.NrPMPEntries-1):0][CVA6Cfg.PLEN-3:0] pmpaddr_i,
    input logic [2:0] fcsr_frm_i,
    output logic dirty_v_state_o,
    input logic acc_mmu_en_i,
    // Interface with the issue stage
    input scoreboard_entry_t issue_instr_i,
    input logic issue_instr_hs_i,
    output logic issue_stall_o,
    input fu_data_t fu_data_i,
    input scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr_i,
    output logic [CVA6Cfg.TRANS_ID_BITS-1:0] acc_trans_id_o,
    output logic [CVA6Cfg.XLEN-1:0] acc_result_o,
    output logic acc_valid_o,
    output exception_t acc_exception_o,
    // Interface with the execute stage
    output logic acc_valid_ex_o,  // FU executed
    // Interface with the commit stage
    input logic [CVA6Cfg.NrCommitPorts-1:0] commit_ack_i,
    input logic commit_st_barrier_i,  // A store barrier was commited
    // Interface with the load/store unit
    output logic acc_stall_st_pending_o,
    input logic acc_no_st_pending_i,
    input dcache_req_i_t [2:0] dcache_req_ports_i,
    // Interface with the MMU
    output acc_mmu_req_t acc_mmu_req_o,
    input acc_mmu_resp_t acc_mmu_resp_i,
    // Interface with the controller
    output logic ctrl_halt_o,
    input logic [11:0] csr_addr_i,
    input logic flush_unissued_instr_i,
    input logic flush_ex_i,
    output logic flush_pipeline_o,
    output logic single_step_o,
    // Interface with cache subsystem
    output dcache_req_i_t [1:0] acc_dcache_req_ports_o,
    input dcache_req_o_t [1:0] acc_dcache_req_ports_i,
    input logic inval_ready_i,
    output logic inval_valid_o,
    output logic [63:0] inval_addr_o,
    // Accelerator interface
    output acc_req_t acc_req_o,
    input acc_resp_t acc_resp_i
);

  `include "common_cells/registers.svh"

  import cf_math_pkg::idx_width;

  /***********************
   *  Common signals     *
   ***********************/

  logic acc_ready;
  logic acc_valid_d, acc_valid_q;

  /**************************
   *  Accelerator issue     *
   **************************/

  // Issue accelerator instructions
  `FF(acc_valid_q, acc_valid_d, '0)

  assign acc_valid_ex_o = acc_valid_q;
  assign acc_valid_d    = ~issue_instr_i.ex.valid &
                          issue_instr_hs_i &
                          (issue_instr_i.fu == ACCEL) &
                          ~flush_unissued_instr_i;

  // Accelerator load/store pending signals
  logic acc_no_ld_pending;
  logic acc_no_st_pending;

  // Stall issue stage in three cases:
  always_comb begin : stall_issue
    unique case (issue_instr_i.fu)
      ACCEL:
      // 1. We're issuing an accelerator instruction but the dispatcher isn't ready yet
      issue_stall_o = ~acc_ready;
      LOAD:
      // 2. We're issuing a scalar load but there is an inflight accelerator store.
      issue_stall_o = acc_cons_en_i & ~acc_no_st_pending;
      STORE:
      // 3. We're issuing a scalar store but there is an inflight accelerator load or store.
      issue_stall_o = acc_cons_en_i & (~acc_no_st_pending | ~acc_no_ld_pending);
      default: issue_stall_o = 1'b0;
    endcase
  end

  /***********************
   *  Instruction queue  *
   ***********************/

  localparam InstructionQueueDepth = 3;

  fu_data_t                                        acc_data;
  fu_data_t                                        acc_insn_queue_o;
  logic                                            acc_insn_queue_pop;
  logic                                            acc_insn_queue_empty;
  logic     [idx_width(InstructionQueueDepth)-1:0] acc_insn_queue_usage;
  logic                                            acc_commit;
  logic     [           CVA6Cfg.TRANS_ID_BITS-1:0] acc_commit_trans_id;

  assign acc_data = acc_valid_ex_o ? fu_data_i : '0;

  cva6_fifo_v3 #(
      .DEPTH       (InstructionQueueDepth),
      .FALL_THROUGH(1'b1),
      .dtype       (fu_data_t),
      .FPGA_EN     (CVA6Cfg.FpgaEn)
  ) i_acc_insn_queue (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .flush_i   (flush_ex_i),
      .testmode_i(1'b0),
      .data_i    (fu_data_i),
      .push_i    (acc_valid_q),
      .full_o    (  /* Unused */),
      .data_o    (acc_insn_queue_o),
      .pop_i     (acc_insn_queue_pop),
      .empty_o   (acc_insn_queue_empty),
      .usage_o   (acc_insn_queue_usage)
  );

  // We are ready if the instruction queue is able to accept at least one more entry.
  assign acc_ready = acc_insn_queue_usage < (InstructionQueueDepth - 1);

  /**********************************
   *  Non-speculative instructions  *
   **********************************/

  // Keep track of the instructions that were received by the dispatcher.
  logic [CVA6Cfg.NR_SB_ENTRIES-1:0] insn_pending_d, insn_pending_q;
  `FF(insn_pending_q, insn_pending_d, '0)

  // Only non-speculative instructions can be issued to the accelerators.
  // The following block keeps track of which transaction IDs reached the
  // top of the scoreboard, and are therefore no longer speculative.
  logic [CVA6Cfg.NR_SB_ENTRIES-1:0] insn_ready_d, insn_ready_q;
  `FF(insn_ready_q, insn_ready_d, '0)

  always_comb begin : p_non_speculative_ff
    // Maintain state
    insn_pending_d = insn_pending_q;
    insn_ready_d   = insn_ready_q;

    // We received a new instruction
    if (acc_valid_q) insn_pending_d[acc_data.trans_id] = 1'b1;
    // Flush all received instructions
    if (flush_ex_i) insn_pending_d = '0;

    // An accelerator instruction is no longer speculative.
    if (acc_commit && insn_pending_q[acc_commit_trans_id]) begin
      insn_ready_d[acc_commit_trans_id]   = 1'b1;
      insn_pending_d[acc_commit_trans_id] = 1'b0;
    end

    // An accelerator instruction was issued.
    if (acc_req_o.acc_req.req_valid) insn_ready_d[acc_req_o.acc_req.trans_id] = 1'b0;
  end : p_non_speculative_ff

  /*************************
   *  Accelerator request  *
   *************************/

  accelerator_req_t acc_req;
  logic             acc_req_valid;
  logic             acc_req_ready;

  accelerator_req_t acc_req_int;
  spill_register #(
      .T(accelerator_req_t)
  ) i_accelerator_req_register (
      .clk_i  (clk_i),
      .rst_ni (rst_ni),
      .data_i (acc_req),
      .valid_i(acc_req_valid),
      .ready_o(acc_req_ready),
      .data_o (acc_req_int),
      .valid_o(acc_req_o.acc_req.req_valid),
      .ready_i(acc_resp_i.acc_resp.req_ready)
  );

  assign acc_req_o.acc_req.insn          = acc_req_int.insn;
  assign acc_req_o.acc_req.rs1           = acc_req_int.rs1;
  assign acc_req_o.acc_req.rs2           = acc_req_int.rs2;
  assign acc_req_o.acc_req.frm           = acc_req_int.frm;
  assign acc_req_o.acc_req.trans_id      = acc_req_int.trans_id;
  assign acc_req_o.acc_req.store_pending = !acc_no_st_pending_i && acc_cons_en_i;
  assign acc_req_o.acc_req.acc_cons_en   = acc_cons_en_i;
  assign acc_req_o.acc_req.inval_ready   = inval_ready_i;

  // MMU interface
  assign acc_req_o.acc_mmu_resp          = acc_mmu_resp_i;
  assign acc_req_o.acc_mmu_en            = acc_mmu_en_i;

  always_comb begin : accelerator_req_dispatcher
    // Do not fetch from the instruction queue
    acc_insn_queue_pop = 1'b0;

    // Default values
    acc_req            = '0;
    acc_req_valid      = 1'b0;

    // Unpack fu_data_t into acc_req_t
    if (!acc_insn_queue_empty) begin
      acc_req = '{
          // Instruction is forwarded from the decoder as an immediate
          // -
          // frm rounding information is up to date during a valid request to the accelerator
          // The scoreboard synchronizes it with previous fcsr writes, and future fcsr writes
          // do not take place until the accelerator answers (Ariane commits in-order)
          insn    :
          acc_insn_queue_o.imm[
          31
          :
          0
          ],
          rs1     : acc_insn_queue_o.operand_a,
          rs2     : acc_insn_queue_o.operand_b,
          frm     : fpnew_pkg::roundmode_e'(fcsr_frm_i),
          trans_id: acc_insn_queue_o.trans_id,
          default: '0
      };
      // Wait until the instruction is no longer speculative.
      acc_req_valid      = insn_ready_q[acc_insn_queue_o.trans_id] ||
                           (acc_commit && insn_pending_q[acc_commit_trans_id] && !flush_unissued_instr_i);
      acc_insn_queue_pop = acc_req_valid && acc_req_ready;
    end
  end

  /**************************
   *  Accelerator response  *
   **************************/

  logic acc_ld_disp;
  logic acc_st_disp;

  assign acc_trans_id_o = acc_resp_i.acc_resp.trans_id;
  assign acc_result_o = acc_resp_i.acc_resp.result;
  assign acc_valid_o = acc_resp_i.acc_resp.resp_valid;
  assign acc_exception_o = acc_resp_i.acc_resp.exception;
  // Unpack the accelerator response
  assign acc_fflags_valid_o = acc_resp_i.acc_resp.fflags_valid;
  assign acc_fflags_o = acc_resp_i.acc_resp.fflags;

  // MMU interface
  assign acc_mmu_req_o = acc_resp_i.acc_mmu_req;

  // Always ready to receive responses
  assign acc_req_o.acc_req.resp_ready = 1'b1;

  // Signal dispatched load/store to issue stage
  assign acc_ld_disp = acc_req_valid && (acc_insn_queue_o.operation == ACCEL_OP_LOAD);
  assign acc_st_disp = acc_req_valid && (acc_insn_queue_o.operation == ACCEL_OP_STORE);

  // Cache invalidation
  assign inval_valid_o = acc_resp_i.acc_resp.inval_valid;
  assign inval_addr_o = acc_resp_i.acc_resp.inval_addr;

  /**************************
   *  Accelerator commit    *
   **************************/

  // Instruction can be issued to the (in-order) back-end if
  // it reached the top of the scoreboard and it hasn't been
  // issued yet
  always_comb begin : accelerator_commit
    acc_commit = 1'b0;
    if (!commit_instr_i[0].valid && commit_instr_i[0].fu == ACCEL) acc_commit = 1'b1;
    if (commit_instr_i[0].valid && !commit_instr_i[1].valid && commit_instr_i[1].fu == ACCEL)
      acc_commit = 1'b1;
  end

  // Dirty the V state if we are committing anything related to the vector accelerator
  always_comb begin : dirty_v_state
    dirty_v_state_o = 1'b0;
    for (int i = 0; i < CVA6Cfg.NrCommitPorts; i++) begin
      dirty_v_state_o |= commit_ack_i[i] & (commit_instr_i[i].fu == ACCEL);
    end
  end

  assign acc_commit_trans_id = !commit_instr_i[0].valid ? commit_instr_i[0].trans_id
                                                        : commit_instr_i[1].trans_id;

  /**************************
   *  Accelerator barriers  *
   **************************/

  // On a store barrier (i.e. any barrier that requires preceeding stores to complete
  // before continuing execution), halt execution while there are pending stores in
  // the accelerator pipeline.
  logic wait_acc_store_d, wait_acc_store_q;
  `FF(wait_acc_store_q, wait_acc_store_d, '0)

  // Set on store barrier. Clear when no store is pending.
  assign wait_acc_store_d = (wait_acc_store_q | commit_st_barrier_i) & acc_resp_i.acc_resp.store_pending;
  assign ctrl_halt_o = wait_acc_store_q;

  /**************************
   *  Load/Store tracking   *
   **************************/

  // Loads
  logic       acc_spec_loads_overflow;
  logic [2:0] acc_spec_loads_pending;
  logic       acc_disp_loads_overflow;
  logic [2:0] acc_disp_loads_pending;

  assign acc_no_ld_pending = (acc_spec_loads_pending == 3'b0) && (acc_disp_loads_pending == 3'b0);

  // Count speculative loads. These can still be flushed.
  counter #(
      .WIDTH          (3),
      .STICKY_OVERFLOW(0)
  ) i_acc_spec_loads (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .clear_i   (flush_ex_i),
      .en_i      ((acc_valid_d && issue_instr_i.op == ACCEL_OP_LOAD) ^ acc_ld_disp),
      .load_i    (1'b0),
      .down_i    (acc_ld_disp),
      .d_i       ('0),
      .q_o       (acc_spec_loads_pending),
      .overflow_o(acc_spec_loads_overflow)
  );

  // Count dispatched loads. These cannot be flushed anymore.
  counter #(
      .WIDTH          (3),
      .STICKY_OVERFLOW(0)
  ) i_acc_disp_loads (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .clear_i   (1'b0),
      .en_i      (acc_ld_disp ^ acc_resp_i.acc_resp.load_complete),
      .load_i    (1'b0),
      .down_i    (acc_resp_i.acc_resp.load_complete),
      .d_i       ('0),
      .q_o       (acc_disp_loads_pending),
      .overflow_o(acc_disp_loads_overflow)
  );

  acc_dispatcher_no_load_overflow :
  assert property (
      @(posedge clk_i) disable iff (~rst_ni) (acc_spec_loads_overflow == 1'b0) && (acc_disp_loads_overflow == 1'b0) )
  else $error("[acc_dispatcher] Too many pending loads.");

  // Stores
  logic       acc_spec_stores_overflow;
  logic [2:0] acc_spec_stores_pending;
  logic       acc_disp_stores_overflow;
  logic [2:0] acc_disp_stores_pending;

  assign acc_no_st_pending = (acc_spec_stores_pending == 3'b0) && (acc_disp_stores_pending == 3'b0);

  // Count speculative stores. These can still be flushed.
  counter #(
      .WIDTH          (3),
      .STICKY_OVERFLOW(0)
  ) i_acc_spec_stores (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .clear_i   (flush_ex_i),
      .en_i      ((acc_valid_d && issue_instr_i.op == ACCEL_OP_STORE) ^ acc_st_disp),
      .load_i    (1'b0),
      .down_i    (acc_st_disp),
      .d_i       ('0),
      .q_o       (acc_spec_stores_pending),
      .overflow_o(acc_spec_stores_overflow)
  );

  // Count dispatched stores. These cannot be flushed anymore.
  counter #(
      .WIDTH          (3),
      .STICKY_OVERFLOW(0)
  ) i_acc_disp_stores (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .clear_i   (1'b0),
      .en_i      (acc_st_disp ^ acc_resp_i.acc_resp.store_complete),
      .load_i    (1'b0),
      .down_i    (acc_resp_i.acc_resp.store_complete),
      .d_i       ('0),
      .q_o       (acc_disp_stores_pending),
      .overflow_o(acc_disp_stores_overflow)
  );

  acc_dispatcher_no_store_overflow :
  assert property (
      @(posedge clk_i) disable iff (~rst_ni) (acc_spec_stores_overflow == 1'b0) && (acc_disp_stores_overflow == 1'b0) )
  else $error("[acc_dispatcher] Too many pending stores.");

  /**************************
   * Tie Off Unused Signals *
   **************************/

  assign acc_stall_st_pending_o = 1'b0;
  assign flush_pipeline_o       = 1'b0;
  assign single_step_o          = 1'b0;
  assign acc_dcache_req_ports_o = '0;

endmodule : acc_dispatcher
