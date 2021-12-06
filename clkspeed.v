`timescale 1ns/10ps

module foo(clk1, clk2,l2h, freq1, freq2);
     input clk1,clk2;
      output reg l2h;
      output reg [100:0] freq1, freq2;
     real t10, t20;
     real t11, t21;
     real frequency1, frequency2;

    always@(clk1 or clk2)
          begin
               @ (posedge clk1) t10 = $realtime;
               @ (posedge clk1) t11 = $realtime;
               frequency1 = 1.0e9 / (t11 - t10);
               freq1= frequency1;
          end
          
     always@(clk1 or clk2)
          begin
               @ (posedge clk2) t20 = $realtime;
               @ (posedge clk2) t21 = $realtime;
               frequency2 = 1.0e9 / (t21 - t20);
               freq2 = frequency2;
          end     
        
       always@(frequency1 or frequency2)
        begin
        if (frequency1> frequency2)
        l2h=1'b0;
        else 
        l2h= 1'b1;
        end  
 
       
endmodule
