	.file	"hello_world.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC0:
	.string	" _   _ _____   _   _ _____   ___   _____\r| | | |_   _| | | | /  __ \\ / _ \\ /  ___|\r| |_| | | |   | | | | /  \\// /_\\ \\ `--. \r|  _  | | |   | | | | |    |  _  | `--. \\\r| | | |_| |_  | |_| | \\__/\\| | | |/\\__/ /\r\\_| |_/\\___/   \\___/ \\____/\\_| |_/\\____/ \r"
	.align	2
.LC1:
	.string	"[init] gpio ok\r"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	print_str
	li	a0,-2147479552
	call	init_gpio_0
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	print_str
.L2:
	li	a0,4096
	call	set_gpio_0
	li	a0,-2147483648
	call	reset_gpio_0
	li	a0,8
	call	delay_us
	li	a0,4096
	call	reset_gpio_0
	li	a0,-2147483648
	call	set_gpio_0
	li	a0,24
	call	delay_us
	j	.L2
	.size	main, .-main
	.align	1
	.globl	print_uint
	.type	print_uint, @function
print_uint:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-40(s0)
	addi	a5,a5,-4
	sw	a5,-20(s0)
	j	.L4
.L7:
	lw	a5,-20(s0)
	lw	a4,-36(s0)
	srl	a5,a4,a5
	andi	a4,a5,15
	li	a5,9
	bleu	a4,a5,.L5
	lw	a5,-20(s0)
	lw	a4,-36(s0)
	srl	a5,a4,a5
	andi	a5,a5,15
	addi	a5,a5,55
	j	.L6
.L5:
	lw	a5,-20(s0)
	lw	a4,-36(s0)
	srl	a5,a4,a5
	andi	a5,a5,15
	addi	a5,a5,48
.L6:
	li	a4,1073741824
	addi	a4,a4,28
	sw	a5,0(a4)
	lw	a5,-20(s0)
	addi	a5,a5,-4
	sw	a5,-20(s0)
.L4:
	lw	a5,-20(s0)
	bge	a5,zero,.L7
	nop
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	print_uint, .-print_uint
	.align	1
	.globl	print_str
	.type	print_str, @function
print_str:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	j	.L9
.L12:
	nop
.L10:
	li	a5,1073741824
	addi	a5,a5,20
	lw	a5,0(a5)
	andi	a5,a5,1
	bne	a5,zero,.L10
	lw	a5,-20(s0)
	addi	a4,a5,1
	sw	a4,-20(s0)
	lbu	a4,0(a5)
	li	a5,1073741824
	addi	a5,a5,28
	sw	a4,0(a5)
	nop
.L11:
	li	a5,1073741824
	addi	a5,a5,20
	lw	a5,0(a5)
	andi	a5,a5,8
	beq	a5,zero,.L11
.L9:
	lw	a5,-20(s0)
	lbu	a5,0(a5)
	bne	a5,zero,.L12
	nop
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	print_str, .-print_str
	.ident	"GCC: (crosstool-NG 1.24.0.498_5075e1f) 10.2.0"
