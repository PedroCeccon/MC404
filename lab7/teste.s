.data
y: .byte 0x1


.text
.set x, 0x50
.globl _start
_start:
    li a0, x
    a:
    la a0, y
    lb a0, 0(a0)
    c:
    add a0, a0, zero