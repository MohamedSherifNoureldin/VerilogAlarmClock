`timescale 1ns / 1ps

//takes x number of bits and increments the counter until it reaches n-1  or decrements from n until it reaches 0
module CounterModNUpDown #(parameter x = 3,parameter  n = 5) (input clk, reset, up, down, load, input[x-1:0] data, output reg [x-1:0] count);
  always @(posedge clk, posedge reset) begin
    if (reset)
        count <= 0;
    else if (load) 
        count <= data;
    else if (up & count == n-1) //reset to 0 the counter when it reaches n
        count <= 0;
    else if (down & count == 0) //reset to n-1 the counter when it reaches 0
        count <= n-1;
    else if (up) 
        count <= count + 1;
    else if (down)
        count <= count - 1;
  end
endmodule
