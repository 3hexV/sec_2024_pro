
  .section .vectors, "ax"

  .option norvc


  .org 0x00
  j no_exception_handler

  .org 0x0c
  j no_exception_handler

  .org 0x1c
  j no_exception_handler
  
  .org 0x2c
  j no_exception_handler

  .org 0x40
  j no_exception_handler

  .org 0x7c
  j no_exception_handler

  .org 0x80
  j _reset_start

  .option norvc


no_exception_handler:
  j no_exception_handler
