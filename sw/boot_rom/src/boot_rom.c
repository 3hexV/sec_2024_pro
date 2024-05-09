/*
 * =====================================================================================
 *
 *    Description:  This file is an example for the Embedded Systems and Security course.
 *                  It is not intended for real product development. You may distribute
 *                  this file but please retain this comment. The author of the file is
 *                  Professor Zhu Ziyuan from the University of CAS.
 *
 *        Version:  1.0
 *        Created:  2024-05-02
 *       Revision:  none
 *
 *         Author:  zhuziyuan@iie.ac.cn
 *   Organization:  [UCAS]
 *
 * =====================================================================================
 */
typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
typedef unsigned long long int uint64_t;
typedef uint32_t size_t;
typedef uint8_t check_status_t;
typedef uint8_t boot_stat_t;

#define BOOT_START_MODE             (1) /// 正常启动
#define BOOT_UPDATE_FW_MODE         (2) /// 更新固件
#define BOOT_UPDATE_BOOT_MODE       (3) /// 更新boot

// #define FW_TEST
#ifdef FW_TEST
#define NO_CHK_FW
#else
#define CHK_FW
#endif

// #define CHK_OPT_SHA1
#define CHK_OPT_CRC32

#define REG32(add) *((volatile unsigned int *)(add))
#define REG16(add) *((volatile unsigned short *)(add))
#define REG8(add) *((volatile unsigned char *)(add))
#define BIT(x) (1UL << x)
#define SETBIT(val, bit) (val | 1 << bit)
#define hexchar(i) (((i & 0xf) > 9) ? (i & 0xf) - 10 + 'A' : (i & 0xf) + '0')

/**
 * @brief 固件完整性参数
 */
#define FW_SEC_OVERALL_PARAM_3  (REG32(0x00008088))
#define FW_SEC_OVERALL_PARAM_2  (REG32(0x0000808C))
#define FW_SEC_OVERALL_PARAM_1  (REG32(0x00008090))
#define FW_SEC_OVERALL_PARAM_0  (REG32(0x00008094))
#define FW_SEC_LOCAL_PARAM      (REG32(0x00008098))
#define FW_SEC_LEN_PARAM        (REG32(0x0000809C))

#define CHECK_PASS              (0x5A)
#define CHECK_NOT_PASS          (0x00)
#define BOOT_FAIL               do{;}while(1)

#define GET_FW_FIRST_32_B                   (REG32(0x20000000))
#define GET_FW_LAST_32_B(fw_len)            (REG32(0x20000000 + (fw_len) - 4))
#define GET_FW_CENTER_32_B(fw_len)          (REG32(0x20000000 + ((fw_len>>1)&0xfffffff0)))

#define GPIO_0_IN               (0x40010000 + 0x10)
#define GPIO_0_OE               (0x40010000 + 0x20)
#define GPIO_0_OUT              (0x40010000 + 0x14)
#define WAIT_THREE_CYCLE        __asm__ volatile ("nop;nop;nop")

extern struct
{
    void (*entry)(void);
} _flash_header;

void crc32_init(void);
uint32_t crc32(uint8_t *buf, size_t len);
int uart_configure(unsigned int baudrate);
void print_str(char *str);
void print_uint(unsigned int n, int bits);
boot_stat_t get_boot_mode(void);

#ifdef CHK_FW
check_status_t fw_check_local_param(void);
check_status_t fw_check_detail_param(void);
#endif

unsigned int crc32_table[256];

void _boot_start(void)
{
    boot_stat_t boot_stat = BOOT_START_MODE;
    uint32_t update_data = 0;
    #ifdef CHK_FW
    check_status_t ret_val = CHECK_NOT_PASS;
    #endif

    uart_configure(115200);

    print_str("\r");
    print_str("Embedded Security BootLoader Demo...\r\n");

    boot_stat = get_boot_mode();

    if(boot_stat == BOOT_UPDATE_FW_MODE) {
        // gpio pin1 ACK
        REG32(GPIO_0_OE) |= 1<<1;
        WAIT_THREE_CYCLE;
        REG32(GPIO_0_OUT) |= 1<<1;
        WAIT_THREE_CYCLE;
        print_str("update FW ...\r\n");

        // update FW
        update_data = REG32(GPIO_0_IN);
        GET_FW_FIRST_32_B = update_data;
        WAIT_THREE_CYCLE;
        // print_uint(update_data, 32);
        // print_uint(GET_FW_FIRST_32_B, 32);   

        // reboot
        print_str("\rupdate ok, reboot...\r\n");
        __asm__ volatile ("jal zero, 0x00008080");
    }

    #ifdef CHK_FW
    // local
    ret_val = fw_check_local_param();
    if(CHECK_NOT_PASS == ret_val) goto lb_boot_fail;

    // detail
    ret_val = CHECK_NOT_PASS;
    ret_val = fw_check_detail_param();
    if(CHECK_NOT_PASS == ret_val) goto lb_boot_fail;
    #endif

    _flash_header.entry();

    #ifdef CHK_FW
    lb_boot_fail:
        BOOT_FAIL;
    #endif
}

