`timescale 1ns / 1ps

module System(input clk, reset, enable, input[4:0] button_in, output[0:6] segment, output[3:0] anodes, output decimal_point, output [3:0] LEDs, output mode_led);
    wire[1:0] sw;
    reg mode; // 0 for clock mode, 1 for adjust mode
    reg load;
    wire clk_out, clk_sec;
    wire[4:0] button_out;
    reg[3:0] num_displayed;
    reg [5:0] alarm_minutes;
    wire [5:0] adjusted_alarm_minutes;
    wire [5:0] adjusted_alarm_minutes;
    reg [4:0] alarm_hours;
    wire [4:0] adjusted_alarm_hours;
    reg [3:0] min_units, hour_units;
    wire [3:0] adj_hour_units,adj_min_units,clk_min_units, clk_hour_units;
    reg [2:0] min_tens, hour_tens;
    wire[2:0] adj_min_tens, adj_hour_tens,clk_min_tens, clk_hour_tens;
    wire [1:0] adjusted;
    wire [3:0] adj_leds;
    
    reg [4:0] clk_load_time_hours;
    wire [4:0] adjusted_time_hours; 
    reg [5:0] clk_load_time_minutes; 
    wire [5:0] adjusted_time_minutes;
    
    initial mode = 0;
        
    // init alarm with zeros
    initial alarm_hours = 0;
    initial alarm_minutes = 0;
    
    // push button detectors
    PushButtonDetector center_button(clk, reset, button_in[0], button_out[0]);
    PushButtonDetector left_button(clk, reset, button_in[1], button_out[1]);
    PushButtonDetector right_button(clk, reset, button_in[2], button_out[2]);
    PushButtonDetector up_button(clk, reset, button_in[3], button_out[3]);
    PushButtonDetector down_button(clk, reset, button_in[4], button_out[4]);

    // Clock Mode
    // Controlling the decimal point 
    ClockDivider #(50000000) ckDecimal(clk, reset, clk_sec);
    // Controlling min and hours digits 
    SystemCounter counter(clk, reset, enable, load, clk_load_time_minutes, clk_load_time_hours, clk_min_units, clk_hour_units, clk_min_tens, clk_hour_tens);
    
    // Adjust Mode
    SystemAdjust adjust(clk, reset, enable, button_out,
                        clk_hour_tens*10 + clk_hour_units, alarm_hours, clk_min_tens*10 + clk_min_units, alarm_minutes,
                        adj_min_units, adj_hour_units, adj_min_tens, adj_hour_tens,
                        adjusted, 
                        adjusted_time_hours, adjusted_alarm_hours, adjusted_time_minutes, adjusted_alarm_minutes, adj_leds);
                        
    // display switch counter
    SegmentDisplay seg(num_displayed, sw, clk_sec, enable, segment, anodes, decimal_point);
    ClockDivider #(250000) ck(clk, reset, clk_out);
    CounterModN #(2, 4) cntModN(clk_out, reset, enable, 0, 0, sw);
    always @(posedge clk) begin
        if(mode == 1) begin
            min_units = adj_min_units;
            min_tens = adj_min_tens;
            hour_units = adj_hour_units;
            hour_tens = adj_hour_tens;
        end
        else if(mode == 0) begin        
            min_units = clk_min_units;
            min_tens = clk_min_tens;
            hour_units = clk_hour_units;
            hour_tens = clk_hour_tens;            
        end
        
        case(sw) 
            2'b00: num_displayed = min_units;
            2'b01: num_displayed = min_tens;
            2'b10: num_displayed = hour_units;
            2'b11: num_displayed = hour_tens;
        endcase
        
        if(button_out[0] == 1 && mode==1 && adjusted[0] == 1) load = 1;
        
        if(button_out[0] == 1) begin
            if(mode==1) begin
                if(adjusted[0] == 1) begin
                    clk_load_time_minutes = adjusted_time_minutes;
                    clk_load_time_hours = adjusted_time_hours;
                end
                if(adjusted[1] == 1) begin
                    alarm_minutes = adjusted_alarm_minutes;
                    alarm_hours = adjusted_alarm_hours;
                end
            end
            mode = ~mode;
        end
    end
    
    wire load_reset_clk;
    ClockDivider #(10000000) ckLoad(clk, reset, load_reset_clk);
    always @(posedge load_reset_clk) begin
        if(load)
            load = 0;
    end
    
    assign LEDs = (mode == 0) ? 0 : adj_leds;
    assign mode_led = mode;
endmodule
