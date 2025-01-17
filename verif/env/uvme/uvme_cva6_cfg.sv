// Copyright 2020 OpenHW Group
// Copyright 2020 Datum Technology Corporation
// Copyright 2020 Silicon Labs, Inc.
// Copyright 2021 Thales DIS Design Services SAS
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


`ifndef __UVME_CVA6_CFG_SV__
`define __UVME_CVA6_CFG_SV__


/**
 * Object encapsulating all parameters for creating, connecting and running
 * CVA6 environment (uvme_cva6_env_c) components.
 */
class uvme_cva6_cfg_c extends uvma_core_cntrl_cfg_c;

   // Integrals
   rand bit                      enabled;

   rand bit                      scoreboard_enabled;
   rand bit                      tandem_enabled;
   rand bit                      cov_model_enabled;
   rand bit                      trn_log_enabled;
   rand bit                      force_disable_csr_checks; // force disable all csr checks in RVFI. Note that all csrs info in instruction from RVFI will be removed
   rand int unsigned             sys_clk_period;

   bit                           performance_mode; // Will force disable coverage, csr checks, scoreboard and loggers

   // Agent cfg handles
   rand uvma_clknrst_cfg_c                clknrst_cfg;
   rand uvma_axi_cfg_c                    axi_cfg;
   rand uvma_rvfi_cfg_c#(ILEN,XLEN)       rvfi_cfg;
   rand uvma_isacov_cfg_c                 isacov_cfg;
   rand uvma_interrupt_cfg_c              interrupt_cfg;
   rand uvma_cvxif_cfg_c                  cvxif_cfg;

   // Zicond extension
   rand bit                      ext_zicond_supported;

   // HPDcache support
   rand bit                      HPDCache_supported;

   // pmp entries
   rand int                      nr_pmp_entries;

   // Zihpm extension
   rand bit                      ext_zihpm_supported;

   // MMU support
   rand bit                      MmuPresent;

   // Software interrupt supported
   rand bit                      sw_int_supported;

   `uvm_object_utils_begin(uvme_cva6_cfg_c)
      `uvm_field_int (                         enabled                     , UVM_DEFAULT          )
      `uvm_field_enum(uvm_active_passive_enum, is_active                   , UVM_DEFAULT          )
      `uvm_field_int (                         scoreboard_enabled          , UVM_DEFAULT          )
      `uvm_field_int (                         tandem_enabled              , UVM_DEFAULT          )
      `uvm_field_int (                         cov_model_enabled           , UVM_DEFAULT          )
      `uvm_field_int (                         trn_log_enabled             , UVM_DEFAULT          )
      `uvm_field_int (                         force_disable_csr_checks    , UVM_DEFAULT          )
      `uvm_field_int (                         ext_zicond_supported        , UVM_DEFAULT          )
      `uvm_field_int (                         HPDCache_supported          , UVM_DEFAULT          )
      `uvm_field_int (                         nr_pmp_entries              , UVM_DEFAULT          )
      `uvm_field_int (                         ext_zihpm_supported         , UVM_DEFAULT          )
      `uvm_field_int (                         MmuPresent                  , UVM_DEFAULT          )
      `uvm_field_int (                         sw_int_supported            , UVM_DEFAULT          )
      `uvm_field_int (                         sys_clk_period            , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int (                         performance_mode            , UVM_DEFAULT          )

      `uvm_field_object(clknrst_cfg, UVM_DEFAULT)

      `uvm_field_object(axi_cfg, UVM_DEFAULT)

      `uvm_field_object(rvfi_cfg,    UVM_DEFAULT)

      `uvm_field_object(isacov_cfg,  UVM_DEFAULT)

      `uvm_field_object(interrupt_cfg,  UVM_DEFAULT)

      `uvm_field_object(cvxif_cfg,  UVM_DEFAULT)

   `uvm_object_utils_end


   constraint defaults_cons {
      soft enabled                 == 1;
      soft is_active               == UVM_ACTIVE;
      soft scoreboard_enabled      == 1;
      soft cov_model_enabled       == 1;
      soft trn_log_enabled         == 1;
      soft force_disable_csr_checks == 0;
      soft sys_clk_period          == uvme_cva6_sys_default_clk_period; // see uvme_cva6_constants.sv
   }

   constraint cva6_riscv_cons {
      xlen == RTLCVA6Cfg.XLEN;

      ext_zihpm_supported    == 0;
      ext_zicond_supported   == RTLCVA6Cfg.RVZiCond;

      nr_pmp_entries         == 64;

      unaligned_access_supported     == 0;
      unaligned_access_amo_supported == 0;

      bitmanip_version        == BITMANIP_VERSION_1P00;
      priv_spec_version       == PRIV_VERSION_MASTER;
      endianness              == ENDIAN_LITTLE;

      boot_addr_valid         == 1;
      mtvec_addr_valid        == 1;
      dm_halt_addr_valid      == 1;
      dm_exception_addr_valid == 1;
      nmi_addr_valid          == 1;
      HPDCache_supported      == (RTLCVA6Cfg.DCacheType == 2);

      MmuPresent              == RTLCVA6Cfg.MmuPresent;
      sw_int_supported        == RTLCVA6Cfg.SoftwareInterruptEn;
   }

   constraint ext_const {
      if (!ext_c_supported) {
         ext_zcb_supported == 0;
      }
   }

   constraint pmp_const {
      if (!pmp_supported) {
         nr_pmp_entries == 0;
      }
      else {
         nr_pmp_entries inside {0, 16, 64};
      }
   }

   constraint default_cva6_boot_cons {
      (!boot_addr_plusarg_valid)         -> (boot_addr         == 'h8000_0000);
   }

   constraint default_cons {
      if (interrupt_cfg.interrupt_plusarg_valid) {
         interrupt_cfg.enable_interrupt == 'h1;
      }
      else {
         interrupt_cfg.enable_interrupt == 'h0;
      }

      if (cvxif_cfg.cvxif_plusarg_valid) {
         cvxif_cfg.enabled_cvxif == 'h1;
      }
      else {
         cvxif_cfg.enabled_cvxif == 'h0;
      }
   }

   constraint agent_cfg_cons {
      if (enabled) {
         clknrst_cfg.enabled    == 1;
         isacov_cfg.enabled     == 1;
         rvfi_cfg.enabled       == 1;
         interrupt_cfg.enabled  == 1;
      }

      isacov_cfg.seq_instr_group_x2_enabled == 1;
      isacov_cfg.seq_instr_group_x3_enabled == 0;
      isacov_cfg.seq_instr_group_x4_enabled == 0;
      isacov_cfg.seq_instr_x2_enabled       == 1;
      isacov_cfg.reg_crosses_enabled        == 0;
      isacov_cfg.reg_hazards_enabled        == 1;
      rvfi_cfg.nret                         == RTLCVA6Cfg.NrCommitPorts;
      unified_traps                         == 0;
      axi_cfg.zero_delay_mode               == 1;
      axi_cfg.disable_trs_randomization     == 1;

      if (is_active == UVM_ACTIVE) {
         clknrst_cfg.is_active        == UVM_ACTIVE;
         isacov_cfg.is_active         == UVM_PASSIVE;
         rvfi_cfg.is_active           == UVM_PASSIVE;
         interrupt_cfg.is_active      == UVM_ACTIVE;
      }

      if (trn_log_enabled) {
         clknrst_cfg.trn_log_enabled   == 0;
         axi_cfg.trn_log_enabled       == 1;
         rvfi_cfg.trn_log_enabled      == 1;
         isacov_cfg.trn_log_enabled    == 1;
      } else {
         clknrst_cfg.trn_log_enabled   == 0;
         axi_cfg.trn_log_enabled       == 0;
         rvfi_cfg.trn_log_enabled      == 0;
         isacov_cfg.trn_log_enabled    == 0;
      }

      if (cov_model_enabled) {
         isacov_cfg.cov_model_enabled    == 1;
         axi_cfg.cov_model_enabled       == 1;
         interrupt_cfg.cov_model_enabled == 1;
      } else {
         isacov_cfg.cov_model_enabled    == 0;
         axi_cfg.cov_model_enabled       == 0;
         interrupt_cfg.cov_model_enabled == 0;
      }

   }

   /**
    * Creates sub-configuration objects.
    */
   extern function new(string name="uvme_cva6_cfg");

      /**
    * Sample the parameters of the DUT via the virtual interface in a context
    */
   extern virtual function void sample_parameters(uvma_core_cntrl_cntxt_c cntxt);

   /**
    * Set unsupported_csr_mask based on extensions/modes supported
    */
   extern virtual function void set_unsupported_csr_mask();

   extern virtual function void read_disable_csr_check_plusargs();

   /**
    * Get irq_addr ack
    */
   extern virtual function bit [XLEN-1:0] get_irq_addr();

endclass : uvme_cva6_cfg_c


function uvme_cva6_cfg_c::new(string name="uvme_cva6_cfg");

   super.new(name);

   clknrst_cfg  = uvma_clknrst_cfg_c::type_id::create("clknrst_cfg");
   axi_cfg      = uvma_axi_cfg_c::type_id::create("axi_cfg");
   rvfi_cfg     = uvma_rvfi_cfg_c#(ILEN,XLEN)::type_id::create("rvfi_cfg");
   isacov_cfg   = uvma_isacov_cfg_c::type_id::create("isacov_cfg");
   interrupt_cfg   = uvma_interrupt_cfg_c::type_id::create("interrupt_cfg");
   cvxif_cfg       = uvma_cvxif_cfg_c::type_id::create("cvxif_cfg");

   isacov_cfg.core_cfg = this;
   rvfi_cfg.core_cfg = this;

   $value$plusargs("core_name=%s", this.core_name);

   if ($test$plusargs("tb_performance_mode")) begin
      performance_mode = 1;
      `uvm_info(get_type_name(), "Testbench set in performance mode, coverage & csr checks & scoreboard & loggers will be deactivated", UVM_NONE);
   end

endfunction : new

function void uvme_cva6_cfg_c::sample_parameters(uvma_core_cntrl_cntxt_c cntxt);

   uvma_cva6_core_cntrl_cntxt_c cva6_cntxt;

   if (!$cast(cva6_cntxt, cntxt)) begin
      `uvm_fatal("SAMPLECNTXT", "Could not cast cntxt to uvma_cva6_core_cntrl_cntxt_c");
   end

endfunction : sample_parameters

function bit [XLEN-1:0] uvme_cva6_cfg_c::get_irq_addr();

   int unsigned IRQ_ADDR;
   string binary;

    if (!$value$plusargs("irq_addr=%h", IRQ_ADDR)) IRQ_ADDR = '0;
    if (IRQ_ADDR == '0) begin
        if (!$value$plusargs("elf_file=%s", binary)) binary = "";
        if (binary != "") begin
            read_elf(binary);
            read_symbol("int_ack", IRQ_ADDR);
        end
      `uvm_info(get_type_name(), $sformatf("[IRQ] INFO: int_ack_addr: %h", IRQ_ADDR), UVM_NONE)
    end

    return IRQ_ADDR;

endfunction : get_irq_addr

function void uvme_cva6_cfg_c::set_unsupported_csr_mask();

   super.set_unsupported_csr_mask();

   // Add supported CSRs for Embedded configuration
   for (int i = 0; i < MAX_NUM_HPMCOUNTERS; i++) begin
      unsupported_csr_mask[uvma_core_cntrl_pkg::MHPMEVENT3+i] = 0;
      if (xlen == 32) begin
         unsupported_csr_mask[uvma_core_cntrl_pkg::MHPMCOUNTER3+i] = 0;
         unsupported_csr_mask[uvma_core_cntrl_pkg::MHPMCOUNTER3H+i] = 0;
      end
      else if (xlen == 64) begin
         unsupported_csr_mask[uvma_core_cntrl_pkg::MHPMCOUNTER3+i] = 1;
         unsupported_csr_mask[uvma_core_cntrl_pkg::MHPMCOUNTER3H+i] = 1;
      end
   end

   // Zihpm extension CSRs
   if (ext_zihpm_supported) begin
      for (int i = 0; i < MAX_NUM_HPMCOUNTERS; i++) begin
         unsupported_csr_mask[uvma_core_cntrl_pkg::HPMCOUNTER3+i] = 0;
         if (xlen == 32) begin
            unsupported_csr_mask[uvma_core_cntrl_pkg::HPMCOUNTER3H+i] = 0;
         end
         else if (xlen ==64) begin
            unsupported_csr_mask[uvma_core_cntrl_pkg::HPMCOUNTER3H+i] = 1;
         end
      end
   end
   else begin
      for (int i = 0; i < MAX_NUM_HPMCOUNTERS; i++) begin
         unsupported_csr_mask[uvma_core_cntrl_pkg::HPMCOUNTER3+i] = 1;
         unsupported_csr_mask[uvma_core_cntrl_pkg::HPMCOUNTER3H+i] = 1;
      end
   end

   // Upper Machine mode CSRs
   if (xlen == 32) begin
      unsupported_csr_mask[uvma_core_cntrl_pkg::MSTATUSH] = 0;
      unsupported_csr_mask[uvma_core_cntrl_pkg::MCYCLEH] = 0;
      unsupported_csr_mask[uvma_core_cntrl_pkg::MINSTRETH] = 0;
   end
   else if (xlen == 64) begin
      unsupported_csr_mask[uvma_core_cntrl_pkg::MSTATUSH] = 1;
      unsupported_csr_mask[uvma_core_cntrl_pkg::MCYCLEH] = 1;
      unsupported_csr_mask[uvma_core_cntrl_pkg::MINSTRETH] = 1;
   end

   // Remove unsupported pmp CSRs
   if (nr_pmp_entries == 0) begin
       unsupported_csr_mask[uvma_core_cntrl_pkg::PMPCFG0+:16]  = 16'hffff;
       unsupported_csr_mask[uvma_core_cntrl_pkg::PMPADDR0+:64] = 64'hffffffffffffffff;
   end
   else if (nr_pmp_entries == 16) begin
       unsupported_csr_mask[uvma_core_cntrl_pkg::PMPCFG4+:12]   = 12'hfff;
       unsupported_csr_mask[uvma_core_cntrl_pkg::PMPADDR16+:48] = 48'hffffffffffff;
   end
   else if (nr_pmp_entries == 64) begin //if pmp entries is 64 we support all the pmp CSRs
       unsupported_csr_mask[uvma_core_cntrl_pkg::PMPCFG0+:16]  = 16'h0;
       unsupported_csr_mask[uvma_core_cntrl_pkg::PMPADDR0+:64] = 64'h0;
   end

endfunction : set_unsupported_csr_mask

function void uvme_cva6_cfg_c::read_disable_csr_check_plusargs();

   super.read_disable_csr_check_plusargs();
   if (force_disable_csr_checks)
      disable_all_csr_checks = 1;

endfunction : read_disable_csr_check_plusargs

`endif // __UVME_CVA6_CFG_SV__
