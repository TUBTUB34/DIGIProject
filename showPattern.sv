// File:showPattern.sv
// Description: This is the comminication module to the LED array in which the micro controller can control the individual LEDs through our own SPI timing protocol
//              
// Author: Alex Weir & Braedon Linforth
// Date: 2024-03-08

module showPattern #(
                        parameter LEDPERIOD = 62,       //period of LED based on data sheet
                        parameter RESTPERIOD = 2500,    //period of rest between each transmission
                        parameter T0H = 20,             //period of high to send a logic 0
                        parameter T0L = 42,             //period of low to send a logic 0
                        parameter T1H = 40,             //period of high to send a logic 1
                        parameter T1L = 22,             //period of low to send a logic 0
                        parameter PCOL = 16,            //number of colmns on the phsyical LED array
                        parameter PROW = 15)            //number of rows on the physical LED array
                    (
                    input logic clk,
                    input logic on,
                    input logic [3:0] red,   //red color logic for LEDs, only controls last 4 bits of the 8 bit red color
				    input logic [3:0] blue,  //blue color logic for LEDs, only controls last 4 bits of the 8 bit blue color
					input logic [3:0] green, //green color logic for LEDs, only controls last 4 bits of the 8 bit green color
                    input logic [15:0][14:0] pattern,//will need to change depending on cols, and led's per col
                    output logic data);

    logic [23:0] colorMask; //24 bit mask to choose color.
    logic [7:0] count = LEDPERIOD; //period of a single color, 20ns * 62 = 1.24us period
    logic [11:0] rest = RESTPERIOD; //period of the rest period for ending comminication, 20ns * 2500 = 50us
    logic [4:0] pattern_row = 15; //change to match pattern of physical LED array
    logic [8:0] color_index= 24; // variable to keep track of which color to toggle on or off
    logic [4:0] pattern_column = 16; //change to match pattern
    logic start_trans = 0;


    assign colorMask = {4'h0, green, 4'h0, red, 4'h0, blue};
    always_ff @(posedge clk) begin
        if (on && !start_trans)
            start_trans <= 1 ;
        else if(start_trans) begin
            if((pattern_column )) begin //logic for if the pattern column is finish cycling, as it it goes from PCOL down to 0
                if ((pattern_row)) begin //logic for if the pattern row is finish cycling, as it it goes from PROW down to 0
                    if(pattern[pattern_column - 1][pattern_row - 1]) begin //checks to see if the individual LED should be on or off
                        if(count && color_index) begin // starts the clock, which is LEDPERIOD long, so LEDPERIOD * 20ns clock = 1.24 us period
                            count <= count - 1;
                            if (count >= T0L && !colorMask[color_index - 1]) //logic for sending high for logic 0 of the color mask based on T0L period
                                data <= 1;
                            else if (!colorMask[color_index - 1])//logic for sending low for logic 0 of the color mask
                                data <= 0;
                            else if (count >= T0H )//logic for sending high for logic 1 of the color mask based on T0H period
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
                    else begin //other condition, if the pattern LED should be off, to set all leds colors to off, same logic as above
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
            else begin //starts the rest period and stops transmission until it is complete
                rest <= RESTPERIOD;
                pattern_column <= PCOL;
                start_trans <= 0;
            end 
        end 
        else begin //default condition if stat_trans is 0 and if the "on" input is 0
            data <= 0;
        end


end

endmodule