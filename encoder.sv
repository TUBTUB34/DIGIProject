// File: endoder.sv
// Description: This module decodes the imput from an endcoder
//              each turn of the encoder pulses ccw or cw four times
// Author: Alex Weir
// Date: 2024-01-24


module encoder ( input logic clk,   //50MHz clodk
                 input logic a,     //a input form encoder
                 input logic b,     //b input from the encoder
                 output logic cw,   //cw output 
                 output logic ccw   // ccw output
);

logic previous_a, previous_b;

always_ff @(posedge clk) begin //decodes the encoders a and b to be cw or ccw pulses
    
    previous_a <= a;
    previous_b <= b;
    if (ccw) ccw <= 0;
    if (cw) cw <= 0;

    if (a && !previous_a && !b) cw <= 1;
    else if (b && !previous_b && a)  cw <= 1;
    else if (!a && previous_a && b)  cw <= 1;
    else if (!b && previous_b && !a) cw <= 1;
    
    else if (!a && previous_a && !b) ccw  <= 1;
    else if (!b && previous_b && a) ccw <= 1;
    else if (b && !previous_b && !a) ccw <= 1;
    else if (a && !previous_a && b)  ccw <= 1;

end


endmodule