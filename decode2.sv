// Description: ELEX 7660 lab1 decode module.  decodes the 
// The led that is supposed to be on an turns on that active low LED.
// Author: Alex Weir
// Date: 2024-01-19
module decode2 ( input logic [1:0] digit,  // led that will be on
                 output logic [3:0] ct );  // active low cathode, till turn on the led.

    //Assgnes the correct LED to the correct active low cathode. 
    always_comb begin
        case (digit)
            0 : ct = 4'b1110 ;
            1 : ct = 4'b1101 ; 
            2 : ct = 4'b1011 ;
            3 : ct = 4'b0111 ;
        endcase
    end
endmodule