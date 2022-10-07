	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"lab03.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
.Lfunc_begin0:
	.file	0 "/home/ceccon/Documents/MC404/lab3" "lab03.c" md5 0xbd866398c7055504b5167b914c16cfa8
	.loc	0 5 0
	.cfi_sections .debug_frame
	.cfi_startproc
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 32
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
.Ltmp0:
	.loc	0 15 14 prologue_end
	lw	a3, -12(s0)
	.loc	0 15 25 is_stmt 0
	lw	a4, -16(s0)
	.loc	0 15 37
	lw	a5, -20(s0)
	.loc	0 7 5 is_stmt 1
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall read (63) 
	ecall	
	mv	a3, a0
	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	.loc	0 18 12
	lw	a0, -24(s0)
	.loc	0 18 5 is_stmt 0
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Ltmp1:
.Lfunc_end0:
	.size	read, .Lfunc_end0-read
	.cfi_endproc

	.globl	write
	.p2align	2
	.type	write,@function
write:
.Lfunc_begin1:
	.loc	0 21 0 is_stmt 1
	.cfi_startproc
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 32
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
.Ltmp2:
	.loc	0 29 14 prologue_end
	lw	a3, -12(s0)
	.loc	0 29 25 is_stmt 0
	lw	a4, -16(s0)
	.loc	0 29 37
	lw	a5, -20(s0)
	.loc	0 22 5 is_stmt 1
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 64	# syscall write (64) 
	ecall	
	#NO_APP
	.loc	0 32 1
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Ltmp3:
.Lfunc_end1:
	.size	write, .Lfunc_end1-write
	.cfi_endproc

	.globl	exit_syscall
	.p2align	2
	.type	exit_syscall,@function
exit_syscall:
.Lfunc_begin2:
	.loc	0 38 0
	.cfi_startproc
	addi	sp, sp, -16
	.cfi_def_cfa_offset 16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 16
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
.Ltmp4:
	.loc	0 43 14 prologue_end
	lw	a0, -12(s0)
	.loc	0 39 5
	#APP
	li	a7, 93	# syscall write (93) 
	ecall	
	#NO_APP
	.loc	0 46 1
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Ltmp5:
.Lfunc_end2:
	.size	exit_syscall, .Lfunc_end2-exit_syscall
	.cfi_endproc

	.globl	power
	.p2align	2
	.type	power,@function
power:
.Lfunc_begin3:
	.loc	0 54 0
	.cfi_startproc
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 32
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 1
.Ltmp6:
	.loc	0 55 9 prologue_end
	sw	a0, -20(s0)
	li	a0, 0
.Ltmp7:
	.loc	0 56 14
	sw	a0, -24(s0)
	.loc	0 56 10 is_stmt 0
	j	.LBB3_1
.LBB3_1:
.Ltmp8:
	.loc	0 56 21
	lw	a0, -24(s0)
	.loc	0 56 25
	lw	a1, -16(s0)
.Ltmp9:
	.loc	0 56 5
	bge	a0, a1, .LBB3_4
	j	.LBB3_2
.LBB3_2:
.Ltmp10:
	.loc	0 57 18 is_stmt 1
	lw	a0, -20(s0)
	.loc	0 57 25 is_stmt 0
	lw	a1, -12(s0)
	.loc	0 57 24
	mul	a0, a0, a1
	.loc	0 57 16
	sw	a0, -20(s0)
	.loc	0 58 5 is_stmt 1
	j	.LBB3_3
.Ltmp11:
.LBB3_3:
	.loc	0 56 36
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	.loc	0 56 5 is_stmt 0
	j	.LBB3_1
.Ltmp12:
.LBB3_4:
	.loc	0 59 12 is_stmt 1
	lw	a0, -20(s0)
	.loc	0 59 5 is_stmt 0
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Ltmp13:
.Lfunc_end3:
	.size	power, .Lfunc_end3-power
	.cfi_endproc

	.globl	copyString
	.p2align	2
	.type	copyString,@function
copyString:
.Lfunc_begin4:
	.loc	0 68 0 is_stmt 1
	.cfi_startproc
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 32
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	li	a0, 0
.Ltmp14:
	.loc	0 69 13 prologue_end
	sw	a0, -24(s0)
	.loc	0 69 9 is_stmt 0
	j	.LBB4_1
.LBB4_1:
.Ltmp15:
	.loc	0 69 20
	lw	a0, -24(s0)
	.loc	0 69 24
	lw	a1, -20(s0)
.Ltmp16:
	.loc	0 69 5
	bge	a0, a1, .LBB4_4
	j	.LBB4_2
.LBB4_2:
.Ltmp17:
	.loc	0 70 21 is_stmt 1
	lw	a0, -12(s0)
	.loc	0 70 27 is_stmt 0
	lw	a2, -24(s0)
	.loc	0 70 21
	add	a0, a0, a2
	lb	a0, 0(a0)
	.loc	0 70 9
	lw	a1, -16(s0)
	add	a1, a1, a2
	.loc	0 70 19
	sb	a0, 0(a1)
	.loc	0 71 5 is_stmt 1
	j	.LBB4_3
.Ltmp18:
.LBB4_3:
	.loc	0 69 28
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	.loc	0 69 5 is_stmt 0
	j	.LBB4_1
.Ltmp19:
.LBB4_4:
	.loc	0 72 1 is_stmt 1
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Ltmp20:
.Lfunc_end4:
	.size	copyString, .Lfunc_end4-copyString
	.cfi_endproc

	.globl	invertString
	.p2align	2
	.type	invertString,@function
invertString:
.Lfunc_begin5:
	.loc	0 81 0
	.cfi_startproc
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 32
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	li	a0, 0
.Ltmp21:
	.loc	0 82 13 prologue_end
	sw	a0, -28(s0)
	.loc	0 82 9 is_stmt 0
	j	.LBB5_1
.LBB5_1:
.Ltmp22:
	.loc	0 82 20
	lw	a0, -28(s0)
	.loc	0 82 24
	lw	a1, -20(s0)
.Ltmp23:
	.loc	0 82 5
	bge	a0, a1, .LBB5_4
	j	.LBB5_2
.LBB5_2:
.Ltmp24:
	.loc	0 83 27 is_stmt 1
	lw	a1, -12(s0)
	.loc	0 83 33 is_stmt 0
	lw	a0, -20(s0)
	.loc	0 83 35
	lw	a2, -28(s0)
	.loc	0 83 34
	sub	a0, a0, a2
	.loc	0 83 27
	add	a0, a0, a1
	lb	a0, -1(a0)
	.loc	0 83 9
	lw	a1, -16(s0)
	.loc	0 83 18
	lw	a3, -24(s0)
	.loc	0 83 17
	add	a2, a2, a3
	.loc	0 83 9
	add	a1, a1, a2
	.loc	0 83 25
	sb	a0, 0(a1)
	.loc	0 84 5 is_stmt 1
	j	.LBB5_3
