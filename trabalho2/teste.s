.bss
my_string: .skip 12

.text
.align 4
.globl main
main:
    li a0, 0
    la a1, my_string
    li a2, 10
    li a7, 17
    ecall
    mv s0, a0
    li a0, 1
    la a1, my_string
    li a2, 10
    li a7, 18
    ecall
    li a7, 20
    ecall
    mv s1, a0
    j main  