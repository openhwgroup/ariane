// Copyright 2024 Thales DIS France SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Guillaume Chauvon

module cvxif_issue_register_commit_if_driver #(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type x_issue_req_t = logic,
    parameter type x_issue_resp_t = logic,
    parameter type x_register_t = logic,
    parameter type x_commit_t = logic
) (
    // CVA6 inputs
    input logic clk_i,
    input logic rst_ni,
    input logic flush_i,
    input logic [CVA6Cfg.XLEN-1:0] hart_id_i,
    // CVXIF Issue interface
    input logic issue_ready_i,
    input x_issue_resp_t issue_resp_i,
    output logic issue_valid_o,
    output x_issue_req_t issue_req_o,
    // CVXIF Register interface
    input logic register_ready_i,
    output logic register_valid_o,
    output x_register_t register_o,
    // CVXIF Commit interface
    output logic commit_valid_o,
    output x_commit_t commit_o,
    // IRO in/out
    input logic valid_i,
    input logic [31:0] x_off_instr_i,
    input logic [CVA6Cfg.TRANS_ID_BITS-1:0] x_trans_id_i,
    input [(CVA6Cfg.NrRgprPorts/CVA6Cfg.NrIssuePorts)-1:0][CVA6Cfg.XLEN-1:0] register_i,
    input logic [(CVA6Cfg.NrRgprPorts/CVA6Cfg.NrIssuePorts)-1:0] rs_valid_i
);
  // X_ISSUE_REGISTER_SPLIT = 0 : Issue and register transactions are synchrone
  // Mandatory assignement
  assign register_valid_o  = issue_valid_o;
  assign register_o.hartid = issue_req_o.hartid;
  assign register_o.id     = issue_req_o.id;

  always_comb begin
    issue_valid_o       = valid_i && ~flush_i;
    issue_req_o.instr   = x_off_instr_i;
    issue_req_o.hartid  = hart_id_i;
    issue_req_o.id      = x_trans_id_i;
    register_o.rs       = register_i;
    register_o.rs_valid = rs_valid_i;
  end

  /* WARNING */
  // Always commit since speculation in execute in not possible : TODO to be verified

  // Always do commit transaction with issue
  // If instruction goes to execute then it is not speculative
  assign commit_valid_o       = issue_valid_o && issue_ready_i;
  assign commit_o.hartid      = issue_req_o.hartid;
  assign commit_o.id          = issue_req_o.id;
  assign commit_o.commit_kill = 1'b0;

endmodule
