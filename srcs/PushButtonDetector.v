`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 08:48:32 PM
// Design Name: 
// Module Name: PushButtonDetector
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
    module PushButtonDetector(input clock, rst, in, output out);
//    wire clock,dout,sout;
    wire dout, sout;
//    ClockDivider #(500000) d (clk,rst,clock);
    Debouncer dd(clock,rst,in,dout);
    Synchronizer dddd(clock,rst,dout,sout);
    RisingEdgeDec ddd(clock, rst, sout, out);
    
    endmodule

//module PushButtonDetector(input clk, rst, in, output out);
//    wire clk_out, db_out, sch_out;
  
//    ClockDivider #(500000) ck(clk, rst, clk_out);  
//    DeBouncer deb(clk_out, rst, in, db_out);
//    Synchronizer syn(clk_out, rst, db_out, sch_out);
//    RisingEdgeDetector rising(clk_out, rst, sch_out, out);  

//endmodule
