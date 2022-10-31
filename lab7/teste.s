
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data
my_string: .skip 12
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
    la a0, my_string 
    jal gets

    la a0, my_string 
    jal puts

    la a0, my_string 
    jal atoi

    mv s0, a0
    la a1, my_string
    li a2, 16
    jal itoa

    la a0, my_string
    jal puts

    li a0, 5000
    jal sleep

    mv a0, s0
    li a1, 20
    jal approx_sqrt

    mv s0, a0
    la a1, my_string
    li a2, 10
    jal itoa

    la a0, my_string
    jal puts

    li a0, 0
    jal exit

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
    li t3, 0xa
    li t4, 0x20
1:
    lb t0, 0(s0)
    addi s0, s0, 1
    beq t0, t3, 12
    beq t0, t4, 8
    j 1b
    mv a0, s0
    mv a1, s1
    mv a2, s2
    la a3, w
    jal imageFilter
    j exit


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


open:
    la a0, input_file       # endereço do caminho para o arquivo
    li a1, 0                # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0                # modo
    li a7, 1024             # syscall open 
    ecall
    ret
