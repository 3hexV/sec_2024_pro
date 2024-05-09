// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0


module boot_rom #(
  parameter  int Width     = 32,
  parameter  int Depth     = 4096, // 8kB default
  parameter  int Aw        = $clog2(Depth)
) (
  input                        clk_i,
  input                        rst_ni,
  input        [Aw-1:0]        addr_i,
  input                        cs_i,
  output logic [Width-1:0]     dout_o,
  output logic                 dvalid_o
);

`ifdef SECSOC_FPGA
boot_rom_fpga u_boot_rom_fpga(
  .clka(clk_i),    // input wire clka
  .ena(cs_i),      // input wire ena
  .addra(addr_i),  // input wire [11 : 0] addra
  .douta(dout_o)  // output wire [31 : 0] douta
);
`else
  logic [Width-1:0] mem [Depth];

  always@(posedge clk_i) begin
    if (cs_i) begin
      dout_o <= mem[addr_i];
    end
  end
  
  
  ////////////////
  ////////////////
  ////parameter  MEM_FILE = "boot_rom.vmem";
  ////initial begin
  ////    $display("Initializing ROM from %s", MEM_FILE);
  ////    $readmemh(MEM_FILE, mem);
  ////end

  // Control Signals should never be X

`endif

  always@(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      dvalid_o <= 1'b0;
    end else begin
      dvalid_o <= cs_i;
    end
  end

endmodule
