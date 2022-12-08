`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 06:44:40 PM
// Design Name: 
// Module Name: SystemCounter
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


module SystemCounter(input clk, reset, enable, output [3:0] sec_units, min_units, output [2:0] sec_tens, min_tens);
    wire clk_out; // we can ignore it as it is a one bit wire
    ClockDivider ck(clk, rst, clk_out);
    CounterModN #(4, 10) sec_mod_10(clk_out, reset, enable, sec_units);
    CounterModN #(3, 6) sec_mod_6(clk_out, reset, sec_units == 9, sec_tens);
        
    CounterModN #(4, 10) min_mod_10(clk_out, reset, (sec_units == 9 && sec_tens == 5), min_units);
    CounterModN #(3, 6) min_mod_6(clk_out, reset, (sec_units == 9 && sec_tens == 5 && min_units == 9), min_tens);

endmodule