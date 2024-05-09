#############################
####   Hello UCAS demo   ####
#############################

CCARGS = -std=c11 -march=rv32imc -mabi=ilp32 -static -mcmodel=medany -Wall -Werror -g -Os -fvisibility=hidden -nostdlib -nostdinc -fno-asynchronous-unwind-tables -fno-common -nostartfiles -nodefaultlibs -Wa,--no-pad-sections -Wl,-gc-section

CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
OC = riscv32-unknown-elf-objcopy
OD = riscv32-unknown-elf-objdump
HEX = srec_cat

FW_NAME = hello_world
FW_TOP_DIR = ./src
FW_HAL_DIR = ./src/hal

FW_BUILD_DIR = ./build

FW_LINK_SCRIPT = ${FW_TOP_DIR}/linkscript.ld

HAL_SRC = $(wildcard ${FW_HAL_DIR}/*.c)
HAL_ASM = $(patsubst ./src/%.c,./build/%.S,${HAL_SRC})
HAL_OBJ = $(patsubst %.S,%.o,${HAL_ASM})

FW_SRC = ${FW_TOP_DIR}/${FW_NAME}.c 
FW_ASM = ${FW_BUILD_DIR}/${FW_NAME}.S
FW_OBJ = ${FW_BUILD_DIR}/${FW_NAME}.o
FW_ELF = ${FW_BUILD_DIR}/${FW_NAME}.elf
FW_MAP = ${FW_BUILD_DIR}/${FW_NAME}.map
FW_VMEM = ${FW_BUILD_DIR}/${FW_NAME}.vmem
FW_BIN = ${FW_BUILD_DIR}/${FW_NAME}.bin
FW_DIS = ${FW_BUILD_DIR}/${FW_NAME}.dis

LIB = /tools/riscv/lib/gcc/riscv32-unknown-elf/10.2.0/libgcc.a

# 编译
${HAL_ASM}:${HAL_SRC}
	$(CC) -S ${HAL_SRC}
	for file in *.s; do \
		mv "$$file" "${FW_BUILD_DIR}/hal/$${file%.s}.S"; \
	done

$(FW_ASM): $(FW_SRC)
	$(CC) $< -S -o $@ 

# 汇编
${HAL_OBJ}: ${HAL_ASM}
	$(CC) -c ${HAL_ASM}
	mv ./*.o ${FW_BUILD_DIR}/hal/
$(FW_OBJ): $(FW_ASM)
	$(CC) $< -c -o $@ 

# 链接
link: $(HAL_OBJ) $(FW_OBJ)
	${LD} -Map ${FW_MAP} -T ${FW_LINK_SCRIPT} -o ${FW_ELF} $(FW_OBJ) $(HAL_OBJ) ${LIB} 

all: link
	${OC} -O binary ${FW_ELF} ${FW_BIN}
	${OD} --disassemble-all --headers --line-numbers --source ${FW_ELF} > ${FW_DIS}
	${HEX} ${FW_BIN} --binary --offset 0x0 --byte-swap 4 --fill 0xff -within ${FW_BIN} -binary -range-pad 4 --output ${FW_VMEM} --vmem 32

clean:
	rm ${FW_ASM} ${FW_OBJ} ${FW_ELF} ${FW_MAP} ${FW_VMEM} ${FW_BIN} ${FW_DIS}  -f
	rm ${FW_BUILD_DIR}/hal/*.S -f
	rm ${FW_BUILD_DIR}/hal/*.o -f

show: 
	@echo HAL_SRC is $(HAL_SRC)
	@echo HAL_ASM is $(HAL_ASM)
	@echo HAL_OBJ is $(HAL_OBJ)

