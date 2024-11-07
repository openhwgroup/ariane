#*****************************************************************************
# pmp_defined_matches_test.S (TST10-1, TST10-2)
#-----------------------------------------------------------------------------
    .text
    .globl main
main:

    # Check a memory access succeeds if no PMP entry is defined.
    li t1, 0x00200000
    li t2, 0xC0D1F1ED
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Set up a PMP entry using NAPOT, from 0x0021_0000 to 0x0028_0000, read and write 
    li t0, 0x000cffff
    csrw pmpaddr0, t0
    csrr t1, pmpaddr0
    bne t0, t1, fail
    li t0, 0x0000001b
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail

    # Check a memory access succeeds if no PMP entry matches.
    li t1, 0x00208000
    li t2, 0xCA5CADED
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
