`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2021 17:21:02
// Design Name: 
// Module Name: dc
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
/*
Description
===========

I/Os
----
rd_clk	Read Port Clock
wr_clk	Write Port Clock
rst	low active, either sync. or async. master reset (see below how to select)
clr	synchronous clear (just like reset but always synchronous), high active
re	read enable, synchronous, high active
we	read enable, synchronous, high active
din	Data Input
dout	Data Output

full	Indicates the FIFO is full (driven at the rising edge of wr_clk)
empty	Indicates the FIFO is empty (driven at the rising edge of rd_clk)

full_n	Indicates if the FIFO has space for N entries (driven of wr_clk)
empty_n	Indicates the FIFO has at least N entries (driven of rd_clk)

level		indicates the FIFO level:
		2'b00	0-25%	 full
		2'b01	25-50%	 full
		2'b10	50-75%	 full
		2'b11	%75-100% full

Status Timing
-------------
All status outputs are registered. They are asserted immediately
as the full/empty condition occurs, however, there is a 2 cycle
delay before they are de-asserted once the condition is not true
anymore.

Parameters
----------
The FIFO takes 3 parameters:
dw	Data bus width
aw	Address bus width (Determines the FIFO size by evaluating 2^aw)
n	N is a second status threshold constant for full_n and empty_n
	If you have no need for the second status threshold, do not
	connect the outputs and the logic should be removed by your
	synthesis tool.

Synthesis Results
-----------------
In a Spartan 2e a 8 bit wide, 8 entries deep FIFO, takes 85 LUTs and runs
at about 116 MHz (IO insertion disabled). The registered status outputs
are valid after 2.1NS, the combinatorial once take out to 6.5 NS to be
available.

Misc
----
This design assumes you will do appropriate status checking externally.

IMPORTANT ! writing while the FIFO is full or reading while the FIFO is
empty will place the FIFO in an undefined state.

*/


// Selecting Sync. or Async Reset
// ------------------------------
// Uncomment one of the two lines below. The first line for
// synchronous reset, the second for asynchronous reset



module asyn_fifo_top(
rd_clk, //read clock
wr_clk, // write clock
rst, // reset
data_in, // data input to fifo
wr_en, // write enable 
data_out,  // data output
rd_en,  // read enable
full,  // full flag
empty   );  // empty flag

parameter data_size = 8;  // number of bits in data
parameter add_size = 8;  // number of bits in address-bus
parameter n = 32;
parameter max_size = 1<<add_size;

input rd_clk;
input wr_clk;
input rst;
input [data_size-1:0]	data_in;
input wr_en;
output	[data_size-1:0]	data_out;
input	rd_en;
output	full; 
output	empty;


////////////////////////////////////////////////////////////////////
//
// Local Wires
//

wire	[add_size:0]		wr_ptr;  // write pointer in gray fortmat
wire	[add_size:0]		rd_ptr;   // read pointer in gray format
wire	[add_size:0]		wr_ptr_s;  // write pointer after synchronization
 wire	[add_size:0]        rd_ptr_s;  // read pointer after synchronization
wire		full, empty;
wire [add_size-1:0] wr_addr; // write pointer in binary format 
wire [add_size-1:0] rd_addr;  // read pointer in binary format

////////////////////////////////////////////////////////////////////
//
// Memory Block--- dpram-------
//
// Module Instantiations
generic_dpram  #(add_size,data_size) u0(
	.rclk(		rd_clk		),
	.rrst(		!rst		),
	.rce(		1'b1		),
	.oe(		1'b1		),
	.rd_en( rd_en),
	.raddr(		rd_addr[add_size-1:0]	),
	.do(		data_out		),
	.wclk(		wr_clk		),
	.wrst(		!rst		),
	.wce(		1'b1		),
	.wr_en(		wr_en		),
	.waddr(		wr_addr[add_size-1:0]	),
	.di(		data_in		), 
	.full(full),
	.empty(empty)
	);

////////////////////////////////////////////////////////////////////
//
// Read/Write Pointers Logic
//
// ---------- full flag logic module------
// Module Instantiations
wptr_full  wptr_full
(
.full(full), 
.wr_addr(wr_addr),
.wr_ptr(wr_ptr), 
.rd_ptr_sync(rd_ptr_s),
.rd_ptr(rd_ptr),
.wr_inc(wr_en),
.rd_inc(rd_en),
.wr_clk(wr_clk),
.wr_rst(rst)
);
 
 
 
//  ----- synchronizer read to write module----
// Module Instantiations
sync_r2w sync_r2w (
.rd_ptr_sync(rd_ptr_s), 
.rd_ptr(rd_ptr),
.wr_clk(wr_clk),
 .wr_rst(rst)
 );
  
  
  
//------ synchronizer write to read module-------
// Module Instantiations
sync_w2r sync_w2r (.wr_ptr_sync(wr_ptr_s), 
.wr_ptr(wr_ptr),
.rd_clk(rd_clk), 
.rd_rst(rst));


//------- assign empty flag module--------
// Module Instantiations
rptr_empty  rptr_empty(
.empty(empty),
.rd_addr(rd_addr),
.rd_ptr(rd_ptr),
.wr_ptr_sync(wr_ptr_s),
.rd_inc(rd_en),
.wr_inc(wr_en), 
.rd_clk(rd_clk),
.rd_rst(rst)
);

//////////////////////////////////////////////////////////////////////
// Sanity Check
//

// synopsys translate_off
always @(posedge wr_clk)
	if( full)
		$display("%m WARNING: Writing while fifo is FULL (%t)",$time);   // Gives warning when writing while fifo is full

always @(posedge rd_clk)
	if( empty)
		$display("%m WARNING: Reading while fifo is EMPTY (%t)",$time);  // Gives warning when reading while fifo is empty
// synopsys translate_on

endmodule

