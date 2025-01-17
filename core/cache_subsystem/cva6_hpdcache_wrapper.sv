// Copyright 2023 Commissariat a l'Energie Atomique et aux Energies
//                Alternatives (CEA)
//
// Licensed under the Solderpad Hardware License, Version 2.1 (the “License”);
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Authors: Cesar Fuguet
// Date: February, 2023
// Description: Wrapper for the Core-V High-Performance L1 data cache (CV-HPDcache)

`include "hpdcache_typedef.svh"

module cva6_hpdcache_wrapper
//  Parameters
//  {{{
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter hpdcache_pkg::hpdcache_cfg_t HPDcacheCfg = '0,
    parameter type dcache_req_i_t = logic,
    parameter type dcache_req_o_t = logic,
    parameter int NumPorts = 4,
    parameter int NrHwPrefetchers = 4,

    parameter type cmo_req_t = logic,
    parameter type cmo_rsp_t = logic,
    parameter type hpdcache_mem_addr_t = logic,
    parameter type hpdcache_mem_id_t = logic,
    parameter type hpdcache_mem_data_t = logic,
    parameter type hpdcache_mem_be_t = logic,
    parameter type hpdcache_mem_req_t = logic,
    parameter type hpdcache_mem_req_w_t = logic,
    parameter type hpdcache_mem_resp_r_t = logic,
    parameter type hpdcache_mem_resp_w_t = logic,
    parameter type hpdcache_req_offset_t = logic,
    parameter type hpdcache_data_word_t = logic,
    parameter type hpdcache_req_data_t = logic,
    parameter type hpdcache_req_be_t = logic,
    parameter type hpdcache_req_sid_t = logic,
    parameter type hpdcache_req_tid_t = logic,
    parameter type hpdcache_tag_t = logic,
    parameter type hpdcache_req_t = logic,
    parameter type hpdcache_rsp_t = logic,
    parameter type hpdcache_wbuf_timecnt_t = logic,
    parameter type hpdcache_data_be_t = logic
)
//  }}}

//  Ports
//  {{{
(

    // Subsystem Clock - SUBSYSTEM
    input logic clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input logic rst_ni,

    //  D$
    //  {{{
    //    Cache management
    // Data cache enable - CSR_REGFILE
    input  logic dcache_enable_i,
    // Data cache flush - CONTROLLER
    input  logic dcache_flush_i,
    // Flush acknowledge - CONTROLLER
    output logic dcache_flush_ack_o,
    // Load or store miss - PERF_COUNTERS
    output logic dcache_miss_o,

    // AMO request/response - EX_STAGE
    input  ariane_pkg::amo_req_t                 dcache_amo_req_i,
    output ariane_pkg::amo_resp_t                dcache_amo_resp_o,
    // CMO interface request/response
    input  cmo_req_t                             dcache_cmo_req_i,
    output cmo_rsp_t                             dcache_cmo_resp_o,
    // Data cache input request/response ports - EX_STAGE
    input  dcache_req_i_t         [NumPorts-1:0] dcache_req_ports_i,
    output dcache_req_o_t         [NumPorts-1:0] dcache_req_ports_o,
    // Write buffer status - EX_STAGE
    output logic                                 wbuffer_empty_o,
    output logic                                 wbuffer_not_ni_o,

    //  Hardware memory prefetcher configuration
    input  logic [NrHwPrefetchers-1:0]       hwpf_base_set_i,
    input  logic [NrHwPrefetchers-1:0][63:0] hwpf_base_i,
    output logic [NrHwPrefetchers-1:0][63:0] hwpf_base_o,
    input  logic [NrHwPrefetchers-1:0]       hwpf_param_set_i,
    input  logic [NrHwPrefetchers-1:0][63:0] hwpf_param_i,
    output logic [NrHwPrefetchers-1:0][63:0] hwpf_param_o,
    input  logic [NrHwPrefetchers-1:0]       hwpf_throttle_set_i,
    input  logic [NrHwPrefetchers-1:0][63:0] hwpf_throttle_i,
    output logic [NrHwPrefetchers-1:0][63:0] hwpf_throttle_o,
    output logic [               63:0]       hwpf_status_o,

    input  logic              dcache_mem_req_read_ready_i,
    output logic              dcache_mem_req_read_valid_o,
    output hpdcache_mem_req_t dcache_mem_req_read_o,

    output logic                 dcache_mem_resp_read_ready_o,
    input  logic                 dcache_mem_resp_read_valid_i,
    input  hpdcache_mem_resp_r_t dcache_mem_resp_read_i,

    input  logic              dcache_mem_req_write_ready_i,
    output logic              dcache_mem_req_write_valid_o,
    output hpdcache_mem_req_t dcache_mem_req_write_o,

    input  logic                dcache_mem_req_write_data_ready_i,
    output logic                dcache_mem_req_write_data_valid_o,
    output hpdcache_mem_req_w_t dcache_mem_req_write_data_o,

    output logic                 dcache_mem_resp_write_ready_o,
    input  logic                 dcache_mem_resp_write_valid_i,
    input  hpdcache_mem_resp_w_t dcache_mem_resp_write_i
);

  localparam int HPDCACHE_NREQUESTERS = NumPorts + 2;

  typedef logic [63:0] hwpf_stride_param_t;

  logic                        dcache_req_valid[HPDCACHE_NREQUESTERS];
  logic                        dcache_req_ready[HPDCACHE_NREQUESTERS];
  hpdcache_req_t               dcache_req      [HPDCACHE_NREQUESTERS];
  logic                        dcache_req_abort[HPDCACHE_NREQUESTERS];
  hpdcache_tag_t               dcache_req_tag  [HPDCACHE_NREQUESTERS];
  hpdcache_pkg::hpdcache_pma_t dcache_req_pma  [HPDCACHE_NREQUESTERS];
  logic                        dcache_rsp_valid[HPDCACHE_NREQUESTERS];
  hpdcache_rsp_t               dcache_rsp      [HPDCACHE_NREQUESTERS];
  logic dcache_read_miss, dcache_write_miss;

  logic                                   [                2:0] snoop_valid;
  logic                                   [                2:0] snoop_abort;
  hpdcache_req_offset_t                   [                2:0] snoop_addr_offset;
  hpdcache_tag_t                          [                2:0] snoop_addr_tag;
  logic                                   [                2:0] snoop_phys_indexed;

  logic                                                         dcache_cmo_req_is_prefetch;

  hwpf_stride_pkg::hwpf_stride_throttle_t [NrHwPrefetchers-1:0] hwpf_throttle_in;
  hwpf_stride_pkg::hwpf_stride_throttle_t [NrHwPrefetchers-1:0] hwpf_throttle_out;

  generate
    dcache_req_i_t dcache_req_ports[NumPorts - 1];

    for (genvar r = 0; r < (NumPorts - 1); r++) begin : gen_cva6_hpdcache_load_if_adapter
      assign dcache_req_ports[r] = dcache_req_ports_i[r];

      cva6_hpdcache_if_adapter #(
          .CVA6Cfg              (CVA6Cfg),
          .HPDcacheCfg          (HPDcacheCfg),
          .hpdcache_tag_t       (hpdcache_tag_t),
          .hpdcache_req_offset_t(hpdcache_req_offset_t),
          .hpdcache_req_sid_t   (hpdcache_req_sid_t),
          .hpdcache_req_t       (hpdcache_req_t),
          .hpdcache_rsp_t       (hpdcache_rsp_t),
          .dcache_req_i_t       (dcache_req_i_t),
          .dcache_req_o_t       (dcache_req_o_t),
          .InvalidateOnFlush    (1'b0),
          .IsLoadPort           (1'b1)
      ) i_cva6_hpdcache_load_if_adapter (
          .clk_i,
          .rst_ni,

          .hpdcache_req_sid_i(hpdcache_req_sid_t'(r)),

          .cva6_req_i     (dcache_req_ports[r]),
          .cva6_req_o     (dcache_req_ports_o[r]),
          .cva6_amo_req_i ('0),
          .cva6_amo_resp_o(  /* unused */),

          .cva6_dcache_flush_i    (1'b0),
          .cva6_dcache_flush_ack_o(  /* unused */),

          .hpdcache_req_valid_o(dcache_req_valid[r]),
          .hpdcache_req_ready_i(dcache_req_ready[r]),
          .hpdcache_req_o      (dcache_req[r]),
          .hpdcache_req_abort_o(dcache_req_abort[r]),
          .hpdcache_req_tag_o  (dcache_req_tag[r]),
          .hpdcache_req_pma_o  (dcache_req_pma[r]),

          .hpdcache_rsp_valid_i(dcache_rsp_valid[r]),
          .hpdcache_rsp_i      (dcache_rsp[r])
      );
    end

    cva6_hpdcache_if_adapter #(
        .CVA6Cfg              (CVA6Cfg),
        .HPDcacheCfg          (HPDcacheCfg),
        .hpdcache_tag_t       (hpdcache_tag_t),
        .hpdcache_req_offset_t(hpdcache_req_offset_t),
        .hpdcache_req_sid_t   (hpdcache_req_sid_t),
        .hpdcache_req_t       (hpdcache_req_t),
        .hpdcache_rsp_t       (hpdcache_rsp_t),
        .dcache_req_i_t       (dcache_req_i_t),
        .dcache_req_o_t       (dcache_req_o_t),
        .InvalidateOnFlush    (CVA6Cfg.DcacheInvalidateOnFlush),
        .IsLoadPort           (1'b0)
    ) i_cva6_hpdcache_store_if_adapter (
        .clk_i,
        .rst_ni,

        .hpdcache_req_sid_i(hpdcache_req_sid_t'(NumPorts - 1)),

        .cva6_req_i     (dcache_req_ports_i[NumPorts-1]),
        .cva6_req_o     (dcache_req_ports_o[NumPorts-1]),
        .cva6_amo_req_i (dcache_amo_req_i),
        .cva6_amo_resp_o(dcache_amo_resp_o),

        .cva6_dcache_flush_i    (dcache_flush_i),
        .cva6_dcache_flush_ack_o(dcache_flush_ack_o),

        .hpdcache_req_valid_o(dcache_req_valid[NumPorts-1]),
        .hpdcache_req_ready_i(dcache_req_ready[NumPorts-1]),
        .hpdcache_req_o      (dcache_req[NumPorts-1]),
        .hpdcache_req_abort_o(dcache_req_abort[NumPorts-1]),
        .hpdcache_req_tag_o  (dcache_req_tag[NumPorts-1]),
        .hpdcache_req_pma_o  (dcache_req_pma[NumPorts-1]),

        .hpdcache_rsp_valid_i(dcache_rsp_valid[NumPorts-1]),
        .hpdcache_rsp_i      (dcache_rsp[NumPorts-1])
    );

`ifdef HPDCACHE_ENABLE_CMO
    cva6_hpdcache_cmo_if_adapter #(
        .cmo_req_t(cmo_req_t),
        .cmo_rsp_t(cmo_rsp_t)
    ) i_cva6_hpdcache_cmo_if_adapter (
        .clk_i,
        .rst_ni,

        .dcache_req_sid_i(hpdcache_req_sid_t'(NumPorts)),

        .cva6_cmo_req_i (dcache_cmo_req_i),
        .cva6_cmo_resp_o(dcache_cmo_resp_o),

        .dcache_req_valid_o(dcache_req_valid[NumPorts]),
        .dcache_req_ready_i(dcache_req_ready[NumPorts]),
        .dcache_req_o      (dcache_req[NumPorts]),
        .dcache_req_abort_o(dcache_req_abort[NumPorts]),
        .dcache_req_tag_o  (dcache_req_tag[NumPorts]),
        .dcache_req_pma_o  (dcache_req_pma[NumPorts]),

        .dcache_rsp_valid_i(dcache_rsp_valid[NumPorts]),
        .dcache_rsp_i      (dcache_rsp[NumPorts])
    );
`else
    assign dcache_req_valid[NumPorts] = 1'b0,
        dcache_req[NumPorts] = '0,
        dcache_req_abort[NumPorts] = 1'b0,
        dcache_req_tag[NumPorts] = '0,
        dcache_req_pma[NumPorts] = '0;
`endif
  endgenerate

  //  Snoop load port
  assign snoop_valid[0] = dcache_req_valid[1] & dcache_req_ready[1],
      snoop_abort[0] = dcache_req_abort[1],
      snoop_addr_offset[0] = dcache_req[1].addr_offset,
      snoop_addr_tag[0] = dcache_req_tag[1],
      snoop_phys_indexed[0] = dcache_req[1].phys_indexed;

  //  Snoop Store/AMO port
  assign snoop_valid[1] = dcache_req_valid[NumPorts-1] & dcache_req_ready[NumPorts-1],
      snoop_abort[1] = dcache_req_abort[NumPorts-1],
      snoop_addr_offset[1] = dcache_req[NumPorts-1].addr_offset,
      snoop_addr_tag[1] = dcache_req_tag[NumPorts-1],
      snoop_phys_indexed[1] = dcache_req[NumPorts-1].phys_indexed;

`ifdef HPDCACHE_ENABLE_CMO
  //  Snoop CMO port (in case of read prefetch accesses)
  assign dcache_cmo_req_is_prefetch = hpdcache_pkg::is_cmo_prefetch(
      dcache_req[NumPorts].op, dcache_req[NumPorts].size
  );
  assign snoop_valid[2]        = dcache_req_valid[NumPorts]
                               & dcache_req_ready[NumPorts]
                               & dcache_cmo_req_is_prefetch,
      snoop_abort[2] = dcache_req_abort[NumPorts],
      snoop_addr_offset[2] = dcache_req[NumPorts].addr_offset,
      snoop_addr_tag[2] = dcache_req_tag[NumPorts],
      snoop_phys_indexed[2] = dcache_req[NumPorts].phys_indexed;
`else
  assign snoop_valid[2] = 1'b0,
      snoop_abort[2] = 1'b0,
      snoop_addr_offset[2] = '0,
      snoop_addr_tag[2] = '0,
      snoop_phys_indexed[2] = 1'b0;
`endif

  generate
    for (genvar h = 0; h < NrHwPrefetchers; h++) begin : gen_hwpf_throttle
      assign hwpf_throttle_in[h] = hwpf_stride_pkg::hwpf_stride_throttle_t'(hwpf_throttle_i[h]);
      assign hwpf_throttle_o[h]  = hwpf_stride_pkg::hwpf_stride_param_t'(hwpf_throttle_out[h]);
    end
  endgenerate

  hwpf_stride_wrapper #(
      .HPDcacheCfg          (HPDcacheCfg),
      .NUM_HW_PREFETCH      (NrHwPrefetchers),
      .NUM_SNOOP_PORTS      (3),
      .hpdcache_tag_t       (hpdcache_tag_t),
      .hpdcache_req_offset_t(hpdcache_req_offset_t),
      .hpdcache_req_data_t  (hpdcache_req_data_t),
      .hpdcache_req_be_t    (hpdcache_req_be_t),
      .hpdcache_req_sid_t   (hpdcache_req_sid_t),
      .hpdcache_req_tid_t   (hpdcache_req_tid_t),
      .hpdcache_req_t       (hpdcache_req_t),
      .hpdcache_rsp_t       (hpdcache_rsp_t)
  ) i_hwpf_stride_wrapper (
      .clk_i,
      .rst_ni,

      .hwpf_stride_base_set_i    (hwpf_base_set_i),
      .hwpf_stride_base_i        (hwpf_base_i),
      .hwpf_stride_base_o        (hwpf_base_o),
      .hwpf_stride_param_set_i   (hwpf_param_set_i),
      .hwpf_stride_param_i       (hwpf_param_i),
      .hwpf_stride_param_o       (hwpf_param_o),
      .hwpf_stride_throttle_set_i(hwpf_throttle_set_i),
      .hwpf_stride_throttle_i    (hwpf_throttle_in),
      .hwpf_stride_throttle_o    (hwpf_throttle_out),
      .hwpf_stride_status_o      (hwpf_status_o),

      .snoop_valid_i       (snoop_valid),
      .snoop_abort_i       (snoop_abort),
      .snoop_addr_offset_i (snoop_addr_offset),
      .snoop_addr_tag_i    (snoop_addr_tag),
      .snoop_phys_indexed_i(snoop_phys_indexed),

      .hpdcache_req_sid_i(hpdcache_req_sid_t'(NumPorts + 1)),

      .hpdcache_req_valid_o(dcache_req_valid[NumPorts+1]),
      .hpdcache_req_ready_i(dcache_req_ready[NumPorts+1]),
      .hpdcache_req_o      (dcache_req[NumPorts+1]),
      .hpdcache_req_abort_o(dcache_req_abort[NumPorts+1]),
      .hpdcache_req_tag_o  (dcache_req_tag[NumPorts+1]),
      .hpdcache_req_pma_o  (dcache_req_pma[NumPorts+1]),
      .hpdcache_rsp_valid_i(dcache_rsp_valid[NumPorts+1]),
      .hpdcache_rsp_i      (dcache_rsp[NumPorts+1])
  );

  hpdcache #(
      .HPDcacheCfg          (HPDcacheCfg),
      .wbuf_timecnt_t       (hpdcache_wbuf_timecnt_t),
      .hpdcache_tag_t       (hpdcache_tag_t),
      .hpdcache_data_word_t (hpdcache_data_word_t),
      .hpdcache_data_be_t   (hpdcache_data_be_t),
      .hpdcache_req_offset_t(hpdcache_req_offset_t),
      .hpdcache_req_data_t  (hpdcache_req_data_t),
      .hpdcache_req_be_t    (hpdcache_req_be_t),
      .hpdcache_req_sid_t   (hpdcache_req_sid_t),
      .hpdcache_req_tid_t   (hpdcache_req_tid_t),
      .hpdcache_req_t       (hpdcache_req_t),
      .hpdcache_rsp_t       (hpdcache_rsp_t),
      .hpdcache_mem_addr_t  (hpdcache_mem_addr_t),
      .hpdcache_mem_id_t    (hpdcache_mem_id_t),
      .hpdcache_mem_data_t  (hpdcache_mem_data_t),
      .hpdcache_mem_be_t    (hpdcache_mem_be_t),
      .hpdcache_mem_req_t   (hpdcache_mem_req_t),
      .hpdcache_mem_req_w_t (hpdcache_mem_req_w_t),
      .hpdcache_mem_resp_r_t(hpdcache_mem_resp_r_t),
      .hpdcache_mem_resp_w_t(hpdcache_mem_resp_w_t)
  ) i_hpdcache (
      .clk_i,
      .rst_ni,

      .wbuf_flush_i(dcache_flush_i),

      .core_req_valid_i(dcache_req_valid),
      .core_req_ready_o(dcache_req_ready),
      .core_req_i      (dcache_req),
      .core_req_abort_i(dcache_req_abort),
      .core_req_tag_i  (dcache_req_tag),
      .core_req_pma_i  (dcache_req_pma),

      .core_rsp_valid_o(dcache_rsp_valid),
      .core_rsp_o      (dcache_rsp),

      .mem_req_read_ready_i(dcache_mem_req_read_ready_i),
      .mem_req_read_valid_o(dcache_mem_req_read_valid_o),
      .mem_req_read_o      (dcache_mem_req_read_o),

      .mem_resp_read_ready_o(dcache_mem_resp_read_ready_o),
      .mem_resp_read_valid_i(dcache_mem_resp_read_valid_i),
      .mem_resp_read_i      (dcache_mem_resp_read_i),

      .mem_req_write_ready_i(dcache_mem_req_write_ready_i),
      .mem_req_write_valid_o(dcache_mem_req_write_valid_o),
      .mem_req_write_o      (dcache_mem_req_write_o),

      .mem_req_write_data_ready_i(dcache_mem_req_write_data_ready_i),
      .mem_req_write_data_valid_o(dcache_mem_req_write_data_valid_o),
      .mem_req_write_data_o      (dcache_mem_req_write_data_o),

      .mem_resp_write_ready_o(dcache_mem_resp_write_ready_o),
      .mem_resp_write_valid_i(dcache_mem_resp_write_valid_i),
      .mem_resp_write_i      (dcache_mem_resp_write_i),

      .evt_cache_write_miss_o(dcache_write_miss),
      .evt_cache_read_miss_o (dcache_read_miss),
      .evt_uncached_req_o    (  /* unused */),
      .evt_cmo_req_o         (  /* unused */),
      .evt_write_req_o       (  /* unused */),
      .evt_read_req_o        (  /* unused */),
      .evt_prefetch_req_o    (  /* unused */),
      .evt_req_on_hold_o     (  /* unused */),
      .evt_rtab_rollback_o   (  /* unused */),
      .evt_stall_refill_o    (  /* unused */),
      .evt_stall_o           (  /* unused */),

      .wbuf_empty_o(wbuffer_empty_o),

      .cfg_enable_i                       (dcache_enable_i),
      .cfg_wbuf_threshold_i               (3'd2),
      .cfg_wbuf_reset_timecnt_on_write_i  (1'b1),
      .cfg_wbuf_sequential_waw_i          (1'b0),
      .cfg_wbuf_inhibit_write_coalescing_i(1'b0),
      .cfg_prefetch_updt_plru_i           (1'b1),
      .cfg_error_on_cacheable_amo_i       (1'b0),
      .cfg_rtab_single_entry_i            (1'b0),
      .cfg_default_wb_i                   (1'b0)
  );

  assign dcache_miss_o = dcache_read_miss, wbuffer_not_ni_o = wbuffer_empty_o;
  //  }}}

endmodule : cva6_hpdcache_wrapper
