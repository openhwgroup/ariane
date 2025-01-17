// Copyright 2019 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: Moritz Schneider, ETH Zurich
// Date: 2.10.2019
// Description: single PMP entry

module pmp_entry #(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter int unsigned PLEN = 56,
    parameter int unsigned PMP_LEN = 54
) (
    // Input
    input logic [CVA6Cfg.PLEN-1:0] addr_i,

    // Configuration
    input logic [CVA6Cfg.PLEN-3:0] conf_addr_i,
    input logic [CVA6Cfg.PLEN-3:0] conf_addr_prev_i,
    input riscv::pmp_addr_mode_t conf_addr_mode_i,

    // Output
    output logic match_o
);
  logic [CVA6Cfg.PLEN-1:0] conf_addr_n;
  logic [$clog2(CVA6Cfg.PLEN)-1:0] trail_ones;
  logic [CVA6Cfg.PLEN-1:0] base;
  logic [CVA6Cfg.PLEN-1:0] mask;
  int unsigned size;
  assign conf_addr_n = {2'b11, ~conf_addr_i};
  lzc #(
      .WIDTH(CVA6Cfg.PLEN),
      .MODE (1'b0)
  ) i_lzc (
      .in_i   (conf_addr_n),
      .cnt_o  (trail_ones),
      .empty_o()
  );

  always_comb begin
    case (conf_addr_mode_i)
      riscv::TOR: begin
        base = '0;
        mask = '0;
        size = '0;
        // check that the requested address is in between the two
        // configuration addresses
        if (addr_i >= ({2'b0, conf_addr_prev_i} << 2) && addr_i < ({2'b0, conf_addr_i} << 2)) begin
          match_o = 1'b1;
        end else match_o = 1'b0;

        // synthesis translate_off
        if (match_o == 0) begin
          assert (addr_i >= ({2'b0, conf_addr_i} << 2) || addr_i < ({2'b0, conf_addr_prev_i} << 2));
        end else begin
          assert (addr_i < ({2'b0, conf_addr_i} << 2) && addr_i >= ({2'b0, conf_addr_prev_i} << 2));
        end
        // synthesis translate_on

      end
      riscv::NAPOT: begin

        // use the extracted trailing ones
        size = {{(32 - $clog2(CVA6Cfg.PLEN)) {1'b0}}, trail_ones} + 3;

        mask = '1 << size;
        base = ({2'b0, conf_addr_i} << 2) & mask;
        match_o = (addr_i & mask) == base ? 1'b1 : 1'b0;

        // synthesis translate_off
        // size extract checks
        assert (size >= 2);
        if (conf_addr_mode_i == riscv::NAPOT) begin
          assert (size > 2);
          if (size < CVA6Cfg.PLEN - 2) assert (conf_addr_i[size-3] == 0);
          for (int i = 0; i < CVA6Cfg.PLEN - 2; i++) begin
            if (size > 3 && i <= size - 4) begin
              assert (conf_addr_i[i] == 1);  // check that all the rest are ones
            end
          end
        end

        if (size < CVA6Cfg.PLEN - 1) begin
          if (base + 2 ** size > base) begin  // check for overflow
            if (match_o == 0) begin
              assert (addr_i >= base + 2 ** size || addr_i < base);
            end else begin
              assert (addr_i < base + 2 ** size && addr_i >= base);
            end
          end else begin
            if (match_o == 0) begin
              assert (addr_i - 2 ** size >= base || addr_i < base);
            end else begin
              assert (addr_i - 2 ** size < base && addr_i >= base);
            end
          end
        end
        // synthesis translate_on

      end
      riscv::OFF: begin
        match_o = 1'b0;
        base = '0;
        mask = '0;
        size = '0;
      end
      default: begin
        match_o = 0;
        base = '0;
        mask = '0;
        size = '0;
      end
    endcase
  end

endmodule
