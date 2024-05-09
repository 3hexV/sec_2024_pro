
  .section .crt, "ax"

_reset_start:
  .globl _reset_start

  lui x1, 0x0
  lui x2, 0x0
  lui x3, 0x0
  lui x4, 0x0
  lui x5, 0x0
  lui x6, 0x0
  lui x7, 0x0
  lui x8, 0x0
  lui x9, 0x0
  lui x10, 0x0
  lui x11, 0x0
  lui x12, 0x0
  lui x13, 0x0
  lui x14, 0x0
  lui x15, 0x0
  lui x16, 0x0
  lui x17, 0x0
  lui x18, 0x0
  lui x19, 0x0
  lui x20, 0x0
  lui x21, 0x0
  lui x22, 0x0
  lui x23, 0x0
  lui x24, 0x0
  lui x25, 0x0
  lui x26, 0x0
  lui x27, 0x0
  lui x28, 0x0
  lui x29, 0x0
  lui x30, 0x0
  lui x31, 0x0

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

  lui t0, 0x0
  lui t1, 0x0
  lui t2, 0x0
  lui t3, 0x0
  
  call main 

1: 
  wfi
  j 1b










