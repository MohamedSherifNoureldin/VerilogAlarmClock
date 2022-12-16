`timescale 1ns / 1ps

module PushButtonDetector(input clk, rst, in, output out);
    wire debouncer_out, sync_out;
    DeBouncer deb(clk, rst, in, debouncer_out);
    Synchronizer syn(clk, rst, debouncer_out, sync_out);
    RisingEdgeDetector rising(clk, rst, sync_out, out);  
endmodule
