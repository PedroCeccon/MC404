# --- .bss --- #
.bss
.align 4
# creating isr stack #
isr_stack:
.skip 1024
isr_stack_end:

# --- .text --- #
.text
.align 4

.set gpt_base, 0xFFFF0100
.set car_base, 0xFFFF0300
.set port_base, 0xFFFF0500
.set canvas_base, 0xFFFF0700

.globl int_handler
int_handler:
  # saving context #
  csrrw sp, mscratch, sp # exchanging sp and mscratch
  addi sp, sp, -192 # allocating space on teh isr stack
  sw a0, 0(sp)
  sw a1, 4(sp)
  sw t0, 8(sp)
  sw t1, 12(sp)
  sw t2, 16(sp)
  sw ra, 20(sp)

  # treating interuption #
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

  return:
  # restoring context #
  lw ra, 20(sp)
  lw t2, 16(sp)
  lw t1, 12(sp)
  lw t0, 8(sp)
  lw a1, 4(sp)
  lw a0, 0(sp)
  addi sp, sp, 192
  csrrw sp, mscratch, sp

  csrr t0, mepc  # loads return address
  addi t0, t0, 4 # adds 4 to return address (to get next instruction)
  csrw mepc, t0  # stores return address back to mepc
  mret   

Syscall_set_motor: # code 10
  # a0: fwd or bkw
  # a1: steering wheel angle

  # getting the car's base address
  li t0, car_base

  # setting engine
  li t1, -1
  beq a0, t1, correct_engine
  li t1, 0
  beq a0, t1, correct_engine
  li t1, 1
  beq a0, t1, correct_engine

  j error_set_motor

  correct_engine:
  sb a0, 0x21(t0)

  # setting turn direction
  li t1, -127
  blt a1, t1, error_set_motor
  li t1, 127
  blt t1, a1, error_set_motor

  sb a1, 0x20(t0)

  # returning 0
  li a0, 0
  j return

  error_set_motor:
    # returning -1
    li a0, -1
    j return

Syscall_set_handbreak: # code 11
  # a0: value to be set on handbreak

  li t0, car_base
  addi t1, t0, 0x22
  sb a0, (t1)

  ret

Sycall_read_sensors: # code 12
  # a0: address to a 256 element vector that stores the values read from the luminosity sensor

  # getting the car's base address
  li t0, car_base

  # activating the line camera
  li a1, 1
  sb a1, 0x01(t0)

  wait_sensors:
  lb a1, (t1)
  bne zero, a1, wait_sensors

  # storing the image
  sb a0, 0x24(t0)
  # TERMINARRRRRR AAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  j return

Syscall_read_sensor_distance: # code 13
  # getting the car's base address
  li t0, car_base

  # activating the ultrasonic sensor
  li a1, 1
  sb a1, 0x02(t0)

  wait_sensor:
  lb a1, (t1)
  bne zero, a1, wait_sensor

  # reading distance
  lw a0, 0x1c(t0)
  
  j return

Syscall_get_position: # code 15
  # a0: variable address that stores x position
  # a1: variable address that stores y position
  # a2: variable address that stores z position

  # getting the car's base address
  li t0, car_base

  # activating GPS
  li a1, 1
  sb a1, (t0)

  wait_gps_position:
  lb a1, (t0)
  bne zero, a1, wait_gps_position

  # getting positions
  lw a0, 0x10(t0) # storing x position

  lw a1, 0x14(t0) # storing y position

  lw a2, 0x18(t0) # storing z position

  j return

Syscall_get_rotation: # code 16
  # a0: variable address that stores x's euler angle
  # a1: variable address that stores y's euler angle
  # a2: variable address that stores z's euler angle

  # getting the car's base address
  li t0, car_base

  # activating GPS
  li a1, 1
  sb a1, (t0)

  wait_gps_angle:
  lb a1, (t0)
  bne zero, a1, wait_gps_angle

  # getting angles
  lw a0, 0x04(t0) # storing x angle

  lw a1, 0x08(t0) # storing y angle

  lw a2, 0x0c(t0) # storing z angle

  j return

Syscall_read: # code 17
  # a0: file descriptor
  # a1: buffer
  # a2: size

  # getting the port's base address
  li t0, port_base

  # reading input
  li a0, 0 # loop aux

  loop:
    # starting port
    li t2, 1
    sb t2, 0x02(t0)

    wait_port_read:
    lb t2, (t1)
    bne zero, a1, wait_port_read

    # reading one byte
    lb t2, 0x03(t0)
    
    # storing byte on buffer
    add t1, t0, a0
    sb t2, (t1)

    # updating loop
    addi a0, a0, 1 # aux = aux + 1
    blt a0, a2, loop

  # return
  add a1, zero, a2
  ret

.globl logica_controle
logica_controle:
  li a0, 1
  li a1, -15
  li a7, 10
  ecall

  ret

.globl _start
_start:
  # setting isr stack #
  li sp, 0x07FFFFFC
  la t0, isr_stack_end
  csrw mscratch, t0

  # registering interuption #
  la t0, int_handler
  csrw mtvec, t0

  # habilitating external interuptions #
  csrr t1, mie
  li t2, 0x800
  or t1, t1, t2
  csrw mie, t1

  # habilitating global interuptions #
  csrr t1, mstatus
  ori t1, t1, 0x8
  csrw mstatus, t1

  # changing user mode and calling user_main #
  csrr t1, mstatus
  li t2, ~0x1800
  and t1, t1, t2
  csrw mstatus, t1
  la t0, main
  csrw mepc, t0
  mret