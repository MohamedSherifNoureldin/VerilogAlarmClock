`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2022 08:19:49 PM
// Design Name: 
// Module Name: SystemAdjust
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


module SystemAdjust( input clk, reset, enable, input [4:0] button_out, 
                        input [4:0] input_time_hours, input_alarm_hours, input [5:0] input_time_minutes, input_alarm_minutes,
                        output reg [3:0] adj_minutes_units, adj_hours_units, output reg [2:0] adj_minutes_tens, adj_hours_tens,
                        output [1:0] adjusted,
                        output [4:0] time_hours_out, alarm_hours_out, output [5:0] time_minutes_out, alarm_minutes_out, 
                        output reg [3:0] LED);   
    // init states
    // states for moving right and left
    reg[2:0] state, nextstate;
    parameter [2:0] Initial = 3'b000, TimeHours = 3'b001, TimeMin = 3'b010, AlarmHours = 3'b011, AlarmMin = 3'b100;
    initial nextstate = Initial; 
    always @(state, button_out) begin
        case(state)
            Initial:
                begin
                    nextstate = TimeHours;
                end
            TimeHours:
                begin
                    // move right
                    if(button_out[2])
                        nextstate = TimeMin;
                    // move left
                    else if(button_out[1])
                        nextstate = AlarmMin;
                    // don't move
                    else
                        nextstate = TimeHours;
                end
            TimeMin:
                begin
                    // move right
                    if(button_out[2])
                        nextstate = AlarmHours;
                    // move left
                    else if(button_out[1])
                        nextstate = TimeHours;
                    // don't move
                    else
                        nextstate = TimeMin;
                end
            AlarmHours:
                begin
                    // move right
                    if(button_out[2])
                        nextstate = AlarmMin;
                    // move left
                    else if(button_out[1])
                        nextstate = TimeMin;
                    // don't move
                    else
                        nextstate = AlarmHours;
                end
            AlarmMin:
                begin
                    // move right
                    if(button_out[2])
                        nextstate = TimeHours;
                    // move left
                    else if(button_out[1])
                        nextstate = AlarmHours;
                    // don't move
                    else
                        nextstate = AlarmMin;
                end
            default: nextstate = TimeHours;
        endcase
    end
    
    always @(posedge clk, posedge reset) begin
        if(reset)
            state <= Initial;
        else
            state <= nextstate;    
    end
    
    // reset when reaching max of 23 hrs 59 minutes
    reg reset_counter;
    always @(posedge clk) begin
        if (time_hours_units == 4 && time_hours_tens == 2) reset_counter = 1;
        else reset_counter = 0;
    end
    
    // counters for time of clock
    wire [3:0] time_minutes_units, time_hours_units;
    wire [2:0] time_minutes_tens, time_hours_tens;

    // minutes digit
    // input clk, reset, up, down, load, input[x-1:0] data, output reg [x-1:0] count
    CounterModNUpDown #(4, 10) time_min_mod_10(clk, reset, (state == TimeMin && button_out[3]==1), (state == TimeMin && button_out[4]==1), (state == Initial), input_time_minutes%10 , time_minutes_units);
    // minutes tens
    CounterModNUpDown #(3, 6) time_min_mod_6(clk, reset, (state == TimeMin && button_out[3]==1 && time_minutes_units == 9), (state == TimeMin && button_out[4]==1 && time_minutes_units == 0), (state == Initial), input_time_minutes/10, time_minutes_tens);
    
    // hours digt
    CounterModNUpDown #(4, 10) time_hour_mod_10(clk, reset | reset_counter, (state == TimeHours  && button_out[3]==1), ((state == TimeHours  && button_out[4]==1) || (state == TimeMin && button_out[4]==1 && time_minutes_tens==0 && time_minutes_units == 0)),(state == Initial), input_time_hours%10, time_hours_units);
    // hours tens
    CounterModNUpDown #(3, 3) time_hour_mod_6(clk, reset | reset_counter, (state == TimeHours && button_out[3]==1 && time_hours_units == 9), (state == TimeHours && button_out[4]==1 && time_hours_units == 0), (state == Initial), input_time_hours / 10, time_hours_tens);
    
    
    // counters for time of alarm
    wire [3:0] alarm_minutes_units, alarm_hours_units;
    wire [2:0] alarm_minutes_tens, alarm_hours_tens;
    // minutes digit
    CounterModNUpDown #(4, 10) alarm_min_mod_10(clk, reset, (state == AlarmMin && button_out[3]==1), (state == AlarmMin && button_out[4]==1), (state == Initial), input_alarm_minutes%10 , alarm_minutes_units);
    // minutes tens
    CounterModNUpDown #(3, 6) alarm_min_mod_6(clk, reset, (state == AlarmMin && button_out[3]==1 && alarm_minutes_units == 9), (state == AlarmMin && button_out[4]==1 && alarm_minutes_units == 0), (state == Initial), input_alarm_minutes/10, alarm_minutes_tens);
    
    // hours digt
    CounterModNUpDown #(4, 10) alarm_hour_mod_10(clk, reset | reset_counter, (state == AlarmHours  && button_out[3]==1), (state == AlarmHours  && button_out[4]==1),(state == Initial), input_alarm_hours%10, alarm_hours_units);
    // hours tens
    CounterModNUpDown #(3, 3) alarm_hour_mod_6(clk, reset | reset_counter, (state == AlarmHours && button_out[3]==1 && alarm_hours_units == 9), (state == AlarmHours && button_out[4]==1 && alarm_hours_units == 0), (state == Initial), input_alarm_hours/10, alarm_hours_tens);
    
    // selecting output to be displayed
    reg [3:0] adj_minutes_units, adj_hours_units;
    reg [2:0] adj_minutes_tens, adj_hours_tens;
    always @(state) begin 
        case (state) 
            TimeHours: 
                begin 
                    LED = 4'b1000; 
                    adj_minutes_units = time_minutes_units;
                    adj_minutes_tens = time_minutes_tens;
                    adj_hours_units = time_hours_units;
                    adj_hours_tens = time_hours_tens;
                end
            TimeMin: 
            begin
                LED = 4'b0100;
                adj_minutes_units = time_minutes_units;
                adj_minutes_tens = time_minutes_tens;
                adj_hours_units = time_hours_units;
                adj_hours_tens = time_hours_tens;
            end
            AlarmHours:
            begin
                LED = 4'b0010;
                adj_minutes_units = alarm_minutes_units;
                adj_minutes_tens = alarm_minutes_tens;
                adj_hours_units = alarm_hours_units;
                adj_hours_tens = alarm_hours_tens;
            end
            AlarmMin:
            begin 
                LED = 4'b0001;
                adj_minutes_units = alarm_minutes_units;
                adj_minutes_tens = alarm_minutes_tens;
                adj_hours_units = alarm_hours_units;
                adj_hours_tens = alarm_hours_tens;
            end
        endcase    
    end
    
    // output saved values
    assign time_hours_out = time_hours_tens*10 + time_hours_units;
    assign time_minutes_out = time_minutes_tens*10 + time_minutes_units;
    assign alarm_hours_out = alarm_hours_tens*10 + alarm_hours_units;
    assign alarm_minutes_out = alarm_minutes_tens*10 + alarm_minutes_units;
    assign adjusted = {(input_alarm_hours != alarm_hours_out || input_alarm_minutes != alarm_minutes_out), (input_time_hours != time_hours_out || input_time_minutes != time_minutes_out)};
endmodule