.Ltmp25:
.LBB5_3:
	.loc	0 82 28
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	.loc	0 82 5 is_stmt 0
	j	.LBB5_1
.Ltmp26:
.LBB5_4:
	.loc	0 85 1 is_stmt 1
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Ltmp27:
.Lfunc_end5:
	.size	invertString, .Lfunc_end5-invertString
	.cfi_endproc

	.globl	complement
	.p2align	2
	.type	complement,@function
complement:
.Lfunc_begin6:
	.loc	0 92 0
	.cfi_startproc
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 32
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 2
.Ltmp28:
	.loc	0 93 9 prologue_end
	sw	a0, -20(s0)
	.loc	0 94 5
	j	.LBB6_1
.LBB6_1:
	.loc	0 94 11 is_stmt 0
	lw	a0, -12(s0)
	.loc	0 94 17
	lw	a1, -20(s0)
	.loc	0 94 11
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 10
	.loc	0 94 5
	beq	a0, a1, .LBB6_3
	j	.LBB6_2
.LBB6_2:
.Ltmp29:
	.loc	0 95 23 is_stmt 1
	lw	a0, -12(s0)
	.loc	0 95 29 is_stmt 0
	lw	a1, -20(s0)
	.loc	0 95 23
	add	a0, a0, a1
	lbu	a0, 0(a0)
	.loc	0 95 32
	addi	a0, a0, -48
	seqz	a0, a0
	.loc	0 95 23
	ori	a0, a0, 48
	.loc	0 95 9
	lw	a2, -16(s0)
	add	a1, a1, a2
	.loc	0 95 21
	sb	a0, -2(a1)
	.loc	0 96 10 is_stmt 1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
.Ltmp30:
	.loc	0 94 5
	j	.LBB6_1
.LBB6_3:
	.loc	0 98 1
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Ltmp31:
.Lfunc_end6:
	.size	complement, .Lfunc_end6-complement
	.cfi_endproc

	.globl	intToString
	.p2align	2
	.type	intToString,@function
