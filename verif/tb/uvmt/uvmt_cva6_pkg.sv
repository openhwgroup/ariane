// Copyright 2020 OpenHW Group
// Copyright 2020 Datum Technologies
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


`ifndef __UVMT_CVA6_PKG_SV__
`define __UVMT_CVA6_PKG_SV__


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvml_hrtbt_macros.sv"
`include "uvml_logs_macros.sv"
`include "uvmt_cva6_macros.sv"

`include "uvmt_axi_switch_intf.sv"
`include "uvmt_default_inputs_intf.sv"
`include "uvma_axi_intf.sv"

/**
 * Encapsulates all the types and test cases for the verification of an
 * CVA6 RTL design.
 */
package uvmt_cva6_pkg;

   import uvm_pkg::*;
   import uvma_core_cntrl_pkg::*;
   import uvme_cva6_pkg::*;
   import uvmc_rvfi_reference_model_pkg::*;
   import uvma_cva6pkg_utils_pkg::*;
   import uvml_hrtbt_pkg::*;
   import uvml_logs_pkg::*;
   import uvml_mem_pkg::*;
   import uvma_axi_pkg::*;

   // Constants / Structs / Enums
   `include "uvmt_cva6_constants.sv"
   `include "uvmt_cva6_tdefs.sv"

   // Virtual sequence library
   // TODO Add virtual sequences
   //      Ex: `include "uvmt_cva6_sanity_vseq.sv"
   `include "uvmt_cva6_vseq_lib.sv"

   // Base test case
   `include "uvmt_cva6_test_cfg.sv"
   `include "uvmt_cva6_base_test.sv"  // all testcases should extend from this testcase
   //`include "uvmt_cva6_smoke_test.sv" // smoke test has multile XMRs that are illegal according to the LRM

   // Compilance tests
   `include "uvmt_cva6_firmware_test.sv"

endpackage : uvmt_cva6_pkg

// All Interfaces used by the CVA6 TB are here
//`include "uvmt_cva6_tb_ifs.sv"

`endif // __UVMT_CVA6_PKG_SV__
