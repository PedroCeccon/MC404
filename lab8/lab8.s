
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data
self_driving_car: .word 0xffff0100

.text
.globl _start
_start:
    la s0, self_driving_car
    lw s0, 0(s0)
    li s10, 73      #x-final
    li s11, -19     #z-final

    getToGoal:
        jal getInitialData
        jal setForward
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
        li t6, -200
        bge s3, t6, 1f
            li t6, -40
            jal turn
            j 3f
        1:
        li t6, 200
        ble s3, t6, 2f
            li t6, 40
            jal turn
            j 3f
        2:
            mv t6, s3
            li t0, 5
            div t6, t6, t0
            jal turn
        3:
        j getToGoal

getInitialData:
    li t6, 1
    sb t6, 0x0(s0)
    lw s1, 0x10(s0) #x-pos
    lw s2, 0x18(s0) #z-pos
    sub s9, s10, s1 
    sub s8, s2, s11
    ret

getNewPosition:
    li s5, 1
    sb t6, 0x0(s0)
    lw a6, 0x10(s0) #x-pos
    lw a7, 0x18(s0) #z-pos
    sub s3, a6, s1
    sub s4, a7, s2
    ret

produtoInterno:
    mul s3, s8, s3
    mul s4, s9, s4
    add s3, s3, s4
    ret

setForward:
    la s0, self_driving_car
    lw s0, 0(s0)
    li t6, 1
    sb zero, 0x22(s0)
    sb t6, 0x21(s0)
    ret

turn:
    la s0, self_driving_car
    lw s0, 0(s0)    
    sb t6, 0x20(s0)
    ret

break:
    la s0, self_driving_car
    lw s0, 0(s0)    
    sb t6, 0x20(s0)
    li t6, 1
    sb zero, 0x21(s0)
    sb t6, 0x22(s0)
    ret

stop:
    jal break
    j stop

goal:
    sub t0, a6, s10
    sub t1, a7, s11
    mul t0, t0, t0
    mul t1, t1, t1
    add t0, t0, t1
    li t3, 1200
    blt t0, t3, stop
    ret