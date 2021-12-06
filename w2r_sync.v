


module sync_w2r #(parameter add_size = 8)
(output reg [add_size:0] wr_ptr_sync,   //  write pointer after synchronization 
input [add_size:0] wr_ptr, //  write pointer before synchronization 
input rd_clk, rd_rst);  // read clock, rad reset

// Module body
// -----synchronize write to read module  registers and wires--------
reg [add_size:0] wq1_rptr;   // read pointer after first clock of synchronization
	
// ------synchronized write pointer assignment-------
always @(posedge rd_clk or posedge rd_rst)
if (!rd_rst)
begin
wr_ptr_sync<=0;
end
else 
begin
wr_ptr_sync <=wr_ptr;
end
endmodule
