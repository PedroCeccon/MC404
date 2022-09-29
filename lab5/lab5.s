.bss
input_adress: .skip 0x14 # buffer
.align 2
output_adress: .skip 0x14
.align 2

.text
.globl _start
_start:
    li s6, 0
    la t4, output_adress
    jal read
    li t0, 0
    li s1, 10
    li s2, 10
    li s3, 0x20
    li s4, 0xa
    jal getValue
    li s0, 1
    li s1, 10
    srli t1, t0, 1      # t1 = k -> [y/2]
    jal sqrt
    confere:
    li a1, 16

read:
    li a0, 0            # file descriptor = 0 (stdin)
    la a1, input_adress #  buffer
    li a2, 0x14            # size (lendo apenas 1 byte, mas tamanho é variável)
    li a7, 63           # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_adress       # buffer
    li a2, 0x14          # size
    li a7, 64           # syscall write (64)
    ecall
    ret

getValue:
    lb s0, 0(a1)
    confere_s:
    addi a1, a1, 1
    beq s0, s4, 28
    beq s0, s3, 28
    addi s0, s0, -48
    mul s0, s0, s1
    add t0, t0, s0
    div s1, s1, s2
    j getValue
    li s6, s6, 1
    ret
    

 sqrt:
    div t2, t0, t1
    add t1, t1, t2
    srli t1, t1, 1
    addi s0, s0, 1
    bne s0, t1, sqrt
    ret