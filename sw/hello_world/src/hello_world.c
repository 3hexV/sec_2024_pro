#include "./hal/hal_type.h"
#include "./hal/hal_common.h"

#include "./hal/hal_gpio.h"
#include "./hal/sys.h"

extern struct
{
    void (*entry)(void);
} _flash_header;

void print_str(char *str);
void print_uint(unsigned int n, int bits);

int main(void)
{
    print_str(
        " _   _ _____   _   _ _____   ___   _____\r"
        "| | | |_   _| | | | /  __ \\ / _ \\ /  ___|\r"
        "| |_| | | |   | | | | /  \\// /_\\ \\ `--. \r"
        "|  _  | | |   | | | | |    |  _  | `--. \\\r"
        "| | | |_| |_  | |_| | \\__/\\| | | |/\\__/ /\r"
        "\\_| |_/\\___/   \\___/ \\____/\\_| |_/\\____/ \r"
    );
    // print_str("\\|/\r"
    //           "(~)\tHi UCAS!!!\r"
    //           "/|\\\r");
    init_gpio_0(GPIO_PIN_n(12)|GPIO_PIN_n(31));
    print_str("[init] gpio ok\r");
    while (1)
    {
        set_gpio_0(GPIO_PIN_n(12));
        reset_gpio_0(GPIO_PIN_n(31));
        delay_us(8);

        reset_gpio_0(GPIO_PIN_n(12));
        set_gpio_0(GPIO_PIN_n(31));
        delay_us(24);
    }
    return 0;
}


void print_uint(unsigned int n, int bits)
{
    for (int i = bits - 4; i >= 0; i -= 4)
    {
        REG32(0x4000001c) = hexchar(n >> i);
    }
}

void print_str(char *str)
{
    while (*str != '\0')
    {
        while (REG32(0x40000014) & 1);

        REG32(0x4000001c) = *str++;

        while (!(REG32(0x40000014) & 8));
    }
}

