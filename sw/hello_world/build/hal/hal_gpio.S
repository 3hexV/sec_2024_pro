	.file	"hal_gpio.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	init_gpio_0
	.type	init_gpio_0, @function
init_gpio_0:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	li	a5,1073807360
	addi	a5,a5,32
	lw	a3,0(a5)
	li	a5,1073807360
	addi	a5,a5,32
	lw	a4,-20(s0)
	or	a4,a3,a4
	sw	a4,0(a5)
	li	a5,1073807360
	addi	a5,a5,20
	sw	zero,0(a5)
 #APP
# 10 "./src/hal/hal_gpio.c" 1
	nop;nop;nop
# 0 "" 2
 #NO_APP
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	init_gpio_0, .-init_gpio_0
	.align	1
	.globl	init_gpio_0_lower_mask_out
	.type	init_gpio_0_lower_mask_out, @function
init_gpio_0_lower_mask_out:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	li	a5,1073807360
	addi	a5,a5,24
	lw	a4,0(a5)
	lw	a5,-20(s0)
	li	a3,1
	sll	a5,a3,a5
	slli	a3,a5,16
	lw	a5,-20(s0)
	li	a2,1
	sll	a5,a2,a5
	or	a5,a3,a5
	mv	a3,a5
	li	a5,1073807360
	addi	a5,a5,24
	or	a4,a4,a3
	sw	a4,0(a5)
 #APP
# 16 "./src/hal/hal_gpio.c" 1
	nop;nop;nop
# 0 "" 2
 #NO_APP
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	init_gpio_0_lower_mask_out, .-init_gpio_0_lower_mask_out
	.align	1
	.globl	set_gpio_0_lower_mask_out
	.type	set_gpio_0_lower_mask_out, @function
set_gpio_0_lower_mask_out:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	li	a5,1073807360
	addi	a5,a5,36
	lw	a3,0(a5)
	lw	a5,-20(s0)
	slli	a4,a5,16
	lw	a5,-20(s0)
	or	a4,a4,a5
	li	a5,1073807360
	addi	a5,a5,36
	or	a4,a3,a4
	sw	a4,0(a5)
 #APP
# 22 "./src/hal/hal_gpio.c" 1
	nop;nop;nop
# 0 "" 2
 #NO_APP
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	set_gpio_0_lower_mask_out, .-set_gpio_0_lower_mask_out
	.align	1
	.globl	reset_gpio_0_lower_mask_out
	.type	reset_gpio_0_lower_mask_out, @function
reset_gpio_0_lower_mask_out:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	li	a5,1073807360
	addi	a5,a5,36
	lw	a3,0(a5)
	lw	a5,-20(s0)
	not	a4,a5
	li	a5,1073807360
	addi	a5,a5,36
	and	a4,a3,a4
	sw	a4,0(a5)
	li	a5,1073807360
	addi	a5,a5,36
	lw	a3,0(a5)
	lw	a5,-20(s0)
	slli	a4,a5,16
	li	a5,1073807360
	addi	a5,a5,36
	or	a4,a3,a4
	sw	a4,0(a5)
 #APP
# 29 "./src/hal/hal_gpio.c" 1
	nop;nop;nop
# 0 "" 2
 #NO_APP
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	reset_gpio_0_lower_mask_out, .-reset_gpio_0_lower_mask_out
	.align	1
	.globl	get_gpio_0
	.type	get_gpio_0, @function
get_gpio_0:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	li	a5,1073807360
	addi	a5,a5,16
	lw	a5,0(a5)
	lw	a4,-20(s0)
	li	a3,1
	sll	a4,a3,a4
	and	a4,a5,a4
	lw	a5,-20(s0)
	srl	a5,a4,a5
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	get_gpio_0, .-get_gpio_0
	.align	1
	.globl	set_gpio_0
	.type	set_gpio_0, @function
set_gpio_0:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	li	a5,1073807360
	addi	a5,a5,20
	lw	a3,0(a5)
	li	a5,1073807360
	addi	a5,a5,20
	lw	a4,-20(s0)
	or	a4,a3,a4
	sw	a4,0(a5)
 #APP
# 40 "./src/hal/hal_gpio.c" 1
	nop;nop;nop
# 0 "" 2
 #NO_APP
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	set_gpio_0, .-set_gpio_0
	.align	1
	.globl	reset_gpio_0
	.type	reset_gpio_0, @function
reset_gpio_0:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	li	a5,1073807360
	addi	a5,a5,20
	lw	a3,0(a5)
	lw	a5,-20(s0)
	not	a4,a5
	li	a5,1073807360
	addi	a5,a5,20
	and	a4,a3,a4
	sw	a4,0(a5)
 #APP
# 46 "./src/hal/hal_gpio.c" 1
	nop;nop;nop
# 0 "" 2
 #NO_APP
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	reset_gpio_0, .-reset_gpio_0
	.ident	"GCC: (crosstool-NG 1.24.0.498_5075e1f) 10.2.0"
