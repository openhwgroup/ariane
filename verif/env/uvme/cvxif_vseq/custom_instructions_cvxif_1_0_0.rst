..
   Copyright (c) 2023 OpenHW Group

   Copyright (c) 2023 Thales DIS design services SAS


   SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

..

Custom Instruction to challenge CV-X-IF protocol
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This section describes some custom instruction, for stress or challenge the CV-X-IF protocol for the 3 implemented interfaces, it's just to interact with the cvxif agent.
Most instructions use opcode `CUSTOM_3`(0x7b, 0b111_1011).
Except for 4 of them using opcode `MADD, MSUB, NMADD, NMSUB`

- **CUS_NOP**: Custom No Operation

    **Format**: cus_nop -> |0000000000000000000000000|111_1011|

    **Description**: do nothing, it's just a hint instruction.

    **Pseudocode**: cus_nop

- **CUS_ADD**: Custom Add

    **Format**: cus_add rd, rs1, rs2 -> |0000000|rs2|rs1|001|rd|111_1011|

    **Description**: add register rs1 to rs2, and store the result in rd.

    **Pseudocode**: x[rd] = x[rs1] + x[rs2]

- **CUS_DOUBLE_RS1**: Custom Double RS1

    **Format**: cus_add rd, rs1, rs1 -> |0000001|rs2|rs1|001|rd|111_1011|

    **Description**: add register rs1 to rs1, and store the result in rd.
    Any rs2 value can be given. It should be ignored by CPU.
    Exists to check that register depedencies is well implemented in CPU.

    **Pseudocode**: x[rd] = x[rs1] + x[rs1]

- **CUS_DOUBLE_RS2**: Custom Double RS2

    **Format**: cus_add rd, rs2, rs2 -> |0000010|rs2|rs1|001|rd|111_1011|

    **Description**: add register rs2 to rs2, and store the result in rd.
    Any rs1 value can be given. It should be ignored by CPU.
    Exists to check that register depedencies is well implemented in CPU.

    **Pseudocode**: x[rd] = x[rs2] + x[rs2]

- **CUS_ADD_MULTI**: Custom Multicycle Add

    **Format**: addi rd, rs1, rs2 -> |0000011|rs2|rs1|001|rd|111_1011|

    **Description**: add register rs1 to rs2, and store the result in rd. Coprocessor should randomly delays the result

    **Pseudocode**: x[rd] = x[rs1] + x[rs2]

- **CUS_ADD_RS3_MADD**: Custom Add with RS3 opcode == MADD

    **Format**: addi rd, rs1, rs2, rs3 -> |rs3|00|rs2|rs1|000|rd|100_0011|

    **Description**: add register rs1, rs2 to rs3, and store the result in rd.

    **Pseudocode**: x[rd] = x[rs1] + x[rs2] + x[rs3]

- **CUS_ADD_RS3_MSUB**: Custom Add with RS3 opcode == MSUB

    **Format**: addi rd, rs1, rs2, rs3 -> |rs3|00|rs2|rs1|000|rd|100_0111|

    **Description**: subtract register rs2 and rs3 from rs1 and store the result in rd.

    **Pseudocode**: x[rd] = x[rs1] - x[rs2] - x[rs3]

- **CUS_ADD_RS3_NMADD**: Custom Add with RS3 opcode == NMADD

    **Format**: addi rd, rs1, rs2, rs3 -> |rs3|00|rs2|rs1|000|rd|100_1111|

    **Description**: add register rs1, rs2 to rs3, negate the sum, and store the result in rd.

    **Pseudocode**: x[rd] = ¬(x[rs1] + x[rs2] + x[rs3])

- **CUS_ADD_RS3_NMSUB**: Custom Add with RS3 opcode == NMSUB

    **Format**: addi rd, rs1, rs2, rs3 -> |rs3|00|rs2|rs1|000|rd|100_1011|

    **Description**: subtract register rs2 and rs3 from rs1, negate the difference, and store the result in rd.

    **Pseudocode**: x[rd] = ¬(x[rs1] - x[rs2] - x[rs3])

- **CUS_ADD_RS3_RTYPE**: Custom Add with RS3, rd is x10 (a0)

    **Format**: addi a0, rs1, rs2, rs3 -> |0000100|rs2|rs1|001|rs3|100_0011|

    **Description**: add register rs1, rs2 to rs3, and store the result in x10 (a0).

    **Pseudocode**: x[10] = x[rs1] + x[rs2] + x[rs3]

- **CUS_CNOP** : Custom Compressed NOP

    **Format**: cus_cnop -> |111|0|rs1|rs2|00|

    **Description**: Extends to CUS_NOP : do nothing, it's just a hint instruction.

    **Pseudocode**: cus_cnop

- **CUS_CADD** : Custom Compressed ADD

    **Format**: cus_cnop -> |111|1|rs1|rs2|00|

    **Description**: Extends to CUS_ADD rs1, rs2 -> x10 : Add rs1 + rs2 into x10 (a0).

    **Pseudocode**: cus_cadd
