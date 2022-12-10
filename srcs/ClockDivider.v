`timescale 1ns / 1ps

module ClockDivider #(parameter n = 50000000) (input clk, rst, output reg clk_out);
    reg [31:0] count;
    // Big enough to hold the maximum possible value
    // Increment count
    always @ (posedge clk, posedge rst) begin
        if (rst == 1'b1) // Asynchronous Reset
            count <= 32'b0;
        else if (count == n-1)
            count <= 32'b0;
        else
            count <= count + 1;
    end
    // Handle the output clock
    always @ (posedge clk, posedge rst) begin
        if (rst) // Asynchronous Reset
            clk_out <= 0;
        else if (count == n-1)
            clk_out <= ~clk_out;
    end
endmodule
