.data
.align 4
my_string: .ascii "hello\n"

.text
.align 4
.globl main
main:
    li a0, 1
    la a1, my_string
    li a2, 10
    li a7, 18
    1:
    j 1b  