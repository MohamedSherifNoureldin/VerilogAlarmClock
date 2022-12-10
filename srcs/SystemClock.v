`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 06:48:00 PM
// Design Name: 
// Module Name: SystemClock
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


module SystemClock(input clk, reset, enable, output [3:0] hour_units, min_units, output [2:0] hour_tens, min_tens);
    wire clk_out;
            
    // Controlling min and hours digits 
    SystemCounter counter(clk, reset, enable, min_units, hour_units, min_tens, hour_tens);
    
    // Controlling the decimal point 
    ClockDivider #(50000000) ckDecimal(clk, reset, clk_sec);

endmodule
