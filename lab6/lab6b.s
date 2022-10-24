
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data
input_file: .asciz "imagem.pgm"
w:
.byte -1
.byte -1
.byte -1
.byte -1
.byte 8
.byte -1
.byte -1
.byte -1
.byte -1
.align 2

.bss
file: .skip 262159
.align 2
width: .skip 3
.align 2
height: .skip 3
.align 2

.text   
.globl _start
_start:
    jal open
    jal read
    li t3, 0xa
    li t4, 0x20
1:
    lb t0, 0(a1)
    addi a1, a1, 1
    beq t0, t3, 12
    beq t0, t4, 8
    j 1b

    jal readHeader
    addi s0, a1, 1
    jal setCanvasSize
    li t3, 0xa
    li t4, 0x20
1:
    lb t0, 0(s0)
    addi s0, s0, 1
    beq t0, t3, 12
    beq t0, t4, 8
    j 1b

    li t0, 0
    li t1, 0
    li t3, 0xff
    addi t4, s1, -1
    addi t5, s2, -1
fillMatrix:
    mv s3, s0
    la s4, w
    jal getColor
    jal setPixel
    addi t1, t1, 1
    bne t1, s2, fillMatrix
    li t1, 0
    addi t0, t0, 1
    bne t0, s1, fillMatrix
    jal exit

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

readHeader:
    la a2, width
    jal s0, getData
    mv s1, a0
    addi a1, a1, 1
    la a2, height
    mv s2, a0
    jal s0, getData
    ret

getData:
    li t1, 0
    mv t2, a2
    li t3, 0xa
    li t4, 0x20
1:
    lb t0, 0(a1)
    addi a1, a1, 1
    beq t0, t3, stringToInt
    beq t0, t4, stringToInt
    sb t0, 0(a2)
    addi a2, a2, 1
    addi t1, t1, 1
    j 1b

stringToInt:
    li a0, 0
    li t3, 1
    li t4, 10
2:
    addi a2, a2, -1
    lb t0, 0(a2)
    addi t0, t0, -48
    mul t0, t0, t3
    mul t3, t3, t4
    add a0, a0, t0
    bne a2, t2, 2b
    jr s0


read:
    # a0                    # file descriptor
    la a1, file                    # buffer
    li a2, 262159               # size (lendo apenas 1 byte, mas tamanho é variável)
    li a7, 63               # syscall read (63)
    ecall
    ret

exit:
    li a0, 0                # exit code = 0  (no error)
    li a7, 93               # syscall exit (93)
    ecall

open:
    la a0, input_file       # endereço do caminho para o arquivo
    li a1, 0                # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0                # modo
    li a7, 1024             # syscall open 
    ecall
    ret

setPixel:
    mv a0, t1               # coordenada x
    mv a1, t0               # coordenada y
    # a2                    # cor (RGBA)
    li a7, 2200             # syscall setPixel
    ecall
    ret

setCanvasSize:
    mv a0, s1
    mv a1, s2
    li a7, 2201             #syscall setCanvasSize
    ecall
    ret