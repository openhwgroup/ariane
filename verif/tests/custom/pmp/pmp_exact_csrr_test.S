#*****************************************************************************
# pmp_exact_csrr_test.S (TST05-1)
#-----------------------------------------------------------------------------
    .text
    .globl main
main:

# Write in addresses and check with csrr what is written 

    # Checking PMP ADDR 0
    li t0, 0xFACADE00
    csrw pmpaddr0, t0
    csrr t1, pmpaddr0
    bne t0, t1, fail
    csrw pmpaddr0, zero

    # Checking PMP ADDR 1
    li t0, 0xFACADE01
    csrw pmpaddr1, t0
    csrr t1, pmpaddr1
    bne t0, t1, fail
    csrw pmpaddr1, zero

    # Checking PMP ADDR 2
    li t0, 0xFACADE02
    csrw pmpaddr2, t0
    csrr t1, pmpaddr2
    bne t0, t1, fail
    csrw pmpaddr2, zero

    # Checking PMP ADDR 3
    li t0, 0xFACADE03
    csrw pmpaddr3, t0
    csrr t1, pmpaddr3
    bne t0, t1, fail
    csrw pmpaddr3, zero

    # Checking PMP ADDR 4
    li t0, 0xFACADE04
    csrw pmpaddr4, t0
    csrr t1, pmpaddr4
    bne t0, t1, fail
    csrw pmpaddr4, zero

    # Checking PMP ADDR 5
    li t0, 0xFACADE05
    csrw pmpaddr5, t0
    csrr t1, pmpaddr5
    bne t0, t1, fail
    csrw pmpaddr5, zero

    # Checking PMP ADDR 6
    li t0, 0xFACADE06
    csrw pmpaddr6, t0
    csrr t1, pmpaddr6
    bne t0, t1, fail
    csrw pmpaddr6, zero

    # Checking PMP ADDR 7
    li t0, 0xFACADE07
    csrw pmpaddr7, t0
    csrr t1, pmpaddr7
    bne t0, t1, fail
    csrw pmpaddr7, zero

    # Checking PMP ADDR 8
    li t0, 0xFACADE08
    csrw pmpaddr8, t0
    csrr t1, pmpaddr8
    bne t0, t1, fail
    csrw pmpaddr8, zero

    # Checking PMP ADDR 9
    li t0, 0xFACADE09
    csrw pmpaddr9, t0
    csrr t1, pmpaddr9
    bne t0, t1, fail
    csrw pmpaddr9, zero

    # Checking PMP ADDR 10
    li t0, 0xFACADE10
    csrw pmpaddr10, t0
    csrr t1, pmpaddr10
    bne t0, t1, fail
    csrw pmpaddr10, zero

    # Checking PMP ADDR 11
    li t0, 0xFACADE11
    csrw pmpaddr11, t0
    csrr t1, pmpaddr11
    bne t0, t1, fail
    csrw pmpaddr11, zero

    # Checking PMP ADDR 12
    li t0, 0xFACADE12
    csrw pmpaddr12, t0
    csrr t1, pmpaddr12
    bne t0, t1, fail
    csrw pmpaddr12, zero

    # Checking PMP ADDR 13
    li t0, 0xFACADE13
    csrw pmpaddr13, t0
    csrr t1, pmpaddr13
    bne t0, t1, fail
    csrw pmpaddr13, zero

    # Checking PMP ADDR 14
    li t0, 0xFACADE14
    csrw pmpaddr14, t0
    csrr t1, pmpaddr14
    bne t0, t1, fail
    csrw pmpaddr14, zero

    # Checking PMP ADDR 15
    li t0, 0xFACADE15
    csrw pmpaddr15, t0
    csrr t1, pmpaddr15
    bne t0, t1, fail
    csrw pmpaddr15, zero

# Write in configurations and check with csrr what is written, except for the reserved combinations with R=0 and W=1

    # Checking PMP CFG 0
    li t0, 0x01030304
    csrw pmpcfg0, t0
    csrr t1, pmpcfg0
    bne t0, t1, fail
    csrw pmpcfg0, zero

    # Checking PMP CFG 1
    li t0, 0x03030405
    csrw pmpcfg1, t0
    csrr t1, pmpcfg1
    bne t0, t1, fail
    csrw pmpcfg1, zero

    # Checking PMP CFG 2
    li t0, 0x03040505
    csrw pmpcfg2, t0
    csrr t1, pmpcfg2
    bne t0, t1, fail
    csrw pmpcfg2, zero

    # Checking PMP CFG 3
    li t0, 0x04050507
    csrw pmpcfg3, t0
    csrr t1, pmpcfg3
    bne t0, t1, fail
    csrw pmpcfg3, zero


pass:
    # Success post-processing
    li a0, 0x0;
    jal exit;

fail:
    # Failure post-processing
    li a0, 0x1;
    jal exit;
