.bss
.align 4
pilha: .skip 1024
end_pilha:

.text
.align 4

.set base_timer, 0xFFFF0100
.set base_carro, 0xFFFF0300 
.set base_port, 0xFFFF0500
.set base_canvas, 0xFFFF0700

.globl _start
int_handler:

    csrrw sp, mscratch, sp # Troca sp com mscratch
    addi sp, sp, -32 # Aloca espaço na pilha da ISR

    sw t0, 0(sp) 
    sw t1, 4(sp) 
    sw t2, 8(sp)  
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    sw t6, 24(sp)

    li t0, 10
    beq a7, t0, Syscall_set_motor

    li t0, 11
    beq a7, t0, Syscall_set_handbreak

    li t0, 12
    beq a7, t0, Sycall_read_sensors

    li t0, 13
    beq a7, t0, Syscall_read_sensor_distance

    li t0, 15
    beq a7, t0, Syscall_get_position

    li t0, 16
    beq a7, t0, Syscall_get_rotation

    li t0, 17
    beq a7, t0, Syscall_read

    li t0, 18
    beq a7, t0, Syscall_write

    li t0, 19
    beq a7, t0, Syscall_draw_line

    li t0, 20
    beq a7, t0, Syscall_get_systime

    Syscall_get_systime:
        li t0, base_timer
        li t1, 1
        sb t1, 0(t0)
        lw a0, 0x04(t0)
        j continua

    Syscall_set_motor:
        li t0, 2
        blt a0, t0, conferesentido
        j invalido
        conferesentido:
            li t0, -1 
            bge a0, t0, confereangulo
            j invalido
        confereangulo:
            li t0, 128
            blt a1, t0, confereangulo2
            j invalido
        confereangulo2:
            li t0, -127 
            bge a1, t0, valido
            j invalido
        valido:
            li t0, base_carro
            sb a0, 0x21(t0)
            sb a1, 0x20(t0)
            li a0, 0
            j continua
        invalido: 
            li a0, -1
            j continua

    Syscall_set_handbreak:
        li t0, 1
        bne t0, a0, continua
        li t0, base_carro
        sb a0, 0x22(t0)
        j continua

    Sycall_read_sensors:
        li t0, base_carro
        li t1, 1
        sb t1, 0x01(t0)

        busy_waiting_sensores:
            lb t1, 0x01(t0)
            bne t1, zero, busy_waiting_sensores

        #como armazenar no vetor
        li t0, base_carro
        li t1, 0
        li t3, 256
        guarda_vetor:
            lb t2, 0x24(t0)
            sb t2, 0(a0)
            addi t1, t1, 1
            addi t0, t0, 1
            addi a0, a0, 1
            blt t1, t3, guarda_vetor

        j continua

    Syscall_read_sensor_distance:
        li t0, base_carro
        li t1, 2
        sb t1, 0x02(t0)

        busy_waiting_distancia:
            lb t1, 0x02(t0)
            bne t1, zero, busy_waiting_distancia

        #como armazenar no vetor
        li t0, base_carro
        lw a0, 0x1C(t0)
        j continua

    Syscall_get_position:
        li t0, base_carro
        li t1, 1
        sb t1, 0x00(t0)

        busy_waiting_posicao:
            lb t1, 0x00(t0)
            bne t1, zero, busy_waiting_posicao

        li t0, base_carro
        lw t1, 0x10(t0)
        sw t1, 0(a0)

        lw t1, 0x14(t0)
        sw t1, 0(a1)

        lw t1, 0x18(t0)
        sw t1, 0(a2)
        j continua

    Syscall_get_rotation:
        li t0, base_carro
        li t1, 1
        sb t1, 0x00(t0)

        busy_waiting_rotacao:
            lb t1, 0x00(t0)
            bne t1, zero, busy_waiting_rotacao

        li t0, base_carro
        lw t1, 0x04(t0)
        sw t1, 0(a0)

        lw t1, 0x08(t0)
        sw t1, 0(a1)

        lw t1, 0x0C(t0)
        sw t1, 0(a2)
        j continua

    Syscall_read: #p que servem os parametros?
        li t0, base_port
        li t1, 1
        sb t1, 0x02(t0)
        li t2, 0
        li t4, 0
        blt t2, a2, trigger
        j final

        trigger:
            li t1, 1
            sb t1, 0x02(t0)

        busy_waiting_read:
            lb t1, 0x02(t0)
            bne t1, zero, busy_waiting_read

        lb t1, 0x03(t0)
        li t3, 0x00
        bne t1, t3, grava
        bnez t4, final
        j trigger

        grava:
        li t4, 1
            addi t2, t2, 1
            sb t1, 0(a1)
            addi a1, a1, 1
            blt t2, a2, trigger
            j final
        final:
            mv a0, t2
        j continua

    Syscall_write:
        li t0, base_port
        li t2, 0

        loop_write:
            lb t1, 0(a1)
            addi a1, a1, 1
            sb t1, 0x01(t0)

            li t1, 1
            sb t1, 0x00(t0)

            busy_waiting_write:
                lb t1, 0x00(t0)
                bne t1, zero, busy_waiting_write

            addi t2, t2, 1
            blt t2, a2, loop_write

        j continua

    Syscall_draw_line:
        j continua


    continua:
        csrr t0, mepc  # carrega endereço de retorno (endereço 
                        # da instrução que invocou a syscall)
        addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall) 
        csrw mepc, t0  # armazena endereço de retorno de volta no mepc
                        # Recuperar o restante do contexto (pc <- mepc)
        
        lw t0, 0(sp) 
        lw t1, 4(sp) 
        lw t2, 8(sp)  
        lw t3, 12(sp)
        lw t4, 16(sp)
        lw t5, 20(sp)
        lw t6, 24(sp)

        addi sp, sp, 32
        csrrw sp, mscratch, sp # Troca sp com mscratch
     
        mret
    

.globl _start
_start:
    la t0, end_pilha
    csrw mscratch, t0

    la t0, int_handler  # Carregar o endereço da rotina que tratará as interrupções
    csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar
                        # o vetor de interrupções.

    # Escreva aqui o código para mudar para modo de usuário 

    li sp, 0x07FFFFFC 

    csrr t1, mstatus # Update the mstatus.MPP
    li t2, ~0x1800 # field (bits 11 and 12)
    and t1, t1, t2 # with value 00 (U-mode)
    csrw mstatus, t1
    la t0, main # Loads the user software
    csrw mepc, t0 # entry point into mepc

    mret # PC <= MEPC; mode <= MPP;

    call main
    # e chamar a função 
    # user_main (definida em outro arquivo). Lembre-se de inicializar a 
    # pilha do usuário para que seu programa possa utilizá-la.
