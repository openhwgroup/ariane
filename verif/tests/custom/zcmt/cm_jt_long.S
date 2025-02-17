.globl _start
_start:
	la t0, trap_handler
	csrw mtvec, t0

    la a1, target1
    la t0, __jvt_base$

    sw a1, 0(t0)

    csrw  jvt, t0

    fence.i

    cm.jt 0                 # Perform jump using the index 0 from JVT

    addi x18,x18, 3

write_tohost:
   li   x1, 1
   la   t0, tohost
   sw   x1, 0(t0)
   j    write_tohost



# Jump Vector Table (JVT) Section
# Create a separate section for the JVT
.section .riscv.jvt, "ax" 
.align 6                    # Align the JVT on a 64-byte boundary (6 = 2^6 = 64)
__jvt_base$:
     .word 0x80000054
     .word 0x80000800
     .word 0x80000802
     .word 0x80000804

# Target Addresses (Where cm.jt will jump)
.align 20
target1:
    addi x6,x0, 6 
    la   t0, write_tohost       # Load upper 20 bits of target address into t0
    jalr   x0, 0(t0) 
                

trap_handler:
	lui    t0, %hi(write_tohost)        # Load upper 20 bits of target address into t0
    addi   t0, t0, %lo(write_tohost)    # Add the lower 12 bits to t0
    jalr   x0, 0(t0) 


.align 6;   .global tohost;   tohost:   .dword 0;
.align 6;   .global fromhost; fromhost: .dword 0;
