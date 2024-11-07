# ------------------------------------------------------------------------------
#   Copyright 2024 Robert Bosch GmbH
#
#   SPDX-License-Identifier: SHL-0.51
#
#   Original Author: Konstantinos LEVENTOS - Robert Bosch France SAS
# ------------------------------------------------------------------------------
#   pmp_cv32a65x_double_entries_test.S (TST04-2)
# ------------------------------------------------------------------------------

    .text
    .globl main
main:

    # Set up PMP using NAPOT, from 0xB000_0000 to 0xC000_0000, Read-Write.
    li t0, 0x2dffffff
    csrw pmpaddr6, t0
    csrr t1, pmpaddr6
    bne t0, t1, fail
    li t0, 0x001b0000
    csrw pmpcfg1, t0
    csrr t1, pmpcfg1
    bne t0, t1, fail

    # Set up PMP using NAPOT, from 0x8000_0000 to 0x9000_0000, Read-Write. 
    li t0, 0x21ffffff
    csrw pmpaddr2, t0
    csrr t1, pmpaddr2
    bne t0, t1, fail
    li t0, 0x001b0000
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail

    # Read-Write check in 0xB800_0000.
    li t1, 0xB8000000
    li t2, 0xC0D1F1ED
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Read-Write check in 0x8800_0000.
    li t1, 0x88000000
    li t2, 0xCA5CADED
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Check that all other addr / cfg are zero.
    csrr t0, pmpaddr0
    bne t0, zero, fail
    csrr t0, pmpaddr1
    bne t0, zero, fail
    csrr t0, pmpaddr3
    bne t0, zero, fail
    csrr t0, pmpaddr4
    bne t0, zero, fail
    csrr t0, pmpaddr5
    bne t0, zero, fail
    csrr t0, pmpaddr7
    bne t0, zero, fail


pass:
    # Success post-processing
    li a0, 0x0;
    jal exit;

fail:
    # Failure post-processing
    li a0, 0x1;
    jal exit;
