`timescale 1ns / 1ps

module SegmentDisplay(input[3:0] x, input[1:0] sw, input dec, input enable, output reg[0:6] segment, output reg[3:0] anodes, output reg decimal_point);  
    
    always @ (x, sw, enable, dec) 
    begin
        if (sw == 2'b10) decimal_point = dec;
        else decimal_point = 1;
    
        if(!enable) anodes = 4'b1111;
        else if (sw == 2'b00) anodes = 4'b1110;
        else if (sw == 2'b01) anodes = 4'b1101;
        else if (sw == 2'b10) anodes = 4'b1011;
        else anodes = 4'b0111;
    
        case(x)
            0: segment = 7'b0000001;
            1: segment = 7'b1001111;
            2: segment = 7'b0010010;
            3: segment = 7'b0000110;
            4: segment = 7'b1001100;
            5: segment = 7'b0100100;
            6: segment = 7'b0100000;
            7: segment = 7'b0001111;
            8: segment = 7'b0000000;
            9: segment = 7'b0000100;
            default: segment = 7'b0110000;  
        endcase
    end

endmodule
