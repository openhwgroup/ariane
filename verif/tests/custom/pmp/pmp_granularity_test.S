#*****************************************************************************
# pmp_granularity_test.S (TST01)
#-----------------------------------------------------------------------------
    .text
    .globl main
main:

# Configure PMP to find its granularity 

    # Write all zeroes in cfg0.
    li t0, 0
    csrw pmpcfg0, t0

    # Write all ones in addr0.
    li t1, -1
    csrw pmpaddr0, t1

    # Read the value back.
    csrr t2, pmpaddr0

    # Check for granularity 8 = 2^(1+2) <=> G = 1.
    # As per: https://docs.openhwgroup.org/projects/cva6-user-manual/01_cva6_user/PMP.html
    # Which states: The PMP grain is 2**G+2. Only a PMP granularity of 8 bytes (G=1) is supported in CVA6.
    # And from the RISC-V Spec: G is the index of the least-significant bit set, the PMP granularity is 2^(G+2) bytes.
    li t3, 0xFFFFFFFE
    bne t2, t3, fail

pass:
    # Success post-processing
    li a0, 0x0;
    jal exit;

fail:
    # Failure post-processing
    li a0, 0x1;
    jal exit;
