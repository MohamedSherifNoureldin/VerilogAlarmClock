`timescale 1ns / 1ps

//takes x number of bits and increments the counter until it reaches n-1
module CounterModN #(parameter x = 3,parameter  n = 5) (input clk, rst, enable, load, input[x-1:0] data, output reg [x-1:0] count);
  always @(posedge clk, posedge rst) begin
    if (rst)
        count <= 0;
    else if (load) 
        count <= data;
    else if (enable & count == n-1)   //reset the counter when it reaches n-1
        count <= 0;
    else if (enable) 
        count <= count + 1;
  end
endmodule