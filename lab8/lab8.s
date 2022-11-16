
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data
self_driving_car: .word 0xffff0100

.bss
dados: .skip 4000

.text
.globl _start
_start:
    la s0, self_driving_car
    lw s0, 0(s0)
    li s10, 73      #x-final
    li s11, -19     #z-final
    la s5, dados

    getDirection:
    jal getInitialData
    jal setForward
    jal getNewPosition
    jal produtoInterno
    bgtz s3, rightTurn
    bltz s3, leftTurn
    bnez s3, getDirection

    jal stop
    loop:
    li a0, 5000
    jal sleep
    j loop

getInitialData:
    li s1, 1
    sb s1, 0x0(s0)
    lw s1, 0x10(s0) #x-pos
    lw s2, 0x18(s0) #z-pos
    sub s9, s1, s10 
    sub s8, s2, s11
    ret

getNewPosition:
    li s1, 1
    sb s1, 0x0(s0)
    lw s3, 0x10(s0) #x-pos
    lw s4, 0x18(s0) #z-pos
    sub s3, s3, s1
    sub s4, s4, s2
    ret

produtoInterno:
    mul s3, s8, s3
    mul s4, s9, s4
    add s3, s3, s4
    ret

setForward:
    la s0, self_driving_car
    lw s0, 0(s0)
    li s1, 1
    sb zero, 0x22(s0)
    sb s1, 0x21(s0)
    ret

leftTurn:
    la s0, self_driving_car
    lw s0, 0(s0)    
    li s1, -70
    sb s1, 0x20(s0)
    ret

rightTurn:
    la s0, self_driving_car
    lw s0, 0(s0)    
    li s1, 15
    sb s1, 0x20(s0)
    ret

turn:
    la s0, self_driving_car
    lw s0, 0(s0)    
    sb s1, 0x20(s0)
    ret

break:
    la s0, self_driving_car
    lw s0, 0(s0)    
    sb s1, 0x20(s0)
    li s1, 1
    sb zero, 0x21(s0)
    sb s1, 0x22(s0)
    ret

stop:
    jal break
    j stop

time:
    addi sp, sp, -16
    mv a0, sp
    mv a1, zero
    li a7, 169
    ecall
    lw t0, 0(sp)
    lw t1, 8(sp)
    addi sp, sp, 16
    li t2, 1000
    mul t0, t0, t2
    div t1, t1, t2
    add a0, t0, t1
    ret

sleep:
    addi sp, sp, -16
    sw ra, 0(sp)
    mv t3, a0
    li t4, -1
    jal time
    bgtz a0, 8
    mul a0, a0, t4
    add t3, t3, a0
    confere:
    1:
        jal time
        bgtz a0, 8
        mul a0, a0, t4
        blt a0, t3, 1b
    lw ra, 0(sp)
    addi sp, sp, 16
    ret