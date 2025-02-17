// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// File:   issue_read_operands.sv
// Author: Florian Zaruba <zarubaf@ethz.ch>
// Date:   8.4.2017
//
// Copyright (C) 2017 ETH Zurich, University of Bologna
// All rights reserved.
//
// Description: Issues instruction from the scoreboard and fetches the operands
//              This also includes all the forwarding logic
//

module decoder
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type branchpredict_sbe_t = logic,
    parameter type exception_t = logic,
    parameter type irq_ctrl_t = logic,
    parameter type scoreboard_entry_t = logic,
    parameter type interrupts_t = logic,
    parameter interrupts_t INTERRUPTS = '0
) (
    // Debug (async) request - SUBSYSTEM
    input logic debug_req_i,
    // PC from fetch stage - FRONTEND
    input logic [CVA6Cfg.VLEN-1:0] pc_i,
    // Is a compressed instruction - compressed_decoder
    input logic is_compressed_i,
    // Compressed form of instruction - FRONTEND
    input logic [15:0] compressed_instr_i,
    // Illegal compressed instruction - compressed_decoder
    input logic is_illegal_i,
    // Instruction from fetch stage - FRONTEND
    input logic [31:0] instruction_i,
    // Is a macro instruction - macro_decoder
    input logic is_macro_instr_i,
    // Is a last macro instruction - macro_decoder
    input logic is_last_macro_instr_i,
    // Is mvsa01/mva01s macro instruction - macro_decoder
    input logic is_double_rd_macro_instr_i,
    // Zcmt instruction - FRONTEND
    input logic is_zcmt_i,
    // Jump address - zcmt_decoder
    input logic [CVA6Cfg.XLEN-1:0] jump_address_i,
    // Is a branch predict instruction - FRONTEND
    input branchpredict_sbe_t branch_predict_i,
    // If an exception occured in fetch stage - FRONTEND
    input exception_t ex_i,
    // Level sensitive (async) interrupts - SUBSYSTEM
    input logic [1:0] irq_i,
    // Interrupt control status - CSR_REGFILE
    input irq_ctrl_t irq_ctrl_i,
    // Current privilege level - CSR_REGFILE
    input riscv::priv_lvl_t priv_lvl_i,
    // Current virtualization mode - CSR_REGFILE
    input logic v_i,
    // Is debug mode - CSR_REGFILE
    input logic debug_mode_i,
    // Floating point extension status - CSR_REGFILE
    input riscv::xs_t fs_i,
    // Virtual floating point extension status - CSR_REGFILE
    input riscv::xs_t vfs_i,
    // Floating-point dynamic rounding mode - CSR_REGFILE
    input logic [2:0] frm_i,
    // Vector extension status - CSR_REGFILE
    input riscv::xs_t vs_i,
    // Trap virtual memory - CSR_REGFILE
    input logic tvm_i,
    // Timeout wait - CSR_REGFILE
    input logic tw_i,
    // Virtual timeout wait - CSR_REGFILE
    input logic vtw_i,
    // Trap sret - CSR_REGFILE
    input logic tsr_i,
    // Hypervisor user mode - CSR_REGFILE
    input logic hu_i,
    // Instruction to be added to scoreboard entry - ISSUE_STAGE
    output scoreboard_entry_t instruction_o,
    // Instruction - ISSUE_STAGE
    output logic [31:0] orig_instr_o,
    // Is a control flow instruction - ISSUE_STAGE
    output logic is_control_flow_instr_o
);
  logic illegal_instr;
  logic illegal_instr_bm;
  logic illegal_instr_zic;
  logic illegal_instr_non_bm;
  logic virtual_illegal_instr;
  // this instruction is an environment call (ecall), it is handled like an exception
  logic ecall;
  // this instruction is a software break-point
  logic ebreak;
  // this instruction needs floating-point rounding-mode verification
  logic check_fprm;
  riscv::instruction_t instr;
  assign instr = riscv::instruction_t'(instruction_i);
  // transformed instruction
  logic [31:0] tinst;
  // --------------------
  // Immediate select
  // --------------------
  enum logic [3:0] {
    NOIMM,
    IIMM,
    SIMM,
    SBIMM,
    UIMM,
    JIMM,
    RS3,
    MUX_RD_RS3
  } imm_select;

  logic [CVA6Cfg.XLEN-1:0] imm_i_type;
  logic [CVA6Cfg.XLEN-1:0] imm_s_type;
  logic [CVA6Cfg.XLEN-1:0] imm_sb_type;
  logic [CVA6Cfg.XLEN-1:0] imm_u_type;
  logic [CVA6Cfg.XLEN-1:0] imm_uj_type;

  // ---------------------------------------
  // Accelerator instructions' first-pass decoder
  // ---------------------------------------
  logic is_accel;
  scoreboard_entry_t acc_instruction;
  logic acc_illegal_instr;
  logic acc_is_control_flow_instr;

  if (CVA6Cfg.EnableAccelerator) begin : gen_accel_decoder
    // This module is responsible for a light-weight decoding of accelerator instructions,
    // identifying them, but also whether they read/write scalar registers.
    // Accelerators are supposed to define this module.
    cva6_accel_first_pass_decoder #(
        .CVA6Cfg(CVA6Cfg),
        .scoreboard_entry_t(scoreboard_entry_t)
    ) i_accel_decoder (
        .instruction_i(instruction_i),
        .fs_i(fs_i),
        .vs_i(vs_i),
        .is_accel_o(is_accel),
        .instruction_o(acc_instruction),
        .illegal_instr_o(acc_illegal_instr),
        .is_control_flow_instr_o(acc_is_control_flow_instr)
    );
  end : gen_accel_decoder
  else begin
    assign is_accel                  = 1'b0;
    assign acc_instruction           = '0;
    assign acc_illegal_instr         = 1'b1;  // this should never propagate
    assign acc_is_control_flow_instr = 1'b0;
  end

  always_comb begin : decoder

    imm_select                             = NOIMM;
    is_control_flow_instr_o                = 1'b0;
    illegal_instr                          = 1'b0;
    illegal_instr_non_bm                   = 1'b0;
    illegal_instr_bm                       = 1'b0;
    illegal_instr_zic                      = 1'b0;
    virtual_illegal_instr                  = 1'b0;
    instruction_o.pc                       = pc_i;
    instruction_o.trans_id                 = '0;
    instruction_o.fu                       = NONE;
    instruction_o.op                       = ariane_pkg::ADD;
    instruction_o.rs1                      = '0;
    instruction_o.rs2                      = '0;
    instruction_o.rd                       = '0;
    instruction_o.use_pc                   = 1'b0;
    instruction_o.is_compressed            = is_compressed_i;
    instruction_o.is_macro_instr           = is_macro_instr_i;
    instruction_o.is_last_macro_instr      = is_last_macro_instr_i;
    instruction_o.is_double_rd_macro_instr = is_double_rd_macro_instr_i;
    instruction_o.use_zimm                 = 1'b0;
    instruction_o.bp                       = branch_predict_i;
    instruction_o.vfp                      = 1'b0;
    instruction_o.is_zcmt                  = is_zcmt_i;
    ecall                                  = 1'b0;
    ebreak                                 = 1'b0;
    check_fprm                             = 1'b0;

    if (~ex_i.valid) begin
      case (instr.rtype.opcode)
        riscv::OpcodeSystem: begin
          instruction_o.fu = CSR;
          instruction_o.rs1 = instr.itype.rs1;
          instruction_o.rs2 = instr.rtype.rs2;   //TODO: needs to be checked if better way is available
          instruction_o.rd = instr.itype.rd;

          unique case (instr.itype.funct3)
            3'b000: begin
              // check if the RD and and RS1 fields are zero, this may be reset for the SENCE.VMA instruction
              if (instr.itype.rs1 != '0 || instr.itype.rd != '0) begin
                if (CVA6Cfg.RVH && v_i) begin
                  virtual_illegal_instr = 1'b1;
                end else begin
                  illegal_instr = 1'b1;
                end
              end
              // decode the immiediate field
              case (instr.itype.imm)
                // ECALL -> inject exception
                12'b0: ecall = 1'b1;
                // EBREAK -> inject exception
                12'b1: ebreak = 1'b1;
                // SRET
                12'b1_0000_0010: begin
                  if (CVA6Cfg.RVS) begin
                    instruction_o.op = ariane_pkg::SRET;
                    // check privilege level, SRET can only be executed in S and M mode
                    // we'll just decode an illegal instruction if we are in the wrong privilege level
                    if (CVA6Cfg.RVU && priv_lvl_i == riscv::PRIV_LVL_U) begin
                      if (CVA6Cfg.RVH && v_i) begin
                        virtual_illegal_instr = 1'b1;
                      end else begin
                        illegal_instr = 1'b1;
                      end
                      //  do not change privilege level if this is an illegal instruction
                      instruction_o.op = ariane_pkg::ADD;
                    end
                    // if we are in S-Mode and Trap SRET (tsr) is set -> trap on illegal instruction
                    if (priv_lvl_i == riscv::PRIV_LVL_S && tsr_i) begin
                      if (CVA6Cfg.RVH && v_i) begin
                        virtual_illegal_instr = 1'b1;
                      end else begin
                        illegal_instr = 1'b1;
                      end
                      //  do not change privilege level if this is an illegal instruction
                      instruction_o.op = ariane_pkg::ADD;
                    end
                  end else begin
                    illegal_instr = 1'b1;
                    instruction_o.op = ariane_pkg::ADD;
                  end
                end
                // MRET
                12'b11_0000_0010: begin
                  instruction_o.op = ariane_pkg::MRET;
                  // check privilege level, MRET can only be executed in M mode
                  // otherwise we decode an illegal instruction
                  if ((CVA6Cfg.RVS && priv_lvl_i == riscv::PRIV_LVL_S) || (CVA6Cfg.RVU && priv_lvl_i == riscv::PRIV_LVL_U))
                    illegal_instr = 1'b1;
                end
                // DRET
                12'b111_1011_0010: begin
                  instruction_o.op = ariane_pkg::DRET;
                  if (CVA6Cfg.DebugEn) begin
                    // check that we are in debug mode when executing this instruction
                    illegal_instr = (!debug_mode_i) ? 1'b1 : illegal_instr;
                  end else begin
                    illegal_instr = 1'b1;
                  end
                end
                // WFI
                12'b1_0000_0101: begin
                  instruction_o.op = ariane_pkg::WFI;
                  // if timeout wait is set, trap on an illegal instruction in S Mode
                  // (after 0 cycles timeout)
                  if (CVA6Cfg.RVS && priv_lvl_i == riscv::PRIV_LVL_S && tw_i) begin
                    illegal_instr = 1'b1;
                    instruction_o.op = ariane_pkg::ADD;
                  end
                  if (CVA6Cfg.RVH && priv_lvl_i == riscv::PRIV_LVL_S && v_i && vtw_i && !tw_i) begin
                    virtual_illegal_instr = 1'b1;
                    instruction_o.op = ariane_pkg::ADD;
                  end
                  // we don't support U mode interrupts so WFI is illegal in this context
                  if (CVA6Cfg.RVU && priv_lvl_i == riscv::PRIV_LVL_U) begin
                    if (CVA6Cfg.RVH && v_i) virtual_illegal_instr = 1'b1;
                    else illegal_instr = 1'b1;
                    instruction_o.op = ariane_pkg::ADD;
                  end
                end
                // SFENCE.VMA
                default: begin
                  if (instr.instr[31:25] == 7'b1001) begin
                    // check privilege level, SFENCE.VMA can only be executed in M/S mode
                    // only if S mode is supported
                    // otherwise decode an illegal instruction
                    if (CVA6Cfg.RVH && v_i) begin
                      virtual_illegal_instr = (priv_lvl_i == riscv::PRIV_LVL_S) ? 1'b0 : 1'b1;
                    end else begin
                      illegal_instr    = (CVA6Cfg.RVS && (priv_lvl_i inside {riscv::PRIV_LVL_M, riscv::PRIV_LVL_S}) && instr.itype.rd == '0) ? 1'b0 : 1'b1;
                    end
                    instruction_o.op = ariane_pkg::SFENCE_VMA;
                    // check TVM flag and intercept SFENCE.VMA call if necessary
                    if (CVA6Cfg.RVS && priv_lvl_i == riscv::PRIV_LVL_S && tvm_i) begin
                      if (CVA6Cfg.RVH && v_i) virtual_illegal_instr = 1'b1;
                      else illegal_instr = 1'b1;
                    end
                  end else if (CVA6Cfg.RVH) begin
                    if (instr.instr[31:25] == 7'b10001) begin
                      // check privilege level, HFENCE.VVMA can only be executed in M/S mode
                      // otherwise decode an illegal instruction or virtual illegal instruction
                      if (v_i) begin
                        virtual_illegal_instr = 1'b1;
                      end else begin
                        illegal_instr    = (priv_lvl_i inside {riscv::PRIV_LVL_M, riscv::PRIV_LVL_S}) ? 1'b0 : 1'b1;
                      end
                      instruction_o.op = ariane_pkg::HFENCE_VVMA;
                    end else if (instr.instr[31:25] == 7'b110001) begin
                      // check privilege level, HFENCE.GVMA can only be executed in M/S mode
                      // otherwise decode an illegal instruction or virtual illegal instruction
                      if (v_i) begin
                        virtual_illegal_instr = 1'b1;
                      end else begin
                        illegal_instr    = (priv_lvl_i inside {riscv::PRIV_LVL_M, riscv::PRIV_LVL_S}) ? 1'b0 : 1'b1;
                      end
                      instruction_o.op = ariane_pkg::HFENCE_GVMA;
                      // check TVM flag and intercept HFENCE.GVMA call if necessary
                      if (priv_lvl_i == riscv::PRIV_LVL_S && !v_i && tvm_i) illegal_instr = 1'b1;
                    end else begin
                      illegal_instr = 1'b1;
                    end
                  end else begin
                    illegal_instr = 1'b1;
                  end
                end
              endcase
            end
            3'b100: begin
              // Hypervisor load/store instructions
              if (CVA6Cfg.RVH) begin
                if (instr.instr[25] != 1'b0) begin
                  instruction_o.fu = STORE;
                  imm_select = NOIMM;
                  instruction_o.rs1 = instr.stype.rs1;
                  instruction_o.rs2 = instr.stype.rs2;
                end else begin
                  instruction_o.fu = LOAD;
                  imm_select = NOIMM;
                  instruction_o.rs1 = instr.itype.rs1;
                  instruction_o.rd = instr.itype.rd;
                end

                // Hypervisor load/store instructions when V=1 cause virtual instruction
                if (v_i) virtual_illegal_instr = 1'b1;
                // Hypervisor load/store instructions in U-mode when hstatus.HU=0 cause an illegal instruction trap.
                else if (!hu_i && priv_lvl_i == riscv::PRIV_LVL_U) illegal_instr = 1'b1;
                unique case (instr.rtype.funct7)
                  7'b011_0000: begin
                    if (instr.rtype.rs2 == 5'b0) begin
                      instruction_o.op = ariane_pkg::HLV_B;
                    end
                    if (instr.rtype.rs2 == 5'b1) begin
                      instruction_o.op = ariane_pkg::HLV_BU;
                    end
                  end
                  7'b011_0010: begin
                    if (instr.rtype.rs2 == 5'b0) begin
                      instruction_o.op = ariane_pkg::HLV_H;
                    end
                    if (instr.rtype.rs2 == 5'b1) begin
                      instruction_o.op = ariane_pkg::HLV_HU;
                    end
                    if (instr.rtype.rs2 == 5'b11) begin
                      instruction_o.op = ariane_pkg::HLVX_HU;
                    end
                  end
                  7'b011_0100: begin
                    if (instr.rtype.rs2 == 5'b0) begin
                      instruction_o.op = ariane_pkg::HLV_W;
                    end
                    if (instr.rtype.rs2 == 5'b1) begin
                      instruction_o.op = ariane_pkg::HLV_WU;
                    end
                    if (instr.rtype.rs2 == 5'b11) begin
                      instruction_o.op = ariane_pkg::HLVX_WU;
                    end
                  end
                  7'b011_0001: instruction_o.op = ariane_pkg::HSV_B;
                  7'b011_0011: instruction_o.op = ariane_pkg::HSV_H;
                  7'b011_0101: instruction_o.op = ariane_pkg::HSV_W;
                  7'b011_0110: instruction_o.op = ariane_pkg::HLV_D;
                  7'b011_0111: instruction_o.op = ariane_pkg::HSV_D;
                  default: illegal_instr = 1'b1;

                endcase
                tinst = {
                  instr.rtype.funct7,
                  instr.rtype.rs2,
                  5'b0,
                  instr.rtype.funct3,
                  instr.rtype.rd,
                  instr.rtype.opcode
                };
              end else begin
                illegal_instr = 1'b1;
              end
            end
            // atomically swaps values in the CSR and integer register
            3'b001: begin  // CSRRW
              imm_select = IIMM;
              instruction_o.op = ariane_pkg::CSR_WRITE;
            end
            // atomically set values in the CSR and write back to rd
            3'b010: begin  // CSRRS
              imm_select = IIMM;
              // this is just a read
              if (instr.itype.rs1 == '0) instruction_o.op = ariane_pkg::CSR_READ;
              else instruction_o.op = ariane_pkg::CSR_SET;
            end
            // atomically clear values in the CSR and write back to rd
            3'b011: begin  // CSRRC
              imm_select = IIMM;
              // this is just a read
              if (instr.itype.rs1 == '0) instruction_o.op = ariane_pkg::CSR_READ;
              else instruction_o.op = ariane_pkg::CSR_CLEAR;
            end
            // use zimm and iimm
            3'b101: begin  // CSRRWI
              instruction_o.rs1 = instr.itype.rs1;
              imm_select = IIMM;
              instruction_o.use_zimm = 1'b1;
              instruction_o.op = ariane_pkg::CSR_WRITE;
            end
            3'b110: begin  // CSRRSI
              instruction_o.rs1 = instr.itype.rs1;
              imm_select = IIMM;
              instruction_o.use_zimm = 1'b1;
              // this is just a read
              if (instr.itype.rs1 == 5'b0) instruction_o.op = ariane_pkg::CSR_READ;
              else instruction_o.op = ariane_pkg::CSR_SET;
            end
            3'b111: begin  // CSRRCI
              instruction_o.rs1 = instr.itype.rs1;
              imm_select = IIMM;
              instruction_o.use_zimm = 1'b1;
              // this is just a read
              if (instr.itype.rs1 == '0) instruction_o.op = ariane_pkg::CSR_READ;
              else instruction_o.op = ariane_pkg::CSR_CLEAR;
            end
            default: illegal_instr = 1'b1;
          endcase
        end
        // Memory ordering instructions
        riscv::OpcodeMiscMem: begin
          instruction_o.fu  = CSR;
          instruction_o.rs1 = '0;
          instruction_o.rs2 = '0;
          instruction_o.rd  = '0;

          case (instr.stype.funct3)
            // FENCE
            // Currently implemented as a whole DCache flush boldly ignoring other things
            3'b000: instruction_o.op = ariane_pkg::FENCE;
            // FENCE.I
            3'b001: instruction_o.op = ariane_pkg::FENCE_I;

            default: illegal_instr = 1'b1;
          endcase
        end

        // --------------------------
        // Reg-Reg Operations
        // --------------------------
        riscv::OpcodeOp: begin
          // --------------------------------------------
          // Vectorial Floating-Point Reg-Reg Operations
          // --------------------------------------------
          if (instr.rvftype.funct2 == 2'b10) begin  // Prefix 10 for all Xfvec ops
            // only generate decoder if FP extensions are enabled (static)
            if (CVA6Cfg.FpPresent && CVA6Cfg.XFVec && fs_i != riscv::Off && ((CVA6Cfg.RVH && (!v_i || vfs_i != riscv::Off)) || !CVA6Cfg.RVH)) begin
              automatic logic allow_replication;  // control honoring of replication flag

              instruction_o.fu  = FPU_VEC;  // Same unit, but sets 'vectorial' signal
              instruction_o.rs1 = instr.rvftype.rs1;
              instruction_o.rs2 = instr.rvftype.rs2;
              instruction_o.rd  = instr.rvftype.rd;
              check_fprm        = 1'b1;
              allow_replication = 1'b1;
              // decode vectorial FP instruction
              unique case (instr.rvftype.vecfltop)
                5'b00001: begin
                  instruction_o.op  = ariane_pkg::FADD;  // vfadd.vfmt - Vectorial FP Addition
                  instruction_o.rs1 = '0;  // Operand A is set to 0
                  instruction_o.rs2 = instr.rvftype.rs1;  // Operand B is set to rs1
                  imm_select        = IIMM;  // Operand C is set to rs2
                end
                5'b00010: begin
                  instruction_o.op = ariane_pkg::FSUB;  // vfsub.vfmt - Vectorial FP Subtraction
                  instruction_o.rs1 = '0;  // Operand A is set to 0
                  instruction_o.rs2 = instr.rvftype.rs1;  // Operand B is set to rs1
                  imm_select = IIMM;  // Operand C is set to rs2
                end
                5'b00011:
                instruction_o.op = ariane_pkg::FMUL;  // vfmul.vfmt - Vectorial FP Multiplication
                5'b00100:
                instruction_o.op = ariane_pkg::FDIV;  // vfdiv.vfmt - Vectorial FP Division
                5'b00101: begin
                  instruction_o.op = ariane_pkg::VFMIN;  // vfmin.vfmt - Vectorial FP Minimum
                  check_fprm       = 1'b0;  // rounding mode irrelevant
                end
                5'b00110: begin
                  instruction_o.op = ariane_pkg::VFMAX;  // vfmax.vfmt - Vectorial FP Maximum
                  check_fprm       = 1'b0;  // rounding mode irrelevant
                end
                5'b00111: begin
                  instruction_o.op  = ariane_pkg::FSQRT;  // vfsqrt.vfmt - Vectorial FP Square Root
                  allow_replication = 1'b0;  // only one operand
                  if (instr.rvftype.rs2 != 5'b00000) illegal_instr = 1'b1;  // rs2 must be 0
                end
                5'b01000: begin
                  instruction_o.op = ariane_pkg::FMADD; // vfmac.vfmt - Vectorial FP Multiply-Accumulate
                  imm_select = SIMM;  // rd into result field (upper bits don't matter)
                end
                5'b01001: begin
                  instruction_o.op = ariane_pkg::FMSUB; // vfmre.vfmt - Vectorial FP Multiply-Reduce
                  imm_select = SIMM;  // rd into result field (upper bits don't matter)
                end
                5'b01100: begin
                  unique case (instr.rvftype.rs2) inside // operation encoded in rs2, `inside` for matching ?
                    5'b00000: begin
                      instruction_o.rs2 = instr.rvftype.rs1; // set rs2 = rs1 so we can map FMV to SGNJ in the unit
                      if (instr.rvftype.repl)
                        instruction_o.op = ariane_pkg::FMV_X2F;  // vfmv.vfmt.x - GPR to FPR Move
                      else instruction_o.op = ariane_pkg::FMV_F2X;  // vfmv.x.vfmt - FPR to GPR Move
                      check_fprm = 1'b0;  // no rounding for moves
                    end
                    5'b00001: begin
                      instruction_o.op  = ariane_pkg::FCLASS; // vfclass.vfmt - Vectorial FP Classify
                      check_fprm = 1'b0;  // no rounding for classification
                      allow_replication = 1'b0;  // R must not be set
                    end
                    5'b00010:
                    instruction_o.op = ariane_pkg::FCVT_F2I; // vfcvt.x.vfmt - Vectorial FP to Int Conversion
                    5'b00011:
                    instruction_o.op = ariane_pkg::FCVT_I2F; // vfcvt.vfmt.x - Vectorial Int to FP Conversion
                    5'b001??: begin
                      instruction_o.op       = ariane_pkg::FCVT_F2F; // vfcvt.vfmt.vfmt - Vectorial FP to FP Conversion
                      instruction_o.rs2 = instr.rvftype.rd; // set rs2 = rd as target vector for conversion
                      imm_select = IIMM;  // rs2 holds part of the intruction
                      // TODO CHECK R bit for valid fmt combinations
                      // determine source format
                      unique case (instr.rvftype.rs2[21:20])
                        // Only process instruction if corresponding extension is active (static)
                        2'b00:   if (~CVA6Cfg.RVFVec) illegal_instr = 1'b1;
                        2'b01:   if (~CVA6Cfg.XF16ALTVec) illegal_instr = 1'b1;
                        2'b10:   if (~CVA6Cfg.XF16Vec) illegal_instr = 1'b1;
                        2'b11:   if (~CVA6Cfg.XF8Vec) illegal_instr = 1'b1;
                        default: illegal_instr = 1'b1;
                      endcase
                    end
                    default: illegal_instr = 1'b1;
                  endcase
                end
                5'b01101: begin
                  check_fprm = 1'b0;  // no rounding for sign-injection
                  instruction_o.op = ariane_pkg::VFSGNJ; // vfsgnj.vfmt - Vectorial FP Sign Injection
                end
                5'b01110: begin
                  check_fprm = 1'b0;  // no rounding for sign-injection
                  instruction_o.op = ariane_pkg::VFSGNJN; // vfsgnjn.vfmt - Vectorial FP Negated Sign Injection
                end
                5'b01111: begin
                  check_fprm = 1'b0;  // no rounding for sign-injection
                  instruction_o.op = ariane_pkg::VFSGNJX; // vfsgnjx.vfmt - Vectorial FP XORed Sign Injection
                end
                5'b10000: begin
                  check_fprm       = 1'b0;  // no rounding for comparisons
                  instruction_o.op = ariane_pkg::VFEQ;  // vfeq.vfmt - Vectorial FP Equality
                end
                5'b10001: begin
                  check_fprm       = 1'b0;  // no rounding for comparisons
                  instruction_o.op = ariane_pkg::VFNE;  // vfne.vfmt - Vectorial FP Non-Equality
                end
                5'b10010: begin
                  check_fprm       = 1'b0;  // no rounding for comparisons
                  instruction_o.op = ariane_pkg::VFLT;  // vfle.vfmt - Vectorial FP Less Than
                end
                5'b10011: begin
                  check_fprm = 1'b0;  // no rounding for comparisons
                  instruction_o.op = ariane_pkg::VFGE;  // vfge.vfmt - Vectorial FP Greater or Equal
                end
                5'b10100: begin
                  check_fprm       = 1'b0;  // no rounding for comparisons
                  instruction_o.op = ariane_pkg::VFLE;  // vfle.vfmt - Vectorial FP Less or Equal
                end
                5'b10101: begin
                  check_fprm       = 1'b0;  // no rounding for comparisons
                  instruction_o.op = ariane_pkg::VFGT;  // vfgt.vfmt - Vectorial FP Greater Than
                end
                5'b11000: begin
                  instruction_o.op  = ariane_pkg::VFCPKAB_S; // vfcpka/b.vfmt.s - Vectorial FP Cast-and-Pack from 2x FP32, lowest 4 entries
                  imm_select = SIMM;  // rd into result field (upper bits don't matter)
                  if (~CVA6Cfg.RVF)
                    illegal_instr = 1'b1;  // if we don't support RVF, we can't cast from FP32
                  // check destination format
                  unique case (instr.rvftype.vfmt)
                    // Only process instruction if corresponding extension is active and FLEN suffices (static)
                    2'b00: begin
                      if (~CVA6Cfg.RVFVec)
                        illegal_instr = 1'b1;  // destination vector not supported
                      if (instr.rvftype.repl)
                        illegal_instr = 1'b1;  // no entries 2/3 in vector of 2 fp32
                    end
                    2'b01: begin
                      if (~CVA6Cfg.XF16ALTVec)
                        illegal_instr = 1'b1;  // destination vector not supported
                    end
                    2'b10: begin
                      if (~CVA6Cfg.XF16Vec)
                        illegal_instr = 1'b1;  // destination vector not supported
                    end
                    2'b11: begin
                      if (~CVA6Cfg.XF8Vec)
                        illegal_instr = 1'b1;  // destination vector not supported
                    end
                    default: illegal_instr = 1'b1;
                  endcase
                end
                5'b11001: begin
                  instruction_o.op  = ariane_pkg::VFCPKCD_S; // vfcpkc/d.vfmt.s - Vectorial FP Cast-and-Pack from 2x FP32, second 4 entries
                  imm_select = SIMM;  // rd into result field (upper bits don't matter)
                  if (~CVA6Cfg.RVF)
                    illegal_instr = 1'b1;  // if we don't support RVF, we can't cast from FP32
                  // check destination format
                  unique case (instr.rvftype.vfmt)
                    // Only process instruction if corresponding extension is active and FLEN suffices (static)
                    2'b00:   illegal_instr = 1'b1;  // no entries 4-7 in vector of 2 FP32
                    2'b01:   illegal_instr = 1'b1;  // no entries 4-7 in vector of 4 FP16ALT
                    2'b10:   illegal_instr = 1'b1;  // no entries 4-7 in vector of 4 FP16
                    2'b11: begin
                      if (~CVA6Cfg.XF8Vec)
                        illegal_instr = 1'b1;  // destination vector not supported
                    end
                    default: illegal_instr = 1'b1;
                  endcase
                end
                5'b11010: begin
                  instruction_o.op  = ariane_pkg::VFCPKAB_D; // vfcpka/b.vfmt.d - Vectorial FP Cast-and-Pack from 2x FP64, lowest 4 entries
                  imm_select = SIMM;  // rd into result field (upper bits don't matter)
                  if (~CVA6Cfg.RVD)
                    illegal_instr = 1'b1;  // if we don't support RVD, we can't cast from FP64
                  // check destination format
                  unique case (instr.rvftype.vfmt)
                    // Only process instruction if corresponding extension is active and FLEN suffices (static)
                    2'b00: begin
                      if (~CVA6Cfg.RVFVec)
                        illegal_instr = 1'b1;  // destination vector not supported
                      if (instr.rvftype.repl)
                        illegal_instr = 1'b1;  // no entries 2/3 in vector of 2 fp32
                    end
                    2'b01: begin
                      if (~CVA6Cfg.XF16ALTVec)
                        illegal_instr = 1'b1;  // destination vector not supported
                    end
                    2'b10: begin
                      if (~CVA6Cfg.XF16Vec)
                        illegal_instr = 1'b1;  // destination vector not supported
                    end
                    2'b11: begin
                      if (~CVA6Cfg.XF8Vec)
                        illegal_instr = 1'b1;  // destination vector not supported
                    end
                    default: illegal_instr = 1'b1;
                  endcase
                end
                5'b11011: begin
                  instruction_o.op  = ariane_pkg::VFCPKCD_D; // vfcpka/b.vfmt.d - Vectorial FP Cast-and-Pack from 2x FP64, second 4 entries
                  imm_select = SIMM;  // rd into result field (upper bits don't matter)
                  if (~CVA6Cfg.RVD)
                    illegal_instr = 1'b1;  // if we don't support RVD, we can't cast from FP64
                  // check destination format
                  unique case (instr.rvftype.vfmt)
                    // Only process instruction if corresponding extension is active and FLEN suffices (static)
                    2'b00:   illegal_instr = 1'b1;  // no entries 4-7 in vector of 2 FP32
                    2'b01:   illegal_instr = 1'b1;  // no entries 4-7 in vector of 4 FP16ALT
                    2'b10:   illegal_instr = 1'b1;  // no entries 4-7 in vector of 4 FP16
                    2'b11: begin
                      if (~CVA6Cfg.XF8Vec)
                        illegal_instr = 1'b1;  // destination vector not supported
                    end
                    default: illegal_instr = 1'b1;
                  endcase
                end
                default: illegal_instr = 1'b1;
              endcase

              // check format
              unique case (instr.rvftype.vfmt)
                // Only process instruction if corresponding extension is active (static)
                2'b00:   if (~CVA6Cfg.RVFVec) illegal_instr = 1'b1;
                2'b01:   if (~CVA6Cfg.XF16ALTVec) illegal_instr = 1'b1;
                2'b10:   if (~CVA6Cfg.XF16Vec) illegal_instr = 1'b1;
                2'b11:   if (~CVA6Cfg.XF8Vec) illegal_instr = 1'b1;
                default: illegal_instr = 1'b1;
              endcase

              // check disallowed replication
              if (~allow_replication & instr.rvftype.repl) illegal_instr = 1'b1;

              // check rounding mode
              if (check_fprm) begin
                unique case (frm_i) inside  // actual rounding mode from frm csr
                  [3'b000 : 3'b100]: ;  //legal rounding modes
                  default: illegal_instr = 1'b1;
                endcase
              end

            end else begin  // No vectorial FP enabled (static)
              illegal_instr = 1'b1;
            end

            // ---------------------------
            // Integer Reg-Reg Operations
            // ---------------------------
          end else begin
            if (CVA6Cfg.RVB) begin
              instruction_o.fu  = (instr.rtype.funct7 == 7'b000_0001 || ((instr.rtype.funct7 == 7'b000_0101) && !(instr.rtype.funct3[14]))) ? MULT : ALU;
            end else begin
              instruction_o.fu = (instr.rtype.funct7 == 7'b000_0001) ? MULT : ALU;
            end
            instruction_o.rs1 = instr.rtype.rs1;
            instruction_o.rs2 = instr.rtype.rs2;
            instruction_o.rd  = instr.rtype.rd;

            unique case ({
              instr.rtype.funct7, instr.rtype.funct3
            })
              {7'b000_0000, 3'b000} : instruction_o.op = ariane_pkg::ADD;  // Add
              {7'b010_0000, 3'b000} : instruction_o.op = ariane_pkg::SUB;  // Sub
              {7'b000_0000, 3'b010} : instruction_o.op = ariane_pkg::SLTS;  // Set Lower Than
              {
                7'b000_0000, 3'b011
              } :
              instruction_o.op = ariane_pkg::SLTU;  // Set Lower Than Unsigned
              {7'b000_0000, 3'b100} : instruction_o.op = ariane_pkg::XORL;  // Xor
              {7'b000_0000, 3'b110} : instruction_o.op = ariane_pkg::ORL;  // Or
              {7'b000_0000, 3'b111} : instruction_o.op = ariane_pkg::ANDL;  // And
              {7'b000_0000, 3'b001} : instruction_o.op = ariane_pkg::SLL;  // Shift Left Logical
              {7'b000_0000, 3'b101} : instruction_o.op = ariane_pkg::SRL;  // Shift Right Logical
              {7'b010_0000, 3'b101} : instruction_o.op = ariane_pkg::SRA;  // Shift Right Arithmetic
              // Multiplications
              {7'b000_0001, 3'b000} : instruction_o.op = ariane_pkg::MUL;
              {7'b000_0001, 3'b001} : instruction_o.op = ariane_pkg::MULH;
              {7'b000_0001, 3'b010} : instruction_o.op = ariane_pkg::MULHSU;
              {7'b000_0001, 3'b011} : instruction_o.op = ariane_pkg::MULHU;
              {7'b000_0001, 3'b100} : instruction_o.op = ariane_pkg::DIV;
              {7'b000_0001, 3'b101} : instruction_o.op = ariane_pkg::DIVU;
              {7'b000_0001, 3'b110} : instruction_o.op = ariane_pkg::REM;
              {7'b000_0001, 3'b111} : instruction_o.op = ariane_pkg::REMU;
              default: begin
                illegal_instr_non_bm = 1'b1;
              end
            endcase
            if (CVA6Cfg.RVB) begin
              unique case ({
                instr.rtype.funct7, instr.rtype.funct3
              })
                //Logical with Negate
                {7'b010_0000, 3'b111} : instruction_o.op = ariane_pkg::ANDN;  // Andn
                {7'b010_0000, 3'b110} : instruction_o.op = ariane_pkg::ORN;  // Orn
                {7'b010_0000, 3'b100} : instruction_o.op = ariane_pkg::XNOR;  // Xnor
                //Shift and Add (Bitmanip)
                {7'b001_0000, 3'b010} : instruction_o.op = ariane_pkg::SH1ADD;  // Sh1add
                {7'b001_0000, 3'b100} : instruction_o.op = ariane_pkg::SH2ADD;  // Sh2add
                {7'b001_0000, 3'b110} : instruction_o.op = ariane_pkg::SH3ADD;  // Sh3add
                // Integer maximum/minimum
                {7'b000_0101, 3'b110} : instruction_o.op = ariane_pkg::MAX;  // max
                {7'b000_0101, 3'b111} : instruction_o.op = ariane_pkg::MAXU;  // maxu
                {7'b000_0101, 3'b100} : instruction_o.op = ariane_pkg::MIN;  // min
                {7'b000_0101, 3'b101} : instruction_o.op = ariane_pkg::MINU;  // minu
                // Single bit instructions
                {7'b010_0100, 3'b001} : instruction_o.op = ariane_pkg::BCLR;  // bclr
                {7'b010_0100, 3'b101} : instruction_o.op = ariane_pkg::BEXT;  // bext
                {7'b011_0100, 3'b001} : instruction_o.op = ariane_pkg::BINV;  // binv
                {7'b001_0100, 3'b001} : instruction_o.op = ariane_pkg::BSET;  // bset
                // Carry-Less-Multiplication (clmul, clmulh, clmulr)
                {7'b000_0101, 3'b001} : instruction_o.op = ariane_pkg::CLMUL;  // clmul
                {7'b000_0101, 3'b011} : instruction_o.op = ariane_pkg::CLMULH;  // clmulh
                {7'b000_0101, 3'b010} : instruction_o.op = ariane_pkg::CLMULR;  // clmulr
                // Bitwise Shifting
                {7'b011_0000, 3'b001} : instruction_o.op = ariane_pkg::ROL;  // rol
                {7'b011_0000, 3'b101} : instruction_o.op = ariane_pkg::ROR;  // ror
                {
                  7'b000_0100, 3'b111
                } : begin
                  if (CVA6Cfg.ZKN) instruction_o.op = ariane_pkg::PACK_H;  //packh
                  else illegal_instr_bm = 1'b1;
                end
                // Zero Extend Op RV32 encoding
                {
                  7'b000_0100, 3'b100
                } : begin
                  if (!CVA6Cfg.IS_XLEN64 && instr.instr[24:20] == 5'b00000)
                    instruction_o.op = ariane_pkg::ZEXTH;  // Zero Extend Op RV32 encoding
                  else if (CVA6Cfg.ZKN) instruction_o.op = ariane_pkg::PACK;  // pack
                  else illegal_instr_bm = 1'b1;
                end
                default: begin
                  illegal_instr_bm = 1'b1;
                end
              endcase
            end
            if (CVA6Cfg.RVZiCond) begin
              unique case ({
                instr.rtype.funct7, instr.rtype.funct3
              })
                //Conditional move
                {7'b000_0111, 3'b101} : instruction_o.op = ariane_pkg::CZERO_EQZ;  // czero.eqz
                {7'b000_0111, 3'b111} : instruction_o.op = ariane_pkg::CZERO_NEZ;  // czero.nez
                default: begin
                  illegal_instr_zic = 1'b1;
                end
              endcase
            end
            //VCS coverage on
            unique case ({
              CVA6Cfg.RVB, CVA6Cfg.RVZiCond
            })
              2'b00:   illegal_instr = illegal_instr_non_bm;
              2'b01:   illegal_instr = illegal_instr_non_bm & illegal_instr_zic;
              2'b10:   illegal_instr = illegal_instr_non_bm & illegal_instr_bm;
              2'b11:   illegal_instr = illegal_instr_non_bm & illegal_instr_bm & illegal_instr_zic;
              default: ;  // TODO: Check that default case is not synthesized.
            endcase
          end
        end

        // --------------------------
        // 32bit Reg-Reg Operations
        // --------------------------
        riscv::OpcodeOp32: begin
          instruction_o.fu  = (instr.rtype.funct7 == 7'b000_0001) ? MULT : ALU;
          instruction_o.rs1 = instr.rtype.rs1;
          instruction_o.rs2 = instr.rtype.rs2;
          instruction_o.rd  = instr.rtype.rd;
          if (CVA6Cfg.IS_XLEN64) begin
            unique case ({
              instr.rtype.funct7, instr.rtype.funct3
            })
              {7'b000_0000, 3'b000} : instruction_o.op = ariane_pkg::ADDW;  // addw
              {7'b010_0000, 3'b000} : instruction_o.op = ariane_pkg::SUBW;  // subw
              {7'b000_0000, 3'b001} : instruction_o.op = ariane_pkg::SLLW;  // sllw
              {7'b000_0000, 3'b101} : instruction_o.op = ariane_pkg::SRLW;  // srlw
              {7'b010_0000, 3'b101} : instruction_o.op = ariane_pkg::SRAW;  // sraw
              // Multiplications
              {7'b000_0001, 3'b000} : instruction_o.op = ariane_pkg::MULW;
              {7'b000_0001, 3'b100} : instruction_o.op = ariane_pkg::DIVW;
              {7'b000_0001, 3'b101} : instruction_o.op = ariane_pkg::DIVUW;
              {7'b000_0001, 3'b110} : instruction_o.op = ariane_pkg::REMW;
              {7'b000_0001, 3'b111} : instruction_o.op = ariane_pkg::REMUW;
              default: illegal_instr_non_bm = 1'b1;
            endcase
            if (CVA6Cfg.RVB) begin
              unique case ({
                instr.rtype.funct7, instr.rtype.funct3
              })
                // Shift with Add (Unsigned Word)
                {7'b001_0000, 3'b010} : instruction_o.op = ariane_pkg::SH1ADDUW;  // sh1add.uw
                {7'b001_0000, 3'b100} : instruction_o.op = ariane_pkg::SH2ADDUW;  // sh2add.uw
                {7'b001_0000, 3'b110} : instruction_o.op = ariane_pkg::SH3ADDUW;  // sh3add.uw
                // Unsigned word Op's
                {7'b000_0100, 3'b000} : instruction_o.op = ariane_pkg::ADDUW;  // add.uw
                // Bitwise Shifting
                {7'b011_0000, 3'b001} : instruction_o.op = ariane_pkg::ROLW;  // rolw
                {7'b011_0000, 3'b101} : instruction_o.op = ariane_pkg::RORW;  // rorw
                {
                  7'b000_0100, 3'b100
                } : begin
                  if (instr.instr[24:20] == 5'b00000)
                    instruction_o.op = ariane_pkg::ZEXTH;  // Zero Extend Op RV64 encoding
                  else if (CVA6Cfg.ZKN) instruction_o.op = ariane_pkg::PACK_W;  // packw
                  else illegal_instr_bm = 1'b1;
                end
                default: illegal_instr_bm = 1'b1;
              endcase
              illegal_instr = illegal_instr_non_bm & illegal_instr_bm;
            end else begin
              illegal_instr = illegal_instr_non_bm;
            end
          end else illegal_instr = 1'b1;
        end
        // --------------------------------
        // Reg-Immediate Operations
        // --------------------------------
        riscv::OpcodeOpImm: begin
          instruction_o.fu = ALU;
          imm_select = IIMM;
          instruction_o.rs1 = instr.itype.rs1;
          instruction_o.rd = instr.itype.rd;
          unique case (instr.itype.funct3)
            3'b000: instruction_o.op = ariane_pkg::ADD;  // Add Immediate
            3'b010: instruction_o.op = ariane_pkg::SLTS;  // Set to one if Lower Than Immediate
            3'b011:
            instruction_o.op = ariane_pkg::SLTU;  // Set to one if Lower Than Immediate Unsigned
            3'b100: instruction_o.op = ariane_pkg::XORL;  // Exclusive Or with Immediate
            3'b110: instruction_o.op = ariane_pkg::ORL;  // Or with Immediate
            3'b111: instruction_o.op = ariane_pkg::ANDL;  // And with Immediate

            3'b001: begin
              instruction_o.op = ariane_pkg::SLL;  // Shift Left Logical by Immediate
              if (instr.instr[31:26] != 6'b0) illegal_instr_non_bm = 1'b1;
              if (instr.instr[25] != 1'b0 && CVA6Cfg.XLEN == 32) illegal_instr_non_bm = 1'b1;
            end

            3'b101: begin
              if (instr.instr[31:26] == 6'b0)
                instruction_o.op = ariane_pkg::SRL;  // Shift Right Logical by Immediate
              else if (instr.instr[31:26] == 6'b010_000)
                instruction_o.op = ariane_pkg::SRA;  // Shift Right Arithmetically by Immediate
              else illegal_instr_non_bm = 1'b1;
              if (instr.instr[25] != 1'b0 && CVA6Cfg.XLEN == 32) illegal_instr_non_bm = 1'b1;
            end
          endcase
          if (CVA6Cfg.RVB) begin
            unique case (instr.itype.funct3)
              3'b001: begin
                if (instr.instr[31:25] == 7'b0110000) begin
                  if (instr.instr[24:20] == 5'b00100) instruction_o.op = ariane_pkg::SEXTB;
                  else if (instr.instr[24:20] == 5'b00101) instruction_o.op = ariane_pkg::SEXTH;
                  else if (instr.instr[24:20] == 5'b00010) instruction_o.op = ariane_pkg::CPOP;
                  else if (instr.instr[24:20] == 5'b00000) instruction_o.op = ariane_pkg::CLZ;
                  else if (instr.instr[24:20] == 5'b00001) instruction_o.op = ariane_pkg::CTZ;
                  else illegal_instr_bm = 1'b1;
                end else if (CVA6Cfg.IS_XLEN64 && instr.instr[31:26] == 6'b010010)
                  instruction_o.op = ariane_pkg::BCLRI;
                else if (CVA6Cfg.IS_XLEN32 && instr.instr[31:25] == 7'b0100100)
                  instruction_o.op = ariane_pkg::BCLRI;
                else if (CVA6Cfg.IS_XLEN64 && instr.instr[31:26] == 6'b011010)
                  instruction_o.op = ariane_pkg::BINVI;
                else if (CVA6Cfg.IS_XLEN32 && instr.instr[31:25] == 7'b0110100)
                  instruction_o.op = ariane_pkg::BINVI;
                else if (CVA6Cfg.IS_XLEN64 && instr.instr[31:26] == 6'b001010)
                  instruction_o.op = ariane_pkg::BSETI;
                else if (CVA6Cfg.IS_XLEN32 && instr.instr[31:25] == 7'b0010100)
                  instruction_o.op = ariane_pkg::BSETI;
                else if (CVA6Cfg.ZKN && instr.instr[31:20] == 12'b000010001111)
                  instruction_o.op = ariane_pkg::ZIP;
                else illegal_instr_bm = 1'b1;
              end
              3'b101: begin
                if (instr.instr[31:20] == 12'b001010000111) instruction_o.op = ariane_pkg::ORCB;
                else if (CVA6Cfg.IS_XLEN64 && instr.instr[31:20] == 12'b011010111000)
                  instruction_o.op = ariane_pkg::REV8;
                else if (instr.instr[31:20] == 12'b011010011000)
                  instruction_o.op = ariane_pkg::REV8;
                else if (CVA6Cfg.IS_XLEN64 && instr.instr[31:26] == 6'b010_010)
                  instruction_o.op = ariane_pkg::BEXTI;
                else if (CVA6Cfg.IS_XLEN32 && instr.instr[31:25] == 7'b010_0100)
                  instruction_o.op = ariane_pkg::BEXTI;
                else if (CVA6Cfg.IS_XLEN64 && instr.instr[31:26] == 6'b011_000)
                  instruction_o.op = ariane_pkg::RORI;
                else if (CVA6Cfg.IS_XLEN32 && instr.instr[31:25] == 7'b011_0000)
                  instruction_o.op = ariane_pkg::RORI;
                else if (CVA6Cfg.ZKN && instr.instr[31:20] == 12'b011010000111)
                  instruction_o.op = ariane_pkg::BREV8;
                else if (CVA6Cfg.ZKN && instr.instr[31:20] == 12'b000010001111)
                  instruction_o.op = ariane_pkg::UNZIP;
                else illegal_instr_bm = 1'b1;
              end
              default: illegal_instr_bm = 1'b1;
            endcase
            illegal_instr = illegal_instr_non_bm & illegal_instr_bm;
          end else begin
            illegal_instr = illegal_instr_non_bm;
          end
        end

        // --------------------------------
        // 32 bit Reg-Immediate Operations
        // --------------------------------
        riscv::OpcodeOpImm32: begin
          instruction_o.fu = ALU;
          imm_select = IIMM;
          instruction_o.rs1 = instr.itype.rs1;
          instruction_o.rd = instr.itype.rd;
          if (CVA6Cfg.IS_XLEN64) begin
            unique case (instr.itype.funct3)
              3'b000:  instruction_o.op = ariane_pkg::ADDW;  // Add Immediate
              3'b001: begin
                instruction_o.op = ariane_pkg::SLLW;  // Shift Left Logical by Immediate
                if (instr.instr[31:25] != 7'b0) illegal_instr_non_bm = 1'b1;
              end
              3'b101: begin
                if (instr.instr[31:25] == 7'b0)
                  instruction_o.op = ariane_pkg::SRLW;  // Shift Right Logical by Immediate
                else if (instr.instr[31:25] == 7'b010_0000)
                  instruction_o.op = ariane_pkg::SRAW;  // Shift Right Arithmetically by Immediate
                else illegal_instr_non_bm = 1'b1;
              end
              default: illegal_instr_non_bm = 1'b1;
            endcase
            if (CVA6Cfg.RVB) begin
              unique case (instr.itype.funct3)
                3'b001: begin
                  if (instr.instr[31:25] == 7'b0110000) begin
                    if (instr.instr[21:20] == 2'b10) instruction_o.op = ariane_pkg::CPOPW;
                    else if (instr.instr[21:20] == 2'b00) instruction_o.op = ariane_pkg::CLZW;
                    else if (instr.instr[21:20] == 2'b01) instruction_o.op = ariane_pkg::CTZW;
                    else illegal_instr_bm = 1'b1;
                  end else if (instr.instr[31:26] == 6'b000010) begin
                    instruction_o.op = ariane_pkg::SLLIUW; // Shift Left Logic by Immediate (Unsigned Word)
                  end else illegal_instr_bm = 1'b1;
                end
                3'b101: begin
                  if (instr.instr[31:25] == 7'b011_0000) instruction_o.op = ariane_pkg::RORIW;
                  else illegal_instr_bm = 1'b1;
                end
                default: illegal_instr_bm = 1'b1;
              endcase
              illegal_instr = illegal_instr_non_bm & illegal_instr_bm;
            end else begin
              illegal_instr = illegal_instr_non_bm;
            end

          end else illegal_instr = 1'b1;
        end
        // --------------------------------
        // LSU
        // --------------------------------
        riscv::OpcodeStore: begin
          instruction_o.fu = STORE;
          imm_select = SIMM;
          instruction_o.rs1 = instr.stype.rs1;
          instruction_o.rs2 = instr.stype.rs2;
          // determine store size
          unique case (instr.stype.funct3)
            3'b000: instruction_o.op = ariane_pkg::SB;
            3'b001: instruction_o.op = ariane_pkg::SH;
            3'b010: instruction_o.op = ariane_pkg::SW;
            3'b011:
            if (CVA6Cfg.XLEN == 64) instruction_o.op = ariane_pkg::SD;
            else illegal_instr = 1'b1;
            default: illegal_instr = 1'b1;
          endcase
          if (CVA6Cfg.RVH) begin
            tinst = {7'b0, instr.stype.rs2, 5'b0, instr.stype.funct3, 5'b0, instr.stype.opcode};
            tinst[1] = is_compressed_i ? 1'b0 : 'b1;
          end
        end

        riscv::OpcodeLoad: begin
          instruction_o.fu = LOAD;
          imm_select = IIMM;
          instruction_o.rs1 = instr.itype.rs1;
          instruction_o.rd = instr.itype.rd;
          // determine load size and signed type
          unique case (instr.itype.funct3)
            3'b000: instruction_o.op = ariane_pkg::LB;
            3'b001: instruction_o.op = ariane_pkg::LH;
            3'b010: instruction_o.op = ariane_pkg::LW;
            3'b100: instruction_o.op = ariane_pkg::LBU;
            3'b101: instruction_o.op = ariane_pkg::LHU;
            3'b110:
            if (CVA6Cfg.XLEN == 64) instruction_o.op = ariane_pkg::LWU;
            else illegal_instr = 1'b1;
            3'b011:
            if (CVA6Cfg.XLEN == 64) instruction_o.op = ariane_pkg::LD;
            else illegal_instr = 1'b1;
            default: illegal_instr = 1'b1;
          endcase
          if (CVA6Cfg.RVH) begin
            tinst = {17'b0, instr.itype.funct3, instr.itype.rd, instr.itype.opcode};
            tinst[1] = is_compressed_i ? 1'b0 : 'b1;
          end
        end

        // --------------------------------
        // Floating-Point Load/store
        // --------------------------------
        riscv::OpcodeStoreFp: begin
          if (CVA6Cfg.FpPresent && fs_i != riscv::Off && ((CVA6Cfg.RVH && (!v_i || vfs_i != riscv::Off)) || !CVA6Cfg.RVH)) begin // only generate decoder if FP extensions are enabled (static)
            instruction_o.fu = STORE;
            imm_select = SIMM;
            instruction_o.rs1 = instr.stype.rs1;
            instruction_o.rs2 = instr.stype.rs2;
            // determine store size
            unique case (instr.stype.funct3)
              // Only process instruction if corresponding extension is active (static)
              3'b000:
              if (CVA6Cfg.XF8) instruction_o.op = ariane_pkg::FSB;
              else illegal_instr = 1'b1;
              3'b001:
              if (CVA6Cfg.XF16 | CVA6Cfg.XF16ALT) instruction_o.op = ariane_pkg::FSH;
              else illegal_instr = 1'b1;
              3'b010:
              if (CVA6Cfg.RVF) instruction_o.op = ariane_pkg::FSW;
              else illegal_instr = 1'b1;
              3'b011:
              if (CVA6Cfg.RVD) instruction_o.op = ariane_pkg::FSD;
              else illegal_instr = 1'b1;
              default: illegal_instr = 1'b1;
            endcase
            if (CVA6Cfg.RVH) begin
              tinst = {7'b0, instr.stype.rs2, 5'b0, instr.stype.funct3, 5'b0, instr.stype.opcode};
              tinst[1] = is_compressed_i ? 1'b0 : 'b1;
            end
          end else illegal_instr = 1'b1;
        end

        riscv::OpcodeLoadFp: begin
          if (CVA6Cfg.FpPresent && fs_i != riscv::Off && ((CVA6Cfg.RVH && (!v_i || vfs_i != riscv::Off)) || !CVA6Cfg.RVH)) begin // only generate decoder if FP extensions are enabled (static)
            instruction_o.fu = LOAD;
            imm_select = IIMM;
            instruction_o.rs1 = instr.itype.rs1;
            instruction_o.rd = instr.itype.rd;
            // determine load size
            unique case (instr.itype.funct3)
              // Only process instruction if corresponding extension is active (static)
              3'b000:
              if (CVA6Cfg.XF8) instruction_o.op = ariane_pkg::FLB;
              else illegal_instr = 1'b1;
              3'b001:
              if (CVA6Cfg.XF16 | CVA6Cfg.XF16ALT) instruction_o.op = ariane_pkg::FLH;
              else illegal_instr = 1'b1;
              3'b010:
              if (CVA6Cfg.RVF) instruction_o.op = ariane_pkg::FLW;
              else illegal_instr = 1'b1;
              3'b011:
              if (CVA6Cfg.RVD) instruction_o.op = ariane_pkg::FLD;
              else illegal_instr = 1'b1;
              default: illegal_instr = 1'b1;
            endcase
            if (CVA6Cfg.RVH) begin
              tinst = {17'b0, instr.itype.funct3, instr.itype.rd, instr.itype.opcode};
              tinst[1] = is_compressed_i ? 1'b0 : 'b1;
            end
          end else illegal_instr = 1'b1;
        end

        // ----------------------------------
        // Floating-Point Reg-Reg Operations
        // ----------------------------------
        riscv::OpcodeMadd, riscv::OpcodeMsub, riscv::OpcodeNmsub, riscv::OpcodeNmadd: begin
          if (CVA6Cfg.FpPresent && fs_i != riscv::Off && ((CVA6Cfg.RVH && (!v_i || vfs_i != riscv::Off)) || !CVA6Cfg.RVH)) begin // only generate decoder if FP extensions are enabled (static)
            instruction_o.fu  = FPU;
            instruction_o.rs1 = instr.r4type.rs1;
            instruction_o.rs2 = instr.r4type.rs2;
            instruction_o.rd  = instr.r4type.rd;
            imm_select        = RS3;  // rs3 into result field
            check_fprm        = 1'b1;
            // select the correct fused operation
            unique case (instr.r4type.opcode)
              default: instruction_o.op = ariane_pkg::FMADD;  // fmadd.fmt - FP Fused multiply-add
              riscv::OpcodeMsub:
              instruction_o.op = ariane_pkg::FMSUB;  // fmsub.fmt - FP Fused multiply-subtract
              riscv::OpcodeNmsub:
              instruction_o.op = ariane_pkg::FNMSUB; // fnmsub.fmt - FP Negated fused multiply-subtract
              riscv::OpcodeNmadd:
              instruction_o.op = ariane_pkg::FNMADD;  // fnmadd.fmt - FP Negated fused multiply-add
            endcase

            // determine fp format
            unique case (instr.r4type.funct2)
              // Only process instruction if corresponding extension is active (static)
              2'b00:   if (~CVA6Cfg.RVF) illegal_instr = 1'b1;
              2'b01:   if (~CVA6Cfg.RVD) illegal_instr = 1'b1;
              2'b10:   if (~CVA6Cfg.XF16 & ~CVA6Cfg.XF16ALT) illegal_instr = 1'b1;
              2'b11:   if (~CVA6Cfg.XF8) illegal_instr = 1'b1;
              default: illegal_instr = 1'b1;
            endcase

            // check rounding mode
            if (check_fprm) begin
              unique case (instr.rftype.rm) inside
                [3'b000 : 3'b100]: ;  //legal rounding modes
                3'b101: begin  // Alternative Half-Precsision encded as fmt=10 and rm=101
                  if (~CVA6Cfg.XF16ALT || instr.rftype.fmt != 2'b10) illegal_instr = 1'b1;
                  unique case (frm_i) inside  // actual rounding mode from frm csr
                    [3'b000 : 3'b100]: ;  //legal rounding modes
                    default: illegal_instr = 1'b1;
                  endcase
                end
                3'b111: begin
                  // rounding mode from frm csr
                  unique case (frm_i) inside
                    [3'b000 : 3'b100]: ;  //legal rounding modes
                    default: illegal_instr = 1'b1;
                  endcase
                end
                default:           illegal_instr = 1'b1;
              endcase
            end
          end else begin
            illegal_instr = 1'b1;
          end
        end

        riscv::OpcodeOpFp: begin
          if (CVA6Cfg.FpPresent && fs_i != riscv::Off && ((CVA6Cfg.RVH && (!v_i || vfs_i != riscv::Off)) || !CVA6Cfg.RVH)) begin // only generate decoder if FP extensions are enabled (static)
            instruction_o.fu  = FPU;
            instruction_o.rs1 = instr.rftype.rs1;
            instruction_o.rs2 = instr.rftype.rs2;
            instruction_o.rd  = instr.rftype.rd;
            check_fprm        = 1'b1;
            // decode FP instruction
            unique case (instr.rftype.funct5)
              5'b00000: begin
                instruction_o.op  = ariane_pkg::FADD;  // fadd.fmt - FP Addition
                instruction_o.rs1 = '0;  // Operand A is set to 0
                instruction_o.rs2 = instr.rftype.rs1;  // Operand B is set to rs1
                imm_select        = IIMM;  // Operand C is set to rs2
              end
              5'b00001: begin
                instruction_o.op  = ariane_pkg::FSUB;  // fsub.fmt - FP Subtraction
                instruction_o.rs1 = '0;  // Operand A is set to 0
                instruction_o.rs2 = instr.rftype.rs1;  // Operand B is set to rs1
                imm_select        = IIMM;  // Operand C is set to rs2
              end
              5'b00010: instruction_o.op = ariane_pkg::FMUL;  // fmul.fmt - FP Multiplication
              5'b00011: instruction_o.op = ariane_pkg::FDIV;  // fdiv.fmt - FP Division
              5'b01011: begin
                instruction_o.op = ariane_pkg::FSQRT;  // fsqrt.fmt - FP Square Root
                // rs2 must be zero
                if (instr.rftype.rs2 != 5'b00000) illegal_instr = 1'b1;
              end
              5'b00100: begin
                instruction_o.op = ariane_pkg::FSGNJ;  // fsgn{j[n]/jx}.fmt - FP Sign Injection
                check_fprm       = 1'b0;  // instruction encoded in rm, do the check here
                if (CVA6Cfg.XF16ALT) begin        // FP16ALT instructions encoded in rm separately (static)
                  if (!(instr.rftype.rm inside {[3'b000 : 3'b010], [3'b100 : 3'b110]}))
                    illegal_instr = 1'b1;
                end else begin
                  if (!(instr.rftype.rm inside {[3'b000 : 3'b010]})) illegal_instr = 1'b1;
                end
              end
              5'b00101: begin
                instruction_o.op = ariane_pkg::FMIN_MAX;  // fmin/fmax.fmt - FP Minimum / Maximum
                check_fprm       = 1'b0;  // instruction encoded in rm, do the check here
                if (CVA6Cfg.XF16ALT) begin           // FP16ALT instructions encoded in rm separately (static)
                  if (!(instr.rftype.rm inside {[3'b000 : 3'b001], [3'b100 : 3'b101]}))
                    illegal_instr = 1'b1;
                end else begin
                  if (!(instr.rftype.rm inside {[3'b000 : 3'b001]})) illegal_instr = 1'b1;
                end
              end
              5'b01000: begin
                instruction_o.op = ariane_pkg::FCVT_F2F;  // fcvt.fmt.fmt - FP to FP Conversion
                instruction_o.rs2 = instr.rvftype.rs1; // tie rs2 to rs1 to be safe (vectors use rs2)
                imm_select = IIMM;  // rs2 holds part of the intruction
                if (|instr.rftype.rs2[24:23])
                  illegal_instr = 1'b1;  // bits [22:20] used, other bits must be 0
                // check source format
                unique case (instr.rftype.rs2[22:20])
                  // Only process instruction if corresponding extension is active (static)
                  3'b000:  if (~CVA6Cfg.RVF) illegal_instr = 1'b1;
                  3'b001:  if (~CVA6Cfg.RVD) illegal_instr = 1'b1;
                  3'b010:  if (~CVA6Cfg.XF16) illegal_instr = 1'b1;
                  3'b110:  if (~CVA6Cfg.XF16ALT) illegal_instr = 1'b1;
                  3'b011:  if (~CVA6Cfg.XF8) illegal_instr = 1'b1;
                  default: illegal_instr = 1'b1;
                endcase
              end
              5'b10100: begin
                instruction_o.op = ariane_pkg::FCMP;  // feq/flt/fle.fmt - FP Comparisons
                check_fprm       = 1'b0;  // instruction encoded in rm, do the check here
                if (CVA6Cfg.XF16ALT) begin       // FP16ALT instructions encoded in rm separately (static)
                  if (!(instr.rftype.rm inside {[3'b000 : 3'b010], [3'b100 : 3'b110]}))
                    illegal_instr = 1'b1;
                end else begin
                  if (!(instr.rftype.rm inside {[3'b000 : 3'b010]})) illegal_instr = 1'b1;
                end
              end
              5'b11000: begin
                instruction_o.op = ariane_pkg::FCVT_F2I;  // fcvt.ifmt.fmt - FP to Int Conversion
                imm_select       = IIMM;  // rs2 holds part of the instruction
                if (|instr.rftype.rs2[24:22])
                  illegal_instr = 1'b1;  // bits [21:20] used, other bits must be 0
              end
              5'b11010: begin
                instruction_o.op = ariane_pkg::FCVT_I2F;  // fcvt.fmt.ifmt - Int to FP Conversion
                imm_select       = IIMM;  // rs2 holds part of the instruction
                if (|instr.rftype.rs2[24:22])
                  illegal_instr = 1'b1;  // bits [21:20] used, other bits must be 0
              end
              5'b11100: begin
                instruction_o.rs2 = instr.rftype.rs1; // set rs2 = rs1 so we can map FMV to SGNJ in the unit
                check_fprm = 1'b0;  // instruction encoded in rm, do the check here
                if (instr.rftype.rm == 3'b000 || (CVA6Cfg.XF16ALT && instr.rftype.rm == 3'b100)) // FP16ALT has separate encoding
                  instruction_o.op = ariane_pkg::FMV_F2X;  // fmv.ifmt.fmt - FPR to GPR Move
                else if (instr.rftype.rm == 3'b001 || (CVA6Cfg.XF16ALT && instr.rftype.rm == 3'b101)) // FP16ALT has separate encoding
                  instruction_o.op = ariane_pkg::FCLASS;  // fclass.fmt - FP Classify
                else illegal_instr = 1'b1;
                // rs2 must be zero
                if (instr.rftype.rs2 != 5'b00000) illegal_instr = 1'b1;
              end
              5'b11110: begin
                instruction_o.op = ariane_pkg::FMV_X2F;  // fmv.fmt.ifmt - GPR to FPR Move
                instruction_o.rs2 = instr.rftype.rs1; // set rs2 = rs1 so we can map FMV to SGNJ in the unit
                check_fprm = 1'b0;  // instruction encoded in rm, do the check here
                if (!(instr.rftype.rm == 3'b000 || (CVA6Cfg.XF16ALT && instr.rftype.rm == 3'b100)))
                  illegal_instr = 1'b1;
                // rs2 must be zero
                if (instr.rftype.rs2 != 5'b00000) illegal_instr = 1'b1;
              end
              default:  illegal_instr = 1'b1;
            endcase

            // check format
            unique case (instr.rftype.fmt)
              // Only process instruction if corresponding extension is active (static)
              2'b00:   if (~CVA6Cfg.RVF) illegal_instr = 1'b1;
              2'b01:   if (~CVA6Cfg.RVD) illegal_instr = 1'b1;
              2'b10:   if (~CVA6Cfg.XF16 & ~CVA6Cfg.XF16ALT) illegal_instr = 1'b1;
              2'b11:   if (~CVA6Cfg.XF8) illegal_instr = 1'b1;
              default: illegal_instr = 1'b1;
            endcase

            // check rounding mode
            if (check_fprm) begin
              unique case (instr.rftype.rm) inside
                [3'b000 : 3'b100]: ;  //legal rounding modes
                3'b101: begin  // Alternative Half-Precsision encded as fmt=10 and rm=101
                  if (~CVA6Cfg.XF16ALT || instr.rftype.fmt != 2'b10) illegal_instr = 1'b1;
                  unique case (frm_i) inside  // actual rounding mode from frm csr
                    [3'b000 : 3'b100]: ;  //legal rounding modes
                    default: illegal_instr = 1'b1;
                  endcase
                end
                3'b111: begin
                  // rounding mode from frm csr
                  unique case (frm_i) inside
                    [3'b000 : 3'b100]: ;  //legal rounding modes
                    default: illegal_instr = 1'b1;
                  endcase
                end
                default:           illegal_instr = 1'b1;
              endcase
            end
          end else begin
            illegal_instr = 1'b1;
          end
        end

        // ----------------------------------
        // Atomic Operations
        // ----------------------------------
        riscv::OpcodeAmo: begin
          // we are going to use the load unit for AMOs
          instruction_o.fu  = STORE;
          instruction_o.rs1 = instr.atype.rs1;
          instruction_o.rs2 = instr.atype.rs2;
          instruction_o.rd  = instr.atype.rd;
          // TODO(zarubaf): Ordering
          // words
          if (CVA6Cfg.RVA && instr.stype.funct3 == 3'h2) begin
            unique case (instr.instr[31:27])
              5'h0: instruction_o.op = ariane_pkg::AMO_ADDW;
              5'h1: instruction_o.op = ariane_pkg::AMO_SWAPW;
              5'h2: begin
                instruction_o.op = ariane_pkg::AMO_LRW;
                if (instr.atype.rs2 != 0) illegal_instr = 1'b1;
              end
              5'h3: instruction_o.op = ariane_pkg::AMO_SCW;
              5'h4: instruction_o.op = ariane_pkg::AMO_XORW;
              5'h8: instruction_o.op = ariane_pkg::AMO_ORW;
              5'hC: instruction_o.op = ariane_pkg::AMO_ANDW;
              5'h10: instruction_o.op = ariane_pkg::AMO_MINW;
              5'h14: instruction_o.op = ariane_pkg::AMO_MAXW;
              5'h18: instruction_o.op = ariane_pkg::AMO_MINWU;
              5'h1C: instruction_o.op = ariane_pkg::AMO_MAXWU;
              default: illegal_instr = 1'b1;
            endcase
            // double words
          end else if (CVA6Cfg.IS_XLEN64 && CVA6Cfg.RVA && instr.stype.funct3 == 3'h3) begin
            unique case (instr.instr[31:27])
              5'h0: instruction_o.op = ariane_pkg::AMO_ADDD;
              5'h1: instruction_o.op = ariane_pkg::AMO_SWAPD;
              5'h2: begin
                instruction_o.op = ariane_pkg::AMO_LRD;
                if (instr.atype.rs2 != 0) illegal_instr = 1'b1;
              end
              5'h3: instruction_o.op = ariane_pkg::AMO_SCD;
              5'h4: instruction_o.op = ariane_pkg::AMO_XORD;
              5'h8: instruction_o.op = ariane_pkg::AMO_ORD;
              5'hC: instruction_o.op = ariane_pkg::AMO_ANDD;
              5'h10: instruction_o.op = ariane_pkg::AMO_MIND;
              5'h14: instruction_o.op = ariane_pkg::AMO_MAXD;
              5'h18: instruction_o.op = ariane_pkg::AMO_MINDU;
              5'h1C: instruction_o.op = ariane_pkg::AMO_MAXDU;
              default: illegal_instr = 1'b1;
            endcase
          end else begin
            illegal_instr = 1'b1;
          end
          if (CVA6Cfg.RVH) begin
            tinst = {
              instr.atype.funct5,
              instr.atype.aq,
              instr.atype.rl,
              instr.atype.rs2,
              5'b0,
              instr.atype.funct3,
              instr.atype.rd,
              instr.atype.opcode
            };
          end
        end

        // --------------------------------
        // Control Flow Instructions
        // --------------------------------
        riscv::OpcodeBranch: begin
          imm_select              = SBIMM;
          instruction_o.fu        = CTRL_FLOW;
          instruction_o.rs1       = instr.stype.rs1;
          instruction_o.rs2       = instr.stype.rs2;

          is_control_flow_instr_o = 1'b1;

          case (instr.stype.funct3)
            3'b000: instruction_o.op = ariane_pkg::EQ;
            3'b001: instruction_o.op = ariane_pkg::NE;
            3'b100: instruction_o.op = ariane_pkg::LTS;
            3'b101: instruction_o.op = ariane_pkg::GES;
            3'b110: instruction_o.op = ariane_pkg::LTU;
            3'b111: instruction_o.op = ariane_pkg::GEU;
            default: begin
              is_control_flow_instr_o = 1'b0;
              illegal_instr           = 1'b1;
            end
          endcase
        end
        // Jump and link register
        riscv::OpcodeJalr: begin
          instruction_o.fu        = CTRL_FLOW;
          instruction_o.op        = ariane_pkg::JALR;
          instruction_o.rs1       = instr.itype.rs1;
          imm_select              = IIMM;
          instruction_o.rd        = instr.itype.rd;
          is_control_flow_instr_o = 1'b1;
          // invalid jump and link register -> reserved for vector encoding
          if (instr.itype.funct3 != 3'b0) illegal_instr = 1'b1;
        end
        // Jump and link
        riscv::OpcodeJal: begin
          instruction_o.fu        = CTRL_FLOW;
          imm_select              = JIMM;
          instruction_o.rd        = instr.utype.rd;
          is_control_flow_instr_o = 1'b1;
        end

        riscv::OpcodeAuipc: begin
          instruction_o.fu     = ALU;
          imm_select           = UIMM;
          instruction_o.use_pc = 1'b1;
          instruction_o.rd     = instr.utype.rd;
        end

        riscv::OpcodeLui: begin
          imm_select       = UIMM;
          instruction_o.fu = ALU;
          instruction_o.rd = instr.utype.rd;
        end

        default: illegal_instr = 1'b1;
      endcase
    end
    if (CVA6Cfg.CvxifEn) begin
      if (~ex_i.valid && (is_illegal_i || illegal_instr)) begin
        instruction_o.fu = CVXIF;
        instruction_o.rs1 = instr.r4type.rs1;
        instruction_o.rs2 = instr.r4type.rs2;
        instruction_o.rd = instr.r4type.rd;
        instruction_o.op = ariane_pkg::OFFLOAD;
        imm_select             = instr.rtype.opcode == riscv::OpcodeMadd ||
                                 instr.rtype.opcode == riscv::OpcodeMsub ||
                                 instr.rtype.opcode == riscv::OpcodeNmadd ||
                                 instr.rtype.opcode == riscv::OpcodeNmsub ? RS3 : MUX_RD_RS3;
      end
    end

    // Accelerator instructions.
    // These can overwrite the previous decoding entirely.
    if (CVA6Cfg.EnableAccelerator) begin // only generate decoder if accelerators are enabled (static)
      if (is_accel) begin
        instruction_o.fu        = acc_instruction.fu;
        instruction_o.vfp       = acc_instruction.vfp;
        instruction_o.rs1       = acc_instruction.rs1;
        instruction_o.rs2       = acc_instruction.rs2;
        instruction_o.rd        = acc_instruction.rd;
        instruction_o.op        = acc_instruction.op;
        illegal_instr           = acc_illegal_instr;
        is_control_flow_instr_o = acc_is_control_flow_instr;
      end
    end
  end

  // --------------------------------
  // Sign extend immediate
  // --------------------------------
  always_comb begin : sign_extend
    imm_i_type = {{CVA6Cfg.XLEN - 12{instruction_i[31]}}, instruction_i[31:20]};
    imm_s_type = {
      {CVA6Cfg.XLEN - 12{instruction_i[31]}}, instruction_i[31:25], instruction_i[11:7]
    };
    imm_sb_type = {
      {CVA6Cfg.XLEN - 13{instruction_i[31]}},
      instruction_i[31],
      instruction_i[7],
      instruction_i[30:25],
      instruction_i[11:8],
      1'b0
    };
    imm_u_type = {
      {CVA6Cfg.XLEN - 32{instruction_i[31]}}, instruction_i[31:12], 12'b0
    };  // JAL, AUIPC, sign extended to 64 bit
    //  if zcmt then xlen jump address assign to immidiate
    if (CVA6Cfg.RVZCMT && is_zcmt_i) begin
      imm_uj_type = {{CVA6Cfg.XLEN - 32{jump_address_i[31]}}, jump_address_i[31:0]};
    end else begin
      imm_uj_type = {
        {CVA6Cfg.XLEN - 20{instruction_i[31]}},
        instruction_i[19:12],
        instruction_i[20],
        instruction_i[30:21],
        1'b0
      };
    end

    // NOIMM, IIMM, SIMM, SBIMM, UIMM, JIMM, RS3
    // select immediate
    case (imm_select)
      IIMM: begin
        instruction_o.result  = imm_i_type;
        instruction_o.use_imm = 1'b1;
      end
      SIMM: begin
        instruction_o.result  = imm_s_type;
        instruction_o.use_imm = 1'b1;
      end
      SBIMM: begin
        instruction_o.result  = imm_sb_type;
        instruction_o.use_imm = 1'b1;
      end
      UIMM: begin
        instruction_o.result  = imm_u_type;
        instruction_o.use_imm = 1'b1;
      end
      JIMM: begin
        instruction_o.result  = imm_uj_type;
        instruction_o.use_imm = 1'b1;
      end
      RS3: begin
        // result holds address of fp operand rs3
        instruction_o.result  = {{CVA6Cfg.XLEN - 5{1'b0}}, instr.r4type.rs3};
        instruction_o.use_imm = 1'b0;
      end
      MUX_RD_RS3: begin
        // result holds address of operand rs3 which is in rd field
        instruction_o.result  = {{CVA6Cfg.XLEN - 5{1'b0}}, instr.rtype.rd};
        instruction_o.use_imm = 1'b0;
      end
      default: begin
        instruction_o.result  = {CVA6Cfg.XLEN{1'b0}};
        instruction_o.use_imm = 1'b0;
      end
    endcase

    if (CVA6Cfg.EnableAccelerator) begin
      if (is_accel) begin
        instruction_o.result  = acc_instruction.result;
        instruction_o.use_imm = acc_instruction.use_imm;
      end
    end
  end

  // ---------------------
  // Exception handling
  // ---------------------
  logic [CVA6Cfg.XLEN-1:0] interrupt_cause;

  // this instruction has already executed if the exception is valid
  assign instruction_o.valid = instruction_o.ex.valid;

  always_comb begin : exception_handling
    interrupt_cause = '0;
    instruction_o.ex = ex_i;
    orig_instr_o = '0;
    // look if we didn't already get an exception in any previous
    // stage - we should not overwrite it as we retain order regarding the exception
    if (~ex_i.valid) begin
      // if we didn't already get an exception save the instruction here as we may need it
      // in the commit stage if we got a access exception to one of the CSR registers
      if (CVA6Cfg.CvxifEn || CVA6Cfg.RVF)
        orig_instr_o = (is_compressed_i) ? {{CVA6Cfg.XLEN-16{1'b0}}, compressed_instr_i} : {{CVA6Cfg.XLEN-32{1'b0}}, instruction_i};
      if (CVA6Cfg.TvalEn)
        instruction_o.ex.tval  = (is_compressed_i) ? {{CVA6Cfg.XLEN-16{1'b0}}, compressed_instr_i} : {{CVA6Cfg.XLEN-32{1'b0}}, instruction_i};
      else instruction_o.ex.tval = '0;
      if (CVA6Cfg.RVH) instruction_o.ex.tinst = tinst;
      else instruction_o.ex.tinst = '0;
      // instructions which will throw an exception are marked as valid
      // e.g.: they can be committed anytime and do not need to wait for any functional unit
      // check here if we decoded an invalid instruction or if the compressed decoder already decoded
      // a invalid instruction
      if (illegal_instr || is_illegal_i) begin
        if (!CVA6Cfg.CvxifEn) instruction_o.ex.valid = 1'b1;
        // we decoded an illegal exception here
        instruction_o.ex.cause = riscv::ILLEGAL_INSTR;
      end else if (CVA6Cfg.RVH && virtual_illegal_instr) begin
        instruction_o.ex.valid = 1'b1;
        // we decoded an virtual illegal exception here
        instruction_o.ex.cause = riscv::VIRTUAL_INSTRUCTION;
        // we got an ecall, set the correct cause depending on the current privilege level
      end else if (ecall) begin
        // this exception is valid
        instruction_o.ex.valid = 1'b1;
        // depending on the privilege mode, set the appropriate cause
        if (priv_lvl_i == riscv::PRIV_LVL_S && CVA6Cfg.RVS) begin
          instruction_o.ex.cause = (CVA6Cfg.RVH && v_i) ? riscv::ENV_CALL_VSMODE : riscv::ENV_CALL_SMODE;
        end else if (priv_lvl_i == riscv::PRIV_LVL_U && CVA6Cfg.RVU) begin
          instruction_o.ex.cause = riscv::ENV_CALL_UMODE;
        end else if (priv_lvl_i == riscv::PRIV_LVL_M) begin
          instruction_o.ex.cause = riscv::ENV_CALL_MMODE;
        end
      end else if (ebreak) begin
        // this exception is valid
        instruction_o.ex.valid = 1'b1;
        // set breakpoint cause
        instruction_o.ex.cause = riscv::BREAKPOINT;
        // set gva bit
        if (CVA6Cfg.RVH) instruction_o.ex.gva = v_i;
        else instruction_o.ex.gva = 1'b0;
      end
      // -----------------
      // Interrupt Control
      // -----------------
      // we decode an interrupt the same as an exception, hence it will be taken if the instruction did not
      // throw any previous exception.
      // we have three interrupt sources: external interrupts, software interrupts, timer interrupts (order of precedence)
      // for two privilege levels: Supervisor and Machine Mode
      // Virtual Supervisor Timer Interrupt
      if (CVA6Cfg.RVH) begin
        if (irq_ctrl_i.mie[riscv::IRQ_VS_TIMER] && irq_ctrl_i.mip[riscv::IRQ_VS_TIMER]) begin
          interrupt_cause = INTERRUPTS.VS_TIMER;
        end
        // Virtual Supervisor Software Interrupt
        if (irq_ctrl_i.mie[riscv::IRQ_VS_SOFT] && irq_ctrl_i.mip[riscv::IRQ_VS_SOFT]) begin
          interrupt_cause = INTERRUPTS.VS_SW;
        end
        // Virtual Supervisor External Interrupt
        if (irq_ctrl_i.mie[riscv::IRQ_VS_EXT] && (irq_ctrl_i.mip[riscv::IRQ_VS_EXT])) begin
          interrupt_cause = INTERRUPTS.VS_EXT;
        end
        // Hypervisor Guest External Interrupts
        if (irq_ctrl_i.mie[riscv::IRQ_HS_EXT] && irq_ctrl_i.mip[riscv::IRQ_HS_EXT]) begin
          interrupt_cause = INTERRUPTS.HS_EXT;
        end
      end
      if (CVA6Cfg.RVS) begin
        // Supervisor Timer Interrupt
        if (irq_ctrl_i.mie[riscv::IRQ_S_TIMER] && irq_ctrl_i.mip[riscv::IRQ_S_TIMER]) begin
          interrupt_cause = INTERRUPTS.S_TIMER;
        end
        // Supervisor Software Interrupt
        if (irq_ctrl_i.mie[riscv::IRQ_S_SOFT] && irq_ctrl_i.mip[riscv::IRQ_S_SOFT]) begin
          interrupt_cause = INTERRUPTS.S_SW;
        end
        // Supervisor External Interrupt
        // The logical-OR of the software-writable bit and the signal from the external interrupt controller is
        // used to generate external interrupts to the supervisor
        if (irq_ctrl_i.mie[riscv::IRQ_S_EXT] && (irq_ctrl_i.mip[riscv::IRQ_S_EXT] | irq_i[ariane_pkg::SupervisorIrq])) begin
          interrupt_cause = INTERRUPTS.S_EXT;
        end
      end
      // Machine Timer Interrupt
      if (irq_ctrl_i.mip[riscv::IRQ_M_TIMER] && irq_ctrl_i.mie[riscv::IRQ_M_TIMER]) begin
        interrupt_cause = INTERRUPTS.M_TIMER;
      end
      if (CVA6Cfg.SoftwareInterruptEn) begin
        // Machine Mode Software Interrupt
        if (irq_ctrl_i.mip[riscv::IRQ_M_SOFT] && irq_ctrl_i.mie[riscv::IRQ_M_SOFT]) begin
          interrupt_cause = INTERRUPTS.M_SW;
        end
      end
      // Machine Mode External Interrupt
      if (irq_ctrl_i.mip[riscv::IRQ_M_EXT] && irq_ctrl_i.mie[riscv::IRQ_M_EXT]) begin
        interrupt_cause = INTERRUPTS.M_EXT;
      end

      if (interrupt_cause[CVA6Cfg.XLEN-1] && irq_ctrl_i.global_enable) begin
        // However, if bit i in mideleg is set, interrupts are considered to be globally enabled if the hart’s current privilege
        // mode equals the delegated privilege mode (S or U) and that mode’s interrupt enable bit
        // (SIE or UIE in mstatus) is set, or if the current privilege mode is less than the delegated privilege mode.
        if (irq_ctrl_i.mideleg[interrupt_cause[$clog2(CVA6Cfg.XLEN)-1:0]]) begin
          if (CVA6Cfg.RVH) begin : hyp_int_gen
            if (v_i && irq_ctrl_i.hideleg[interrupt_cause[$clog2(CVA6Cfg.XLEN)-1:0]]) begin
              if ((irq_ctrl_i.sie && priv_lvl_i == riscv::PRIV_LVL_S) || priv_lvl_i == riscv::PRIV_LVL_U) begin
                instruction_o.ex.valid = 1'b1;
                instruction_o.ex.cause = interrupt_cause;
              end
            end else if (v_i && ~irq_ctrl_i.hideleg[interrupt_cause[$clog2(
                    CVA6Cfg.XLEN
                )-1:0]]) begin
              instruction_o.ex.valid = 1'b1;
              instruction_o.ex.cause = interrupt_cause;
            end else if (!v_i && ((irq_ctrl_i.sie && priv_lvl_i == riscv::PRIV_LVL_S) || priv_lvl_i == riscv::PRIV_LVL_U) && ~irq_ctrl_i.hideleg[interrupt_cause[$clog2(
                    CVA6Cfg.XLEN
                )-1:0]]) begin
              instruction_o.ex.valid = 1'b1;
              instruction_o.ex.cause = interrupt_cause;
            end
          end else begin
            if ((CVA6Cfg.RVS && irq_ctrl_i.sie && priv_lvl_i == riscv::PRIV_LVL_S) || (CVA6Cfg.RVU && priv_lvl_i == riscv::PRIV_LVL_U)) begin
              instruction_o.ex.valid = 1'b1;
              instruction_o.ex.cause = interrupt_cause;
            end
          end
        end else begin
          instruction_o.ex.valid = 1'b1;
          instruction_o.ex.cause = interrupt_cause;
        end
      end
    end

    // a debug request has precendece over everything else
    if (CVA6Cfg.DebugEn && debug_req_i && !debug_mode_i) begin
      instruction_o.ex.valid = 1'b1;
      instruction_o.ex.cause = riscv::DEBUG_REQUEST;
    end
  end
endmodule
