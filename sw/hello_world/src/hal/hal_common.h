#ifndef HAL_COMMON_H
#define HAL_COMMON_H

/**
 * @file hal_common.h
 * @brief 定义hal层需要的公共宏定义
 * @author 3hex
*/

/**
 * @brief 读写操作
*/
#define hexchar(i) (((i & 0xf) > 9) ? (i & 0xf) - 10 + 'A' : (i & 0xf) + '0')
#define REG32(add) *((volatile unsigned int *)(add))
#define REG8(add) *((volatile unsigned char *)(add))

/**
 * @brief gpio相关宏定义
*/
#define GPIO_PIN_n(n)                   (1<<(n))
#define GPIO_OE_OFFSET                  (0x20)
#define GPIO_MASK_OUT_LOWER_OE_OFFSET   (0x18)
#define GPIO_MASK_OUT_UPPER_OE_OFFSET   (0x1c)
#define GPIO_MASK_OUT_LOWER_OFFSET      (0x24)
#define GPIO_MASK_OUT_UPPER_OFFSET      (0x28)
#define GPIO_OUT_OFFSET                 (0x14)
#define GPIO_IN_OFFSET                  (0x10)

#define GPIP_0_BASE_ADDR        (0x40010000)
#define GPIO_0_OE               (GPIP_0_BASE_ADDR + GPIO_OE_OFFSET)
#define GPIO_0_OUT              (GPIP_0_BASE_ADDR + GPIO_OUT_OFFSET)
#define GPIO_0_IN               (GPIP_0_BASE_ADDR + GPIO_IN_OFFSET)

#define GPIO_0_MASK_OUT_LOWER_OE                (GPIP_0_BASE_ADDR + GPIO_MASK_OUT_LOWER_OE_OFFSET)
#define GPIO_0_MASK_OUT_UPPER_OE                (GPIP_0_BASE_ADDR + GPIO_MASK_OUT_UPPER_OE_OFFSET)
#define GPIO_0_MASK_OUT_LOWER                   (GPIP_0_BASE_ADDR + GPIO_MASK_OUT_LOWER_OFFSET)
#define GPIO_0_MASK_OUT_UPPER                   (GPIP_0_BASE_ADDR + GPIO_MASK_OUT_UPPER_OFFSET)

#define WAIT_THREE_CYCLE                        __asm__ volatile ("nop;nop;nop")

#endif