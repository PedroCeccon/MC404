
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data
gpt: .word 0xFFFF0100
MIDI: .word 0xFFFF0300
_system_time: .word 0

.bss
ISR_stack: .skip 1024
ISR_stack_end:

.text
.globl gpt_isr
    csrrw sp, mscratch, sp
    addi sp, sp, -128 
    sw x0, 0(sp) 
    sw x1, 4(sp)
    sw x2, 8(sp) 
    sw x3, 12(sp) 
    sw x4, 16(sp) 
    sw x5, 20(sp) 
    sw x6, 24(sp) 
    sw x7, 28(sp)

    la t0, gpt
    li t1, 1
    sw t1, 0(t0)
    lw t1, 4(t0)
    la t0, _system_time
    sw t1, 0(t0)
    la t0, gpt
    li t1, 100
    sw t1, 8(t0)

    lw x1, 4(sp)
    lw x0, 0(sp)
    addi sp, sp, 128 
    csrrw sp, mscratch, sp 
    mret

.globl play_note
play_note:
    la t0, MIDI
    lb a0, 0(t0)
    lh a1, 2(t0)
    lb a2, 4(t0)
    lb a3, 5(t0)
    lh a4, 6(t0)
    ret

.globl _start
_start:
    la t0, gpt_isr
    csrw mtvec, t0

    la t0, ISR_stack_end
    csrw mscratch, t0

    la t0, gpt
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
    