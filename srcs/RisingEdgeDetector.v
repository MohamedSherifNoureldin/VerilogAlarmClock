`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 08:47:04 PM
// Design Name: 
// Module Name: RisingEdgeDetector
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
module RisingEdgeDec(input clk, reset, w, output z);
reg [1:0] state, nextState;
parameter [1:0] A=2'b00, B=2'b01, C=2'b10;

always @ (w,state)
case (state)
A: if (w==0) begin 
nextState = A;
end
 else begin 
 nextState = B;
 end
B: if (w==0) begin 
nextState = A;
end
else begin 
nextState = C;
end
C: if (w==0) begin
nextState = A;
end
 else begin
 nextState = C;
end
default: nextState = A;
endcase


always @ (posedge clk or posedge reset) begin
if(reset) state <= A;
else state <= nextState;
end

assign z = (state == B);

endmodule

//module RisingEdgeDetector(input clk, reset, w, output z);
//  reg[1:0] state, nextState;
//  parameter[1:0] A = 2'b00, B = 2'b01, C = 2'b10;
  
//  always @(w or state)   //or
//    case(state)
//      A: if (w==0) nextState = A;
//          else nextState = B;
//      B: if (w==0) nextState = A;
//          else nextState = C;
//      C: if (w==0) nextState = A;
//          else nextState = C;
//      default: nextState = A;
//  endcase
  
//  always @ (posedge clk or posedge reset) begin
//    if(reset) state <= A;
//    else state <= nextState;
//  end
  
//  assign z = (state == B);
//endmodule
