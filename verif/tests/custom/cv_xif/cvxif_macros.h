// Copyright 2022 Thales DIS design services SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Zineb EL KACIMI (zineb.el-kacimi@external.thalesgroup.com)
// Contributor : Guillaume Chauvon

# Add user macros, routines in this file

# Mappings of custom_* mnemonics to .insn pseudo-op of GAS


# CUS_ADD rd, rs1, rs2 -> .insn r CUSTOM_3, 0x1, 0x0, rd, rs1, rs2
.macro  cus_add rd, rs1, rs2
    .insn r CUSTOM_3, 0x1, 0x0, \rd, \rs1, \rs2
.endm

# CUS_NOP -> .insn r CUSTOM_3, 0x0, 0x0, x0, x0, x0
.macro  cus_nop
    .insn r CUSTOM_3, 0x0, 0x0, x0, x0, x0
.endm

# CUS_DOUBLE_RS1 rd, rs1, rs2 -> .insn r CUSTOM_3, 0x1, 0x1, rd, rs1, rs2
.macro  cus_double_rs1 rd, rs1, rs2
    .insn r CUSTOM_3, 0x1, 0x1, \rd, \rs1, \rs2
.endm

# CUS_DOUBLE_RS2 rd, rs1, rs2 -> .insn r CUSTOM_3, 0x1, 0x2, rd, rs1, rs2
.macro  cus_double_rs2 rd, rs1, rs2
    .insn r CUSTOM_3, 0x1, 0x2, \rd, \rs1, \rs2
.endm

# CUS_ADD_MULTI rd, rs1, rs2 -> .insn r CUSTOM_3, 0x1, 0x3, rd, rs1, rs2
.macro  cus_add_multi rd, rs1, rs2
    .insn r CUSTOM_3, 0x1, 0x3, \rd, \rs1, \rs2
.endm

# CUS_ADD_RS3_MADD rd, rs1, rs2, rs3 -> .insn r MADD, 0x0, 0x0, rd, rs1, rs2, rs3
.macro  cus_add_rs3_madd rd, rs1, rs2, rs3
    .insn r MADD, 0x0, 0x0, \rd, \rs1, \rs2, \rs3
.endm

# CUS_ADD_RS3_MSUB rd, rs1, rs2, rs3 -> .insn r MSUB, 0x0, 0x0, rd, rs1, rs2, rs3
.macro  cus_add_rs3_msub rd, rs1, rs2, rs3
    .insn r MSUB, 0x0, 0x0, \rd, \rs1, \rs2, \rs3
.endm

# CUS_ADD_RS3_NMADD rd, rs1, rs2, rs3 -> .insn r NMADD, 0x0, 0x0, rd, rs1, rs2, rs3
.macro  cus_add_rs3_nmadd rd, rs1, rs2, rs3
    .insn r NMADD, 0x0, 0x0, \rd, \rs1, \rs2, \rs3
.endm

# CUS_ADD_RS3_NMSUB rd, rs1, rs2, rs3 -> .insn r NMSUB, 0x0, 0x0, rd, rs1, rs2, rs3
.macro  cus_add_rs3_nmsub rd, rs1, rs2, rs3
    .insn r NMSUB, 0x0, 0x0, \rd, \rs1, \rs2, \rs3
.endm

# CUS_ADD_RS3_RTYPE rs3, rs1, rs2 -> .insn r MADD, 0x1, 0x4, rs3, rs1, rs2
.macro  cus_add_rs3_rtype rs1, rs2, rs3
    .insn r MADD, 0x1, 0x4, \rs3, \rs1, \rs2
.endm

# CUS_CNOP -> .insn cr 0x0, 0xe, x0, x0
.macro  cus_cnop
    .insn cr 0x0, 0xe, x0, x0
.endm

# CUS_CADD rs1, rs2 -> .insn cr 0x0, 0xf, rs1, rs2
.macro  cus_cadd rs1, rs2
    .insn cr 0x0, 0xf, \rs1, \rs2
.endm