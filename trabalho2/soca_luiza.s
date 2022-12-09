
.globl _start

.bss
#aloca espaço na pilha
.align 4
stack:
.skip 1024
stack_end:

.text
.align 4
.set gpt, 0xFFFF0100
.set car, 0xFFFF0300
.set port, 0xFFFF0500
.set canvas, 0xFFFF0700


int_handler:
csrrw sp, mscratch, sp
addi sp, sp, -32
sw ra, 0(sp)
sw t0, 4(sp)
sw t1, 8(sp)
sw t2, 12(sp)
sw t3, 16(sp)
sw t4, 20(sp)

.set set_motor, 10
.set set_handbreak, 11
.set read_sensors, 12
.set read_season_distance, 13
.set get_position, 15
.set get_rotation, 16
.set read, 17
.set write, 18
.set draw_line, 19
.set get_systime, 20

li t0, set_motor
beq a7, t0, syscall_set_motor
li t0, set_handbreak
beq a7, t0, syscall_set_handbreak
li t0, read_sensors
beq a7, t0, syscall_read_sensors
li t0, read_season_distance
beq a7, t0, syscall_read_sensor_distance
li t0, get_position
beq a7, t0, syscall_get_position
li t0, get_rotation
beq a7, t0, syscall_get_rotation
li t0, read
beq a7, t0, syscall_read
li t0, write
beq a7, t0, syscall_write
li t0, draw_line
beq a7, t0, syscall_draw_line
li t0, get_systime
beq a7, t0, syscall_get_systime
j conclusion

syscall_set_motor:
//coloca a0 para andar o motor
//coloca a1 para angulação do volante e checa se está no intervalo
    li t1, car

    li t2, -127
    bge a1, t2, inInterval //checa se a1 > t2
    j error

    inInterval:
    li t2, 128
    bge a1, t2, error // checa se a1 < t2
    li t2, -1
    blt a0, t2, error
    li t2, 1
    bgt a0, t2, error

    sb a1, 0x20(t1)
    sb a0, 0x21(t1)
    li a0, 0
    j conclusion

    error:
    li a0, -1
    j conclusion

syscall_set_handbreak:
//coloca a0 para acionar o freio de mão
    li t1, car

    bltz a0, error2

    inInterval2:
    li t2, 1
    bgt a0, t2, error2
    sb a0, 0x22(t1)
    li a0, 0
    j conclusion

    error2:
    li a0, -1
    j conclusion

syscall_read_sensors:
    //busy waiting
    li t1, car
    li t2, 1
    sb t2, 1(t1)

    waiting:
    lb t3, 1(t1)
    bne t3, zero, waiting

    li t3, 256
    li a1, 0

    sensors:
    bge a1, t3, conclusion
    lb t2, 0x24(t1)
    sb t2, 0(a0)
    addi t1, t1, 1
    addi a0, a0, 1
    addi a1, a1, 1
    j sensors

syscall_read_sensor_distance:
    li t1, car
    li t2, 2
    sb t2, 2(t1)

    waiting2:
    lb t3, 2(t1)
    bne t3, zero, waiting2

    lw a0, 0x1C(t1)
    j conclusion

syscall_get_position:
    li t1, car
    li t2, 1
    sb t2, 0(t1)

    waiting3:
    lb t3, 0(t1)
    bne t3, zero, waiting3

    lw t4, 0x10(t1)
    sw t4, 0(a0)
    lw t4, 0x14(t1)
    sw t4, 0(a1)
    lw t4, 0x18(t1)
    sw t4, 0(a2)
    j conclusion

syscall_get_rotation:
    li t1, car
    li t2, 1
    sb t2, 0(t1)

    waiting4:
    lb t3, 0(t1)
    bne t3, zero, waiting4

    lw t4, 4(t1)
    sw t4, 0(a0)
    lw t4, 8(t1)
    sw t4, 0(a1)
    lw t4, 0x0C(t1)
    sw t4, 0(a2)
    j conclusion 

syscall_read:
    li t1, port
    bnez a0, conclusion

    filtering:
    li t3, 1
    sb t3, 2(t1)

    waiting5a:
    lb t3, 2(t1)
    bne t3, zero, waiting5a

    lb t2, 3(t1)
    beq t2, zero, filtering
    sb t2, 0(a1)
    addi a1, a1, 1
    addi a0, a0, 1

    reading:
    bge a0, a2, conclusion
    li t3, 1
    sb t3, 2(t1)

    waiting5b:
    lb t3, 2(t1)
    bne t3, zero, waiting5b

    lb t2, 3(t1)
    beq t2, zero, conclusion
    sb t2, 0(a1)
    addi a1, a1, 1
    addi a0, a0, 1
    j reading

syscall_write:
    li t1, port
    li t3, 1
    bne a0, t3, conclusion 
    li a0, 0

    writing:
    bge a0, a2, conclusion
    lb t2, 0(a1)
    sb t2, 1(t1)
    addi a1, a1, 1
    addi a0, a0, 1

    li t3, 1
    sb t3, 0(t1)
    waiting6:
    lb t3, 0(t1)
    bne t3, zero, waiting6
    j writing

syscall_draw_line:


syscall_get_systime:
    li t1, gpt
    li t2, 1
    sb t2, 0(t1)

    waiting7:
    lb t2, 0(t1)
    bne t2, zero, waiting7

    lw a0, 4(t1)
    j conclusion

conclusion:


csrr t0, mepc  # carrega endereço de retorno (endereço da instrução que invocou a syscall)
addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall) 
csrw mepc, t0

//recupera memoria e valores
lw t4, 20(sp)
lw t3, 16(sp)
lw t2, 12(sp)
lw t1, 8(sp)
lw t0, 4(sp)
lw ra, 0(sp)
addi sp, sp, 32
csrrw sp, mscratch, sp
mret




_start:
li sp, 0x07FFFFFC
la t0, int_handler  # Carregar o endereço da rotina que tratará as interrupções
csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar
                    # o vetor de interrupções.
la t0, stack_end
csrw mscratch, t0

csrr t1, mstatus
ori t1, t1, 0x8
csrw mstatus, t1

csrr t1, mstatus # Update the mstatus.MPP
li t2, ~0x1800 # field (bits 11 and 12)
and t1, t1, t2 # with value 00 (U-mode)
csrw mstatus, t1

la t0, main # Loads the user software
csrw mepc, t0 # entry point into mepc
mret