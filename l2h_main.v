`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2021 12:53:48
// Design Name: 
// Module Name: top
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
module ltoh#(parameter DATA_WIDTH = 32, LOC = 64, ADD_WIDTH = 4)(
input rst,
input wclk,
input rclk,
input  [DATA_WIDTH-1 :0]din,
output reg [DATA_WIDTH-1 :0]dout,
output pe
    );
 
 reg wclk1,wclk2;   

    
always@(posedge rclk)
        begin
        
         wclk1 <= wclk;
         wclk2 <= wclk1;
         end    
 
 assign pe = wclk1 & (~wclk2);
 
 always @ (posedge pe)
 if(rst)
        begin
         dout <= 0;
        end
  else
     begin
     dout <= din;
     end
 
endmodule
