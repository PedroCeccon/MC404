.globl main_isr
.globl _start

.bss
.align 4
isr_stack:                      # Final pilha ISR
.skip 1024
isr_stack_end:                  # Base pilha ISR

.text
.align 4
.set baseGPT, 0xFFFF0100
.set baseCar, 0xFFFF0300
.set baseSerial, 0xFFFF0500
.set baseCanvas, 0xFFFF0700


main_isr:
# a7 = codigo da syscall
    # Salva contexto
    csrrw sp, mscratch, sp
    addi sp, sp, -64
    sw t0, (sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)

    # Trata interrupção
    li t0, 10
    beq a7, t0, syscall_set_motor
    li t0, 11
    beq a7, t0, syscall_set_handbreak
    li t0, 12
    beq a7, t0, syscall_read_sensors
    li t0, 13
    beq a7, t0, syscall_read_sensor_distance
    li t0, 15
    beq a7, t0, syscall_get_position
    li t0, 16
    beq a7, t0, syscall_get_rotation  
    li t0, 17
    beq a7, t0, syscall_read
    li t0, 18
    beq a7, t0, syscall_write
    li t0, 19
    beq a7, t0, syscall_draw_line  
    li t0, 20
    beq a7, t0, syscall_get_systime
    j main_isr_end



syscall_set_motor:
# a0 = sentido; a1 = angulo
    li t0, -1
    li t1, 0
    li t2, 1
    beq a0, t0, 0f
    beq a0, t1, 0f
    beq a0, t2, 0f

    li a0, -1
    j main_isr_end

0:
    li t0, -127
    li t1, 128
    blt a1, t0, 0f
    bge a1, t1, 0f
    j 1f

0:
    li a0, -1
    j main_isr_end

1:
    li t0, baseCar
    sb a0, 0x21(t0)
    sb a1, 0x20(t0)

    li a0, 0
    j main_isr_end



syscall_set_handbreak:
# a0 = ativado
    li t0, baseCar
    sb a0, 0x22(t0)
    j main_isr_end



syscall_read_sensors:
# a0 = endereço vetor luminosidade
    li t0, baseCar
    li t1, 1
    sb t1, 0x1(t0)

0:
    lb t2, 0x1(t0)
    beq t1, t2, 0b

    addi t0, t0, 0x24
    li t1, 256
    li t2, 0

1:
    lb t3, (t0)
    sb t3, (a0)
    addi t0, t0, 1
    addi a0, a0, 1
    addi t2, t2, 1
    blt t2, t1, 1b
    j main_isr_end



syscall_read_sensor_distance:
    li t0, baseCar
    li t1, 2
    sb t1, 0x2(t0)

0:
    lb t2, 0x2(t0)
    beq t1, t2, 0b

    lw a0, 0x1c(t0)
    j main_isr_end



syscall_get_position:
# a0 = endereço x; a1 = endereço y; a2 = endereço z
    li t0, baseCar
    li t1, 1
    sb t1, (t0)

0:
    lb t2, (t0)
    beq t1, t2, 0b

    lw t1, 0x10(t0)             # t1 = posicao x
    lw t2, 0x14(t0)             # t2 = posicao y
    lw t3, 0x18(t0)             # t3 = posicao z
    sw t1, (a0)
    sw t2, (a1)
    sw t3, (a2)
    j main_isr_end



syscall_get_rotation:
# a0 = endereco Euler x; a1 = endereco Euler y; a2 = endereco Euler z
    li t0, baseCar
    li t1, 1
    sb t1, (t0)

0:
    lb t2, (t0)
    beq t1, t2, 0b

    lw t1, 0x4(t0)              # t1 = angulo Euler x
    lw t2, 0x8(t0)              # t2 = angulo Euler y
    lw t3, 0xc(t0)              # t3 = angulo Euler z
    sw t1, (a0)
    sw t2, (a1)
    sw t3, (a2)
    j main_isr_end


syscall_read:
# a0 = file descriptor; a1 = buffer; a2 = size
    li t0, baseSerial
    li t1, 0
    bne a0, t1, main_isr_end

    li t1, 0

0:
    li t2, 1
    sb t2, 0x2(t0)

1:
    lb t3, 0x2(t0)
    beq t2, t3, 1b

    lb t2, 0x3(t0)
    sb t2, (a1)
    addi a1, a1, 1

    addi t1, t1, 1
    blt t1, a2, 0b
    mv a0, a2
    j main_isr_end



syscall_write:
# a0 = file descriptor; a1 = buffer; a2 = size
    li t0, baseSerial
    li t1, 1
    bne a0, t1, main_isr_end

    li t1, 0

0:
    lb t2, (a1)
    addi a1, a1, 1
    sb t2, 0x1(t0)

    li t2, 1
    sb t2, (t0)

1:
    lb t3, (t0)
    beq t2, t3, 1b

    addi t1, t1, 1
    blt t1, a2, 0b
    j main_isr_end



syscall_draw_line:
# a0 = buffer
    li t0, baseCanvas
    li t1, 256
    sh t1, 0x2(t0)
    li t1, 0
    sw t1, 0x4(t0)

    li t1, 0
    addi t2, t0, 0x8

0:
// little ou big endian?
    lbu t3, (a0)                # nn
    mv t4, t3
    li t5, 256

    mul t3, t3, t5              # nn00
    add t3, t3, t4              # nnnn
    mul t3, t3, t5              # nnnn00
    add t3, t3, t4              # nnnnnn
    mul t3, t3, t5              # nnnnnn00
    addi t3, t3, 0xff           # nnnnnnFF
    sw t3, (t2)

    addi a0, a0, 1
    addi t2, t2, 4
    addi t1, t1, 1
    blt t1, t5, 0b

    li t1, 1
    sb t1, (t0)

1:
    lb t2, (t0)
    beq t1, t2, 1b
    j main_isr_end



syscall_get_systime:
    li t0, baseGPT
    li t1, 1
    sb t1, (t0)

0:
    lb t2, (t0)
    beq t1, t2, 0b

    sw a0, 0x4(t0)
    j main_isr_end



main_isr_end:
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0

    # Restaura contexto
    lw t0, (sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    addi sp, sp, 64
    csrrw sp, mscratch, sp
    mret



_start:
    la t0, isr_stack_end
    csrw mscratch, t0           # salva a pilha isr no mscratch

    li sp, 0x07FFFFFC           # inicializa a pilha do usuário

    la t0, main_isr
    csrw mtvec, t0              # salva o endereço da ISR no mtvec

    csrr t1, mie
    li t2, 0x800
    or t1, t1, t2
    csrw mie, t1                # habilita interrupções externas

    csrr t1, mstatus
    ori t1, t1, 0x8
    csrw mstatus, t1            # habilita interrupções globais

    csrr t1, mstatus            # atualiza o mstatus.MPP
    li t2, ~0x1800
    and t1, t1, t2
    csrw mstatus, t1
    la t0, main                 # atualiza para privilégio de usuário
    csrw mepc, t0
    mret