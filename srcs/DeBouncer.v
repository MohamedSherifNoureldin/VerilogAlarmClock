`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 08:41:27 PM
// Design Name: 
// Module Name: DeBouncer
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


module DeBouncer(input clk, reset, in, output out);
    reg q1,q2,q3;
    always@(posedge clk, posedge reset) begin
        if(reset == 1'b1) begin
            q1 <= 0;
            q2 <= 0;
            q3 <= 0;
        end
        else begin
            q1 <= in;
            q2 <= q1;
            q3 <= q2;
        end
    end
    assign out = (reset) ? 0 : q1 & q2 & q3;
endmodule
