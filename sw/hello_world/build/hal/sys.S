	.file	"sys.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	delay_us
	.type	delay_us, @function
delay_us:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	a4,-36(s0)
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	slli	a5,a5,3
	sw	a5,-20(s0)
.L2:
 #APP
# 14 "./src/hal/sys.c" 1
	nop
# 0 "" 2
 #NO_APP
	lw	a5,-20(s0)
	addi	a4,a5,-1
	sw	a4,-20(s0)
	bne	a5,zero,.L2
	nop
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	delay_us, .-delay_us
	.ident	"GCC: (crosstool-NG 1.24.0.498_5075e1f) 10.2.0"
