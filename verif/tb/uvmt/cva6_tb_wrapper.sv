///////////////////////////////////////////////////////////////////////////////
//
// Copyright 2021 OpenHW Group
// Copyright 2021 Thales DIS Design Services SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    https://solderpad.org/licenses/
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
//
///////////////////////////////////////////////////////////////////////////////
//
// CVA6 "core_only" testbench wrapper.
//
///////////////////////////////////////////////////////////////////////////////

`define MAIN_MEM(P) uvmt_cva6_tb.cva6_dut_wrap.cva6_tb_wrapper_i.i_sram.gen_cut[0].i_tc_sram_wrapper.i_tc_sram.init_val[(``P``)]
`define USER_MEM(P) uvmt_cva6_tb.cva6_dut_wrap.cva6_tb_wrapper_i.i_sram.gen_cut[0].gen_mem_user.i_tc_sram_wrapper_user.i_tc_sram.init_val[(``P``)]

import uvm_pkg::*;

`include "uvm_macros.svh"
`include "cvxif_types.svh"


`ifndef DPI_FESVR_SPIKE_UTILS
`define DPI_FESVR_SPIKE_UTILS
import "DPI-C" function void read_elf(input string filename);
import "DPI-C" function byte read_symbol(input string symbol_name, inout longint unsigned address);
import "DPI-C" function byte get_section(output longint address, output longint len);
import "DPI-C" context function read_section_sv(input longint address, inout byte buffer[]);
`endif

module cva6_tb_wrapper import uvmt_cva6_pkg::*; #(
  parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
  parameter type rvfi_instr_t = logic,
  parameter type rvfi_csr_elmt_t = logic,
  parameter type rvfi_csr_t = logic,
  parameter type rvfi_probes_instr_t = logic,
  parameter type rvfi_probes_csr_t = logic,
  parameter type rvfi_probes_t = logic,
  // CVXIF Types
  localparam type readregflags_t      = `READREGFLAGS_T(CVA6Cfg),
  localparam type writeregflags_t     = `WRITEREGFLAGS_T(CVA6Cfg),
  localparam type id_t                = `ID_T(CVA6Cfg),
  localparam type hartid_t            = `HARTID_T(CVA6Cfg),
  localparam type x_compressed_req_t  = `X_COMPRESSED_REQ_T(CVA6Cfg, hartid_t),
  localparam type x_compressed_resp_t = `X_COMPRESSED_RESP_T(CVA6Cfg),
  localparam type x_issue_req_t       = `X_ISSUE_REQ_T(CVA6Cfg, hartit_t, id_t),
  localparam type x_issue_resp_t      = `X_ISSUE_RESP_T(CVA6Cfg, writeregflags_t, readregflags_t),
  localparam type x_register_t        = `X_REGISTER_T(CVA6Cfg, hartid_t, id_t, readregflags_t),
  localparam type x_commit_t          = `X_COMMIT_T(CVA6Cfg, hartid_t, id_t),
  localparam type x_result_t          = `X_RESULT_T(CVA6Cfg, hartid_t, id_t, writeregflags_t),
  localparam type cvxif_req_t         = `CVXIF_REQ_T(CVA6Cfg, x_compressed_req_t, x_issue_req_t, x_register_req_t, x_commit_t),
  localparam type cvxif_resp_t        = `CVXIF_RESP_T(CVA6Cfg, x_compressed_resp_t, x_issue_resp_t, x_result_t),
  //
  parameter int unsigned AXI_USER_EN       = 0,
  parameter int unsigned NUM_WORDS         = 2**25
) (
  input  logic                         clk_i,
  input  logic                         rst_ni,
  input  logic [CVA6Cfg.VLEN-1:0]      boot_addr_i,
  output logic [31:0]                  tb_exit_o,
  output rvfi_instr_t [CVA6Cfg.NrCommitPorts-1:0] rvfi_o,
  output rvfi_csr_t                    rvfi_csr_o,
  input  logic [15:0]                  irq_i,
  uvma_debug_if                        debug_if,
  uvma_axi_intf                        axi_slave,
  uvma_cvxif_intf                      cvxif_if,
  uvmt_axi_switch_intf                 axi_switch_vif,
  uvmt_default_inputs_intf             default_inputs_vif
);

  ariane_axi::req_t    axi_ariane_req;
  ariane_axi::resp_t   axi_ariane_resp;

  static uvm_cmdline_processor uvcl = uvm_cmdline_processor::get_inst();
  string binary = "";

  rvfi_instr_t [CVA6Cfg.NrCommitPorts-1:0]  rvfi_instr;
  rvfi_probes_t rvfi_probes;
  rvfi_csr_t rvfi_csr;
  assign rvfi_o = rvfi_instr;
  assign rvfi_csr_o = rvfi_csr;

  cvxif_req_t  cvxif_req;
  cvxif_resp_t cvxif_resp;

  cva6 #(
     .CVA6Cfg ( CVA6Cfg ),
     .rvfi_probes_instr_t  ( rvfi_probes_instr_t ),
     .rvfi_probes_csr_t    ( rvfi_probes_csr_t   ),
     .rvfi_probes_t        ( rvfi_probes_t       )
   ) i_cva6 (
    .clk_i                ( clk_i                        ),
    .rst_ni               ( rst_ni                       ),
    .boot_addr_i          ( boot_addr_i                  ),//Driving the boot_addr value from the core control agent
    .hart_id_i            ( default_inputs_vif.hart_id   ),
    .irq_i                ( {1'b0, irq_i[0]}             ),
    .ipi_i                ( 1'b0                         ),
    .time_irq_i           ( irq_i[1]                     ),
    .debug_req_i          ( debug_if.debug_req           ),
    .rvfi_probes_o        ( rvfi_probes                  ),
    .cvxif_req_o          ( cvxif_req                    ),
    .cvxif_resp_i         ( cvxif_resp                   ),
    .noc_req_o            ( axi_ariane_req               ),
    .noc_resp_i           ( axi_ariane_resp              )
  );

  //----------------------------------------------------------------------------
  // RVFI
  //----------------------------------------------------------------------------

  cva6_rvfi #(
      .CVA6Cfg   (CVA6Cfg),
      .rvfi_instr_t(rvfi_instr_t),
      .rvfi_csr_t(rvfi_csr_t),
      .rvfi_probes_instr_t(rvfi_probes_instr_t),
      .rvfi_probes_csr_t(rvfi_probes_csr_t),
      .rvfi_probes_t(rvfi_probes_t)
  ) i_cva6_rvfi (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .rvfi_probes_i(rvfi_probes),
      .rvfi_instr_o(rvfi_instr),
      .rvfi_csr_o(rvfi_csr)
  );

  rvfi_tracer  #(
    .CVA6Cfg(CVA6Cfg),
    .rvfi_instr_t(rvfi_instr_t),
    .rvfi_csr_t(rvfi_csr_t),
    //
    .HART_ID(8'h0),
    .DEBUG_START(0),
    .DEBUG_STOP(0)
  ) i_rvfi_tracer (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .rvfi_i(rvfi_instr),
    .rvfi_csr_i(rvfi_csr),
    .end_of_test_o(tb_exit_o)
  ) ;

  //----------------------------------------------------------------------------
  // Memory
  //----------------------------------------------------------------------------

  logic                         req;
  logic                         we;
  logic [CVA6Cfg.AxiAddrWidth-1:0] addr;
  logic [CVA6Cfg.AxiDataWidth/8-1:0]  be;
  logic [CVA6Cfg.AxiDataWidth-1:0]    wdata;
  logic [CVA6Cfg.AxiUserWidth-1:0]    wuser;
  logic [CVA6Cfg.AxiDataWidth-1:0]    rdata;
  logic [CVA6Cfg.AxiUserWidth-1:0]    ruser;

  //Response structs
   assign axi_ariane_resp.aw_ready = (axi_switch_vif.active) ? axi_slave.aw_ready : cva6_axi_bus.aw_ready;
   assign axi_ariane_resp.ar_ready = (axi_switch_vif.active) ? axi_slave.ar_ready : cva6_axi_bus.ar_ready;
   assign axi_ariane_resp.w_ready  = (axi_switch_vif.active) ? axi_slave.w_ready  : cva6_axi_bus.w_ready;
   assign axi_ariane_resp.b_valid  = (axi_switch_vif.active) ? axi_slave.b_valid  : cva6_axi_bus.b_valid;
   assign axi_ariane_resp.r_valid  = (axi_switch_vif.active) ? axi_slave.r_valid  : cva6_axi_bus.r_valid;
   // B Channel
   assign axi_ariane_resp.b.id   = (axi_switch_vif.active) ? axi_slave.b_id   : cva6_axi_bus.b_id;
   assign axi_ariane_resp.b.resp = (axi_switch_vif.active) ? axi_slave.b_resp : cva6_axi_bus.b_resp;
   assign axi_ariane_resp.b.user = (axi_switch_vif.active) ? axi_slave.b_user : cva6_axi_bus.b_user;
   // R Channel
   assign axi_ariane_resp.r.id   = (axi_switch_vif.active) ? axi_slave.r_id   : cva6_axi_bus.r_id;
   assign axi_ariane_resp.r.data = (axi_switch_vif.active) ? axi_slave.r_data : cva6_axi_bus.r_data;
   assign axi_ariane_resp.r.resp = (axi_switch_vif.active) ? axi_slave.r_resp : cva6_axi_bus.r_resp;
   assign axi_ariane_resp.r.last = (axi_switch_vif.active) ? axi_slave.r_last : cva6_axi_bus.r_last;
   assign axi_ariane_resp.r.user = (axi_switch_vif.active) ? axi_slave.r_user : cva6_axi_bus.r_user;

   assign axi_slave.aw_ready  = (axi_switch_vif.active) ? 'z : cva6_axi_bus.aw_ready;
   assign axi_slave.ar_ready  = (axi_switch_vif.active) ? 'z : cva6_axi_bus.ar_ready;
   assign axi_slave.w_ready   = (axi_switch_vif.active) ? 'z : cva6_axi_bus.w_ready;
   assign axi_slave.b_valid   = (axi_switch_vif.active) ? 'z : cva6_axi_bus.b_valid;
   assign axi_slave.r_valid   = (axi_switch_vif.active) ? 'z : cva6_axi_bus.r_valid;

   assign axi_slave.b_id      = (axi_switch_vif.active) ? 'z : cva6_axi_bus.b_id;
   assign axi_slave.b_resp    = (axi_switch_vif.active) ? 'z : cva6_axi_bus.b_resp;
   assign axi_slave.b_user    = (axi_switch_vif.active) ? 'z : cva6_axi_bus.b_user;

   assign axi_slave.r_id      = (axi_switch_vif.active) ? 'z : cva6_axi_bus.r_id;
   assign axi_slave.r_data    = (axi_switch_vif.active) ? 'z : cva6_axi_bus.r_data;
   assign axi_slave.r_resp    = (axi_switch_vif.active) ? 'z : cva6_axi_bus.r_resp;
   assign axi_slave.r_last    = (axi_switch_vif.active) ? 'z : cva6_axi_bus.r_last;
   assign axi_slave.r_user    = (axi_switch_vif.active) ? 'z : cva6_axi_bus.r_user;

   // Request structs
   assign axi_slave.aw_valid = axi_ariane_req.aw_valid;
   assign axi_slave.w_valid  = axi_ariane_req.w_valid;
   assign axi_slave.b_ready  = axi_ariane_req.b_ready;
   assign axi_slave.ar_valid = axi_ariane_req.ar_valid;
   assign axi_slave.r_ready  = axi_ariane_req.r_ready;
   // AW Channel
   assign axi_slave.aw_id     = axi_ariane_req.aw.id;
   assign axi_slave.aw_addr   = axi_ariane_req.aw.addr;
   assign axi_slave.aw_len    = axi_ariane_req.aw.len;
   assign axi_slave.aw_size   = axi_ariane_req.aw.size;
   assign axi_slave.aw_burst  = axi_ariane_req.aw.burst;
   assign axi_slave.aw_lock   = axi_ariane_req.aw.lock;
   assign axi_slave.aw_cache  = axi_ariane_req.aw.cache;
   assign axi_slave.aw_prot   = axi_ariane_req.aw.prot;
   assign axi_slave.aw_qos    = axi_ariane_req.aw.qos;
   assign axi_slave.aw_region = axi_ariane_req.aw.region;
   assign axi_slave.aw_atop   = axi_ariane_req.aw.atop;
   assign axi_slave.aw_user   = 0;
    // W Channel
   assign axi_slave.w_data = axi_ariane_req.w.data;
   assign axi_slave.w_strb = axi_ariane_req.w.strb;
   assign axi_slave.w_last = axi_ariane_req.w.last;
   assign axi_slave.w_user = 0;
   // AR Channel
   assign axi_slave.ar_id     = axi_ariane_req.ar.id;
   assign axi_slave.ar_addr   = axi_ariane_req.ar.addr;
   assign axi_slave.ar_len    = axi_ariane_req.ar.len;
   assign axi_slave.ar_size   = axi_ariane_req.ar.size;
   assign axi_slave.ar_burst  = axi_ariane_req.ar.burst;
   assign axi_slave.ar_lock   = axi_ariane_req.ar.lock;
   assign axi_slave.ar_cache  = axi_ariane_req.ar.cache;
   assign axi_slave.ar_prot   = axi_ariane_req.ar.prot;
   assign axi_slave.ar_qos    = axi_ariane_req.ar.qos;
   assign axi_slave.ar_region = axi_ariane_req.ar.region;
   assign axi_slave.ar_user   = 0;

  //CVXIF Response structs
   assign cvxif_resp.compressed_ready  = cvxif_if.compressed_ready;
   assign cvxif_resp.compressed_resp   = cvxif_if.compressed_resp;
   assign cvxif_resp.issue_ready       = cvxif_if.issue_ready;
   assign cvxif_resp.issue_resp        = cvxif_if.issue_resp;
   assign cvxif_resp.register_ready    = cvxif_if.register_ready;
   assign cvxif_resp.result_valid      = cvxif_if.result_valid;
   assign cvxif_resp.result            = cvxif_if.result;

   // Request structs
   assign cvxif_if.compressed_valid    = cvxif_req.compressed_valid;
   assign cvxif_if.compressed_req      = cvxif_req.compressed_req;
   assign cvxif_if.issue_valid         = cvxif_req.issue_valid;
   assign cvxif_if.issue_req.instr     = cvxif_req.issue_req.instr;
   assign cvxif_if.issue_req.hartid    = cvxif_req.issue_req.hartid;
   assign cvxif_if.issue_req.id        = cvxif_req.issue_req.id;
   assign cvxif_if.register_valid      = cvxif_req.register_valid;
   assign cvxif_if.register            = cvxif_req.register;
   assign cvxif_if.commit_valid        = cvxif_req.commit_valid;
   assign cvxif_if.commit_req          = cvxif_req.commit;
   assign cvxif_if.result_ready        = cvxif_req.result_ready;



  AXI_BUS #(
    .AXI_ADDR_WIDTH ( CVA6Cfg.AxiAddrWidth         ),
    .AXI_DATA_WIDTH ( CVA6Cfg.AxiDataWidth         ),
    .AXI_ID_WIDTH   ( ariane_axi_soc::IdWidthSlave ),
    .AXI_USER_WIDTH ( CVA6Cfg.AxiUserWidth         )
  ) cva6_axi_bus();

  axi_master_connect #(
  ) i_axi_master_connect_cva6_to_mem (
    .axi_req_i  (axi_ariane_req),
    .dis_mem    (axi_switch_vif.active),
    .master     (cva6_axi_bus)
  );

  axi2mem #(
    .AXI_ID_WIDTH   ( ariane_axi_soc::IdWidthSlave ),
    .AXI_ADDR_WIDTH ( CVA6Cfg.AxiAddrWidth         ),
    .AXI_DATA_WIDTH ( CVA6Cfg.AxiDataWidth         ),
    .AXI_USER_WIDTH ( CVA6Cfg.AxiUserWidth         )
  ) i_cva6_axi2mem (
    .clk_i  ( clk_i       ),
    .rst_ni ( rst_ni      ),
    .slave  ( cva6_axi_bus ),
    .req_o  ( req          ),
    .we_o   ( we           ),
    .addr_o ( addr         ),
    .be_o   ( be           ),
    .user_o ( wuser        ),
    .data_o ( wdata        ),
    .user_i ( ruser        ),
    .data_i ( rdata        )
  );

  sram #(
    .USER_WIDTH ( CVA6Cfg.AxiUserWidth ),
    .DATA_WIDTH ( CVA6Cfg.AxiDataWidth ),
    .USER_EN    ( AXI_USER_EN    ),
    .SIM_INIT   ( "zeros"        ),
    .NUM_WORDS  ( NUM_WORDS      )
  ) i_sram (
    .clk_i      ( clk_i                                                                       ),
    .rst_ni     ( rst_ni                                                                      ),
    .req_i      ( req                                                                         ),
    .we_i       ( we                                                                          ),
    .addr_i     ( addr[$clog2(NUM_WORDS)-1+$clog2(CVA6Cfg.AxiDataWidth/8):$clog2(CVA6Cfg.AxiDataWidth/8)] ),
    .wuser_i    ( wuser                                                                       ),
    .wdata_i    ( wdata                                                                       ),
    .be_i       ( be                                                                          ),
    .ruser_o    ( ruser                                                                       ),
    .rdata_o    ( rdata                                                                       )
  );

    initial begin
        wait (
          !$isunknown(axi_switch_vif.active)
        );
        if(!axi_switch_vif.active) begin
           automatic logic [7:0][7:0] mem_row;
           longint address, load_address, last_load_address;
           longint len;
           byte buffer[];
           void'(uvcl.get_arg_value("+elf_file=", binary));

           if (binary != "") begin

               read_elf(binary);
               wait(clk_i);

               last_load_address = 'hFFFFFFFF;
               // while there are more sections to process
               while (get_section(address, len)) begin
                   automatic int num_words0 = (len+7)/8;
                   `uvm_info( "Core Test", $sformatf("Loading Address: %x, Length: %x", address, len), UVM_LOW)
                   buffer = new [num_words0*8];
                   read_section_sv(address, buffer);
                   // preload memories
                   // 64-bit
                   for (int i = 0; i < num_words0; i++) begin
                       mem_row = '0;
                       for (int j = 0; j < 8; j++) begin
                           mem_row[j] = buffer[i*8 + j];
                       end
                       load_address = (address[23:0] >> 3) + i;
                       if (load_address != last_load_address) begin
                          if (address[31:0] < 'h84000000) begin
                            `MAIN_MEM(load_address) = mem_row;
                          end else begin
                             `USER_MEM(load_address) = mem_row;
                          end
                          last_load_address = load_address;
                       end else begin
                           `uvm_info( "Debug info", $sformatf(" Address: %x Already Loaded! ELF file might have less than 64 bits granularity on segments.", load_address), UVM_LOW)
                       end
                   end
               end
           end
        end
    end

endmodule
