#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data
input_file: .asciz "imagem.pgm"
MAXsize: .word 262159

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
fillMatrix:
    li a2, 0xff
    lbu t2, 0(s0)
    addi s0, s0, 1
    slli t2, t2, 8
    add a2, a2, t2
    slli t2, t2, 8
    add a2, a2, t2
    slli t2, t2, 8
    add a2, a2, t2
    jal setPixel
    addi t1, t1, 1
    bne t1, s2, fillMatrix
    coluna:
    li t1, 0
    addi t0, t0, 1
    bne t0, s1, fillMatrix
    jal exit


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
    lw a2, MAXsize                 # size (lendo apenas 1 byte, mas tamanho é variável)
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