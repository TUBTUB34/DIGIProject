
module showPattern #(
                        parameter LEDPERIOD = 62,
                        parameter RESTPERIOD = 2500,
                        parameter T0H = 20,
                        parameter T0L = 42,
                        parameter T1H = 40,
                        parameter T1L = 22,
                        parameter PCOL = 16,
                        parameter PROW = 15)
                    (
                    input logic clk,
                    input logic on,
                    input logic [3:0] red,
						  input logic [3:0] blue,
						  input logic [3:0] green, // desired color
                    input logic [15:0][14:0] pattern,//will need to change depending on cols, and led's per col
                    output logic data);

    logic [23:0] colorMask; //24 bit mask to choose color. 
                                                                                  //0000 0001 0000 0001 0000 0001 = white lowest brightness
    logic [7:0] count = LEDPERIOD; //period of a single color, 20ns * 62 = 1.24us period
    logic [11:0] rest = RESTPERIOD; //period of the rest period for ending comminication, 20ns * 2500 = 50us
    logic [4:0] pattern_row = 15; //change to match pattern
    logic [8:0] color_index= 24;
    logic [4:0] pattern_column = 16; //change to match pattern
    logic start_trans = 0;


    assign colorMask = {4'h0, green, 4'h0, red, 4'h0, blue};
    always_ff @(posedge clk) begin
        if (on && !start_trans)
            start_trans <= 1 ;
        else if(start_trans) begin
            if((pattern_column )) begin //logic for if the pattern column is finish cycling, as it it goes from 5 down to 0
                if ((pattern_row)) begin //logic for if the pattern row is finish cycling, as it it goes from 5 down to 0
                    if(pattern[pattern_column - 1][pattern_row - 1]) begin //checks to see if the individual LED should be on or off
                        if(count && color_index) begin // starts the clock, which is 62 long, so 62 * 20ns clock = 1.24 us period
                            count <= count - 1;
                            if (count >= T0L && !colorMask[color_index - 1]) //logic for sending high for logic 0 of the color mask
                                data <= 1;
                            else if (!colorMask[color_index - 1])//logic for sending low for logic 0 of the color mask
                                data <= 0;
                            else if (count >= T0H )//&& colorMask [color_index - 1])//logic for sending high for logic 1 of the color mask
                                data <= 1;
                            else if (colorMask[color_index - 1]) //logic for sending low for logic 1 of the color mask
                                data <= 0;
                            else 
                                data <= 0;
                        end 
                        else if (!count && color_index) begin  //checks to see that there is still colors to cycle through of the 24 index
                            color_index <= color_index -1;
                            count <= LEDPERIOD;
                        end
                        else begin // resets count, color index and changes pattern_row down by 1
                            count <= LEDPERIOD;
                            color_index <= 24;
                            pattern_row <= pattern_row -1;
                        end 
                    end 
                    else begin //other condition if the pattern LED should be low, to set all leds colors to low, same logic as above
                        if(count && color_index) begin
                            count <= count - 1;
                            if (count >= T0L )
                                data <= 1;
                            else 
                                data <= 0;
                        end 
                        else if (!count && color_index) begin 
                            color_index <= color_index -1;
                            count <= LEDPERIOD;
                        end
                        else begin
                            count <= LEDPERIOD;
                            color_index <= 24;
                            pattern_row <= pattern_row -1;
                        end 
                    end

                end
                else begin // if pattern_row reaches 0, this resets it and deincrements pattern_column by 1
                    pattern_row <= PROW;
                    pattern_column <= pattern_column - 1;
                end
            end
            else if (rest) begin //rest condition of 50us so the program knows its the end of data transmission
                rest <= rest - 1;
                data <= 0;
            end
            else begin
                rest <= RESTPERIOD;
                pattern_column <= PCOL;
                start_trans <= 0;
            end 
        end 
        else begin
            data <= 0;
        end


end

endmodule