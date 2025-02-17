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
    j target2

exit:
    j write_tohost

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
target0:
    j write_tohost   
target1:
     addi x6,x0, 7
     j write_tohost

target2:
    addi x2,x20, 5
    j write_tohost                 
                  

trap_handler:
	j exit


.align 6;   .global tohost;   tohost:   .dword 0;
.align 6;   .global fromhost; fromhost: .dword 0;
