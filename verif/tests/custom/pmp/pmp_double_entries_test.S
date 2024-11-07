#*****************************************************************************
# pmp_double_entries_test.S (TST04-2)
#-----------------------------------------------------------------------------
    .text
    .globl main
main:

    # Set up a PMP entry using NAPOT, from 0x0025_0000 to 0x0028_0000, read and write 
    li t0, 0x00099fff
    csrw pmpaddr11, t0
    csrr t1, pmpaddr11
    bne t0, t1, fail
    li t0, 0x1b000000
    csrw pmpcfg2, t0
    csrr t1, pmpcfg2
    bne t0, t1, fail

    # Set up a PMP entry using NAPOT, from 0x0020_0000 to 0x0023_0000, read and write 
    li t0, 0x00085fff
    csrw pmpaddr3, t0
    csrr t1, pmpaddr3
    bne t0, t1, fail
    li t0, 0x1b000000
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail

    # Read-Write in 0x0021_0000
    li t1, 0x00210000
    li t2, 0xC0D1F1ED
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Read-Write in 0x0026_0000
    li t1, 0x00260000
    li t2, 0xCA5CADED
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Check that all other addr / cfg read to zero
    csrr t0, pmpaddr0
    bne t0, zero, fail
    csrr t0, pmpaddr1
    bne t0, zero, fail
    csrr t0, pmpaddr2
    bne t0, zero, fail
    csrr t0, pmpaddr4
    bne t0, zero, fail
    csrr t0, pmpaddr5
    bne t0, zero, fail
    csrr t0, pmpaddr6
    bne t0, zero, fail
    csrr t0, pmpaddr7
    bne t0, zero, fail
    csrr t0, pmpaddr8
    bne t0, zero, fail
    csrr t0, pmpaddr9
    bne t0, zero, fail
    csrr t0, pmpaddr10
    bne t0, zero, fail
    csrr t0, pmpaddr12
    bne t0, zero, fail
    csrr t0, pmpaddr13
    bne t0, zero, fail
    csrr t0, pmpaddr14
    bne t0, zero, fail
    csrr t0, pmpaddr15
    bne t0, zero, fail
    csrr t0, pmpcfg1
    bne t0, zero, fail
    csrr t0, pmpcfg3
    bne t0, zero, fail


pass:
    # Success post-processing
    li a0, 0x0;
    jal exit;

fail:
    # Failure post-processing
    li a0, 0x1;
    jal exit;
