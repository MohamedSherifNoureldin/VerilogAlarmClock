`timescale 1ns / 1ps

module SystemCounter(input clk, reset, enable, load, input [5:0] time_minutes, input [4:0] time_hours, output [3:0] min_units, hour_units, output [2:0] min_tens, hour_tens);
    wire clk_out; // we can ignore it as it is a one bit wire
    wire [3:0] sec_units;
    wire [2:0] sec_tens;
    reg reset_counter;
    
    ClockDivider ck(clk, reset, clk_out);
    always @(posedge clk_out) begin
        if (sec_units == 9 && sec_tens == 5 && min_units == 9 && min_tens == 5 && hour_units == 3 && hour_tens == 2) reset_counter = 1;
        else reset_counter = 0;
    end

    CounterModN #(4, 10) sec_mod_10(clk_out, reset | reset_counter, enable, 0, 0, sec_units);
    CounterModN #(3, 6) sec_mod_6(clk_out, reset | reset_counter, sec_units == 9, 0, 0, sec_tens);
        
    CounterModN #(4, 10) min_mod_10(clk_out, reset | reset_counter, (sec_units == 9 && sec_tens == 5), load, time_minutes % 10 ,min_units);
    CounterModN #(3, 6) min_mod_6(clk_out, reset | reset_counter, (sec_units == 9 && sec_tens == 5 && min_units == 9), load, time_minutes / 10, min_tens);
    
    CounterModN #(4, 10) hour_mod_10(clk_out, reset | reset_counter, (sec_units == 9 && sec_tens == 5 && min_units == 9 && min_tens == 5), load, time_hours % 10, hour_units);
    CounterModN #(3, 3) hour_mod_6(clk_out, reset | reset_counter, (sec_units == 9 && sec_tens == 5 && min_units == 9 && min_tens == 5 && hour_units == 9), load, time_hours / 10, hour_tens);
endmodule