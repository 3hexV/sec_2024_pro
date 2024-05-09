
module soc_top_fpga(
    input       fpga_resetn,
    input       fpga_clk_p,
    input       fgap_clk_n,
    input       uart_rx,
    output      uart_tx,
    inout[31:0] gpio
);

wire       pll_clk_12m;
wire[31:0] gpio_i ;
wire[31:0] gpio_o ;
wire[31:0] gpio_oe;

fpga_clk fpga_clk_inst (
    .clk_out1  ( pll_clk_12m ),
    .reset     ( 1'b0        ),
    .locked    (  ),
    .clk_in1_p ( fpga_clk_p ),
    .clk_in1_n ( fgap_clk_n )
 );


soc_top u_soc_top(
    .clk_i     ( pll_clk_12m ),
    .rstn_i    ( fpga_resetn ),
    .uart_tx_o ( uart_tx     ),
    .uart_rx_i ( uart_rx     ),
    .gpio_i    ( gpio_i      ),
    .gpio_o    ( gpio_o      ),
    .gpio_oe   ( gpio_oe     )
);

assign    gpio   = gpio_oe ? gpio_o : 32'hz;
assign    gpio_i = gpio;

endmodule
