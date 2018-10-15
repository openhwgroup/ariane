// Copyright (c) 2018 ETH Zurich, University of Bologna
// All rights reserved.
//
// This code is under development and not yet released to the public.
// Until it is released, the code is under the copyright of ETH Zurich and
// the University of Bologna, and may contain confidential and/or unpublished
// work. Any reuse/redistribution is strictly forbidden without written
// permission from ETH Zurich.
//
// Bug fixes and contributions will eventually be released under the
// SolderPad open hardware license in the context of the PULP platform
// (http://www.pulp-platform.org), under the copyright of ETH Zurich and the
// University of Bologna.
//
// Author: Michael Schaffner <schaffner@iis.ee.ethz.ch>, ETH Zurich
// Date: 15.08.2018
// Description: program that emulates a cache write port. the program can generate
// randomized or linear read sequences.
// 

`include "tb.svh"

import ariane_pkg::*;
import serpent_cache_pkg::*;
import tb_pkg::*;

program tb_writeport  #(
    parameter string PORT_NAME  = "write port 0",
    parameter MEM_WORDS         = 1024*1024,// in 64bit words
    parameter NC_ADDR_BEGIN     = 0,
    parameter RND_SEED          = 1110,
    parameter VERBOSE           = 0       
)(
    input logic           clk_i,
    input logic           rst_ni,

    // to testbench master
    ref   string          test_name_i,
    input  logic [6:0]    req_rate_i,
    input  seq_t          seq_type_i,
    input  logic          seq_run_i,
    input  logic [31:0]   seq_num_vect_i,     
    input  logic          seq_last_i,
    output logic          seq_done_o, 
    
    // interface to DUT
    output dcache_req_i_t dut_req_port_o, 
    input  dcache_req_o_t dut_req_port_i
    );

    // leave this
    timeunit 1ps;
    timeprecision 1ps;

    logic [63:0] paddr;
    
    assign dut_req_port_o.address_tag   = paddr[DCACHE_TAG_WIDTH+DCACHE_INDEX_WIDTH-1:DCACHE_INDEX_WIDTH];
    assign dut_req_port_o.address_index = paddr[DCACHE_INDEX_WIDTH-1:0];
    assign dut_req_port_o.data_we       = dut_req_port_o.data_req;

///////////////////////////////////////////////////////////////////////////////
// Helper tasks
///////////////////////////////////////////////////////////////////////////////


    task automatic applyRandData();
        automatic logic [63:0] val;
        automatic logic [7:0]  be;
        automatic logic [1:0]  size;

        void'(randomize(size));
        // align to size, set correct byte enables
        be = '0;
        unique case(size)
            2'b00: be[paddr[2:0]    +: 1] = '1;
            2'b01: be[paddr[2:1]<<1 +: 2] = '1;
            2'b10: be[paddr[2:2]<<2 +: 4] = '1;
            2'b11: be = '1;
            default: ;
        endcase
        paddr[2:0] = '0;
            

        void'(randomize(val));
        for(int k=0; k<8; k++) begin
            if( be[k] ) begin
                dut_req_port_o.data_wdata[k*8 +: 8] = val[k*8 +: 8];
            end
        end    

        dut_req_port_o.data_be       = be;
        dut_req_port_o.data_size     = size;    
    endtask : applyRandData   


    task automatic genRandReq();
        automatic logic [63:0] val;

        void'($urandom(RND_SEED));

        paddr                        = '0;
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.data_be       = '0;
        dut_req_port_o.data_wdata    = 'x;

        repeat(seq_num_vect_i) begin
            // randomize request
            dut_req_port_o.data_req   = '0;
            dut_req_port_o.data_be    = '0;
            dut_req_port_o.data_wdata = 'x;
            void'(randomize(val) with {val > 0; val <= 100;});
            if(val < req_rate_i) begin 
                dut_req_port_o.data_req = 1'b1;
                // generate random address
                void'(randomize(paddr) with {paddr >= 0; paddr < (MEM_WORDS<<3);});
                applyRandData();
                `APPL_WAIT_COMB_SIG(clk_i, dut_req_port_i.data_gnt)
            end
            `APPL_WAIT_CYC(clk_i,1)
        end

        paddr                        = '0;
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.data_be       = '0;
        dut_req_port_o.data_wdata    = 'x;
        
    endtask : genRandReq

    task automatic genSeqWrite();
        automatic logic [63:0] val;
        paddr                         = '0;
        dut_req_port_o.data_req       = '0;
        dut_req_port_o.data_size      = '0;
        dut_req_port_o.data_be        = '0;
        dut_req_port_o.data_wdata     = 'x;
        val                           = '0;
       repeat(seq_num_vect_i) begin
            dut_req_port_o.data_req   = 1'b1;
            dut_req_port_o.data_size  = 2'b11;
            dut_req_port_o.data_be    = '1;
            dut_req_port_o.data_wdata = val;
            paddr = val;
            // generate linear read
            val = (val + 8) % (MEM_WORDS<<3);
            `APPL_WAIT_COMB_SIG(clk_i, dut_req_port_i.data_gnt)
            `APPL_WAIT_CYC(clk_i,1)
        end  
        paddr                        = '0;
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.data_be       = '0;
        dut_req_port_o.data_wdata    = 'x;
        
    endtask : genSeqWrite

    task automatic genWrapSeq();
        automatic logic [63:0] val;
        void'($urandom(RND_SEED));

        paddr                         = NC_ADDR_BEGIN;
        dut_req_port_o.data_req       = '0;
        dut_req_port_o.data_size      = '0;
        dut_req_port_o.data_be        = '0;
        dut_req_port_o.data_wdata     = 'x;
        val                           = '0;
       repeat(seq_num_vect_i) begin
            dut_req_port_o.data_req   = 1'b1;
            applyRandData();
            // generate wrapping read of 1 cacheline
            paddr = NC_ADDR_BEGIN + val;
            val = (val + 8) % (1*(DCACHE_LINE_WIDTH/64)*8);
            `APPL_WAIT_COMB_SIG(clk_i, dut_req_port_i.data_gnt)
            `APPL_WAIT_CYC(clk_i,1)
        end  
        paddr                        = '0;
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.data_be       = '0;
        dut_req_port_o.data_wdata    = 'x;
        
    endtask : genWrapSeq

    task automatic genSeqBurst();
        automatic logic [63:0] val;
        automatic logic [7:0]  be;
        automatic logic [1:0]  size;
        automatic int cnt, burst_len;

        void'($urandom(RND_SEED));

        paddr                        = '0;
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.data_be       = '0;
        dut_req_port_o.data_wdata    = 'x;
        cnt = 0;
        while(cnt < seq_num_vect_i) begin
            // randomize request
            dut_req_port_o.data_req   = '0;
            dut_req_port_o.data_be    = '0;
            dut_req_port_o.data_wdata = 'x;
            void'(randomize(val) with {val > 0; val <= 100;});
            if(val < req_rate_i) begin 
                dut_req_port_o.data_req = 1'b1;
                // generate random address base
                void'(randomize(paddr) with {paddr >= 0; paddr < (MEM_WORDS<<3);});
                
                // do a random burst
                void'(randomize(burst_len) with {burst_len >= 0; burst_len < 100;});
                for(int k=0; k<burst_len && cnt < seq_num_vect_i && paddr < ((MEM_WORDS-1)<<3); k++) begin
                    applyRandData();
                    `APPL_WAIT_COMB_SIG(clk_i, dut_req_port_i.data_gnt)
                    `APPL_WAIT_CYC(clk_i,1)
                    //void'(randomize(val) with {val>=0 val<=8;};);
                    paddr += 8;
                    cnt ++;
                end
            end
            `APPL_WAIT_CYC(clk_i,1)
        end

        paddr                        = '0;
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.data_be       = '0;
        dut_req_port_o.data_wdata    = 'x;
        
    endtask : genSeqBurst


