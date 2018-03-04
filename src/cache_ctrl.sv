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
// File:   cache_ctrl.svh
// Author: Florian Zaruba <zarubaf@ethz.ch>
// Date:   14.10.2017
//
// Copyright (C) 2017 ETH Zurich, University of Bologna
// All rights reserved.
//
// Description: Cache controller

import ariane_pkg::*;
import nbdcache_pkg::*;

module cache_ctrl #(
        parameter int unsigned SET_ASSOCIATIVITY = 8,
        parameter int unsigned INDEX_WIDTH       = 12,
        parameter int unsigned TAG_WIDTH         = 44,
        parameter int unsigned CACHE_LINE_WIDTH  = 100,
        parameter logic [63:0] CACHE_START_ADDR  = 64'h4000_0000
    )(
        input  logic                                               clk_i,     // Clock
        input  logic                                               rst_ni,    // Asynchronous reset active low
        input  logic                                               bypass_i,  // enable cache
        output logic                                               busy_o,
        // Core request ports
        input  logic [INDEX_WIDTH-1:0]                             address_index_i,
        input  logic [TAG_WIDTH-1:0]                               address_tag_i,
        input  logic [63:0]                                        data_wdata_i,
        input  logic                                               data_req_i,
        input  logic                                               data_we_i,
        input  logic [7:0]                                         data_be_i,
        input  logic [1:0]                                         data_size_i,
        input  logic                                               kill_req_i,
        input  logic                                               tag_valid_i,
        output logic                                               data_gnt_o,
        output logic                                               data_rvalid_o,
        output logic [63:0]                                        data_rdata_o,
        input  amo_t                                               amo_op_i,
        // SRAM interface
        output logic [SET_ASSOCIATIVITY-1:0]                       req_o,  // req is valid
        output logic [INDEX_WIDTH-1:0]                             addr_o, // address into cache array
        input  logic                                               gnt_i,
        output cache_line_t                                        data_o,
        output cl_be_t                                             be_o,
        output logic [TAG_WIDTH-1:0]                               tag_o, //valid one cycle later
        input  cache_line_t [SET_ASSOCIATIVITY-1:0]                data_i,
        output logic                                               we_o,
        input  logic [SET_ASSOCIATIVITY-1:0]                       hit_way_i,
        // Miss handling
        output miss_req_t                                          miss_req_o,
        // return
        input  logic                                               miss_gnt_i,
        input  logic                                               active_serving_i, // the miss unit is currently active for this unit, serving the miss
        input  logic [63:0]                                        critical_word_i,
        input  logic                                               critical_word_valid_i,

        input  logic                                               bypass_gnt_i,
        input  logic                                               bypass_valid_i,
        input  logic [63:0]                                        bypass_data_i,
        // check MSHR for aliasing
        output logic [55:0]                                        mshr_addr_o,
        input  logic                                               mshr_addr_matches_i
);

    // 0 IDLE
    // 1 WAIT_TAG
    // 2 WAIT_TAG_BYPASSED
    // 3 STORE_REQ
    // 4 WAIT_REFILL_VALID
    // 5 WAIT_REFILL_GNT
    // 6 WAIT_TAG_SAVED
    // 7 WAIT_MSHR
    // 8 WAIT_CRITICAL_WORD

    enum logic [3:0] {
        IDLE, WAIT_TAG, WAIT_TAG_BYPASSED, STORE_REQ, WAIT_REFILL_VALID, WAIT_REFILL_GNT, WAIT_TAG_SAVED, WAIT_MSHR, WAIT_CRITICAL_WORD
    } state_d, state_q;

    typedef struct packed {
        logic [INDEX_WIDTH-1:0] index;
        logic [TAG_WIDTH-1:0]   tag;
        logic [7:0]             be;
        logic [1:0]             size;
        logic                   we;
        logic [63:0]            wdata;
        logic                   bypass;
    } mem_req_t;

    logic [SET_ASSOCIATIVITY-1:0] hit_way_d, hit_way_q;

    assign busy_o = (state_q != IDLE);

    mem_req_t mem_req_d, mem_req_q;

    logic [CACHE_LINE_WIDTH-1:0] cl_i;

    always_comb begin : way_select
        cl_i = '0;
        for (int unsigned i = 0; i < SET_ASSOCIATIVITY; i++)
            if (hit_way_i[i])
                cl_i = data_i[i].data;

        // cl_i = data_i[one_hot_to_bin(hit_way_i)].data;
    end

    // --------------
    // Cache FSM
    // --------------
    always_comb begin : cache_ctrl_fsm
        automatic logic [$clog2(CACHE_LINE_WIDTH)-1:0] cl_offset;
        // incoming cache-line -> this is needed as synthesis is not supporting +: indexing in a multi-dimensional array
        // cache-line offset -> multiple of 64
        cl_offset = mem_req_q.index[BYTE_OFFSET-1:3] << 6; // shift by 6 to the left

        // default assignments
        state_d   = state_q;
        mem_req_d = mem_req_q;
        hit_way_d = hit_way_q;

        // output assignments
        data_gnt_o    = 1'b0;
        data_rvalid_o = 1'b0;
        data_rdata_o  = '0;
        miss_req_o    = '0;
        mshr_addr_o   = '0;
        // Memory array communication
        req_o  = '0;
        addr_o = address_index_i;
        data_o = '0;
        be_o   = '0;
        tag_o  = '0;
        we_o   = '0;
        tag_o  = 'b0;

        case (state_q)

            IDLE: begin
                // a new request arrived
                if (data_req_i) begin
                    // request the cache line - we can do this specualtive
                    req_o = '1;

                    // save index, be and we
                    mem_req_d.index = address_index_i;
                    mem_req_d.tag   = address_tag_i;
                    mem_req_d.be    = data_be_i;
                    mem_req_d.size  = data_size_i;
                    mem_req_d.we    = data_we_i;
                    mem_req_d.wdata = data_wdata_i;

                    // Bypass mode, check for uncacheable address here as well
                    if (bypass_i) begin
                        state_d = WAIT_TAG_BYPASSED;
                        // grant this access
                        data_gnt_o = 1'b1;
                        mem_req_d.bypass = 1'b1;
                    // ------------------
                    // Cache is enabled
                    // ------------------
                    end else begin
                        // Wait that we have access on the memory array
                        if (gnt_i) begin
                            state_d = WAIT_TAG;
                            mem_req_d.bypass = 1'b0;
                            // only for a read
                            if (!data_we_i)
                                data_gnt_o = 1'b1;
                        end
                    end
                end
            end

            // cache enabled and waiting for tag
            WAIT_TAG, WAIT_TAG_SAVED: begin
                // depending on where we come from
                // For the store case the tag comes in the same cycle
                tag_o = (state_q == WAIT_TAG_SAVED || mem_req_q.we) ? mem_req_q.tag :  address_tag_i;

                // we speculatively request another transfer
                if (data_req_i) begin
                    req_o      = '1;
                end

                // check that the client really wants to do the request
                if (!kill_req_i) begin
                    // ------------
                    // HIT CASE
                    // ------------
                    if (|hit_way_i) begin
                        // we can request another cache-line if this was a load
                        // make another request
                        if (data_req_i && !mem_req_q.we) begin
                            state_d          = WAIT_TAG; // switch back to WAIT_TAG
                            mem_req_d.index  = address_index_i;
                            mem_req_d.be     = data_be_i;
                            mem_req_d.size   = data_size_i;
                            mem_req_d.we     = data_we_i;
                            mem_req_d.wdata  = data_wdata_i;
                            mem_req_d.tag    = address_tag_i;
                            mem_req_d.bypass = 1'b0;
                            data_gnt_o = gnt_i;

                            if (!gnt_i) begin
                                state_d = IDLE;
                            end

                        end else begin
                            state_d = IDLE;
                        end

                        // this is timing critical
                        // data_rdata_o = cl_i[cl_offset +: 64];
                        case (mem_req_q.index[3])
                            1'b0: data_rdata_o = cl_i[63:0];
                            1'b1: data_rdata_o = cl_i[CACHE_LINE_WIDTH-1:64];
                        endcase

                        // report data for a read
                        if (!mem_req_q.we) begin
                            data_rvalid_o = 1'b1;

                        // else this was a store so we need an extra step to handle it
                        end else begin
                            state_d = STORE_REQ;
                            hit_way_d = hit_way_i;
                        end
                    // ------------
                    // MISS CASE
                    // ------------
                    end else begin
                        // also save tag
                        mem_req_d.tag = address_tag_i;
                        // make a miss request
                        state_d = WAIT_REFILL_GNT;
                    end
                    // ---------------
                    // Check MSHR
                    // ---------------
                    mshr_addr_o = {address_tag_i, mem_req_q.index};
                    // we've got a match on MSHR
                    if (mshr_addr_matches_i) begin
                        state_d = WAIT_MSHR;
                        // save tag if we didn't already save it e.g.: we are not in in the Tag saved state
                        if (state_q != WAIT_TAG_SAVED)
                            mem_req_d.tag = address_tag_i;
                    end
                    // -------------------------
                    // Check for cache-ability
                    // -------------------------
                    if (tag_o < CACHE_START_ADDR[TAG_WIDTH+INDEX_WIDTH-1:INDEX_WIDTH]) begin
                        mem_req_d.tag = address_tag_i;
                        mem_req_d.bypass = 1'b1;
                        state_d = WAIT_REFILL_GNT;
                    end
                end else begin
                    // we can potentially accept a new request -> I don't know how this works out timing vise
                    // as this will chain some paths together...
                    // For now this should not happen to frequently and we spare another cycle
                    // go back to idle
                    state_d = IDLE;
                    data_rvalid_o = 1'b1;
                end
            end

            // ~> we are here as we need a second round of memory access for a store
            STORE_REQ: begin
                // store data, write dirty bit
                req_o = hit_way_q;
                addr_o = mem_req_q.index;
                we_o  = 1'b1;

                be_o.dirty = hit_way_q;
                be_o.valid = hit_way_q;

                // set the correct byte enable
                for (int unsigned i = 0; i < 8; i++) begin
                    if (mem_req_q.be[i])
                        be_o.data[cl_offset + i*8 +: 8] = '1;
                end

                data_o.data[cl_offset +: 64] = mem_req_q.wdata;
                // ~> change the state
                data_o.dirty = 1'b1;
                data_o.valid = 1'b1;

                // got a grant ~> this is finished now
                if (gnt_i) begin
                    data_gnt_o = 1'b1;
                    state_d = IDLE;
                end
            end

            // we've got a match on MSHR ~> miss unit is scurrently serving a request
            WAIT_MSHR: begin
                mshr_addr_o = {mem_req_q.tag, mem_req_q.index};
                // we can start a new request
                if (!mshr_addr_matches_i) begin
                    req_o = '1;

                    addr_o = mem_req_q.index;

                    if (gnt_i)
                        state_d = WAIT_TAG_SAVED;
                end
            end

            // its for sure a miss
            WAIT_TAG_BYPASSED: begin
                // the request was killed
                if (kill_req_i) begin
                    state_d = IDLE;
                    // we need to ack the killing
                    data_rvalid_o = 1'b1;
                end else begin
                    // save tag
                    mem_req_d.tag = address_tag_i;
                    state_d = WAIT_REFILL_GNT;
                end
            end

            // ~> wait for grant from miss unit
            WAIT_REFILL_GNT: begin

                mshr_addr_o = {mem_req_q.tag, mem_req_q.index};

                miss_req_o.valid = 1'b1;
                miss_req_o.bypass = mem_req_q.bypass;
                miss_req_o.addr = {mem_req_q.tag, mem_req_q.index};
                miss_req_o.be = mem_req_q.be;
                miss_req_o.size = mem_req_q.size;
                miss_req_o.we = mem_req_q.we;
                miss_req_o.wdata = mem_req_q.wdata;

                // got a grant so go to valid
                if (bypass_gnt_i) begin
                    state_d = WAIT_REFILL_VALID;
                    // if this was a write we still need to give a grant to the store unit
                    if (mem_req_q.we)
                        data_gnt_o = 1'b1;
                end

                if (miss_gnt_i && !mem_req_q.we)
                    state_d = WAIT_CRITICAL_WORD;
                else if (miss_gnt_i) begin
                    state_d = IDLE;
                    data_gnt_o = 1'b1;
                end

                // it can be the case that the miss unit is currently serving a request which matches ours
                // so we need to check the mshr for matching continously
                // if the mshr matches we need to go to a different state -> we should never get a matching mshr and a high miss_gnt_i
                if (mshr_addr_matches_i && !active_serving_i) begin
                    state_d = WAIT_MSHR;
                end
            end

            // ~> wait for critical word to arrive
            WAIT_CRITICAL_WORD: begin
                // speculatively request another word
                if (data_req_i) begin
                    // request the cache line
                    req_o = '1;
                end

                if (critical_word_valid_i) begin
                    data_rvalid_o = 1'b1;
                    data_rdata_o = critical_word_i;
                    // we can make another request
                    if (data_req_i) begin
                        // save index, be and we
                        mem_req_d.index = address_index_i;
                        mem_req_d.be    = data_be_i;
                        mem_req_d.size  = data_size_i;
                        mem_req_d.we    = data_we_i;
                        mem_req_d.wdata = data_wdata_i;
                        mem_req_d.tag   = address_tag_i;


                        state_d = IDLE;

                        // Wait until we have access on the memory array
                        if (gnt_i) begin
                            state_d = WAIT_TAG;
                            mem_req_d.bypass = 1'b0;
                            data_gnt_o = 1'b1;
                        end

                    end else begin
                        state_d = IDLE;
                    end
                end
            end
            // ~> wait until the bypass request is valid
            WAIT_REFILL_VALID: begin
                // got a valid answer
                if (bypass_valid_i) begin
                    data_rdata_o = bypass_data_i;
                    data_rvalid_o = 1'b1;
                    state_d = IDLE;
                end
            end

        endcase
    end

    // --------------
    // Registers
    // --------------
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (~rst_ni) begin
            state_q   <= IDLE;
            mem_req_q <= '0;
            hit_way_q <= '0;
        end else begin
            state_q   <= state_d;
            mem_req_q <= mem_req_d;
            hit_way_q <= hit_way_d;
        end
    end

    `ifndef SYNTHESIS
        initial begin
            assert (CACHE_LINE_WIDTH == 128) else $error ("Cacheline width has to be 128 for the moment. But only small changes required in data select logic");
        end
    `endif
endmodule

module AMO_alu (
        input logic         clk_i,
        input logic         rst_ni,
        // AMO interface
        input  logic        amo_commit_i, // commit atomic memory operation
        output logic        amo_valid_o,  // we have a valid AMO result
        output logic [63:0] amo_result_o, // result of atomic memory operation
        input  logic        amo_flush_i   // forget about AMO
    );

endmodule
