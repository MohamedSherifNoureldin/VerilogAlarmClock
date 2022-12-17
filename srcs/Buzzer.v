`timescale 1ns / 1ps

module Buzzer(input clk, input en, output speaker);
    parameter clkdivider = 100000000/440/2;
    
    reg [23:0] tone;
    always @(posedge clk) tone <= tone+1;
    
    reg [14:0] counter;
    always @(posedge clk) if (counter == 0) counter <= (tone[23] ? clkdivider-1 : clkdivider/2-1); else counter <= counter-1;
    
    reg speaker;
    always @(posedge clk) begin
        if (!en) speaker <= 0;
        else if (counter == 0) speaker <= ~speaker;
    end
    
endmodule