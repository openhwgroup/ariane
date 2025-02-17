//-----------------------------------------------------------------------------
// Copyright 2024 Robert Bosch GmbH
//
// SPDX-License-Identifier: SHL-0.51
//
// Original Author: Coralie Allioux - Robert Bosch France SAS
//-----------------------------------------------------------------------------

module pmp_data_if
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg       = config_pkg::cva6_cfg_empty,
    parameter type                   icache_areq_t = logic,
    parameter type                   exception_t   = logic
) (
    input logic clk_i,
    input logic rst_ni,
    // IF interface
    input icache_areq_t icache_areq_i,
    output icache_areq_t icache_areq_o,
    input [CVA6Cfg.VLEN-1:0] icache_fetch_vaddr_i,  // virtual address for tval only
    // LSU interface
    // this is a more minimalistic interface because the actual addressing logic is handled
    // in the LSU as we distinguish load and stores, what we do here is simple address translation
    input logic lsu_valid_i,  // request lsu access
    input logic [CVA6Cfg.PLEN-1:0] lsu_paddr_i,  // physical address in
    input logic [CVA6Cfg.VLEN-1:0] lsu_vaddr_i,  // virtual address in, for tval only
    input exception_t lsu_exception_i,  // lsu exception coming from MMU, or misaligned exception
    input logic lsu_is_store_i,  // the translation is requested by a store
    output logic lsu_valid_o,  // translation is valid
    output logic [CVA6Cfg.PLEN-1:0] lsu_paddr_o,  // translated address
    output exception_t lsu_exception_o,  // address translation threw an exception
    // General control signals
    input riscv::priv_lvl_t priv_lvl_i,
    input logic v_i,
    input riscv::priv_lvl_t ld_st_priv_lvl_i,
    input logic ld_st_v_i,
    // PMP
    input riscv::pmpcfg_t [avoid_neg(CVA6Cfg.NrPMPEntries-1):0] pmpcfg_i,
    input logic [avoid_neg(CVA6Cfg.NrPMPEntries-1):0][CVA6Cfg.PLEN-3:0] pmpaddr_i
);
  // virtual address causing the exception
  logic [CVA6Cfg.XLEN-1:0] fetch_vaddr_xlen, lsu_vaddr_xlen;

  logic pmp_if_allow;
  logic match_any_execute_region;
  logic data_allow_o;

  // Wires to PMP checks
  riscv::pmp_access_t pmp_access_type;

  logic no_locked_data, no_locked_if;

  // For exception tval reporting, use the virtual address and resize it
  if (CVA6Cfg.VLEN >= CVA6Cfg.XLEN) begin
    assign lsu_vaddr_xlen   = lsu_vaddr_i[CVA6Cfg.XLEN-1:0];
    assign fetch_vaddr_xlen = icache_fetch_vaddr_i[CVA6Cfg.XLEN-1:0];
  end else begin
    assign lsu_vaddr_xlen   = CVA6Cfg.XLEN'(lsu_vaddr_i);
    assign fetch_vaddr_xlen = CVA6Cfg.XLEN'(icache_fetch_vaddr_i);
  end

  //-----------------------
  // Instruction Interface
  //-----------------------

  // check for execute flag on memory
  assign match_any_execute_region = config_pkg::is_inside_execute_regions(
      CVA6Cfg, {{64 - CVA6Cfg.PLEN{1'b0}}, icache_areq_i.fetch_paddr}
  );

  // As the PMP check is combinatorial, pass the icache_areq directly if no
  // exception
  always_comb begin : instr_interface
    icache_areq_o.fetch_valid     = icache_areq_i.fetch_valid;
    icache_areq_o.fetch_paddr     = icache_areq_i.fetch_paddr;
    icache_areq_o.fetch_exception = icache_areq_i.fetch_exception;

    // if it didn't match any execute region throw an `Instruction Access Fault` (PMA)
    // or if PMP reject the access
    if (!match_any_execute_region || !pmp_if_allow) begin
      icache_areq_o.fetch_exception.cause = riscv::INSTR_ACCESS_FAULT;
      icache_areq_o.fetch_exception.valid = 1'b1;
      // For exception, the virtual address is required for tval, if no MMU is
      // instantiated then it will be equal to physical address
      if (CVA6Cfg.TvalEn) begin
        icache_areq_o.fetch_exception.tval = fetch_vaddr_xlen;
      end
      if (CVA6Cfg.RVH) begin
        icache_areq_o.fetch_exception.tval2 = '0;
        icache_areq_o.fetch_exception.tinst = '0;
        icache_areq_o.fetch_exception.gva   = v_i;
      end
    end
  end

  // Instruction fetch
  pmp #(
      .CVA6Cfg(CVA6Cfg)
  ) i_pmp_if (
      .addr_i       (icache_areq_i.fetch_paddr),
      .priv_lvl_i   (priv_lvl_i),
      // we will always execute on the instruction fetch port
      .access_type_i(riscv::ACCESS_EXEC),
      // Configuration
      .conf_addr_i  (pmpaddr_i),
      .conf_i       (pmpcfg_i),
      .allow_o      (pmp_if_allow)
  );

  //-----------------------
  // Data Interface
  //-----------------------
  always_comb begin : data_interface
    // save request and DTLB response
    lsu_valid_o     = lsu_valid_i;
    lsu_paddr_o     = lsu_paddr_i;
    lsu_exception_o = lsu_exception_i;
    pmp_access_type = lsu_is_store_i ? riscv::ACCESS_WRITE : riscv::ACCESS_READ;

    // If translation is not enabled, check the paddr immediately against PMPs
    if (lsu_valid_i && !data_allow_o) begin
      lsu_exception_o.valid = 1'b1;

      if (CVA6Cfg.TvalEn) begin
        lsu_exception_o.tval = lsu_vaddr_xlen;
      end

      if (lsu_is_store_i) begin
        lsu_exception_o.cause = riscv::ST_ACCESS_FAULT;
      end else begin
        lsu_exception_o.cause = riscv::LD_ACCESS_FAULT;
      end
      if (CVA6Cfg.RVH) begin
        lsu_exception_o.tval2 = '0;
        lsu_exception_o.tinst = '0;
        lsu_exception_o.gva   = ld_st_v_i;
      end
    end
  end

  // Load/store PMP check
  pmp #(
      .CVA6Cfg(CVA6Cfg)
  ) i_pmp_data (
      .addr_i       (lsu_paddr_i),
      .priv_lvl_i   (ld_st_priv_lvl_i),
      .access_type_i(pmp_access_type),
      // Configuration
      .conf_addr_i  (pmpaddr_i),
      .conf_i       (pmpcfg_i),
      .allow_o      (data_allow_o)
  );

  // ----------------
  // Assert for PMPs
  // ----------------

  // synthesis translate_off
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      no_locked_data <= 1'b0;
    end else begin
      if (ld_st_priv_lvl_i == riscv::PRIV_LVL_M) begin
        no_locked_data <= 1'b1;
        for (int i = 0; i < CVA6Cfg.NrPMPEntries; i++) begin
          if (pmpcfg_i[i].locked && pmpcfg_i[i].addr_mode != riscv::OFF) begin
            no_locked_data <= no_locked_data & 1'b0;
          end else no_locked_data <= no_locked_data & 1'b1;
        end
        if (no_locked_data == 1'b1) assert (data_allow_o == 1'b1);
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      no_locked_if <= 1'b0;
    end else begin
      if (priv_lvl_i == riscv::PRIV_LVL_M) begin
        no_locked_if <= 1'b1;
        for (int i = 0; i < CVA6Cfg.NrPMPEntries; i++) begin
          if (pmpcfg_i[i].locked && pmpcfg_i[i].addr_mode != riscv::OFF) begin
            no_locked_if <= no_locked_if & 1'b0;
          end else no_locked_if <= no_locked_if & 1'b1;
        end
        if (no_locked_if == 1'b1) assert (pmp_if_allow == 1'b1);
      end
    end
  end
  // synthesis translate_on
endmodule
