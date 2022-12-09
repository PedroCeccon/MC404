# ----------------------------------------------------------------------------
# API
# ----------------------------------------------------------------------------

.globl strlen
strlen:
    # Gets the number of characters in a string
    #
    # Arguments:
    #   a0: string address
    #
    # Returns:
    #   a0: string length

    mv t6, a0

    1: # do
        lb t0, 0(t6)
        li t1, '\0'
        addi t6, t6, 1
        # while
        beq t0, t1, 2f
            j 1b
    2: #endwhile

    mv a0, t0
    ret


.globl puts
puts:
    # Writes the string pointed by a0 to stdout and appends a '\n'
    #
    # Arguments:
    #   a0: string address

    # save context
    addi sp, sp, -16
    sw ra, 0(sp)

    mv a1, a0
    call strlen
    mv a0, a2

    # print the string
    li a0, 1
    li a7, 18
    ecall

    # print '\n'
    li a0, 1
    li t0, '\n' # store '\n' in stack
    sw t0, 4(sp)
    la a1, sp
    li a2, 1
    li a7, 18
    ecall

    # retrieve context
    lw ra, 0(sp)
    addi sp, sp, 16

    ret


.globl gets
gets:
    # Reads a string into a0 from stdin until '\n' is reached
    #
    # Arguments:
    #   a0: string address

    mv a1, a0
    mv t0, a0
    li a2, 1
    li t1, '\n'



.globl itoa
itoa:
    # Converts an int to a null-terminated string using the specified base
    # NOTE: If base is 10 and value is negative, '-' is prepended
    #
    # Arguments:
    #   a0: string address
    #   a1: integer
    #   a2: base

    # save context
    addi sp, sp, -16
    sw ra, 12(sp)


    # convert string to int
    mv t6, a0 # current position
    mv t5, a1 # current number
    1: # do
        rem t0, t5, a2
        div t5, t5, a2
        addi t0, t0, '0'
        sb t0, 0(t6)
        addi t6, t6, 1 # update position
        # while
        bnez t5, 1b
        # endwhile

    # append minus ('-') if needed
    bge a1, zero, 1f
        li t0, '-'
        sb t0, 0(t6)
        addi t6, t6, 1 # update position
    1:

    # append null ('\0')
    li t0, '\0'
    sb t0, 0(t6)
    addi t6, t6, -1

    # invert string
    mv t3, a0
    1: # do
        lb t0, 0(t6) # last value
        lb t2, 0(t3) # first value
        sb t0, 0(t3)
        sb t2, 0(t6)

        addi t3, t3, 1
        addi t6, t6, -1

        # while
        blt t3, t6, 1b
        # endwhile

    # retrieve context
    lw ra, 12(sp)
    addi sp, sp, 16

    ret

.globl atoi
atoi:
    # Parses the string interpreting its content as an integer
    # NOTE: All leading whitespace is removed
    # NOTE: An optional sign can be provided

.globl approx_sqrt
approx_sqrt:
    # Approximates the square root of a given value
    #
    # Arguments:
    #   a0: value
    #
    # Returns
    #   a0: square root of value

    # t0 = k
    # a0 = y
    srai t0, a0, 1

    li t1, 10
    1:
        div  t2, a0, t0 # t2 = y/k
        add  t2, t2, t0 # t2 = y/k + k
        srai t2, t2, 1  # t2 = (y/k + k)/2
        mv   t0, t2     # t0 = (y/k + k)/2

        addi t1, t1, -1
        bnez t1, 1b

    mv a0, t0
    ret


.globl sleep
sleep:
    # Executes for the given amount of miliseconds
    #
    # Arguments:
    #   a0: time to execute

.globl filter_1d_image
filter_1d_image:
    # Filters a 1D image with a 1D filter
    #
    # Arguments:
    #   a0 (unsigned word): address of 1D image with size = 256
    #   a1 (unsigned word): address of 1D filter


# ----------------------------------------------------------------------------
# PERIPHERALS
# ----------------------------------------------------------------------------

.globl set_motor
set_motor:
    # Controls the engine and steering wheel of the car
    #
    # Arguments:
    #   a0 (byte): engine direction
    #   a1 (byte): wheel angle
    #
    # Returns
    #   a0 (word): 0 if successful, 1 otherwise

    li a7, 10
    ecall


.globl set_handbreak
set_handbreak:
    # Controls the handbreak of the car
    #
    # Arguments:
    #   a0 (byte): 1 to break, 0 otherwise
    #
    # Returns
    #   a0 (word): 0 if successful, 1 otherwise

    li a7, 11
    ecall


.globl read_camera
read_camera:
    # Reads the line camera of the car
    #
    # Arguments:
    #   a0 (unsigned byte): address of a 256 bytes vector, with values read from the line camera

    li a7, 12
    ecall


.globl read_sensor_distance
read_sensor_distance:
    # Reads the ultrasonic sensor of the car
    #
    # Returns:
    #   a0 (word): -1 if no object is detected at less than 20 meters from the car

    li a7, 13
    ecall


.globl get_position
get_position:
    # Reads the the position given by the GPS of the car
    #
    # Arguments:
    #   a0 (unsigned word): address to put x coordinate
    #   a1 (unsigned word): address to put y coordinate
    #   a2 (unsigned word): address to put z coordinate

    li a7, 15
    ecall


.globl get_rotation
get_rotation:
    # Reads the the rotation given by the GPS of the car
    #
    # Arguments:
    #   a0 (unsigned word): address to put Euler angle at x
    #   a1 (unsigned word): address to put Euler angle at y
    #   a2 (unsigned word): address to put Euler angle at y

    li a7, 16
    ecall


.globl display_image
display_image:
    # Displays a 1D image in the Canvas peripheral
    #
    # Arguments:
    #   a0 (unsigned word): address of 1D image with size = 256

    li a7, 19
    ecall
