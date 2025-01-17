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
// Description: Hardware-PTW (Page-Table-Walker) for CVA6 supporting sv32, sv39 and sv39x4.
//              This module is an merge of the PTW Sv39 developed by Florian Zaruba,
//              the PTW Sv32 developed by Sebastien Jacq and the PTW Sv39x4 by Bruno Sá.  

/* verilator lint_off WIDTH */

module cva6_ptw
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type pte_cva6_t = logic,
    parameter type tlb_update_cva6_t = logic,
    parameter type dcache_req_i_t = logic,
    parameter type dcache_req_o_t = logic,
    parameter int unsigned HYP_EXT = 0
) (
    input logic clk_i,  // Clock
    input logic rst_ni,  // Asynchronous reset active low
    input logic flush_i,  // flush everything, we need to do this because
                          // actually everything we do is speculative at this stage
                          // e.g.: there could be a CSR instruction that changes everything
    output logic ptw_active_o,
    output logic walking_instr_o,  // set when walking for TLB
    output logic ptw_error_o,  // set when an error occurred
    output logic ptw_error_at_g_st_o,  // set when an error occurred at the G-Stage
    output logic ptw_err_at_g_int_st_o,  // set when an error occurred at the G-Stage during S-Stage translation
    output logic ptw_access_exception_o,  // set when an PMP access exception occured
    input logic enable_translation_i,  // CSRs indicate to enable SV39 VS-Stage translation
    input logic enable_g_translation_i,  // CSRs indicate to enable SV39  G-Stage translation
    input logic en_ld_st_translation_i,  // enable virtual memory translation for load/stores
    input logic en_ld_st_g_translation_i,  // enable G-Stage translation for load/stores
    input logic v_i,  // current virtualization mode bit
    input logic ld_st_v_i,  // load/store virtualization mode bit
    input logic hlvx_inst_i,  // is a HLVX load/store instruction

    input  logic          lsu_is_store_i,  // this translation was triggered by a store
    // PTW memory interface
    input  dcache_req_o_t req_port_i,
    output dcache_req_i_t req_port_o,


    // to TLBs, update logic
    output tlb_update_cva6_t shared_tlb_update_o,

    output logic [CVA6Cfg.VLEN-1:0] update_vaddr_o,

    input logic [CVA6Cfg.ASID_WIDTH-1:0] asid_i,
    input logic [CVA6Cfg.ASID_WIDTH-1:0] vs_asid_i,
    input logic [CVA6Cfg.VMID_WIDTH-1:0] vmid_i,

    // from TLBs
    // did we miss?
    input logic                    shared_tlb_access_i,
    input logic                    shared_tlb_hit_i,
    input logic [CVA6Cfg.VLEN-1:0] shared_tlb_vaddr_i,

    input logic itlb_req_i,

    // from CSR file
    input logic [CVA6Cfg.PPNW-1:0] satp_ppn_i,   // ppn from satp
    input logic [CVA6Cfg.PPNW-1:0] vsatp_ppn_i,  // ppn from satp
    input logic [CVA6Cfg.PPNW-1:0] hgatp_ppn_i,  // ppn from hgatp
    input logic                    mxr_i,
    input logic                    vmxr_i,

    // Performance counters
    output logic shared_tlb_miss_o,

    // PMP
    input riscv::pmpcfg_t [(CVA6Cfg.NrPMPEntries > 0 ? CVA6Cfg.NrPMPEntries-1 : 0):0] pmpcfg_i,
    input logic [(CVA6Cfg.NrPMPEntries > 0 ? CVA6Cfg.NrPMPEntries-1 : 0):0][CVA6Cfg.PLEN-3:0] pmpaddr_i,
    output logic [CVA6Cfg.PLEN-1:0] bad_paddr_o,
    output logic [CVA6Cfg.GPLEN-1:0] bad_gpaddr_o
);

  // input registers
  logic data_rvalid_q;
  logic [CVA6Cfg.XLEN-1:0] data_rdata_q;

  pte_cva6_t pte;
  // register to perform context switch between stages
  pte_cva6_t gpte_q, gpte_d;
  assign pte = pte_cva6_t'(data_rdata_q);

  enum logic [2:0] {
    IDLE,
    WAIT_GRANT,
    PTE_LOOKUP,
    WAIT_RVALID,
    PROPAGATE_ERROR,
    PROPAGATE_ACCESS_ERROR,
    LATENCY
  }
      state_q, state_d;

  logic [CVA6Cfg.PtLevels-2:0] misaligned_page;
  logic [HYP_EXT:0][CVA6Cfg.PtLevels-2:0] ptw_lvl_n, ptw_lvl_q;

  // define 3 PTW stages to be used in sv39x4. sv32 and sv39 are always in S_STAGE
  // S_STAGE -> S/VS-stage normal translation controlled by the satp/vsatp CSRs
  // G_INTERMED_STAGE -> Converts the S/VS-stage non-leaf GPA pointers to HPA (controlled by hgatp)
  // G_FINAL_STAGE -> Converts the S/VS-stage final GPA to HPA (controlled by hgatp)
  enum logic [1:0] {
    S_STAGE,
    G_INTERMED_STAGE,
    G_FINAL_STAGE
  }
      ptw_stage_q, ptw_stage_d;

  // is this an instruction page table walk?
  logic is_instr_ptw_q, is_instr_ptw_n;
  logic global_mapping_q, global_mapping_n;
  // latched tag signal
  logic tag_valid_n, tag_valid_q;
  // register the ASID
  logic [CVA6Cfg.ASID_WIDTH-1:0] tlb_update_asid_q, tlb_update_asid_n;
  // register the VMID
  logic [CVA6Cfg.VMID_WIDTH-1:0] tlb_update_vmid_q, tlb_update_vmid_n;
  // register the VPN we need to walk, SV39 defines a 39 bit virtual address
  logic [CVA6Cfg.VLEN-1:0] vaddr_q, vaddr_n;
  logic [HYP_EXT*2:0][CVA6Cfg.PtLevels-2:0][(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)-1:0] vaddr_lvl;
  // register the VPN we need to walk, SV39x4 defines a 41 bit virtual address for the G-Stage
  logic [CVA6Cfg.GPLEN-1:0] gpaddr_q, gpaddr_n, gpaddr_base;
  logic [CVA6Cfg.PtLevels-1:0][CVA6Cfg.GPLEN-1:0] gpaddr;
  // 4 byte aligned physical pointer
  logic [CVA6Cfg.PLEN-1:0] ptw_pptr_q, ptw_pptr_n;
  logic [CVA6Cfg.PLEN-1:0] gptw_pptr_q, gptw_pptr_n;

  // Assignments
  assign update_vaddr_o = vaddr_q;

  assign ptw_active_o = (state_q != IDLE);
  assign walking_instr_o = is_instr_ptw_q;
  // directly output the correct physical address
  assign req_port_o.address_index = ptw_pptr_q[CVA6Cfg.DCACHE_INDEX_WIDTH-1:0];
  assign req_port_o.address_tag   = ptw_pptr_q[CVA6Cfg.DCACHE_INDEX_WIDTH+CVA6Cfg.DCACHE_TAG_WIDTH-1:CVA6Cfg.DCACHE_INDEX_WIDTH];
  // we are never going to kill this request
  assign req_port_o.kill_req = '0;
  // we are never going to write with the HPTW
  assign req_port_o.data_wdata = '0;
  // we only issue one single request at a time
  assign req_port_o.data_id = '0;

  // -----------
  // TLB Update
  // -----------

  assign gpaddr_base = {pte.ppn[CVA6Cfg.GPPNW-1:0], vaddr_q[11:0]};
  assign gpaddr[CVA6Cfg.PtLevels-1] = gpaddr_base;
  assign shared_tlb_update_o.vpn = CVA6Cfg.VpnLen'(vaddr_q[CVA6Cfg.SV+HYP_EXT*2-1:12]);

  genvar z, w;
  generate
    for (z = 0; z < CVA6Cfg.PtLevels - 1; z++) begin

      // check if the ppn is correctly aligned:
      // 6. If i > 0 and pa.ppn[i − 1 : 0] != 0, this is a misaligned superpage; stop and raise a page-fault
      // exception.
      assign misaligned_page[z] = (ptw_lvl_q[0] == (z)) && (pte.ppn[(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*(CVA6Cfg.PtLevels-1-z)-1:0] != '0);

      //record the vaddr corresponding to each level
      for (w = 0; w < HYP_EXT * 2 + 1; w++) begin
        assign vaddr_lvl[w][z] = w==0 ?  vaddr_q[12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*(CVA6Cfg.PtLevels-z-1))-1:12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*(CVA6Cfg.PtLevels-z-2))] :
                            w==1 ?  gptw_pptr_q[12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*(CVA6Cfg.PtLevels-z-1))-1:12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*(CVA6Cfg.PtLevels-z-2))]:
                            gpaddr_q[12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*(CVA6Cfg.PtLevels-z-1))-1:12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*(CVA6Cfg.PtLevels-z-2))];
      end

      if (CVA6Cfg.RVH) begin
        assign gpaddr[z][CVA6Cfg.VpnLen-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels):0]= (ptw_lvl_q[0] == z) ? vaddr_q[CVA6Cfg.VpnLen-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels):0] : gpaddr_base[CVA6Cfg.VpnLen-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels):0];
        assign gpaddr[z][CVA6Cfg.VpnLen:CVA6Cfg.VpnLen-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)+1]= (ptw_lvl_q[0] == 0) ? vaddr_q[CVA6Cfg.VpnLen:CVA6Cfg.VpnLen-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)+1] : gpaddr_base[CVA6Cfg.VpnLen:CVA6Cfg.VpnLen-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)+1];
        assign gpaddr[z][CVA6Cfg.GPLEN-1:CVA6Cfg.VpnLen+1] = gpaddr_base[CVA6Cfg.GPLEN-1:CVA6Cfg.VpnLen+1];
      end


    end
  endgenerate

  always_comb begin : tlb_update
    // update the correct page table level
    for (int unsigned y = 0; y < HYP_EXT + 1; y++) begin
      for (int unsigned x = 0; x < CVA6Cfg.PtLevels - 1; x++) begin
        if((enable_g_translation_i && enable_translation_i) || (en_ld_st_g_translation_i && en_ld_st_translation_i) && CVA6Cfg.RVH) begin
          shared_tlb_update_o.is_page[x][y] = (ptw_lvl_q[y==HYP_EXT?0 : 1] == x);
        end else if (enable_translation_i || en_ld_st_translation_i || !CVA6Cfg.RVH) begin
          shared_tlb_update_o.is_page[x][y] = y == 0 ? (ptw_lvl_q[0] == x) : 1'b0;
        end else begin
          shared_tlb_update_o.is_page[x][y] = y != 0 ? (ptw_lvl_q[0] == x) : 1'b0;
        end
      end
    end

    // set the global mapping bit
    if ((enable_g_translation_i || en_ld_st_g_translation_i) && CVA6Cfg.RVH) begin
      shared_tlb_update_o.content   = gpte_q | (global_mapping_q << 5);
      shared_tlb_update_o.g_content = pte;
    end else begin
      shared_tlb_update_o.content   = (pte | (global_mapping_q << 5));
      shared_tlb_update_o.g_content = '0;
    end

    // output the correct ASIDs
    shared_tlb_update_o.asid = tlb_update_asid_q;
    shared_tlb_update_o.vmid = tlb_update_vmid_q;

    bad_paddr_o = ptw_access_exception_o ? ptw_pptr_q : 'b0;
    if (CVA6Cfg.RVH)
      bad_gpaddr_o[CVA6Cfg.GPLEN-1:0] = ptw_error_at_g_st_o ? ((ptw_stage_q == G_INTERMED_STAGE) ? gptw_pptr_q[CVA6Cfg.GPLEN-1:0] : gpaddr_q) : 'b0;
  end

  assign req_port_o.tag_valid = tag_valid_q;

  logic allow_access;



  pmp #(
      .CVA6Cfg(CVA6Cfg)
  ) i_pmp_ptw (
      .addr_i       (ptw_pptr_q),
      // PTW access are always checked as if in S-Mode...
      .priv_lvl_i   (riscv::PRIV_LVL_S),
      // ...and they are always loads
      .access_type_i(riscv::ACCESS_READ),
      // Configuration
      .conf_addr_i  (pmpaddr_i),
      .conf_i       (pmpcfg_i),
      .allow_o      (allow_access)
  );


  assign req_port_o.data_be = CVA6Cfg.XLEN == 32 ? be_gen_32(
      req_port_o.address_index[1:0], req_port_o.data_size
  ) : '1;



  //-------------------
  // Page table walker
  //-------------------
  // A virtual address va is translated into a physical address pa as follows:
  // 1. Let a be sptbr.ppn × PAGESIZE, and let i = LEVELS-1. (For Sv39,
  //    PAGESIZE=2^12 and LEVELS=3.)
  // 2. Let pte be the value of the PTE at address a+va.vpn[i]×PTESIZE. (For
  //    Sv32, PTESIZE=4.)
  // 3. If pte.v = 0, or if pte.r = 0 and pte.w = 1, or if any bits or encodings 
  //    that are reserved for future standard use are set within pte, stop and raise 
  //    a page-fault exception corresponding to the original access type.
  // 4. Otherwise, the PTE is valid. If pte.r = 1 or pte.x = 1, go to step 5.
  //    Otherwise, this PTE is a pointer to the next level of the page table.
  //    Let i=i-1. If i < 0, stop and raise an access exception. Otherwise, let
  //    a = pte.ppn × PAGESIZE and go to step 2.
  // 5. A leaf PTE has been found. Determine if the requested memory access
  //    is allowed by the pte.r, pte.w, and pte.x bits. If not, stop and
  //    raise an access exception. Otherwise, the translation is successful.
  //    Set pte.a to 1, and, if the memory access is a store, set pte.d to 1.
  //    The translated physical address is given as follows:
  //      - pa.pgoff = va.pgoff.
  //      - If i > 0, then this is a superpage translation and
  //        pa.ppn[i-1:0] = va.vpn[i-1:0].
  //      - pa.ppn[LEVELS-1:i] = pte.ppn[LEVELS-1:i].
  always_comb begin : ptw
    automatic logic [CVA6Cfg.PLEN-1:0] pptr;
    // automatic logic [CVA6Cfg.GPLEN-1:0] gpaddr;
    // default assignments
    // PTW memory interface
    tag_valid_n               = 1'b0;
    req_port_o.data_req       = 1'b0;
    req_port_o.data_size      = 2'(CVA6Cfg.PtLevels);
    req_port_o.data_we        = 1'b0;
    ptw_error_o               = 1'b0;
    ptw_error_at_g_st_o       = 1'b0;
    ptw_err_at_g_int_st_o     = 1'b0;
    ptw_access_exception_o    = 1'b0;
    shared_tlb_update_o.valid = 1'b0;
    is_instr_ptw_n            = is_instr_ptw_q;
    ptw_lvl_n                 = ptw_lvl_q;
    ptw_pptr_n                = ptw_pptr_q;
    state_d                   = state_q;
    ptw_stage_d               = ptw_stage_q;
    global_mapping_n          = global_mapping_q;
    // input registers
    tlb_update_asid_n         = tlb_update_asid_q;
    tlb_update_vmid_n         = tlb_update_vmid_q;
    vaddr_n                   = vaddr_q;
    pptr                      = ptw_pptr_q;

    if (CVA6Cfg.RVH) begin
      gpaddr_n    = gpaddr_q;
      gptw_pptr_n = gptw_pptr_q;
      gpte_d = gpte_q;
    end

    shared_tlb_miss_o = 1'b0;


    case (state_q)

      IDLE: begin
        // by default we start with the top-most page table
        ptw_lvl_n        = '0;
        global_mapping_n = 1'b0;
        is_instr_ptw_n   = 1'b0;


        if (CVA6Cfg.RVH) begin
          gpte_d   = '0;
          gpaddr_n = '0;
        end


        // if we got an ITLB miss
        if (((enable_translation_i | enable_g_translation_i) || (en_ld_st_translation_i || en_ld_st_g_translation_i)  || !CVA6Cfg.RVH) && shared_tlb_access_i && ~shared_tlb_hit_i) begin
          if (((enable_translation_i && enable_g_translation_i) || (en_ld_st_translation_i && en_ld_st_g_translation_i)) && CVA6Cfg.RVH) begin
            ptw_stage_d = G_INTERMED_STAGE;
            pptr = {
              vsatp_ppn_i,
              shared_tlb_vaddr_i[CVA6Cfg.SV-1:CVA6Cfg.SV-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)],
              (CVA6Cfg.PtLevels)'(0)
            };
            gptw_pptr_n = pptr;
            ptw_pptr_n = {
              hgatp_ppn_i[CVA6Cfg.PPNW-1:2],
              pptr[CVA6Cfg.SV+HYP_EXT*2-1:CVA6Cfg.SV-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)],
              (CVA6Cfg.PtLevels)'(0)
            };
          end else if ((((enable_translation_i | enable_g_translation_i) && !enable_translation_i) || ((en_ld_st_translation_i || en_ld_st_g_translation_i) && !en_ld_st_translation_i)) && CVA6Cfg.RVH) begin
            ptw_stage_d = G_FINAL_STAGE;
            gpaddr_n = shared_tlb_vaddr_i[CVA6Cfg.SV+HYP_EXT*2-1:0];
            ptw_pptr_n = {
              hgatp_ppn_i[CVA6Cfg.PPNW-1:2],
              shared_tlb_vaddr_i[CVA6Cfg.SV+HYP_EXT*2-1:CVA6Cfg.SV-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)],
              (CVA6Cfg.PtLevels)'(0)
            };
          end else begin
            ptw_stage_d = S_STAGE;
            if ((v_i || ld_st_v_i) && CVA6Cfg.RVH)
              ptw_pptr_n = {
                vsatp_ppn_i,
                shared_tlb_vaddr_i[CVA6Cfg.SV-1:CVA6Cfg.SV-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)],
                (CVA6Cfg.PtLevels)'(0)
              };
            else
              ptw_pptr_n = {
                satp_ppn_i,
                shared_tlb_vaddr_i[CVA6Cfg.SV-1:CVA6Cfg.SV-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)],
                (CVA6Cfg.PtLevels)'(0)
              };
          end

          is_instr_ptw_n    = itlb_req_i;
          vaddr_n           = shared_tlb_vaddr_i;
          state_d           = WAIT_GRANT;
          shared_tlb_miss_o = 1'b1;

          if (itlb_req_i) begin
            tlb_update_asid_n = v_i ? vs_asid_i : asid_i;
            if (CVA6Cfg.RVH) tlb_update_vmid_n = vmid_i;
          end else begin
            tlb_update_asid_n = ld_st_v_i ? vs_asid_i : asid_i;
            if (CVA6Cfg.RVH) tlb_update_vmid_n = vmid_i;
          end
        end
      end

      WAIT_GRANT: begin
        // send a request out
        req_port_o.data_req = 1'b1;
        // wait for the WAIT_GRANT
        if (req_port_i.data_gnt) begin
          // send the tag valid signal one cycle later
          tag_valid_n = 1'b1;
          state_d     = PTE_LOOKUP;
        end
      end

      PTE_LOOKUP: begin
        // we wait for the valid signal
        if (data_rvalid_q) begin

          // check if the global mapping bit is set
          if (pte.g && (ptw_stage_q == S_STAGE || !CVA6Cfg.RVH)) global_mapping_n = 1'b1;

          // -------------
          // Invalid PTE
          // -------------
          // If pte.v = 0, or if pte.r = 0 and pte.w = 1, or if pte.reserved !=0 in sv39 and sv39x4, stop and raise a page-fault exception.
          if (!pte.v || (!pte.r && pte.w) || (|pte.reserved && CVA6Cfg.XLEN == 64))
            state_d = PROPAGATE_ERROR;
          // -----------
          // Valid PTE
          // -----------
          else begin
            state_d = LATENCY;
            // it is a valid PTE
            // if pte.r = 1 or pte.x = 1 it is a valid PTE
            if (pte.r || pte.x) begin
              if (CVA6Cfg.RVH) begin
                case (ptw_stage_q)
                  S_STAGE: begin
                    if ((is_instr_ptw_q && enable_g_translation_i) || (!is_instr_ptw_q && en_ld_st_g_translation_i)) begin
                      state_d = WAIT_GRANT;
                      ptw_stage_d = G_FINAL_STAGE;
                      if (CVA6Cfg.RVH) gpte_d = pte;
                      ptw_lvl_n[HYP_EXT] = ptw_lvl_q[0];
                      gpaddr_n = gpaddr[ptw_lvl_q[0]];
                      ptw_pptr_n = {
                        hgatp_ppn_i[CVA6Cfg.PPNW-1:2],
                        gpaddr[ptw_lvl_q[0]][CVA6Cfg.SV+HYP_EXT*2-1:CVA6Cfg.SV-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)],
                        (CVA6Cfg.PtLevels)'(0)
                      };
                      ptw_lvl_n[0] = '0;
                    end
                  end
                  G_INTERMED_STAGE: begin
                    state_d = WAIT_GRANT;
                    ptw_stage_d = S_STAGE;
                    ptw_lvl_n[0] = ptw_lvl_q[HYP_EXT];
                    pptr = {pte.ppn[CVA6Cfg.GPPNW-1:0], gptw_pptr_q[11:0]};
                    if (ptw_lvl_q[0] == 1) pptr[20:0] = gptw_pptr_q[20:0];
                    if (ptw_lvl_q[0] == 0) pptr[29:0] = gptw_pptr_q[29:0];
                    ptw_pptr_n = pptr;
                  end
                  default: ;
                endcase
              end
              // Valid translation found (either 1G, 2M or 4K entry)
              if (is_instr_ptw_q) begin
                // ------------
                // Update ITLB
                // ------------
                // If page is not executable, we can directly raise an error. This
                // doesn't put a useless entry into the TLB. The same idea applies
                // to the access flag since we let the access flag be managed by SW.
                if (!pte.x || !pte.a) begin
                  state_d = PROPAGATE_ERROR;
                  if (CVA6Cfg.RVH) ptw_stage_d = ptw_stage_q;
                end else if (CVA6Cfg.RVH && ((ptw_stage_q == G_FINAL_STAGE) || !enable_g_translation_i) || !CVA6Cfg.RVH)
                  shared_tlb_update_o.valid = 1'b1;

              end else begin
                // ------------
                // Update DTLB
                // ------------
                // Check if the access flag has been set, otherwise throw a page-fault
                // and let the software handle those bits.
                // If page is not readable (there are no write-only pages)
                // we can directly raise an error. This doesn't put a useless
                // entry into the TLB.
                if (pte.a && ((pte.r && !hlvx_inst_i) || (pte.x && (mxr_i || hlvx_inst_i || (ptw_stage_q == S_STAGE && vmxr_i && ld_st_v_i && CVA6Cfg.RVH))))) begin
                  if (CVA6Cfg.RVH && ((ptw_stage_q == G_FINAL_STAGE) || !en_ld_st_g_translation_i) || !CVA6Cfg.RVH)
                    shared_tlb_update_o.valid = 1'b1;
                end else begin
                  state_d = PROPAGATE_ERROR;
                  if (CVA6Cfg.RVH) ptw_stage_d = ptw_stage_q;
                end
                // Request is a store: perform some additional checks
                // If the request was a store and the page is not write-able, raise an error
                // the same applies if the dirty flag is not set
                if (lsu_is_store_i && (!pte.w || !pte.d)) begin
                  shared_tlb_update_o.valid = 1'b0;
                  state_d = PROPAGATE_ERROR;
                  if (CVA6Cfg.RVH) ptw_stage_d = ptw_stage_q;
                end
              end

              //if there is a misaligned page, propagate error
              if (|misaligned_page) begin
                state_d = PROPAGATE_ERROR;
                if (CVA6Cfg.RVH) ptw_stage_d = ptw_stage_q;
                shared_tlb_update_o.valid = 1'b0;
              end

              // check if 63:41 are all zeros
              if (CVA6Cfg.RVH) begin
                if (((v_i && is_instr_ptw_q) || (ld_st_v_i && !is_instr_ptw_q)) && ptw_stage_q == S_STAGE && !((|pte.ppn[CVA6Cfg.PPNW-1:CVA6Cfg.GPPNW-1+HYP_EXT]) == 1'b0)) begin
                  state_d = PROPAGATE_ERROR;
                  ptw_stage_d = G_FINAL_STAGE;
                end
              end
              // this is a pointer to the next TLB level
            end else begin
              // pointer to next level of page table

              if (ptw_lvl_q[0] == CVA6Cfg.PtLevels - 1) begin
                // Should already be the last level page table => Error
                ptw_lvl_n[0] = ptw_lvl_q[0];
                state_d = PROPAGATE_ERROR;
                if (CVA6Cfg.RVH) ptw_stage_d = ptw_stage_q;


              end else begin
                ptw_lvl_n[0] = ptw_lvl_q[0] + 1'b1;
                state_d = WAIT_GRANT;

                if (CVA6Cfg.RVH) begin
                  case (ptw_stage_q)
                    S_STAGE: begin
                      if (CVA6Cfg.RVH && ((is_instr_ptw_q && enable_g_translation_i) || (!is_instr_ptw_q && en_ld_st_g_translation_i))) begin
                        ptw_stage_d = G_INTERMED_STAGE;
                        if (CVA6Cfg.RVH) gpte_d = pte;
                        ptw_lvl_n[HYP_EXT] = ptw_lvl_q[0] + 1;
                        pptr = {pte.ppn, vaddr_lvl[0][ptw_lvl_q[0]], (CVA6Cfg.PtLevels)'(0)};
                        gptw_pptr_n = pptr;
                        ptw_pptr_n = {
                          hgatp_ppn_i[CVA6Cfg.PPNW-1:2],
                          pptr[CVA6Cfg.SV+HYP_EXT*2-1:CVA6Cfg.SV-(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)],
                          (CVA6Cfg.PtLevels)'(0)
                        };
                        ptw_lvl_n[0] = '0;
                      end else begin
                        ptw_pptr_n = {pte.ppn, vaddr_lvl[0][ptw_lvl_q[0]], (CVA6Cfg.PtLevels)'(0)};
                      end
                    end
                    G_INTERMED_STAGE: begin
                      ptw_pptr_n = {
                        pte.ppn, vaddr_lvl[HYP_EXT][ptw_lvl_q[0]], (CVA6Cfg.PtLevels)'(0)
                      };
                    end
                    G_FINAL_STAGE: begin
                      ptw_pptr_n = {
                        pte.ppn, vaddr_lvl[HYP_EXT*2][ptw_lvl_q[0]], (CVA6Cfg.PtLevels)'(0)
                      };
                    end
                  endcase
                end else ptw_pptr_n = {pte.ppn, vaddr_lvl[0][ptw_lvl_q[0]], (CVA6Cfg.PtLevels)'(0)};

                if (CVA6Cfg.RVH && (pte.a || pte.d || pte.u)) begin
                  state_d = PROPAGATE_ERROR;
                  ptw_stage_d = ptw_stage_q;
                end

              end

              // check if 63:41 are all zeros
              if (CVA6Cfg.RVH) begin
                if (((v_i && is_instr_ptw_q) || (ld_st_v_i && !is_instr_ptw_q)) && ptw_stage_q == S_STAGE && !((|pte.ppn[CVA6Cfg.PPNW-1:CVA6Cfg.GPPNW-1+HYP_EXT]) == 1'b0)) begin
                  state_d = PROPAGATE_ERROR;
                  ptw_stage_d = ptw_stage_q;
                end
              end
            end
          end

          // Check if this access was actually allowed from a PMP perspective
          if (!allow_access) begin
            shared_tlb_update_o.valid = 1'b0;
            // we have to return the failed address in bad_addr
            ptw_pptr_n = ptw_pptr_q;
            if (CVA6Cfg.RVH) ptw_stage_d = ptw_stage_q;
            state_d = PROPAGATE_ACCESS_ERROR;
          end
        end
        // we've got a data WAIT_GRANT so tell the cache that the tag is valid
      end
      // Propagate error to MMU/LSU
      PROPAGATE_ERROR: begin
        state_d = LATENCY;
        ptw_error_o = 1'b1;
        if (CVA6Cfg.RVH) begin
          ptw_error_at_g_st_o   = (ptw_stage_q != S_STAGE) ? 1'b1 : 1'b0;
          ptw_err_at_g_int_st_o = (ptw_stage_q == G_INTERMED_STAGE) ? 1'b1 : 1'b0;
        end
      end
      PROPAGATE_ACCESS_ERROR: begin
        state_d = LATENCY;
        ptw_access_exception_o = 1'b1;
      end
      // wait for the rvalid before going back to IDLE
      WAIT_RVALID: begin
        if (data_rvalid_q) state_d = IDLE;
      end
      LATENCY: begin
        state_d = IDLE;
      end
      default: begin
        state_d = IDLE;
      end
    endcase

    // -------
    // Flush
    // -------
    // should we have flushed before we got an rvalid, wait for it until going back to IDLE
    if (flush_i) begin
      // on a flush check whether we are
      // 1. in the PTE Lookup check whether we still need to wait for an rvalid
      // 2. waiting for a grant, if so: wait for it
      // if not, go back to idle
      if (((state_q inside {PTE_LOOKUP, WAIT_RVALID}) && !data_rvalid_q) || ((state_q == WAIT_GRANT) && req_port_i.data_gnt))
        state_d = WAIT_RVALID;
      else state_d = LATENCY;
    end
  end

  // sequential process
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      state_q           <= IDLE;
      is_instr_ptw_q    <= 1'b0;
      ptw_lvl_q         <= '0;
      tag_valid_q       <= 1'b0;
      tlb_update_asid_q <= '0;
      tlb_update_vmid_q <= '0;
      vaddr_q           <= '0;
      ptw_pptr_q        <= '0;
      global_mapping_q  <= 1'b0;
      data_rdata_q      <= '0;
      data_rvalid_q     <= 1'b0;
      if (CVA6Cfg.RVH) begin
        gpaddr_q    <= '0;
        gptw_pptr_q <= '0;
        ptw_stage_q <= S_STAGE;
        gpte_q      <= '0;
      end
    end else begin
      state_q           <= state_d;
      ptw_pptr_q        <= ptw_pptr_n;
      is_instr_ptw_q    <= is_instr_ptw_n;
      ptw_lvl_q         <= ptw_lvl_n;
      tag_valid_q       <= tag_valid_n;
      tlb_update_asid_q <= tlb_update_asid_n;
      vaddr_q           <= vaddr_n;
      global_mapping_q  <= global_mapping_n;
      data_rdata_q      <= req_port_i.data_rdata;
      data_rvalid_q     <= req_port_i.data_rvalid;

      if (CVA6Cfg.RVH) begin
        gpaddr_q          <= gpaddr_n;
        gptw_pptr_q       <= gptw_pptr_n;
        ptw_stage_q       <= ptw_stage_d;
        gpte_q            <= gpte_d;
        tlb_update_vmid_q <= tlb_update_vmid_n;
      end
    end
  end

endmodule
/* verilator lint_on WIDTH */
