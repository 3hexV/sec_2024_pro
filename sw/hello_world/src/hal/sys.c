#include "./sys.h"

/**
 * @brief us延时，为了更好的延时效果，建议采用4的倍数的延时
 * @name 最低延时4us
*/
void delay_us(uint32_t us)
{
    // clock: 1 cycle = 41670ps = 41.67 ns
    // 24 = 1 us
    uint32_t tmp_time = us * 24;
    do
    {
        __asm__ volatile ("nop");
    } while (tmp_time --);
}