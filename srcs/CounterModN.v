`timescale 1ns / 1ps

module CounterModN #(parameter x = 5,parameter  n = 3) (input clk, rst, enable, load, input[x-1:0] data, output reg [x-1:0] count);
  always @(posedge clk, posedge rst) begin
    if (rst)
        count <= 0;
    else if (load) 
        count <= data;
    else if (enable & count == n-1) 
        count <= 0;
    else if (enable) 
        count <= count + 1;
  end
endmodule