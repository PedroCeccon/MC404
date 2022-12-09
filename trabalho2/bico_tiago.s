.globl set_motor
set_motor:
    li a7, 10
    ecall
ret

.globl set_handbreak
set_handbreak:
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

.globl get_time
get_time:
    li a7, 20
    ecall
ret

.globl filter_1d_image
filter_1d_image:
    # a0: img
    # a1: filter

    li t0, 1
    li t1, 254
    la t6, filter_buffer

    1:

    li t4, 0
    lb t2, -1(a0)
    lb t3, 0(a1)
    mul t4, t3, t2
    lb t2, 0(a0)
    lb t3, 1(a1)
    mul t5, t3, t2
    add t4, t4, t5
    lb t2, 1(a0)
    lb t3, 2(a1)
    mul t5, t3, t2
    add t4, t4, t5
    sb t4, 0(t6)

    addi a0, a0, 1
    addi t6, t6, 1

    addi t0, t0, 1
    bne t0, t1, 1b 

    la a0, filter_buffer

    # Mout[i][j] = S(q=0->2) w[q] * Min[i][j + q - 1]
ret

.globl display_image
display_image:
    mv t0, a0

    li a0, 256      # width
    li a1, 1        # height
    li a7, 2201     # syscall
    ecall

    mv a0, t0

    li a7, 19
    ecall
ret

.globl puts
puts:
    li a7, 18
    mv a1, a0
    li a0, 1

    mv t1, a1
    li a2, 0
    1:
    lbu t0, 0(t1)
    addi t1, t1, 1
    beq t0, zero, 2f
    addi a2, a2, 1
    j 1b

    2:
    
    ecall

    la a1, line_break
    li a2, 1
    ecall

    li a0, 0
ret

.globl gets
gets:
    add a1, a0, zero

    li a2, 1
    li a7, 17

    li t1, '\n'
    li t2, 127

    mv t3, a0
    1:
    li a0, 0
    ecall
    lb t0, 0(a1)
    beq t0, t1, 2f
    blt t0, zero, 2f
    bgt t0, t2, 2f
    addi a1, a1, 1
    j 1b

    2:
    li t0, 0
    sb t0, 0(a1)
    mv a0, t3

ret

.globl atoi
atoi:
    add t1, a0, zero
    1:
    lb a0, 0(t1)
    addi t1, t1, 1
    mv t2, a0
    
    li t0, 0x20
    beq a0, t0, 1f
    li t0, 0x9
    beq a0, t0, 1f
    li t0, 0xa
    beq a0, t0, 1f
    li t0, 0xb
    beq a0, t0, 1f
    li t0, 0xc
    beq a0, t0, 1f
    li t0, 0xd
    beq a0, t0, 1f
    li a0, 0
    j 2f

    1:
    li a0, 1

    2:
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

ret

is_space:
    li t0, 0x20
    beq a0, t0, 1f
    li t0, 0x9
    beq a0, t0, 1f
    li t0, 0xa
    beq a0, t0, 1f
    li t0, 0xb
    beq a0, t0, 1f
    li t0, 0xc
    beq a0, t0, 1f
    li t0, 0xd
    beq a0, t0, 1f
    li a0, 0
    ret

    1:
    li a0, 1

ret

.globl itoa
itoa:

    add t1, sp, zero
    add t2, a1, zero
    
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

    2:
    lw t0, 0(sp)
    addi sp, sp, 16
    blt t0, t3, 12
    addi t0, t0, 87
    j 8
    addi t0, t0, 48
    sb t0, 0(t2)
    addi t2, t2, 1
    bne sp, t1, 2b

    li t0, 0
    sb t0, 0(t2)
    mv a0, a1

ret

.globl sleep
sleep:
    add t3, a0, zero
    li t4, -1
    
    addi sp, sp, -16
    mv a0, sp
    mv a1, zero
    li a7, 20
    ecall
    lw t0, 0(sp)
    lw t1, 8(sp)
    addi sp, sp, 16
    li t2, 1000
    mul t0, t0, t2
    div t1, t1, t2
    add a0, t0, t1

    bgtz a0, 8
    mul a0, a0, t4
    add t3, t3, a0

    1:
    addi sp, sp, -16
    add a0, sp, zero
    li a1, 0
    li a7, 20
    ecall
    lw t0, 0(sp)
    lw t1, 8(sp)
    addi sp, sp, 16
    li t2, 1000
    mul t0, t0, t2
    div t1, t1, t2
    add a0, t0, t1

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

    1:
    div t2, a0, t1
    add t1, t1, t2
    srli t1, t1, 1
    addi t0, t0, 1
    bne a1, t0, 1b
    add a0, t1, zero
ret

testee: .string "foi\n"
line_break: .byte '\n'

.section .bss
.align 4
filter_buffer: .skip 256