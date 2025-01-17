// Copyright 2021 Thales DIS design services SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Guillaume Chauvon (guillaume.chauvon@thalesgroup.com)



package cvxif_instr_pkg;

  typedef enum logic [3:0] {
    ILLEGAL = 4'b0000,
    NOP = 4'b0001,
    ADD = 4'b0010,
    DOUBLE_RS1 = 4'b0011,
    DOUBLE_RS2 = 4'b0100,
    ADD_MULTI = 4'b0101,
    MADD_RS3_R4 = 4'b0110,
    MSUB_RS3_R4 = 4'b0111,
    NMADD_RS3_R4 = 4'b1000,
    NMSUB_RS3_R4 = 4'b1001,
    ADD_RS3_R = 4'b1111
  } opcode_t;


  typedef struct packed {
    logic accept;
    logic writeback;  // TODO depends on dualwrite
    logic [2:0] register_read;  // TODO Nr read ports
  } issue_resp_t;

  typedef struct packed {
    logic        accept;
    logic [31:0] instr;
  } compressed_resp_t;

  typedef struct packed {
    logic [31:0] instr;
    logic [31:0] mask;
    issue_resp_t resp;
    opcode_t     opcode;
  } copro_issue_resp_t;


  typedef struct packed {
    logic [15:0]      instr;
    logic [15:0]      mask;
    compressed_resp_t resp;
  } copro_compressed_resp_t;

  // 4 Possible RISCV instructions for Coprocessor
  parameter int unsigned NbInstr = 10;
  parameter copro_issue_resp_t CoproInstr[NbInstr] = '{
      '{
          // Custom Nop
          instr:
          32'b00000_00_00000_00000_0_00_00000_1111011,  // custom3 opcode
          mask: 32'b11111_11_00000_00000_1_11_00000_1111111,
          resp : '{accept : 1'b1, writeback : 1'b0, register_read : {1'b0, 1'b0, 1'b0}},
          opcode : NOP
      },
      '{
          // Custom Add : cus_add rd, rs1, rs2
          instr:
          32'b00000_00_00000_00000_0_01_00000_1111011,  // custom3 opcode
          mask: 32'b11111_11_00000_00000_1_11_00000_1111111,
          resp : '{accept : 1'b1, writeback : 1'b1, register_read : {1'b0, 1'b1, 1'b1}},
          opcode : ADD
      },
      '{
          // Custom Add rs1 : cus_add rd, rs1, rs1
          instr:
          32'b00000_01_00000_00000_0_01_00000_1111011,  // custom3 opcode
          mask: 32'b11111_11_00000_00000_1_11_00000_1111111,
          resp : '{accept : 1'b1, writeback : 1'b1, register_read : {1'b0, 1'b0, 1'b1}},
          opcode : DOUBLE_RS1
      },
      '{
          // Custom Add rs2 : cus_add rd, rs2, rs2
          instr:
          32'b00000_10_00000_00000_0_01_00000_1111011,  // custom3 opcode
          mask: 32'b11111_11_00000_00000_1_11_00000_1111111,
          resp : '{accept : 1'b1, writeback : 1'b1, register_read : {1'b0, 1'b1, 1'b0}},
          opcode : DOUBLE_RS2
      },
      '{
          // Custom Add Multi rs1 : cus_add rd, rs1, rs1
          instr:
          32'b00000_11_00000_00000_0_01_00000_1111011,  // custom3 opcode
          mask: 32'b11111_11_00000_00000_1_11_00000_1111111,
          resp : '{accept : 1'b1, writeback : 1'b1, register_read : {1'b0, 1'b1, 1'b1}},
          opcode : ADD_MULTI
      },
      '{
          // Custom Add Multi rs1 : cus_add rd, rs1, rs1
          instr:
          32'b00001_00_00000_00000_0_01_00000_1111011,  // custom3 opcode
          mask: 32'b11111_11_00000_00000_1_11_00000_1111111,
          resp : '{accept : 1'b1, writeback : 1'b1, register_read : {1'b1, 1'b1, 1'b1}},
          opcode : ADD_RS3_R
      },
      '{
          // Custom Add Multi rs1 : cus_add rd, rs1, rs1
          instr:
          32'b00000_00_00000_00000_0_00_00000_1000011,  // MADD opcode
          mask: 32'b00000_11_00000_00000_1_11_00000_1111111,
          resp : '{accept : 1'b1, writeback : 1'b1, register_read : {1'b1, 1'b1, 1'b1}},
          opcode : MADD_RS3_R4
      },
      '{
          // Custom Add Multi rs1 : cus_add rd, rs1, rs1
          instr:
          32'b00000_00_00000_00000_0_00_00000_1000111,  // MSUB opcode
          mask: 32'b00000_11_00000_00000_1_11_00000_1111111,
          resp : '{accept : 1'b1, writeback : 1'b1, register_read : {1'b1, 1'b1, 1'b1}},
          opcode : MSUB_RS3_R4
      },
      '{
          // Custom Add Multi rs1 : cus_add rd, rs1, rs1
          instr:
          32'b00000_00_00000_00000_0_00_00000_1001011,  // NMSUB opcode
          mask: 32'b00000_11_00000_00000_1_11_00000_1111111,
          resp : '{accept : 1'b1, writeback : 1'b1, register_read : {1'b1, 1'b1, 1'b1}},
          opcode : NMSUB_RS3_R4
      },
      '{
          // Custom Add Multi rs1 : cus_add rd, rs1, rs1
          instr:
          32'b00000_00_00000_00000_0_00_00000_1001111,  // NMADD opcode
          mask: 32'b00000_11_00000_00000_1_11_00000_1111111,
          resp : '{accept : 1'b1, writeback : 1'b1, register_read : {1'b1, 1'b1, 1'b1}},
          opcode : NMADD_RS3_R4
      }
  };

  parameter int unsigned NbCompInstr = 2;
  parameter copro_compressed_resp_t CoproCompInstr[NbCompInstr] = '{
      // C_NOP
      '{
          instr : 16'b111_0_00000_00000_00,
          mask : 16'b111_1_00000_00000_11,
          resp : '{accept : 1'b1, instr : 32'b00000_00_00000_00000_0_00_00000_1111011}
      },
      '{
          instr : 16'b111_1_00000_00000_00,
          mask : 16'b111_1_00000_00000_11,
          resp : '{accept : 1'b1, instr : 32'b00000_00_00000_00000_0_01_01010_1111011}
      }
  };

endpackage
