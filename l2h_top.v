module top2#(parameter DATA_WIDTH = 32, LOC = 64, ADD_WIDTH = 4)(
input wclk,
input rclk,
input rst,
input  [DATA_WIDTH-1 :0]din,
output  [DATA_WIDTH-1 :0]dout,
output pe
);

reg [DATA_WIDTH-1 :0]mem1[0:LOC-1];
reg [DATA_WIDTH-1 :0]mem2[0:LOC-1];
reg [ADD_WIDTH :0] wctr,rctr;


ltoh top(
.rst(rst),
.din(din),
.dout(dout),
.wclk(wclk),
.rclk(rclk),
.pe(pe)
);


endmodule
