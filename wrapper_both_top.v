`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.12.2021 09:55:29
// Design Name: 
// Module Name: wrapper_both_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wrapper_both_top #(parameter DATA_WIDTH = 8, LOC = 64, ADD_WIDTH = 3)(
input rclk,
input wclk,
input rst,
input [DATA_WIDTH-1 :0]din,
input wen,
input ren, 

//outputs of 1st half wrapper
output  [DATA_WIDTH-1 :0]dout4,   //output os Asynchromous FIFO 
output  [DATA_WIDTH-1 :0]doutx,  //output of l2h
output  [DATA_WIDTH-1 :0]dout,   //overall output
output  full1, 
output  empty1,
output  lh1,

//outputs of 2nd half wrapper
output  [DATA_WIDTH-1 :0]dout4_b,   //output os Asynchromous FIFO 
output  [DATA_WIDTH-1 :0]doutx_b,  //output of l2h
output  [DATA_WIDTH-1 :0]dout_b,   //overall output
output  lh2,
output  full2, 
output  empty2 
);


both_top U0(
.wclk(wclk),
.rclk(rclk),
.rst(rst),
.din(din),
.doutx(doutx),
.pe(),
.dout(dout),
.dout4(dout4),
.full(full1),
.empty(empty1),
.lh(lh1),
.freq1(),
.freq2(),
.wen(wen),
.ren(ren)
);

both_top U1(
.wclk(rclk),
.rclk(wclk),
.rst(rst),
.din(dout),
.doutx(doutx_b),
.pe(),
.dout(dout_b),
.dout4(dout4_b),
.full(full2),
.empty(empty2),
.lh(lh2),
.freq1(),
.freq2(),
.wen(ren),
.ren(wen)
);


endmodule


