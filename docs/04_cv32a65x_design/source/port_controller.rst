..
   Copyright 2024 Thales DIS France SAS
   Licensed under the Solderpad Hardware License, Version 2.1 (the "License");
   you may not use this file except in compliance with the License.
   SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
   You may obtain a copy of the License at https://solderpad.org/licenses/

   Original Author: Jean-Roch COULON - Thales

.. _CVA6_controller_ports:

.. list-table:: controller module IO ports
   :header-rows: 1

   * - Signal
     - IO
     - Description
     - connexion
     - Type

   * - ``clk_i``
     - in
     - Subsystem Clock
     - SUBSYSTEM
     - Subsystem Clock
     - logic

   * - ``rst_ni``
     - in
     - Asynchronous reset active low
     - SUBSYSTEM
     - Asynchronous reset active low
     - logic

   * - ``set_pc_commit_o``
     - out
     - Set PC om PC Gen
     - FRONTEND
     - Set PC om PC Gen
     - logic

   * - ``flush_if_o``
     - out
     - Flush the IF stage
     - FRONTEND
     - Flush the IF stage
     - logic

   * - ``flush_unissued_instr_o``
     - out
     - Flush un-issued instructions of the scoreboard
     - FRONTEND
     - Flush un-issued instructions of the scoreboard
     - logic

   * - ``flush_id_o``
     - out
     - Flush ID stage
     - ID_STAGE
     - Flush ID stage
     - logic

   * - ``flush_ex_o``
     - out
     - Flush EX stage
     - EX_STAGE
     - Flush EX stage
     - logic

   * - ``flush_bp_o``
     - out
     - Flush branch predictors
     - FRONTEND
     - Flush branch predictors
     - logic

   * - ``flush_icache_o``
     - out
     - Flush ICache
     - CACHE
     - Flush ICache
     - logic

   * - ``flush_dcache_o``
     - out
     - Flush DCache
     - CACHE
     - Flush DCache
     - logic

   * - ``flush_dcache_ack_i``
     - in
     - Acknowledge the whole DCache Flush
     - CACHE
     - Acknowledge the whole DCache Flush
     - logic

   * - ``flush_tlb_o``
     - out
     - Flush TLBs
     - EX_STAGE
     - Flush TLBs
     - logic

   * - ``halt_csr_i``
     - in
     - Halt request from CSR (WFI instruction)
     - CSR_REGFILE
     - Halt request from CSR (WFI instruction)
     - logic

   * - ``halt_acc_i``
     - in
     - ACC_DISPATCHER
     - Halt request from accelerator dispatcher
     - logic

   * - ``halt_o``
     - out
     - Halt signal to commit stage
     - COMMIT_STAGE
     - Halt signal to commit stage
     - logic

   * - ``eret_i``
     - in
     - Return from exception
     - CSR_REGFILE
     - Return from exception
     - logic

   * - ``ex_valid_i``
     - in
     - FRONTEND
     - We got an exception, flush the pipeline
     - logic

   * - ``set_debug_pc_i``
     - in
     - FRONTEND
     - set the debug pc from CSR
     - logic

   * - ``resolved_branch_i``
     - in
     - We got a resolved branch, check if we need to flush the front-end
     - EX_STAGE
     - We got a resolved branch, check if we need to flush the front-end
     - bp_resolve_t

   * - ``flush_csr_i``
     - in
     - We got an instruction which altered the CSR, flush the pipeline
     - CSR_REGFILE
     - We got an instruction which altered the CSR, flush the pipeline
     - logic

   * - ``fence_i_i``
     - in
     - fence.i in
     - ACC_DISPATCH
     - fence.i in
     - logic

   * - ``fence_i``
     - in
     - fence in
     - ACC_DISPATCH
     - fence in
     - logic

   * - ``sfence_vma_i``
     - in
     - We got an instruction to flush the TLBs and pipeline
     - COMMIT_STAGE
     - We got an instruction to flush the TLBs and pipeline
     - logic

   * - ``flush_commit_i``
     - in
     - Flush request from commit stage
     - COMMIT_STAGE
     - Flush request from commit stage
     - logic

   * - ``flush_acc_i``
     - in
     - ACC_DISPATCHER
     - Flush request from accelerator
     - logic
