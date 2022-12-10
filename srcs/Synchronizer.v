`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 08:42:43 PM
// Design Name: 
// Module Name: Synchronizer
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


module Synchronizer(input clk, rst, in, output reg out);
reg q1;
always@(posedge clk, posedge rst) begin
 if(rst == 1'b1) begin
 q1 <= 0;
 out <= 0;
 end
 else begin
 q1 <= in;
 out <= q1;
 end
end
endmodule
//module Synchronizer(input clk, reset, in, output reg out);
//    reg q1;
//    always@(posedge clk, posedge reset) begin
//         if(reset == 1'b1) begin
//            q1 <= 0;
//         end
//         else begin
//             q1 <= in;
//             out <= q1;
//         end
//    end
//endmodule
