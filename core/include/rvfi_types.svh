`ifndef RVFI_TYPES_SVH
`define RVFI_TYPES_SVH

// RVFI
`define RVFI_INSTR_T(Cfg) struct packed { \
  logic [config_pkg::NRET-1:0]                  valid; \
  logic [config_pkg::NRET*64-1:0]               order; \
  logic [config_pkg::NRET*config_pkg::ILEN-1:0] insn; \
  logic [config_pkg::NRET-1:0]                  trap; \
  logic [config_pkg::NRET*Cfg.XLEN-1:0]        cause; \
  logic [config_pkg::NRET-1:0]                  halt; \
  logic [config_pkg::NRET*Cfg.XLEN-1:0]         intr; \
  logic [config_pkg::NRET*2-1:0]                mode; \
  logic [config_pkg::NRET*2-1:0]                ixl; \
  logic [config_pkg::NRET*5-1:0]                rs1_addr; \
  logic [config_pkg::NRET*5-1:0]                rs2_addr; \
  logic [config_pkg::NRET*Cfg.XLEN-1:0]      rs1_rdata; \
  logic [config_pkg::NRET*Cfg.XLEN-1:0]      rs2_rdata; \
  logic [config_pkg::NRET*5-1:0]                rd_addr; \
  logic [config_pkg::NRET*Cfg.XLEN-1:0]      rd_wdata; \
  logic [config_pkg::NRET*Cfg.XLEN-1:0]      pc_rdata; \
  logic [config_pkg::NRET*Cfg.XLEN-1:0]      pc_wdata; \
  logic [config_pkg::NRET*Cfg.VLEN-1:0]      mem_addr; \
  logic [config_pkg::NRET*Cfg.PLEN-1:0]      mem_paddr; \
  logic [config_pkg::NRET*(Cfg.XLEN/8)-1:0]  mem_rmask; \
  logic [config_pkg::NRET*(Cfg.XLEN/8)-1:0]  mem_wmask; \
  logic [config_pkg::NRET*Cfg.XLEN-1:0]      mem_rdata; \
  logic [config_pkg::NRET*Cfg.XLEN-1:0]      mem_wdata; \
}

`define RVFI_CSR_ELMT_T(Cfg) struct packed { \
  logic [Cfg.XLEN-1:0] rdata; \
  logic [Cfg.XLEN-1:0] rmask; \
  logic [Cfg.XLEN-1:0] wdata; \
  logic [Cfg.XLEN-1:0] wmask; \
}

