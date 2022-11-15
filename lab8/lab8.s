
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B

.data
self_driving_car: 0xffff0100

.text
.globl _start
_start:
    li s0, self_driving_car
    li s1, 1
    sb s1, 0x0(s0)
    lw s2, 0x10(s0) #x-pos
    lw s1, 0x14(s0) #y-pos
    