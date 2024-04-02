module colorchoice (
                    input logic clk, // clock and reset
                    input logic [11:0] colorjoystick,
                    output logic [3:0] color
                    );

    logic [24:0] count = 0;
    logic up = 0, down = 0;
        
    always_ff @(posedge clk) begin
        //count <= count + 1;
        // if (count >= 2000000) begin
        if (colorjoystick > 12'h750) up = 1;
        else if (colorjoystick < 12'h500) down = 1;
            //count <= 0;
        //end

        if (up ||  down) begin 
            count <= count + 1;
            // up = 0;
            // color <= color + 1;
        end
        if (up && count >= 5000000) begin
            up = 0;
            color <= color + 1;
            count <= 0;
        end
        if (down && count >= 5000000) begin
            down = 0;
            color <= color - 1;
            count <= 0;
        end
    end
    
endmodule