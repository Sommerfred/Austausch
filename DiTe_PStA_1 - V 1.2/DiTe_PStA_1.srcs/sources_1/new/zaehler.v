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

// Schreib ein Reset register das bei fallender Flanke 
// von Sell-LED 1 ausgibt und dise Vergleiche mit den einzelnen Inputs jedes Registers

// Zeitschaltung einbauen wie?

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
        output reg fiftyLed,
        output reg delay_done,
        output reg counter_reset,
        output reg [31:0] counter

    );


wire fiftyInput = key[0];
wire euroInput = key[1];
wire fiftyTapOut = fiftyTap;
wire euroTapOut = euroTap;
wire fiftyBufferOut = fiftyBuffer;
wire euroBufferOut = euroBuffer;
wire fiftyOut = fifty;
wire euroOut = euro;
wire sellOut = SellLed;
wire returnOut = ReturnLed; 
wire delayOut = delay_done;
wire resetOut = counter_reset;




initial begin
        ReturnLed <= 0;
        SellLed <= 0;
        fiftyBuffer <= 0; 
        euroBuffer <= 0;
        fiftyTap <= 0;
        euroTap <= 0;
        fifty <= 0;
        euro <= 0;
        fiftyLed <= 0;
        euroLed <=0;
        counter_reset <= 1;
end 

always @(posedge sys_clk)begin : Automat

    parameter CLOCK_FREQ = 50000000; // Taktfrequenz 50 MHz
    parameter DELAY_TIME = 5; // Verzögerung in Sekunden
    parameter MAX_COUNT = CLOCK_FREQ * DELAY_TIME; // Maximale Zählerzahl
    
    if (fiftyInput==1)            
        fiftyBuffer <= 1;
    else
        fiftyBuffer <= 0;
    if (euroInput==1)
        euroBuffer <= 1;
    else
        euroBuffer <= 0;

    if((((fiftyBufferOut==0)&&(fiftyInput==0))==0) && (fiftyBufferOut==0))
        fiftyTap <= 1;
    else
       fiftyTap <= 0;
    if( ((euroBufferOut==0)&&(euroInput==0)==0) && (euroBufferOut==0))
        euroTap <= 1;
    else
        euroTap <= 0;

    if (((euroOut==0)&&(fiftyOut==0)&&(euroTapOut==0)&&(fiftyTapOut==1)) // 50 Cent Einwurf
    || ((euroOut==0)&&(fiftyOut==1)&&(euroTapOut==1)&&(fiftyTapOut==0))  // 1 Euro Einwurf bei bestehenden 50 Cent
    || ((euroOut==0)&&(fiftyOut==1)&&(euroTapOut==0)&&(fiftyTapOut==0)) // kein Einwurf bei 50 Cent
    || ((returnOut==1)&&(sellOut==1)))                                  // Wechselgeldfall
        fifty <= 1;
    else
        fifty <= 0;
    if ((euroOut==0)&&(fiftyOut==1)&&(euroTapOut==0)&&(fiftyTapOut==1))   // Reset bei 50 Cent Einwurf bei bestehenden 50 Cent
        fifty <= 0; 
    if (((euroOut==0)&&(euroTapOut==1)&&(fiftyTapOut==0))                 // 1 Euro Einwurf 
    || ((euroOut==0)&&(fiftyOut==1)&&(euroTapOut==0)&&(fiftyTapOut==1))  // 1 Euro Einwurf bei bestehenden 50 Cent
    || (sellOut==1))                                                     // Verkaufsfall 
        euro <= 1;
    else
        euro <= 0;
        
//Output via LEDs
// Inputfeedback
    if (fiftyOut==1)
        fiftyLed <= 1;                // 50ct LED
    else 
        fiftyLed <= 0;
    if (euroOut==1)
        euroLed <= 1;                // 1€ LED


// Outputfeedback
    if ((euroOut==1)&&(fiftyOut==0)) begin
        SellLed <= 1;                 // S LED
    end

    if ((euroOut==1)&&(fiftyOut==1)) begin
        ReturnLed <= 1;
        SellLed <= 1;                 // R LED 
        
    end
    
    if (sellOut==1)begin
        if (counter_reset==1) begin
            counter <= 0;
            delay_done <= 0;
            counter_reset <= 0;
        end else if (counter < MAX_COUNT) begin
            counter <= counter + 1;
        end else begin
            delay_done <= 1;
            counter_reset <= 1;
        end
                
    if (delayOut==1)begin
        ReturnLed <= 0;
        SellLed <= 0;
        fiftyBuffer <= 0; 
        euroBuffer <= 0;
        fiftyTap <= 0;
        euroTap <= 0;
        fifty <= 0;
        euro <= 0;
        fiftyLed <= 0;
        euroLed <=0;
     end
 
end end
endmodule

