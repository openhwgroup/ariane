// Copyright 2018 ETH Zurich and University of Bologna.
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
// Date: 08.05.2017
// Description: Flush controller


module controller
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type bp_resolve_t = logic
) (
    // Subsystem Clock - SUBSYSTEM
    input logic clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input logic rst_ni,
    // Virtualization mode - CSR_REGFILE
    input logic v_i,
    // Set PC om PC Gen - FRONTEND
    output logic set_pc_commit_o,
    // Flush the IF stage - FRONTEND
    output logic flush_if_o,
    // Flush un-issued instructions of the scoreboard - FRONTEND
    output logic flush_unissued_instr_o,
    // Flush ID stage - ID_STAGE
    output logic flush_id_o,
    // Flush EX stage - EX_STAGE
    output logic flush_ex_o,
    // Flush branch predictors - FRONTEND
    output logic flush_bp_o,
    // Flush ICache - CACHE
    output logic flush_icache_o,
    // Flush DCache - CACHE
    output logic flush_dcache_o,
    // Acknowledge the whole DCache Flush - CACHE
    input logic flush_dcache_ack_i,
    // Flush TLBs - EX_STAGE
    output logic flush_tlb_o,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    output logic flush_tlb_vvma_o,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    output logic flush_tlb_gvma_o,
    // Halt request from CSR (WFI instruction) - CSR_REGFILE
    input logic halt_csr_i,
    // Halt request from accelerator dispatcher - ACC_DISPATCHER
    input logic halt_acc_i,
    // Halt signal to commit stage - COMMIT_STAGE
    output logic halt_o,
    // Return from exception - CSR_REGFILE
    input logic eret_i,
    // We got an exception, flush the pipeline - FRONTEND
    input logic ex_valid_i,
    // set the debug pc from CSR - FRONTEND
    input logic set_debug_pc_i,
    // We got a resolved branch, check if we need to flush the front-end - EX_STAGE
    input bp_resolve_t resolved_branch_i,
    // We got an instruction which altered the CSR, flush the pipeline - CSR_REGFILE
    input logic flush_csr_i,
    // fence.i in - ACC_DISPATCH
    input logic fence_i_i,
    // fence in - ACC_DISPATCH
    input logic fence_i,
    // We got an instruction to flush the TLBs and pipeline - COMMIT_STAGE
    input logic sfence_vma_i,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    input logic hfence_vvma_i,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    input logic hfence_gvma_i,
    // Flush request from commit stage - COMMIT_STAGE
    input logic flush_commit_i,
    // Flush request from accelerator - ACC_DISPATCHER
    input logic flush_acc_i
);

  // active fence - high if we are currently flushing the dcache
  logic fence_active_d, fence_active_q;
  logic flush_dcache;

  // ------------
  // Flush CTRL
  // ------------
  always_comb begin : flush_ctrl
    fence_active_d         = fence_active_q;
    set_pc_commit_o        = 1'b0;
    flush_if_o             = 1'b0;
    flush_unissued_instr_o = 1'b0;
    flush_id_o             = 1'b0;
    flush_ex_o             = 1'b0;
    flush_dcache           = 1'b0;
    flush_icache_o         = 1'b0;
    flush_tlb_o            = 1'b0;
    flush_tlb_vvma_o       = 1'b0;
    flush_tlb_gvma_o       = 1'b0;
    flush_bp_o             = 1'b0;
    // ------------
    // Mis-predict
    // ------------
    // flush on mispredict
    if (resolved_branch_i.is_mispredict) begin
      // flush only un-issued instructions
      flush_unissued_instr_o = 1'b1;
      // and if stage
      flush_if_o             = 1'b1;
    end

    // ---------------------------------
    // FENCE
    // ---------------------------------
    if (fence_i) begin
      // this can be seen as a CSR instruction with side-effect
      set_pc_commit_o        = 1'b1;
      flush_if_o             = 1'b1;
      flush_unissued_instr_o = 1'b1;
      flush_id_o             = 1'b1;
      flush_ex_o             = 1'b1;
      // this is not needed in the case since we
      // have a write-through cache in this case
      if (CVA6Cfg.DcacheFlushOnFence) begin
        flush_dcache   = 1'b1;
        fence_active_d = 1'b1;
      end
    end

    // ---------------------------------
    // FENCE.I
    // ---------------------------------
    if (fence_i_i) begin
      set_pc_commit_o        = 1'b1;
      flush_if_o             = 1'b1;
      flush_unissued_instr_o = 1'b1;
      flush_id_o             = 1'b1;
      flush_ex_o             = 1'b1;
      flush_icache_o         = 1'b1;
      // this is not needed in the case since we
      // have a write-through cache in this case
      if (CVA6Cfg.DcacheFlushOnFence) begin
        flush_dcache   = 1'b1;
        fence_active_d = 1'b1;
      end
    end

    // this is not needed in the case since we
    // have a write-through cache in this case
    if (CVA6Cfg.DcacheFlushOnFence) begin
      // wait for the acknowledge here
      if (flush_dcache_ack_i && fence_active_q) begin
        fence_active_d = 1'b0;
        // keep the flush dcache signal high as long as we didn't get the acknowledge from the cache
      end else if (fence_active_q) begin
        flush_dcache = 1'b1;
      end
    end
    // ---------------------------------
    // SFENCE.VMA
    // ---------------------------------
    if (CVA6Cfg.RVS && sfence_vma_i) begin
      set_pc_commit_o        = 1'b1;
      flush_if_o             = 1'b1;
      flush_unissued_instr_o = 1'b1;
      flush_id_o             = 1'b1;
      flush_ex_o             = 1'b1;

      if (CVA6Cfg.RVH && v_i) flush_tlb_vvma_o = 1'b1;
      else flush_tlb_o = 1'b1;
    end

    // ---------------------------------
    // HFENCE.VVMA
    // ---------------------------------
    if (CVA6Cfg.RVH && hfence_vvma_i) begin
      set_pc_commit_o        = 1'b1;
      flush_if_o             = 1'b1;
      flush_unissued_instr_o = 1'b1;
      flush_id_o             = 1'b1;
      flush_ex_o             = 1'b1;

      flush_tlb_vvma_o       = 1'b1;
    end

    // ---------------------------------
    // HFENCE.GVMA
    // ---------------------------------
    if (CVA6Cfg.RVH && hfence_gvma_i) begin
      set_pc_commit_o        = 1'b1;
      flush_if_o             = 1'b1;
      flush_unissued_instr_o = 1'b1;
      flush_id_o             = 1'b1;
      flush_ex_o             = 1'b1;

      flush_tlb_gvma_o       = 1'b1;
    end

    // ---------------------------------
    // CSR side effects and accelerate port
    // ---------------------------------
    // Set PC to commit stage and flush pipeline
    if (flush_csr_i || flush_acc_i) begin
      set_pc_commit_o        = 1'b1;
      flush_if_o             = 1'b1;
      flush_unissued_instr_o = 1'b1;
      flush_id_o             = 1'b1;
      flush_ex_o             = 1'b1;
    end else if (CVA6Cfg.RVA && flush_commit_i) begin
      set_pc_commit_o        = 1'b1;
      flush_if_o             = 1'b1;
      flush_unissued_instr_o = 1'b1;
      flush_id_o             = 1'b1;
      flush_ex_o             = 1'b1;
    end

    // ---------------------------------
    // 1. Exception
    // 2. Return from exception
    // ---------------------------------
    if (ex_valid_i || eret_i || (CVA6Cfg.DebugEn && set_debug_pc_i)) begin
      // don't flush pcgen as we want to take the exception: Flush PCGen is not a flush signal
      // for the PC Gen stage but instead tells it to take the PC we gave it
      set_pc_commit_o        = 1'b0;
      flush_if_o             = 1'b1;
      flush_unissued_instr_o = 1'b1;
      flush_id_o             = 1'b1;
      flush_ex_o             = 1'b1;
      // this potentially reduces performance, but is needed
      // to suppress speculative fetches to virtual memory from
      // machine mode. TODO: remove when PMA checkers have been
      // added to the system
      flush_bp_o             = 1'b1;
    end
  end

  // ----------------------
  // Halt Logic
  // ----------------------
  always_comb begin
    // halt the core if the fence is active
    halt_o = halt_csr_i || halt_acc_i || (CVA6Cfg.DcacheFlushOnFence && fence_active_q);
  end

  // ----------------------
  // Registers
  // ----------------------
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      fence_active_q <= 1'b0;
      flush_dcache_o <= 1'b0;
    end else begin
      fence_active_q <= fence_active_d;
      // register on the flush signal, this signal might be critical
      flush_dcache_o <= flush_dcache;
    end
  end
endmodule
