.globl _start
_start:

    la t0, int_handler 
    csrw mtvec, t0     

    li sp, 0x07FFFFFC   
    la t0, sys_stack_end
    csrw mscratch, t0              

    csrr t1, mstatus 
    ori t1, t1, 0x8 
    csrw mstatus, t1

    csrr t1, mstatus    
    li t2, ~0x1800      
    and t1, t1, t2      
    csrw mstatus, t1 

    la t0, main         
    csrw mepc, t0       

    mret


int_handler:
        # Salvar o contexto
        csrrw sp, mscratch, sp

        addi sp, sp, -64
        sw t0, 0(sp)            
        sw t1, 4(sp)            
        sw t2, 8(sp)           
        sw ra, 12(sp)
        sw s0, 16(sp)
        sw s1, 20(sp)
        sw s2, 24(sp)

        # Trata a exceção
        li s0, 0xFFFF0300 # Car Address
        li s1, 0xFFFF0500 # Serial Port Address
        li s2, 0xFFFF0100 # GPT Address

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
        
        syscall_end:
        csrr t0, mepc

    addi t0, t0, 4
    csrw mepc, t0

    # Recupera o contexto
    lw s2, 24(sp)
    lw s1, 20(sp)
    lw s0, 16(sp)
    lw ra, 12(sp)
    lw t2, 8(sp)            
    lw t1, 4(sp)            
    lw t0, 0(sp)            
    addi sp, sp, 64        

    csrrw sp, mscratch, sp
    mret


Syscall_set_motor:
    li t0, -127
    blt a1, t0, 2f
    li t0, 127
    bgt a1, t0, 2f
    
    li t0, -1
    beq a0, t0, 1f
    li t0, 0
    beq a0, t0, 1f
    li t0, 1
    beq a0, t0, 1f
    j 2f

    1:
    sb a0, 0x21(s0) 
    sb a1, 0x20(s0)

    li a0, 0
    j syscall_end

    2:
    li a0, -1
    j syscall_end

Syscall_set_handbreak:
    li t0, 1
    beq a0, t0, 1f
    j syscall_end
    1:
    sb a0, 0x22(s0)
    j syscall_end

Sycall_read_sensors:
    li t0, 1
    sb t0, 0x1(s0)

    1:
    lb t0, 0x1(s0)
    bne t0, zero, 1b

    add t0, s0, 0x24
    add t2, t0, 256
    1:
        lb t1, 0(t0)
        sb t1, 0(a0)
        addi t0, t0, 1
        addi a0, a0, 1
        blt t0, t2, 1b

    j syscall_end

Syscall_read_sensor_distance:
    li t0, 2
    sb t0, 0x2(s0)
    1:
    lb t0, 0x2(s0)
    bne t0, zero, 1b

    lw a0, 0x1c(s0)

    j syscall_end

Syscall_get_position:
    li t0, 1
    sb t0, 0(s0)

    1:
    lb t0, 0(s0)
    bne t0, zero, 1b

    lw t0, 0x10(s0)
    lw t1, 0x14(s0)
    lw t2, 0x18(s0)

    sw t0, 0(a0)
    sw t1, 0(a1)
    sw t2, 0(a2)

    j syscall_end

Syscall_get_rotation:
    li t0, 1
    sb t0, 0(s0)

    1:
    lb t0, 0(s0)
    bne t0, zero, 1b

    lw t0, 0x04(s0)
    lw t1, 0x08(s0)
    lw t2, 0x0C(s0)

    sw t0, 0(a0)
    sw t1, 0(a1)
    sw t2, 0(a2)

    j syscall_end

Syscall_read:
    bne a0, zero, syscall_end
    li a0, 0
    li t3, '\n'

    1:
    li t0, 1
    sb t0, 0x2(s1)

    2:
    lb t0, 0x2(s1)
    bne t0, zero, 2b

    3:
    lb t1, 0x3(s1)
    beq t1, t3, syscall_end
    sb t1, 0(a1)
    addi a1, a1, 1
    addi a0, a0, 1

    beq t2, a2, syscall_end
    j 1b

    j syscall_end

Syscall_write:
    li t1, 1
    bne a0, t1, syscall_end

    li t0, 0
    1:

    lb t2, 0(a1)
    sb t2, 0x1(s1)

    sb t1, 0(s1)
    2:
    lb t3, 0(s1)
    bne t3, zero, 2b

    addi a1, a1, 1
    addi t0, t0, 1
    blt t0, a2, 1b

    j syscall_end

Syscall_draw_line:
j syscall_end

Syscall_get_systime:
    li t1, 1
    sb t1, 0(s2)

    1:
    lb t1, 0(s2)
    bne t1, zero, 1b

    lw a0, 4(s2)
    j syscall_end

.bss
.align 4

sys_stack: .skip 64
sys_stack_end: