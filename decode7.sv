// Description: ELEX 7660 lab1 decode module.  decodes the 
// number input to the correct seven segment display segments.
// Author: Alex Weir
// Date: 2024-01-19

module decode7 ( input logic [3:0] num,      // number between 0 and 15
                 output logic [7:0] leds );  // segmnets of the led to create corresponding number/letter
   
    // assignes correct number to correct segments 
    always_comb begin
        case (num)
                        //PGFEDCBA
            0 : leds = 8'b00111111 ;
            1 : leds = 8'b00000110 ;
            2 : leds = 8'b01011011 ;
            3 : leds = 8'b01001111 ;
            4 : leds = 8'b01100110 ;
            5 : leds = 8'b01101101 ;
            6 : leds = 8'b01111101 ;
            7 : leds = 8'b00000111 ;
            8 : leds = 8'b01111111 ;
            9 : leds = 8'b01100111 ;
            10 : leds = 8'b01110111 ;
            11 : leds = 8'b01111100 ;
            12 : leds = 8'b00111001 ;
            13 : leds = 8'b01011110 ;
            14 : leds = 8'b01111001 ;
            15 : leds = 8'b01110001 ;
            default : leds = 0 ;
        endcase
    end
    
endmodule