
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.set self_driving_car, 0xffff0100
.set set_engine_and_steering, 10
.set set_handbrek, 11
.set read_sensors, 12
.set get_position, 15

.bss
.align 4

ISR_stack: .skip 16
ISR_stack_end:
program_stack: .skip 16
program_stack_end:

.text
.align 4

Syscall_set_engine_and_steering:
    li t0, 1
    bgt a0, t0, 1f
    li t0, -1
    blt a0, t0, 1f
    li t0, 127
    bgt a1, t0, 1f
    li t0, -127
    blt a1, t0, 1f
    li t0, self_driving_car
    sb zero, 22(t0)
    sb a0, 21(t0)
    sb a1, 20(t0)
    li a0, 0
    j 12
    1:
    li a0, -1
    ret

Syscall_set_handbreak:
    li t0, 1
    bne a0, t0, 1f
    li t0, self_driving_car
    sb a0, 22(t0)
    1:
    ret

Syscall_read_sensors:
    li t0, self_driving_car
    li t1, 1
    sb t1, 1(t0)
    addi t0, t0, 24
    add t1, t0, 256
    1:
        lb a1, 0(t0)
        sb a1, 0(a0)
        addi t0, t0, 1
        addi a0, a0, 1
        blt t0, t1, 1b
    ret

Syscall_get_position:
    li t0, self_driving_car
    li t1, 1
    sb t1, 0(t0)
    lw a0, 10(t0)
    lw a1, 14(t0)
    lw a2, 18(t0)
    ret


int_handler:
  ###### Tratador de interrupções e syscalls ######
    csrrw sp, mscratch, sp
    addi sp, sp, -16   
    sw t0, 0(sp) 
    sw t1, 4(sp)
    sw ra, 8(sp)
  
  # <= Implemente o tratamento da sua syscall aqui
    li t0, set_engine_and_steering
    beq a7, t0, Syscall_set_engine_and_steering
    li t0, set_handbrek
    beq a7, t0, Syscall_set_handbreak
    li t0, read_sensors
    beq a7, t0, Syscall_read_sensors
    li t0, get_position
    beq a7, t0, Syscall_get_position

    csrr t0, mepc   # carrega endereço de retorno (endereço 
                    # da instrução que invocou a syscall)
    addi t0, t0, 4  # soma 4 no endereço de retorno (para retornar após a ecall) 
    csrw mepc, t0   # armazena endereço de retorno de volta no mepc

    lw ra, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16
    csrrw sp, mscratch, sp 
    mret            # Recuperar o restante do contexto (pc <- mepc)
  


.globl _start
_start:
    la sp, program_stack_end

    la t0, int_handler
    csrw mtvec, t0

    la t0, ISR_stack_end
    csrw mscratch, t0

    li t0, gpt
    li t1, 100
    sw t1, 8(t0)

    csrr t1, mie 
    li t2, 0x800
    or t1, t1, t2
    csrw mie, t1

    csrr t1, mstatus 
    ori t1, t1, 0x8 
    csrw mstatus, t1

    csrr t1, mstatus
    li t2, ~0x1800
    and t1, t1, t2
    csrw mstatus, t1

    la t0, user_main
    csrw mepc, t0

    mret 

# Escreva aqui o código para mudar para modo de usuário e chamar a função 
# user_main (definida em outro arquivo). Lembre-se de inicializar a 
# pilha do usuário para que seu programa possa utilizá-la.

.globl logica_controle
logica_controle:
    addi sp, sp, -16   
    sw ra, 0(sp)

    li a7, 15
    ecall

    jal goal
    bnez t3, 4f
    mv t0, a0
    mv t1, a2
    li t2, 73
    li t3, -19
    sub t5, t3, a2
    sub t6, t2, a0

    li a0, 1
    li a1, 0
    li a7, 10
    ecall
    li t2, 3
    1:
        li a7, 15
        ecall
        jal goal
        bnez t3, 4f
        sub a0, t0, a0
        sub a2, t1, a2
        mul t0, a0, t5
        mul t1, a2, t6
        add t0, t0, t1
        blt t0, t3, 1b
    li t0, 73
    mul t0, a0, t0
    li t1, -19
    mul t1, a2, t1
    add t0, t0, t1
    mv a1, t0
    li a0, 1
    li a7, 10
    li t1, 5
    blt t0, t1, 3f
    li t1, -350
        bge t0, t1, 1f
            li a1, -70
            j 3f
        1:
        li t1, 350
        ble t0, t1, 2f
            li a1, 70
            j 3f
        2:
            li t1, 5
            div a1, t0, t1
        3:
        ecall
    4:
    li a0, 1
    li a7, 11
    ecall
    lw ra 0(sp)
    addi sp, sp, 16
    ret

goal:
    li t3, 1
    addi t0, a0, -73
    addi t1, a2, 19
    mul t0, t0, t0
    mul t1, t1, t1
    add t0, t0, t1
    li t2, 225
    bgt t0, t2, 1f
    li t3, 0
    1:
    ret

  # implemente aqui sua lógica de controle, utilizando apenas as 
  # syscalls definidas.
