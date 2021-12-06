`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.12.2021 14:42:55
// Design Name: 
// Module Name: trial_tb
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

module wrapper_both_tb #(parameter DATA_WIDTH = 32, LOC = 256, ADD_WIDTH = 9)( );

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


wrapper_both_top tb( 
        .wclk(wclk),
        .rclk(rclk),
        .rst(rst),
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
		
///////////////////////////////////////////////////////////////////
// Initial Startup and Simulation Begin
//assign valid_in3 =  valid_out2;
//assign ready_in2 =  ready_out3;

integer		x, rwd;
real rcp;
integer		wrp, rdp;
reg	   [7:0]buffer[0:1024];
reg	   [7:0]buffer2[0:1024];



initial
   begin
	rcp = 5;   		rclk = 0;  wclk = 0;  rst = 1;	

//	we1 = 0;	 re1 = 0;     wrp2 = 0;	    rdp2 = 0;

	rwd = 0;	 wrp = 0;	  rdp = 0;     

 if(1)
	   begin
		test_dc_fifo;
	   end
	else
	   begin

		rwd = 4;
		wr_dc(8);
		rd_dc(8);
		wr_dc(8);
		rd_dc(8);

	   end

   	$finish;
   end

///////////////////////////////////////////////////////////////////
// TASK test_dc_fifo

task test_dc_fifo;
begin

$display("\n\n");
$display("*****************************************************");
$display("*** DC FIFO Sanity Test                           ***");
$display("*****************************************************\n");

for(rwd = 0;  rwd < 5;   rwd = rwd + 1)	// read write delay
for(rcp = 10; rcp < 40; rcp = rcp + 10.0)
   begin
	$display("rwd=%0d, rcp=%0f",rwd, rcp);

	$display("pass 0 ...");
	for(x=0;x<256;x=x+1)
	   begin
		//rd_wr_dc;
		wr_dc(1);
	   end
	$display("pass 1 ...");
	for(x=0; x<256; x = x + 1)
	   begin
		rd_wr_dc;
		rd_dc(1);
	   end

   end

$display("");
$display("*****************************************************");
$display("*** DC FIFO Sanity Test DONE                      ***");
$display("*****************************************************\n");
end
endtask
///////////////////////////////////////////////////////////////////
// read and write counters
reg		 we1, re1;
reg      we2, re2;

always @(posedge wclk)
	if((we1 & !full1))
	   begin
		buffer[wrp] = din ;
		wrp = wrp+1;
	   end

always @(posedge rclk)
	if((re1 & !empty1))
	   begin
		#3;
		if(dout_final_1 != buffer[rdp] | ( ^dout_final_1 )=== 1'bx)
			$display("ERROR: Data (%0d) mismatch, expected %h got %h (%t)", rdp, buffer[rdp], dout1, $time);
		      rdp = rdp + 1;
          end
/////////////////////////////////////////////////////////////////////

//always @(posedge rclk)
//	if((we2 & !full2))
//	   begin
//		buffer2[wrp2] = din2;
//		wrp2 = wrp2 + 1;
//	   end

//always @(posedge wclk)
//	if((re2 & !empty2))
//	   begin
//		#3;
//		if(data_out_final != buffer2[rdp2] | ( ^data_out_final )=== 1'bx)
//			$display("ERROR: Data (%0d) mismatch, expected %h got %h (%t)", rdp, buffer2[rdp2], dout1, $time);
//		      rdp2 = rdp2 + 1;
//	   end
	   
///////////////////////////////////////////////////////////////////
// Clock generation
//

always #150 rclk = ~rclk;
always #50 wclk = ~wclk;

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TASK wr_dc

task wr_dc;
input	cnt;
integer	n, cnt;

begin
@(posedge wclk);
for(n=0;n<cnt;n=n+1)
   begin
	#1;
	we1 = 1;
	din = $random;
	@(posedge wclk);
	#1;
	we1 = 0;
	din = 8'hxx;
	repeat(rwd)	@(posedge wclk);
   end
end
endtask
///////////////////////////////////////////////////////////////////
// TASK rd_dc


task rd_dc;
input	cnt;
integer	n, cnt;
begin
@(posedge rclk);
for(n = 0; n < cnt; n = n + 1)
   begin
	#1;
	re1 = 1;
	@(posedge rclk);
	#1;
	re1 = 0;
	repeat(rwd)	@(posedge rclk);
   end
end
endtask

///////////////////////////////////////////////////////////////////
// TASK rd_wr_dc

task rd_wr_dc;

integer		n;
begin
   		repeat(10)	@(posedge wclk);
		// RD/WR 1
		for(n=0;n<20;n=n+1)
		   fork

			begin
				wr_dc(1);
			end

			begin
				@(posedge wclk);
				@(posedge wclk);
				rd_dc(1);
			end

		   join

   		repeat(50)	@(posedge wclk);

//		// RD/WR 2
//		for(n=0;n<20;n=n+1)
//		   fork

//			begin
//				wr_dc(2);
//			end

//			begin
//				@(posedge wclk);
//				@(posedge wclk);
//				@(posedge wclk);
//				rd_dc(2);
//			end

//		   join

   		repeat(50)	@(posedge wclk);


end
endtask
    
endmodule
