`timescale 1ns / 1ps

module RisingEdgeDetector(input clk, rst, w, output z);

  reg[1:0] state, nextState;
  parameter[1:0] A = 2'b00, B = 2'b01, C = 2'b10;
  
  always @(w or state)

    case(state)
      A: if (w==0) nextState = A;
          else nextState = B;
      B: if (w==0) nextState = A;
          else nextState = C;
      C: if (w==0) nextState = A;
          else nextState = C;

      default: nextState = A;
  endcase
  
  always @ (posedge clk or posedge rst) begin
    if(rst) state <= A;
    else state <= nextState;
  end
  
  assign z = (state == B);
endmodule
