`timescale 1ns / 1ps

module PushButtonDetector(input clk, rst, in, output out);
    wire clk_out, db_out, sch_out;
    DeBouncer deb(clk, rst, in, db_out);
    Synchronizer syn(clk, rst, db_out, sch_out);
    RisingEdgeDetector rising(clk, rst, sch_out, out);  
endmodule
