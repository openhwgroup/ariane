// Copyright 2021 Thales DIS design services SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Zineb EL KACIMI (zineb.el-kacimi@external.thalesgroup.com)

`ifndef __UVME_CVXIF_VSEQ_SV__
`define __UVME_CVXIF_VSEQ_SV__


class uvme_cvxif_vseq_c extends uvme_cvxif_base_vseq_c;

   `uvm_object_utils (uvme_cvxif_vseq_c)
   `uvm_declare_p_sequencer (uvma_cvxif_vsqr_c)

   string info_tag = "CVXIF_VSEQ_RESP";
   string instr;
   string compressed_instr;

   /**
    * Default constructor.
   */
   extern function new(string name="uvme_cvxif_vseq");

   /**
    * Send the Sequence Response to the Sequencer.
   */
   extern task send_resp(uvma_cvxif_resp_item_c resp);

   /**
    * Default response in case of illegal/inaccepted instruction.
    * Or in case of an invalid issue_req
   */
   extern task do_default();

   /**
    * Generate an issue response depending on received request
   */
   extern virtual task do_issue_resp();

   /**
    * Generate the result response independent of instruction received
   */
   extern virtual task do_result_resp();

   /**
    * Generate the result response depending on instruction received
   */
   extern virtual task do_compressed_resp();

   /**
    * Generate the result response depending on instruction received
   */
   extern virtual task do_instr_result();

   /**
    * Main sequence body
   */
   extern virtual task body();

endclass

task uvme_cvxif_vseq_c::body();

   if (cfg.enabled_cvxif) begin

      do_default();
      forever begin
         // wait for a transaction request (get is blocking)
         `uvm_info(info_tag, $sformatf("Waiting for the transaction request from monitor"), UVM_HIGH);
         p_sequencer.mm_req_fifo.get(req_item);
         resp_item = uvma_cvxif_resp_item_c::type_id::create("resp_item");
         `uvm_info(info_tag, $sformatf("Request: %p ", req_item), UVM_HIGH);

         resp_item.issue_valid      = '0;
         resp_item.compressed_valid = '0;

         compressed_instr = compressed_decode(req_item.compressed_req.instr);
         instr = decode(req_item.issue_req.instr);
         `uvm_info(info_tag, $sformatf("Compressed Instr: %s ", compressed_instr), UVM_HIGH);
         `uvm_info(info_tag, $sformatf("Uncompressed Instr: %s ", instr), UVM_HIGH);

         if (req_item.compressed_valid) begin
           if (compressed_instr == "") do_default();
           else begin
              resp_item.compressed_valid = 1;
              // compressed response
              do_compressed_resp();
           end
         end
         if (req_item.issue_valid) begin
           if (instr == "") do_default();
           else begin
              resp_item.issue_valid = 1;
              //issue response
              do_issue_resp();
              //result response
              do_result_resp();
           end
         end
         if (resp_item.issue_valid || resp_item.compressed_valid) begin
            //send response to the sequencer
            send_resp(resp_item);
         end
      end
   end

endtask

function uvme_cvxif_vseq_c::new(string name="uvme_cvxif_vseq");

   super.new(name);

endfunction : new

