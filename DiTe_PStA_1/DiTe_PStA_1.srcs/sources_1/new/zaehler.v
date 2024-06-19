`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/13
// Design Name: 
// Module Name: Münzzähler
// Project Name: Verkaufsautomat
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

module zaehler(
        input sys_clk,
        input [1:0]key,
        output reg fifty,
        output reg euro,
        output reg fiftyBuffer,
        output reg euroBuffer,
        output reg fiftyTap,
        output reg euroTap,
        output reg productLed,
        output reg productchangeLed
    );


wire fiftyInput = key[0];
wire euroInput = key[1];
wire fiftyTapOut = fiftyTap;
wire euroTapOut = euroTap;
wire fiftyBufferOut = fiftyBuffer;
wire euroBufferOut = euroBuffer;
wire fiftyOut = fifty;
wire euroOut = euro;

//weiß ich ja nich 
initial begin
    fiftyBuffer <= 1'b0; 
    euroBuffer <= 1'b0;
end 

always @(posedge sys_clk)begin
    if (fiftyInput==1)              //Input mus =0 nach Schaltplan?
        fiftyBuffer <= 1'b1;
    else
        fiftyBuffer <= 1'b0;
    if (euroInput==1)
        euroBuffer <= 1'b1;
    else
        euroBuffer <= 1'b0;

    if( (((fiftyBufferOut==0)&&(fiftyInput==0))==0) && (fiftyBufferOut==0))
        fiftyTap <= 1'b1;
    else
        fiftyTap <= 1'b0;
    if( ((euroBufferOut==0)&&(euroInput==0)==0) && (euroBufferOut==0))
        euroTap <= 1'b1;
    else
        euroTap <= 1'b0;
        
    // code to do
   // fiftybuffer <= fiftyInput;
   // euroBuffer <= euroInput;
    if(((euroOut==0)&&(euroTapOut==0)&&(fiftyTapOut==1)&&((fiftyOut==0)||fiftyOut==1))||((euroOut==0)&&(fiftyOut==1)&&(euroTapOut==1)&&(fiftyTapOut==0))||(fiftyOut==1))
        fifty <= 1'b1;
    else
        fifty <= 1'b0;    
        
    if (((euroOut==0)&&(euroTapOut==1)&&(fiftyTapOut==0))||(((euroOut==0)&&(fiftyOut==1)&&(euroTapOut==0)&&(fiftyTapOut==1)))||(euroOut==1))
        euro <= 1'b1;
    else
        euro <= 1'b0;
    if ((fiftyOut==1)&&(fiftyTapOut==1))
        fifty <= 1'b0;  
    
//Output via LEDs
    if (euroOut==1)
        productLed <= 1'b1;
    if ((euroOut==1)&&(fiftyOut==1))    
        productchangeLed <= 1'b1;
    if ((euroOut==1)&&(fiftyOut==1))    
        productLed <= 1'b0;
        
// Reset bei Dopeelinput
    if ((euroInput==1)&&(fiftyInput==1))
        fiftyBuffer <= 1'b0;
    if ((euroInput==1)&&(fiftyInput==1))
        euroBuffer <= 1'b0;
 end   
/*
always @(posedge sys_clk)begin
    if(((zahl1_out==0)&&(flag1==0)&&(flag0==1)&&((zahl0_out==0)||zahl0_out==1))||((zahl1_out==0)&&(zahl0_out==1)&&(flag1==1)&&(flag0==0)))
        zahl0 <= 1'b1;
    else
        zahl0 <= 1'b0;    
        
    if (((zahl1_out==0)&&(flag1==1)&&(flag0==0))||(((zahl1_out==0)&&(zahl0_out==1)&&(flag1==0)&&(flag0==1))))
        zahl1 <= 1'b1;
    else
        zahl1 <= 1'b0;

end

always @(posedge sys_clk)begin
    if( ~((~fiftyBufferOut)&&(~fiftyInput)) && ~(fiftyBufferOut))
        fiftyTap <= 1'b1;
    else
        fiftyTap <= 1'b0;
    if( ~((~euroBufferOut)&&(~euroInput)) && ~(euroBufferOut))
        euroTap <= 1'b1;
    else
        euroTap <= 1'b0;
*/
endmodule