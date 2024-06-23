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
        output reg SellLed,
        output reg ReturnLed,
        output reg euroLed,
        output reg fiftyLed
    );


wire fiftyInput = key[0];
wire euroInput = key[1];
wire fiftyTapOut = fiftyTap;
wire euroTapOut = euroTap;
wire fiftyBufferOut = fiftyBuffer;
wire euroBufferOut = euroBuffer;
wire fiftyOut = fifty;
wire euroOut = euro;

initial begin
    fiftyBuffer <= 1'b0; 
    euroBuffer <= 1'b0;
    SellLed <= 1'b0;
    ReturnLed <= 1'b0;
end 

always @(posedge sys_clk)begin
    if (fiftyInput==1)              //Input muss =0 nach Schaltplan?
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

    if (((euroOut==0)&&(fiftyOut==0)&&(euroTapOut==0)&&(fiftyTapOut==1)) // 50 Cent Einwurf
    || ((euroOut==0)&&(fiftyOut==1)&&(euroTapOut==1)&&(fiftyTapOut==0))  // 1 Euro Einwurf bei bestehenden 50 Cent
    || ((euroOut==0)&&(fiftyOut==1)&&(euroTapOut==0)&&(fiftyTapOut==0))) // kein Einwurf bei 50 Cent
        fifty <= 1'b1;
    else
        fifty <= 1'b0;
    if ((euroOut==0)&&(fiftyOut==1)&&(euroTapOut==0)&&(fiftyTapOut==1))   //Hardcodierung: Reset bei 50 Cent Einwurf bei bestehenden 50 Cent
        fifty <= 1'b0; 
    if (((euroOut==0)&&(euroTapOut==1)&&(fiftyTapOut==0))                 // 1 Euro Einwurf 
    || ((euroOut==0)&&(fiftyOut==1)&&(euroTapOut==0)&&(fiftyTapOut==1)))  // 1 Euro Einwurf bei bestehenden 50 Cent 
        euro <= 1'b1;
    else
        euro <= 1'b0;
        
//Output via LEDs
// Inputfeedback
    if (fiftyOut==1)
        fiftyLed <= 1'b1;                // 50ct LED
    else
        fiftyLed <= 1'b0;
    if (euroOut==1)
        euroLed <= 1'b1;                // 1€ LED
    else
        euroLed <= 1'b0;

// Outputfeedback
    if ((euroOut==1)&&(fiftyOut==0)) begin
        SellLed <= 1'b1;                 // S LED
        #10; // sleeps for 10ns
    end else
        SellLed <= 1'b0;
    if ((euroOut==1)&&(fiftyOut==1)) begin
        ReturnLed <= 1'b1;
        SellLed <= 1'b1;                 // R LED 
        #10;
    end else
        ReturnLed <= 1'b0;
        
end   
endmodule