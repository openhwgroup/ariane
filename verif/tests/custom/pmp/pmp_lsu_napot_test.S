#*****************************************************************************
# pmp_lsu_napot_test.S (TST14-11, TST14-21, TST14-31)
#-----------------------------------------------------------------------------
    .text
    .globl main
main:

# Configure PMP

    # Area 0, from 0x0000_0000 to 0x0010_0000, execute only
    li t0, 0x0001ffff
    csrw pmpaddr0, t0

    # Area 1, from 0x0020_0000 to 0x0028_0000, read and write 
    li t0, 0x0008ffff
    csrw pmpaddr1, t0

    # Area 2, from 0x0030_0000 to 0x0038_0000, exec, read and write 
    li t0, 0x000cffff
    csrw pmpaddr2, t0

    # Area 3, from 0x0070_0000 to 0x0070_1000, read and write 
    li t0, 0x001c01ff
    csrw pmpaddr3, t0


    # Area 4, from 0x0080_0000 to 0x00C0_0000, exec, read and write 
    li t0, 0x0027ffff
    csrw pmpaddr4, t0

    # Area 5, from 0x4000_0000 to 0x4000_7000, read and write 
    li t0, 0x10000dff
    csrw pmpaddr5, t0

    # Area 6, from 0x6000_0000 to 0xE000_0000, read and write 
    li t0, 0x27ffffff
    csrw pmpaddr6, t0

    # Area 7, from 0xE000_0000 to 0xE004_1000, read and write 
    li t0, 0x380081ff
    csrw pmpaddr7, t0


    # Area 8, from 0xF000_0000 to 0xF000_4000, exec, read and write 
    li t0, 0x3c0007ff
    csrw pmpaddr8, t0


    # Area 0-3 configs, written in cfg0, with LOCK OFF, and NAPOT.
    li t0, 0x1b1f1b1c
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail

    # Area 4-7 configs, written in cfg1, with LOCK OFF, and NAPOT.
    li t0, 0x1b1b1b1f
    csrw pmpcfg1, t0
    csrr t1, pmpcfg1
    bne t0, t1, fail

    # Area 8 configs, written in cfg2, with LOCK OFF, and NAPOT.
    li t0, 0x0000001f
    csrw pmpcfg2, t0
    csrr t1, pmpcfg2
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
    
    # Exec test, at 0x00370000
    li t0, 0x00370000
    li t1, 0x8082
    sw t1, 0(t0)
    lw t2, 0(t0)
    bne t1, t2, fail
    jalr t0

    # Exec test, at 0x00B00000
    li t0, 0x00B00000
    li t1, 0x8082
    sw t1, 0(t0)
    lw t2, 0(t0)
    bne t1, t2, fail
    jalr t0

    # Exec test, at 0xF0003000
    li t0, 0xF0003000
    li t1, 0x8082
    sw t1, 0(t0)
    lw t2, 0(t0)
    bne t1, t2, fail
    jalr t0

    # Exec test, at 0x000F0000
    li t0, 0x000F0000
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
