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
// Date: 09.05.2017
// Description: Branch target calculation and comparison

module branch_unit #(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type bp_resolve_t = logic,
    parameter type branchpredict_sbe_t = logic,
    parameter type exception_t = logic,
    parameter type fu_data_t = logic
) (
    // Subsystem Clock - SUBSYSTEM
    input logic clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input logic rst_ni,
    // Virtualization mode state - CSR_REGFILE
    input logic v_i,
    // Debug mode state - CSR_REGFILE
    input logic debug_mode_i,
    // FU data needed to execute instruction - ISSUE_STAGE
    input fu_data_t fu_data_i,
    // Instruction PC - ISSUE_STAGE
    input logic [CVA6Cfg.VLEN-1:0] pc_i,
    // Is zcmt instruction - ISSUE_STAGE
    input logic is_zcmt_i,
    // Instruction is compressed - ISSUE_STAGE
    input logic is_compressed_instr_i,
    // Branch unit instruction is valid - ISSUE_STAGE
    input logic branch_valid_i,
    // ALU branch compare result - ALU
    input logic branch_comp_res_i,
    // Brach unit result - ISSUE_STAGE
    output logic [CVA6Cfg.VLEN-1:0] branch_result_o,
    // Information of branch prediction - ISSUE_STAGE
    input branchpredict_sbe_t branch_predict_i,
    // Signaling that we resolved the branch - ISSUE_STAGE
    output bp_resolve_t resolved_branch_o,
    // Branch is resolved, new entries can be accepted by scoreboard - ID_STAGE
    output logic resolve_branch_o,
    // Branch exception out - TO_BE_COMPLETED
    output exception_t branch_exception_o
);
  logic [CVA6Cfg.VLEN-1:0] target_address;
  logic [CVA6Cfg.VLEN-1:0] next_pc;

  // here we handle the various possibilities of mis-predicts
  always_comb begin : mispredict_handler
    // set the jump base, for JALR we need to look at the register, for all other control flow instructions we can take the current PC
    automatic logic [CVA6Cfg.VLEN-1:0] jump_base;
    // TODO(zarubaf): The ALU can be used to calculate the branch target
    jump_base = (fu_data_i.operation == ariane_pkg::JALR) ? fu_data_i.operand_a[CVA6Cfg.VLEN-1:0] : pc_i;

    resolve_branch_o = 1'b0;
    resolved_branch_o.target_address = {CVA6Cfg.VLEN{1'b0}};
    resolved_branch_o.is_taken = 1'b0;
    resolved_branch_o.valid = branch_valid_i;
    resolved_branch_o.is_mispredict = 1'b0;
    resolved_branch_o.cf_type = branch_predict_i.cf;
    // calculate next PC, depending on whether the instruction is compressed or not this may be different
    // TODO(zarubaf): We already calculate this a couple of times, maybe re-use?
    next_pc                          = pc_i + ((is_compressed_instr_i) ? {{CVA6Cfg.VLEN-2{1'b0}}, 2'h2} : {{CVA6Cfg.VLEN-3{1'b0}}, 3'h4});
    // calculate target address simple 64 bit addition
    target_address = $unsigned($signed(jump_base) + $signed(fu_data_i.imm[CVA6Cfg.VLEN-1:0]));
    // on a JALR we are supposed to reset the LSB to 0 (according to the specification)
    if (fu_data_i.operation == ariane_pkg::JALR) target_address[0] = 1'b0;
    // we need to put the branch target address into rd, this is the result of this unit
    branch_result_o = next_pc;
    resolved_branch_o.pc = pc_i;
    // There are only three sources of mispredicts:
    // 1. Branches
    // 2. Jumps to register addresses
    // 3. Zcmt instructions
    if (branch_valid_i) begin
      // write target address which goes to PC Gen or select target address if zcmt
      resolved_branch_o.target_address = (branch_comp_res_i) ? target_address : next_pc;
      resolved_branch_o.is_taken = branch_comp_res_i;
      if (CVA6Cfg.RVZCMT) begin
        if (is_zcmt_i) begin
          // Unconditional jump handling
          resolved_branch_o.is_mispredict = 1'b1;  // miss prediction for ZCMT 
          resolved_branch_o.cf_type = ariane_pkg::JumpR;
        end
      end
      // check the outcome of the branch speculation
      if (ariane_pkg::op_is_branch(fu_data_i.operation)) begin
        // Set the `cf_type` of the output as `branch`, this will update the BHT.
        resolved_branch_o.cf_type = ariane_pkg::Branch;
        // If the ALU comparison does not agree with the BHT prediction set the resolution as mispredicted.
        resolved_branch_o.is_mispredict  = branch_comp_res_i != (branch_predict_i.cf == ariane_pkg::Branch);
      end
      if (fu_data_i.operation == ariane_pkg::JALR
          // check if the address of the jump register is correct and that we actually predicted
          && (branch_predict_i.cf == ariane_pkg::NoCF || target_address != branch_predict_i.predict_address)) begin
        resolved_branch_o.is_mispredict = 1'b1;
        // update BTB only if this wasn't a return
        if (branch_predict_i.cf != ariane_pkg::Return)
          resolved_branch_o.cf_type = ariane_pkg::JumpR;
      end
      // to resolve the branch in ID
      resolve_branch_o = 1'b1;
    end
  end
  // use ALU exception signal for storing instruction fetch exceptions if
  // the target address is not aligned to a 2 byte boundary
  //
  logic jump_taken;
  always_comb begin : exception_handling

    // Do a jump if it is either unconditional jump (JAL | JALR) or `taken` conditional jump
    branch_exception_o.cause = riscv::INSTR_ADDR_MISALIGNED;
    branch_exception_o.valid = 1'b0;
    if (CVA6Cfg.TvalEn)
      branch_exception_o.tval = {{CVA6Cfg.XLEN - CVA6Cfg.VLEN{pc_i[CVA6Cfg.VLEN-1]}}, pc_i};
    else branch_exception_o.tval = '0;
    branch_exception_o.tval2 = {CVA6Cfg.GPLEN{1'b0}};
    branch_exception_o.tinst = '0;
    branch_exception_o.gva   = CVA6Cfg.RVH ? v_i : 1'b0;
    // Only throw instruction address misaligned exception if this is indeed a `taken` conditional branch or
    // an unconditional jump
    if (!CVA6Cfg.RVC) begin
      jump_taken = !(ariane_pkg::op_is_branch(fu_data_i.operation)) ||
          ((ariane_pkg::op_is_branch(fu_data_i.operation)) && branch_comp_res_i);
      if (branch_valid_i && (target_address[0] || target_address[1]) && jump_taken) begin
        branch_exception_o.valid = 1'b1;
      end
    end
  end
endmodule
