// File: end2cholor.sv
// Description: This module takes the encouder pulses and counts up once every four cycles,
//              then depending on what the count is, outputs the appropriate color brightness
// Author: Alex Weir & Braedon Linforth
// Date: 2024-03-08


module enc2color
        ( input logic cw, ccw, // outputs from lab 3 encoder module
          output logic [3:0] color, // desired color
          input logic reset_n, clk); // reset and clock

    logic [3:0] count = 0;
    logic [3:0] counter = 4;
    logic up = 0, down = 0;

    always_ff @(posedge clk) begin 
        
        if (!reset_n) count <= 0;
        //cw or ccw pulse increments or decrements the counter
        if (cw || ccw) begin
            if (cw) counter <= counter + 1;
            else counter <= counter - 1;
            end

        //if the counter goes up by 4, set up flag.
        if (counter >= 8) begin
            up <= 1;
            counter <= 4;
        end
        //if the counter goes down by 4, set down flag.
        else if (counter <= 0) begin
            down <= 1;
            counter <= 4;
        end

        // if up or down flag, increment or decrement counter
        if (up) begin
            up <= 0;
            if (count >= 16) count <= 0;
            else 
            count <= count + 1;
        end 
        else if (down) begin
            down <= 0;
            if (count < 0) count <= 15;
            else 
            count <= count - 1;
        end
    end
    

    always_ff @(posedge clk) begin     // picks the appropriate color channel which effects the brightness
        
        case(count)
            0: color <= 0; 
            1: color <= 1; 
            2: color <= 2; 
            3: color <= 3; 
            4: color <= 4;
            5: color <= 5;
            6: color <= 6;
            7: color <= 7;
            8: color <= 8;
            9: color <= 9;
            10: color <= 'ha;
            11: color <= 'hb;
            12: color <= 'hc;
            13: color <= 'hd;
            14: color <= 'he;
            15: color <= 'hf;
            default: color <= 0;

        endcase
    end

endmodule