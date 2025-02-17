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
// Description: purely combinatorial PMP unit (with extraction for more complex configs such as NAPOT)

module pmp
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty
) (
    // Input
    input logic [CVA6Cfg.PLEN-1:0] addr_i,
    input riscv::pmp_access_t access_type_i,
    input riscv::priv_lvl_t priv_lvl_i,
    // Configuration
    input logic [avoid_neg(CVA6Cfg.NrPMPEntries-1):0][CVA6Cfg.PLEN-3:0] conf_addr_i,
    input riscv::pmpcfg_t [avoid_neg(CVA6Cfg.NrPMPEntries-1):0] conf_i,
    // Output
    output logic allow_o
);
  // if there are no PMPs we can always grant the access.
  if (CVA6Cfg.NrPMPEntries > 0) begin : gen_pmp
    logic [(CVA6Cfg.NrPMPEntries > 0 ? CVA6Cfg.NrPMPEntries-1 : 0):0] match;

    for (genvar i = 0; i < CVA6Cfg.NrPMPEntries; i++) begin
      logic [CVA6Cfg.PLEN-3:0] conf_addr_prev;

      assign conf_addr_prev = (i == 0) ? '0 : conf_addr_i[i-1];

      pmp_entry #(
          .CVA6Cfg(CVA6Cfg)
      ) i_pmp_entry (
          .addr_i          (addr_i),
          .conf_addr_i     (conf_addr_i[i]),
          .conf_addr_prev_i(conf_addr_prev),
          .conf_addr_mode_i(conf_i[i].addr_mode),
          .match_o         (match[i])
      );
    end

    always_comb begin
      int i;

      allow_o = 1'b0;
      for (i = 0; i < CVA6Cfg.NrPMPEntries; i++) begin
        // either we are in S or U mode or the config is locked in which
        // case it also applies in M mode
        if (priv_lvl_i != riscv::PRIV_LVL_M || conf_i[i].locked) begin
          if (match[i]) begin
            if ((access_type_i & conf_i[i].access_type) != access_type_i) allow_o = 1'b0;
            else allow_o = 1'b1;
            break;
          end
        end
      end
      if (i == CVA6Cfg.NrPMPEntries) begin  // no PMP entry matched the address
        // allow all accesses from M-mode for no pmp match
        if (priv_lvl_i == riscv::PRIV_LVL_M) allow_o = 1'b1;
        // disallow accesses for all other modes
        else
          allow_o = 1'b0;
      end
    end
  end else assign allow_o = 1'b1;

endmodule
