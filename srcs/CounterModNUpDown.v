`timescale 1ns / 1ps

module CounterModNUpDown #(parameter x = 5,parameter  n = 3) (input clk, reset, up, down, load, input[x-1:0] data, output reg [x-1:0] count);
  always @(posedge clk, posedge reset) begin
    if (reset)
        count <= 0;
    else if (load) 
        count <= data;
    else if (up & count == n-1) 
        count <= 0;
    else if (down & count == 0) 
        count <= n-1;
    else if (up) 
        count <= count + 1;
    else if (down)
        count <= count - 1;
  end
endmodule