boot_stat_t get_boot_mode(void)
{
    uint32_t gpio_0_in = REG32(GPIO_0_IN);

    /// gpio0 pin0 输入高电平 则进入更新固件
    if((gpio_0_in&(0x00000001)) == 1) return BOOT_UPDATE_FW_MODE;

    return BOOT_START_MODE;
}

#ifdef CHK_FW
check_status_t fw_check_local_param(void)
{
    size_t fw_len = FW_SEC_LEN_PARAM;
    uint32_t fw_chk_val = FW_SEC_LOCAL_PARAM;
    uint32_t fw_calc_val = GET_FW_FIRST_32_B^GET_FW_CENTER_32_B(fw_len)^GET_FW_LAST_32_B(fw_len);
    print_str("*FW check(L)\r");
    print_str("- FW len: 0X");
    print_uint(fw_len, 32);

    print_str("\r- FW param(L): 0X");
    print_uint(fw_chk_val, 32);

    // print_str("\r");
    // print_uint(GET_FW_FIRST_32_B, 32);
    // print_str("\r");
    // print_uint(GET_FW_CENTER_32_B(fw_len), 32);
    // print_str("\r");
    // print_uint(GET_FW_LAST_32_B(fw_len), 32);

    print_str("\r- FW calc val(L): 0X");
    print_uint(fw_calc_val, 32);

    if(fw_calc_val == fw_chk_val)
    {
        print_str("\rFW check(L): Pass\r");
        return CHECK_PASS;
    }

    print_str("\rFW check(L): Not pass\r");
    return CHECK_NOT_PASS;
}

check_status_t fw_check_detail_param(void)
{
    size_t fw_len = FW_SEC_LEN_PARAM;
    uint32_t fw_calc_val = 0;
    uint32_t fw_chk_val = FW_SEC_OVERALL_PARAM_0;
    print_str("*FW check(D)\r");
    crc32_init();

    print_str("- FW param(D): 0X");

    print_uint(fw_chk_val, 32);

    fw_calc_val = crc32((uint8_t *)0x20000000, fw_len);
    print_str("\r- FW calc val(D): 0X");
    print_uint(fw_calc_val, 32);

    if(fw_calc_val == fw_chk_val)
    {
        print_str("\rFW check(D): Pass\r");
        return CHECK_PASS;
    }

    print_str("\rFW check(D): Not pass\r");
    return CHECK_NOT_PASS;
}
#endif

void print_uint(unsigned int n, int bits)
{
    for (int i = bits - 4; i >= 0; i -= 4)
    {
        REG32(0x4000001c) = hexchar(n >> i); // TXDATA
    }
}

void print_str(char *str)
{
    while (*str != '\0')
    {
        while (REG32(0x40000014) & 1) ;

        REG32(0x4000001c) = *str++; // tx data

        while (!(REG32(0x40000014) & 8));
    }
}

uint32_t crc32(uint8_t *buf, size_t len)
{
    unsigned int ret = 0xFFFFFFFF;
    size_t i;

    for (i = 0; i < len; i++) {
        ret = crc32_table[(ret ^ buf[i]) & 0xFF] ^ (ret >> 8);
        // if(i%64==0 || i == len-1)
        // {
        //     print_str("\r");
        //     print_uint(buf[i], 8);
        //     print_str("\t");
        //     print_uint(ret, 32);
        // }
    }
    return ret ^ 0xFFFFFFFF;
}

void crc32_init(void)
{
    unsigned int polynomial = 0xEDB88320;
    unsigned int i, j;

    for (i = 0; i < 256; i++) {
        unsigned int crc = i;
        for (j = 0; j < 8; j++) {
            if (crc & 1) {
                crc = (crc >> 1) ^ polynomial;
            } else {
                crc = crc >> 1;
            }
        }
        crc32_table[i] = crc;
    }
}

int uart_configure(unsigned int baudrate)
{
    // Calculation formula: NCO = 2^20 * baud / fclk
    uint64_t nco = ((uint64_t)baudrate << 20) / (uint64_t)(12 * 1000 * 1000);
    uint32_t nco_masked = nco & 0xffff;
    uint32_t reg;

    // Requested baudrate is too high for the given clock frequency
    if (nco != nco_masked)
    {
        return 0;
    }

    // CTRL
    reg = (nco_masked << 16);
    reg |= (1u << 0);
    reg |= (1u << 1);
    REG32(0x40000000 + 0x10) = reg;

    // Reset RX/TX FIFOs
    reg = (1u << 0);
    reg |= (1u << 1);
    REG32(0x40000000 + 0x20) = reg;

    // Disable interrupts
    REG32(0x40000000 + 0x04) = 0x0;

    // clear int status
    REG32(0x40000000 + 0x00) = 0xffffffffu;

    return 1;
}
