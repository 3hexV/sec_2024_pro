module soc_top(
    clk_i ,
    rstn_i,
    uart_tx_o,
    uart_rx_i,
    gpio_i,
    gpio_o,
    gpio_oe
);
  localparam   ADDR_SPACE_ROM = 32'h00008000;

  input        clk_i;
  input        rstn_i;
  input        uart_rx_i;
  input        uart_tx_o;
  input[31:0]  gpio_i;
  output[31:0] gpio_o;
  output[31:0] gpio_oe;

  import tlul_pkg::*;
  import top_pkg::*;
  import tl_main_pkg::*;

  parameter OTP_DW = 32;
  parameter OTP_AW = 13;

  tl_h2d_t  tl_corei_h_h2d;
  tl_d2h_t  tl_corei_h_d2h;

  tl_h2d_t  tl_cored_h_h2d;
  tl_d2h_t  tl_cored_h_d2h;

  tl_h2d_t  tl_uart_d_h2d;
  tl_d2h_t  tl_uart_d_d2h;

  tl_h2d_t  tl_rom_d_h2d;
  tl_d2h_t  tl_rom_d_d2h;

  tl_h2d_t  tl_ram_main_d_h2d;
  tl_d2h_t  tl_ram_main_d_d2h;

  tl_h2d_t  tl_otp_d_h2d;
  tl_d2h_t  tl_otp_d_d2h;

  tl_h2d_t  tl_gpio_d_h2d;
  tl_d2h_t  tl_gpio_d_d2h;



  logic [31:0]  intr_vector;
  logic [31:0]  intr_clr_vector;

  // Interrupt source list
  logic intr_uart_tx_watermark;
  logic intr_uart_rx_watermark;
  logic intr_uart_tx_empty;
  logic intr_uart_rx_overflow;
  logic intr_uart_rx_frame_err;
  logic intr_uart_rx_break_err;
  logic intr_uart_rx_timeout;
  logic intr_uart_rx_parity_err;


  // processor core
  rv_core_ibex #(
    .PMPEnable           (0),
    .PMPGranularity      (0),
    .PMPNumRegions       (4),
    .MHPMCounterNum      (8),
    .MHPMCounterWidth    (40),
    .RV32E               (0),
    .RV32M               (1),
    .DbgTriggerEn        (0),
    .DmHaltAddr          (0),
    .DmExceptionAddr     (0),
    .PipeLine            (0)
  ) core (
    // clock and reset
    .clk_i                (clk_i),
    .rst_ni               (rstn_i),
    .test_en_i            (1'b0),
    // static pinning
    .hart_id_i            (32'b0),
    .boot_addr_i          (ADDR_SPACE_ROM),
    // TL-UL buses
    .tl_i_o               (tl_corei_h_h2d),
    .tl_i_i               (tl_corei_h_d2h),
    .tl_d_o               (tl_cored_h_h2d),
    .tl_d_i               (tl_cored_h_d2h),
    // interrupts
    .irq_software_i       (1'b0),
    .irq_timer_i          (1'b0),
    .irq_external_i       (1'b0),
    .irq_fast_i           (15'd0),// PLIC handles all peripheral interrupts
    .irq_nm_i             (1'b0),// TODO - add and connect alert responder
    // debug interface
    .debug_req_i          (1'b0),
    // CPU control signals
    .fetch_enable_i       (1'b1),
    .core_sleep_o         ()
  );


  // ROM device
  logic        rom_req;
  logic [11:0] rom_addr;
  logic [31:0] rom_rdata;
  logic        rom_rvalid;

  tlul_adapter_sram #(
    .SramAw(12),
    .SramDw(32),
    .Outstanding(1),
    .ErrOnWrite(1)
  ) tl_adapter_rom (
    .clk_i    (clk_i),
    .rst_ni   (rstn_i),

    .tl_i     (tl_rom_d_h2d),
    .tl_o     (tl_rom_d_d2h),

    .en_ifetch_i  (prim_mubi_pkg::MuBi4True),

    .req_o    (rom_req),
    .req_type_o   (),
    .intg_error_o (),
    .gnt_i    (1'b1), // Always grant as only one requester exists
    .we_o     (),
    .addr_o   (rom_addr),
    .wdata_o  (),
    .wmask_o  (),
    .rdata_i  (rom_rdata),
    .rvalid_i (rom_rvalid),
    .rerror_i (2'b00)
  );

  boot_rom u_boot_rom (
    .clk_i    (clk_i),
    .rst_ni   (rstn_i),
    .cs_i     (rom_req),
    .addr_i   (rom_addr),
    .dout_o   (rom_rdata),
    .dvalid_o (rom_rvalid)
  );

  // sram device
  logic        ram_main_req;
  logic        ram_main_we;
  logic [10:0] ram_main_addr;
  logic [31:0] ram_main_wdata;
  logic [31:0] ram_main_wmask;
  logic [31:0] ram_main_rdata;
  logic        ram_main_rvalid;

  tlul_adapter_sram #(
    .SramAw(11),
    .SramDw(32),
    .Outstanding(1)
  ) tl_adapter_ram_main (
    .clk_i    (clk_i),
    .rst_ni   (rstn_i),
    .tl_i     (tl_ram_main_d_h2d),
    .tl_o     (tl_ram_main_d_d2h),
    .en_ifetch_i  (prim_mubi_pkg::MuBi4True),

    .req_o    (ram_main_req),
    .req_type_o   (),
    .intg_error_o (),
    .gnt_i    (1'b1), // Always grant as only one requester exists
    .we_o     (ram_main_we),
    .addr_o   (ram_main_addr),
    .wdata_o  (ram_main_wdata),
    .wmask_o  (ram_main_wmask),
    .rdata_i  (ram_main_rdata),
    .rvalid_i (ram_main_rvalid),
    .rerror_i (2'b00)
  );

  prim_ram_1p u_ram1p_ram_main (
    .clk_i    (clk_i),
    .rst_ni   (rstn_i   ),

    .req_i    (ram_main_req),
    .write_i  (ram_main_we),
    .addr_i   (ram_main_addr),
    .wdata_i  (ram_main_wdata),
    .wmask_i  (ram_main_wmask),
    .rvalid_o (ram_main_rvalid),
    .rdata_o  (ram_main_rdata)
  );


  // host to flash communication
  logic otp_req;
  logic otp_we ;
  logic [OTP_DW-1:0] otp_rdata;
  logic [OTP_DW-1:0] otp_wdata;
  logic [OTP_DW-1:0] otp_wmask;
  logic [OTP_AW-1:0] otp_addr;
  logic otp_dvalid;

  tlul_adapter_sram #(
    .SramAw(OTP_AW),
    .SramDw(OTP_DW),
    .Outstanding(1)
  ) tl_adapter_otp(
    .clk_i    (clk_i),
    .rst_ni   (rstn_i),

    .tl_i     (tl_otp_d_h2d),
    .tl_o     (tl_otp_d_d2h),
    .en_ifetch_i  (prim_mubi_pkg::MuBi4True),

    .req_o    (otp_req),
    .req_type_o   (),
    .intg_error_o (),
    .gnt_i    (1'b1),
    .we_o     (otp_we),
    .addr_o   (otp_addr),
    .wdata_o  (otp_wdata),
    .wmask_o  (otp_wmask),
    .rdata_i  (otp_rdata),
    .rvalid_i (otp_dvalid),
    .rerror_i (2'b00)
  );

  flash u_flash_emulator (
    .clk_i    (clk_i),
    .rst_ni   (rstn_i),
    .we_i     (otp_we),
    .wmask_i  (otp_wmask),
    .wdata_i  (otp_wdata),
    .cs_i     (otp_req),
    .addr_i   (otp_addr),
    .dout_o   (otp_rdata),
    .dvalid_o (otp_dvalid)
  );


//UART
  uart uart_inst (
      .tl_i                 (tl_uart_d_h2d),
      .tl_o                 (tl_uart_d_d2h),
      .cio_rx_i             (uart_rx_i),
      .cio_tx_o             (uart_tx_o),
      .cio_tx_en_o          (uart_tx_en_o),
      // Interrupt
      .intr_tx_watermark_o  (intr_uart_tx_watermark),
      .intr_rx_watermark_o  (intr_uart_rx_watermark),
      .intr_tx_empty_o      (intr_uart_tx_empty),
      .intr_rx_overflow_o   (intr_uart_rx_overflow),
      .intr_rx_frame_err_o  (intr_uart_rx_frame_err),
      .intr_rx_break_err_o  (intr_uart_rx_break_err),
      .intr_rx_timeout_o    (intr_uart_rx_timeout),
      .intr_rx_parity_err_o (intr_uart_rx_parity_err),

      .clk_i                (clk_i),
      .rst_ni               (rstn_i)
  );


//GPIO
gpio gpio_inst (
  .clk_i ( clk_i  ),
  .rst_ni( rstn_i ),

  // Bus interface
  .tl_i( tl_gpio_d_h2d ),
  .tl_o( tl_gpio_d_d2h ),

  // GPIOs
  .cio_gpio_i   ( gpio_i  ),
  .cio_gpio_o   ( gpio_o  ),
  .cio_gpio_en_o( gpio_oe )
);

//xbar
xbar_main xbar_inst(
  .clk_main_i   ( clk_i  ),
  .clk_jtag_i   ( 1'b0   ),
  .clk_periph_i ( clk_i  ),
  .clk_crypt_i  ( ),
  .rst_main_ni  ( rstn_i ),
  .rst_jtag_ni  ( 1'b1   ),
  .rst_periph_ni( rstn_i ),
  .rst_crypt_ni ( 1'b1   ),

  // Host interfaces
  .tl_ibexif_i  ( tl_corei_h_h2d ),
  .tl_ibexif_o  ( tl_corei_h_d2h ),
  .tl_ibexlsu_i ( tl_cored_h_h2d ),
  .tl_ibexlsu_o ( tl_cored_h_d2h ),

  // Device interfaces
  .tl_rom_o     ( tl_rom_d_h2d      ),
  .tl_rom_i     ( tl_rom_d_d2h      ),
  .tl_sram_o    ( tl_ram_main_d_h2d ),
  .tl_sram_i    ( tl_ram_main_d_d2h ),
  .tl_flash_o   ( tl_otp_d_h2d      ),
  .tl_flash_i   ( tl_otp_d_d2h      ),
  .tl_uart0_o   ( tl_uart_d_h2d     ),
  .tl_uart0_i   ( tl_uart_d_d2h     ),
  .tl_gpio0_o   ( tl_gpio_d_h2d     ),
  .tl_gpio0_i   ( tl_gpio_d_d2h     ),

  .scanmode_i   ( prim_mubi_pkg::MuBi4False )
);



endmodule
