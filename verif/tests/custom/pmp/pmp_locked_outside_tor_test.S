#*****************************************************************************
# pmp_locked_outside_tor_test.S (TST16-26, TST16-36)
#-----------------------------------------------------------------------------
    .text
    .globl main
main:

    # Set up a PMP entry using TOR, from 0x0000_0000 to 0x0010_0000 
    li t0, 0x00040000 
    csrw pmpaddr0, t0
    # From 0x0010_0000 to 0x0020_0000 no permissions
    li t0, 0x00080000 
    csrw pmpaddr1, t0
    # From 0x0020_0000 to 0x0026_0000 read-write
    li t0, 0x00098000 
    csrw pmpaddr2, t0

    # Configure the TOR areas with LOCK ON
    li t0, 0x008b888c
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail
    
    # Check a memory access succeeds when outside the LOCKED entry.
    li t1, 0x00270000
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
