// Copyright (c) 2018 ETH Zurich and University of Bologna.
// Copyright (c) 2021 Thales.
// Copyright (c) 2022 Bruno Sá and Zero-Day Labs.
// Copyright (c) 2024 PlanV Technology
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: Angela Gonzalez, PlanV Technology
// Date: 26/02/2024
//
// Description: Memory Management Unit for CVA6, contains TLB and
//              address translation unit. SV32 SV39 and SV39x4 as defined in RISC-V
//              privilege specification 1.11-WIP.
//              This module is an merge of the MMU Sv39 developed
//              by Florian Zaruba, the MMU Sv32 developed by Sebastien Jacq and the MMU Sv39x4 developed by Bruno Sá.


module cva6_mmu
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg        = config_pkg::cva6_cfg_empty,
    parameter type                   icache_areq_t  = logic,
    parameter type                   icache_arsp_t  = logic,
    parameter type                   icache_dreq_t  = logic,
    parameter type                   icache_drsp_t  = logic,
    parameter type                   dcache_req_i_t = logic,
    parameter type                   dcache_req_o_t = logic,
    parameter type                   exception_t    = logic,
    parameter int unsigned           HYP_EXT        = 0

) (
    input logic clk_i,
    input logic rst_ni,
    input logic flush_i,
    input logic enable_translation_i,
    input logic enable_g_translation_i,
    input logic en_ld_st_translation_i,  // enable virtual memory translation for load/stores
    input logic en_ld_st_g_translation_i,  // enable G-Stage translation for load/stores
    // IF interface
    input icache_arsp_t icache_areq_i,
    output icache_areq_t icache_areq_o,
    // LSU interface
    // this is a more minimalistic interface because the actual addressing logic is handled
    // in the LSU as we distinguish load and stores, what we do here is simple address translation
    input exception_t misaligned_ex_i,
    input logic lsu_req_i,  // request address translation
    input logic [CVA6Cfg.VLEN-1:0] lsu_vaddr_i,  // virtual address in
    input logic [31:0] lsu_tinst_i,  // transformed instruction in
    input logic lsu_is_store_i,  // the translation is requested by a store
    output logic csr_hs_ld_st_inst_o,  // hyp load store instruction
    // if we need to walk the page table we can't grant in the same cycle
    // Cycle 0
    output logic lsu_dtlb_hit_o,  // sent in same cycle as the request if translation hits in DTLB
    output logic [CVA6Cfg.PPNW-1:0] lsu_dtlb_ppn_o,  // ppn (send same cycle as hit)
    // Cycle 1
    output logic lsu_valid_o,  // translation is valid
    output logic [CVA6Cfg.PLEN-1:0] lsu_paddr_o,  // translated address
    output exception_t lsu_exception_o,  // address translation threw an exception
    // General control signals
    input riscv::priv_lvl_t priv_lvl_i,
    input logic v_i,
    input riscv::priv_lvl_t ld_st_priv_lvl_i,
    input logic ld_st_v_i,
    input logic sum_i,
    input logic vs_sum_i,
    input logic mxr_i,
    input logic vmxr_i,
    input logic hlvx_inst_i,
    input logic hs_ld_st_inst_i,
    // input logic flag_mprv_i,
    input logic [CVA6Cfg.PPNW-1:0] satp_ppn_i,
    input logic [CVA6Cfg.PPNW-1:0] vsatp_ppn_i,
    input logic [CVA6Cfg.PPNW-1:0] hgatp_ppn_i,

    input logic [CVA6Cfg.ASID_WIDTH-1:0] asid_i,
    input logic [CVA6Cfg.ASID_WIDTH-1:0] vs_asid_i,
    input logic [CVA6Cfg.ASID_WIDTH-1:0] asid_to_be_flushed_i,
    input logic [CVA6Cfg.VMID_WIDTH-1:0] vmid_i,
    input logic [CVA6Cfg.VMID_WIDTH-1:0] vmid_to_be_flushed_i,
    input logic [CVA6Cfg.VLEN-1:0] vaddr_to_be_flushed_i,
    input logic [CVA6Cfg.GPLEN-1:0] gpaddr_to_be_flushed_i,

    input logic flush_tlb_i,
    input logic flush_tlb_vvma_i,
    input logic flush_tlb_gvma_i,

    // Performance counters
    output logic itlb_miss_o,
    output logic dtlb_miss_o,
    // PTW memory interface
    input dcache_req_o_t req_port_i,
    output dcache_req_i_t req_port_o,

    // PMP

    input riscv::pmpcfg_t [avoid_neg(CVA6Cfg.NrPMPEntries-1):0]                   pmpcfg_i,
    input logic           [avoid_neg(CVA6Cfg.NrPMPEntries-1):0][CVA6Cfg.PLEN-3:0] pmpaddr_i
);

  // memory management, pte for cva6
  localparam type pte_cva6_t = struct packed {
    logic [9:0] reserved;
    logic [CVA6Cfg.PPNW-1:0] ppn;  // PPN length for
    logic [1:0] rsw;
    logic d;
    logic a;
    logic g;
    logic u;
    logic x;
    logic w;
    logic r;
    logic v;
  };

  localparam type tlb_update_cva6_t = struct packed {
    logic                                   valid;
    logic [CVA6Cfg.PtLevels-2:0][HYP_EXT:0] is_page;
    logic [CVA6Cfg.VpnLen-1:0]              vpn;
    logic [CVA6Cfg.ASID_WIDTH-1:0]          asid;
    logic [CVA6Cfg.VMID_WIDTH-1:0]          vmid;
    logic [HYP_EXT*2:0]                     v_st_enbl;  // v_i,g-stage enabled, s-stage enabled
    pte_cva6_t                              content;
    pte_cva6_t                              g_content;
  };

  logic iaccess_err;  // insufficient privilege to access this instruction page
  logic i_g_st_access_err;  // insufficient privilege at g stage to access this instruction page
  logic daccess_err;  // insufficient privilege to access this data page
  logic canonical_addr_check;  // canonical check on the virtual address for SV39
  logic d_g_st_access_err;  // insufficient privilege to access this data page
  logic ptw_active;  // PTW is currently walking a page table
  logic walking_instr;  // PTW is walking because of an ITLB miss
  logic ptw_error;  // PTW threw an exception
  logic ptw_error_at_g_st;  // PTW threw an exception at the G-Stage
  logic ptw_err_at_g_int_st;  // PTW threw an exception at the G-Stage during S-Stage translation
  logic ptw_access_exception;  // PTW threw an access exception (PMPs)
  logic [CVA6Cfg.PLEN-1:0] ptw_bad_paddr;  // PTW page fault bad physical addr
  logic [CVA6Cfg.GPLEN-1:0] ptw_bad_gpaddr;  // PTW guest page fault bad guest physical addr

  logic [CVA6Cfg.VLEN-1:0] update_vaddr, shared_tlb_vaddr;

  tlb_update_cva6_t update_itlb, update_dtlb, update_shared_tlb;

  logic                               itlb_lu_access;
  pte_cva6_t                          itlb_content;
  pte_cva6_t                          itlb_g_content;
  logic      [  CVA6Cfg.PtLevels-2:0] itlb_is_page;
  logic                               itlb_lu_hit;
  logic      [     CVA6Cfg.GPLEN-1:0] itlb_gpaddr;
  logic      [CVA6Cfg.ASID_WIDTH-1:0] itlb_lu_asid;

  logic                               dtlb_lu_access;
  pte_cva6_t                          dtlb_content;
  pte_cva6_t                          dtlb_g_content;
  logic      [  CVA6Cfg.PtLevels-2:0] dtlb_is_page;
  logic      [CVA6Cfg.ASID_WIDTH-1:0] dtlb_lu_asid;
  logic                               dtlb_lu_hit;
  logic      [     CVA6Cfg.GPLEN-1:0] dtlb_gpaddr;

  logic shared_tlb_access, shared_tlb_miss;
  logic shared_tlb_hit, itlb_req;

  // Assignments

  assign itlb_lu_access = icache_areq_i.fetch_req;
  assign dtlb_lu_access = lsu_req_i;
  assign itlb_lu_asid   = v_i ? vs_asid_i : asid_i;
  assign dtlb_lu_asid   = (ld_st_v_i || flush_tlb_vvma_i) ? vs_asid_i : asid_i;


  cva6_tlb #(
      .CVA6Cfg          (CVA6Cfg),
      .pte_cva6_t       (pte_cva6_t),
      .tlb_update_cva6_t(tlb_update_cva6_t),
      .TLB_ENTRIES      (CVA6Cfg.InstrTlbEntries),
      .HYP_EXT          (HYP_EXT)
  ) i_itlb (
      .clk_i         (clk_i),
      .rst_ni        (rst_ni),
      .flush_i       (flush_tlb_i),
      .flush_vvma_i  (flush_tlb_vvma_i),
      .flush_gvma_i  (flush_tlb_gvma_i),
      .s_st_enbl_i   (enable_translation_i),
      .g_st_enbl_i   (enable_g_translation_i),
      .v_i           (v_i),
      .update_i      (update_itlb),
      .lu_access_i   (itlb_lu_access),
      .lu_asid_i     (itlb_lu_asid),
      .lu_vmid_i     (vmid_i),
      .lu_vaddr_i    (icache_areq_i.fetch_vaddr),
      .lu_gpaddr_o   (itlb_gpaddr),
      .lu_content_o  (itlb_content),
      .lu_g_content_o(itlb_g_content),
      .asid_to_be_flushed_i,
      .vmid_to_be_flushed_i,
      .vaddr_to_be_flushed_i,
      .gpaddr_to_be_flushed_i,
      .lu_is_page_o  (itlb_is_page),
      .lu_hit_o      (itlb_lu_hit)
  );

  cva6_tlb #(
      .CVA6Cfg          (CVA6Cfg),
      .pte_cva6_t       (pte_cva6_t),
      .tlb_update_cva6_t(tlb_update_cva6_t),
      .TLB_ENTRIES      (CVA6Cfg.DataTlbEntries),
      .HYP_EXT          (HYP_EXT)
  ) i_dtlb (
      .clk_i         (clk_i),
      .rst_ni        (rst_ni),
      .flush_i       (flush_tlb_i),
      .flush_vvma_i  (flush_tlb_vvma_i),
      .flush_gvma_i  (flush_tlb_gvma_i),
      .s_st_enbl_i   (en_ld_st_translation_i),
      .g_st_enbl_i   (en_ld_st_g_translation_i),
      .v_i           (ld_st_v_i),
      .update_i      (update_dtlb),
      .lu_access_i   (dtlb_lu_access),
      .lu_asid_i     (itlb_lu_asid),
      .lu_vmid_i     (vmid_i),
      .lu_vaddr_i    (lsu_vaddr_i),
      .lu_gpaddr_o   (dtlb_gpaddr),
      .lu_content_o  (dtlb_content),
      .lu_g_content_o(dtlb_g_content),
      .asid_to_be_flushed_i,
      .vmid_to_be_flushed_i,
      .vaddr_to_be_flushed_i,
      .gpaddr_to_be_flushed_i,
      .lu_is_page_o  (dtlb_is_page),
      .lu_hit_o      (dtlb_lu_hit)
  );


  cva6_shared_tlb #(
      .CVA6Cfg          (CVA6Cfg),
      .SHARED_TLB_WAYS  (2),
      .HYP_EXT          (HYP_EXT),
      .pte_cva6_t       (pte_cva6_t),
      .tlb_update_cva6_t(tlb_update_cva6_t)
  ) i_shared_tlb (
      .clk_i         (clk_i),
      .rst_ni        (rst_ni),
      .flush_i       (flush_tlb_i),
      .flush_vvma_i  (flush_tlb_vvma_i),
      .flush_gvma_i  (flush_tlb_gvma_i),
      .s_st_enbl_i   (enable_translation_i),
      .g_st_enbl_i   (enable_g_translation_i),
      .v_i           (v_i),
      .s_ld_st_enbl_i(en_ld_st_translation_i),
      .g_ld_st_enbl_i(en_ld_st_g_translation_i),
      .ld_st_v_i     (ld_st_v_i),

      .dtlb_asid_i  (dtlb_lu_asid),
      .itlb_asid_i  (itlb_lu_asid),
      .lu_vmid_i    (vmid_i),
      // from TLBs
      // did we miss?
      .itlb_access_i(itlb_lu_access),
      .itlb_hit_i   (itlb_lu_hit),
      .itlb_vaddr_i (icache_areq_i.fetch_vaddr),

      .dtlb_access_i(dtlb_lu_access),
      .dtlb_hit_i   (dtlb_lu_hit),
      .dtlb_vaddr_i (lsu_vaddr_i),

      // to TLBs, update logic
      .itlb_update_o(update_itlb),
      .dtlb_update_o(update_dtlb),

      // Performance counters
      .itlb_miss_o(itlb_miss_o),
      .dtlb_miss_o(dtlb_miss_o),
      .shared_tlb_miss_i(shared_tlb_miss),

      .shared_tlb_access_o(shared_tlb_access),
      .shared_tlb_hit_o   (shared_tlb_hit),
      .shared_tlb_vaddr_o (shared_tlb_vaddr),

      .itlb_req_o         (itlb_req),
      // to update shared tlb
      .shared_tlb_update_i(update_shared_tlb)
  );

  cva6_ptw #(
      .CVA6Cfg          (CVA6Cfg),
      .pte_cva6_t       (pte_cva6_t),
      .tlb_update_cva6_t(tlb_update_cva6_t),
      .dcache_req_i_t   (dcache_req_i_t),
      .dcache_req_o_t   (dcache_req_o_t),
      .HYP_EXT          (HYP_EXT)
  ) i_ptw (
      .clk_i (clk_i),
      .rst_ni(rst_ni),
      .flush_i,

      .ptw_active_o          (ptw_active),
      .walking_instr_o       (walking_instr),
      .ptw_error_o           (ptw_error),
      .ptw_error_at_g_st_o   (ptw_error_at_g_st),
      .ptw_err_at_g_int_st_o (ptw_err_at_g_int_st),
      .ptw_access_exception_o(ptw_access_exception),
      .enable_translation_i,
      .enable_g_translation_i,
      .en_ld_st_translation_i,
      .en_ld_st_g_translation_i,
      .v_i,
      .ld_st_v_i,
      .hlvx_inst_i           (hlvx_inst_i),

      .lsu_is_store_i(lsu_is_store_i),
      // PTW memory interface
      .req_port_i    (req_port_i),
      .req_port_o    (req_port_o),

      // to Shared TLB, update logic
      .shared_tlb_update_o(update_shared_tlb),

      .update_vaddr_o(update_vaddr),

      .asid_i,
      .vs_asid_i,
      .vmid_i,

      // from shared TLB
      // did we miss?
      .shared_tlb_access_i(shared_tlb_access),
      .shared_tlb_hit_i   (shared_tlb_hit),
      .shared_tlb_vaddr_i (shared_tlb_vaddr),

      .itlb_req_i(itlb_req),

      .satp_ppn_i,
      .vsatp_ppn_i,
      .hgatp_ppn_i,
      .mxr_i,
      .vmxr_i,

      // Performance counters
      .shared_tlb_miss_o(shared_tlb_miss),  //open for now

      // PMP
      .pmpcfg_i   (pmpcfg_i),
      .pmpaddr_i  (pmpaddr_i),
      .bad_paddr_o(ptw_bad_paddr),
      .bad_gpaddr_o(ptw_bad_gpaddr)
  );

  //-----------------------
  // Instruction Interface
  //-----------------------
  localparam int PPNWMin = (CVA6Cfg.PPNW - 1 > 29) ? 29 : CVA6Cfg.PPNW - 1;

  // The instruction interface is a simple request response interface
  always_comb begin : instr_interface
    // MMU disabled: just pass through
    icache_areq_o.fetch_valid = icache_areq_i.fetch_req;
    icache_areq_o.fetch_paddr  = CVA6Cfg.PLEN'(icache_areq_i.fetch_vaddr[((CVA6Cfg.PLEN > CVA6Cfg.VLEN) ? CVA6Cfg.VLEN -1: CVA6Cfg.PLEN -1 ):0]);
    // two potential exception sources:
    // 1. HPTW threw an exception -> signal with a page fault exception
    // 2. We got an access error because of insufficient permissions -> throw an access exception
    icache_areq_o.fetch_exception = '0;
    // Check whether we are allowed to access this memory region from a fetch perspective
    iaccess_err = icache_areq_i.fetch_req && enable_translation_i &&  //
    (((priv_lvl_i == riscv::PRIV_LVL_U) && ~itlb_content.u)  //
    || ((priv_lvl_i == riscv::PRIV_LVL_S) && itlb_content.u));

    if (CVA6Cfg.RVH)
      i_g_st_access_err = icache_areq_i.fetch_req && enable_g_translation_i && !itlb_g_content.u;
    // MMU enabled: address from TLB, request delayed until hit. Error when TLB
    // hit and no access right or TLB hit and translated address not valid (e.g.
    // AXI decode error), or when PTW performs walk due to ITLB miss and raises
    // an error.
    if ((enable_translation_i || enable_g_translation_i)) begin
      // we work with SV39 or SV32, so if VM is enabled, check that all bits [CVA6Cfg.VLEN-1:CVA6Cfg.SV-1] are equal
      if (icache_areq_i.fetch_req && !((&icache_areq_i.fetch_vaddr[CVA6Cfg.VLEN-1:CVA6Cfg.SV-1]) == 1'b1 || (|icache_areq_i.fetch_vaddr[CVA6Cfg.VLEN-1:CVA6Cfg.SV-1]) == 1'b0)) begin

        icache_areq_o.fetch_exception.cause = riscv::INSTR_PAGE_FAULT;
        icache_areq_o.fetch_exception.valid = 1'b1;
        if (CVA6Cfg.TvalEn)
          icache_areq_o.fetch_exception.tval = CVA6Cfg.XLEN'(icache_areq_i.fetch_vaddr);
        if (CVA6Cfg.RVH) begin
          icache_areq_o.fetch_exception.tval2 = '0;
          icache_areq_o.fetch_exception.tinst = '0;
          icache_areq_o.fetch_exception.gva   = v_i;
        end
      end

      icache_areq_o.fetch_valid = 1'b0;

      icache_areq_o.fetch_paddr = {
        (enable_g_translation_i && CVA6Cfg.RVH) ? itlb_g_content.ppn : itlb_content.ppn,
        icache_areq_i.fetch_vaddr[11:0]
      };

      if (CVA6Cfg.PtLevels == 3 && itlb_is_page[CVA6Cfg.PtLevels-2]) begin

        icache_areq_o.fetch_paddr[PPNWMin-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels):9+CVA6Cfg.PtLevels] = icache_areq_i.fetch_vaddr[PPNWMin-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels):9+CVA6Cfg.PtLevels];

      end

      if (itlb_is_page[0]) begin

        icache_areq_o.fetch_paddr[PPNWMin:12] = icache_areq_i.fetch_vaddr[PPNWMin:12];

      end
      // ---------//
      // ITLB Hit
      // --------//
      // if we hit the ITLB output the request signal immediately
      if (itlb_lu_hit) begin
        icache_areq_o.fetch_valid = icache_areq_i.fetch_req;
        if (CVA6Cfg.RVH && i_g_st_access_err) begin
          icache_areq_o.fetch_exception.cause = riscv::INSTR_GUEST_PAGE_FAULT;
          icache_areq_o.fetch_exception.valid = 1'b1;
          if (CVA6Cfg.TvalEn)
            icache_areq_o.fetch_exception.tval = CVA6Cfg.XLEN'(icache_areq_i.fetch_vaddr);
          if (CVA6Cfg.RVH) begin
            icache_areq_o.fetch_exception.tval2 = itlb_gpaddr[CVA6Cfg.GPLEN-1:0];
            icache_areq_o.fetch_exception.tinst = '0;
            icache_areq_o.fetch_exception.gva   = v_i;
          end

          // we got an access error
        end else if (iaccess_err) begin
          // throw a page fault
          icache_areq_o.fetch_exception.cause = riscv::INSTR_PAGE_FAULT;
          icache_areq_o.fetch_exception.valid = 1'b1;
          if (CVA6Cfg.TvalEn)
            icache_areq_o.fetch_exception.tval = CVA6Cfg.XLEN'(icache_areq_i.fetch_vaddr);
          if (CVA6Cfg.RVH) begin
            icache_areq_o.fetch_exception.tval2 = '0;
            icache_areq_o.fetch_exception.tinst = '0;
            icache_areq_o.fetch_exception.gva   = v_i;
          end
        end
      end else if (ptw_active && walking_instr) begin
        // ---------//
        // ITLB Miss
        // ---------//
        // watch out for exceptions happening during walking the page table
        icache_areq_o.fetch_valid = ptw_error | ptw_access_exception;
        if (ptw_error) begin
          if (CVA6Cfg.RVH && ptw_error_at_g_st) begin
            icache_areq_o.fetch_exception.cause = riscv::INSTR_GUEST_PAGE_FAULT;
            icache_areq_o.fetch_exception.valid = 1'b1;
            if (CVA6Cfg.TvalEn) icache_areq_o.fetch_exception.tval = CVA6Cfg.XLEN'(update_vaddr);
            if (CVA6Cfg.RVH) begin
              icache_areq_o.fetch_exception.tval2 = ptw_bad_gpaddr[CVA6Cfg.GPLEN-1:0];
              icache_areq_o.fetch_exception.tinst=(ptw_err_at_g_int_st ? (CVA6Cfg.IS_XLEN64 ? riscv::READ_64_PSEUDOINSTRUCTION : riscv::READ_32_PSEUDOINSTRUCTION) : '0);
              icache_areq_o.fetch_exception.gva = v_i;
            end
          end else begin
            icache_areq_o.fetch_exception.cause = riscv::INSTR_PAGE_FAULT;
            icache_areq_o.fetch_exception.valid = 1'b1;
            if (CVA6Cfg.TvalEn) icache_areq_o.fetch_exception.tval = CVA6Cfg.XLEN'(update_vaddr);
            if (CVA6Cfg.RVH) begin
              icache_areq_o.fetch_exception.tval2 = '0;
              icache_areq_o.fetch_exception.tinst = '0;
              icache_areq_o.fetch_exception.gva   = v_i;
            end
          end
        end else begin
          icache_areq_o.fetch_exception.cause = riscv::INSTR_ACCESS_FAULT;
          icache_areq_o.fetch_exception.valid = 1'b1;
          if (CVA6Cfg.TvalEn)  //To confirm this is the right TVAL
            icache_areq_o.fetch_exception.tval = CVA6Cfg.XLEN'(update_vaddr);
          if (CVA6Cfg.RVH) begin
            icache_areq_o.fetch_exception.tval2 = '0;
            icache_areq_o.fetch_exception.tinst = '0;
            icache_areq_o.fetch_exception.gva   = v_i;
          end
        end
      end
    end
  end


  //-----------------------
  // Data Interface
  //-----------------------
  logic [CVA6Cfg.VLEN-1:0] lsu_vaddr_n, lsu_vaddr_q;
  logic [CVA6Cfg.GPLEN-1:0] lsu_gpaddr_n, lsu_gpaddr_q;
  logic [31:0] lsu_tinst_n, lsu_tinst_q;
  logic hs_ld_st_inst_n, hs_ld_st_inst_q;
  pte_cva6_t dtlb_pte_n, dtlb_pte_q;
  pte_cva6_t dtlb_gpte_n, dtlb_gpte_q;
  logic lsu_req_n, lsu_req_q;
  logic lsu_is_store_n, lsu_is_store_q;
  logic dtlb_hit_n, dtlb_hit_q;
  logic [CVA6Cfg.PtLevels-2:0] dtlb_is_page_n, dtlb_is_page_q;
  exception_t misaligned_ex_n, misaligned_ex_q;

  // check if we need to do translation or if we are always ready (e.g.: we are not translating anything)
  assign lsu_dtlb_hit_o = (en_ld_st_translation_i || en_ld_st_g_translation_i) ? dtlb_lu_hit : 1'b1;


  // The data interface is simpler and only consists of a request/response interface
  always_comb begin : data_interface
    // save request and DTLB response
    lsu_vaddr_n = lsu_vaddr_i;
    lsu_req_n = lsu_req_i;
    dtlb_pte_n = dtlb_content;
    dtlb_hit_n = dtlb_lu_hit;
    lsu_is_store_n = lsu_is_store_i;
    dtlb_is_page_n = dtlb_is_page;
    misaligned_ex_n = misaligned_ex_i;

    lsu_valid_o = lsu_req_q;
    lsu_exception_o = misaligned_ex_q;

    // mute misaligned exceptions if there is no request otherwise they will throw accidental exceptions
    misaligned_ex_n.valid = misaligned_ex_i.valid & lsu_req_i;

    // we work with SV39 or SV32, so if VM is enabled, check that all bits [CVA6Cfg.VLEN-1:CVA6Cfg.SV-1] are equal to bit [CVA6Cfg.SV]
    canonical_addr_check = (lsu_req_i && en_ld_st_translation_i &&
           !((&lsu_vaddr_i[CVA6Cfg.VLEN-1:CVA6Cfg.SV-1]) == 1'b1 || (|lsu_vaddr_i[CVA6Cfg.VLEN-1:CVA6Cfg.SV-1]) == 1'b0));

    // Check if the User flag is set, then we may only access it in supervisor mode
    // if SUM is enabled
    daccess_err = en_ld_st_translation_i &&
              ((ld_st_priv_lvl_i == riscv::PRIV_LVL_S && (ld_st_v_i ? !vs_sum_i : !sum_i ) && dtlb_pte_q.u) || // SUM is not set and we are trying to access a user page in supervisor mode
    (ld_st_priv_lvl_i == riscv::PRIV_LVL_U && !dtlb_pte_q.u));

    if (CVA6Cfg.RVH) begin
      lsu_tinst_n = lsu_tinst_i;
      hs_ld_st_inst_n = hs_ld_st_inst_i;
      lsu_gpaddr_n[(CVA6Cfg.XLEN == 32 ? CVA6Cfg.VLEN: CVA6Cfg.GPLEN)-1:0] = dtlb_gpaddr[(CVA6Cfg.XLEN == 32 ? CVA6Cfg.VLEN: CVA6Cfg.GPLEN)-1:0];
      csr_hs_ld_st_inst_o = hs_ld_st_inst_i || hs_ld_st_inst_q;
      d_g_st_access_err = en_ld_st_g_translation_i && !dtlb_gpte_q.u;
      dtlb_gpte_n = dtlb_g_content;
    end

    lsu_paddr_o = (CVA6Cfg.PLEN)'(lsu_vaddr_q[((CVA6Cfg.PLEN > CVA6Cfg.VLEN) ? CVA6Cfg.VLEN -1: CVA6Cfg.PLEN -1 ):0]);
    lsu_dtlb_ppn_o        = (CVA6Cfg.PPNW)'(lsu_vaddr_n[((CVA6Cfg.PLEN > CVA6Cfg.VLEN) ? CVA6Cfg.VLEN -1: CVA6Cfg.PLEN -1 ):12]);

    // translation is enabled and no misaligned exception occurred
    if ((en_ld_st_translation_i || en_ld_st_g_translation_i) && !misaligned_ex_q.valid) begin
      lsu_valid_o = 1'b0;

      lsu_dtlb_ppn_o = (en_ld_st_g_translation_i && CVA6Cfg.RVH)? dtlb_g_content.ppn :dtlb_content.ppn;
      lsu_paddr_o = {
        (en_ld_st_g_translation_i && CVA6Cfg.RVH) ? dtlb_gpte_q.ppn : dtlb_pte_q.ppn,
        lsu_vaddr_q[11:0]
      };

      if (CVA6Cfg.PtLevels == 3 && dtlb_is_page_q[CVA6Cfg.PtLevels-2]) begin
        lsu_paddr_o[PPNWMin-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels):9+CVA6Cfg.PtLevels] = lsu_vaddr_q[PPNWMin-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels):9+CVA6Cfg.PtLevels];
        lsu_dtlb_ppn_o[PPNWMin-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels):9+CVA6Cfg.PtLevels] = lsu_vaddr_n[PPNWMin-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels):9+CVA6Cfg.PtLevels];
      end

      if (dtlb_is_page_q[0]) begin
        lsu_dtlb_ppn_o[PPNWMin:12] = lsu_vaddr_n[PPNWMin:12];
        lsu_paddr_o[PPNWMin:12] = lsu_vaddr_q[PPNWMin:12];
      end



      // ---------
      // DTLB Hit
      // --------
      if (dtlb_hit_q && lsu_req_q) begin
        lsu_valid_o = 1'b1;
        // exception priority:
        // PAGE_FAULTS have higher priority than ACCESS_FAULTS
        // virtual memory based exceptions are PAGE_FAULTS
        // physical memory based exceptions are ACCESS_FAULTS (PMA/PMP)

        // this is a store
        if (lsu_is_store_q) begin
          // check if the page is write-able and we are not violating privileges
          // also check if the dirty flag is set
          if(CVA6Cfg.RVH && en_ld_st_g_translation_i && (!dtlb_gpte_q.w || d_g_st_access_err || !dtlb_gpte_q.d)) begin
            lsu_exception_o.cause = riscv::STORE_GUEST_PAGE_FAULT;
            lsu_exception_o.valid = 1'b1;
            if (CVA6Cfg.TvalEn)
              lsu_exception_o.tval = {
                {CVA6Cfg.XLEN - CVA6Cfg.VLEN{lsu_vaddr_q[CVA6Cfg.VLEN-1]}}, lsu_vaddr_q
              };
            if (CVA6Cfg.RVH) begin
              lsu_exception_o.tval2= CVA6Cfg.GPLEN'(lsu_gpaddr_q[(CVA6Cfg.XLEN==32?CVA6Cfg.VLEN : CVA6Cfg.GPLEN)-1:0]);
              lsu_exception_o.tinst = '0;
              lsu_exception_o.gva = ld_st_v_i;
            end
          end else if ((en_ld_st_translation_i || !CVA6Cfg.RVH) && (!dtlb_pte_q.w || daccess_err || canonical_addr_check || !dtlb_pte_q.d)) begin
            lsu_exception_o.cause = riscv::STORE_PAGE_FAULT;
            lsu_exception_o.valid = 1'b1;
            if (CVA6Cfg.TvalEn)
              lsu_exception_o.tval = {
                {CVA6Cfg.XLEN - CVA6Cfg.VLEN{lsu_vaddr_q[CVA6Cfg.VLEN-1]}}, lsu_vaddr_q
              };
            if (CVA6Cfg.RVH) begin
              lsu_exception_o.tval2 = '0;
              lsu_exception_o.tinst = lsu_tinst_q;
              lsu_exception_o.gva   = ld_st_v_i;
            end
          end
          // this is a load
        end else begin
          if (CVA6Cfg.RVH && d_g_st_access_err) begin
            lsu_exception_o.cause = riscv::LOAD_GUEST_PAGE_FAULT;
            lsu_exception_o.valid = 1'b1;
            if (CVA6Cfg.TvalEn)
              lsu_exception_o.tval = {
                {CVA6Cfg.XLEN - CVA6Cfg.VLEN{lsu_vaddr_q[CVA6Cfg.VLEN-1]}}, lsu_vaddr_q
              };
            if (CVA6Cfg.RVH) begin
              lsu_exception_o.tval2= CVA6Cfg.GPLEN'(lsu_gpaddr_q[(CVA6Cfg.XLEN==32?CVA6Cfg.VLEN : CVA6Cfg.GPLEN)-1:0]);
              lsu_exception_o.tinst = '0;
              lsu_exception_o.gva = ld_st_v_i;
            end
            // check for sufficient access privileges - throw a page fault if necessary
          end else if (daccess_err || canonical_addr_check) begin
            lsu_exception_o.cause = riscv::LOAD_PAGE_FAULT;
            lsu_exception_o.valid = 1'b1;
            if (CVA6Cfg.TvalEn)
              lsu_exception_o.tval = {
                {CVA6Cfg.XLEN - CVA6Cfg.VLEN{lsu_vaddr_q[CVA6Cfg.VLEN-1]}}, lsu_vaddr_q
              };
            if (CVA6Cfg.RVH) begin
              lsu_exception_o.tval2 = '0;
              lsu_exception_o.tinst = lsu_tinst_q;
              lsu_exception_o.gva   = ld_st_v_i;
            end
          end
        end
      end else

      // ---------
      // DTLB Miss
      // ---------
      // watch out for exceptions
      if (ptw_active && !walking_instr) begin
        // page table walker threw an exception
        if (ptw_error) begin
          // an error makes the translation valid
          lsu_valid_o = 1'b1;
          // the page table walker can only throw page faults
          if (lsu_is_store_q) begin
            if (CVA6Cfg.RVH && ptw_error_at_g_st) begin
              lsu_exception_o.cause = riscv::STORE_GUEST_PAGE_FAULT;
              lsu_exception_o.valid = 1'b1;
              if (CVA6Cfg.TvalEn)
                lsu_exception_o.tval = {
                  {CVA6Cfg.XLEN - CVA6Cfg.VLEN{lsu_vaddr_q[CVA6Cfg.VLEN-1]}}, update_vaddr
                };
              if (CVA6Cfg.RVH) begin
                lsu_exception_o.tval2 = ptw_bad_gpaddr[CVA6Cfg.GPLEN-1:0];
                lsu_exception_o.tinst= (ptw_err_at_g_int_st ? (CVA6Cfg.IS_XLEN64 ? riscv::READ_64_PSEUDOINSTRUCTION : riscv::READ_32_PSEUDOINSTRUCTION) : '0);
                lsu_exception_o.gva = ld_st_v_i;
              end
            end else begin
              lsu_exception_o.cause = riscv::STORE_PAGE_FAULT;
              lsu_exception_o.valid = 1'b1;
              if (CVA6Cfg.TvalEn)
                lsu_exception_o.tval = {
                  {CVA6Cfg.XLEN - CVA6Cfg.VLEN{lsu_vaddr_q[CVA6Cfg.VLEN-1]}}, update_vaddr
                };
              if (CVA6Cfg.RVH) begin
                lsu_exception_o.tval2 = '0;
                lsu_exception_o.tinst = lsu_tinst_q;
                lsu_exception_o.gva   = ld_st_v_i;
              end
            end
          end else begin
            if (CVA6Cfg.RVH && ptw_error_at_g_st) begin
              lsu_exception_o.cause = riscv::LOAD_GUEST_PAGE_FAULT;
              lsu_exception_o.valid = 1'b1;
              if (CVA6Cfg.TvalEn)
                lsu_exception_o.tval = {
                  {CVA6Cfg.XLEN - CVA6Cfg.VLEN{lsu_vaddr_q[CVA6Cfg.VLEN-1]}}, update_vaddr
                };
              if (CVA6Cfg.RVH) begin
                lsu_exception_o.tval2 = ptw_bad_gpaddr[CVA6Cfg.GPLEN-1:0];
                lsu_exception_o.tinst= (ptw_err_at_g_int_st ? (CVA6Cfg.IS_XLEN64 ? riscv::READ_64_PSEUDOINSTRUCTION : riscv::READ_32_PSEUDOINSTRUCTION) : '0);
                lsu_exception_o.gva = ld_st_v_i;
              end
            end else begin
              lsu_exception_o.cause = riscv::LOAD_PAGE_FAULT;
              lsu_exception_o.valid = 1'b1;
              if (CVA6Cfg.TvalEn)
                lsu_exception_o.tval = {
                  {CVA6Cfg.XLEN - CVA6Cfg.VLEN{lsu_vaddr_q[CVA6Cfg.VLEN-1]}}, update_vaddr
                };
              if (CVA6Cfg.RVH) begin
                lsu_exception_o.tval2 = '0;
                lsu_exception_o.tinst = lsu_tinst_q;
                lsu_exception_o.gva   = ld_st_v_i;
              end
            end
          end
        end
        if (ptw_access_exception) begin
          // an error makes the translation valid
          lsu_valid_o = 1'b1;
          // Any fault of the page table walk should be based of the original access type
          if (lsu_is_store_q && !CVA6Cfg.RVH && CVA6Cfg.PtLevels == 3) begin
            lsu_exception_o.cause = riscv::ST_ACCESS_FAULT;
            lsu_exception_o.valid = 1'b1;
            if (CVA6Cfg.TvalEn)
              lsu_exception_o.tval = {
                {CVA6Cfg.XLEN - CVA6Cfg.VLEN{lsu_vaddr_q[CVA6Cfg.VLEN-1]}}, update_vaddr
              };
          end else begin
            // the page table walker can only throw page faults
            lsu_exception_o.cause = riscv::LD_ACCESS_FAULT;
            lsu_exception_o.valid = 1'b1;
            if (CVA6Cfg.TvalEn)
              lsu_exception_o.tval = {
                {CVA6Cfg.XLEN - CVA6Cfg.VLEN{lsu_vaddr_q[CVA6Cfg.VLEN-1]}}, update_vaddr
              };
            if (CVA6Cfg.RVH) begin
              lsu_exception_o.tval2 = '0;
              lsu_exception_o.tinst = lsu_tinst_q;
              lsu_exception_o.gva   = ld_st_v_i;
            end
          end
        end
      end
    end
  end

  // ----------
  // Registers
  // ----------
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      lsu_vaddr_q     <= '0;
      lsu_gpaddr_q    <= '0;
      lsu_req_q       <= '0;
      dtlb_pte_q      <= '0;
      dtlb_gpte_q     <= '0;
      dtlb_hit_q      <= '0;
      lsu_is_store_q  <= '0;
      dtlb_is_page_q  <= '0;
      lsu_tinst_q     <= '0;
      hs_ld_st_inst_q <= '0;
      misaligned_ex_q <= '0;
    end else begin
      lsu_vaddr_q    <= lsu_vaddr_n;
      lsu_req_q      <= lsu_req_n;
      dtlb_pte_q     <= dtlb_pte_n;
      dtlb_hit_q     <= dtlb_hit_n;
      lsu_is_store_q <= lsu_is_store_n;
      dtlb_is_page_q <= dtlb_is_page_n;

      if (CVA6Cfg.RVH) begin
        lsu_tinst_q     <= lsu_tinst_n;
        hs_ld_st_inst_q <= hs_ld_st_inst_n;
        dtlb_gpte_q     <= dtlb_gpte_n;
        lsu_gpaddr_q    <= lsu_gpaddr_n;
        misaligned_ex_q <= misaligned_ex_n;
      end
    end
  end
endmodule
