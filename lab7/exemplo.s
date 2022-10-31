	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"exemplo.c"
	.file	0 "/home/ceccon/Documents/MC404/lab7" "exemplo.c" md5 0x18563dd28f6da19f319a753c52f78f4b
	.globl	run_operation
	.p2align	2
	.type	run_operation,@function
run_operation:
.Lfunc_begin0:
	.loc	0 7 0
	.cfi_sections .debug_frame
	.cfi_startproc
	addi	sp, sp, -112
	.cfi_def_cfa_offset 112
	sw	ra, 108(sp)
	sw	s0, 104(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 112
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
.Ltmp0:
	.loc	0 10 11 prologue_end
	lw	a1, -12(s0)
	sw	a1, -84(s0)
	li	a0, 10
	.loc	0 10 3 is_stmt 0
	bltu	a0, a1, .LBB0_28
	.loc	0 0 3
	lw	a0, -84(s0)
	slli	a0, a0, 2
	lui	a1, %hi(.LJTI0_0)
	addi	a1, a1, %lo(.LJTI0_0)
	add	a0, a0, a1
	lw	a0, 0(a0)
	jr	a0
.LBB0_2:
.Ltmp1:
	.loc	0 12 5 is_stmt 1
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	call	puts
	.loc	0 13 5
	j	.LBB0_29
.LBB0_3:
	.loc	0 16 5
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	sw	a0, -88(s0)
	call	gets
	.loc	0 17 5
	lw	a0, -88(s0)
	call	puts
	.loc	0 18 5
	j	.LBB0_29
.LBB0_4:
	.loc	0 21 15
	lui	a0, %hi(number)
	lw	a0, %lo(number)(a0)
	.loc	0 21 10 is_stmt 0
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	li	a2, 10
	call	itoa
	.loc	0 21 5
	call	puts
	.loc	0 22 5 is_stmt 1
	j	.LBB0_29
.LBB0_5:
	.loc	0 25 20
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	sw	a0, -92(s0)
	call	gets
	.loc	0 25 15 is_stmt 0
	call	atoi
	lw	a1, -92(s0)
	li	a2, 16
	.loc	0 25 10
	call	itoa
	.loc	0 25 5
	call	puts
	.loc	0 26 5 is_stmt 1
	j	.LBB0_29
.LBB0_6:
	.loc	0 29 10
	call	time
	.loc	0 29 8 is_stmt 0
	sw	a0, -16(s0)
	.loc	0 30 11 is_stmt 1
	lui	a0, %hi(number)
	lw	a0, %lo(number)(a0)
	.loc	0 30 5 is_stmt 0
	call	sleep
	.loc	0 31 10 is_stmt 1
	call	time
	.loc	0 31 8 is_stmt 0
	sw	a0, -20(s0)
	.loc	0 32 15 is_stmt 1
	lw	a0, -20(s0)
	.loc	0 32 18 is_stmt 0
	lw	a1, -16(s0)
	.loc	0 32 17
	sub	a0, a0, a1
	.loc	0 32 10
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	li	a2, 10
	call	itoa
	.loc	0 32 5
	call	puts
	.loc	0 33 5 is_stmt 1
	j	.LBB0_29
.LBB0_7:
	.loc	0 36 15
	call	time
	.loc	0 36 10 is_stmt 0
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	li	a2, 10
	call	itoa
	.loc	0 36 5
	call	puts
	.loc	0 37 5 is_stmt 1
	j	.LBB0_29
.LBB0_8:
	.loc	0 40 27
	lui	a0, %hi(number)
	lw	a0, %lo(number)(a0)
	li	a1, 40
	.loc	0 40 15 is_stmt 0
	call	approx_sqrt
	.loc	0 40 10
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	li	a2, 10
	call	itoa
	.loc	0 40 5
	call	puts
	.loc	0 41 5 is_stmt 1
	j	.LBB0_29
.LBB0_9:
	.loc	0 44 10
	call	time
	.loc	0 44 8 is_stmt 0
	sw	a0, -16(s0)
	.loc	0 45 17 is_stmt 1
	lui	a0, %hi(number)
	sw	a0, -104(s0)
	lw	a0, %lo(number)(a0)
	li	a1, 100
	.loc	0 45 5 is_stmt 0
	call	approx_sqrt
	.loc	0 46 10 is_stmt 1
	call	time
	.loc	0 46 8 is_stmt 0
	sw	a0, -20(s0)
	.loc	0 47 15 is_stmt 1
	lw	a0, -20(s0)
	.loc	0 47 18 is_stmt 0
	lw	a1, -16(s0)
	.loc	0 47 17
	sub	a0, a0, a1
	.loc	0 47 10
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	sw	a1, -100(s0)
	li	a2, 10
	sw	a2, -96(s0)
	call	itoa
	.loc	0 47 5
	call	puts
	lw	a0, -104(s0)
	lw	a1, -100(s0)
	lw	a2, -96(s0)
	.loc	0 48 15 is_stmt 1
	lw	a0, %lo(number)(a0)
	.loc	0 48 10 is_stmt 0
	call	itoa
	.loc	0 48 5
	call	puts
	.loc	0 49 5 is_stmt 1
	j	.LBB0_29
.LBB0_10:
	.loc	0 52 18
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	sw	a0, -108(s0)
	call	gets
	.loc	0 52 13 is_stmt 0
	call	atoi
	mv	a1, a0
	.loc	0 52 11
	lw	a0, -108(s0)
	sw	a1, -56(s0)
	.loc	0 53 19 is_stmt 1
	call	gets
	.loc	0 53 14 is_stmt 0
	call	atoi
	.loc	0 53 12
	sw	a0, -60(s0)
	li	a0, 0
.Ltmp2:
	.loc	0 54 12 is_stmt 1
	sw	a0, -64(s0)
	.loc	0 54 10 is_stmt 0
	j	.LBB0_11
.LBB0_11:
.Ltmp3:
	.loc	0 54 17
	lw	a1, -64(s0)
	li	a0, 2
.Ltmp4:
	.loc	0 54 5
	blt	a0, a1, .LBB0_18
	j	.LBB0_12
.LBB0_12:
	.loc	0 0 5
	li	a0, 0
.Ltmp5:
	.loc	0 55 14 is_stmt 1
	sw	a0, -68(s0)
	.loc	0 55 12 is_stmt 0
	j	.LBB0_13
.LBB0_13:
.Ltmp6:
	.loc	0 55 19
	lw	a1, -68(s0)
	li	a0, 2
.Ltmp7:
	.loc	0 55 7
	blt	a0, a1, .LBB0_16
	j	.LBB0_14
.LBB0_14:
.Ltmp8:
	.loc	0 56 29 is_stmt 1
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	call	gets
	.loc	0 56 24 is_stmt 0
	call	atoi
	.loc	0 56 16
	lw	a2, -64(s0)
	.loc	0 56 9
	slli	a1, a2, 1
	add	a2, a1, a2
	addi	a1, s0, -77
	add	a1, a1, a2
	.loc	0 56 19
	lw	a2, -68(s0)
	.loc	0 56 9
	add	a1, a1, a2
	.loc	0 56 22
	sb	a0, 0(a1)
	.loc	0 57 7 is_stmt 1
	j	.LBB0_15
.Ltmp9:
.LBB0_15:
	.loc	0 55 27
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	.loc	0 55 7 is_stmt 0
	j	.LBB0_13
.Ltmp10:
.LBB0_16:
	.loc	0 58 5 is_stmt 1
	j	.LBB0_17
.Ltmp11:
.LBB0_17:
	.loc	0 54 25
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	.loc	0 54 5 is_stmt 0
	j	.LBB0_11
.Ltmp12:
.LBB0_18:
	.loc	0 59 22 is_stmt 1
	lw	a1, -56(s0)
	.loc	0 59 29 is_stmt 0
	lw	a2, -60(s0)
	.loc	0 59 5
	lui	a0, %hi(img)
	addi	a0, a0, %lo(img)
	addi	a3, s0, -77
	call	imageFilter
	li	a0, 0
.Ltmp13:
	.loc	0 60 12 is_stmt 1
	sw	a0, -64(s0)
	.loc	0 60 10 is_stmt 0
	j	.LBB0_19
.LBB0_19:
.Ltmp14:
	.loc	0 60 17
	lw	a0, -64(s0)
	.loc	0 60 21
	lw	a1, -60(s0)
.Ltmp15:
	.loc	0 60 5
	bge	a0, a1, .LBB0_26
	j	.LBB0_20
.LBB0_20:
	.loc	0 0 5
	li	a0, 0
.Ltmp16:
	.loc	0 61 14 is_stmt 1
	sw	a0, -68(s0)
	.loc	0 61 12 is_stmt 0
	j	.LBB0_21
.LBB0_21:
.Ltmp17:
	.loc	0 61 19
	lw	a0, -68(s0)
	.loc	0 61 23
	lw	a1, -56(s0)
.Ltmp18:
	.loc	0 61 7
	bge	a0, a1, .LBB0_24
	j	.LBB0_22
.LBB0_22:
.Ltmp19:
	.loc	0 62 23 is_stmt 1
	lw	a0, -64(s0)
	.loc	0 62 25 is_stmt 0
	lw	a1, -56(s0)
	.loc	0 62 24
	mul	a0, a0, a1
	.loc	0 62 33
	lw	a1, -68(s0)
	.loc	0 62 31
	add	a0, a0, a1
	.loc	0 62 19
	lui	a1, %hi(img)
	addi	a1, a1, %lo(img)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	.loc	0 62 14
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	li	a2, 10
	call	itoa
	.loc	0 62 9
	call	puts
	.loc	0 63 7 is_stmt 1
	j	.LBB0_23
.Ltmp20:
.LBB0_23:
	.loc	0 61 31
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	.loc	0 61 7 is_stmt 0
	j	.LBB0_21
.Ltmp21:
.LBB0_24:
	.loc	0 64 5 is_stmt 1
	j	.LBB0_25
.Ltmp22:
.LBB0_25:
	.loc	0 60 30
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	.loc	0 60 5 is_stmt 0
	j	.LBB0_19
.Ltmp23:
.LBB0_26:
	.loc	0 65 5 is_stmt 1
	j	.LBB0_29
.LBB0_27:
	.loc	0 68 5
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	sw	a0, -112(s0)
	call	gets
	.loc	0 69 5
	lw	a0, -112(s0)
	call	puts
	lw	a0, -112(s0)
	.loc	0 70 5
	call	gets
	.loc	0 71 5
	lw	a0, -112(s0)
	call	puts
	.loc	0 72 5
	j	.LBB0_29
.LBB0_28:
	.loc	0 75 5
	j	.LBB0_29
.Ltmp24:
.LBB0_29:
	.loc	0 77 1
	lw	ra, 108(sp)
	lw	s0, 104(sp)
	addi	sp, sp, 112
	ret
.Ltmp25:
.Lfunc_end0:
	.size	run_operation, .Lfunc_end0-run_operation
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	2
.LJTI0_0:
	.word	.LBB0_2
	.word	.LBB0_3
	.word	.LBB0_4
	.word	.LBB0_5
	.word	.LBB0_6
	.word	.LBB0_7
	.word	.LBB0_8
	.word	.LBB0_9
	.word	.LBB0_28
	.word	.LBB0_10
	.word	.LBB0_27

	.text
	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
.Lfunc_begin1:
	.loc	0 79 0
	.cfi_startproc
	addi	sp, sp, -16
	.cfi_def_cfa_offset 16
.Ltmp26:
	.loc	0 80 24 prologue_end
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 16
	.cfi_def_cfa s0, 0
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	call	gets
	.loc	0 80 19 is_stmt 0
	call	atoi
	.loc	0 80 7
	sw	a0, -12(s0)
	.loc	0 81 17 is_stmt 1
	lw	a0, -12(s0)
	.loc	0 81 3 is_stmt 0
	call	run_operation
	li	a0, 0
	.loc	0 82 3 is_stmt 1
	call	exit
.Ltmp27:
.Lfunc_end1:
	.size	_start, .Lfunc_end1-_start
	.cfi_endproc

	.type	number,@object
	.section	.sdata,"aw",@progbits
	.globl	number
	.p2align	2
number:
	.word	635
	.size	number, 4

	.type	buffer,@object
	.bss
	.globl	buffer
buffer:
	.zero	100
	.size	buffer, 100

	.type	img,@object
	.globl	img
img:
	.zero	40000
	.size	img, 40000

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
	.byte	52
	.byte	0
	.byte	3
	.byte	37
	.byte	73
	.byte	19
	.byte	63
	.byte	25
	.byte	58
	.byte	11
	.byte	59
	.byte	11
	.byte	2
	.byte	24
	.byte	0
	.byte	0
	.byte	3
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
	.byte	4
	.byte	1
	.byte	1
	.byte	73
	.byte	19
	.byte	0
	.byte	0
	.byte	5
	.byte	33
	.byte	0
	.byte	73
	.byte	19
	.byte	55
	.byte	11
	.byte	0
	.byte	0
	.byte	6
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
	.byte	7
	.byte	33
	.byte	0
	.byte	73
	.byte	19
	.byte	55
	.byte	5
	.byte	0
	.byte	0
	.byte	8
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
	.byte	9
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
	.byte	10
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
	.byte	11
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
	.byte	63
	.byte	25
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
	.byte	3
	.word	.Lfunc_end1-.Lfunc_begin0
	.word	.Laddr_table_base0
	.byte	2
	.byte	3
	.word	46

	.byte	0
	.byte	5
	.byte	2
	.byte	161
	.byte	0
	.byte	3
	.byte	4
	.byte	5
	.byte	4
	.byte	2
	.byte	5
	.word	61

	.byte	0
	.byte	3
	.byte	2
	.byte	161
	.byte	1
	.byte	4
	.word	73
	.byte	5
	.word	77
	.byte	100
	.byte	0
	.byte	3
	.byte	6
	.byte	8
	.byte	1
	.byte	6
	.byte	7
	.byte	8
	.byte	7
	.byte	2
	.byte	8
	.word	92

	.byte	0
	.byte	4
	.byte	2
	.byte	161
	.byte	2
	.byte	4
	.word	73
	.byte	7
	.word	77
	.half	40000
	.byte	0
	.byte	8
	.byte	3
	.word	.Lfunc_end0-.Lfunc_begin0
	.byte	1
	.byte	88
	.byte	9
	.byte	0
	.byte	7


	.byte	9
	.byte	2
	.byte	145
	.byte	116
	.byte	11
	.byte	0
	.byte	7
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	112
	.byte	12
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	108
	.byte	13
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	104
	.byte	14
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	100
	.byte	15
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	96
	.byte	16
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	92
	.byte	17
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	88
	.byte	18
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	84
	.byte	19
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	80
	.byte	20
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	76
	.byte	21
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	72
	.byte	22
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	68
	.byte	23
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	2
	.byte	145
	.byte	64
	.byte	24
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	3
	.byte	145
	.ascii	"\274\177"
	.byte	25
	.byte	0
	.byte	8
	.word	46
	.byte	10
	.byte	3
	.byte	145
	.ascii	"\263\177"
	.byte	26
	.byte	0
	.byte	9
	.word	318
	.byte	0
	.byte	11
	.byte	4
	.word	.Lfunc_end1-.Lfunc_begin1
	.byte	1
	.byte	88
	.byte	10
	.byte	0
	.byte	79

	.byte	10
	.byte	2
	.byte	145
	.byte	116
	.byte	27
	.byte	0
	.byte	80
	.word	46
	.byte	0
	.byte	4
	.word	73
	.byte	5
	.word	77
	.byte	3
	.byte	5
	.word	77
	.byte	3
	.byte	0
	.byte	0
.Ldebug_info_end0:
	.section	.debug_str_offsets,"",@progbits
	.word	116
	.half	5
	.half	0
.Lstr_offsets_base0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"Ubuntu clang version 14.0.0-1ubuntu1"
.Linfo_string1:
	.asciz	"exemplo.c"
.Linfo_string2:
	.asciz	"/home/ceccon/Documents/MC404/lab7"
.Linfo_string3:
	.asciz	"number"
.Linfo_string4:
	.asciz	"int"
.Linfo_string5:
	.asciz	"buffer"
.Linfo_string6:
	.asciz	"char"
.Linfo_string7:
	.asciz	"__ARRAY_SIZE_TYPE__"
.Linfo_string8:
	.asciz	"img"
.Linfo_string9:
	.asciz	"run_operation"
.Linfo_string10:
	.asciz	"_start"
.Linfo_string11:
	.asciz	"op"
.Linfo_string12:
	.asciz	"t0"
.Linfo_string13:
	.asciz	"t1"
.Linfo_string14:
	.asciz	"x"
.Linfo_string15:
	.asciz	"y"
.Linfo_string16:
	.asciz	"y_b"
.Linfo_string17:
	.asciz	"x_c"
.Linfo_string18:
	.asciz	"t_a"
.Linfo_string19:
	.asciz	"t_b"
.Linfo_string20:
	.asciz	"t_c"
.Linfo_string21:
	.asciz	"t_r"
.Linfo_string22:
	.asciz	"width"
.Linfo_string23:
	.asciz	"height"
.Linfo_string24:
	.asciz	"i"
.Linfo_string25:
	.asciz	"j"
.Linfo_string26:
	.asciz	"filter"
.Linfo_string27:
	.asciz	"operation"
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
	.section	.debug_addr,"",@progbits
	.word	.Ldebug_addr_end0-.Ldebug_addr_start0
.Ldebug_addr_start0:
	.half	5
	.byte	4
	.byte	0
.Laddr_table_base0:
	.word	number
	.word	buffer
	.word	img
	.word	.Lfunc_begin0
	.word	.Lfunc_begin1
.Ldebug_addr_end0:
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym run_operation
	.addrsig_sym puts
	.addrsig_sym gets
	.addrsig_sym itoa
	.addrsig_sym atoi
	.addrsig_sym time
	.addrsig_sym sleep
	.addrsig_sym approx_sqrt
	.addrsig_sym imageFilter
	.addrsig_sym exit
	.addrsig_sym number
	.addrsig_sym buffer
	.addrsig_sym img
	.section	.debug_line,"",@progbits
.Lline_table_start0:
