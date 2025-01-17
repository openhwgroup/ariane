// Copyright 2024 Thales DIS France SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Guillaume Chauvon

module cvxif_compressed_if_driver #(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type x_compressed_req_t = logic,
    parameter type x_compressed_resp_t = logic
) (
    // Subsystem Clock - SUBSYSTEM
    input logic                    clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input logic                    rst_ni,
    // CVA6 Hart id
    input logic [CVA6Cfg.XLEN-1:0] hart_id_i,

    input logic [CVA6Cfg.NrIssuePorts-1:0]       is_compressed_i,
    input logic [CVA6Cfg.NrIssuePorts-1:0]       is_illegal_i,
    input logic [CVA6Cfg.NrIssuePorts-1:0]       instruction_valid_i,
    input logic [CVA6Cfg.NrIssuePorts-1:0][31:0] instruction_i,

    output logic               [CVA6Cfg.NrIssuePorts-1:0]       is_compressed_o,
    output logic               [CVA6Cfg.NrIssuePorts-1:0]       is_illegal_o,
    output logic               [CVA6Cfg.NrIssuePorts-1:0][31:0] instruction_o,
    input  logic                                                stall_i,
    output logic               [CVA6Cfg.NrIssuePorts-1:0]       stall_o,
    // CVXIF Compressed interface
    input  logic                                                compressed_ready_i,
    input  x_compressed_resp_t                                  compressed_resp_i,
    output logic                                                compressed_valid_o,
    output x_compressed_req_t                                   compressed_req_o
);


  always_comb begin
    is_illegal_o            = is_illegal_i;
    instruction_o           = instruction_i;
    is_compressed_o         = is_compressed_i;
    compressed_valid_o      = 1'b0;
    compressed_req_o.instr  = '0;
    compressed_req_o.hartid = hart_id_i;
    stall_o[0]              = stall_i;
    stall_o[1]              = 1'b0;
    if (is_illegal_i[0]) begin
      compressed_valid_o = is_illegal_i[0] && instruction_valid_i[0];
      compressed_req_o.instr = instruction_i[0][15:0];
      is_illegal_o[0] = ~compressed_resp_i.accept;
      instruction_o[0] = compressed_resp_i.accept ? compressed_resp_i.instr : instruction_i[0];
      is_compressed_o[0] = compressed_resp_i.accept ? 1'b0 : is_compressed_i[0];
      if (~stall_i) begin
        // Propagate stall from macro decoder or wait for compressed ready if compressed transaction is happening.
        // Stall if both instruction are illegal
        stall_o[0] = (compressed_valid_o && ~compressed_ready_i);
        if (CVA6Cfg.SuperscalarEn) begin
          stall_o[1] = is_illegal_i[1];
        end
      end
    end
    if (CVA6Cfg.SuperscalarEn) begin
      if (~is_illegal_i[0] && is_illegal_i[1]) begin  // 2nd instruction is illegal
        compressed_valid_o = is_illegal_i[1] && instruction_valid_i[1];
        compressed_req_o.instr = instruction_i[1][15:0];
        is_illegal_o[1] = ~compressed_resp_i.accept;
        instruction_o[1] = compressed_resp_i.accept ? compressed_resp_i.instr : instruction_i[1];
        is_compressed_o[1] = compressed_resp_i.accept ? 1'b0 : is_compressed_i[1];
        stall_o[1] = (compressed_valid_o && ~compressed_ready_i);
      end
    end
  end

endmodule
