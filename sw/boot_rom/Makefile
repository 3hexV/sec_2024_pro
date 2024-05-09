#/*
# * =====================================================================================
# *
# *    Description:  This file is an example for the Embedded Systems and Security course.
# *                  It is not intended for real product development. You may distribute 
# *                  this file but please retain this comment. The author of the file is 
# *                  Professor Zhu Ziyuan from the University of CAS.
# *
# *        Version:  1.0
# *        Created:  2024-05-02
# *       Revision:  none
# *
# *         Author:  zhuziyuan@iie.ac.cn
# *   Organization:  [UCAS]
# *
# * =====================================================================================
# */



CCARGS = -std=c11 -march=rv32imc -mabi=ilp32 -static -mcmodel=medany -Wall -Werror -g -Os -fvisibility=hidden -nostdlib -nostdinc -fno-asynchronous-unwind-tables -fno-common -nostartfiles -nodefaultlibs -Wa,--no-pad-sections -Wl,-gc-section

CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
OC = riscv32-unknown-elf-objcopy
OD = riscv32-unknown-elf-objdump
HEX = srec_cat

all: 
	${CC} $(CCARGS) -Wl,-T,./src/linkscript.ld -o ./build/boot_rom.elf ./src/boot_rom.c ./src/crt.S ./src/irq.S ./src/sec_init.S -Wl,--build-id=none -lc -lgcc
	${OC} -O binary ./build/boot_rom.elf ./build/boot_rom.bin 
	${OD} --disassemble-all --headers --line-numbers --source ./build/boot_rom.elf > ./build/boot_rom.dis
	${HEX} ./build/boot_rom.bin --binary --offset 0x0 --byte-swap 4 --fill 0xff -within ./build/boot_rom.bin -binary -range-pad 4 --output ./build/boot_rom.vmem --vmem 32

clean:
	rm ./build/* -f
