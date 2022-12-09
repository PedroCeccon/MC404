.bss

.align 4
sys_stack_top: .skip 0x400
sys_stack:


.align 4
.text
.set BASE_GPT, 0xFFFF0100
.set BASE_CAR, 0xFFFF0300
.set BASE_SERIAL, 0xFFFF0500
.set BASE_CANVAS, 0xFFFF0700

Syscall_set_motor:
    # Syscall to control the engine and steering wheel of the car
    #
    # Code: 10
    #
    # Arguments:
    #   a0: engine direction
    #   a1: wheel angle
    #
    # Returns
    #  0 if successful, 1 otherwise

    # Save context
    addi sp, sp, -16
    sw t0, 0(sp)

    li t0, BASE_CAR
    sb a0, 33(t0)
    sb a1, 32(t0)

    # Restore context
    lw t0, 0(sp)
    addi sp, sp, 16

    ret


Syscall_set_handbreak:
    # Syscall to control the handbreak of the car
    #
    # Code: 11
    #
    # Arguments:
    #  a0: 1 to break, 0 otherwise

    # Save context
    addi sp, sp, -16
    sw t0, 0(sp)

    li t0, BASE_CAR
    sb a0, 34(t0)

    # Restore context
    lw t0, 0(sp)
    addi sp, sp, 16

    ret


Syscall_read_sensors:
    # Syscall to read the line camera of the car
    #
    # Code: 12
    #
    # Arguments:
    #   a0: address of a 256 bytes vector, with values read from the line camera

    # Save context
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)

    # Trigger line camera capture
    li t0, BASE_CAR
    li t1, 1
    sb t1, 1(t0)

    # Wait until it's done
    1:
        lb t1, 1(t0)
        bnez t1, 1b

    # Save results to registers
    lw a0, 36(t0) # 0x24 = 0d36

    # Restore context
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16

    ret


Syscall_read_sensor_distance:
    # Syscall to read the ultrasonic sensor of the car
    #
    # Code: 13
    #
    # Returns:
    #   a0: -1 if no object is detected at less than 20 meters from the car

    # Save context
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)

    # Trigger distance measurement
    li t0, BASE_CAR
    li t1, 1
    sb t1, 2(t0)

    # Wait until it's done
    1:
        lb t1, 2(t0)
        bnez t1, 1b

    # Save results to registers
    lw a0, 28(t0) # 0x1C = 0d28

    # Restore context
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16

    ret


Syscall_get_position:
    # Syscall to read the the position given by the gps of the car
    #
    # Code: 15
    #
    # Returns:
    #   a0: address to put x coordinate
    #   a1: address to put y coordinate
    #   a2: address to put z coordinate

    # Save context
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)

    li t0, BASE_CAR

    # Trigger GPS measurement
    li t1, 1
    sb t1, 0(t0)

    # Wait until it's done
    1:
        lb t1, 0(t0)
        bnez t1, 1b

    # Save results to registers
    lw a0, 16(t0) # x
    lw a1, 20(t0) # y
    lw a2, 24(t0) # z

    # Restore context
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16

    ret


Syscall_get_rotation:
    # Syscall to read the the rotation given by the gps of the car
    #
    # Code: 16
    #
    # Arguments:
    #   a0: address to put Euler angle at x
    #   a1: address to put Euler angle at y
    #   a2: address to put Euler angle at y

    # Save context
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)

    li t0, BASE_CAR

    # Trigger GPS measurement
    li t1, 1
    sb t1, 0(t0)

    # Wait until it's done
    1:
        lb t1, 0(t0)
        bnez t1, 1b

    # Save results to registers
    lw a0, 4(t0)  # x angle
    lw a1, 8(t0)  # y angle
    lw a2, 12(t0) # z angle

    # Restore context
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16

    ret


Syscall_read:
    # Syscall to read from stdin
    #
    # Code: 17
    #
    # Arguments:
    #   a0: file descriptor = 0
    #   a1: address of buffer
    #   a2: size of buffer
    #
    # Returns:
    #  a0: number of chars read

    # Save context
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t6, 12(sp)

    li t6, BASE_SERIAL

    mv t0, zero
    0: # for
    bge t0, a2, 2f
        # Trigger read
        li t1, 1
        sb t1, 2(t6)

        # Wait until it's done
        1:
            lb t1, 2(t6)
            bnez t1, 1b

        # Store byte read
        add t2, a1, t0
        lb t1, 3(t6)
        sb t1, 0(t2)

        addi t0, t0, 1
        j 0b
    2: # endfor

    # Restore context
    lw t6, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16

    ret


