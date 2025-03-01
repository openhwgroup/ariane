// Copyright 2025 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Original author: Gianmarco Ottavi, University of Bologna
// Description: Private history BHT

module bht2lvl #(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter int unsigned NR_ENTRIES = 256,
    parameter int unsigned HISTORY_LENGTH = 3,
    parameter type bht_update_t = logic
) (
    input  logic                                                      clk_i,
    input  logic                                                      rst_ni,
    input  logic                                                      flush_i,
    input  logic                        [           CVA6Cfg.VLEN-1:0] vpc_i,
    input  bht_update_t                                               bht_update_i,
    // we potentially need INSTR_PER_FETCH predictions/cycle
    output ariane_pkg::bht_prediction_t [CVA6Cfg.INSTR_PER_FETCH-1:0] bht_prediction_o
);

  // the last bit is always zero, we don't need it for indexing
  localparam OFFSET = CVA6Cfg.RVC == 1'b1 ? 1 : 2;
  // re-shape the branch history table
  localparam NR_ROWS = NR_ENTRIES / CVA6Cfg.INSTR_PER_FETCH;
  // number of bits needed to index the row
  localparam ROW_ADDR_BITS = $clog2(CVA6Cfg.INSTR_PER_FETCH);
  localparam ROW_INDEX_BITS = CVA6Cfg.RVC == 1'b1 ? $clog2(CVA6Cfg.INSTR_PER_FETCH) : 1;
  // number of bits we should use for prediction
  localparam PREDICTION_BITS = $clog2(NR_ROWS) + OFFSET + ROW_ADDR_BITS;

  struct packed {
    logic valid;
    logic [HISTORY_LENGTH-1:0] hist;
    logic [2**HISTORY_LENGTH-1:0][1:0] saturation_counter;
  }
      bht_d[NR_ROWS-1:0][CVA6Cfg.INSTR_PER_FETCH-1:0],
      bht_q[NR_ROWS-1:0][CVA6Cfg.INSTR_PER_FETCH-1:0];


  logic [$clog2(NR_ROWS)-1:0] index, update_pc;
  logic [HISTORY_LENGTH-1:0] update_hist;
  logic [ROW_INDEX_BITS-1:0] update_row_index;

  assign index       = vpc_i[PREDICTION_BITS-1:ROW_ADDR_BITS+OFFSET];
  assign update_pc   = bht_update_i.pc[PREDICTION_BITS-1:ROW_ADDR_BITS+OFFSET];
  assign update_hist = bht_q[update_pc][update_row_index].hist;

  if (CVA6Cfg.RVC) begin : gen_update_row_index
    assign update_row_index = bht_update_i.pc[ROW_ADDR_BITS+OFFSET-1:OFFSET];
  end else begin
    assign update_row_index = '0;
  end


  logic [1:0] saturation_counter;

  // Get the current history of the entry
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0][HISTORY_LENGTH-1:0] read_history;
  for (genvar i = 0; i < CVA6Cfg.INSTR_PER_FETCH; i++) begin
    assign read_history[i] = bht_q[index][i].hist;
  end

  // prediction assignment
  for (genvar i = 0; i < CVA6Cfg.INSTR_PER_FETCH; i++) begin : gen_bht_output
    assign bht_prediction_o[i].valid = bht_q[index][i].valid;
    assign bht_prediction_o[i].taken = bht_q[index][i].saturation_counter[read_history[i]][1] == 1'b1;
  end

  always_comb begin : update_bht
    bht_d = bht_q;
    saturation_counter = bht_q[update_pc][update_row_index].saturation_counter[update_hist];

    if (bht_update_i.valid) begin
      bht_d[update_pc][update_row_index].valid = 1'b1;

      if (saturation_counter == 2'b11) begin
        // we can safely decrease it
        if (!bht_update_i.taken)
          bht_d[update_pc][update_row_index].saturation_counter[update_hist] = saturation_counter - 1;
        // then check if it saturated in the negative regime e.g.: branch not taken
      end else if (saturation_counter == 2'b00) begin
        // we can safely increase it
        if (bht_update_i.taken)
          bht_d[update_pc][update_row_index].saturation_counter[update_hist] = saturation_counter + 1;
      end else begin  // otherwise we are not in any boundaries and can decrease or increase it
        if (bht_update_i.taken)
          bht_d[update_pc][update_row_index].saturation_counter[update_hist] = saturation_counter + 1;
        else
          bht_d[update_pc][update_row_index].saturation_counter[update_hist] = saturation_counter - 1;
      end

      bht_d[update_pc][update_row_index].hist = {
        update_hist[HISTORY_LENGTH-2:0], bht_update_i.taken
      };
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      for (int unsigned i = 0; i < NR_ROWS; i++) begin
        for (int j = 0; j < CVA6Cfg.INSTR_PER_FETCH; j++) begin
          bht_q[i][j] <= '0;
          for (int k = 0; k < 2 ** HISTORY_LENGTH; k++) begin
            bht_q[i][j].saturation_counter[k] <= 2'b10;
          end
        end
      end
    end else begin
      // evict all entries
      if (flush_i) begin
        for (int i = 0; i < NR_ROWS; i++) begin
          for (int j = 0; j < CVA6Cfg.INSTR_PER_FETCH; j++) begin
            bht_q[i][j].valid <= 1'b0;
            bht_q[i][j].hist  <= '0;
            for (int k = 0; k < 2 ** HISTORY_LENGTH; k++) begin
              bht_q[i][j].saturation_counter[k] <= 2'b10;
            end
          end
        end
      end else begin
        bht_q <= bht_d;
      end
    end
  end


endmodule
