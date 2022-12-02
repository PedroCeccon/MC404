
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
program_stack: .skip 48
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
    sb zero, 0x22(t0)
    sb a0, 0x21(t0)
    sb a1, 0x20(t0)
    li a0, 0
    j 12
    1:
    li a0, -1
    j return_syscall

Syscall_set_handbreak:
    li t0, 1
    bne a0, t0, 1f
    li t0, self_driving_car
    sb zero, 0x21(t0)
    sb a0, 0x22(t0)
    1:
    j return_syscall

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
    j return_syscall

Syscall_get_position:
    li t0, self_driving_car
    li t1, 1
    sb t1, 0(t0)
    lw a0, 0x10(t0)
    lw a1, 0x14(t0)
    lw a2, 0x18(t0)
    j return_syscall


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
    return_syscall:

    csrr t0, mepc   
    addi t0, t0, 4 
    csrw mepc, t0  

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


.globl logica_controle
logica_controle:
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s6, 20(sp)
    sw s7, 24(sp)
    sw s8, 28(sp)
    sw s9, 32(sp)
    sw s10, 36(sp)
    sw s11, 40(sp)

    li s10, 73      #x-final
    li s11, -19     #z-final
    li t6, 0

    getToGoal:
        jal getInitialData
        jal set_direction
        li a3, 3

        setDistance:
        jal getNewPosition
        jal goal
        mul s6, s3, s3
        mul s7, s4, s4
        add s6, s6, s7
        blt s6, a3, setDistance

        jal break
        jal getNewPosition
        jal produtoInterno
        beq s3, zero, 3f
        li t6, -350
        bge s3, t6, 1f
            li t6, -70
            jal set_direction
            j 3f
        1:
        li t6, 350
        ble s3, t6, 2f
            li t6, 70
            jal set_direction
            j 3f
        2:
            mv t6, s3
            li t0, 5
            div t6, t6, t0
            jal set_direction
        3:
        j getToGoal
    end:

    lw s11, 40(sp)
    lw s10, 36(sp)
    lw s9, 32(sp)
    lw s8, 28(sp)
    lw s7, 24(sp)
    lw s6, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw ra, 0(sp)

    addi sp, sp, 48
    ret

getInitialData:
    li a7, 15
    ecall
    mv s1, a0
    mv s2, a2
    sub s9, s10, s1 
    sub s8, s2, s11
    ret

getNewPosition:
    li a7, 15
    ecall
    mv a5, a0 #x-pos
    mv a6, a2 #z-pos
    sub s3, a5, s1
    sub s4, a6, s2
    ret

produtoInterno:
    mul s3, s8, s3
    mul s4, s9, s4
    add s3, s3, s4
    ret

set_direction:
    li a0, 1
    mv a1, t6
    li a7, 10
    ecall
    ret

break:
    li a0, 1
    li a7, 11
    ecall
    ret

stop:
    jal break
    j end

goal:
    sub t0, a5, s10
    sub t1, a6, s11
    mul t0, t0, t0
    mul t1, t1, t1
    add t0, t0, t1
    li t3, 1000
    blt t0, t3, stop
    ret