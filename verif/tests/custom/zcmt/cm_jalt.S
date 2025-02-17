.globl _start
_start:
	la t0, trap_handler
	csrw mtvec, t0

    la a1, target1
    la t0, __jvt_base$

    sw a1, 128(t0)       //cm.jalt entry start from index >=32

    csrw  jvt, t0

    fence.i
    # Perform jump using the index from JVT
    cm.jalt 32

    li t1, 1
    addi x20,x20, 9
    j write_tohost




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

# Target Addresses (Where cm.jalt will jump)
target0:
    li x5, 99
    j write_tohost   
target1:
    li x2, 99
    j write_tohost 

target2:
    addi x2,x20, 5
    j write_tohost                 
                  

trap_handler:
	j exit


.align 6;   .global tohost;   tohost:   .dword 0;
.align 6;   .global fromhost; fromhost: .dword 0;
