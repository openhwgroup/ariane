// Copyright 2024 Thales DIS France SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Guillaume Chauvon

// Functional Unit for the CoreV-X-Interface
// Handles Result interface and exception forwarding to next stages.


module cvxif_fu
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type exception_t = logic,
    parameter type x_result_t = logic
) (
    // Subsystem Clock - SUBSYSTEM
    input  logic                                   clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input  logic                                   rst_ni,
    // CVXIF instruction is valid - ISSUE_STAGE
    input  logic                                   x_valid_i,
    // Transaction ID - ISSUE_STAGE
    input  logic       [CVA6Cfg.TRANS_ID_BITS-1:0] x_trans_id_i,
    // Instruction is illegal, determined during CVXIF issue transaction - ISSUE_STAGE
    input  logic                                   x_illegal_i,
    // Offloaded instruction - ISSUE_STAGE
    input  logic       [                     31:0] x_off_instr_i,
    // CVXIF is ready - ISSUE_STAGE
    output logic                                   x_ready_o,
    // CVXIF result transaction ID - ISSUE_STAGE
    output logic       [CVA6Cfg.TRANS_ID_BITS-1:0] x_trans_id_o,
    // CVXIF exception - ISSUE_STAGE
    output exception_t                             x_exception_o,
    // CVXIF FU result - ISSUE_STAGE
    output logic       [         CVA6Cfg.XLEN-1:0] x_result_o,
    // CVXIF result valid - ISSUE_STAGE
    output logic                                   x_valid_o,
    // CVXIF write enable - ISSUE_STAGE
    output logic                                   x_we_o,
    // CVXIF destination register - ISSUE_STAGE
    output logic       [                      4:0] x_rd_o,
    // CVXIF result interface
    input  logic                                   result_valid_i,
    input  x_result_t                              result_i,
    output logic                                   result_ready_o
);



  assign result_ready_o = 1'b1;

  assign x_ready_o = 1'b1; // Readyness of cvxif_fu is determined in issue stage by CVXIF issue interface
  // Result signals
  assign x_valid_o = x_illegal_i || result_valid_i;
  assign x_result_o = result_i.data;
  assign x_trans_id_o = x_illegal_i ? x_trans_id_i : result_i.id;
  assign x_we_o = result_i.we;
  assign x_rd_o = result_i.rd;

  // Handling of illegal instruction exception
  always_comb begin
    x_exception_o.valid = x_illegal_i;
    x_exception_o.cause = x_illegal_i ? riscv::ILLEGAL_INSTR : '0;
    if (CVA6Cfg.TvalEn)
      x_exception_o.tval = x_off_instr_i;  // TODO Optimization : Set exception in IRO.
  end

endmodule
