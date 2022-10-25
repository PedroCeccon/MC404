#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data 
my_string: .skip 12
.byte 0

.text
.globl _start
_start:
    la a0, my_string
    jal gets
    jal atoi
    jal puts
    li a0, 0
    j exit

.globl puts
puts:
    li a2, 0
    1:
        lbu t0, 0(a0)
        addi a0, a0, 1
        beq t0, zero, 1f
        addi a2, a2, 1
        j 1b
    1:
    li t0, '\n'
    addi sp, sp, -16
    sb t0, 0(sp)
    li a0, 1
    la a1, my_string
    li a7, 64
    ecall
    li a0, 1
    mv a1, sp
    ecall
    addi sp, sp, 16
    ret

.globl gets
gets:
    mv a1, a0
    li a2, 1
    li a7, 63
    li t1, '\n'
    li t2, 127
    mv t3, a0
    1:
        li a0, 0
        ecall
        lb t0, 0(a1)
        beq t0, t1, 1f
        blt t0, zero, 1f
        bgt t0, t2, 1f
        addi a1, a1, 1
        j 1b
    1:
    li t0, 0
    sb t0, 0(a1)
    mv a0, t3
    ret

.globl atoi
atoi:
    addi sp, sp, -16
    sw ra, 0(sp)
    mv t1, a0
    1:
        lb a0, 0(t1)
        addi t1, t1, 1
        mv t2, a0
        jal isspace
        bne a0, zero, 1b

        li a0, 0
        li t0, 1
        li t3, 0x2d
        beq t2, t3, 1f
        li t3, 0x2b
        beq t2, t3, 2f
        j 3f
    1:
        li t0, -1
    2:
        lb t2, 0(t1)
        addi t1, t1, 1
    3:
        li t3, 0x30
        li t4, 0x39
        li t5, 10
    1:
        blt t2, t3, 1f
        bgt t2, t4, 1f
        mul a0, a0, t5
        sub t2, t2, t3
        add a0, a0, t2
        lb t2, 0(t1)
        addi t1, t1, 1
        j 1b
    1:
        mul a0, a0, t0
        lw ra, 0(sp)
        addi sp, sp, 16
        ret

isspace:
    li t0, 0x20
    beq a0, t0, 4f
    li t0, 0x9
    beq a0, t0, 4f
    li t0, 0xa
    beq a0, t0, 4f
    li t0, 0xb
    beq a0, t0, 4f
    li t0, 0xc
    beq a0, t0, 4f
    li t0, 0xd
    beq a0, t0, 4f
    li a0, 0
    ret
    4:
    li a0, 1
    ret

.globl exit
exit:
    li a7, 93               # syscall exit (93)
    ecall