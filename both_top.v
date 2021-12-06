module both_top#(parameter DATA_WIDTH = 8, LOC = 64, ADD_WIDTH = 3)(
input rclk,
input wclk,
input rst,
input [DATA_WIDTH-1 :0]din,
input wen,
input ren,  
output  [DATA_WIDTH-1 :0]dout4,  //output os Asynchromous FIFO
output  [DATA_WIDTH-1 :0]doutx,  //output of l2h 
output  [DATA_WIDTH-1 :0]dout,   //overall output
output full,
output  empty ,
output  pe, 
output  lh,
output  [100:0] freq1,  freq2
    );
reg [DATA_WIDTH-1 :0]dout4_net;  
reg [DATA_WIDTH-1 :0]dout_reg; 

assign dout = dout_reg;


asyn_fifo_top async(
.rd_clk(rclk), //read clock
.wr_clk(wclk), // write clock
.rst(~lh & ~rst), // reset
.data_in(din), // data input to fifo
.wr_en(wen), // write enable
.data_out(dout4),  // data output
.rd_en(ren),  // read enable
.full(full),  // full flag
.empty(empty)
);

top2 l2h(
.wclk(wclk),

.rclk(rclk),
.rst(lh & rst),
.din(din),
.dout(doutx),
.pe(pe)
);

foo f1(
.clk1(wclk),
.clk2(rclk),
.l2h(lh),
.freq1(freq1),
.freq2(freq2));


always@(*)
begin
if(~lh)
begin
dout_reg <= dout4;
end
else 
begin
dout_reg <= doutx;
end
end

endmodule
