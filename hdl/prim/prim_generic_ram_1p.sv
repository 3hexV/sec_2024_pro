// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Synchronous single-port SRAM model


module prim_generic_ram_1p #(
  parameter  int Width           = 32, // bit
  parameter  int Depth           = 2048,
  parameter  int DataBitsPerMask = 8 // Number of data bits per bit of write mask
) (
  clk_i,
  rst_ni,       // Memory content reset

  req_i,
  write_i,
  addr_i,
  wdata_i,
  wmask_i,
  rvalid_o,
  rdata_o
);

  localparam int Aw              = $clog2(Depth)  ;// derived parameter

  input clk_i;
  input rst_ni;       // Memory content reset

  input                    req_i;
  input                    write_i;
  input        [Aw-1:0]    addr_i;
  input        [Width-1:0] wdata_i;
  input        [Width-1:0] wmask_i;
  output logic             rvalid_o;
  output logic [Width-1:0] rdata_o;


  // Width of internal write mask. Note wmask_i input into the module is always assumed
  // to be the full bit mask
  localparam int MaskWidth = Width / DataBitsPerMask;

  logic [MaskWidth-1:0] wmask;

  always_comb begin
    for (int i=0; i < MaskWidth; i = i + 1) begin : create_wmask
      wmask[i] = &wmask_i[i*DataBitsPerMask +: DataBitsPerMask];
    end
  end

`ifdef SECSOC_FPGA

wire[3:0] wmask_with_we;

assign    wmask_with_we = {write_i, write_i, write_i, write_i} & wmask;

ram2048x32_fpga your_instance_name (
  .clka  ( clk_i   ),  // input wire clka
  .wea   ( wmask_with_we   ),  // input wire [3 : 0] wea
  .addra ( addr_i  ),  // input wire [10 : 0] addra
  .dina  ( wdata_i ),  // input wire [31 : 0] dina
  .douta ( rdata_o )   // output wire [31 : 0] douta
);

`else
  // using always instead of always_ff to avoid 'ICPD  - illegal combination of drivers' error
  // thrown when using $readmemh system task to backdoor load an image
  logic [Width-1:0] mem [Depth];

  always @(posedge clk_i) begin
    if (req_i) begin
      if (write_i) begin
        for (int i=0; i < MaskWidth; i = i + 1) begin
          if (wmask[i]) begin
            mem[addr_i][i*DataBitsPerMask +: DataBitsPerMask] <=
              wdata_i[i*DataBitsPerMask +: DataBitsPerMask];
          end
        end
      end else begin
        rdata_o <= mem[addr_i];
      end
    end
  end
`endif

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      rvalid_o <= '0;
    end else begin
      rvalid_o <= req_i & ~write_i;
    end
  end


endmodule
