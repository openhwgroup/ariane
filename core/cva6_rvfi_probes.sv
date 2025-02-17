// Copyright 2024 Thales DIS France SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Yannick Casamatta - Thales
// Date: 09/01/2024


module cva6_rvfi_probes
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type exception_t = logic,
    parameter type scoreboard_entry_t = logic,
    parameter type lsu_ctrl_t = logic,
    parameter type rvfi_probes_instr_t = logic,
    parameter type rvfi_probes_csr_t = logic,
    parameter type rvfi_probes_t = logic

) (

    input logic                                  flush_i,
    input logic [CVA6Cfg.NrIssuePorts-1:0]       issue_instr_ack_i,
    input logic [CVA6Cfg.NrIssuePorts-1:0]       fetch_entry_valid_i,
    input logic [CVA6Cfg.NrIssuePorts-1:0][31:0] instruction_i,
    input logic [CVA6Cfg.NrIssuePorts-1:0]       is_compressed_i,

    input logic [CVA6Cfg.NrIssuePorts-1 : 0][CVA6Cfg.TRANS_ID_BITS-1:0] issue_pointer_i,
    input logic [ CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.TRANS_ID_BITS-1:0] commit_pointer_i,

    input logic flush_unissued_instr_i,
    input logic [CVA6Cfg.NrIssuePorts-1:0] decoded_instr_valid_i,
    input logic [CVA6Cfg.NrIssuePorts-1:0] decoded_instr_ack_i,

    input logic [CVA6Cfg.NrIssuePorts-1:0][CVA6Cfg.XLEN-1:0] rs1_i,
    input logic [CVA6Cfg.NrIssuePorts-1:0][CVA6Cfg.XLEN-1:0] rs2_i,

    input scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr_i,
    input logic [CVA6Cfg.NrCommitPorts-1:0] commit_drop_i,
    input exception_t ex_commit_i,
    input riscv::priv_lvl_t priv_lvl_i,

    input lsu_ctrl_t                                               lsu_ctrl_i,
    input logic      [    CVA6Cfg.NrWbPorts-1:0][CVA6Cfg.XLEN-1:0] wbdata_i,
    input logic      [CVA6Cfg.NrCommitPorts-1:0]                   commit_ack_i,
    input logic      [         CVA6Cfg.PLEN-1:0]                   mem_paddr_i,
    input logic                                                    debug_mode_i,
    input logic      [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.XLEN-1:0] wdata_i,

    input rvfi_probes_csr_t csr_i,
    input logic [1:0] irq_i,

    output rvfi_probes_t rvfi_probes_o
);


  rvfi_probes_csr_t   csr;
  rvfi_probes_instr_t instr;

  always_comb begin
    csr = '0;
    instr = '0;

    instr.flush = flush_i;
    instr.issue_instr_ack = issue_instr_ack_i;
    instr.fetch_entry_valid = fetch_entry_valid_i;
    instr.instruction = instruction_i;
    instr.is_compressed = is_compressed_i;

    instr.issue_pointer = issue_pointer_i;

    instr.flush_unissued_instr = flush_unissued_instr_i;
    instr.decoded_instr_valid = decoded_instr_valid_i;
    instr.decoded_instr_ack = decoded_instr_ack_i;

    instr.rs1 = rs1_i;
    instr.rs2 = rs2_i;

    instr.ex_commit_cause = ex_commit_i.cause;
    instr.ex_commit_valid = ex_commit_i.valid;

    instr.priv_lvl = priv_lvl_i;

    instr.lsu_ctrl_vaddr = lsu_ctrl_i.vaddr;
    instr.lsu_ctrl_fu = lsu_ctrl_i.fu;
    instr.lsu_ctrl_be = lsu_ctrl_i.be;
    instr.lsu_ctrl_trans_id = lsu_ctrl_i.trans_id;

    instr.wbdata = wbdata_i;
    instr.mem_paddr = mem_paddr_i;
    instr.debug_mode = debug_mode_i;

    instr.commit_pointer = commit_pointer_i;

    for (int i = 0; i < CVA6Cfg.NrCommitPorts; i++) begin
      instr.commit_instr_pc[i] = commit_instr_i[i].pc;
      instr.commit_instr_op[i] = commit_instr_i[i].op;
      instr.commit_instr_rs1[i] = commit_instr_i[i].rs1;
      instr.commit_instr_rs2[i] = commit_instr_i[i].rs2;
      instr.commit_instr_rd[i] = commit_instr_i[i].rd;
      instr.commit_instr_result[i] = commit_instr_i[i].result;
      instr.commit_instr_valid[i] = commit_instr_i[i].valid;
    end

    instr.commit_drop = commit_drop_i;
    instr.commit_ack = commit_ack_i;
    instr.wdata = wdata_i;

    csr = csr_i;
    csr.mip_q = csr_i.mip_q | ({{CVA6Cfg.XLEN - 1{1'b0}}, CVA6Cfg.RVS && irq_i[1]} << riscv::IRQ_S_EXT);

  end


  always_comb begin
    rvfi_probes_o = '0;

    if ($bits(rvfi_probes_o.instr) == $bits(instr)) begin
      rvfi_probes_o.instr = instr;
    end

    if ($bits(rvfi_probes_o.csr) == $bits(csr)) begin
      rvfi_probes_o.csr = csr;
    end

  end


endmodule

