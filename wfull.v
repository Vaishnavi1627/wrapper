`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2021 11:43:46
// Design Name: 
// Module Name: full
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


module wptr_full #(parameter add_size = 8)
(output reg full,  // full flag
output [add_size-1:0] wr_addr,  // write address in binary 
output reg [add_size :0] wr_ptr,  //  write pointer in binary
input [add_size :0] rd_ptr_sync,  // read pointer after synchronization
input [add_size :0] rd_ptr,  // read pointer after synchronization
input wr_inc,  //write enable
input wr_clk, // write clock
input rd_inc,
input wr_rst);   // write reset

//
	// Module body
//------ Write pointer full module  registers and wires-------
reg [add_size:0] wbin; // write pointer in binary format
wire [add_size:0] wgraynext, wbinnext;  //write gray next, write binary next
wire wfull_val;


//  ----gary counter implementation------
assign wr_addr = wbin[add_size-1:0];   // assign write binary to wrrite address
assign wbinnext = wbin + (wr_inc & ~full);  // write pointer binary increment in write enable and not full
assign wgraynext = (wbinnext>>1) ^ wbinnext;  // binary to gray conversion

// ----- full flag condition-------
assign  wfull_val=  ((wgraynext[add_size] !=rd_ptr_sync[add_size] ) &&
(wgraynext[add_size-1] !=rd_ptr_sync[add_size-1]) &&
 (wgraynext[add_size-2:0]==rd_ptr_sync[add_size-2:0]) && wr_inc);  // full flag assignment logic  for error while it should stop after next clock cycle only
 
 
 assign  wfull_val=  ((wgraynext[add_size] !=rd_ptr[add_size] ) &&
(wgraynext[add_size-1] !=rd_ptr[add_size-1]) &&
 (wgraynext[add_size-2:0]==rd_ptr[add_size-2:0]) && wr_inc);  // full flag assignment logic  for error while it should stop after next clock cycle only
 
// assign wfull_val=(((wgraynext[add_size] !=rd_ptr_sync[add_size] ) &&
//(wgraynext[add_size-1] !=rd_ptr_sync[add_size-1]) &&
// (wgraynext[add_size-2:0]==rd_ptr_sync[add_size-2:0])) | !((wr_ptr[add_size] !=rd_ptr_sync[add_size] ) &&
//(wr_ptr[add_size-1] !=rd_ptr_sync[add_size-1]) &&
// (wr_ptr[add_size-2:0]==rd_ptr_sync[add_size-2:0]) ));  // full flag assignment logic
 // ---------pointer update to next value ---------
always @(posedge wr_clk or posedge wr_rst)
begin
if (!wr_rst) 
{wbin, wr_ptr} <= 0;
else 
{wbin, wr_ptr} <= {wbinnext, wgraynext};  //  next value to pointer after positive edge of clock
end

// ------- full flag assignment--------
always @(posedge wr_clk or posedge wr_rst)
begin
if (!wr_rst) 
full <= 1'b0;
else 
full <= wfull_val ;  //  full flag value at positive edge of clock
end
endmodule


