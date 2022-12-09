
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.text
.align 4
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
    li a7, 18
    ecall
    li a0, 1
    li a2, 1
    mv a1, sp
    ecall
    addi sp, sp, 16
    ret

.globl gets
gets:
    mv a1, a0
    mv t4, a1
    li a2, 1
    li a7, 17
    li t1, '\n'
    li t2, 127
    mv t3, a0
    1:
        li a0, 0
        ecall
        mv a1, t4
        lb t0, 0(a1)
        beq t0, t1, 1f
        blt t0, zero, 1f
        bgt t0, t2, 1f
        addi a1, a1, 1
        addi t4, t4, 1
        j 1b
    1:
    li t0, 0
    sb t0, 0(a1)
    mv a0, t3
    .globl confere
    confere:
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

.globl get_time
get_time:
    li a7, 20
    ecall
    ret

.globl sleep
sleep:
    mv t3, a0
    li t4, -1
    li a7, 20
    ecall
    bgtz a0, 8
    mul a0, a0, t4
    add t3, t3, a0
    1:
        li a7, 20
        ecall
        bgtz a0, 8
        mul a0, a0, t4
        blt a0, t3, 1b
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

.globl set_motor
set_motor:
    li a7, 10
    ecall
    ret

.globl set_handbrek
set_handbrek:
    li a7, 11
    ecall
    ret

.globl read_camera
read_camera:
    li a7, 12
    ecall
    ret

.globl read_sensor_distance
read_sensor_distance:
    li a7, 13
    ecall
    ret

.globl get_position
get_position:
    li a7, 15
    ecall
    ret

.globl get_rotation
get_rotation:
    li a7, 16
    ecall
    ret

.globl filter_1d_image
filter_1d_image:
    # a0: image (256-byte array)
    # a1: filter (3-byte array)
    addi sp, sp, -256
    mv t6, sp
    addi t5, sp, 255
    mv t4, a0
    sb zero, 0(t6)
    addi t6, t6, 1
    addi t4, t4, 1
    1:
    addi t0, t4, -1
    lbu t1, 0(t0)
    lb t2, 0(a1)
    mul t3, t1, t2
    lbu t1, 1(t0)
    lb t2, 1(a1)
    mul t1, t1, t2
    add t3, t3, t1
    lbu t1, 2(t0)
    lb t2, 2(a1)
    mul t1, t1, t2
    add t3, t3, t1
    bltz t3, 2f
    li t1, 255
    bgt t3, t1, 3f
    2:
    li t3, 0
    j 4f
    3:
    li t3, 255
    4:
    sb t3, 0(t6)
    addi t6, t6, 1
    addi t4, t4, 1
    blt t6, t5, 1b
    sb zero, 0(t6)
    
    li t0, 0
    li t1, 256

    mv t3, sp
    1:
    lbu t2, 0(t3)
    sb t2, 0(a0)
    addi t3, t3, 1
    addi a0, a0, 1
    addi t0, t0, 1
    blt t0, t1, 1b
    addi sp, sp, 256
    ret

.globl display_image
display_image:
    li a7, 19
    ecall
    ret