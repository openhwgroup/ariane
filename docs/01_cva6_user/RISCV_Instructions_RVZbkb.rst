..
   Copyright (c) 2023 OpenHW Group
   Copyright (c) 2023 10xEngineers

   SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

.. Level 1
   =======

   Level 2
   -------

   Level 3
   ~~~~~~~

   Level 4
   ^^^^^^^

.. _cva6_riscv_instructions_RV32Zbkb:

*Applicability of this chapter to configurations:*

.. csv-table::
   :widths: auto
   :align: left
   :header: "Configuration", "Implementation"

   "CV32A60AX", "Implemented extension"
   "CV64A6_MMU", "Implemented extension"

=============================
RVZbkb: Bitmanip instructions for Cryptography
=============================

The following instructions comprise the Zbkb extension:

Pack instructions
--------------------
The Pack instructions can be implemented by packing the lower halves of both source operands into the destination register for pack and packw instructions and by packing the lower bytes of the source operands into the destination register for packh.

+-----------+-----------+-----------------------+
| RV32      | RV64      | Mnemonic              |
+===========+===========+=======================+
| ✔         | ✔         | pack rd, rs1, rs2     |
+-----------+-----------+-----------------------+
| ✔         | ✔         | packh rd, rs1, rs2    |
+-----------+-----------+-----------------------+
|           | ✔         | packw rd, rs1, rs2    |
+-----------+-----------+-----------------------+

RV32 and RV64 Instructions
~~~~~~~~~~~~~~~~~~~~~~~~~~


- **PACK**: Pack low halves of registers

    **Format**: pack rd, rs1, rs2

    **Description**: This instruction packs the lower halves of rs1 and rs2 into rd, with rs1 in the lower half and rs2 in the upper half.

    **Pseudocode**: X(rd) = X(rs2)[XLEN/2-1..0] @ X(rs1)[XLEN/2-1..0];

    **Invalid values**: NONE

    **Exception raised**: NONE

- **PACKH**: Pack low bytes of registers

    **Format**: packh rd, rs1, rs2 

    **Description**: This instruction packs the least-significant bytes of rs1 and rs2 into the 16 least-significant bits of rd, zero extending the rest of rd.

    **Pseudocode**: X(rd) = EXTZ(X(rs2)[7..0] @ X(rs1)[7..0]);

    **Invalid values**: NONE

    **Exception raised**: NONE

RV64 specific instructions
~~~~~~~~~~~~~~~~~~~~~~~~~~	

- **PACKW**: Pack low 16-bits of registers

    **Format**: packw rd, rs1, rs2

    **Description**: This instruction packs the low 16 bits of rs1 and rs2 into the 32 least-significant bits of rd, sign extending the 32-bit result to the rest of rd.

    **Pseudocode**: X(rd) = EXTS(X(rs2)[15..0] @ X(rs1)[15..0]);

    **Invalid values**: NONE

    **Exception raised**: NONE


Zip instructions
--------------------------------
These instructions are used to extract bits from the source registers and interleave them into the destination register.

+-----------+-----------+-----------------------+
| RV32      | RV64      | Mnemonic              |
+===========+===========+=======================+
| ✔         |           | zip rd, rs            |
+-----------+-----------+-----------------------+
| ✔         |           | unzip rd, rs          |
+-----------+-----------+-----------------------+

RV32 specific Instructions
~~~~~~~~~~~~~~~~~~~~~~~~~~

- **ZIP**: Zip

    **Format**: zip rd, rs 

    **Description**: This instruction places bits in the low half of the source register into the even bit positions of the destination, and bits in the high half of the source register into the odd bit positions of the destination. It is the inverse of the unzip instruction.

    **Pseudocode**: foreach (i from 0 to 15) {
                        X(rd)[i << 1] = X(rs1)[i]
                        X(rd)[i+1 << 1] = X(rs1)[i+16] 
                    }

    **Invalid values**: NONE

    **Exception raised**: NONE

- **UNZIP**: Unzip

    **Format**: unzip rd, rs 

    **Description**: This instruction places the even bits of the source register into the low half of the destination, and the odd bits of the source into the high bits of the destination. It is the inverse of the zip instruction.

    **Pseudocode**: foreach (i from 0 to 15) {
                        X(rd)[i] = X(rs1)[i << 1]
                        X(rd)[i+16] = X(rs1)[i+1 << 1]
                    }

    **Invalid values**: NONE

    **Exception raised**: NONE


Bits-in-Byte-reverse
------------
brev8 reverses the bits in each byte of the source register.

+-----------+-----------+-----------------------+
| RV32      | RV64      | Mnemonic              |
+===========+===========+=======================+
| ✔         | ✔         | brev8 rd, rs          |
+-----------+-----------+-----------------------+

RV32 and RV64 Instructions
~~~~~~~~~~~~~~~~~~~~~~~~~~

- **BREV8**: Reverse bits in bytes

    **Format**:  brev8 rd, rs

    **Description**: This instruction reverses the order of the bits in every byte of a register.

    **Pseudocode**: foreach (i from 0 to xlen by 8) {
                        foreach (j from 0 to 7) {
                            X(rd)[(i<<3)+j] = X(rs)[(i<<3)+(7-j)];
                        }
                    }

    **Invalid values**: NONE

    **Exception raised**: NONE
