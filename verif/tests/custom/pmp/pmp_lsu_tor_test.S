#*****************************************************************************
# pmp_lsu_tor_test.S (TST16-11, TST16-21, TST16-31)
#-----------------------------------------------------------------------------
    .text
    .globl main
main:

# Configure PMP using TOR

    # From 0x0000_0000 to 0x0010_0000 only execute
    li t0, 0x00040000 
    csrw pmpaddr0, t0

    # From 0x0010_0000 to 0x0020_0000 no permissions
    li t0, 0x00080000 
    csrw pmpaddr1, t0

    # From 0x0020_0000 to 0x0028_0000 read-write
    li t0, 0x000a0000 
    csrw pmpaddr2, t0

    # From 0x0028_0000 to 0x0030_0000 no permissions
    li t0, 0x000c0000 
    csrw pmpaddr3, t0

    # From 0x0030_0000 to 0x0038_0000 read-write-execute
    li t0, 0x000e0000 
    csrw pmpaddr4, t0

    # From 0x0038_0000 to 0x0070_0000 no permissions
    li t0, 0x001c0000 
    csrw pmpaddr5, t0

    # From 0x0070_0000 to 0x0070_1000 read-write
    li t0, 0x001c0400 
    csrw pmpaddr6, t0

    # From 0x0070_1000 to 0x0080_0000 no permissions
    li t0, 0x00200000 
    csrw pmpaddr7, t0

    # From 0x0080_0000 to 0x00C0_0000 read-write-execute
    li t0, 0x00300000 
    csrw pmpaddr8, t0

    # From 0x00C0_0000 to 0x4000_0000 no permissions
    li t0, 0x10000000 
    csrw pmpaddr9, t0

    # From 0x4000_0000 to 0x4000_7000 read-write
    li t0, 0x10001c00 
    csrw pmpaddr10, t0

    # From 0x4000_7000 to 0x6000_0000 no permissions
    li t0, 0x18000000 
    csrw pmpaddr11, t0

    # From 0x6000_0000 to 0xE004_1000 read-write
    li t0, 0x38010400 
    csrw pmpaddr12, t0

    # From 0xE004_1000 to 0xF000_0000 no permissions
    li t0, 0x3c000000 
    csrw pmpaddr13, t0

    # From 0xF000_0000 to 0xF000_4000 read-write-execute
    li t0, 0x3c001000 
    csrw pmpaddr14, t0

    # From 0xF000_4000 to 0xFFFF_FFFF no permissions
    li t0, 0x3fffffff 
    csrw pmpaddr15, t0

    # Addr 0-3 configs, written in cfg0, with LOCK OFF, and TOR.
    li t0, 0x080b080c
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail

    # Addr 4-7 configs, written in cfg1, with LOCK OFF, and TOR.
    li t0, 0x080b080f
    csrw pmpcfg1, t0
    csrr t1, pmpcfg1
    bne t0, t1, fail

    # Addr 8-11 configs, written in cfg2, with LOCK OFF, and TOR.
    li t0, 0x080b080f
    csrw pmpcfg2, t0
    csrr t1, pmpcfg2
    bne t0, t1, fail

    # Addr 12-15 configs, written in cfg3, with LOCK OFF, and TOR.
    li t0, 0x080f080b
    csrw pmpcfg3, t0
    csrr t1, pmpcfg3
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

# Do the EXEC "RET" test    
    
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
