`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/06 09:52:07
// Design Name: 
// Module Name: test_sim
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


module zaehler_sim();
reg clk;
reg [1:0]key_in;
reg fifty;
reg euro;


/*
wire fiftyOut;
wire euroOut;
wire fiftyTapOut;
wire euroTapOut;
wire fiftyBufferOut;
wire euroBufferOut;
wire sellOut;
*/
wire fiftyInput; 
wire euroInput ;
wire fiftyTapOut;
wire euroTapOut ;
wire fiftyBufferOut;
wire euroBufferOut;
wire fiftyOut;
wire euroOut ;
wire sellOut ;
wire delayOut;
wire resetOut;

      
zaehler u_zaehler(
              clk,
              key_in,
              fiftyOut,
              euroOut,    
              fiftyBuffer,
              euroBuffer,
              fiftyTap,
              euroTap,
              SellLED,
              ChangeLED,
              euroLED,
              fiftyLED,
              delay_done,
              counter_reset,
              counter
              
        ); 
// fifty + euro  
/*
initial begin
    fifty=0;
    euro=0; 
    clk  = 1'b0;
    key_in = 2'b00;
    #30 key_in = 2'b01;
    #30 key_in = 2'b00;
    #30 key_in = 2'b10;
    #30 key_in = 2'b00;
end  

/*
//fifty + fifty
initial begin
    fifty=0;
    euro=0; 
    clk  = 1'b0;
    key_in = 2'b00;
    #30 key_in = 2'b01;
    #30 key_in = 2'b00;
    #30 key_in = 2'b01;
    #30 key_in = 2'b00;
  
    #30 key_in = 2'b01;
    #30 key_in = 2'b00;
    #30 key_in = 2'b10;
    #30 key_in = 2'b00;
    
    #30 key_in = 2'b10;
    #30 key_in = 2'b00;
    #30 key_in = 2'b00;
    #30 key_in = 2'b00;

end 
*/
//euro 

initial begin
    fifty=0;
    euro=0; 
    clk  = 1'b0;
    key_in = 2'b00;
    #30 key_in = 2'b10;
    #30 key_in = 2'b00;
    #30 key_in = 2'b00;
    #30 key_in = 2'b00;
end   
     
always #15 clk = ~clk;       
endmodule