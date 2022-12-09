# --- .text --- #
.text
.align 4

.globl set_motor
set_motor:
    # a0: vertical
    # a1: horizontal
    li a7, 10
    ecall
    ret

.globl set_handbreak
set_handbreak:
    # a0: value to be set on handbreak
    li a7, 11
    ecall
    ret

.globl read_camera
read_camera:
    # a0: address to a 256 element vector that stores the values read from the luminosity sensor
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
    # a0: variable address that stores x position
    # a1: variable address that stores y position
    # a2: variable address that stores z position
    li a7, 15
    ecall
    ret

.globl get_rotation
get_rotation:
    # a0: variable address that stores x's euler angle
    # a1: variable address that stores y's euler angle
    # a2: variable address that stores z's euler angle
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
    # a0: array
    # a1: filter

    # adjusting stack
    addi sp, sp, -256
    mv a4, sp

    # loading filter
    lb t1, (a1)
    lb t2, 1(a1)
    lb t3, 2(a1)

    # first pixel
    lb t4, (a0)
    lb t5, 1(a0)

    mul t4, t1, t4
    mul t5, t2, t5

    add t4, t4, t5

    sb t4, (a4)
    addi a4, a4, 1

    # other pixels
    add t0, zero, a0
    li a2, 1
    li a3, 255
    
    loop_filter:
        lb t4, (t0)
        lb t5, 1(t0)
        lb t6, 2(t0)

        mul t4, t1, t4
        mul t5, t2, t5
        mul t6, t3, t6

        add t5, t4, t5
        add t5, t5, t6

        sb t5, 1(a4)
        addi a4, a4, 1

        addi t0, t0, 1
        addi a2, a2, 1
        blt a2, a3, loop_filter

    # final pixel
    addi t0, t0, -1
    lb t4, (t0)
    lb t5, 1(t0)

    mul t4, t1, t4
    mul t5, t2, t5

    add t4, t4, t5

    sb t4, 1(a4)
    addi a4, a4, 1

    # taking pixels from stack and placing them in the array
    addi a4, a4, -256
    li a2, 0
    li a3, 256

    loop_saving_pixels:
        lb t4, (a4)
        sb t4, (a0)

        addi a0, a0, 1
        addi a2, a2, 1
        blt a2, a3, loop_saving_pixels

    addi sp, sp, 256

    ret

.globl display_image
display_image:
    # a0: memmory address to the array that represents the line
    li a7, 19
    ecall
    ret

.globl puts
puts:
    mv a3, a0
    add t0, zero, a0

    putsWhile:
    lb t1, (t0) // loading next character

    beq t1, zero, putsEnd // checks if the character is null

    // displaying character on terminal
    li a0, 1
    add a1, zero, t0
    li a2, 1
    li a7, 18
    ecall

    addi t0, t0, 1

    j putsWhile

    putsEnd:
    li t1, '\n'

    // displaying character on terminal
    addi sp, sp, -16 // alocando espaço na pilha
    sb t1, 0(sp) // guardando caractere na pilha

    li a0, 1
    add a1, zero, sp
    li a2, 1
    li a7, 18
    ecall

    addi sp, sp, 16 // liberando espaço da pilha
    mv a0, a3

    ret

.globl gets
gets:
    add t0, zero, a0
    add t4, zero, a0

    getsWhile:
    // retrieving character
    li a0, 0 # file descriptor = 0 (stdin)
    add a1, zero, t0 # buffer
    li a2, 1 # size
    li a7, 17
    ecall

    lbu t1, 0(t0) // loading next character

    li t2, '\n' // if its new line
    beq t1, t2, getsEnd // checks the character

    li t2, 0 // if its null
    beq t1, t2, getsEnd // checks the character

    sb t1, 0(t0)

    addi t0, t0, 1

    j getsWhile

    getsEnd:
    sb zero, 0(t0)
    add a0, zero, t4
    ret

