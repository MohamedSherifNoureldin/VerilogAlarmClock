`timescale 1ns / 1ps

//Rising-edge detector that keeps the output 1 for n clock cycles
module RisingEdgeDetectorExt #(parameter n = 2) (input clk, rst, in, output reg out);
    reg[1:0] shiftReg;
    reg[31:0] count;

    always @(posedge clk) begin
        if (rst) begin 
            shiftReg <= 0;
            count <= 0;
            out <= 0;
        end
        else begin 
            shiftReg <= (shiftReg << 1) + in;
            if (count == n - 1) begin
                count <= 0;
                out <= 0;
            end
            else count <= count + 1;
        
            if (shiftReg == 1) begin
                count <= 0;
                out <= 1;
            end
        end
    end    
endmodule
