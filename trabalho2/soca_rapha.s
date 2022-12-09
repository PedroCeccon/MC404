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
  addi sp, sp, -128 # allocating space on teh isr stack
  sw t0, 0(sp)
  sw t1, 4(sp)
  sw t2, 8(sp)
  sw ra, 12(sp)

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

  li t0, 17
  beq a7, t0, Syscall_read

  li t0, 18
  beq a7, t0, Syscall_write

  li t0, 19
  beq a7, t0, Syscall_draw_line

  li t0, 20
  beq a7, t0, Syscall_get_systime

  return:
  # restoring context #
  csrr t0, mepc  # loads return address
  addi t0, t0, 4 # adds 4 to return address (to get next instruction)
  csrw mepc, t0  # stores return address back to mepc
  
  lw ra, 12(sp)
  lw t2, 8(sp)
  lw t1, 4(sp)
  lw t0, 0(sp)
  addi sp, sp, 128
  csrrw sp, mscratch, sp

  
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

  # setting turn direction
  li t1, -127
  blt a1, t1, error_set_motor
  li t1, 127
  blt t1, a1, error_set_motor

  sb a0, 0x21(t0)
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

  li t1, 0
  beq a0, t1, correct_handbreak
  li t1, 1
  beq a0, t1, correct_handbreak

  j error_set_handbreak

  correct_handbreak:
  li t0, car_base
  addi t1, t0, 0x22
  sb a0, (t1)
  j return

  error_set_handbreak:
  li a0, -1
  j return

Sycall_read_sensors: # code 12
  # a0: address to a 256 element vector that stores the values read from the luminosity sensor

  # getting the car's base address
  li t0, car_base

  # activating the line camera
  li a1, 1
  sb a1, 0x01(t0)

  wait_sensors:
  lb a1, 0x01(t0)
  bne zero, a1, wait_sensors

  # storing the image
  li a1, 256
  li t1, 0 # loop aux

  loop_read_sensors:
    # getting next byte
    addi t2, t0, 0x24
    add t2, t2, t1
    lb t3, (t2)

    # storing in vector
    add t2, a0, t1
    sb t3, (t2)

    # updating loop
    addi t1, t1, 1 # aux = aux + 1
    blt t1, a1, loop_read_sensors

  j return

Syscall_read_sensor_distance: # code 13
  # getting the car's base address
  li t0, car_base

  # activating the ultrasonic sensor
  li a1, 1
  sb a1, 0x02(t0)

  wait_sensor:
  lb a1, 0x02(t0)
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
  li t1, 1
  sb t1, (t0)

  wait_gps_position:
  lb t1, (t0)
  bne zero, t1, wait_gps_position

  # getting positions
  lw t1, 0x10(t0) # loading x position
  sw t1, (a0) # storing x position

  lw t1, 0x14(t0) # loading y position
  sw t1, (a1) # storing y position

  lw t1, 0x18(t0) # loading z position
  sw t1, (a2) # storing z position

  j return

Syscall_get_rotation: # code 16
  # a0: variable address that stores x's euler angle
  # a1: variable address that stores y's euler angle
  # a2: variable address that stores z's euler angle

  # getting the car's base address
  li t0, car_base

  # activating GPS
  li t1, 1
  sb t1, (t0)

  wait_gps_angle:
  lb t1, (t0)
  bne zero, t1, wait_gps_angle

  # getting angles
  lw t1, 0x04(t0) # loading x angle
  sw t1, (a0) # storing x angle

  lw t1, 0x08(t0) # loading y angle
  sw t1, (a1) # storing y angle

  lw t1, 0x0c(t0) # loading z angle
  sw t1, (a2) # storing z angle

  j return

Syscall_read: # code 17
  # a0: file descriptor
  # a1: buffer
  # a2: size

  # getting the port's base address
  li t0, port_base

  # reading input
  li a0, 0 # loop aux

  filter:
    # starting port
    li t1, 1
    sb t1, 0x02(t0)

    wait_port_read1:
    lb t1, 0x02(t0)
    bne zero, t1, wait_port_read1

    lb t1, 0x03(t0)
    beqz t1, filter
    sb t1, 0(a1)
    loop:
    addi a0, a0, 1
    addi a1, a1, 1
    bge a0, a2, return
    li t1, 1
    sb t1, 0x02(t0)
    wait_port_read2:
    lb t1, 0x02(t0)
    bne zero, t1, wait_port_read2
    lb t1, 0x03(t0)
    beqz t1, return
    sb t1, 0(a1)
    j loop

    # reading one byte
    lb t1, 0x03(t0)
    
    # storing byte on buffer
    add t1, t0, a0
    sb t2, (t1)

    # updating loop
    addi a0, a0, 1 # aux = aux + 1
    blt a0, a2, loop

  # return
  add a1, zero, a2
  j return

Syscall_write: # code 18
  # a0: file descriptor
  # a1: buffer
  # a2: size

  # getting the port's base address
  li t0, port_base

  # writing output
  li a0, 0 # loop aux

  loop_write:
    # loading byte from buffer
    add t1, a1, a0
    lb t2, (t1)

    # storing byte to port
    sb t2, 0x01(t0)

    # starting port
    li t1, 1
    sb t1, (t0)

    wait_port_write:
    lb t1, (t0)
    bne zero, t1, wait_port_write

    # updating loop
    addi a0, a0, 1 # aux = aux + 1
    blt a0, a2, loop_write

  # return
  j return

Syscall_draw_line: # code 19
  # a0: memmory address to the array that represents the line

  # getting the canva's base address
  li t0, canvas_base

  # setting array size
  li t1, 256
  sh t1, 0x02(t0)

  # setting initial position
  li t1, 0
  sw t1, 0x04(t0)

  # setting array address
  li t1, 0 # loop aux
  li t2, 256

  # drawing on canvas
  loop_draw_line:
    add t3, a0, t1
    lw t4, (t3)

    addi t3, t0, 0x08
    add t3, t3, t1
    sw t4, (t3)

    # updating loop
    addi t1, t1, 1 # aux = aux + 1
    blt t1, t2, loop

  li t1, 1
  sb t1, (t0)

  wait_canvas:
  lb t1, (t0)
  bne zero, t1, wait_canvas

  j return

Syscall_get_systime: # code 20
  # getting the canva's base address
  li t0, gpt_base

  # starting gpt
  li t1, 1
  sb t1, (t0)

  wait_gpt:
  lb t1, (t0)
  bne zero, t1, wait_gpt

  # getting system time and returning
  lw a0, 0x04(t0)
  j return

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