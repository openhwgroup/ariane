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
// Author: Matthias Baer <baermatt@student.ethz.ch>
// Author: Igor Loi <igor.loi@unibo.it>
// Author: Andreas Traber <atraber@student.ethz.ch>
// Author: Lukas Mueller <lukasmue@student.ethz.ch>
// Author: Florian Zaruba <zaruabf@iis.ee.ethz.ch>
//
// Date: 19.03.2017
// Description: Ariane ALU based on RI5CY's ALU


module alu
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter bit HasBranch = 1'b1,
    parameter type fu_data_t = logic
) (
    // Subsystem Clock - SUBSYSTEM
    input logic clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input logic rst_ni,
    // FU data needed to execute instruction - ISSUE_STAGE
    input fu_data_t fu_data_i,
    // ALU result - ISSUE_STAGE
    output logic [CVA6Cfg.XLEN-1:0] result_o,
    // ALU branch compare result - branch_unit
    output logic alu_branch_res_o
);

  logic [CVA6Cfg.XLEN-1:0] operand_a_rev;
  logic [            31:0] operand_a_rev32;
  logic [  CVA6Cfg.XLEN:0] operand_b_neg;
  logic [CVA6Cfg.XLEN+1:0] adder_result_ext_o;
  logic                    less;  // handles both signed and unsigned forms
  logic [            31:0] rolw;  // Rotate Left Word
  logic [            31:0] rorw;  // Rotate Right Word
  logic [31:0] orcbw, rev8w;
  logic [  $clog2(CVA6Cfg.XLEN) : 0] cpop;  // Count Population
  logic [$clog2(CVA6Cfg.XLEN)-1 : 0] lz_tz_count;  // Count Leading Zeros
  logic [                       4:0] lz_tz_wcount;  // Count Leading Zeros Word
  logic lz_tz_empty, lz_tz_wempty;
  logic [CVA6Cfg.XLEN-1:0] orcbw_result, rev8w_result;

  logic [CVA6Cfg.XLEN-1:0] brev8_reversed;
  logic [            31:0] unzip_gen;
  logic [            31:0] zip_gen;
  // bit reverse operand_a for left shifts and bit counting
  generate
    genvar k;
    for (k = 0; k < CVA6Cfg.XLEN; k++)
      assign operand_a_rev[k] = fu_data_i.operand_a[CVA6Cfg.XLEN-1-k];

    for (k = 0; k < 32; k++) assign operand_a_rev32[k] = fu_data_i.operand_a[31-k];
  endgenerate

  // ------
  // Adder
  // ------
  logic adder_op_b_negate;
  logic adder_z_flag;
  logic [CVA6Cfg.XLEN:0] adder_in_a, adder_in_b;
  logic [CVA6Cfg.XLEN-1:0] adder_result;
  logic [CVA6Cfg.XLEN-1:0] operand_a_bitmanip, bit_indx;

  assign adder_op_b_negate = fu_data_i.operation inside {EQ, NE, SUB, SUBW, ANDN, ORN, XNOR};

  always_comb begin
    operand_a_bitmanip = fu_data_i.operand_a;

    if (CVA6Cfg.RVB) begin
      if (CVA6Cfg.IS_XLEN64) begin
        unique case (fu_data_i.operation)
          SH1ADDUW:           operand_a_bitmanip = fu_data_i.operand_a[31:0] << 1;
          SH2ADDUW:           operand_a_bitmanip = fu_data_i.operand_a[31:0] << 2;
          SH3ADDUW:           operand_a_bitmanip = fu_data_i.operand_a[31:0] << 3;
          CTZW:               operand_a_bitmanip = operand_a_rev32;
          ADDUW, CPOPW, CLZW: operand_a_bitmanip = fu_data_i.operand_a[31:0];
          default:            ;
        endcase
      end
      unique case (fu_data_i.operation)
        SH1ADD:  operand_a_bitmanip = fu_data_i.operand_a << 1;
        SH2ADD:  operand_a_bitmanip = fu_data_i.operand_a << 2;
        SH3ADD:  operand_a_bitmanip = fu_data_i.operand_a << 3;
        CTZ:     operand_a_bitmanip = operand_a_rev;
        default: ;
      endcase
    end
  end

  // prepare operand a
  assign adder_in_a         = {operand_a_bitmanip, 1'b1};

  // prepare operand b
  assign operand_b_neg      = {fu_data_i.operand_b, 1'b0} ^ {CVA6Cfg.XLEN + 1{adder_op_b_negate}};
  assign adder_in_b         = operand_b_neg;

  // actual adder
  assign adder_result_ext_o = adder_in_a + adder_in_b;
  assign adder_result       = adder_result_ext_o[CVA6Cfg.XLEN:1];
  assign adder_z_flag       = ~|adder_result;

  // get the right branch comparison result
  if (HasBranch) begin
    always_comb begin : branch_resolve
      // set comparison by default
      case (fu_data_i.operation)
        EQ:       alu_branch_res_o = adder_z_flag;
        NE:       alu_branch_res_o = ~adder_z_flag;
        LTS, LTU: alu_branch_res_o = less;
        GES, GEU: alu_branch_res_o = ~less;
        default:  alu_branch_res_o = 1'b1;
      endcase
    end
  end else begin
    assign alu_branch_res_o = 1'b0;
  end

  // ---------
  // Shifts
  // ---------

  // TODO: this can probably optimized significantly
  logic                    shift_left;  // should we shift left
  logic                    shift_arithmetic;

  logic [CVA6Cfg.XLEN-1:0] shift_amt;  // amount of shift, to the right
  logic [CVA6Cfg.XLEN-1:0] shift_op_a;  // input of the shifter
  logic [            31:0] shift_op_a32;  // input to the 32 bit shift operation

  logic [CVA6Cfg.XLEN-1:0] shift_result;
  logic [            31:0] shift_result32;

  logic [  CVA6Cfg.XLEN:0] shift_right_result;
  logic [            32:0] shift_right_result32;

  logic [CVA6Cfg.XLEN-1:0] shift_left_result;
  logic [            31:0] shift_left_result32;

  assign shift_amt = fu_data_i.operand_b;

  assign shift_left = (fu_data_i.operation == SLL) | (CVA6Cfg.IS_XLEN64 && fu_data_i.operation == SLLW);

  assign shift_arithmetic = (fu_data_i.operation == SRA) | (CVA6Cfg.IS_XLEN64 && fu_data_i.operation == SRAW);

  // right shifts, we let the synthesizer optimize this
  logic [CVA6Cfg.XLEN:0] shift_op_a_64;
  logic [32:0] shift_op_a_32;

  // choose the bit reversed or the normal input for shift operand a
  assign shift_op_a           = shift_left ? operand_a_rev : fu_data_i.operand_a;
  assign shift_op_a32         = shift_left ? operand_a_rev32 : fu_data_i.operand_a[31:0];

  assign shift_op_a_64        = {shift_arithmetic & shift_op_a[CVA6Cfg.XLEN-1], shift_op_a};
  assign shift_op_a_32        = {shift_arithmetic & shift_op_a[31], shift_op_a32};

  assign shift_right_result   = $unsigned($signed(shift_op_a_64) >>> shift_amt[5:0]);

  assign shift_right_result32 = $unsigned($signed(shift_op_a_32) >>> shift_amt[4:0]);
  // bit reverse the shift_right_result for left shifts
  genvar j;
  generate
    for (j = 0; j < CVA6Cfg.XLEN; j++)
      assign shift_left_result[j] = shift_right_result[CVA6Cfg.XLEN-1-j];

    for (j = 0; j < 32; j++) assign shift_left_result32[j] = shift_right_result32[31-j];

  endgenerate

  assign shift_result   = shift_left ? shift_left_result : shift_right_result[CVA6Cfg.XLEN-1:0];
  assign shift_result32 = shift_left ? shift_left_result32 : shift_right_result32[31:0];

  // ------------
  // Comparisons
  // ------------

  always_comb begin
    logic sgn;
    sgn = 1'b0;

    if ((fu_data_i.operation == SLTS) ||
            (fu_data_i.operation == LTS)  ||
            (fu_data_i.operation == GES)  ||
            (fu_data_i.operation == MAX)  ||
            (fu_data_i.operation == MIN))
      sgn = 1'b1;

    less = ($signed({sgn & fu_data_i.operand_a[CVA6Cfg.XLEN-1], fu_data_i.operand_a}) <
            $signed({sgn & fu_data_i.operand_b[CVA6Cfg.XLEN-1], fu_data_i.operand_b}));
  end

  if (CVA6Cfg.RVB) begin : gen_bitmanip
    // Count Population + Count population Word

    popcount #(
        .INPUT_WIDTH(CVA6Cfg.XLEN)
    ) i_cpop_count (
        .data_i    (operand_a_bitmanip),
        .popcount_o(cpop)
    );

    // Count Leading/Trailing Zeros
    // 64b
    lzc #(
        .WIDTH(CVA6Cfg.XLEN),
        .MODE (1)
    ) i_clz_64b (
        .in_i(operand_a_bitmanip),
        .cnt_o(lz_tz_count),
        .empty_o(lz_tz_empty)
    );
    if (CVA6Cfg.IS_XLEN64) begin
      //32b
      lzc #(
          .WIDTH(32),
          .MODE (1)
      ) i_clz_32b (
          .in_i(operand_a_bitmanip[31:0]),
          .cnt_o(lz_tz_wcount),
          .empty_o(lz_tz_wempty)
      );
    end
  end

  if (CVA6Cfg.RVB) begin : gen_orcbw_rev8w_results
    assign orcbw = {
      {8{|fu_data_i.operand_a[31:24]}},
      {8{|fu_data_i.operand_a[23:16]}},
      {8{|fu_data_i.operand_a[15:8]}},
      {8{|fu_data_i.operand_a[7:0]}}
    };
    assign rev8w = {
      {fu_data_i.operand_a[7:0]},
      {fu_data_i.operand_a[15:8]},
      {fu_data_i.operand_a[23:16]},
      {fu_data_i.operand_a[31:24]}
    };
    if (CVA6Cfg.IS_XLEN64) begin : gen_64b
      assign orcbw_result = {
        {8{|fu_data_i.operand_a[63:56]}},
        {8{|fu_data_i.operand_a[55:48]}},
        {8{|fu_data_i.operand_a[47:40]}},
        {8{|fu_data_i.operand_a[39:32]}},
        orcbw
      };
      assign rev8w_result = {
        rev8w,
        {fu_data_i.operand_a[39:32]},
        {fu_data_i.operand_a[47:40]},
        {fu_data_i.operand_a[55:48]},
        {fu_data_i.operand_a[63:56]}
      };
    end else begin : gen_32b
      assign orcbw_result = orcbw;
      assign rev8w_result = rev8w;
    end
  end

  // ZKN gen block
  if (CVA6Cfg.ZKN && CVA6Cfg.RVB) begin : zkn_gen_block
    genvar i, m, n;
    // Generate brev8_reversed by reversing bits within each byte
    for (i = 0; i < (CVA6Cfg.XLEN / 8); i++) begin : brev8_gen
      for (m = 0; m < 8; m++) begin : reverse_bits
        // Reversing the order of bits within a single byte
        assign brev8_reversed[(i<<3)+m] = fu_data_i.operand_a[(i<<3)+(7-m)];
      end
    end
    // Generate zip and unzip results
    if (CVA6Cfg.IS_XLEN32) begin
      for (n = 0; n < 16; n++) begin : zip_unzip_gen
        // Assigning lower and upper half of operand into the even and odd positions of result
        assign zip_gen[n<<1] = fu_data_i.operand_a[n];
        assign zip_gen[(n<<1)+1] = fu_data_i.operand_a[n+16];
        // Assigning even and odd bits of operand into lower and upper halves of result
        assign unzip_gen[n] = fu_data_i.operand_a[n<<1];
        assign unzip_gen[n+16] = fu_data_i.operand_a[(n<<1)+1];
      end
    end
  end

  // -----------
  // Result MUX
  // -----------
  always_comb begin
    result_o = '0;
    if (CVA6Cfg.IS_XLEN64) begin
      unique case (fu_data_i.operation)
        // Add word: Ignore the upper bits and sign extend to 64 bit
        ADDW, SUBW: result_o = {{CVA6Cfg.XLEN - 32{adder_result[31]}}, adder_result[31:0]};
        SH1ADDUW, SH2ADDUW, SH3ADDUW: result_o = adder_result;
        // Shifts 32 bit
        SLLW, SRLW, SRAW:
        result_o = {{CVA6Cfg.XLEN - 32{shift_result32[31]}}, shift_result32[31:0]};
        default: ;
      endcase
    end
    unique case (fu_data_i.operation)
      // Standard Operations
      ANDL, ANDN: result_o = fu_data_i.operand_a & operand_b_neg[CVA6Cfg.XLEN:1];
      ORL, ORN: result_o = fu_data_i.operand_a | operand_b_neg[CVA6Cfg.XLEN:1];
      XORL, XNOR: result_o = fu_data_i.operand_a ^ operand_b_neg[CVA6Cfg.XLEN:1];
      // Adder Operations
      ADD, SUB, ADDUW, SH1ADD, SH2ADD, SH3ADD: result_o = adder_result;
      // Shift Operations
      SLL, SRL, SRA: result_o = (CVA6Cfg.IS_XLEN64) ? shift_result : shift_result32;
      // Comparison Operations
      SLTS, SLTU: result_o = {{CVA6Cfg.XLEN - 1{1'b0}}, less};
      default: ;  // default case to suppress unique warning
    endcase

    if (CVA6Cfg.RVB) begin
      // Index for Bitwise Rotation
      bit_indx = 1 << (fu_data_i.operand_b & (CVA6Cfg.XLEN - 1));
      if (CVA6Cfg.IS_XLEN64) begin
        // rolw, roriw, rorw
        rolw = ({{CVA6Cfg.XLEN-32{1'b0}},fu_data_i.operand_a[31:0]} << fu_data_i.operand_b[4:0]) | ({{CVA6Cfg.XLEN-32{1'b0}},fu_data_i.operand_a[31:0]} >> (CVA6Cfg.XLEN-32-fu_data_i.operand_b[4:0]));
        rorw = ({{CVA6Cfg.XLEN-32{1'b0}},fu_data_i.operand_a[31:0]} >> fu_data_i.operand_b[4:0]) | ({{CVA6Cfg.XLEN-32{1'b0}},fu_data_i.operand_a[31:0]} << (CVA6Cfg.XLEN-32-fu_data_i.operand_b[4:0]));
        unique case (fu_data_i.operation)
          CLZW, CTZW:
          result_o = (lz_tz_wempty) ? 32 : {{CVA6Cfg.XLEN - 5{1'b0}}, lz_tz_wcount};  // change
          ROLW: result_o = {{CVA6Cfg.XLEN - 32{rolw[31]}}, rolw};
          RORW, RORIW: result_o = {{CVA6Cfg.XLEN - 32{rorw[31]}}, rorw};
          default: ;
        endcase
      end
      unique case (fu_data_i.operation)
        // Integer minimum/maximum
        MAX:  result_o = less ? fu_data_i.operand_b : fu_data_i.operand_a;
        MAXU: result_o = less ? fu_data_i.operand_b : fu_data_i.operand_a;
        MIN:  result_o = ~less ? fu_data_i.operand_b : fu_data_i.operand_a;
        MINU: result_o = ~less ? fu_data_i.operand_b : fu_data_i.operand_a;

        // Single bit instructions operations
        BCLR, BCLRI: result_o = fu_data_i.operand_a & ~bit_indx;
        BEXT, BEXTI: result_o = {{CVA6Cfg.XLEN - 1{1'b0}}, |(fu_data_i.operand_a & bit_indx)};
        BINV, BINVI: result_o = fu_data_i.operand_a ^ bit_indx;
        BSET, BSETI: result_o = fu_data_i.operand_a | bit_indx;

        // Count Leading/Trailing Zeros
        CLZ, CTZ:
        result_o = (lz_tz_empty) ? ({{CVA6Cfg.XLEN - $clog2(CVA6Cfg.XLEN) {1'b0}}, lz_tz_count} + 1)
            : {{CVA6Cfg.XLEN - $clog2(CVA6Cfg.XLEN) {1'b0}}, lz_tz_count};

        // Count population
        CPOP, CPOPW: result_o = {{(CVA6Cfg.XLEN - ($clog2(CVA6Cfg.XLEN) + 1)) {1'b0}}, cpop};

        // Sign and Zero Extend
        SEXTB: result_o = {{CVA6Cfg.XLEN - 8{fu_data_i.operand_a[7]}}, fu_data_i.operand_a[7:0]};
        SEXTH: result_o = {{CVA6Cfg.XLEN - 16{fu_data_i.operand_a[15]}}, fu_data_i.operand_a[15:0]};
        ZEXTH: result_o = {{CVA6Cfg.XLEN - 16{1'b0}}, fu_data_i.operand_a[15:0]};

        // Bitwise Rotation
        ROL:
        result_o = (CVA6Cfg.IS_XLEN64) ? ((fu_data_i.operand_a << fu_data_i.operand_b[5:0]) | (fu_data_i.operand_a >> (CVA6Cfg.XLEN-fu_data_i.operand_b[5:0]))) : ((fu_data_i.operand_a << fu_data_i.operand_b[4:0]) | (fu_data_i.operand_a >> (CVA6Cfg.XLEN-fu_data_i.operand_b[4:0])));

        ROR, RORI:
        result_o = (CVA6Cfg.IS_XLEN64) ? ((fu_data_i.operand_a >> fu_data_i.operand_b[5:0]) | (fu_data_i.operand_a << (CVA6Cfg.XLEN-fu_data_i.operand_b[5:0]))) : ((fu_data_i.operand_a >> fu_data_i.operand_b[4:0]) | (fu_data_i.operand_a << (CVA6Cfg.XLEN-fu_data_i.operand_b[4:0])));

        ORCB: result_o = orcbw_result;
        REV8: result_o = rev8w_result;

        default:
        if (fu_data_i.operation == SLLIUW && CVA6Cfg.IS_XLEN64)
          result_o = {{CVA6Cfg.XLEN-32{1'b0}}, fu_data_i.operand_a[31:0]} << fu_data_i.operand_b[5:0];  // Left Shift 32 bit unsigned
      endcase
    end
    if (CVA6Cfg.RVZiCond) begin
      unique case (fu_data_i.operation)
        CZERO_EQZ:
        result_o = (|fu_data_i.operand_b) ? fu_data_i.operand_a : '0;  // move zero to rd if rs2 is equal to zero else rs1
        CZERO_NEZ:
        result_o = (|fu_data_i.operand_b) ? '0 : fu_data_i.operand_a; // move zero to rd if rs2 is nonzero else rs1
        default: ;  // default case to suppress unique warning
      endcase
    end
    // ZKN instructions
    if (CVA6Cfg.ZKN && CVA6Cfg.RVB) begin
      unique case (fu_data_i.operation)
        PACK:
        result_o = (CVA6Cfg.IS_XLEN32) ? ({fu_data_i.operand_b[15:0], fu_data_i.operand_a[15:0]}) : ({fu_data_i.operand_b[31:0], fu_data_i.operand_a[31:0]});
        PACK_H:
        result_o = (CVA6Cfg.IS_XLEN32) ? ({16'b0, fu_data_i.operand_b[7:0], fu_data_i.operand_a[7:0]}) : ({48'b0, fu_data_i.operand_b[7:0], fu_data_i.operand_a[7:0]});
        BREV8: result_o = brev8_reversed;
        default: ;
      endcase
      if (fu_data_i.operation == PACK_W && CVA6Cfg.IS_XLEN64)
        result_o = {
          {32{fu_data_i.operand_b[15]}}, {fu_data_i.operand_b[15:0]}, {fu_data_i.operand_a[15:0]}
        };
      if (fu_data_i.operation == UNZIP && CVA6Cfg.IS_XLEN32) result_o = unzip_gen;
      if (fu_data_i.operation == ZIP && CVA6Cfg.IS_XLEN32) result_o = zip_gen;
    end
  end
endmodule
