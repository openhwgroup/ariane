# ------------------------------------------------------------------------------
#   Copyright 2024 Robert Bosch GmbH
#
#   SPDX-License-Identifier: SHL-0.51
#
#   Original Author: Konstantinos LEVENTOS - Robert Bosch France SAS
# ------------------------------------------------------------------------------
#   pmp_cv32a65x_locked_outside_napot_test.S (TST14-26, TST14-36)
# ------------------------------------------------------------------------------
    
    .text
    .globl main
main:

    # Set up PMP using NAPOT, from 0x8000_0000 to 0xB000_0000. 
    li t2, 0x25ffffff
    csrw pmpaddr0, t2

    # Configure it with LOCK ON, Read-Write-Execute.
    li t0, 0x0000009f
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail

    # Check pmpaddr after switching to NAPOT (and lock)
    csrr t0, pmpaddr0
    bne t0, t2, fail

    # Check a memory access succeeds when outside the LOCKED entry.
    li t1, 0xB8000000
    li t2, 0xC0D1F1ED
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail


pass:
    # Success post-processing
    li a0, 0x0;
    jal exit;

fail:
    # Failure post-processing
    li a0, 0x1;
    jal exit;