task uvme_cvxif_vseq_c::do_default();

   resp_item.compressed_ready         = 0;
   resp_item.compressed_valid         = 0;
   resp_item.compressed_resp.accept   = 0;
   resp_item.compressed_resp.instr    = 0;

   resp_item.issue_ready              = 0;
   resp_item.issue_valid              = 0;
   resp_item.issue_resp.accept        = 0;
   resp_item.issue_resp.writeback     = 0;
   resp_item.issue_resp.register_read = 0;

   resp_item.result_valid             = 0;
   resp_item.result.id                = 0;
   resp_item.result.hartid            = 0;
   resp_item.result.data              = 0;
   resp_item.result.rd                = 0;
   resp_item.result.we                = 0;

   resp_item.delay_resp               = 0;
   `uvm_info(info_tag, $sformatf("Sending default sequence response to sqr"), UVM_NONE);

   send_resp(resp_item);

endtask

task uvme_cvxif_vseq_c::do_issue_resp();

   resp_item.issue_resp.writeback     = 0;
   resp_item.issue_resp.accept        = 0;
   resp_item.issue_resp.register_read = 0;

   case (instr) inside
      "CUS_NOP" : begin
          resp_item.issue_resp.writeback     = 0;
          resp_item.issue_resp.accept        = 1;
          resp_item.issue_resp.register_read = 0;
          resp_item.delay_resp = 0;
        end
      "CUS_ADD" : begin
          if (req_item.register.rs_valid inside {2'b11, 3'b111}) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 'b011;
             resp_item.delay_resp = 0;
          end
          else begin
            resp_item.delay_resp = 1;
          end
        end
      "CUS_DOUBLE_RS1" : begin
          if (req_item.register.rs_valid inside {2'b11, 3'b111}) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 'b001;
             resp_item.delay_resp = 0;
          end
          else begin
            resp_item.delay_resp = 1;
          end
        end
      "CUS_DOUBLE_RS2" : begin
          if (req_item.register.rs_valid inside {2'b11, 3'b111}) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 'b010;
             resp_item.delay_resp = 0;
          end
          else begin
            resp_item.delay_resp = 1;
          end
        end
      "CUS_ADD_MULTI" : begin
          if (req_item.register.rs_valid inside {2'b11, 3'b111}) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 'b11;
             resp_item.delay_resp = 0;
          end
          else begin
            resp_item.delay_resp = 1;
          end
        end
      "CUS_ADD_RS3_MADD" : begin
          if (req_item.register.rs_valid == 3'b111) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 3'b111;
             resp_item.delay_resp = 0;
          end
          else if (req_item.register.rs_valid == 2'b11) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 2'b11;
             resp_item.delay_resp = 0;
          end
          else begin
            resp_item.delay_resp = 1;
          end
        end
      "CUS_ADD_RS3_MSUB" : begin
          if (req_item.register.rs_valid == 3'b111) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 'b111;
             resp_item.delay_resp = 0;
          end
          else if (req_item.register.rs_valid == 2'b11) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 2'b11;
             resp_item.delay_resp = 0;
          end
          else begin
            resp_item.delay_resp = 1;
          end
        end
      "CUS_ADD_RS3_NMADD" : begin
          if (req_item.register.rs_valid == 3'b111) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 'b111;
             resp_item.delay_resp = 0;
          end
          else if (req_item.register.rs_valid == 2'b11) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 2'b11;
             resp_item.delay_resp = 0;
          end
          else begin
            resp_item.delay_resp = 1;
          end
        end
      "CUS_ADD_RS3_NMSUB" : begin
          if (req_item.register.rs_valid == 3'b111) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 'b111;
             resp_item.delay_resp = 0;
          end
          else if (req_item.register.rs_valid == 2'b11) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 2'b11;
             resp_item.delay_resp = 0;
          end
          else begin
            resp_item.delay_resp = 1;
          end
        end
      "CUS_ADD_RS3_RTYPE" : begin
          if (req_item.register.rs_valid == 3'b111) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 'b111;
             resp_item.delay_resp = 0;
          end
          else if (req_item.register.rs_valid == 2'b11) begin
             resp_item.issue_resp.writeback  = 1;
             resp_item.issue_resp.accept     = 1;
             resp_item.issue_resp.register_read  = 2'b11;
             resp_item.delay_resp = 0;
          end
          else begin
            resp_item.delay_resp = 1;
          end
        end
      default : begin
          resp_item.issue_resp.writeback  = 0;
          resp_item.issue_resp.accept     = 0;
          resp_item.issue_resp.register_read = 0;
          resp_item.issue_ready = 1;
        end
   endcase

endtask

task uvme_cvxif_vseq_c::do_compressed_resp();

   case (compressed_instr) inside
      "CUS_CNOP" : begin
         resp_item.compressed_resp.accept  = 1;
         resp_item.compressed_resp.instr   = 32'b00000000000000000000000001111011;
        end
      "CUS_CADD" : begin
         resp_item.compressed_resp.accept  = 1;        
         resp_item.compressed_resp.instr   = 32'b00000000000000000001010101111011;
         resp_item.compressed_resp.instr[19:15] = req_item.compressed_req.instr[11:7];
         resp_item.compressed_resp.instr[24:20] = req_item.compressed_req.instr[6:2];   
        end
        default : begin
             resp_item.compressed_resp.accept = 0;
             resp_item.compressed_resp.instr = req_item.compressed_req.instr; 
        end
    endcase

endtask

task uvme_cvxif_vseq_c::do_result_resp();

   if (req_item.commit_valid && !req_item.commit_req.commit_kill) begin
      resp_item.result_valid  = 1;
      resp_item.result.id     = req_item.commit_req.id;
      resp_item.result.hartid = req_item.commit_req.hartid;
      resp_item.result.we     = resp_item.issue_resp.writeback;
      `uvm_info(info_tag, $sformatf("Request ID : %1d", req_item.commit_req.id), UVM_HIGH);
      do_instr_result();
   end
   else begin
      resp_item.result_valid = 0;
      resp_item.result.id = 0;
      resp_item.result.hartid = 0;
      resp_item.result.data = 0;
      resp_item.result.rd = 0;
      resp_item.result.we = 0;
   end

