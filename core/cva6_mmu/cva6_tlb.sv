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
// Author: Angela Gonzalez PlanV Technology
// Date: 26/02/2024
//
// Description: Translation Lookaside Buffer, parameterizable to Sv32 or Sv39 , 
//              or sv39x4 fully set-associative
//              This module is an merge of the Sv32 TLB developed by Sebastien
//              Jacq (Thales Research & Technology), the Sv39 TLB developed
//              by Florian Zaruba and David Schaffenrath and the Sv39x4 by Bruno Sá.

module cva6_tlb
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type pte_cva6_t = logic,
    parameter type tlb_update_cva6_t = logic,
    parameter int unsigned TLB_ENTRIES = 4,
    parameter int unsigned HYP_EXT = 0
) (
    input logic clk_i,  // Clock
    input logic rst_ni,  // Asynchronous reset active low
    input logic flush_i,  // Flush normal translations signal
    input logic flush_vvma_i,  // Flush vs stage signal
    input logic flush_gvma_i,  // Flush g stage signal
    input logic s_st_enbl_i,  // s-stage enabled
    input logic g_st_enbl_i,  // g-stage enabled
    input logic v_i,  // virtualization mode
    // Update TLB
    input tlb_update_cva6_t update_i,
    // Lookup signals
    input logic lu_access_i,
    input logic [CVA6Cfg.ASID_WIDTH-1:0] lu_asid_i,
    input logic [CVA6Cfg.VMID_WIDTH-1:0] lu_vmid_i,
    input logic [CVA6Cfg.VLEN-1:0] lu_vaddr_i,
    output logic [CVA6Cfg.GPLEN-1:0] lu_gpaddr_o,
    output pte_cva6_t lu_content_o,
    output pte_cva6_t lu_g_content_o,
    input logic [CVA6Cfg.ASID_WIDTH-1:0] asid_to_be_flushed_i,
    input logic [CVA6Cfg.VMID_WIDTH-1:0] vmid_to_be_flushed_i,
    input logic [CVA6Cfg.VLEN-1:0] vaddr_to_be_flushed_i,
    input logic [CVA6Cfg.GPLEN-1:0] gpaddr_to_be_flushed_i,
    output logic [CVA6Cfg.PtLevels-2:0] lu_is_page_o,
    output logic lu_hit_o
);
  localparam GPPN2 = (CVA6Cfg.XLEN == 32) ? CVA6Cfg.VLEN - 33 : 10;
  // SV39 defines three levels of page tables
  struct packed {
    logic [CVA6Cfg.ASID_WIDTH-1:0] asid;
    logic [CVA6Cfg.VMID_WIDTH-1:0] vmid;
    logic [CVA6Cfg.PtLevels+HYP_EXT-1:0][(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)-1:0] vpn;
    logic [CVA6Cfg.PtLevels-2:0][HYP_EXT:0] is_page;
    logic [HYP_EXT*2:0] v_st_enbl;  // v_i,g-stage enabled, s-stage enabled
    logic valid;
  } [TLB_ENTRIES-1:0]
      tags_q, tags_n;

  struct packed {
    pte_cva6_t pte;
    pte_cva6_t gpte;
  } [TLB_ENTRIES-1:0]
      content_q, content_n;

  logic [TLB_ENTRIES-1:0][CVA6Cfg.PtLevels-1:0] vpn_match;
  logic [TLB_ENTRIES-1:0][CVA6Cfg.PtLevels-1:0] level_match;
  logic [TLB_ENTRIES-1:0][HYP_EXT:0][CVA6Cfg.PtLevels-1:0] vaddr_vpn_match;
  logic [TLB_ENTRIES-1:0][HYP_EXT:0][CVA6Cfg.PtLevels-1:0] vaddr_level_match;
  logic [TLB_ENTRIES-1:0] lu_hit;  // to replacement logic
  logic [TLB_ENTRIES-1:0] replace_en;  // replace the following entry, set by replacement strategy
  logic [TLB_ENTRIES-1:0] match_asid;
  logic [TLB_ENTRIES-1:0] match_vmid;
  logic [TLB_ENTRIES-1:0][CVA6Cfg.PtLevels-1:0] page_match;
  logic [TLB_ENTRIES-1:0][HYP_EXT:0][CVA6Cfg.PtLevels-1:0] vpage_match;
  logic [TLB_ENTRIES-1:0][CVA6Cfg.PtLevels-2:0] is_page_o;
  logic [TLB_ENTRIES-1:0] match_stage;
  pte_cva6_t g_content;
  logic [TLB_ENTRIES-1:0][(CVA6Cfg.GPPNW-1):0] gppn;
  logic [2:0] v_st_enbl;

  assign v_st_enbl = (CVA6Cfg.RVH) ? {v_i, g_st_enbl_i, s_st_enbl_i} : '1;
  //-------------
  // Translation
  //-------------

  genvar i, x, z, w;
  generate
    for (i = 0; i < TLB_ENTRIES; i++) begin
      for (x = 0; x < CVA6Cfg.PtLevels; x++) begin
        //identify page_match for all TLB Entries  
        assign page_match[i][x] = x==0 ? 1 :((HYP_EXT==0 || x==(CVA6Cfg.PtLevels-1)) ? // PAGE_MATCH CONTAINS THE MATCH INFORMATION FOR EACH TAG OF is_1G and is_2M in sv39x4. HIGHER LEVEL (Giga page), THEN THERE IS THE Mega page AND AT THE LOWER LEVEL IS ALWAYS 1
            &(tags_q[i].is_page[CVA6Cfg.PtLevels-1-x] | (~v_st_enbl[HYP_EXT:0])):
                                        ((&v_st_enbl[HYP_EXT:0]) ? 
                                        ((tags_q[i].is_page[CVA6Cfg.PtLevels-1-x][0] && (tags_q[i].is_page[CVA6Cfg.PtLevels-2-x][HYP_EXT] || tags_q[i].is_page[CVA6Cfg.PtLevels-1-x][HYP_EXT])) 
                                      || (tags_q[i].is_page[CVA6Cfg.PtLevels-1-x][HYP_EXT] && (tags_q[i].is_page[CVA6Cfg.PtLevels-2-x][0] || tags_q[i].is_page[CVA6Cfg.PtLevels-1-x][0]))):
                                          tags_q[i].is_page[CVA6Cfg.PtLevels-1-x][0] && s_st_enbl_i || tags_q[i].is_page[CVA6Cfg.PtLevels-1-x][HYP_EXT] && g_st_enbl_i));

        //identify if vpn matches at all PT levels for all TLB entries  
        assign vpn_match[i][x] = (CVA6Cfg.RVH && x == (CVA6Cfg.PtLevels - 1) && ~s_st_enbl_i) ?  //
            lu_vaddr_i[12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*(x+1))-1:12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*x)] == tags_q[i].vpn[x] && lu_vaddr_i[12+HYP_EXT*(CVA6Cfg.VpnLen-1): 12+HYP_EXT*(CVA6Cfg.VpnLen-(CVA6Cfg.VpnLen%CVA6Cfg.PtLevels))] == tags_q[i].vpn[x+HYP_EXT][(CVA6Cfg.VpnLen%CVA6Cfg.PtLevels)-HYP_EXT:0]: //
            lu_vaddr_i[12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*(x+1))-1:12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*x)] == tags_q[i].vpn[x];

        //identify if there is a hit at each PT level for all TLB entries  
        assign level_match[i][x] = &vpn_match[i][CVA6Cfg.PtLevels-1:x] && page_match[i][x];

        //identify vpage_match for all TLB Entries and vaddr_level match (if there is a hit at each PT level for all TLB entries on the vaddr)
        for (z = 0; z < HYP_EXT + 1; z++) begin
          assign vpage_match[i][z][x] = x == 0 ? 1 : tags_q[i].is_page[CVA6Cfg.PtLevels-1-x][z];
          assign vaddr_level_match[i][z][x]= &vaddr_vpn_match[i][z][CVA6Cfg.PtLevels-1:x] && vpage_match[i][z][x];

        end
        //identify if virtual address vpn matches at all PT levels for all TLB entries 
        assign vaddr_vpn_match[i][0][x]  = vaddr_to_be_flushed_i[12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*(x+1))-1:12+((CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)*x)] == tags_q[i].vpn[x];

      end



      if (CVA6Cfg.RVH) begin
        //identify if GPADDR matches the GPPN
        assign vaddr_vpn_match[i][HYP_EXT][0] = (gpaddr_to_be_flushed_i[20:12] == gppn[i][8:0]);
        assign vaddr_vpn_match[i][HYP_EXT][HYP_EXT] = (gpaddr_to_be_flushed_i[29:21] == gppn[i][17:9]);
        assign vaddr_vpn_match[i][HYP_EXT][HYP_EXT*2] = (gpaddr_to_be_flushed_i[30+GPPN2:30] == gppn[i][18+GPPN2:18]);

      end

      for (w = 0; w < CVA6Cfg.PtLevels - 1; w++) begin
        assign is_page_o[i][w] = page_match[i][CVA6Cfg.PtLevels - 1 - w]; //THIS REORGANIZES THE PAGES TO MATCH THE OUTPUT STRUCTURE (2M,1G)
      end
    end
  endgenerate

  always_comb begin : translation

    // default assignment
    lu_hit         = '{default: 0};
    lu_hit_o       = 1'b0;
    lu_content_o   = '{default: 0};
    lu_g_content_o = '{default: 0};
    lu_is_page_o   = '{default: 0};
    match_asid     = '{default: 0};
    match_vmid     = CVA6Cfg.RVH ? '{default: 0} : '{default: 1};
    match_stage    = '{default: 0};
    g_content      = '{default: 0};
    lu_gpaddr_o    = '{default: 0};

    for (int unsigned i = 0; i < TLB_ENTRIES; i++) begin
      // first level match, this may be a giga page, check the ASID flags as well
      // if the entry is associated to a global address, don't match the ASID (ASID is don't care)
      match_asid[i] = ((lu_asid_i == tags_q[i].asid || content_q[i].pte.g) && s_st_enbl_i) || !s_st_enbl_i;

      if (CVA6Cfg.RVH) begin
        match_vmid[i] = (lu_vmid_i == tags_q[i].vmid && g_st_enbl_i) || !g_st_enbl_i;
      end

      // check if translation is a: S-Stage and G-Stage, S-Stage only or G-Stage only translation and virtualization mode is on/off
      match_stage[i] = tags_q[i].v_st_enbl[HYP_EXT*2:0] == v_st_enbl[HYP_EXT*2:0];

      if (tags_q[i].valid && match_asid[i] && match_vmid[i] && match_stage[i]) begin

        if (CVA6Cfg.RVH && vpn_match[i][HYP_EXT*2]) begin
          if (s_st_enbl_i) begin
            lu_gpaddr_o = {content_q[i].pte.ppn[(CVA6Cfg.GPPNW-1):0], lu_vaddr_i[11:0]};
            // Giga page
            if (tags_q[i].is_page[0][0])
              lu_gpaddr_o[12+2*CVA6Cfg.VpnLen/CVA6Cfg.PtLevels-1:12] = lu_vaddr_i[12+2*CVA6Cfg.VpnLen/CVA6Cfg.PtLevels-1:12];
            // Mega page
            if (tags_q[i].is_page[HYP_EXT][0])
              lu_gpaddr_o[12+CVA6Cfg.VpnLen/CVA6Cfg.PtLevels-1:12] = lu_vaddr_i[12+CVA6Cfg.VpnLen/CVA6Cfg.PtLevels-1:12];
          end else begin
            lu_gpaddr_o =CVA6Cfg.GPLEN'(lu_vaddr_i[(CVA6Cfg.XLEN == 32 ? CVA6Cfg.VLEN: CVA6Cfg.GPLEN)-1:0]);
          end
        end

        if (|level_match[i]) begin
          lu_is_page_o = is_page_o[i];
          lu_content_o = content_q[i].pte;
          lu_hit_o     = 1'b1;
          lu_hit[i]    = 1'b1;

          if (CVA6Cfg.RVH) begin
            // Compute G-Stage PPN based on the gpaddr
            g_content = content_q[i].gpte;
            if (tags_q[i].is_page[HYP_EXT][HYP_EXT]) g_content.ppn[8:0] = lu_gpaddr_o[20:12];
            if (tags_q[i].is_page[0][HYP_EXT]) g_content.ppn[17:0] = lu_gpaddr_o[29:12];
            // Output G-stage and S-stage content
            lu_g_content_o = level_match[i][CVA6Cfg.PtLevels-1] ? content_q[i].gpte : g_content;
          end
        end
      end
    end
  end

  logic [HYP_EXT:0]asid_to_be_flushed_is0;  // indicates that the ASID provided by SFENCE.VMA (rs2)is 0, active high
  logic [HYP_EXT:0] vaddr_to_be_flushed_is0;  // indicates that the VADDR provided by SFENCE.VMA (rs1)is 0, active high
  logic vmid_to_be_flushed_is0;  // indicates that the VMID provided is 0, active high
  logic gpaddr_to_be_flushed_is0;  // indicates that the GPADDR provided is 0, active high

  assign asid_to_be_flushed_is0   = ~(|asid_to_be_flushed_i);
  assign vaddr_to_be_flushed_is0  = ~(|vaddr_to_be_flushed_i);
  assign vmid_to_be_flushed_is0   = ~(|vmid_to_be_flushed_i);
  assign gpaddr_to_be_flushed_is0 = ~(|gpaddr_to_be_flushed_i);

  // ------------------
  // Update and Flush
  // ------------------
  always_comb begin : update_flush
    tags_n    = tags_q;
    content_n = content_q;

    for (int unsigned i = 0; i < TLB_ENTRIES; i++) begin


      if (CVA6Cfg.RVH) begin

        if (tags_q[i].v_st_enbl[0]) begin
          gppn[i] = content_q[i].pte.ppn[(CVA6Cfg.GPPNW-1):0];
          if (tags_q[i].is_page[HYP_EXT][0])
            gppn[i][CVA6Cfg.VpnLen/CVA6Cfg.PtLevels-1:0] = tags_q[i].vpn[0];
          if (tags_q[i].is_page[0][0])
            gppn[i][2*(CVA6Cfg.VpnLen/CVA6Cfg.PtLevels)-1:0] = {
              tags_q[i].vpn[HYP_EXT], tags_q[i].vpn[0]
            };
        end else begin
          gppn[i][CVA6Cfg.VpnLen-1:0] = CVA6Cfg.VpnLen'(tags_q[i].vpn);
        end
      end


      if (flush_i) begin
        if (!tags_q[i].v_st_enbl[HYP_EXT*2] || HYP_EXT == 0) begin
          // invalidate logic
          // flush everything if ASID is 0 and vaddr is 0 ("SFENCE.VMA x0 x0" case)
          if (asid_to_be_flushed_is0 && vaddr_to_be_flushed_is0) tags_n[i].valid = 1'b0;
          // flush vaddr in all addressing space ("SFENCE.VMA vaddr x0" case), it should happen only for leaf pages
          else if (asid_to_be_flushed_is0 && (|vaddr_level_match[i][0] ) && (~vaddr_to_be_flushed_is0))
            tags_n[i].valid = 1'b0;
          // the entry is flushed if it's not global and asid and vaddr both matches with the entry to be flushed ("SFENCE.VMA vaddr asid" case)
          else if ((!content_q[i].pte.g) && (|vaddr_level_match[i][0]) && (asid_to_be_flushed_i == tags_q[i].asid ) && (!vaddr_to_be_flushed_is0) && (!asid_to_be_flushed_is0))
            tags_n[i].valid = 1'b0;
          // the entry is flushed if it's not global, and the asid matches and vaddr is 0. ("SFENCE.VMA 0 asid" case)
          else if ((!content_q[i].pte.g) && (vaddr_to_be_flushed_is0) && (asid_to_be_flushed_i  == tags_q[i].asid ) && (!asid_to_be_flushed_is0))
            tags_n[i].valid = 1'b0;
        end
      end else if (flush_vvma_i && CVA6Cfg.RVH) begin
        if (tags_q[i].v_st_enbl[HYP_EXT*2] && tags_q[i].v_st_enbl[0]) begin
          // invalidate logic
          // flush everything if current VMID matches and ASID is 0 and vaddr is 0 ("SFENCE.VMA/HFENCE.VVMA x0 x0" case)
          if (asid_to_be_flushed_is0 && vaddr_to_be_flushed_is0 && ((tags_q[i].v_st_enbl[HYP_EXT] && lu_vmid_i == tags_q[i].vmid) || !tags_q[i].v_st_enbl[HYP_EXT]))
            tags_n[i].valid = 1'b0;
          // flush vaddr in all addressing space if current VMID matches ("SFENCE.VMA/HFENCE.VVMA vaddr x0" case), it should happen only for leaf pages
          else if (asid_to_be_flushed_is0 && (|vaddr_level_match[i][0]) && (~vaddr_to_be_flushed_is0) && ((tags_q[i].v_st_enbl[HYP_EXT] && lu_vmid_i == tags_q[i].vmid) || !tags_q[i].v_st_enbl[HYP_EXT]))
            tags_n[i].valid = 1'b0;
          // the entry is flushed if it's not global and asid and vaddr and current VMID matches with the entry to be flushed ("SFENCE.VMA/HFENCE.VVMA vaddr asid" case)
          else if ((!content_q[i].pte.g) && (|vaddr_level_match[i][0]) && (asid_to_be_flushed_i  == tags_q[i].asid  && ((tags_q[i].v_st_enbl[HYP_EXT] && lu_vmid_i == tags_q[i].vmid) || !tags_q[i].v_st_enbl[HYP_EXT])) && (!vaddr_to_be_flushed_is0) && (!asid_to_be_flushed_is0))
            tags_n[i].valid = 1'b0;
          // the entry is flushed if it's not global, and the asid and the current VMID matches and vaddr is 0. ("SFENCE.VMA/HFENCE.VVMA 0 asid" case)
          else if ((!content_q[i].pte.g) && (vaddr_to_be_flushed_is0) && (asid_to_be_flushed_i  == tags_q[i].asid  && ((tags_q[i].v_st_enbl[HYP_EXT] && lu_vmid_i == tags_q[i].vmid) || !tags_q[i].v_st_enbl[HYP_EXT])) && (!asid_to_be_flushed_is0))
            tags_n[i].valid = 1'b0;
        end
      end else if (flush_gvma_i && CVA6Cfg.RVH) begin
        if (tags_q[i].v_st_enbl[HYP_EXT]) begin
          // invalidate logic
          // flush everything if vmid is 0 and addr is 0 ("HFENCE.GVMA x0 x0" case)
          if (vmid_to_be_flushed_is0 && gpaddr_to_be_flushed_is0) tags_n[i].valid = 1'b0;
          // flush gpaddr in all addressing space ("HFENCE.GVMA gpaddr x0" case), it should happen only for leaf pages
          else if (vmid_to_be_flushed_is0 && (|vaddr_level_match[i][HYP_EXT] ) && (~gpaddr_to_be_flushed_is0))
            tags_n[i].valid = 1'b0;
          // the entry vmid and gpaddr both matches with the entry to be flushed ("HFENCE.GVMA gpaddr vmid" case)
          else if ((|vaddr_level_match[i][HYP_EXT]) && (vmid_to_be_flushed_i == tags_q[i].vmid) && (~gpaddr_to_be_flushed_is0) && (~vmid_to_be_flushed_is0))
            tags_n[i].valid = 1'b0;
          // the entry is flushed if the vmid matches and gpaddr is 0. ("HFENCE.GVMA 0 vmid" case)
          else if ((gpaddr_to_be_flushed_is0) && (vmid_to_be_flushed_i == tags_q[i].vmid) && (!vmid_to_be_flushed_is0))
            tags_n[i].valid = 1'b0;
        end
        // normal replacement
      end else if (update_i.valid & replace_en[i] & !lu_hit_o) begin
        //update tag
        tags_n[i] = {
          update_i.asid,
          update_i.vmid,
          ((CVA6Cfg.PtLevels + HYP_EXT) * (CVA6Cfg.VpnLen / CVA6Cfg.PtLevels))'(update_i.vpn),
          update_i.is_page,
          update_i.v_st_enbl,
          1'b1
        };
        // update content as well
        content_n[i].pte = update_i.content;
        if (CVA6Cfg.RVH) content_n[i].gpte = update_i.g_content;
      end
    end
  end

  // -----------------------------------------------
  // PLRU - Pseudo Least Recently Used Replacement
  // -----------------------------------------------
  logic [2*(TLB_ENTRIES-1)-1:0] plru_tree_q, plru_tree_n;
  always_comb begin : plru_replacement
    plru_tree_n = plru_tree_q;
    // The PLRU-tree indexing:
    // lvl0        0
    //            / \
