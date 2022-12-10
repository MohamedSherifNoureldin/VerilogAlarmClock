`timescale 1ns / 1ps

module System(input clk, rst, enable, input[4:0] button_in, output[0:6] segment, output[3:0] anodes, output decimal_point, output [3:0] LEDs, output mode_led, output alarm_led);
    reg load, mode, alarm, alarm_flag; // 0 for clock mode, 1 for adjust mode
    reg[3:0] num_displayed;
    reg[4:0] alarm_hours, clk_load_time_hours;
    reg[5:0] alarm_minutes, clk_load_time_minutes; 
    wire[4:0] adjusted_alarm_hours, adjusted_time_hours, button_out; 
    wire[5:0] adjusted_alarm_minutes, adjusted_time_minutes;
    wire[1:0] adjusted, sw;
    wire[3:0] adj_leds;
    wire clk_load_reset, clk_out, clk_sec, load_out;
    
    // 0: min_units, 1: min_tens, 2: hour_units, 3: hour_tens
    wire[3:0] clk_time[3:0], adj_time[3:0]; 
    reg[3:0] min_display[3:0];
    
    // Push button detectors
    genvar i;
    generate for (i = 0; i < 5; i = i + 1) begin: block1
        PushButtonDetector btn(clk, rst, button_in[i], button_out[i]);
    end endgenerate
    
    // ----------- Clock Mode -----------
    // Controlling the decimal point 
    ClockDivider #(50000000) ckDecimal(clk, rst, clk_sec);
    // Controlling min and hours digits 
    SystemCounter counter(clk, rst, enable, load_out, clk_load_time_minutes, clk_load_time_hours, clk_time[0], clk_time[2], clk_time[1], clk_time[3]);
    
    // ----------- Adjust Mode -----------
    SystemAdjust adjust(clk, rst, enable, button_out,
                        clk_time[3] * 10 + clk_time[2], alarm_hours, clk_time[1] * 10 + clk_time[0], alarm_minutes,
                        adj_time[0], adj_time[2], adj_time[1], adj_time[3], adjusted, 
                        adjusted_time_hours, adjusted_alarm_hours, adjusted_time_minutes, adjusted_alarm_minutes, adj_leds);
                        
    // Display switch counter
    SegmentDisplay seg(num_displayed, sw, clk_sec, enable, segment, anodes, decimal_point);
    ClockDivider #(250000) ck(clk, rst, clk_out);
    CounterModN #(2, 4) cntModN(clk_out, rst, enable, 0, 0, sw);
    integer j;
    always @(posedge clk) begin
        // Initializing the variables
        if (rst) 
            {load, mode, alarm_hours, alarm_minutes} <= 0;         
        else begin
            if (mode) 
                for (j = 0; j < 4; j = j + 1)
                    min_display[j] = adj_time[j];
            else 
                for (j = 0; j < 4; j = j + 1)
                    min_display[j] = clk_time[j];
            
            num_displayed = min_display[sw];
            
            if(button_out[0]) begin
                mode <= ~mode;
                if(mode) begin
                    if(adjusted[0]) 
                        {clk_load_time_minutes, clk_load_time_hours} <= {adjusted_time_minutes, adjusted_time_hours};
                    if(adjusted[1]) 
                        {alarm_minutes, alarm_hours} <= {adjusted_alarm_minutes, adjusted_alarm_hours};
                end
            end        
        end
    end
    
    RisingEdgeDetectorExt #(100000000) rising1(clk, rst, button_out[0] && mode && adjusted[0], load_out);  
    
    always @(posedge clk_sec) begin
        if (button_out) alarm_flag <= 0;
        else if (mode == 0 && clk_time[1] * 10 + clk_time[0] == alarm_minutes && clk_time[3] * 10 + clk_time[2] == alarm_hours) 
            alarm_flag <= 1;    
        else alarm_flag <= 0;  
          
        alarm <= ~alarm;
    end

    assign LEDs = (mode == 0) ? 0 : adj_leds;
    assign mode_led = mode;
    assign alarm_led = (alarm_flag && alarm);
endmodule
