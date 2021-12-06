`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01.11.2021 09:46:53
// Design Name:
// Module Name: top_tb
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


module wrapper_both_tb#(parameter DATA_WIDTH = 32, LOC = 256, ADD_WIDTH = 9)( );

reg rclk;
reg wclk;
reg rst;
reg wen;
reg ren;
reg   [DATA_WIDTH-1 :0]din;
wire  [DATA_WIDTH-1 :0]dout4;
wire  [DATA_WIDTH-1 :0]doutx; 
wire  lh1;
wire  [DATA_WIDTH-1 :0]dout4_b;   //output os Asynchromous FIFO 
wire  [DATA_WIDTH-1 :0]doutx_b;  //output of l2h

wire  full2; 
wire  empty2; 
wire  lh2;

wire full1;
wire empty1 ;
wire [DATA_WIDTH-1 :0]dout_final_1;
wire [DATA_WIDTH-1 :0]dout_final_2;


wrapper_both_top tb( .wclk(wclk),.rclk(rclk),.rst(rst),
        .din(din),
        .doutx(doutx),        
        .dout(dout_final_1),
        .dout4(dout4),
        .full1(full1),
        .empty1(empty1),
        .dout4_b(dout4_b),   
        .doutx_b(doutx_b),  
        .dout_b(dout_final_2),           
        .full2(full2),
        .empty2(empty2),      
        .wen(wen),
        .ren(ren),
        .lh1(lh1),
        .lh2(lh2)
        );


initial 
begin
    #5     wclk =1'b0 ; rst = 1; wen = 0; ren = 0;
    #5     rclk =1'b0 ;
    #50    rst = 0 ; wen = 1; ren = 1;
    
    #20000 $finish;

end

always #(10) wclk = ~ wclk;
always #(2.5)  rclk = ~ rclk;
    



always@(posedge wclk)
       begin
       if(wen)
          din = $random;
       end
       
       
endmodule


