
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.text
.globl puts
puts:
    li a2, 0
    mv a1, a0
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

.globl itoa
itoa:
    mv t1, sp
    mv t2, a1
    li t3, 10
    bgtz a0, 1f
        li t0, -1
        mul a0, a0, t0
        bne a2, t3, 1f
            li t0, 0x2d
            sb t0, 0(t2)
            addi t2, t2, 1
    1:
        rem t0, a0, a2
        addi sp, sp, -16
        sw t0, 0(sp)
        div a0, a0, a2
        bne a0, zero, 1b
    1:
        lw t0, 0(sp)
        addi sp, sp, 16
        blt t0, t3, 12
        addi t0, t0, 87
        j 8
        addi t0, t0, 48
        sb t0, 0(t2)
        addi t2, t2, 1
        bne sp, t1, 1b
    li t0, 0
    sb t0, 0(t2)
    mv a0, a1
    ret

.globl time
time:
    addi sp, sp, -16
    mv a0, sp
    mv a1, zero
    li a7, 169
    ecall
    lw t0, 0(sp)
    lw t1, 8(sp)
    addi sp, sp, 16
    li t2, 1000
    mul t0, t0, t2
    div t1, t1, t2
    add a0, t0, t1
    ret

.globl sleep
sleep:
    addi sp, sp, -16
    sw ra, 0(sp)
    mv t3, a0
    li t4, -1
    jal time
    bgtz a0, 8
    mul a0, a0, t4
    add t3, t3, a0
    confere:
    1:
        jal time
        bgtz a0, 8
        mul a0, a0, t4
        blt a0, t3, 1b
    lw ra, 0(sp)
    addi sp, sp, 16
    ret

.globl approx_sqrt
approx_sqrt:
    li t3, 1
    bgt a0, t3, 8
    ret
    li t0, 1
    srli t1, a0, 1
iteration:
    div t2, a0, t1
    add t1, t1, t2
    srli t1, t1, 1
    addi t0, t0, 1
    bne a1, t0, iteration
    mv a0, t1
    ret

.globl imageFilter
imageFilter:
    addi sp, sp, -48
    sw ra, 44(sp)
    sw s0, 40(sp)
    sw s1, 36(sp)
    sw s2, 32(sp)
    sw s3, 28(sp)
    sw s4, 24(sp)
    sw s5, 20(sp)
    sw s6, 16(sp)
    sw s7, 12(sp)
    sw s8, 8(sp)
    sw s11, 4(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv a0, s1
    mv a1, s2
    jal setCanvasSize
    li t0, 0
    li t1, 0
    li t3, 0xff
    addi t4, s1, -1
    addi t5, s2, -1
fillMatrix:
    mv s3, s0
    mv s4, a3
    jal getColor
    jal setPixel
    addi t1, t1, 1
    bne t1, s2, fillMatrix
    li t1, 0
    addi t0, t0, 1
    bne t0, s1, fillMatrix
    lw s11, 4(sp)
    lw s8, 8(sp)
    lw s7, 12(sp)
    lw s6, 16(sp)
    lw s5, 20(sp)
    lw s4, 24(sp)
    lw s3, 28(sp)
    lw s2, 32(sp)
    lw s1, 36(sp)
    lw s0, 40(sp)
    lw ra, 44(sp)
    addi sp, sp, 32
    ret

getColor: 
    beq t0, zero, black
    beq t1, zero, black
    beq t0, t4, black
    beq t1, t5, black
    li s5, 0
    li s6, 0
    li t6, 0
    li s11, 3
    1:
        lb s7, 0(s4)
        addi s4, s4, 1
        add s8, t0, s6
        addi s8, s8, -1
        mul s8, s8, s1
        add s8, s8, t1
        add s8, s8, s5
        addi s8, s8, -1
        add s3, s0, s8
        lbu s8, 0(s3)
        mul s8, s8, s7
        add t6, t6, s8
        add s5, s5, 1
        blt s5, s11, 1b
        li s5, 0
        addi s6, s6, 1
        blt s6, s11, 1b
    ble t6, zero, black
    bge t6, t3, white
    mv a2, t6
    slli a2, a2, 8
    add a2, a2, t6
    slli a2, a2, 8
    add a2, a2, t6
    slli a2, a2, 8
    add a2, a2, t3
    ret
black:
    li a2, 0xff
    ret
white:
    li a2, 0xffffffff
    ret

setPixel:
    mv a0, t1               # coordenada x
    mv a1, t0               # coordenada y
    # a2                    # cor (RGBA)
    li a7, 2200             # syscall setPixel
    ecall
    ret

setCanvasSize:
    li a7, 2201             #syscall setCanvasSize
    ecall
    ret

.globl exit
exit:
    li a7, 93               # syscall exit (93)
    ecall