//           /   \
// lvl1     1     2
//         / \   / \
// lvl2   3   4 5   6
//       / \ /\/\  /\
//      ... ... ... ...
// Just predefine which nodes will be set/cleared
// E.g. for a TLB with 8 entries, the for-loop is semantically
// equivalent to the following pseudo-code:
// unique case (1'b1)
// lu_hit[7]: plru_tree_n[0, 2, 6] = {1, 1, 1};
// lu_hit[6]: plru_tree_n[0, 2, 6] = {1, 1, 0};
// lu_hit[5]: plru_tree_n[0, 2, 5] = {1, 0, 1};
// lu_hit[4]: plru_tree_n[0, 2, 5] = {1, 0, 0};
// lu_hit[3]: plru_tree_n[0, 1, 4] = {0, 1, 1};
// lu_hit[2]: plru_tree_n[0, 1, 4] = {0, 1, 0};
// lu_hit[1]: plru_tree_n[0, 1, 3] = {0, 0, 1};
// lu_hit[0]: plru_tree_n[0, 1, 3] = {0, 0, 0};
// default: begin /* No hit */ end
// endcase
for (
        int unsigned i = 0; i < TLB_ENTRIES; i++
    ) begin
      automatic int unsigned idx_base, shift, new_index;
      // we got a hit so update the pointer as it was least recently used
      if (lu_hit[i] & lu_access_i) begin
        // Set the nodes to the values we would expect
        for (int unsigned lvl = 0; lvl < $clog2(TLB_ENTRIES); lvl++) begin
          idx_base = $unsigned((2 ** lvl) - 1);
          // lvl0 <=> MSB, lvl1 <=> MSB-1, ...
          shift = $clog2(TLB_ENTRIES) - lvl;
          // to circumvent the 32 bit integer arithmetic assignment
          new_index = ~((i >> (shift - 1)) & 32'b1);
          plru_tree_n[idx_base+(i>>shift)] = new_index[0];
        end
      end
    end
    // Decode tree to write enable signals
    // Next for-loop basically creates the following logic for e.g. an 8 entry
    // TLB (note: pseudo-code obviously):
    // replace_en[7] = &plru_tree_q[ 6, 2, 0]; //plru_tree_q[0,2,6]=={1,1,1}
    // replace_en[6] = &plru_tree_q[~6, 2, 0]; //plru_tree_q[0,2,6]=={1,1,0}
    // replace_en[5] = &plru_tree_q[ 5,~2, 0]; //plru_tree_q[0,2,5]=={1,0,1}
    // replace_en[4] = &plru_tree_q[~5,~2, 0]; //plru_tree_q[0,2,5]=={1,0,0}
    // replace_en[3] = &plru_tree_q[ 4, 1,~0]; //plru_tree_q[0,1,4]=={0,1,1}
    // replace_en[2] = &plru_tree_q[~4, 1,~0]; //plru_tree_q[0,1,4]=={0,1,0}
    // replace_en[1] = &plru_tree_q[ 3,~1,~0]; //plru_tree_q[0,1,3]=={0,0,1}
    // replace_en[0] = &plru_tree_q[~3,~1,~0]; //plru_tree_q[0,1,3]=={0,0,0}
    // For each entry traverse the tree. If every tree-node matches,
    // the corresponding bit of the entry's index, this is
    // the next entry to replace.
    for (int unsigned i = 0; i < TLB_ENTRIES; i += 1) begin
      automatic logic en;
      automatic int unsigned idx_base, shift, new_index;
      en = 1'b1;
      for (int unsigned lvl = 0; lvl < $clog2(TLB_ENTRIES); lvl++) begin
        idx_base = $unsigned((2 ** lvl) - 1);
        // lvl0 <=> MSB, lvl1 <=> MSB-1, ...
        shift = $clog2(TLB_ENTRIES) - lvl;

        // en &= plru_tree_q[idx_base + (i>>shift)] == ((i >> (shift-1)) & 1'b1);
        new_index = (i >> (shift - 1)) & 32'b1;
        if (new_index[0]) begin
          en &= plru_tree_q[idx_base+(i>>shift)];
        end else begin
          en &= ~plru_tree_q[idx_base+(i>>shift)];
        end
      end
      replace_en[i] = en;
    end
  end

  // sequential process
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      tags_q      <= '{default: 0};
      content_q   <= '{default: 0};
      plru_tree_q <= '{default: 0};
    end else begin
      tags_q      <= tags_n;
      content_q   <= content_n;
      plru_tree_q <= plru_tree_n;
    end
  end
  //--------------
  // Sanity checks
  //--------------

  //pragma translate_off

  initial begin : p_assertions
    assert ((TLB_ENTRIES % 2 == 0) && (TLB_ENTRIES > 1))
    else begin
      $error("TLB size must be a multiple of 2 and greater than 1");
      $stop();
    end
    assert (CVA6Cfg.ASID_WIDTH >= 1)
    else begin
      $error("ASID width must be at least 1");
      $stop();
    end
  end

  // Just for checking
  function int countSetBits(logic [TLB_ENTRIES-1:0] vector);
    automatic int count = 0;
    foreach (vector[idx]) begin
      count += vector[idx];
    end
    return count;
  endfunction

  assert property (@(posedge clk_i) (countSetBits(lu_hit) <= 1))
  else begin
    $error("More then one hit in TLB!");
    $stop();
  end
  assert property (@(posedge clk_i) (countSetBits(replace_en) <= 1))
  else begin
    $error("More then one TLB entry selected for next replace!");
    $stop();
  end

  //pragma translate_on

endmodule
