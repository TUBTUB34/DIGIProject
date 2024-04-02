// File: colorchoice.sv
// Description: This module sends receives a joystick signal from the adc and will ouput a color signal which will increment the color
//              output variable up or down depending on the joystick postion. The joystick must return to the center position for it to reset.
// Author: Alex Weir & Braedon Linforth
// Date: 2024-03-08

module colorchoice (
                    input logic clk, reset_n, // clock and reset
                    input logic [11:0] colorjoystick,
                    output logic [3:0] color
                    );

    
    logic up = 0, down = 0;
        
    always_ff @(posedge clk) begin
       
        if (~reset_n) color <= '0;
        else begin
            if(colorjoystick > 12'h800 && up) begin //increments the color by 1
                up <= 0;
                color <= color + 1;
            end
            //logic to ensure the color variable doesnt increments until joystick returns to center position
            else if (colorjoystick <= 12'h800 && colorjoystick > 12'h300) begin 
                up <= 1;
                down <=1;
            end
            else if(colorjoystick <= 12'h300 && down) begin //decrements the color by 1
                down <= 0;
                color <= color - 1;
            end

        end
    end
    
endmodule