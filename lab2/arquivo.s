.globl _start
 

.bss
z: .skip 4

.data
x: .word 10

.section .rodata
msg: .asciz "ola"

.section ".ola"
make:
    li t0, 16

.section ".oie"
    li t1, 16

.text

_start:
    csrrwi a5, 0x7b1, 3

    li a1, 0x11108
    jalr a0, 4(a1)
    .word 15
    fence.i
    fence r, rw
    li a0, 247327  #<<<=== RA
    li a1, 0
    li a2, 0
    li a3, -1
    lb a4, -20(a1)
    srai a1, a1, 2
    fence
loop:
    jal a0, _start
    andi t0, a0, 1
    add  a1, a1, t0
    xor  a2, a2, t0
    addi a3, a3, 1
    srli a0, a0, 1
    bnez a0, loop
end:
    la a0, result
    sw a1, 0(a0)
    li a0, 0
    li a7, 93
    ecall
    ebreak
result:
    .word 0
