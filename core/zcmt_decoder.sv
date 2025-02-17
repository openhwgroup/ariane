// Licensed under the Solderpad Hardware Licence, Version 2.1 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Author: Farhan Ali Shah, 10xEngineers
// Date: 15.11.2024
// Description: ZCMT extension in the CVA6 core targeting the 32-bit embedded-class platforms (CV32A60x).
// ZCMT is a code-size reduction feature that utilizes compressed table jump instructions (cm.jt and cm.jalt) to
//reduce code size for embedded systems
//
module zcmt_decoder #(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type dcache_req_i_t = logic,
    parameter type dcache_req_o_t = logic,
    parameter type jvt_t = logic,
    parameter type branchpredict_sbe_t = logic
) (
    // Subsystem Clock - SUBSYSTEM
    input  logic                             clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input  logic                             rst_ni,
    // Instruction input - compressed_decoder
    input  logic          [            31:0] instr_i,
    // current PC - FRONTEND
    input  logic          [CVA6Cfg.VLEN-1:0] pc_i,
    // Intruction is of ZCMT extension - compressed_decoder
    input  logic                             is_zcmt_instr_i,
    // Instruction is illegal - compressed_decoder
    input  logic                             illegal_instr_i,
    // Instruction is compressed - compressed_decoder
    input  logic                             is_compressed_i,
    // JVT struct input - CSR
    input  jvt_t                             jvt_i,
    // Data cache request output - CACHE
    input  dcache_req_o_t                    req_port_i,
    // Instruction out - cvxif_compressed_if_driver
    output logic          [            31:0] instr_o,
    // Instruction is illegal out - cvxif_compressed_if_driver     
    output logic                             illegal_instr_o,
    // Instruction is compressed out - cvxif_compressed_if_driver
    output logic                             is_compressed_o,
    // Fetch stall - cvxif_compressed_if_driver
    output logic                             fetch_stall_o,
    // Data cache request input - CACHE
    output dcache_req_i_t                    req_port_o,
    // jump_address
    output logic          [CVA6Cfg.XLEN-1:0] jump_address_o
);

  // FSM States
  enum logic {
    IDLE,  // if ZCMT instruction then request sent to fetch the entry from jump table
    TABLE_JUMP  // Check the valid data from jump table and Calculate the offset for jump and create jal instruction
  }
      state_d, state_q;
  // Temporary registers
  // Physical address: jvt + (index <<2)
  logic [CVA6Cfg.VLEN-1:0] table_address;

  always_comb begin
    state_d               = state_q;
    illegal_instr_o       = 1'b0;
    is_compressed_o       = is_zcmt_instr_i || is_compressed_i;
    fetch_stall_o         = '0;
    jump_address_o        = '0;

    // cache request port
    req_port_o.data_wdata = '0;
    req_port_o.data_wuser = '0;
    req_port_o.data_req   = 1'b0;
    req_port_o.data_we    = 1'b0;
    req_port_o.data_be    = '0;
    req_port_o.data_size  = 2'b10;
    req_port_o.data_id    = 1'b1;
    req_port_o.kill_req   = 1'b0;
    req_port_o.tag_valid  = 1'b1;

    unique case (state_q)
      IDLE: begin
        fetch_stall_o = 1'b0;
        if (is_zcmt_instr_i) begin
          if (CVA6Cfg.XLEN == 32) begin  //It is only target for 32 bit targets in cva6 with No MMU
            table_address = {jvt_i.base, 6'b000000} + {24'h0, instr_i[7:2], 2'b00};
            req_port_o.address_index = table_address[9:0];
            req_port_o.address_tag = table_address[CVA6Cfg.VLEN-1:10];  // No MMU support
            state_d = TABLE_JUMP;
            req_port_o.data_req = 1'b1;
            fetch_stall_o = 1'b1;
          end else illegal_instr_o = 1'b1;
          // Condition may be extented for 64 bits embedded targets with No MMU
        end else begin
          illegal_instr_o = illegal_instr_i;
          instr_o         = instr_i;
          state_d         = IDLE;
        end
      end
      TABLE_JUMP: begin
        if (req_port_i.data_rvalid) begin
          // save the PC relative Xlen table jump address 
          jump_address_o = $unsigned($signed(req_port_i.data_rdata) - $signed(pc_i));
          if (instr_i[9:2] < 32) begin  // jal pc_offset, x0 for no return stack
            instr_o = {
              20'h0, 5'h0, riscv::OpcodeJal
            };  // immidiate assigned here (0) will be overwrite in decode stage with jump_address_o
          end else if ((instr_i[9:2] >= 32) & (instr_i[9:2] <= 255))  begin  //- jal pc_offset, x1 for return stack
            instr_o = {
              20'h0, 5'h1, riscv::OpcodeJal
            };  // immidiate assigned here (0) will be overwrite in decode stage with jump_address_o
          end else begin
            illegal_instr_o = 1'b1;
            instr_o         = instr_i;
          end
          state_d = IDLE;
        end else begin
          state_d = TABLE_JUMP;
        end
      end
      default: begin
        state_d = IDLE;
      end
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      state_q <= IDLE;

    end else begin
      state_q <= state_d;
    end
  end
endmodule