///////////////////////////////////////////////////////////////////////////////
// Sequence application
///////////////////////////////////////////////////////////////////////////////

    initial begin : p_stim              
        paddr                        = '0;
        
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.data_be       = '0;
        dut_req_port_o.data_wdata    = '0;
        dut_req_port_o.tag_valid     = '0;
        dut_req_port_o.kill_req      = '0;

        seq_done_o                   = 1'b0;  

        // print some info
        $display("%s> current configuration:",  PORT_NAME);
        $display("%s> RND_SEED           %d",   PORT_NAME, RND_SEED);

        `APPL_WAIT_CYC(clk_i,1) 
        `APPL_WAIT_SIG(clk_i,~rst_ni)
        
        $display("%s> starting application", PORT_NAME);
        while(~seq_last_i) begin
            `APPL_WAIT_SIG(clk_i,seq_run_i) 
            seq_done_o = 1'b0;  
            unique case(seq_type_i) 
                RANDOM_SEQ: begin
                    $display("%s> start random sequence with %04d vectors and req_rate %03d", PORT_NAME, seq_num_vect_i, req_rate_i);
                    genRandReq();
                end    
                LINEAR_SEQ: begin
                    $display("%s> start linear sequence with %04d vectors and req_rate %03d", PORT_NAME, seq_num_vect_i, req_rate_i);
                    genSeqWrite();
                end
                WRAP_SEQ: begin
                    $display("%s> start wrapping sequence with %04d vectors and req_rate %03d", PORT_NAME, seq_num_vect_i, req_rate_i);
                    genWrapSeq();
                end    
                IDLE_SEQ: ;// do nothing
                BURST_SEQ: begin
                    $display("%s> start burst sequence with %04d vectors and req_rate %03d", PORT_NAME, seq_num_vect_i, req_rate_i);
                    genSeqBurst();
                end    
            endcase // seq_type_i
            seq_done_o = 1'b1;  
            $display("%s> stop sequence", PORT_NAME);
            `APPL_WAIT_CYC(clk_i,1) 
        end
        $display("%s> ending application", PORT_NAME);
    end

///////////////////////////////////////////////////////
// assertions
///////////////////////////////////////////////////////

//pragma translate_off
// `ifndef verilator
//     exp_resp_vld: assert property (
//         @(posedge clk_i) disable iff (~rst_ni) dut_req_port_i.data_rvalid |-> exp_rdata_queue.size()>0 && exp_size_queue.size()>0 && exp_paddr_queue.size()>0)       
//         else $fatal(1, "expected response must be in the queue when DUT response returns");

// `endif
//pragma translate_on

endprogram // tb_readport
