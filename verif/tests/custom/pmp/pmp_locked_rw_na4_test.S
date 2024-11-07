#*****************************************************************************
# pmp_locked_rw_na4_test.S (TST12-24, TST12-34)
#-----------------------------------------------------------------------------
    .text
    .globl main
main:

# Configure PMP

    # Area 0, at 0x0020_0000 read and write 
    li t0, 0x00200000 
    csrw pmpaddr0, t0

    # Area 1, at 0x0030_0000 read and write 
    li t0, 0x00300000
    csrw pmpaddr1, t0

    # Area 2, at 0x0070_0000 read and write 
    li t0, 0x00700000
    csrw pmpaddr2, t0

    # Area 3, at 0x0080_0000 read and write 
    li t0, 0x00800000
    csrw pmpaddr3, t0


    # Area 4, at 0x4000_0000 read and write 
    li t0, 0x40000000
    csrw pmpaddr4, t0

    # Area 5, at 0x6000_0000 read and write 
    li t0, 0x60000000
    csrw pmpaddr5, t0

    # Area 6, at 0xE000_0000 read and write 
    li t0, 0xE0000000
    csrw pmpaddr6, t0

    # Area 7, at 0xF000_0000 read and write 
    li t0, 0xF0000000
    csrw pmpaddr7, t0


    # Area 0-3 configs, written in cfg0, with LOCK ON, and NA4.
    li t0, 0x93939393
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail

    # Area 5-8 configs, written in cfg1, with LOCK ON, and NA4.
    li t0, 0x93939393
    csrw pmpcfg1, t0
    csrr t1, pmpcfg1
    bne t0, t1, fail


# Do the READ-WRITE test

    # Area 1 read-write test, at 0x0020_0000
    li t1, 0x00200000
    li t2, 0xEFFACED1
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Area 2 read-write test, at 0x0030_0000
    li t1, 0x00300000
    li t2, 0xACCEDED2
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Area 3 read-write test, at 0x0070_0000
    li t1, 0x00700000
    li t2, 0xDEFACED3
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Area 4 read-write test, at 0x0080_0000
    li t1, 0x00800000
    li t2, 0xEC0C1DE4
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Area 5 read-write test, at 0x4000_0000
    li t1, 0x40000000
    li t2, 0xBACCAE05
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Area 6 read-write test, at 0x6000_0000
    li t1, 0x60000000
    li t2, 0xC0FFEE06
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Area 7 read-write test, at 0xE000_0000
    li t1, 0xE0000000
    li t2, 0x0FF1CE07
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # Area 8 read-write test, at 0xF000_0000
    li t1, 0xF0000000
    li t2, 0xDABBED08
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
