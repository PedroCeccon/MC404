#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data
input_file: .asciz "imagem.pgm"
MAXsize: .word 262144

.bss
imagem: .skip 262144
.align 2
headerLine: .skip 8
.align 2
size: .skip 4
linhas: .skip 2
colunas: .skip 2
.align 2

.text
.globl _start
_start:
    jal open

    jal s0, ignoreLine
    jal s0, ignoreLine

    jal s0, readLine
    jal s0, getSize
    jal setCanvasSize

    jal s0, ignoreLine
    
    jal s0, readImage

    jal read
    jal write
    j exit

getSize:
    li t6, 6

readImage:
    li t6, 6


ignoreLine:
    li t2, 0xa
    la a1, headerLine
    li a2, 1
    jal read
    lb t3, 0(a1)
    li a1, 1
    jal lseek
    confere:
    bne t3, t2, ignoreLine
    jr s0

readLine:
    li t0, 0
    li t1, 8
    li t2, 0xa
readByte:
    la a1, headerLine
    li a2, 1
    jal read
    li a1, 1
    jal lseek
    lb t3, 0(a1)
    beq t3, t2, 20
    addi t0, t0, 1
    beq t0, t1, 12
    addi a1, a1, 1
    j readByte
    jr s0

lseek:
    li a2, 1
    li a7, 62
    ecall
    ret

read:
    # a0                    # file descriptor
    # a1                    # buffer
    # a2                    # size (lendo apenas 1 byte, mas tamanho é variável)
    li a7, 63               # syscall read (63)
    ecall
    ret

write:
    li a0, 1                # file descriptor = 1 (stdout)
    #la a1, imagem           # buffer
    #li a2, 1              # size
    li a7, 64               # syscall write (64)
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
    # a0                    # coordenada x
    # a1                    # coordenada x
    # a2                    # cor (RGBA)
    li a7, 2200             # syscall setPixel
    ret

setCanvasSize:
    lh a0, colunas
    lh a1, linhas
    li a7, 2201             #syscall setCanvasSize
    ret