#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data
input_file: .asciz "teste.txt"

.bss
file: .skip 20
.align 2

.text
.globl _start
_start:
    li t0, 6
    li t1, 1
    la t2, input_file
    lb t0, 0(t2)