OUTPUT_ARCH(riscv)
/*GROUP(-lgcc)*/

__DYNAMIC = 0;

MEMORY {
  rom(rx)   : ORIGIN = 0x00008000, LENGTH = 0x2000
  ram(w)    : ORIGIN = 0x10000000, LENGTH = 0x2000
  flash(rx) : ORIGIN = 0x20000000, LENGTH = 0x8000
}

_boot_address = ORIGIN(rom);

_heap_size    = 0x0800;
_stack_size   = 0x1000;
_stack_start  = ORIGIN(ram) + _heap_size + _stack_size;
_flash_start  = ORIGIN(flash);
_flash_header = ORIGIN(flash);


SECTIONS {
  .vectors _boot_address : ALIGN(4) {
    KEEP(*(.vectors))
    *(.vectors)
  } > rom

  .sec_param : ALIGN(4) {
    KEEP(*(.sec_param))
    *(.sec_param)
  } > rom

  .crt : ALIGN(4) {
    KEEP(*(.crt))
    *(.crt)
  } > rom

  .text : ALIGN(4) {
    *(.text)
    *(.text.*)
  } > rom

  .rodata : ALIGN(4) {
    *(.rodata)
    *(.rodata.*)
  } > rom

  .idata : ALIGN(4) {
    _data_init_start = .;
  } > rom

  .data ORIGIN(ram): AT(_data_init_start) ALIGN(4) {
    _data_start = .;
    *(.data)
    *(.data.*)
    *(.sdata)
    _data_end = .;
  } > ram

  .bss : ALIGN(4) {
    _bss_start = .;
    *(.bss)
    *(.bss.*)
    *(.sbss)
    *(.sbss.*)
    *(COMMON)
    _bss_end = .;
  } > ram
}
