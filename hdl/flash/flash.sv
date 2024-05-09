// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0


module flash #(
  parameter  int Width     = 32,
  parameter  int Depth     = 8192, // 8kB default
  parameter  int DataBitsPerMask = 8 // Number of data bits per bit of write mask
) (
  clk_i    ,
  rst_ni   ,
  we_i     ,
  wmask_i  ,
  wdata_i  ,
  addr_i   ,
  cs_i     ,
  dout_o   ,
  dvalid_o
);

  localparam int Aw        = $clog2(Depth);
  localparam int MaskWidth = Width / DataBitsPerMask;

  logic [MaskWidth-1:0] wmask;

  input                        clk_i    ;
  input                        rst_ni   ;
  input  logic                 we_i     ;
  input  logic [Width-1:0]     wmask_i  ;
  input  logic [Width-1:0]     wdata_i  ;
  input        [Aw-1:0]        addr_i   ;
  input                        cs_i     ;
  output logic [Width-1:0]     dout_o   ;
  output logic                 dvalid_o ;



  always_comb begin
    for (int i=0; i < MaskWidth; i = i + 1) begin : create_wmask
      wmask[i] = &wmask_i[i*DataBitsPerMask +: DataBitsPerMask];
    end
  end



`ifdef SECSOC_FPGA

wire[3:0] wmask_with_we;

assign    wmask_with_we = {we_i, we_i, we_i, we_i} & wmask;



mtp_ram_8192x32_fpga u_mtp_ram_8192x32_fpga(
  .clka  ( clk_i   ),    // input wire clka
  //.ena   ( cs_i    ),    // input wire ena
  .ena   ( 1'b1    ),    // input wire ena
  .wea   ( wmask_with_we   ),    // input wire [3 : 0] wea
  .addra ( addr_i  ),    // input wire [12 : 0] addra
  .dina  ( wdata_i ),    // input wire [31 : 0] dina
  .douta ( dout_o  )     // output wire [31 : 0] douta
);

`else


  logic [Width-1:0] mem [Depth];

  always @(posedge clk_i) begin
    if (cs_i) begin
      if (we_i) begin
        for (int i=0; i < MaskWidth; i = i + 1) begin
          if (wmask[i]) begin
            mem[addr_i][i*DataBitsPerMask +: DataBitsPerMask] <=
              wdata_i[i*DataBitsPerMask +: DataBitsPerMask];
          end
        end
      end else begin
        dout_o <= mem[addr_i];
      end
    end
  end



  ////////////////
  ////////////////
  ////parameter  MEM_FILE = "otp_rom.vmem";
  ////initial begin
  ////    $display("Initializing ROM from %s", MEM_FILE);
  ////    $readmemh(MEM_FILE, mem);
  ////end

  // Control Signals should never be X


`endif


  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      dvalid_o <= '0;
    end else begin
      dvalid_o <= cs_i & ~we_i;
    end
  end





endmodule
