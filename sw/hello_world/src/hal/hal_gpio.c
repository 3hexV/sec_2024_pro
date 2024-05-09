/**
 * @note 指定地址写入数据后，需要一些时间成功设置
*/
#include "./hal_gpio.h"

void init_gpio_0(pin_t pin)
{
    REG32(GPIO_0_OE) |= pin;
    REG32(GPIO_0_OUT) = 0;
    WAIT_THREE_CYCLE;
}

void init_gpio_0_lower_mask_out(pin_t pin)
{
    REG32(GPIO_0_MASK_OUT_LOWER_OE) |= ((1<<pin)<<16)|(1<<pin);
    WAIT_THREE_CYCLE;
}

void set_gpio_0_lower_mask_out(pin_t pin)
{
    REG32(GPIO_0_MASK_OUT_LOWER) |= ((pin)<<16)|(pin);
    WAIT_THREE_CYCLE;
}

void reset_gpio_0_lower_mask_out(pin_t pin)
{
    REG32(GPIO_0_MASK_OUT_LOWER) &= ~(pin);
    REG32(GPIO_0_MASK_OUT_LOWER) |= ((pin)<<16);
    WAIT_THREE_CYCLE;
}

uint32_t get_gpio_0(pin_t pin)
{
    return (REG32(GPIO_0_IN)&(1<<pin))>>pin;
}

void set_gpio_0(pin_t pin)
{
    REG32(GPIO_0_OUT) |= (pin);
    WAIT_THREE_CYCLE;
}

void reset_gpio_0(pin_t pin)
{
    REG32(GPIO_0_OUT) &= ~(pin);
    WAIT_THREE_CYCLE;
}