`define RVFI_CSR_T(Cfg, rvfi_csr_elmt_t) struct packed { \
  rvfi_csr_elmt_t fflags; \
  rvfi_csr_elmt_t frm; \
  rvfi_csr_elmt_t fcsr; \
  rvfi_csr_elmt_t jvt; \
  rvfi_csr_elmt_t ftran; \
  rvfi_csr_elmt_t dcsr; \
  rvfi_csr_elmt_t dpc; \
  rvfi_csr_elmt_t dscratch0; \
  rvfi_csr_elmt_t dscratch1; \
  rvfi_csr_elmt_t sstatus; \
  rvfi_csr_elmt_t sie; \
  rvfi_csr_elmt_t sip; \
  rvfi_csr_elmt_t stvec; \
  rvfi_csr_elmt_t scounteren; \
  rvfi_csr_elmt_t sscratch; \
  rvfi_csr_elmt_t sepc; \
  rvfi_csr_elmt_t scause; \
  rvfi_csr_elmt_t stval; \
  rvfi_csr_elmt_t satp; \
  rvfi_csr_elmt_t mstatus; \
  rvfi_csr_elmt_t mstatush; \
  rvfi_csr_elmt_t misa; \
  rvfi_csr_elmt_t medeleg; \
  rvfi_csr_elmt_t mideleg; \
  rvfi_csr_elmt_t mie; \
  rvfi_csr_elmt_t mtvec; \
  rvfi_csr_elmt_t mcounteren; \
  rvfi_csr_elmt_t mscratch; \
  rvfi_csr_elmt_t mepc; \
  rvfi_csr_elmt_t mcause; \
  rvfi_csr_elmt_t mtval; \
  rvfi_csr_elmt_t mip; \
  rvfi_csr_elmt_t menvcfg; \
  rvfi_csr_elmt_t menvcfgh; \
  rvfi_csr_elmt_t mvendorid; \
  rvfi_csr_elmt_t marchid; \
  rvfi_csr_elmt_t mhartid; \
  rvfi_csr_elmt_t mcountinhibit; \
  rvfi_csr_elmt_t mcycle; \
  rvfi_csr_elmt_t mcycleh; \
  rvfi_csr_elmt_t minstret; \
  rvfi_csr_elmt_t minstreth; \
  rvfi_csr_elmt_t cycle; \
  rvfi_csr_elmt_t cycleh; \
  rvfi_csr_elmt_t instret; \
  rvfi_csr_elmt_t instreth; \
  rvfi_csr_elmt_t dcache; \
  rvfi_csr_elmt_t icache; \
  rvfi_csr_elmt_t acc_cons; \
  rvfi_csr_elmt_t pmpcfg0; \
  rvfi_csr_elmt_t pmpcfg1; \
  rvfi_csr_elmt_t pmpcfg2; \
  rvfi_csr_elmt_t pmpcfg3; \
  rvfi_csr_elmt_t [15:0] pmpaddr; \
}

// RVFI PROBES
`define RVFI_PROBES_INSTR_T(Cfg) struct packed { \
  logic [Cfg.NrIssuePorts-1:0][Cfg.TRANS_ID_BITS-1:0] issue_pointer; \
  logic [Cfg.NrCommitPorts-1:0][Cfg.TRANS_ID_BITS-1:0] commit_pointer; \
  logic flush_unissued_instr; \
  logic [Cfg.NrIssuePorts-1:0] decoded_instr_valid; \
  logic [Cfg.NrIssuePorts-1:0] decoded_instr_ack; \
  logic flush; \
  logic [Cfg.NrIssuePorts-1:0] issue_instr_ack; \
  logic [Cfg.NrIssuePorts-1:0] fetch_entry_valid; \
  logic [Cfg.NrIssuePorts-1:0][31:0] instruction; \
  logic [Cfg.NrIssuePorts-1:0] is_compressed; \
  logic [Cfg.NrIssuePorts-1:0][Cfg.XLEN-1:0] rs1; \
  logic [Cfg.NrIssuePorts-1:0][Cfg.XLEN-1:0] rs2; \
  logic [Cfg.NrCommitPorts-1:0][Cfg.VLEN-1:0] commit_instr_pc; \
  ariane_pkg::fu_op [Cfg.NrCommitPorts-1:0] commit_instr_op; \
  logic [Cfg.NrCommitPorts-1:0][ariane_pkg::REG_ADDR_SIZE-1:0] commit_instr_rs1; \
  logic [Cfg.NrCommitPorts-1:0][ariane_pkg::REG_ADDR_SIZE-1:0] commit_instr_rs2; \
  logic [Cfg.NrCommitPorts-1:0][ariane_pkg::REG_ADDR_SIZE-1:0] commit_instr_rd; \
  logic [Cfg.NrCommitPorts-1:0][Cfg.XLEN-1:0] commit_instr_result; \
  logic [Cfg.NrCommitPorts-1:0] commit_instr_valid; \
  logic [Cfg.NrCommitPorts-1:0] commit_drop; \
  logic [Cfg.XLEN-1:0] ex_commit_cause; \
  logic ex_commit_valid; \
  riscv::priv_lvl_t priv_lvl; \
  logic [Cfg.VLEN-1:0] lsu_ctrl_vaddr; \
  ariane_pkg::fu_t lsu_ctrl_fu; \
  logic [(Cfg.XLEN/8)-1:0] lsu_ctrl_be; \
  logic [Cfg.TRANS_ID_BITS-1:0] lsu_ctrl_trans_id; \
  logic [Cfg.NrWbPorts-1:0][Cfg.XLEN-1:0] wbdata; \
  logic [Cfg.NrCommitPorts-1:0] commit_ack; \
  logic [Cfg.PLEN-1:0] mem_paddr; \
  logic debug_mode; \
  logic [Cfg.NrCommitPorts-1:0][Cfg.XLEN-1:0] wdata; \
}

`define RVFI_PROBES_CSR_T(Cfg) struct packed { \
  riscv::fcsr_t fcsr_q; \
  riscv::dcsr_t dcsr_q; \
  logic [Cfg.XLEN-1:0] jvt_q; \
  logic [Cfg.XLEN-1:0] dpc_q; \
  logic [Cfg.XLEN-1:0] dscratch0_q; \
  logic [Cfg.XLEN-1:0] dscratch1_q; \
  logic [Cfg.XLEN-1:0] mie_q; \
  logic [Cfg.XLEN-1:0] mip_q; \
  logic [Cfg.XLEN-1:0] stvec_q; \
  logic [Cfg.XLEN-1:0] scounteren_q; \
  logic [Cfg.XLEN-1:0] sscratch_q; \
  logic [Cfg.XLEN-1:0] sepc_q; \
  logic [Cfg.XLEN-1:0] scause_q; \
  logic [Cfg.XLEN-1:0] stval_q; \
  logic [Cfg.XLEN-1:0] satp_q; \
  logic [Cfg.XLEN-1:0] mstatus_extended; \
  logic [Cfg.XLEN-1:0] medeleg_q; \
  logic [Cfg.XLEN-1:0] mideleg_q; \
  logic [Cfg.XLEN-1:0] mtvec_q; \
  logic [Cfg.XLEN-1:0] mcounteren_q; \
  logic [Cfg.XLEN-1:0] mscratch_q; \
  logic [Cfg.XLEN-1:0] mepc_q; \
  logic [Cfg.XLEN-1:0] mcause_q; \
  logic [Cfg.XLEN-1:0] mtval_q; \
  logic fiom_q; \
  logic [ariane_pkg::MHPMCounterNum+3-1:0] mcountinhibit_q; \
  logic [63:0] cycle_q; \
  logic [63:0] instret_q; \
  logic [Cfg.XLEN-1:0] dcache_q; \
  logic [Cfg.XLEN-1:0] icache_q; \
  logic [Cfg.XLEN-1:0] acc_cons_q; \
  riscv::pmpcfg_t [63:0] pmpcfg_q; \
  logic [63:0][Cfg.PLEN-3:0] pmpaddr_q; \
}

`endif  // RVFI_TYPES_SVH
