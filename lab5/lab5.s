#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.bss
input_adress: .skip 0x14    # buffer que armazena a string de entrada
.align 2
output_adress: .skip 0x14   # buffer que armazena a string para a escrita
.align 2

.text
.globl _start
_start:
    li s6, 0                # controla se ainda deve ser calculada a raiz de algum numero
    la t4, output_adress    # guarda o endereco onde deve ser armazenado o proximo byte (char)
    jal read
loop:
    li t0, 0                
    li s1, 1000             # digito decimal mais significativo
    li s2, 10               # base
    li s3, 0x20             # char " "
    li s4, 0xa              # char "\n"
    jal getValue            # t0 = y

    li s0, 1                # contador de iteracoes
    li s1, 10               # quantidade de iteracoes
    srli t1, t0, 1          # t1 = k -> [y/2]
    jal sqrt                # t1 = sqrt(t0)

    li s1, 1000             # digito decimal mais significativo
    jal storeString         
    j loop

read:
    li a0, 0                # file descriptor = 0 (stdin)
    la a1, input_adress     # buffer
    li a2, 0x14             # size (lendo apenas 1 byte, mas tamanho é variável)
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

getValue:
    lb s0, 0(a1)            # pega o valor do proximo byte (char) da string
    addi a1, a1, 1          # atualiza a posicao da string
    beq s0, s4, 28          # confere se o char lido eh o "\n", se for significa que esse eh o ultimo valor lido
    beq s0, s3, 28          # confere se o char lido eh o " ", se for significa que esse numero ja foi convertido integralmente
    addi s0, s0, -48        # transforma o char para o valor numerico do digito
    mul s0, s0, s1          # multiplica o valor do digito pela sua posicao
    add t0, t0, s0          
    div s1, s1, s2 
    j getValue
    li s6, 1                
    ret

storeString:
    div t0, t1, s1
    mul t2, s1, t0
    sub t1, t1, t2
    div s1, s1, s2
    add t0, t0, 48
    sb t0, 0(t4)
    addi t4, t4, 1
    bne s1, zero, storeString
    bgtz s6, 16
    sb s3, 0(t4)
    addi t4, t4, 1
    ret
    sb s4, 0(t4)
    j write

 sqrt:
    div t2, t0, t1
    add t1, t1, t2
    srli t1, t1, 1
    addi s0, s0, 1
    bne s0, s1, sqrt
    ret