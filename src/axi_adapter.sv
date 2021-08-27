/* Copyright 2018 ETH Zurich and University of Bologna.
 * Copyright and related rights are licensed under the Solderpad Hardware
 * License, Version 0.51 (the “License”); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
 * or agreed to in writing, software, hardware and materials distributed under
 * this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 * File:  axi_adapter.sv
 * Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
 * Date:   1.8.2018
 *
 * Description: Manages communication with the AXI Bus
 */
//import std_cache_pkg::*;

module axi_adapter #(
  parameter int unsigned DATA_WIDTH            = 256,
  parameter logic        CRITICAL_WORD_FIRST   = 0, // the AXI subsystem needs to support wrapping reads for this feature
  parameter int unsigned AXI_ID_WIDTH          = 10,
  parameter int unsigned CACHELINE_BYTE_OFFSET = 8
)(
  input  logic                             clk_i,  // Clock
  input  logic                             rst_ni, // Asynchronous reset active low

  input  logic                             req_i,
  input  ariane_axi::ad_req_t              type_i,
  output logic                             gnt_o,
  output logic [AXI_ID_WIDTH-1:0]          gnt_id_o,
  input  logic [riscv::XLEN-1:0]           addr_i,
  input  logic                             we_i,
  input  logic [(DATA_WIDTH/riscv::XLEN)-1:0][riscv::XLEN-1:0] wdata_i,
  input  logic [(DATA_WIDTH/riscv::XLEN)-1:0][(riscv::XLEN/8)-1:0]  be_i,
  input  logic [1:0]                       size_i,
  input  logic [AXI_ID_WIDTH-1:0]          id_i,
  // read port
  output logic                             valid_o,
  output logic [(DATA_WIDTH/riscv::XLEN)-1:0][riscv::XLEN-1:0] rdata_o,
  output logic [AXI_ID_WIDTH-1:0]          id_o,
  // critical word - read port
  output logic [riscv::XLEN-1:0]                      critical_word_o,
  output logic                             critical_word_valid_o,
  // AXI port
  output ariane_axi::req_t                 axi_req_o,
  input  ariane_axi::resp_t                axi_resp_i
);
  localparam BURST_SIZE = DATA_WIDTH/riscv::XLEN-1;
  localparam ADDR_INDEX = ($clog2(DATA_WIDTH/riscv::XLEN) > 0) ? $clog2(DATA_WIDTH/riscv::XLEN) : 1;

  enum logic [3:0] {
    IDLE, WAIT_B_VALID, WAIT_AW_READY, WAIT_LAST_W_READY, WAIT_LAST_W_READY_AW_READY, WAIT_AW_READY_BURST,
    WAIT_R_VALID, WAIT_R_VALID_MULTIPLE, COMPLETE_READ
  } state_q, state_d;

  // counter for AXI transfers
  logic [ADDR_INDEX-1:0] cnt_d, cnt_q;
  logic [(DATA_WIDTH/riscv::XLEN)-1:0][riscv::XLEN-1:0] cache_line_d, cache_line_q;
  // save the address for a read, as we allow for non-cacheline aligned accesses
  logic [(DATA_WIDTH/riscv::XLEN)-1:0] addr_offset_d, addr_offset_q;
  logic [AXI_ID_WIDTH-1:0]    id_d, id_q;
  logic [ADDR_INDEX-1:0]      index;

  always_comb begin : axi_fsm
    // Default assignments
    axi_req_o.aw_valid  = 1'b0;
    axi_req_o.aw.addr   = addr_i;
    axi_req_o.aw.prot   = 3'b0;
    axi_req_o.aw.region = 4'b0;
    axi_req_o.aw.len    = 8'b0;
    axi_req_o.aw.size   = {1'b0, size_i}; // 1, 2, 4 or 8 bytes
    axi_req_o.aw.burst  = axi_pkg::BURST_INCR; // Use BURST_INCR for AXI regular transaction
    axi_req_o.aw.lock   = 1'b0;
    axi_req_o.aw.cache  = 4'b0;
    axi_req_o.aw.qos    = 4'b0;
    axi_req_o.aw.id     = id_i;
    axi_req_o.aw.atop   = '0; // currently not used
    axi_req_o.aw.user   = '0;

    axi_req_o.ar_valid  = 1'b0;
    // in case of a single request or wrapping transfer we can simply begin at the address, if we want to request a cache-line
    // with an incremental transfer we need to output the corresponding base address of the cache line
    axi_req_o.ar.addr   = (CRITICAL_WORD_FIRST || type_i == ariane_axi::SINGLE_REQ) ? addr_i : { addr_i[(riscv::XLEN-1):CACHELINE_BYTE_OFFSET], {{CACHELINE_BYTE_OFFSET}{1'b0}}};
    axi_req_o.ar.prot   = 3'b0;
    axi_req_o.ar.region = 4'b0;
    axi_req_o.ar.len    = 8'b0;
    axi_req_o.ar.size   = {1'b0, size_i}; // 1, 2, 4 or 8 bytes
    axi_req_o.ar.burst  = (CRITICAL_WORD_FIRST ? axi_pkg::BURST_WRAP : axi_pkg::BURST_INCR); // wrapping transfer in case of a critical word first strategy
    axi_req_o.ar.lock   = 1'b0;
    axi_req_o.ar.cache  = 4'b0;
    axi_req_o.ar.qos    = 4'b0;
    axi_req_o.ar.id     = id_i;
    axi_req_o.ar.user   = '0;

    axi_req_o.w_valid   = 1'b0;
    axi_req_o.w.data    = wdata_i[0];
    axi_req_o.w.strb    = be_i[0];
    axi_req_o.w.last    = 1'b0;
    axi_req_o.w.user    = '0;

    axi_req_o.b_ready   = 1'b0;
    axi_req_o.r_ready   = 1'b0;

    gnt_o    = 1'b0;
    gnt_id_o = id_i;
    valid_o  = 1'b0;
    id_o     = axi_resp_i.r.id;

    critical_word_o       = axi_resp_i.r.data;
    critical_word_valid_o = 1'b0;
    rdata_o               = cache_line_q;

    state_d       = state_q;
    cnt_d         = cnt_q;
    cache_line_d  = cache_line_q;
    addr_offset_d = addr_offset_q;
    id_d          = id_q;
    index         = '0;

    case (state_q)

      IDLE: begin
        cnt_d = '0;
        // we have an incoming request
        if (req_i) begin
          // is this a read or write?
          // write
          if (we_i) begin
            // the data is valid
            axi_req_o.aw_valid = 1'b1;
            axi_req_o.w_valid  = 1'b1;
            // its a single write
            if (type_i == ariane_axi::SINGLE_REQ) begin
              // only a single write so the data is already the last one
              axi_req_o.w.last   = 1'b1;
              // single req can be granted here
              gnt_o = axi_resp_i.aw_ready & axi_resp_i.w_ready;
              case ({axi_resp_i.aw_ready, axi_resp_i.w_ready})
                2'b11: state_d = WAIT_B_VALID;
                2'b01: state_d = WAIT_AW_READY;
                2'b10: state_d = WAIT_LAST_W_READY;
                default: state_d = IDLE;
              endcase

            // its a request for the whole cache line
            end else begin
              axi_req_o.aw.len = BURST_SIZE; // number of bursts to do
              axi_req_o.w.data = wdata_i[0];
              axi_req_o.w.strb = be_i[0];

              if (axi_resp_i.w_ready)
                cnt_d = BURST_SIZE - 1;
              else
                cnt_d = BURST_SIZE;

              case ({axi_resp_i.aw_ready, axi_resp_i.w_ready})
                2'b11: state_d = WAIT_LAST_W_READY;
                2'b01: state_d = WAIT_LAST_W_READY_AW_READY;
                2'b10: state_d = WAIT_LAST_W_READY;
                default:;
              endcase
            end
          // read
          end else begin

            axi_req_o.ar_valid = 1'b1;
            gnt_o = axi_resp_i.ar_ready;
            if (type_i != ariane_axi::SINGLE_REQ) begin
              axi_req_o.ar.len = BURST_SIZE;
              cnt_d = BURST_SIZE;
            end

            if (axi_resp_i.ar_ready) begin
              state_d = (type_i == ariane_axi::SINGLE_REQ) ? WAIT_R_VALID : WAIT_R_VALID_MULTIPLE;
              addr_offset_d = addr_i[ADDR_INDEX-1+3:3];
            end
          end
        end
      end

      // ~> from single write
      WAIT_AW_READY: begin
        axi_req_o.aw_valid = 1'b1;

        if (axi_resp_i.aw_ready) begin
          gnt_o   = 1'b1;
          state_d = WAIT_B_VALID;
        end
      end

      // ~> we need to wait for an aw_ready and there is at least one outstanding write
      WAIT_LAST_W_READY_AW_READY: begin
        axi_req_o.w_valid  = 1'b1;
        axi_req_o.w.last   = (cnt_q == '0);
        if (type_i == ariane_axi::SINGLE_REQ) begin
          axi_req_o.w.data = wdata_i[0];
          axi_req_o.w.strb = be_i[0];
        end else begin
          axi_req_o.w.data = wdata_i[BURST_SIZE-cnt_q];
          axi_req_o.w.strb = be_i[BURST_SIZE-cnt_q];
        end
        axi_req_o.aw_valid = 1'b1;
        // we are here because we want to write a cache line
        axi_req_o.aw.len   = BURST_SIZE;
        // we got an aw_ready
        case ({axi_resp_i.aw_ready, axi_resp_i.w_ready})
          // we got an aw ready
          2'b01: begin
            // are there any outstanding transactions?
            if (cnt_q == 0)
              state_d = WAIT_AW_READY_BURST;
            else // yes, so reduce the count and stay here
              cnt_d = cnt_q - 1;
          end
          2'b10: state_d = WAIT_LAST_W_READY;
          2'b11: begin
            // we are finished
            if (cnt_q == 0) begin
              state_d = WAIT_B_VALID;
              gnt_o   = 1'b1;
            // there are outstanding transactions
            end else begin
              state_d = WAIT_LAST_W_READY;
              cnt_d   = cnt_q - 1;
            end
          end
          default:;
         endcase

      end

      // ~> all data has already been sent, we are only waiting for the aw_ready
      WAIT_AW_READY_BURST: begin
        axi_req_o.aw_valid = 1'b1;
        axi_req_o.aw.len   = BURST_SIZE;

        if (axi_resp_i.aw_ready) begin
          state_d  = WAIT_B_VALID;
          gnt_o    = 1'b1;
        end
      end

      // ~> from write, there is an outstanding write
      WAIT_LAST_W_READY: begin
        axi_req_o.w_valid = 1'b1;

        if (type_i != ariane_axi::SINGLE_REQ) begin
          axi_req_o.w.data = wdata_i[BURST_SIZE-cnt_q];
          axi_req_o.w.strb = be_i[BURST_SIZE-cnt_q];
        end

        // this is the last write
        if (cnt_q == '0) begin
          axi_req_o.w.last = 1'b1;
          if (axi_resp_i.w_ready) begin
            state_d = WAIT_B_VALID;
            gnt_o   = 1'b1;
          end
        end else if (axi_resp_i.w_ready) begin
          cnt_d = cnt_q - 1;
        end
      end

      // ~> finish write transaction
      WAIT_B_VALID: begin
        axi_req_o.b_ready = 1'b1;
        id_o = axi_resp_i.b.id;

        // Write is valid
        if (axi_resp_i.b_valid) begin
          state_d = IDLE;
          valid_o = 1'b1;
        end
      end

      // ~> cacheline read, single read
      WAIT_R_VALID_MULTIPLE, WAIT_R_VALID: begin
        if (CRITICAL_WORD_FIRST)
          index = addr_offset_q + (BURST_SIZE-cnt_q);
        else
          index = BURST_SIZE-cnt_q;

        // reads are always wrapping here
        axi_req_o.r_ready = 1'b1;
        // this is the first read a.k.a the critical word
        if (axi_resp_i.r_valid) begin
          if (CRITICAL_WORD_FIRST) begin
            // this is the first word of a cacheline read, e.g.: the word which was causing the miss
            if (state_q == WAIT_R_VALID_MULTIPLE && cnt_q == BURST_SIZE) begin
              critical_word_valid_o = 1'b1;
              critical_word_o       = axi_resp_i.r.data;
            end
          end else begin
            // check if the address offset matches - then we are getting the critical word
            if (index == addr_offset_q) begin
              critical_word_valid_o = 1'b1;
              critical_word_o       = axi_resp_i.r.data;
            end
          end

          // this is the last read
          if (axi_resp_i.r.last) begin
            id_d    = axi_resp_i.r.id;
            state_d = COMPLETE_READ;
          end

          // save the word
          if (state_q == WAIT_R_VALID_MULTIPLE) begin
            cache_line_d[index] = axi_resp_i.r.data;

          end else
            cache_line_d[0] = axi_resp_i.r.data;

          // Decrease the counter
          cnt_d = cnt_q - 1;
        end
      end
      // ~> read is complete
      COMPLETE_READ: begin
        valid_o = 1'b1;
        state_d = IDLE;
        id_o    = id_q;
      end
    endcase
  end

  // ----------------
  // Registers
  // ----------------
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      // start in flushing state and initialize the memory
      state_q       <= IDLE;
      cnt_q         <= '0;
      cache_line_q  <= '0;
      addr_offset_q <= '0;
      id_q          <= '0;
    end else begin
      state_q       <= state_d;
      cnt_q         <= cnt_d;
      cache_line_q  <= cache_line_d;
      addr_offset_q <= addr_offset_d;
      id_q          <= id_d;
    end
  end

endmodule
