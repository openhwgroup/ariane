//
// Copyright 2024 OpenHW Group
// Copyright 2024 Thales
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://solderpad.org/licenses/
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0

// Original Author: Ayoub JALALI (ayoub.jalali@external.thalesgroup.com)

covergroup cg_interrupt(
    string name,
    bit sw_int_supported
) with function sample (
    uvma_isacov_instr_c instr
);
  option.per_instance = 1;
  option.name = name;

  cp_interrupt: coverpoint instr.rvfi.name_csrs["mcause"].wdata {
    bins NO_INTERRUPT = {0} iff (!instr.rvfi.intr);

    ignore_bins IGN_SOFTWARE_INTERRUPT   = {32'h80000003} iff (!sw_int_supported);
    bins MACHINE_MODE_EXTERNAL_INTERRUPT = {32'h8000000b} iff (instr.rvfi.intr);
    bins MACHINE_MODE_SOFTWARE_INTERRUPT = {32'h80000003} iff (instr.rvfi.intr);
    bins MACHINE_MODE_TIMER_INTERRUPT    = {32'h80000007} iff (instr.rvfi.intr);

   }

  cp_mstatus_mie: coverpoint instr.rvfi.name_csrs["mstatus"].wdata[3] {
    bins GLOBAL_INTERRUPT_ENABLE = {1'h1};
   }

  cp_msie: coverpoint instr.rvfi.name_csrs["mie"].wdata[3] {
    ignore_bins IGN_MSIE = {1'h1} iff (!sw_int_supported);
    bins MSIE = {1'h1};
   }

  cp_mtie: coverpoint instr.rvfi.name_csrs["mie"].wdata[7] {
    bins MTIE = {1'h1};
   }

  cp_meie: coverpoint instr.rvfi.name_csrs["mie"].wdata[11] {
    bins MEIE = {1'h1};
   }

  cp_msip: coverpoint instr.rvfi.name_csrs["mip"].wdata[3] {
    ignore_bins IGN_MSIP = {1'h1} iff (!sw_int_supported);
    bins MSIP = {1'h1};
   }

  cp_mtip: coverpoint instr.rvfi.name_csrs["mip"].wdata[7] {
    bins MTIP = {1'h1};
   }

  cp_meip: coverpoint instr.rvfi.name_csrs["mip"].wdata[11] {
    bins MEIP = {1'h1};
   }

endgroup : cg_interrupt

class uvme_interrupt_covg_c extends uvm_component;

    /*
    * Class members
    */
   // Objects
   uvme_cva6_cfg_c         cfg      ;
   uvme_cva6_cntxt_c       cntxt    ;

   // TLM
   uvm_tlm_analysis_fifo#(uvma_isacov_mon_trn_c)  mon_trn_fifo;

   uvma_isacov_mon_trn_c mon_trn;

  `uvm_component_utils(uvme_interrupt_covg_c)

   //Interrupt Covergroup
   cg_interrupt interrupt_cg;

   extern function new(string name = "interrupt_covg", uvm_component parent = null);
   extern function void build_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);

endclass : uvme_interrupt_covg_c

function uvme_interrupt_covg_c::new(string name = "interrupt_covg", uvm_component parent = null);

   super.new(name, parent);

endfunction : new

function void uvme_interrupt_covg_c::build_phase(uvm_phase phase);

   super.build_phase(phase);

   void'(uvm_config_db#(uvme_cva6_cfg_c)::get(this, "", "cfg", cfg));
   if (!cfg) begin
      `uvm_fatal("CFG", "Configuration handle is null")
   end

   if (!cfg.disable_all_csr_checks)
      interrupt_cg = new("interrupt_cg",
                         .sw_int_supported(cfg.sw_int_supported));   else
      `uvm_warning(get_type_name(), "Interrupt coverage will not be scored since config disable_all_csr_checks is true")

   mon_trn_fifo   = new("mon_trn_fifo" , this);

endfunction : build_phase

task uvme_interrupt_covg_c::run_phase(uvm_phase phase);

  super.run_phase(phase);

   `uvm_info(get_type_name(), "The Interrupt env coverage model is running", UVM_LOW);

   if (!cfg.disable_all_csr_checks)
     forever begin
         mon_trn_fifo.get(mon_trn);
         interrupt_cg.sample(mon_trn.instr);
     end

endtask : run_phase
