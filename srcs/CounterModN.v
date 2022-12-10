`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 06:41:26 PM
// Design Name: 
// Module Name: CounterModN
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


module CounterModN #(parameter x = 5,parameter  n = 3) (input clk, reset, enable, load, input[x-1:0] data, output reg [x-1:0] count);
  always @(posedge clk, posedge reset) begin
    if (reset)
        count <= 0;
    else if (load) 
        count <= data;
    else if (enable & count == n-1) 
        count <= 0;
    else if (enable) 
        count <= count + 1;
  end
endmodule