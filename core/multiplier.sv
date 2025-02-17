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
// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
//
// Description: Multiplication Unit with one pipeline register
//              This unit relies on retiming features of the synthesizer
//


module multiplier
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty
) (
    // Subsystem Clock - SUBSYSTEM
    input  logic                             clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input  logic                             rst_ni,
    // Multiplier transaction ID - Mult
    input  logic [CVA6Cfg.TRANS_ID_BITS-1:0] trans_id_i,
    // Multiplier instruction is valid - Mult
    input  logic                             mult_valid_i,
    // Multiplier operation - Mult
    input  fu_op                             operation_i,
    // A operand - Mult
    input  logic [         CVA6Cfg.XLEN-1:0] operand_a_i,
    // B operand - Mult
    input  logic [         CVA6Cfg.XLEN-1:0] operand_b_i,
    // Multiplier result - Mult
    output logic [         CVA6Cfg.XLEN-1:0] result_o,
    // Mutliplier result is valid - Mult
    output logic                             mult_valid_o,
    // Multiplier transaction ID - Mult
    output logic [CVA6Cfg.TRANS_ID_BITS-1:0] mult_trans_id_o
);
  // Carry-less multiplication
  logic [CVA6Cfg.XLEN-1:0]
      clmul_q, clmul_d, clmulr_q, clmulr_d, operand_a, operand_b, operand_a_rev, operand_b_rev;
  logic clmul_rmode, clmul_hmode;

  if (CVA6Cfg.RVB) begin : gen_bitmanip
    // checking for clmul_rmode and clmul_hmode
    assign clmul_rmode = (operation_i == CLMULR);
    assign clmul_hmode = (operation_i == CLMULH);

    // operand_a and b reverse generator
    for (genvar i = 0; i < CVA6Cfg.XLEN; i++) begin
      assign operand_a_rev[i] = operand_a_i[(CVA6Cfg.XLEN-1)-i];
      assign operand_b_rev[i] = operand_b_i[(CVA6Cfg.XLEN-1)-i];
    end

    // operand_a and operand_b selection
    assign operand_a = (clmul_rmode | clmul_hmode) ? operand_a_rev : operand_a_i;
    assign operand_b = (clmul_rmode | clmul_hmode) ? operand_b_rev : operand_b_i;

    // implementation
    always_comb begin
      clmul_d = '0;
      for (int i = 0; i <= CVA6Cfg.XLEN; i++) begin
        clmul_d = (|((operand_b >> i) & 1)) ? clmul_d ^ (operand_a << i) : clmul_d;
      end
    end

    // clmulr + clmulh result generator
    for (genvar i = 0; i < CVA6Cfg.XLEN; i++) begin
      assign clmulr_d[i] = clmul_d[(CVA6Cfg.XLEN-1)-i];
    end
  end

  // Pipeline register
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] trans_id_q;
  logic                             mult_valid_q;
  fu_op operator_d, operator_q;
  logic [CVA6Cfg.XLEN*2-1:0] mult_result_d, mult_result_q;

  // control registers
  logic sign_a, sign_b;
  logic mult_valid;

  // control signals
  assign mult_valid_o = mult_valid_q;
  assign mult_trans_id_o = trans_id_q;

  assign mult_valid      = mult_valid_i && (operation_i inside {MUL, MULH, MULHU, MULHSU, MULW, CLMUL, CLMULH, CLMULR});

  // Sign Select MUX
  always_comb begin
    sign_a = 1'b0;
    sign_b = 1'b0;

    // signed multiplication
    if (operation_i == MULH) begin
      sign_a = 1'b1;
      sign_b = 1'b1;
      // signed - unsigned multiplication
    end else if (operation_i == MULHSU) begin
      sign_a = 1'b1;
      // unsigned multiplication
    end else begin
      sign_a = 1'b0;
      sign_b = 1'b0;
    end
  end


  // single stage version
  assign mult_result_d = $signed(
      {operand_a_i[CVA6Cfg.XLEN-1] & sign_a, operand_a_i}
  ) * $signed(
      {operand_b_i[CVA6Cfg.XLEN-1] & sign_b, operand_b_i}
  );


  assign operator_d = operation_i;

  always_comb begin : p_selmux
    unique case (operator_q)
      MULH, MULHU, MULHSU: result_o = mult_result_q[CVA6Cfg.XLEN*2-1:CVA6Cfg.XLEN];
      CLMUL:               result_o = clmul_q;
      CLMULH:              result_o = clmulr_q >> 1;
      CLMULR:              result_o = clmulr_q;
      // MUL performs an CVA6Cfg.XLEN-bit×CVA6Cfg.XLEN-bit multiplication and places the lower CVA6Cfg.XLEN bits in the destination register
      default: begin
        if (operator_q == MULW && CVA6Cfg.IS_XLEN64) result_o = sext32to64(mult_result_q[31:0]);
        else result_o = mult_result_q[CVA6Cfg.XLEN-1:0];  // including MUL
      end
    endcase
  end
  if (CVA6Cfg.RVB) begin
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (~rst_ni) begin
        clmul_q  <= '0;
        clmulr_q <= '0;
      end else begin
        clmul_q  <= clmul_d;
        clmulr_q <= clmulr_d;
      end
    end
  end
  // -----------------------
  // Output pipeline register
  // -----------------------
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      mult_valid_q  <= '0;
      trans_id_q    <= '0;
      operator_q    <= MUL;
      mult_result_q <= '0;
    end else begin
      // Input silencing
      trans_id_q    <= trans_id_i;
      // Output Register
      mult_valid_q  <= mult_valid;
      operator_q    <= operator_d;
      mult_result_q <= mult_result_d;
    end
  end
endmodule
