#ifndef HAL_GPIO_H
#define HAL_GPIO_H

#include "./hal_type.h"
#include "./hal_common.h"

void init_gpio_0(pin_t pin);
uint32_t get_gpio_0(pin_t pin);
void reset_gpio_0(pin_t pin);
void set_gpio_0(pin_t pin);

void init_gpio_0_lower_mask_out(pin_t pin);
void set_gpio_0_lower_mask_out(pin_t pin);
void reset_gpio_0_lower_mask_out(pin_t pin);

#endif