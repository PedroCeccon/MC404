#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.bss
input_adress: .skip 0x20    # buffer que armazena a string de entrada
output_adress: .skip 0xc   # buffer que armazena a string para a escrita
# variaveis
Yb: .skip 0x4
Xc: .skip 0x4
Ta: .skip 0x4
Tb: .skip 0x4
Tc: .skip 0x4
Tr: .skip 0x4
da: .skip 0x4
db: .skip 0x4
dc: .skip 0x4
y: .skip 0x4
x: .skip 0x4

.text
.globl _start

_start:
    li t0, 47               
    li t1, 0x2d             # '-'
    li t2, 0x20             # ' '
    li t3, 0xa              # '\n'
    li t4, 0x2b             # '+'
    la s0, Yb               # o endereco da primeira variavel
    li s1, 1
    li s2, 5                
    li s3, 0                # valores lidos
    li s4, -1
    
    jal read
signal:                     # le o sinal do valor de entrada
    lb t4, 0(a1)
    addi a1, a1, 1
value:                      # le o valor absoluto da entrada
    li s8, 1000
    li s9, 10
    li t6, 0
    jal getValue
    addi s3, s3, 1
    sw t6, 0(s0)
    addi s0, s0, 4
    li t4, 0x2b
    bgt s3, s2, 12
    bgt s3, s1, value
    j signal

    lw t0, Tr
    la t1, Ta
    la t2, da
    li t3, 3
    li t4, 10
    li t5, 0

    jal getDistance         # calcula as distrancias e salva nos espacos da memoria reservados para elas

    jal getY                # calcula y e salva no espaco da memoria reservados para ele

    jal getX                # calcula x e salva no espaco da memoria reservados para ele


    la a1, output_adress
    li a2, 1000
    li a3, 10
    lw a0, x
    jal storeString         # salva o valor de x como uma string no endereco reservado para a string de saida do programa
    li t0, 0x20
    sb t0, 0(a1)
    addi a1, a1, 1
    li a2, 1000
    lw a0, y                # salva o valor de y como uma string no endereco reservado para a string de saida do programa
    jal storeString
    li t0, 0xa
    sb t0, 0(a1)

    jal write               # escreve a sring de sauda no terminal

    j exit

getValue:
    lb t5, 0(a1)            # pega o valor do proximo byte (char) da string
    addi a1, a1, 1          # atualiza a posicao da string
    bgt t5, t0, 16
    bne t4, t1, 8
    mul t6, t6, s4
    ret
    addi t5, t5, -48        # transforma o char para o valor numerico do digito
    mul t5, t5, s8          # multiplica o valor do digito pela sua posicao
    add t6, t6, t5        
    div s8, s8, s9
    j getValue

getDistance:                # d = [(Tr - T)*3]/10
    lw t6, 0(t1)
    addi t1, t1, 4
    sub t6, t0, t6
    mul t6, t6, t3
    div t6, t6, t4
    sw t6, 0(t2)
    addi t2, t2, 4
    addi t5, t5, 1
    blt t5, t3, getDistance
    ret

getY:                       # y = (da² + Yb² - db²)/(2*Yb)
    lw t0, da
    lw t1, Yb
    lw t2, db
    li t3, 2
    mul t6, t0, t0
    mul t4, t1, t1
    add t6, t6, t4
    mul t4, t2, t2
    sub t6, t6, t4
    mul t4, t1, t3
    div t6, t6, t4
    la t0, y
    sw t6, 0(t0)
    ret

getX:                   # x = +-sqrt(da²-y²)
    lw t0, da
    mul a0, t0, t0
    lw t1, y
    mul t1, t1, t1
    sub a0, a0, t1
    jal a2, sqrt
    li t1, -1
    mul a0, a1, t1      # a1 -> x = +sqrt(da²-y²); a0 -> x = -sqrt(da²-y²)
                        # confere qual dos dois valores esta mais proximo do esperado a partir de: (x - Xc)² + y² = dc²
    lw t4, Xc           # t4 = Xc
    lw t5, y
    mul t5, t5, t5      # t5 = y²
    lw t6, dc
    mul t6, t6, t6      # t6 = dc²

    add t0, a0, zero
    add t1, a1, zero

    sub t0, t0, t4
    sub t1, t1, t4

    mul t0, t0, t0
    mul t1, t1, t1

    add t0, t0, t5
    add t1, t1, t5
    
    sub t0, t0, t6
    sub t1, t1, t6

    li t2, -1
    bge t0, zero, 8
    mul t0, t0, t2
    bge t1, zero, 8
    mul t1, t1, t2

    la s1, x
    blt t0, t1, 12
    sw a1, 0(s1)
    ret
    sw a0, 0(s1)
    ret

sqrt:                       # a0 = y; a1 = k  (k = sqrt(y))
    li s0, 1                # contador de iteracoes
    li s1, 21               # quantidade de iteracoes
    srli a1, a0, 1          # a1 = k -> [y/2]
iteracao:
    div s3, a0, a1
    add a1, a1, s3
    srli a1, a1, 1
    addi s0, s0, 1
    bne s0, s1, iteracao
    jr a2

storeString:
    bge a0, zero, 20
    li t0, 0x2d
    li t1, -1
    mul a0, a0, t1
    j 8
    li t0, 0x2b
    sb t0, 0(a1)
    addi a1, a1, 1
getDigit:
    div a4, a0, a2
    mul t2, a4, a2
    sub a0, a0, t2
    div a2, a2, a3
    add a4, a4, 48
    sb a4, 0(a1)
    addi a1, a1, 1
    bne a2, zero, getDigit
    ret

read:
    li a0, 0                # file descriptor = 0 (stdin)
    la a1, input_adress
    li a2, 0x20
    li a7, 63               # syscall read (63)
    ecall
    ret

write:
    li a0, 1                # file descriptor = 1 (stdout)
    la a1, output_adress    # buffer
    li a2, 0x14             # size
    li a7, 64               # syscall write (64)
    ecall
    j exit

exit:
    li a0, 0                # exit code = 0  (no error)
    li a7, 93               # syscall exit (93)
    ecall    