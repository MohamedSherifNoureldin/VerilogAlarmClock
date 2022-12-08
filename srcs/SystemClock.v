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


module SystemClock(input clk, reset, enable, output[0:6] segment, output[3:0] anodes, output decimal_point);
    wire[1:0] sw;
    reg dec;
    wire clk_out, clk_sec;
    wire [3:0] sec_units, min_units;
    wire [2:0] sec_tens, min_tens;
    
    
    ClockDivider #(250000) ck(clk, reset, clk_out);
    CounterModN #(2, 4) cntModN(clk_out, reset, enable, sw);
    
    // Controlling min and hours digits 
    SystemCounter counter(clk, reset, enable, sec_units, min_units, sec_tens, min_tens);
    
    ClockDivider #(100000000) ckDecimal(clk, reset, clk_sec);
    always @(posedge clk_sec) begin
        dec = ~dec;
    end
    
    reg[3:0] num;
    SegmentDisplay seg(num, sw, dec, enable, segment, anodes, decimal_point);
    always @(sw) begin  
        case(sw) 
            2'b00: num = sec_units;
            2'b01: num = {1'b0, sec_tens};
            2'b10: num = min_units;
            2'b11: num = {1'b0, min_tens};
        endcase
    end

endmodule
