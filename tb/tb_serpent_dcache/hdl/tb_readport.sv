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
// Description: program that emulates a cache readport. the program can generate
// randomized or linear read sequences, and it checks the returned responses against
// the expected responses coming directly from the emulated memory (tb_mem).
// 

`include "tb.svh"

import ariane_pkg::*;
import serpent_cache_pkg::*;
import tb_pkg::*;

program tb_readport  #(
    parameter string PORT_NAME  = "read port 0",
    parameter FLUSH_RATE        = 1,
    parameter KILL_RATE         = 5,
    parameter TLB_HIT_RATE      = 95,
    parameter MEM_WORDS         = 1024*1024,// in 64bit words
    parameter NC_ADDR_BEGIN     = 0,
    parameter RND_SEED          = 1110,
    parameter VERBOSE           = 0       
)(
    input logic           clk_i,
    input logic           rst_ni,

    // to testbench master
    ref   string          test_name_i,
    input  logic [6:0]    req_rate_i, //a rate between 0 and 100 percent
    input  seq_t          seq_type_i,
    input  logic          tlb_rand_en_i,
    input  logic          flush_rand_en_i,
    input  logic          seq_run_i,
    input  logic [31:0]   seq_num_resp_i,     
    input  logic          seq_last_i,
    output logic          seq_done_o, 

    // expresp interface 
    output logic [63:0]   exp_paddr_o,
    input  logic [1:0]    exp_size_i,
    input  logic [63:0]   exp_rdata_i,
    input  logic [63:0]   exp_paddr_i,
    input  logic [63:0]   act_paddr_i,
    
    // interface to DUT
    output logic          flush_o,
    input  logic          flush_ack_i,
    output dcache_req_i_t dut_req_port_o, 
    input  dcache_req_o_t dut_req_port_i
    );

    // leave this
    timeunit 1ps;
    timeprecision 1ps;

    logic [63:0] paddr;
    logic seq_end_req, seq_end_ack, prog_end;
    logic [DCACHE_TAG_WIDTH-1:0] tag_q;
    logic [DCACHE_TAG_WIDTH-1:0] tag_vld_q;
    

///////////////////////////////////////////////////////////////////////////////
// Randomly delay the tag by at least one cycle
///////////////////////////////////////////////////////////////////////////////
    
    // // TODO: add randomization
    initial begin : p_tag_delay
        logic [63:0] tmp_paddr, val;
        int unsigned cnt;
        logic tmp_vld;
        
        tag_q      <= '0;
        tag_vld_q  <= 1'b0;

        `APPL_WAIT_CYC(clk_i, 10)
        `APPL_WAIT_SIG(clk_i,~rst_ni)
        `APPL_WAIT_CYC(clk_i,1)

        tmp_vld = 0;
        cnt = 0;
        forever begin
            `APPL_WAIT_CYC(clk_i,1)
            
            if(cnt==0) begin
                if(tmp_vld) begin
                    tmp_vld   = 0;
                    tag_q     <= tmp_paddr[DCACHE_TAG_WIDTH+DCACHE_INDEX_WIDTH-1:DCACHE_INDEX_WIDTH];
                    tag_vld_q <= 1'b1;
                end else begin
                    tag_vld_q <= 1'b0;
                end 
                
                `APPL_ACQ_WAIT;
                if(dut_req_port_o.data_req) begin
                    tmp_paddr = paddr;
                    tmp_vld   = 1;

                    if(tlb_rand_en_i) begin
                        void'(randomize(val) with {val>0; val<=100;});
                        if(val>=TLB_HIT_RATE) begin
                            void'(randomize(cnt) with {cnt>0; cnt<=50;});
                        end
                    end
                 end

            end else begin
                tag_vld_q <= 1'b0; 
                cnt -= 1;           
                `APPL_ACQ_WAIT;
            end
           
            if(dut_req_port_o.kill_req) begin
                tmp_vld = 0;
                cnt     = 0;
            end 

        end
    end    

    assign dut_req_port_o.address_tag   = tag_q;
    assign dut_req_port_o.tag_valid     = tag_vld_q;
    assign dut_req_port_o.address_index = paddr[DCACHE_INDEX_WIDTH-1:0];
    assign exp_paddr_o                  = paddr;

///////////////////////////////////////////////////////////////////////////////
// Helper tasks
///////////////////////////////////////////////////////////////////////////////

    task automatic flushCache();
        flush_o      = 1'b1;
        `APPL_WAIT_SIG(clk_i, flush_ack_i);
        flush_o      = 0'b0;
        `APPL_WAIT_CYC(clk_i,1)
    endtask : flushCache
        

    task automatic genRandReq();
        automatic logic [63:0] val;
        automatic logic [1:0] size;

        void'($urandom(RND_SEED));

        paddr                        = '0;
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.kill_req      = '0;
        
        while(~seq_end_req) begin
            // randomize request
            dut_req_port_o.data_req = '0;
            // generate random control events
            void'(randomize(val) with {val > 0; val <= 100;});
            if(val < KILL_RATE) begin
                dut_req_port_o.kill_req = 1'b1;
                `APPL_WAIT_CYC(clk_i,1)
                dut_req_port_o.kill_req = 1'b0;
            end else begin
                void'(randomize(val) with {val > 0; val <= 100;});
                if(val < FLUSH_RATE && flush_rand_en_i) begin
                    flushCache();
                end else begin
                    void'(randomize(val) with {val > 0; val <= 100;});
                    if(val < req_rate_i) begin 
                        dut_req_port_o.data_req = 1'b1;
                        // generate random address
                        void'(randomize(val) with {val >= 0; val < (MEM_WORDS<<3);});
                        void'(randomize(size));
                        
                        dut_req_port_o.data_size = size;
                        paddr = val;

                        // align to size
                        unique case(size)
                            2'b01: paddr[0]   = 1'b0;
                            2'b10: paddr[1:0] = 2'b00;
                            2'b11: paddr[2:0] = 3'b000;
                            default: ;
                        endcase

                        `APPL_WAIT_COMB_SIG(clk_i, dut_req_port_i.data_gnt)
                    end
                    `APPL_WAIT_CYC(clk_i,1)
                end
            end    
        end

        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.kill_req      = '0;
        
    endtask : genRandReq

    task automatic genSeqRead();
        automatic logic [63:0] val;
        paddr                        = '0;
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.kill_req      = '0;
        val                          = '0;
        while(~seq_end_req) begin
            dut_req_port_o.data_req  = 1'b1;
            dut_req_port_o.data_size = 2'b11;
            paddr = val;
            // generate linear read
            val = (val + 8) % (MEM_WORDS<<3);
            `APPL_WAIT_COMB_SIG(clk_i, dut_req_port_i.data_gnt)
            `APPL_WAIT_CYC(clk_i,1)
        end  
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.kill_req      = '0;
    endtask : genSeqRead

    task automatic genWrapSeq();
        automatic logic [63:0] val;
        paddr                        = NC_ADDR_BEGIN;
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.kill_req      = '0;
        val                          = '0;
        while(~seq_end_req) begin
            dut_req_port_o.data_req  = 1'b1;
            dut_req_port_o.data_size = 2'b11;
            paddr = val;
            // generate wrapping read of 1 cachelines
            paddr = NC_ADDR_BEGIN + val;
            val = (val + 8) % (1*(DCACHE_LINE_WIDTH/64)*8);
            `APPL_WAIT_COMB_SIG(clk_i, dut_req_port_i.data_gnt)
            `APPL_WAIT_CYC(clk_i,1)
        end  
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.kill_req      = '0;
    endtask : genWrapSeq