intToString:
.Lfunc_begin7:
	.loc	0 110 0
	.cfi_startproc
	addi	sp, sp, -96
	.cfi_def_cfa_offset 96
	sw	ra, 92(sp)
	sw	s0, 88(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 96
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	li	a0, 0
.Ltmp32:
	.loc	0 111 9 prologue_end
	sw	a0, -28(s0)
	.loc	0 115 5
	j	.LBB7_1
.LBB7_1:
	.loc	0 115 11 is_stmt 0
	lw	a0, -12(s0)
	li	a1, 0
	.loc	0 115 5
	beq	a0, a1, .LBB7_5
	j	.LBB7_2
.LBB7_2:
.Ltmp33:
	.loc	0 116 23 is_stmt 1
	lw	a0, -12(s0)
	.loc	0 116 29 is_stmt 0
	lw	a1, -16(s0)
	.loc	0 116 28
	remu	a0, a0, a1
	.loc	0 116 21
	sw	a0, -72(s0)
	.loc	0 117 18 is_stmt 1
	lw	a1, -72(s0)
	.loc	0 117 15 is_stmt 0
	lw	a0, -12(s0)
	sub	a0, a0, a1
	sw	a0, -12(s0)
	.loc	0 118 17 is_stmt 1
	lw	a0, -12(s0)
	.loc	0 118 23 is_stmt 0
	lw	a1, -16(s0)
	.loc	0 118 22
	divu	a0, a0, a1
	.loc	0 118 15
	sw	a0, -12(s0)
	.loc	0 119 33 is_stmt 1
	lw	a0, -72(s0)
	li	a1, 87
	sw	a1, -84(s0)
	li	a2, 48
	li	a1, 10
	sw	a2, -80(s0)
	blt	a0, a1, .LBB7_4
	.loc	0 0 33 is_stmt 0
	lw	a0, -84(s0)
	sw	a0, -80(s0)
.LBB7_4:
	.loc	0 119 33
	lw	a0, -80(s0)
	.loc	0 119 13
	sw	a0, -76(s0)
	.loc	0 120 22 is_stmt 1
	lw	a0, -72(s0)
	.loc	0 120 34 is_stmt 0
	lw	a1, -76(s0)
	.loc	0 120 33
	add	a0, a0, a1
	.loc	0 120 14
	lw	a2, -28(s0)
	addi	a1, s0, -68
	.loc	0 120 9
	add	a1, a1, a2
	.loc	0 120 20
	sb	a0, 0(a1)
	.loc	0 121 13 is_stmt 1
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
.Ltmp34:
	.loc	0 115 5
	j	.LBB7_1
.LBB7_5:
	.loc	0 124 24
	lw	a1, -24(s0)
	.loc	0 124 32 is_stmt 0
	lw	a2, -28(s0)
	.loc	0 124 38
	lw	a3, -20(s0)
	addi	a0, s0, -68
	.loc	0 124 5
	call	invertString
	.loc	0 125 13 is_stmt 1
	lw	a1, -20(s0)
	.loc	0 125 10 is_stmt 0
	lw	a0, -28(s0)
	add	a0, a0, a1
	sw	a0, -28(s0)
	.loc	0 126 5 is_stmt 1
	lw	a0, -24(s0)
	.loc	0 126 12 is_stmt 0
	lw	a1, -28(s0)
	.loc	0 126 5
	add	a1, a0, a1
	li	a0, 10
	.loc	0 126 18
	sb	a0, 0(a1)
	.loc	0 128 12 is_stmt 1
	lw	a0, -28(s0)
	.loc	0 128 17 is_stmt 0
	addi	a0, a0, 1
	.loc	0 128 5
	lw	ra, 92(sp)
	lw	s0, 88(sp)
	addi	sp, sp, 96
	ret
.Ltmp35:
.Lfunc_end7:
	.size	intToString, .Lfunc_end7-intToString
	.cfi_endproc

	.globl	stringToInt
	.p2align	2
	.type	stringToInt,@function
stringToInt:
.Lfunc_begin8:
	.loc	0 142 0 is_stmt 1
	.cfi_startproc
	addi	sp, sp, -48
	.cfi_def_cfa_offset 48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 48
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	li	a0, 0
.Ltmp36:
	.loc	0 143 22 prologue_end
	sw	a0, -32(s0)
	li	a0, 2
.Ltmp37:
	.loc	0 144 14
	sw	a0, -36(s0)
	.loc	0 144 10 is_stmt 0
	j	.LBB8_1
.LBB8_1:
.Ltmp38:
	.loc	0 144 22
	lw	a0, -16(s0)
	.loc	0 144 29
	lw	a1, -36(s0)
	.loc	0 144 27
	sub	a0, a0, a1
	.loc	0 144 35
	lw	a1, -24(s0)
.Ltmp39:
	.loc	0 144 5
	blt	a0, a1, .LBB8_7
	j	.LBB8_2
.LBB8_2:
.Ltmp40:
	.loc	0 145 12 is_stmt 1
	lw	a0, -12(s0)
	.loc	0 145 19 is_stmt 0
	lw	a1, -16(s0)
	.loc	0 145 24
	lw	a2, -36(s0)
	.loc	0 145 23
	sub	a1, a1, a2
	.loc	0 145 12
	add	a0, a0, a1
	lbu	a1, 0(a0)
	li	a0, 57
.Ltmp41:
	.loc	0 145 12
	blt	a0, a1, .LBB8_4
	j	.LBB8_3
.LBB8_3:
.Ltmp42:
	.loc	0 146 27 is_stmt 1
	lw	a0, -12(s0)
	.loc	0 146 34 is_stmt 0
	lw	a1, -16(s0)
	.loc	0 146 39
	lw	a2, -36(s0)
	.loc	0 146 38
	sub	a1, a1, a2
	.loc	0 146 27
	add	a0, a0, a1
	lbu	a0, 0(a0)
	.loc	0 146 41
	addi	a0, a0, -48
	.loc	0 146 25
	sw	a0, -28(s0)
	.loc	0 147 9 is_stmt 1
	j	.LBB8_5
.Ltmp43:
.LBB8_4:
	.loc	0 149 27
	lw	a0, -12(s0)
	.loc	0 149 34 is_stmt 0
	lw	a1, -16(s0)
	.loc	0 149 39
	lw	a2, -36(s0)
	.loc	0 149 38
	sub	a1, a1, a2
	.loc	0 149 27
	add	a0, a0, a1
	lbu	a0, 0(a0)
	.loc	0 149 41
	addi	a0, a0, -87
	.loc	0 149 25
	sw	a0, -28(s0)
	j	.LBB8_5
.Ltmp44:
.LBB8_5:
	.loc	0 151 24 is_stmt 1
	lw	a0, -28(s0)
	.loc	0 151 42 is_stmt 0
	sw	a0, -40(s0)
	lw	a0, -20(s0)
	.loc	0 151 48
	lw	a1, -36(s0)
	.loc	0 151 49
	addi	a1, a1, -2
	.loc	0 151 36
	call	power
	mv	a1, a0
	.loc	0 151 35
	lw	a0, -40(s0)
	mul	a1, a0, a1
	.loc	0 151 21
	lw	a0, -32(s0)
	add	a0, a0, a1
	sw	a0, -32(s0)
	.loc	0 152 5 is_stmt 1
	j	.LBB8_6
.Ltmp45:
.LBB8_6:
	.loc	0 144 43
	lw	a0, -36(s0)
	addi	a0, a0, 1
	sw	a0, -36(s0)
	.loc	0 144 5 is_stmt 0
	j	.LBB8_1
.Ltmp46:
.LBB8_7:
	.loc	0 154 12 is_stmt 1
	lw	a0, -32(s0)
	.loc	0 154 5 is_stmt 0
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Ltmp47:
.Lfunc_end8:
	.size	stringToInt, .Lfunc_end8-stringToInt
	.cfi_endproc

	.globl	switchEndian
	.p2align	2
	.type	switchEndian,@function
switchEndian:
.Lfunc_begin9:
	.loc	0 165 0 is_stmt 1
	.cfi_startproc
	addi	sp, sp, -80
	.cfi_def_cfa_offset 80
	sw	ra, 76(sp)
	sw	s0, 72(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 80
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	li	a0, 1
.Ltmp48:
	.loc	0 167 13 prologue_end
	sw	a0, -56(s0)
	.loc	0 167 9 is_stmt 0
	j	.LBB9_1
.LBB9_1:
.Ltmp49:
	.loc	0 167 20
	lw	a0, -56(s0)
	.loc	0 167 24
	lw	a1, -20(s0)
	.loc	0 167 35
	addi	a1, a1, -2
.Ltmp50:
	.loc	0 167 5
	bge	a0, a1, .LBB9_4
	j	.LBB9_2
.LBB9_2:
.Ltmp51:
	.loc	0 168 22 is_stmt 1
	lw	a1, -12(s0)
	.loc	0 168 28 is_stmt 0
	lw	a0, -20(s0)
	.loc	0 168 39
	lw	a2, -56(s0)
	.loc	0 168 38
	sub	a0, a0, a2
	.loc	0 168 22
	add	a0, a0, a1
	lb	a0, -1(a0)
	addi	a1, s0, -52
	.loc	0 168 9
	sub	a1, a1, a2
	.loc	0 168 20
	sb	a0, 32(a1)
	.loc	0 169 5 is_stmt 1
	j	.LBB9_3
.Ltmp52:
.LBB9_3:
	.loc	0 167 41
	lw	a0, -56(s0)
	addi	a0, a0, 1
	sw	a0, -56(s0)
	.loc	0 167 5 is_stmt 0
	j	.LBB9_1
.Ltmp53:
.LBB9_4:
	.loc	0 170 17 is_stmt 1
	lw	a0, -20(s0)
	.loc	0 170 28 is_stmt 0
	addi	a0, a0, -2
	.loc	0 170 13
	sw	a0, -60(s0)
	.loc	0 170 9
	j	.LBB9_5
.LBB9_5:
.Ltmp54:
	.loc	0 170 33
	lw	a1, -60(s0)
	li	a0, 32
.Ltmp55:
	.loc	0 170 5
	blt	a0, a1, .LBB9_8
	j	.LBB9_6
.LBB9_6:
.Ltmp56:
	.loc	0 171 17 is_stmt 1
	lw	a1, -60(s0)
	addi	a0, s0, -52
	.loc	0 171 9 is_stmt 0
	sub	a1, a0, a1
	li	a0, 48
	.loc	0 171 20
	sb	a0, 32(a1)
	.loc	0 172 5 is_stmt 1
	j	.LBB9_7
.Ltmp57:
.LBB9_7:
	.loc	0 170 42
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	.loc	0 170 5 is_stmt 0
	j	.LBB9_5
.Ltmp58:
.LBB9_8:
	.loc	0 0 5
	li	a0, 0
.Ltmp59:
	.loc	0 173 13 is_stmt 1
	sw	a0, -64(s0)
	.loc	0 173 9 is_stmt 0
	j	.LBB9_9
.LBB9_9:
.Ltmp60:
	.loc	0 173 20
	lw	a1, -64(s0)
	li	a0, 31
.Ltmp61:
	.loc	0 173 5
	blt	a0, a1, .LBB9_16
	j	.LBB9_10
.LBB9_10:
	.loc	0 0 5
	li	a0, 0
.Ltmp62:
	.loc	0 174 17 is_stmt 1
	sw	a0, -68(s0)
	.loc	0 174 13 is_stmt 0
	j	.LBB9_11
.LBB9_11:
.Ltmp63:
	.loc	0 174 24
	lw	a1, -68(s0)
	li	a0, 7
.Ltmp64:
	.loc	0 174 9
	blt	a0, a1, .LBB9_14
	j	.LBB9_12
.LBB9_12:
.Ltmp65:
	.loc	0 175 35 is_stmt 1
	lw	a2, -64(s0)
	.loc	0 175 39 is_stmt 0
	lw	a3, -68(s0)
	.loc	0 175 38
	sub	a0, a2, a3
	addi	a1, s0, -52
	add	a0, a0, a1
	.loc	0 175 30
	lb	a0, 7(a0)
	.loc	0 175 13
	lw	a1, -16(s0)
	.loc	0 175 24
	add	a2, a2, a3
	.loc	0 175 13
	sub	a1, a1, a2
	.loc	0 175 28
	sb	a0, 31(a1)
	.loc	0 176 9 is_stmt 1
	j	.LBB9_13
.Ltmp66:
.LBB9_13:
	.loc	0 174 32
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	.loc	0 174 9 is_stmt 0
	j	.LBB9_11
.Ltmp67:
.LBB9_14:
	.loc	0 177 5 is_stmt 1
	j	.LBB9_15
.Ltmp68:
.LBB9_15:
	.loc	0 173 29
	lw	a0, -64(s0)
	addi	a0, a0, 8
	sw	a0, -64(s0)
	.loc	0 173 5 is_stmt 0
	j	.LBB9_9
.Ltmp69:
.LBB9_16:
	.loc	0 178 1 is_stmt 1
	lw	ra, 76(sp)
	lw	s0, 72(sp)
	addi	sp, sp, 80
	ret
.Ltmp70:
.Lfunc_end9:
	.size	switchEndian, .Lfunc_end9-switchEndian
	.cfi_endproc

	.globl	main
	.p2align	2
	.type	main,@function
main:
.Lfunc_begin10:
	.loc	0 180 0
	.cfi_startproc
	addi	sp, sp, -272
	.cfi_def_cfa_offset 272
	sw	ra, 268(sp)
	sw	s0, 264(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 272
	.cfi_def_cfa s0, 0
	li	a0, 0
	sw	a0, -12(s0)
.Ltmp71:
	.loc	0 183 9 prologue_end
	sw	a0, -200(s0)
	.loc	0 183 23 is_stmt 0
	sw	a0, -204(s0)
	.loc	0 183 41
	sw	a0, -208(s0)
	.loc	0 183 55
	sw	a0, -212(s0)
	addi	a1, s0, -32
	li	a2, 20
	.loc	0 186 13 is_stmt 1
	call	read
	.loc	0 186 9 is_stmt 0
	sw	a0, -220(s0)
.Ltmp72:
	.loc	0 189 8 is_stmt 1
	lbu	a0, -32(s0)
	li	a1, 48
	.loc	0 189 24 is_stmt 0
	bne	a0, a1, .LBB10_6
	j	.LBB10_1
.LBB10_1:
	.loc	0 189 27
	lbu	a0, -31(s0)
	li	a1, 120
.Ltmp73:
	.loc	0 189 8
	bne	a0, a1, .LBB10_6
	j	.LBB10_2
.LBB10_2:
.Ltmp74:
	.loc	0 190 32 is_stmt 1
	lw	a2, -220(s0)
	addi	a0, s0, -32
	addi	a1, s0, -124
	.loc	0 190 9 is_stmt 0
	sw	a1, -228(s0)
	call	copyString
	lw	a0, -228(s0)
	.loc	0 191 20 is_stmt 1
	lw	a1, -220(s0)
	.loc	0 191 18 is_stmt 0
	sw	a1, -208(s0)
	.loc	0 192 34 is_stmt 1
	lw	a1, -220(s0)
	li	a2, 16
	li	a3, 2
	.loc	0 192 17 is_stmt 0
	sw	a3, -224(s0)
	call	stringToInt
	lw	a2, -224(s0)
	.loc	0 192 15
	sw	a0, -216(s0)
	li	a0, 48
	.loc	0 193 19 is_stmt 1
	sb	a0, -72(s0)
	li	a0, 98
	.loc	0 194 19
	sb	a0, -71(s0)
	.loc	0 195 32
	lw	a0, -216(s0)
	addi	a3, s0, -72
	.loc	0 195 20 is_stmt 0
	mv	a1, a2
	call	intToString
	.loc	0 195 18
	sw	a0, -200(s0)
.Ltmp75:
	.loc	0 198 13 is_stmt 1
	lw	a0, -216(s0)
	li	a1, 0
.Ltmp76:
	.loc	0 198 13 is_stmt 0
	bge	a0, a1, .LBB10_4
	j	.LBB10_3
.LBB10_3:
	.loc	0 0 13
	addi	a0, s0, -72
	addi	a1, s0, -104
.Ltmp77:
	.loc	0 199 13 is_stmt 1
	sw	a1, -232(s0)
	call	complement
	lw	a0, -232(s0)
	.loc	0 200 52
	lw	a1, -200(s0)
	.loc	0 200 60 is_stmt 0
	addi	a1, a1, -2
	li	a2, 2
	li	a3, 0
	.loc	0 200 21
	call	stringToInt
	.loc	0 200 19
	sw	a0, -216(s0)
	li	a0, 45
	.loc	0 201 24 is_stmt 1
	sb	a0, -144(s0)
	.loc	0 202 40
	lw	a0, -216(s0)
	.loc	0 202 46 is_stmt 0
	addi	a0, a0, 1
	li	a1, 10
	li	a2, 1
	addi	a3, s0, -144
	.loc	0 202 28
	call	intToString
	.loc	0 202 26
	sw	a0, -204(s0)
	.loc	0 203 9 is_stmt 1
	j	.LBB10_5
.Ltmp78:
.LBB10_4:
	.loc	0 207 40
	lw	a0, -216(s0)
	li	a1, 10
	li	a2, 0
	addi	a3, s0, -144
	.loc	0 207 28 is_stmt 0
	call	intToString
	.loc	0 207 26
	sw	a0, -204(s0)
	j	.LBB10_5
.Ltmp79:
.LBB10_5:
	.loc	0 210 40 is_stmt 1
	lw	a2, -200(s0)
	addi	a0, s0, -72
	addi	a1, s0, -176
	.loc	0 210 9 is_stmt 0
	sw	a1, -240(s0)
	call	switchEndian
	lw	a0, -240(s0)
	li	a1, 33
	li	a2, 2
	li	a3, 0
	.loc	0 211 17 is_stmt 1
	sw	a3, -236(s0)
	call	stringToInt
	lw	a2, -236(s0)
	.loc	0 211 15 is_stmt 0
	sw	a0, -216(s0)
	.loc	0 212 35 is_stmt 1
	lw	a0, -216(s0)
	li	a1, 10
	addi	a3, s0, -196
	.loc	0 212 23 is_stmt 0
	call	intToString
	.loc	0 212 21
	sw	a0, -212(s0)
	.loc	0 213 5 is_stmt 1
	j	.LBB10_10
.Ltmp80:
.LBB10_6:
	.loc	0 217 36
	lw	a2, -220(s0)
	addi	a0, s0, -32
	addi	a1, s0, -144
	.loc	0 217 9 is_stmt 0
	call	copyString
	.loc	0 218 24 is_stmt 1
	lw	a0, -220(s0)
	.loc	0 218 22 is_stmt 0
	sw	a0, -204(s0)
.Ltmp81:
	.loc	0 221 12 is_stmt 1
	lbu	a0, -32(s0)
	li	a1, 45
.Ltmp82:
	.loc	0 221 12 is_stmt 0
	bne	a0, a1, .LBB10_8
	j	.LBB10_7
.LBB10_7:
.Ltmp83:
	.loc	0 222 42 is_stmt 1
	lw	a1, -220(s0)
	addi	a0, s0, -144
	li	a2, 10
	li	a3, 1
	.loc	0 222 21 is_stmt 0
	call	stringToInt
	.loc	0 222 19
	sw	a0, -216(s0)
	.loc	0 223 21 is_stmt 1
	lw	a1, -216(s0)
	li	a0, 0
	.loc	0 223 27 is_stmt 0
	sub	a0, a0, a1
	.loc	0 223 19
	sw	a0, -216(s0)
	.loc	0 224 9 is_stmt 1
	j	.LBB10_9
.Ltmp84:
.LBB10_8:
	.loc	0 228 42
	lw	a1, -220(s0)
	addi	a0, s0, -144
	li	a2, 10
	li	a3, 0
	.loc	0 228 21 is_stmt 0
	call	stringToInt
	.loc	0 228 19
	sw	a0, -216(s0)
	j	.LBB10_9
.Ltmp85:
.LBB10_9:
	.loc	0 0 19
	li	a0, 48
	.loc	0 231 19 is_stmt 1
	sw	a0, -260(s0)
	sb	a0, -72(s0)
	li	a0, 98
	.loc	0 232 19
	sb	a0, -71(s0)
	.loc	0 233 32
	lw	a0, -216(s0)
	li	a2, 2
	sw	a2, -248(s0)
	addi	a3, s0, -72
	.loc	0 233 20 is_stmt 0
	sw	a3, -256(s0)
	mv	a1, a2
	call	intToString
	lw	a2, -248(s0)
	mv	a1, a0
	.loc	0 233 18
	lw	a0, -260(s0)
	sw	a1, -200(s0)
	.loc	0 234 16 is_stmt 1
	sb	a0, -124(s0)
	li	a0, 120
	.loc	0 235 16
	sb	a0, -123(s0)
	.loc	0 236 32
	lw	a0, -216(s0)
	li	a1, 16
	addi	a3, s0, -124
	.loc	0 236 20 is_stmt 0
	call	intToString
	mv	a1, a0
	.loc	0 236 18
	lw	a0, -256(s0)
	sw	a1, -208(s0)
	.loc	0 237 40 is_stmt 1
	lw	a2, -200(s0)
	addi	a1, s0, -176
	.loc	0 237 9 is_stmt 0
	sw	a1, -252(s0)
	call	switchEndian
	lw	a0, -252(s0)
	lw	a2, -248(s0)
	li	a1, 33
	li	a3, 0
	.loc	0 238 17 is_stmt 1
	sw	a3, -244(s0)
	call	stringToInt
	lw	a2, -244(s0)
	.loc	0 238 15 is_stmt 0
	sw	a0, -216(s0)
	.loc	0 239 35 is_stmt 1
	lw	a0, -216(s0)
	li	a1, 10
	addi	a3, s0, -196
	.loc	0 239 23 is_stmt 0
	call	intToString
	.loc	0 239 21
	sw	a0, -212(s0)
	j	.LBB10_10
.Ltmp86:
.LBB10_10:
	.loc	0 243 22 is_stmt 1
	lw	a2, -200(s0)
	li	a0, 1
	sw	a0, -264(s0)
	addi	a1, s0, -72
	.loc	0 243 5 is_stmt 0
	call	write
	lw	a0, -264(s0)
	.loc	0 244 23 is_stmt 1
	lw	a2, -204(s0)
	addi	a1, s0, -144
	.loc	0 244 5 is_stmt 0
	call	write
	lw	a0, -264(s0)
	.loc	0 245 19 is_stmt 1
	lw	a2, -208(s0)
	addi	a1, s0, -124
	.loc	0 245 5 is_stmt 0
	call	write
	lw	a0, -264(s0)
	.loc	0 246 25 is_stmt 1
	lw	a2, -212(s0)
	addi	a1, s0, -196
	.loc	0 246 5 is_stmt 0
	call	write
	li	a0, 0
	.loc	0 248 5 is_stmt 1
	lw	ra, 268(sp)
	lw	s0, 264(sp)
	addi	sp, sp, 272
	ret
.Ltmp87:
.Lfunc_end10:
	.size	main, .Lfunc_end10-main
	.cfi_endproc

	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
.Lfunc_begin11:
	.loc	0 251 0
	.cfi_startproc
	addi	sp, sp, -16
	.cfi_def_cfa_offset 16
.Ltmp88:
	.loc	0 252 18 prologue_end
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 16
	.cfi_def_cfa s0, 0
	call	main
	.loc	0 252 5 is_stmt 0
	call	exit_syscall
	.loc	0 253 1 is_stmt 1
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Ltmp89:
.Lfunc_end11:
	.size	_start, .Lfunc_end11-_start
	.cfi_endproc

	.section	.debug_abbrev,"",@progbits
	.byte	1
	.byte	17
	.byte	1
	.byte	37
	.byte	37
	.byte	19
	.byte	5
	.byte	3
	.byte	37
	.byte	114
	.byte	23
	.byte	16
	.byte	23
	.byte	27
	.byte	37
	.byte	17
	.byte	27
	.byte	18
	.byte	6
	.byte	115
	.byte	23
	.byte	0
	.byte	0
	.byte	2
	.byte	46
	.byte	1
	.byte	17
	.byte	27
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	3
	.byte	37
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	39
	.byte	25
	.byte	73
	.byte	19
	.byte	63
	.byte	25
	.byte	0
	.byte	0
	.byte	3
	.byte	5
	.byte	0
	.byte	2
	.byte	24
	.byte	3
	.byte	37
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	4
	.byte	52
	.byte	0
	.byte	2
	.byte	24
	.byte	3
	.byte	37
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	5
	.byte	46
	.byte	1
	.byte	17
	.byte	27
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	3
	.byte	37
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	39
	.byte	25
	.byte	63
	.byte	25
	.byte	0
	.byte	0
	.byte	6
	.byte	11
	.byte	1
	.byte	17
	.byte	27
	.byte	18
	.byte	6
	.byte	0
	.byte	0
	.byte	7
	.byte	46
	.byte	1
	.byte	17
	.byte	27
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	3
	.byte	37
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	73
	.byte	19
	.byte	63
	.byte	25
	.byte	0
	.byte	0
	.byte	8
	.byte	46
	.byte	0
	.byte	17
	.byte	27
	.byte	18
	.byte	6
	.byte	64
	.byte	24
	.byte	3
	.byte	37
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	63
	.byte	25
	.byte	0
	.byte	0
	.byte	9
	.byte	36
	.byte	0
	.byte	3
	.byte	37
	.byte	62
	.byte	11
	.byte	11
	.byte	11
	.byte	0
	.byte	0
	.byte	10
	.byte	15
	.byte	0
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	11
	.byte	38
	.byte	0
	.byte	0
	.byte	0
	.byte	12
	.byte	1
	.byte	1
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	13
	.byte	33
	.byte	0
	.byte	73
	.byte	19
	.byte	55
	.byte	11
	.byte	0
	.byte	0
	.byte	14
	.byte	36
	.byte	0
	.byte	3
	.byte	37
	.byte	11
	.byte	11
	.byte	62
	.byte	11
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.word	.Ldebug_info_end0-.Ldebug_info_start0
.Ldebug_info_start0:
	.half	5
	.byte	1
	.byte	4
	.word	.debug_abbrev
	.byte	1
	.byte	0
	.half	12
	.byte	1
	.word	.Lstr_offsets_base0
	.word	.Lline_table_start0
	.byte	2
	.byte	0
	.word	.Lfunc_end11-.Lfunc_begin0
	.word	.Laddr_table_base0
	.byte	2
	.byte	0
	.word	.Lfunc_end0-.Lfunc_begin0
	.byte	1
	.byte	88
	.byte	3
	.byte	0
	.byte	5

	.word	937

	.byte	3
	.byte	2
	.byte	145
	.byte	116
	.byte	16
	.byte	0
	.byte	5
	.word	937
	.byte	3
	.byte	2
	.byte	145
	.byte	112
	.byte	17
	.byte	0
	.byte	5
	.word	941
	.byte	3
	.byte	2
	.byte	145
	.byte	108
	.byte	18
	.byte	0
	.byte	5
	.word	937
	.byte	4
	.byte	2
	.byte	145
	.byte	104
	.byte	19
	.byte	0
	.byte	6
	.word	937
	.byte	0
	.byte	5
	.byte	1
	.word	.Lfunc_end1-.Lfunc_begin1
	.byte	1
	.byte	88
	.byte	5
	.byte	0
	.byte	21


	.byte	3
	.byte	2
	.byte	145
	.byte	116
	.byte	16
	.byte	0
	.byte	21
	.word	937
	.byte	3
	.byte	2
	.byte	145
	.byte	112
	.byte	17
	.byte	0
	.byte	21
	.word	941
	.byte	3
	.byte	2
	.byte	145
	.byte	108
	.byte	18
	.byte	0
	.byte	21
	.word	937
	.byte	0
	.byte	5
	.byte	2
	.word	.Lfunc_end2-.Lfunc_begin2
	.byte	1
	.byte	88
	.byte	6
	.byte	0
	.byte	38


	.byte	3
	.byte	2
	.byte	145
	.byte	116
	.byte	20
	.byte	0
	.byte	38
	.word	937
	.byte	0
	.byte	2
	.byte	3
	.word	.Lfunc_end3-.Lfunc_begin3
	.byte	1
	.byte	88
	.byte	7
	.byte	0
	.byte	54

	.word	937

	.byte	3
	.byte	2
	.byte	145
	.byte	116
	.byte	21
	.byte	0
	.byte	54
	.word	937
	.byte	3
	.byte	2
	.byte	145
	.byte	112
	.byte	22
	.byte	0
	.byte	54
	.word	937
	.byte	4
	.byte	2
	.byte	145
	.byte	108
	.byte	23
	.byte	0
	.byte	55
	.word	937
	.byte	6
	.byte	4
	.word	.Ltmp12-.Ltmp7
	.byte	4
	.byte	2
	.byte	145
	.byte	104
	.byte	24
	.byte	0
	.byte	56
	.word	937
	.byte	0
	.byte	0
	.byte	5
	.byte	5
	.word	.Lfunc_end4-.Lfunc_begin4
	.byte	1
	.byte	88
	.byte	8
	.byte	0
	.byte	68


	.byte	3
	.byte	2
	.byte	145
	.byte	116
	.byte	25
	.byte	0
	.byte	68
	.word	947
	.byte	3
	.byte	2
	.byte	145
	.byte	112
	.byte	27
	.byte	0
	.byte	68
	.word	947
	.byte	3
	.byte	2
	.byte	145
	.byte	108
	.byte	28
	.byte	0
	.byte	68
	.word	937
	.byte	6
	.byte	6
	.word	.Ltmp19-.Ltmp14
	.byte	4
	.byte	2
	.byte	145
	.byte	104
	.byte	24
	.byte	0
	.byte	69
	.word	937
	.byte	0
	.byte	0
	.byte	5
	.byte	7
	.word	.Lfunc_end5-.Lfunc_begin5
	.byte	1
	.byte	88
	.byte	9
	.byte	0
	.byte	81


	.byte	3
	.byte	2
	.byte	145
	.byte	116
	.byte	25
	.byte	0
	.byte	81
	.word	947
	.byte	3
	.byte	2
	.byte	145
	.byte	112
	.byte	27
	.byte	0
	.byte	81
	.word	947
	.byte	3
	.byte	2
	.byte	145
	.byte	108
	.byte	28
	.byte	0
	.byte	81
	.word	937
	.byte	3
	.byte	2
	.byte	145
	.byte	104
	.byte	29
	.byte	0
	.byte	81
	.word	937
	.byte	6
	.byte	8
	.word	.Ltmp26-.Ltmp21
	.byte	4
	.byte	2
	.byte	145
	.byte	100
	.byte	24
	.byte	0
	.byte	82
	.word	937
	.byte	0
	.byte	0
	.byte	5
	.byte	9
	.word	.Lfunc_end6-.Lfunc_begin6
	.byte	1
	.byte	88
	.byte	10
	.byte	0
	.byte	92


	.byte	3
	.byte	2
	.byte	145
	.byte	116
	.byte	25
	.byte	0
	.byte	92
	.word	947
	.byte	3
	.byte	2
	.byte	145
	.byte	112
	.byte	27
	.byte	0
	.byte	92
	.word	947
	.byte	4
	.byte	2
	.byte	145
	.byte	108
	.byte	24
	.byte	0
	.byte	93
	.word	937
	.byte	0
	.byte	2
	.byte	10
	.word	.Lfunc_end7-.Lfunc_begin7
	.byte	1
	.byte	88
	.byte	11
	.byte	0
	.byte	110

	.word	937

	.byte	3
	.byte	2
	.byte	145
	.byte	116
	.byte	30
	.byte	0
	.byte	110
	.word	956
	.byte	3
	.byte	2
	.byte	145
	.byte	112
	.byte	21
	.byte	0
	.byte	110
	.word	937
	.byte	3
	.byte	2
	.byte	145
	.byte	108
	.byte	29
	.byte	0
	.byte	110
	.word	937
	.byte	3
	.byte	2
	.byte	145
	.byte	104
	.byte	32
	.byte	0
	.byte	110
	.word	947
	.byte	4
	.byte	2
	.byte	145
	.byte	100
	.byte	33
	.byte	0
	.byte	111
	.word	937
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\274\177"
	.byte	34
	.byte	0
	.byte	112
	.word	960
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\270\177"
	.byte	36
	.byte	0
	.byte	113
	.word	937
	.byte	6
	.byte	11
	.word	.Ltmp34-.Ltmp33
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\264\177"
	.byte	37
	.byte	0
	.byte	119
	.word	937
	.byte	0
	.byte	0
	.byte	2
	.byte	12
	.word	.Lfunc_end8-.Lfunc_begin8
	.byte	1
	.byte	88
	.byte	12
	.byte	0
	.byte	142

	.word	937

	.byte	3
	.byte	2
	.byte	145
	.byte	116
	.byte	32
	.byte	0
	.byte	142
	.word	947
	.byte	3
	.byte	2
	.byte	145
	.byte	112
	.byte	33
	.byte	0
	.byte	142
	.word	937
	.byte	3
	.byte	2
	.byte	145
	.byte	108
	.byte	21
	.byte	0
	.byte	142
	.word	937
	.byte	3
	.byte	2
	.byte	145
	.byte	104
	.byte	29
	.byte	0
	.byte	142
	.word	937
	.byte	4
	.byte	2
	.byte	145
	.byte	100
	.byte	36
	.byte	0
	.byte	143
	.word	937
	.byte	4
	.byte	2
	.byte	145
	.byte	96
	.byte	38
	.byte	0
	.byte	143
	.word	937
	.byte	6
	.byte	13
	.word	.Ltmp46-.Ltmp37
	.byte	4
	.byte	2
	.byte	145
	.byte	92
	.byte	24
	.byte	0
	.byte	144
	.word	937
	.byte	0
	.byte	0
	.byte	5
	.byte	14
	.word	.Lfunc_end9-.Lfunc_begin9
	.byte	1
	.byte	88
	.byte	13
	.byte	0
	.byte	165


	.byte	3
	.byte	2
	.byte	145
	.byte	116
	.byte	25
	.byte	0
	.byte	165
	.word	947
	.byte	3
	.byte	2
	.byte	145
	.byte	112
	.byte	27
	.byte	0
	.byte	165
	.word	947
	.byte	3
	.byte	2
	.byte	145
	.byte	108
	.byte	39
	.byte	0
	.byte	165
	.word	937
	.byte	4
	.byte	2
	.byte	145
	.byte	76
	.byte	34
	.byte	0
	.byte	166
	.word	976
	.byte	6
	.byte	15
	.word	.Ltmp53-.Ltmp48
	.byte	4
	.byte	2
	.byte	145
	.byte	72
	.byte	24
	.byte	0
	.byte	167
	.word	937
	.byte	0
	.byte	6
	.byte	16
	.word	.Ltmp58-.Ltmp53
	.byte	4
	.byte	2
	.byte	145
	.byte	68
	.byte	24
	.byte	0
	.byte	170
	.word	937
	.byte	0
	.byte	6
	.byte	17
	.word	.Ltmp69-.Ltmp59
	.byte	4
	.byte	2
	.byte	145
	.byte	64
	.byte	24
	.byte	0
	.byte	173
	.word	937
	.byte	6
	.byte	18
	.word	.Ltmp67-.Ltmp62
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\274\177"
	.byte	40
	.byte	0
	.byte	174
	.word	937
	.byte	0
	.byte	0
	.byte	0
	.byte	7
	.byte	19
	.word	.Lfunc_end10-.Lfunc_begin10
	.byte	1
	.byte	88
	.byte	14
	.byte	0
	.byte	180
	.word	937

	.byte	4
	.byte	2
	.byte	145
	.byte	96
	.byte	25
	.byte	0
	.byte	181
	.word	988
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\270\177"
	.byte	41
	.byte	0
	.byte	182
	.word	960
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\230\177"
	.byte	42
	.byte	0
	.byte	182
	.word	976
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\204\177"
	.byte	43
	.byte	0
	.byte	182
	.word	988
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\360~"
	.byte	44
	.byte	0
	.byte	182
	.word	988
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\320~"
	.byte	45
	.byte	0
	.byte	182
	.word	976
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\274~"
	.byte	46
	.byte	0
	.byte	182
	.word	988
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\270~"
	.byte	47
	.byte	0
	.byte	183
	.word	937
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\264~"
	.byte	48
	.byte	0
	.byte	183
	.word	937
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\260~"
	.byte	49
	.byte	0
	.byte	183
	.word	937
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\254~"
	.byte	50
	.byte	0
	.byte	183
	.word	937
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\250~"
	.byte	30
	.byte	0
	.byte	184
	.word	937
	.byte	4
	.byte	3
	.byte	145
	.ascii	"\244~"
	.byte	28
	.byte	0
	.byte	186
	.word	937
	.byte	0
	.byte	8
	.byte	20
	.word	.Lfunc_end11-.Lfunc_begin11
	.byte	1
	.byte	88
	.byte	15
	.byte	0
	.byte	251

	.byte	9
	.byte	4
	.byte	5
	.byte	4
	.byte	10
	.word	946
	.byte	11
	.byte	10
	.word	952
	.byte	9
	.byte	26
	.byte	8
	.byte	1
	.byte	9
	.byte	31
	.byte	7
	.byte	4
	.byte	12
	.word	952
	.byte	13
	.word	972
	.byte	40
	.byte	0
	.byte	14
	.byte	35
	.byte	8
	.byte	7
	.byte	12
	.word	952
	.byte	13
	.word	972
	.byte	32
	.byte	0
	.byte	12
	.word	952
	.byte	13
	.word	972
	.byte	20
	.byte	0
	.byte	0
.Ldebug_info_end0:
	.section	.debug_str_offsets,"",@progbits
	.word	208
	.half	5
	.half	0
.Lstr_offsets_base0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"Ubuntu clang version 14.0.0-1ubuntu1"
.Linfo_string1:
	.asciz	"lab03.c"
.Linfo_string2:
	.asciz	"/home/ceccon/Documents/MC404/lab3"
.Linfo_string3:
	.asciz	"read"
.Linfo_string4:
	.asciz	"int"
.Linfo_string5:
	.asciz	"write"
.Linfo_string6:
	.asciz	"exit_syscall"
.Linfo_string7:
	.asciz	"power"
.Linfo_string8:
	.asciz	"copyString"
.Linfo_string9:
	.asciz	"invertString"
.Linfo_string10:
	.asciz	"complement"
.Linfo_string11:
	.asciz	"intToString"
.Linfo_string12:
	.asciz	"stringToInt"
.Linfo_string13:
	.asciz	"switchEndian"
.Linfo_string14:
	.asciz	"main"
.Linfo_string15:
	.asciz	"_start"
.Linfo_string16:
	.asciz	"__fd"
.Linfo_string17:
	.asciz	"__buf"
.Linfo_string18:
	.asciz	"__n"
.Linfo_string19:
	.asciz	"bytes"
.Linfo_string20:
	.asciz	"error_code"
.Linfo_string21:
	.asciz	"base"
.Linfo_string22:
	.asciz	"exponent"
.Linfo_string23:
	.asciz	"result"
.Linfo_string24:
	.asciz	"i"
.Linfo_string25:
	.asciz	"input"
.Linfo_string26:
	.asciz	"char"
.Linfo_string27:
	.asciz	"output"
.Linfo_string28:
	.asciz	"n"
.Linfo_string29:
	.asciz	"start"
.Linfo_string30:
	.asciz	"value"
.Linfo_string31:
	.asciz	"unsigned int"
.Linfo_string32:
	.asciz	"string"
.Linfo_string33:
	.asciz	"size"
.Linfo_string34:
	.asciz	"temp"
.Linfo_string35:
	.asciz	"__ARRAY_SIZE_TYPE__"
.Linfo_string36:
	.asciz	"digit_value"
.Linfo_string37:
	.asciz	"ascii_complement"
.Linfo_string38:
	.asciz	"total_value"
.Linfo_string39:
	.asciz	"input_size"
.Linfo_string40:
	.asciz	"j"
.Linfo_string41:
	.asciz	"binary"
.Linfo_string42:
	.asciz	"binary_complement"
.Linfo_string43:
	.asciz	"hex"
.Linfo_string44:
	.asciz	"decimal"
.Linfo_string45:
	.asciz	"endian_2"
.Linfo_string46:
	.asciz	"endian_10"
.Linfo_string47:
	.asciz	"bin_size"
.Linfo_string48:
	.asciz	"decimal_size"
.Linfo_string49:
	.asciz	"hex_size"
.Linfo_string50:
	.asciz	"endian_size"
	.section	.debug_str_offsets,"",@progbits
	.word	.Linfo_string0
	.word	.Linfo_string1
	.word	.Linfo_string2
	.word	.Linfo_string3
	.word	.Linfo_string4
	.word	.Linfo_string5
	.word	.Linfo_string6
	.word	.Linfo_string7
	.word	.Linfo_string8
	.word	.Linfo_string9
	.word	.Linfo_string10
	.word	.Linfo_string11
	.word	.Linfo_string12
	.word	.Linfo_string13
	.word	.Linfo_string14
	.word	.Linfo_string15
	.word	.Linfo_string16
	.word	.Linfo_string17
	.word	.Linfo_string18
	.word	.Linfo_string19
	.word	.Linfo_string20
	.word	.Linfo_string21
	.word	.Linfo_string22
	.word	.Linfo_string23
	.word	.Linfo_string24
	.word	.Linfo_string25
	.word	.Linfo_string26
	.word	.Linfo_string27
	.word	.Linfo_string28
	.word	.Linfo_string29
	.word	.Linfo_string30
	.word	.Linfo_string31
	.word	.Linfo_string32
	.word	.Linfo_string33
	.word	.Linfo_string34
	.word	.Linfo_string35
	.word	.Linfo_string36
	.word	.Linfo_string37
	.word	.Linfo_string38
	.word	.Linfo_string39
	.word	.Linfo_string40
	.word	.Linfo_string41
	.word	.Linfo_string42
	.word	.Linfo_string43
	.word	.Linfo_string44
	.word	.Linfo_string45
	.word	.Linfo_string46
	.word	.Linfo_string47
	.word	.Linfo_string48
	.word	.Linfo_string49
	.word	.Linfo_string50
	.section	.debug_addr,"",@progbits
	.word	.Ldebug_addr_end0-.Ldebug_addr_start0
.Ldebug_addr_start0:
	.half	5
	.byte	4
	.byte	0
.Laddr_table_base0:
	.word	.Lfunc_begin0
	.word	.Lfunc_begin1
	.word	.Lfunc_begin2
	.word	.Lfunc_begin3
	.word	.Ltmp7
	.word	.Lfunc_begin4
	.word	.Ltmp14
	.word	.Lfunc_begin5
	.word	.Ltmp21
	.word	.Lfunc_begin6
	.word	.Lfunc_begin7
	.word	.Ltmp33
	.word	.Lfunc_begin8
	.word	.Ltmp37
	.word	.Lfunc_begin9
	.word	.Ltmp48
	.word	.Ltmp53
	.word	.Ltmp59
	.word	.Ltmp62
	.word	.Lfunc_begin10
	.word	.Lfunc_begin11
.Ldebug_addr_end0:
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym exit_syscall
	.addrsig_sym power
	.addrsig_sym copyString
	.addrsig_sym invertString
	.addrsig_sym complement
	.addrsig_sym intToString
	.addrsig_sym stringToInt
	.addrsig_sym switchEndian
	.addrsig_sym main
	.section	.debug_line,"",@progbits
.Lline_table_start0:
