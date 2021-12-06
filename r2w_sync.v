
module sync_r2w #(parameter add_size = 8)
(output reg [add_size:0] rd_ptr_sync,   // read pointer after synchronization
input [add_size:0] rd_ptr,   // read pointer before synchronization
input wr_clk, wr_rst);  // write clock, write reset

// Module body
	// -----synchronize read to write module  registers and wires--------
reg [add_size:0] wq1_rptr;   // read pointer after first clock of synchronization

// ------synchronized read pointer assignment-------

always @(posedge wr_clk or posedge wr_rst)
if (!wr_rst) 
begin
rd_ptr_sync <=0;  // if reset assign to zero
end
else
begin
rd_ptr_sync<= rd_ptr;
end
endmodule
