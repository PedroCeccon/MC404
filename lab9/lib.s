
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data
.set gpt, 0xFFFF0100
.set MIDI, 0xFFFF0300

.globl _system_time
_system_time: .word 0

.bss
ISR_stack: .skip 16
ISR_stack_end:
program_stack: .skip 1024
program_stack_end:

.text
.globl gpt_isr
gpt_isr:
    csrrw sp, mscratch, sp
    addi sp, sp, -16   
    sw t0, 0(sp) 
    sw t1, 4(sp)

    la t0, _system_time
    lw t1, 0(t0)
    addi t1, t1, 100
    sw t1, 0(t0)

    li t0, gpt
    li t1, 100
    sw t1, 8(t0)

    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16
    csrrw sp, mscratch, sp 
    mret

.globl play_note
play_note:
    li t0, MIDI
    sb a0, 0(t0)
    sh a1, 2(t0)
    sb a2, 4(t0)
    sb a3, 5(t0)
    sh a4, 6(t0)
    ret

.globl _start
_start:
    la sp, program_stack_end

    la t0, gpt_isr
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

    jal main