.globl atoi
atoi:
    // a0 = memory address
    addi t0, zero, 0 // registrador que vai guardar o número final
    addi t1, zero, 10 // t1 = 10
    addi t3, zero, '0'
    addi t5, zero, 0

    funcao:
        lbu t4, 0(a0) // t4 5, t4 1

        // intial confference
        li t2, 0x20 # se for espaço
        beq t4, t2, proximo // confere o caractere
        li t2, 0x9 # se for tab
        beq t4, t2, proximo // confere o caractere
        li t2, 0xa # se for lf
        beq t4, t2, proximo // confere o caractere
        li t2, 0xd # se for cr
        beq t4, t2, proximo // confere o caractere

        // secondary confference
        li t2, '+' # se for cr
        beq t4, t2, proximo // confere o caractere

        li t2, '-' # se for cr
        beq t4, t2, acionaNegativo // confere o caractere

        j outrasVerific

        acionaNegativo:
        addi t5, zero, 1

        outrasVerific:
        li t2, '9'
        blt t2, t4, end
        
        li t2, '0'
        blt t4, t2, end

        li t2, 1
        beq t5, t2, negativo // se for negativo

        // calculo para numero positivo
        sub t4, t4, t3 // transformando pra inteiro
        mul t0, t0, t1 // multiplica por 10
        add t0, t0, t4 // soma com o digito que vc ta pegando

        j proximo

        negativo:
        // calculo para numero negativo
        sub t4, t4, t3 // transformando pra inteiro
        mul t0, t0, t1 // multiplica por 10
        sub t0, t0, t4 // soma com o digito que vc ta pegando

        proximo:
        addi a0, a0, 1 // pega o próximo byte
        j funcao

    end:
        add a0, zero, t0 // colocando o número em a0
        ret


.globl itoa
itoa:
    // a0 = valor (int)
    // a1 = endereço da string
    // a2 = base (int)

    li a3, 0 // controle da pilha
    add t1, zero, a0

    verificaBase:
    li t0, 10
    beq a2, t0, decimal

    li t0, 16
    beq a2, t0, hexadecimal

    hexadecimal:
        beq t1, zero, itoaEnd

        rem t2, t1, t0 // resto da divisão pela base

        li t3, 10
        blt t2, t3, numeros // se for menor que 10
        addi t2, t2, 87 // se o número for maior ou igual a 10
        j empilhando

        numeros:
        // se for menor que 10
        addi t2, t2, '0'

        empilhando:
        addi sp, sp, -16 // alocando espaço na pilha
        sb t2, 0(sp) // guardando o caractere
        addi a3, a3, 1

        div t1, t1, t0 // dividindo pela base

        blt zero, t1, hexadecimal

    decimal:
        beq t1, zero, itoaEnd

        rem t2, t1, t0 // resto da divisão pela base
        addi t2, t2, '0' // transformando em char

        addi sp, sp, -16 // alocando espaço na pilha
        sb t2, 0(sp) // guardando o caractere
        addi a3, a3, 1

        div t1, t1, t0 // dividindo pela base

        blt zero, t1, decimal

    itoaEnd:
        add a4, zero, a3
        
        itoaWhile:
            lbu t3, 0(sp) // fazendo o load do caractere
            addi sp, sp, 16
            sub t4, a3, a4 // calculando offset
            add t4, t4, a1 // adicionando offset ao endereço da string
            sb t3, 0(t4) // salvando o caractere

            addi a4, a4, -1
            blt zero, a4, itoaWhile

        add t4, a3, a1
        li t3, 0
        sb t3, 0(t4) // salvando o caractere
        add a0, zero, a1
        ret

.globl sleep
sleep:
    add t0, zero, a0 // tempo da função

    # getting current time
    li a7, 20
    ecall

    add t1, zero, a0 // tempo inicial

    sleepWhile:
        # getting current time
        li a7, 20
        ecall

        add t2, zero, a0 // tempo atual
        sub t3, t2, t1 // delta tempo

        bge t3, t0, sleepEnd
        j sleepWhile

    sleepEnd:
    ret

.globl approx_sqrt
approx_sqrt:
    // a0 = entrada
    // a1 = numero de iteracoes

    add t0, zero, a0
    add t1, zero, a1
    li t2, 2

    sqrtLoop:
        div t3, a0, t0 // t3 = a0 / t0
        add t3, t3, t0 // t3 = t3 + t0
        div t0, t3, t2 // t3 = t3 / 2

        addi t1, t1, -1

        blt zero, t1, sqrtLoop

    add a0, zero, t0
    ret