endtask

task uvme_cvxif_vseq_c::do_instr_result();

   resp_item.result.rd   = 0;
   resp_item.result.data = 0;
   case (instr)
      "CUS_ADD": begin
         if (req_item.register.rs_valid inside {2'b11, 3'b111}) begin
            resp_item.result.data = req_item.register.rs[0] + req_item.register.rs[1];
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
      end
      "CUS_DOUBLE_RS1": begin
         if (req_item.register.rs_valid inside {2'b11, 3'b111}) begin
            resp_item.result.data = req_item.register.rs[0] + req_item.register.rs[0];
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
      end
      "CUS_DOUBLE_RS2": begin
         if (req_item.register.rs_valid inside {2'b11, 3'b111}) begin
            resp_item.result.data = req_item.register.rs[1] + req_item.register.rs[1];
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
      end
      "CUS_ADD_MULTI": begin
         if (req_item.register.rs_valid inside {2'b11, 3'b111}) begin
            resp_item.result.data = req_item.register.rs[0] + req_item.register.rs[1];
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
      end
      "CUS_ADD_RS3_MADD": begin
         if (req_item.register.rs_valid == 3'b111) begin
            resp_item.result.data = req_item.register.rs[0] + req_item.register.rs[1] + req_item.register.rs[2];
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
         else if (req_item.register.rs_valid == 2'b11) begin
            resp_item.result.data = req_item.register.rs[0] + req_item.register.rs[1];
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
      end
      "CUS_ADD_RS3_MSUB": begin
         if (req_item.register.rs_valid == 3'b111) begin
            resp_item.result.data = req_item.register.rs[0] - req_item.register.rs[1] - req_item.register.rs[2];
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
         else if (req_item.register.rs_valid == 2'b11) begin
            resp_item.result.data = req_item.register.rs[0] - req_item.register.rs[1];
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
      end
      "CUS_ADD_RS3_NMADD": begin
         if (req_item.register.rs_valid == 3'b111) begin
            resp_item.result.data = ~(req_item.register.rs[0] + req_item.register.rs[1] + req_item.register.rs[2]);
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
         else if (req_item.register.rs_valid == 2'b11) begin
            resp_item.result.data = ~(req_item.register.rs[0] + req_item.register.rs[1]);
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
      end
      "CUS_ADD_RS3_NMSUB": begin
         if (req_item.register.rs_valid == 3'b111) begin
            resp_item.result.data = ~(req_item.register.rs[0] - req_item.register.rs[1] - req_item.register.rs[2]);
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
         else if (req_item.register.rs_valid == 2'b11) begin
            resp_item.result.data = ~(req_item.register.rs[0] - req_item.register.rs[1]);
            resp_item.result.rd   = req_item.issue_req.instr[11:7];
         end
      end
      "CUS_ADD_RS3_RTYPE": begin
         if (req_item.register.rs_valid == 3'b111) begin
            resp_item.result.data = req_item.register.rs[0] + req_item.register.rs[1] + req_item.register.rs[2];
            resp_item.result.rd   = 5'hA;
         end
         else if (req_item.register.rs_valid == 2'b11) begin
            resp_item.result.data = req_item.register.rs[0] + req_item.register.rs[1];
            resp_item.result.rd   = 5'hA;
         end
      end
      "ILLEGAL": begin
            resp_item.result.data = '0;
            resp_item.result.rd   = '0;
      end
   endcase

endtask

task uvme_cvxif_vseq_c::send_resp(uvma_cvxif_resp_item_c resp);

   resp_item.set_sequencer(p_sequencer);
   `uvm_send(resp_item);

endtask : send_resp


`endif
