#*****************************************************************************
# pmp_locked_outside_napot_test.S (TST14-26, TST14-36)
#-----------------------------------------------------------------------------
    .text
    .globl main
main:

    # Set up a PMP entry using NAPOT, from 0x0021_0000 to 0x0028_0000 
    li t0, 0x000cffff
    csrw pmpaddr0, t0
    csrr t1, pmpaddr0
    bne t0, t1, fail

    # Configure it with LOCK ON, read-write.
    li t0, 0x0000009b
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail
    
    # Check a memory access succeeds when outside the LOCKED entry.
    li t1, 0x00200000
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
