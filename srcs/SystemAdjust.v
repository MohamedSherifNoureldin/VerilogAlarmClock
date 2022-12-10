`timescale 1ns / 1ps

module SystemAdjust( input clk, reset, enable, input[4:0] button_out, 
                     input[4:0] input_time_hours, input_alarm_hours, input[5:0] input_time_minutes, input_alarm_minutes,
                     output[3:0] adj_minutes_units, adj_hours_units, output[2:0] adj_minutes_tens, adj_hours_tens, output[1:0] adjusted,
                     output[4:0] time_hours_out, alarm_hours_out, output[5:0] time_minutes_out, alarm_minutes_out, output reg[3:0] LED);   
       
    wire[3:0] clk_time[3:0], alarm_time[3:0]; // 0: min_units, 1: min_tens, 2: hour_units, 3: hour_tens
    reg[3:0] adj_time[3:0];
    reg rst_time, rst_alarm;

    // Init states
    // States for moving right and left
    reg[2:0] state, nextstate;
    parameter[2:0] Initial = 3'b000, TimeHours = 3'b001, TimeMin = 3'b010, AlarmHours = 3'b011, AlarmMin = 3'b100;
    initial nextstate = Initial; 
    
    integer i;
    always @(state, button_out) begin
        case(state)
            Initial: nextstate = TimeHours;
            TimeHours:
                begin
                    LED = 4'b1000; 
                    if(button_out[2]) nextstate = TimeMin; // move right
                    else if(button_out[1]) nextstate = AlarmMin; // move left
                    else nextstate = TimeHours; // don't move
                end   
            TimeMin:
                begin
                    LED = 4'b0100; 
                    if(button_out[2]) nextstate = AlarmHours; // move right
                    else if(button_out[1]) nextstate = TimeHours; // move left
                    else nextstate = TimeMin; // don't move
                end
            AlarmHours:
                begin
                    LED = 4'b0010;
                    if(button_out[2]) nextstate = AlarmMin; // move right
                    else if(button_out[1]) nextstate = TimeMin; // move left
                    else nextstate = AlarmHours; // don't move
                end
            AlarmMin:
                begin
                    LED = 4'b0001;
                    if(button_out[2]) nextstate = TimeHours; // move right
                    else if(button_out[1]) nextstate = AlarmHours; // move left
                    else nextstate = AlarmMin; // don't move
                end
            default: nextstate = TimeHours;
        endcase
        
       if (state == TimeHours || state == TimeMin) 
            for (i = 0; i < 4; i = i + 1)
                adj_time[i] = clk_time[i];
        else if (state == AlarmHours || state == AlarmMin) 
            for (i = 0; i < 4; i = i + 1)
                adj_time[i] = alarm_time[i];
    end

    always @(posedge clk, posedge reset) begin
        if(reset || button_out[0]) state <= Initial;
        else state <= nextstate;    
    end
    
    // reset when reaching max of 23 hrs 59 minutes
    always @(posedge clk) begin
        if (clk_time[2] == 4 && clk_time[3] == 2) rst_time = 1;
        else rst_time = 0;
        
        if (alarm_time[2] == 4 && alarm_time[3] == 2) rst_alarm = 1;
        else rst_alarm = 0;
    end
    
    // Counters for time of clock
    // minutes digit
    CounterModNUpDown #(4, 10) time_min_mod_10(clk, reset, (state == TimeMin && button_out[3]==1), (state == TimeMin && button_out[4]==1), 
                                              (state == Initial), input_time_minutes%10 , clk_time[0]);
    // minutes tens
    CounterModNUpDown #(3, 6) time_min_mod_6(clk, reset, (state == TimeMin && button_out[3]==1 && clk_time[0] == 9), 
                                            (state == TimeMin && button_out[4]==1 && clk_time[0] == 0), (state == Initial), input_time_minutes/10, clk_time[1]);

    // hours digit
    CounterModNUpDown #(4, 10) time_hour_mod_10(clk, reset | rst_time, (state == TimeHours && button_out[3]==1), 
                                               ((state == TimeHours  && button_out[4]==1) || (state == TimeMin && button_out[4]==1 && clk_time[1] == 0 && clk_time[0] == 0)),
                                               (state == Initial), input_time_hours%10, clk_time[2]);
    // hours tens
    CounterModNUpDown #(3, 3) time_hour_mod_6(clk, reset | rst_time, (state == TimeHours && button_out[3]==1 && clk_time[2] == 9), 
                                             (state == TimeHours && button_out[4]==1 && clk_time[2] == 0), (state == Initial), input_time_hours / 10, clk_time[3]);
    
    // Counters for time of alarm
    // minutes digit
    CounterModNUpDown #(4, 10) alarm_min_mod_10(clk, reset, (state == AlarmMin && button_out[3]==1), (state == AlarmMin && button_out[4]==1), 
                                               (state == Initial), input_alarm_minutes%10 , alarm_time[0]);
    // minutes tens
    CounterModNUpDown #(3, 6) alarm_min_mod_6(clk, reset, (state == AlarmMin && button_out[3]==1 && alarm_time[0] == 9), 
                                             (state == AlarmMin && button_out[4]==1 && alarm_time[0] == 0), (state == Initial), input_alarm_minutes/10, alarm_time[1]);
    
    // hours digt
    CounterModNUpDown #(4, 10) alarm_hour_mod_10(clk, reset | rst_alarm, (state == AlarmHours  && button_out[3]==1), (state == AlarmHours  && button_out[4]==1),
                                                (state == Initial), input_alarm_hours%10, alarm_time[2]);
    // hours tens
    CounterModNUpDown #(3, 3) alarm_hour_mod_6(clk, reset | rst_alarm, (state == AlarmHours && button_out[3]==1 && alarm_time[2] == 9), 
                                              (state == AlarmHours && button_out[4]==1 && alarm_time[2] == 0), (state == Initial), input_alarm_hours/10, alarm_time[3]);
    
    // Output saved values
    assign adj_minutes_units = adj_time[0];
    assign adj_minutes_tens = adj_time[1];
    assign adj_hours_units = adj_time[2];
    assign adj_hours_tens = adj_time[3];
    
    assign time_hours_out = clk_time[3] * 10 + clk_time[2];
    assign time_minutes_out = clk_time[1] * 10 + clk_time[0];
    assign alarm_hours_out = alarm_time[3] * 10 + alarm_time[2];
    assign alarm_minutes_out = alarm_time[1] * 10 + alarm_time[0];
    assign adjusted = {(input_alarm_hours != alarm_hours_out || input_alarm_minutes != alarm_minutes_out), 
                       (input_time_hours != time_hours_out || input_time_minutes != time_minutes_out)};
endmodule