Syscall_write:
    # Syscall to write to stdout
    #
    # Code: 18
    #
    # Arguments:
    #   a0: file descriptor = 1
    #   a1: address of buffer
    #   a2: size of buffer

    # Save context
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)

    li t0, BASE_SERIAL

    mv t2, zero
    0: # for
    bge t2, a2, 2f
        # Store byte to write
        add t3, a1, t2
        lb t1, 0(t3)
        sb t1, 1(t0)

        # Trigger write
        li t1, 1
        sb t1, 0(t0)

        # Wait until it's done
        1:
            lb t1, 0(t0)
            bnez t1, 1b

        addi t2, t2, 1
        j 0b
    2: # endfor

    # Restore context
    lw t3, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16

    ret


Syscall_draw_line:
    # Syscall to draw line camera output on canvas
    #
    # Code: 19
    #
    # Arguments:
    #   a0: address of 1D image with size = 256

    # Save context
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t6, 12(sp)

    li t6, BASE_CAR

    # Prepare MMIO to write
    li t0, 256
    sh t0, 2(t6)
    # TODO: o que os dois últimos campos fazem?

    # Trigger write
    li t1, 1
    sb t1, 0(t6)

    # Wait until it's done
    1:
        lb t1, 0(t6)
        bnez t1, 1b

    # Restore context
    lw t6, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16

    ret


Syscall_get_systime:
    # Syscall to get system uptime
    #
    # Code: 20
    #
    # Returns:
    #   a0: time passed since boot, in miliseconds


    li t0, BASE_GPT

    # Trigger time reading
    li t1, 1
    sb t1, 0(t0)

    # Wait until it's done
    1:
        lb t1, 0(t0)
        bnez t1, 1b

    # Subtract time at boot=
    lw a0, 4(t0)

    ret


Syscall_unhandled:
    # Syscall to handle ecalls with invalid values for a7

    ret


.globl _start
_start:
    # Rotina principal do programa

    # Inicializar a pilha do usuário
    li sp, 0x7FFFFFC

    # Registrar a rotina de tratamento de interrupções
    la t0, int_handler
    csrw mtvec, t0

    # Configurar o mscratch para apontar para a pilha do sistema
    la t0, sys_stack
    csrw mscratch, t0

    # Carrega o modo de execução do programa do usuário (00)
    csrr t1, mstatus
    li t2, ~0x1800
    and t1, t1, t2
    csrw mstatus, t1

    # Carrega o ponto de entrada do programa do usuário
    la t0, main
    csrw mepc, t0

    # Habilitar interrupções
    csrr t1, mstatus
    ori t1, t1, 0x8
    csrw mstatus, t1

    mret


int_handler:
    # Tratador de interrupções e syscalls

    # Save context
    csrrw sp, mscratch, sp
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw ra, 8(sp)

    # Jump to the routine of the selected syscall
    la t0, syscall_table
    slli t1, a7, 2
    add t0, t0, t1
    lw t0, (t0)
    jalr ra, t0, 0

    # Update mepc to the instruction next to the
    # one the that caused the interruption
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0

    # Restore context
    lw ra, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16
    csrrw sp, mscratch, sp

    mret


syscall_table:
    .word Syscall_unhandled            # 0
    .word Syscall_unhandled            # 1
    .word Syscall_unhandled            # 2
    .word Syscall_unhandled            # 3
    .word Syscall_unhandled            # 4
    .word Syscall_unhandled            # 5
    .word Syscall_unhandled            # 6
    .word Syscall_unhandled            # 7
    .word Syscall_unhandled            # 8
    .word Syscall_unhandled            # 9
    .word Syscall_set_motor            # 10
    .word Syscall_set_handbreak        # 11
    .word Syscall_read_sensors         # 12
    .word Syscall_read_sensor_distance # 13
    .word Syscall_unhandled            # 14
    .word Syscall_get_position         # 15
    .word Syscall_get_rotation         # 16
    .word Syscall_read                 # 17
    .word Syscall_write                # 18
    .word Syscall_draw_line            # 19
    .word Syscall_get_systime          # 20
