`timescale 1ns / 1ps

module Synchronizer(input clk, reset, in, output reg out);
    reg q1;
    always@(posedge clk, posedge reset) begin
         if(reset == 1'b1) begin
            q1 <= 0;
         end
         else begin
             q1 <= in;
             out <= q1;
         end
    end
endmodule