///////////////////////////////////////////////////////////////////////////////
// Sequence application
///////////////////////////////////////////////////////////////////////////////

    initial begin : p_stim              
        paddr                        = '0;
        dut_req_port_o.data_wdata    = '0;
        dut_req_port_o.data_req      = '0;
        dut_req_port_o.data_we       = '0;
        dut_req_port_o.data_be       = '0;
        dut_req_port_o.data_size     = '0;
        dut_req_port_o.kill_req      = '0;
        seq_end_ack                  = '0;  
        flush_o                      = '0;

        // print some info
        $display("%s> current configuration:",  PORT_NAME);
        $display("%s> KILL_RATE          %d",   PORT_NAME, KILL_RATE);
        $display("%s> FLUSH_RATE         %d",   PORT_NAME, FLUSH_RATE);
        $display("%s> TLB_HIT_RATE       %d",   PORT_NAME, TLB_HIT_RATE);
        $display("%s> RND_SEED           %d",   PORT_NAME, RND_SEED);

        `APPL_WAIT_CYC(clk_i,1) 
        `APPL_WAIT_SIG(clk_i,~rst_ni)
        
        $display("%s> starting application", PORT_NAME);
        while(~seq_last_i) begin
                `APPL_WAIT_SIG(clk_i,seq_run_i) 
            unique case(seq_type_i) 
                RANDOM_SEQ: begin
                    $display("%s> start random sequence with %04d responses and req_rate %03d", PORT_NAME, seq_num_resp_i, req_rate_i);
                    genRandReq();
                end    
                LINEAR_SEQ: begin
                    $display("%s> start linear sequence with %04d responses and req_rate %03d", PORT_NAME, seq_num_resp_i, req_rate_i);
                    genSeqRead();
                end    
                WRAP_SEQ: begin
                    $display("%s> start wrapping sequence with %04d responses and req_rate %03d", PORT_NAME, seq_num_resp_i, req_rate_i);
                    genWrapSeq();
                end    
                IDLE_SEQ: begin
                    `APPL_WAIT_SIG(clk_i,seq_end_req)
                end    
                BURST_SEQ: begin
                    $fatal(1, "Burst sequence not implemented for read port agent");
                end        
            endcase // seq_type_i
            seq_end_ack = 1'b1;
            $display("%s> stop sequence", PORT_NAME);
            `APPL_WAIT_CYC(clk_i,1) 
            seq_end_ack = 1'b0;
        end
        $display("%s> ending application", PORT_NAME);
    end


///////////////////////////////////////////////////////////////////////////////
// Response acquisition
///////////////////////////////////////////////////////////////////////////////

    initial begin : p_acq             
        bit ok;
        progress status;
        string failingTests, tmpstr1, tmpstr2;
        int    n;
        logic [63:0] exp_rdata, exp_paddr;
        logic [1:0] exp_size;

        status       = new(PORT_NAME);
        failingTests = "";
        seq_done_o   = 1'b0;  
        seq_end_req  = 1'b0;
        prog_end     = 1'b0;
        
        `ACQ_WAIT_CYC(clk_i,1) 
        `ACQ_WAIT_SIG(clk_i,~rst_ni)

        ///////////////////////////////////////////////
        // loop over tests
        n=0;
        while(~seq_last_i) begin
            `ACQ_WAIT_SIG(clk_i,seq_run_i)
            seq_done_o = 1'b0;    
            
            $display("%s> %s", PORT_NAME, test_name_i);  
            status.reset(seq_num_resp_i);
            for (int k=0;k<seq_num_resp_i && seq_type_i != IDLE_SEQ;k++) begin
                `ACQ_WAIT_SIG(clk_i, dut_req_port_i.data_rvalid)
               
                exp_rdata = 'x;
                unique case(exp_size_i)
                    2'b00: exp_rdata[exp_paddr_i[2:0]*8  +: 8]  = exp_rdata_i[exp_paddr_i[2:0]*8  +: 8];
                    2'b01: exp_rdata[exp_paddr_i[2:1]*16 +: 16] = exp_rdata_i[exp_paddr_i[2:1]*16 +: 16];
                    2'b10: exp_rdata[exp_paddr_i[2]  *32 +: 32] = exp_rdata_i[exp_paddr_i[2]  *32 +: 32];
                    2'b11: exp_rdata                            = exp_rdata_i;
                endcase // exp_size   
                
                // note: wildcard as defined in right operand!
                ok=(dut_req_port_i.data_rdata ==? exp_rdata) && (exp_paddr_i == act_paddr_i);
                
                if(VERBOSE | !ok) begin  
                    tmpstr1 =  $psprintf("vector: %02d - %06d -- exp_paddr: %16X -- exp_data: %16X -- access size: %01d Byte",
                                n, k, exp_paddr_i, exp_rdata, 2**exp_size_i);
                    tmpstr2 =  $psprintf("vector: %02d - %06d -- act_paddr: %16X -- act_data: %16X -- access size: %01d Byte",
                                n, k, act_paddr_i, dut_req_port_i.data_rdata, 2**exp_size_i);
                    $display("%s> %s", PORT_NAME, tmpstr1);
                    $display("%s> %s", PORT_NAME, tmpstr2);
                end 

                if(!ok) begin
                  failingTests = $psprintf("%s%s> %s\n%s> %s\n", failingTests, PORT_NAME, tmpstr1, PORT_NAME, tmpstr2); 
                end  
                status.addRes(!ok);
                status.print();
            end
            seq_end_req = 1'b1;
            `ACQ_WAIT_SIG(clk_i, seq_end_ack)
            seq_end_req = 1'b0;
            
            `ACQ_WAIT_CYC(clk_i,1) 
            seq_done_o = 1'b1;    
            n++;
        end  
        ///////////////////////////////////////////////

        status.printToFile({PORT_NAME, "_summary.rep"}, 1);     
          
        if(status.totErrCnt == 0) begin
            $display("%s> ----------------------------------------------------------------------", PORT_NAME);
            $display("%s> PASSED %0d VECTORS", PORT_NAME, status.totAcqCnt);
            $display("%s> ----------------------------------------------------------------------\n", PORT_NAME);
        end else begin
            $display("%s> ----------------------------------------------------------------------\n", PORT_NAME);
            $display("%s> FAILED %0d OF %0d VECTORS\n", PORT_NAME , status.totErrCnt, status.totAcqCnt);
            $display("%s> failing tests:", PORT_NAME);
            $display("%s", failingTests);
            $display("%s> ----------------------------------------------------------------------\n", PORT_NAME);
        end
        prog_end = 1'b1;
    end      

///////////////////////////////////////////////////////
// assertions
///////////////////////////////////////////////////////

//pragma translate_off
// `ifndef VERILATOR

// `endif
//pragma translate_on

endprogram // tb_readport
