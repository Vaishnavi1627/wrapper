`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2021 12:01:32
// Design Name: 
// Module Name: empty
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


module rptr_empty #(parameter add_size = 8)
(output reg empty,   // empty flag
output [add_size-1:0] rd_addr,   // read address in  binary format
output reg [add_size :0] rd_ptr,  // read pointer in binary format
input [add_size :0] wr_ptr_sync,  // write pointer after synchronization
input rd_inc,  // read enable
input wr_inc , // write enable
input rd_clk,  // read clock
input rd_rst);    // read reset

//
	// Module body
	// ------Read pointer empty module  registers and wires-------
reg [add_size:0] rbin;  // read pointer in binary format
wire [add_size:0] rgraynext;  // read pointer next in gray format
wire [add_size:0] rbinnext;   //  read pointer next in binary format
wire rempty_val;

//  ----gary counter implementation------
assign rd_addr = rbin[add_size-1:0];    // assign read binary to read address
assign rbinnext = rbin + (rd_inc & ~empty);  // binary pointer increment
assign rgraynext = (rbinnext>>1) ^ rbinnext;  // binary to gray conversionb

// ----- empty flag condition-------
assign  rempty_val = ((rd_ptr == wr_ptr_sync) | ( (wr_ptr_sync== rgraynext )));  // empty value assignment


 // ---------pointer update to next value ---------
always @(posedge rd_clk or posedge rd_rst)
begin
if (!rd_rst) 
{rbin, rd_ptr} <= 0;  // if !rst then assign pointer to 0
else 
{rbin, rd_ptr} <= {rbinnext, rgraynext}; //  next value to pointer at positive clock edge
end

// ------- empty flag assignment--------
always @(posedge rd_clk )
begin
if (!rd_rst) 
empty <= 1'b1;
else 
empty <= rempty_val;  // empty flag update at positive edge of clock 
end
endmodule

