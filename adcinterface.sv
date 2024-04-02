// File: adcinterface.sv
// Description: This module sneds one pulse on the CONVST, the proceeds
//              to read the adc output for the precedind 12 clock cycles.
//              also on the first six clock cycles it sends what channal it
//              would like to communicate with.
// Author: Alex Weir
// Date: 2024-02-01


module adcinterface(
                    input logic clk, reset_n, // clock and reset
                    output logic [11:0] result, // ADC result
                    output logic [11:0] colorjoystick,
                    // ltc2308 signals
                    output logic ADC_CONVST, ADC_SCK, ADC_SDI,
                    input logic ADC_SDO );

logic [11:0] result_t, result_r;    //temporary result
logic [2:0] state = 0;
logic [4:0] count = 0; 
logic [10:0] chan_count = 0;
logic clockstate = 0;
logic [2:0] chan = 5;
logic [7:0][5:0] adc_II = {6'b011111,6'b011101,6'b010111,6'b010101,6'b011011,6'b011001,6'b010011,6'b010001};// all the words to send the adc to pick what channel. 
                          
assign ADC_SCK = (clockstate) ? clk : 1'b0;    // setting the acd clock to the clock state. 

always_ff @(negedge clk) begin
    chan_count <= chan_count + 1;
    if (chan_count >= 18) begin 
        if (chan == 5) chan <= 1;
        else if (chan == 1) chan <= 5;
        chan_count <= 0;
    end

end

always_ff @(posedge ADC_SCK)begin      // assigning the result the SDO bit on each clock cycle
    case(count)
        1 : result_t[11] <= ADC_SDO;
        2 : result_t[10] <= ADC_SDO;
        3 : result_t[9] <= ADC_SDO;
        4 : result_t[8] <= ADC_SDO;
        5 : result_t[7] <= ADC_SDO;
        6 : result_t[6] <= ADC_SDO;
        7 : result_t[5] <= ADC_SDO;
        8 : result_t[4] <= ADC_SDO;
        9 : result_t[3] <= ADC_SDO;
        10 : result_t[2] <= ADC_SDO;
        11 : result_t[1] <= ADC_SDO;
        12 : result_t[0] <= ADC_SDO;
    endcase
end
//Sending the word to pick what channel
always_ff @(negedge clk) begin       
    if (state == 3 && count < 6) ADC_SDI <= adc_II[chan][count];
    else ADC_SDI <= 0;
end
                                // the state machine to cycle threw the states. 
always_ff @(negedge clk) begin
    if (~reset_n) begin
        result <= '0;
        state <= '0;
        ADC_CONVST <= 0;
    end 
    if (state == 0) begin
        ADC_CONVST <= 1;
        state <= 1;
    end
    else if (state == 1) begin
        ADC_CONVST <= 0;
        state <= 2;
    end
    else if (state == 2) state <= 3;
    else if (state == 3) begin
        clockstate <= 1;
        count <= count + 1;
        if (count == 12) begin 
            clockstate <= 0;
            state <= 4;
            result_r <= result_t;
            if (chan == 5) begin
                if (result_r < 'h600 ) result <= 'h000;
                else if (result_r < 'h610 && result_r >= 'h600) result <= 'h001;
                else if (result_r < 'h620 && result_r >= 'h610) result <= 'h002;
                else if (result_r < 'h630 && result_r >= 'h620) result <= 'h003;
                else if (result_r < 'h640 && result_r >= 'h630) result <= 'h004;
                else if (result_r < 'h650 && result_r >= 'h640) result <= 'h005;
                else if (result_r < 'h660 && result_r >= 'h650) result <= 'h006;
                else if (result_r < 'h670 && result_r >= 'h660) result <= 'h007;
                else if (result_r < 'h680 && result_r >= 'h670) result <= 'h008;
                else if (result_r < 'h690 && result_r >= 'h680) result <= 'h009;
                else if (result_r < 'h700 && result_r >= 'h690) result <= 'h00a;
                else if (result_r < 'h710 && result_r >= 'h700) result <= 'h00b;
                else if (result_r < 'h720 && result_r >= 'h710) result <= 'h00c;
                else if (result_r < 'h730 && result_r >= 'h720) result <= 'h00d;
                else if (result_r >= 'h730 ) result <= 'h00e;
            end
            else begin
                 colorjoystick <= result_t;
            end
            count <= 0;
        end
    end
    else if (state == 4) state <= 0;
end

endmodule