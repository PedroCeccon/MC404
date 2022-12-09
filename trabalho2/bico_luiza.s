.text

.globl set_motor
.globl set_handbreak
.globl read_camera
.globl read_sensor_distance
.globl get_position
.globl get_rotation
.globl get_time
.globl filter_1d_image
.globl display_image
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl sleep
.globl approx_sqrt

set_motor:
    li a7, 10
    ecall
    ret

set_handbreak:
    li a7, 11
    ecall
    ret

read_camera:
    li a7, 12
    ecall
    ret

read_sensor_distance:
    li a7, 13
    ecall
    ret

get_position:
    li a7, 15
    ecall
    ret

get_rotation:
    li a7, 16
    ecall
    ret

get_time:
    li a7, 20
    ecall
    ret


filter_1d_image:
    ret

display_image:
    li a7, 19
    ecall
    ret

puts:
    //a0 endereço da string
    mv a4, a0
    mv t1, a0
    puts1:
    lb t0, 0(t1)
    beq t0, zero, end_puts
    mv a1, t1
    li a0, 1
    li a2, 1
    li a7, 18
    ecall
    addi t1, t1, 1
    j puts1
    end_puts:
    li t2, 10
    addi sp, sp, -16
    sb t2, 0(sp)
    mv a1, sp
    li a0, 1
    li a2, 1
    li a7, 18
    ecall
    addi sp, sp, 16
    mv a0, a4
    ret

gets:
    //a0 o endereço do buffer
    mv a4, a0
    mv t1, a0
    gets1:
    li a0, 0
    mv a1, t1
    li a2, 1
    li a7, 17
    ecall
    lb t2, 0(t1)
    li t3, 10
    beq t2, t3, end_gets
    addi t1, t1, 1
    j gets1
    end_gets:
    sb zero, 0(t1)
    mv a0, a4
    ret

atoi:
    // a0 = buffer
    // 0x20 0x9 0xa 0xd
    //checa se for +
    //checa se for -
    addi t2, zero, '0'
    li a4, 0
    li a5, 10

    atoi1:
    lbu t1, 0(a0)

    li t3, 0xd
    beq t1, t3, nextByte1
    li t3, 0xa
    beq t1, t3, nextByte1
    li t3, 0x9
    beq t1, t3, nextByte1
    li t3, 0x20
    beq t1, t3, nextByte1
    li t3, '+'
    beq t1, t3, nextByte2
    li t3, '-' 
    beq t1, t3, nextByteNeg
    atoi2:
    lbu t1, 0(a0)
    li t3, '0'
    blt t1, t3, end_atoi
    li t3, '9'
    blt t3, t1, end_atoi

    numero:
    sub t1, t1, t2
    mul a4, a4, a5
    add a4, a4, t1
    j nextByte2

    nextByte1:
    addi a0, a0, 1
    j atoi1

    nextByte2:
    addi a0, a0, 1
    j atoi2

    nextByteNeg:
    li t4, 1
    addi a0, a0, 1
    j atoi2

    end_atoi:
    mv a0, a4
    li t3, 1
    beq t4, t3, negativo
    ret

    negativo:
    li t3, -1
    mul a0, a0, t3
    ret


itoa:
//a0 num, a1 end, a2 base
    mv a6, a1
    mv t0, a0
    li t1, 0

    li t2, 10
    beq a2, t2, deci
    li t2, 16
    beq a2, t2, hex

    deci:
    beq t0, zero, end_itoa
    li t2, 10

    rem a4, t0, t2 
    div t0, t0, t2 // valor da divisão
    //  valor do resto da divisão

    addi a4, a4, '0'
    addi sp, sp, -16
    sb a4, 0(sp)
    addi t1, t1, 1 // computando o tamanho da string

    j deci

    hex:
    beq t0, zero, end_itoa
    li t2, 16
    rem a4, t0, t2
    div t0, t0, t2
    

    li t3, 9
    bgt a4, t3, singleChar
    addi a4, a4, '0'
    j end_hex

    singleChar:
    addi a4, a4, 87
    j end_hex

    end_hex:
    addi sp, sp, -16
    sb a4, 0(sp)
    addi t1, t1, 1

    j hex

    end_itoa:
    mv a5, t1

    itoa1: 
    // iteração para carregar o caractere, calcular e adicionar o offset
    // e depois salvar novamente o caractere
        lbu t4, 0(sp)
        addi sp, sp, 16

        sb t4, 0(a1)
        addi a1, a1, 1

        addi a5, a5, -1
        blt zero, a5, itoa1

        loop_itoa_end:
        lbu t4, 0(a1)
        beqz t4, end_itoa2
        sb zero, 0(a1)
        addi a1, a1, 1
        j loop_itoa_end

    end_itoa2:
        
    mv a0, a6
    ret

sleep: //valor em a0
    mv t0, a0 // tempo alvo
    li a7, 20 //get_time
    ecall
    mv t1, a0 //tempo atual
    add t2, t1, t0

    time1:
    bge a0, t2, end_time1
    li a7, 20 //get_time
    ecall
    j time1

    end_time1:
    ret

approx_sqrt: //numero em a0 e iterações em a1
    li t5, 0
    li s0, 2
    divu s2, a0, s0 // k = y/2

    for:
    bge t5, a1, end_if
    divu s3, a0, s2 // y/k
    add s4, s2, s3 // k + y/k
    divu s5, s4, s0 // k' = (k + y/k)/2
    mv s2, s5
    addi t5, t5, 1
    j for

    end_if:
    mv a0, s2
    ret

