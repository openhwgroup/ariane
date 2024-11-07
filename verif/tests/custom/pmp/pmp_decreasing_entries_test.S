#*****************************************************************************
# pmp_decreasing_entries_test.S (TST04-4)
#-----------------------------------------------------------------------------
    .text
    .globl main
main:

# Configure PMP using 7 decreasing entries of TOR

    # From 0x0026_0000 to 0x0028_0000 read-write
    li t0, 0x000a0000 
    csrw pmpaddr6, t0

    # From 0x0025_0000 to 0x0026_0000 no permissions
    li t0, 0x00098000 
    csrw pmpaddr5, t0

    # From 0x0023_0000 to 0x0025_0000 read-write
    li t0, 0x00094000 
    csrw pmpaddr4, t0

    # From 0x0022_0000 to 0x0023_0000 no permissions
    li t0, 0x0008c000 
    csrw pmpaddr3, t0

    # From 0x0020_0000 to 0x0022_0000 read-write
    li t0, 0x00088000 
    csrw pmpaddr2, t0
                        
    # From 0x0010_0000 to 0x0020_0000 no permissions
    li t0, 0x00080000 
    csrw pmpaddr1, t0
    
    # From 0x0000_0000 to 0x0010_0000 only execute
    li t0, 0x00040000 
    csrw pmpaddr0, t0


    # Addr 4-6 configs, written in cfg1, with LOCK OFF, and TOR.
    li t0, 0x000b080b
    csrw pmpcfg1, t0

    # Addr 0-3 configs, written in cfg0, with LOCK OFF, and TOR.
    li t0, 0x080b080c
    csrw pmpcfg0, t0

# Do the READ-WRITE test

    # A read-write test at 0x0020_0000
    li t1, 0x00200000
    li t2, 0xEFFACED0
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # A read-write test at 0x0023_0000
    li t1, 0x00230000
    li t2, 0xEFFACED3
    sw t2, 0(t1)
    lw t3, 0(t1)
    bne t2, t3, fail

    # A read-write test at 0x0026_0000
    li t1, 0x00260000
    li t2, 0xEFFACED6
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
