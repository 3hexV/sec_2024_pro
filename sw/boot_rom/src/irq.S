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

  .option rvc


no_exception_handler:
  j no_exception_handler
