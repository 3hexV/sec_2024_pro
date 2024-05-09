;/*
; * =====================================================================================
; *
; *    Description:  This file is an example for the Embedded Systems and Security course.
; *                  It is not intended for real product development. You may distribute 
; *                  this file but please retain this comment. The author of the file is 
; *                  Professor Zhu Ziyuan from the University of CAS.
; *
; *        Version:  1.0
; *        Created:  2024-05-02
; *       Revision:  none
; *
; *         Author:  zhuziyuan@iie.ac.cn
; *   Organization:  [UCAS]
; *
; * =====================================================================================
; */


  .section .crt, "ax"

_reset_start:
  .globl _reset_start

  li x1, 0x0
  li x2, 0x0
  li x3, 0x0
  li x4, 0x0
  li x5, 0x0
  li x6, 0x0
  li x7, 0x0
  li x8, 0x0
  li x9, 0x0
  li x10, 0x0
  li x11, 0x0
  li x12, 0x0
  li x13, 0x0
  li x14, 0x0
  li x15, 0x0
  li x16, 0x0
  li x17, 0x0
  li x18, 0x0
  li x19, 0x0
  li x20, 0x0
  li x21, 0x0
  li x22, 0x0
  li x23, 0x0
  li x24, 0x0
  li x25, 0x0
  li x26, 0x0
  li x27, 0x0
  li x28, 0x0
  li x29, 0x0
  li x30, 0x0
  li x31, 0x0

  la sp, _stack_start


_start:
  .globl _start

  la t0, _bss_start
  la t1, _bss_end
  bge t0, t1, bss_init_loop_end
bss_init_loop:
  sw zero, 0(t0)
  addi t0, t0, 0x4
  ble t0, t1, bss_init_loop
bss_init_loop_end:


  la t0, _data_start
  la t1, _data_end
  la t2, _data_init_start
  bge t0, t1, data_copy_loop_end
data_copy_loop:
  lw t3, 0(t2)
  sw t3, 0(t0)
  addi t0, t0, 0x4
  addi t2, t2, 0x4
  ble  t0, t1, data_copy_loop
data_copy_loop_end:

  li t0, 0x0
  li t1, 0x0
  li t2, 0x0
  li t3, 0x0
  
  call _boot_start

1: 
  wfi
  j 1b










