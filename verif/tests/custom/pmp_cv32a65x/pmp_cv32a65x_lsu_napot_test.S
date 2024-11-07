# ------------------------------------------------------------------------------
#   Copyright 2024 Robert Bosch GmbH
#
#   SPDX-License-Identifier: SHL-0.51
#
#   Original Author: Konstantinos LEVENTOS - Robert Bosch France SAS
# ------------------------------------------------------------------------------
#   pmp_cv32a65x_lsu_napot_test.S (TST14-11, TST14-21, TST14-31)
# ------------------------------------------------------------------------------
    
    .text
    .globl main
main:

    # Configure PMP using NAPOT.

    # From 0x0000_0000 to 0x0000_1000 only Execute.
    li t0, 0x000001ff
    csrw pmpaddr0, t0

    # From 0x0001_0000 to 0x0002_0000 only Execute.
    li t0, 0x00005fff 
    csrw pmpaddr1, t0

    # From 0x8000_0000 to 0xC000_0000 Read-Write-Execute.
    li t0, 0x27ffffff 
    csrw pmpaddr2, t0


    # Addr 0-2 configs, written in cfg0, with LOCK OFF, and NAPOT.
    li t0, 0x001f1c1c
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail


    # Do the READ-WRITE test.

    # Check 1 read-write test, at 0x8000_0000.
    li t1, 0x80000000
    li t2, 0xEFFACED1
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Check 2 read-write test, at 0x9000_0000.
    li t1, 0x90000000
    li t2, 0xACCEDED2
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Check 3 read-write test, at 0xA000_0000.
    li t1, 0xA0000000
    li t2, 0xDEFACED3
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Check 4 read-write test, at 0xB000_0000.
    li t1, 0xB0000000
    li t2, 0xDEC0DED4
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail


    # Do the EXEC "RET" test.    
    
    # Exec test 1, at 0x0000_0800.
    li t0, 0x00000800
    li t1, 0x8082
    sw t1, 0(t0)
    lw t2, 0(t0)
    bne t1, t2, fail
    jalr t0

    # Exec test 2, at 0x0001_8000.
    li t0, 0x00018000
    li t1, 0x8082
    sw t1, 0(t0)
    lw t2, 0(t0)
    bne t1, t2, fail
    jalr t0

    # Exec test 3, at 0x9800_0000.
    li t0, 0x98000000
    li t1, 0x8082
    sw t1, 0(t0)
    lw t2, 0(t0)
    bne t1, t2, fail
    jalr t0

    # Exec test 4, at 0xA800_0000.
    li t0, 0xA8000000
    li t1, 0x8082
    sw t1, 0(t0)
    lw t2, 0(t0)
    bne t1, t2, fail
    jalr t0
    

pass:
    # Success post-processing
    li a0, 0x0;
    jal exit;

fail:
    # Failure post-processing
    li a0, 0x1;
    jal exit;
