.bss
my_string: .skip 12

.text
.align 4
.globl _start
_start:
    li a0, 0
    la a1, my_string
    li a2, 10
    li a7, 63
    ecall
    mv s0, a0
    li a0, 1
    la a1, my_string
    sb zero, 1(a1)
    li a2, 10
    li a7, 64
    ecall
    j _start