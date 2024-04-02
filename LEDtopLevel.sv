// File:LEDtopLevel.sv
// Description: This is the top level module to record the values from a tiva booster pack microphone and to then output the levels of that microphone to an LED array.
//              
// Author: Alex Weir & Braedon Linforth
// Date: 2024-03-08


module LEDtopLevel ( input logic CLOCK_50,       // 50 MHz clock
              input logic s1,
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
              input logic enc1_a, enc1_b, //Encoder 1 pins
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
              input logic enc2_a, enc2_b, //Encoder 1 pins
              output logic ADC_CONVST, ADC_SCK, ADC_SDI,
              output logic GPIO_0[0], //output to our LED array for comminication
              input logic ADC_SDO ,
              output logic [7:0] leds,
              output logic [3:0] ct,
              output logic red, green, blue // RGB LED signals
              ) ;

  logic [15:0][14:0] pattern;  //will need to change depending on cols, and led's per col
  logic [1:0] digit; 
  logic [3:0] disp_digit;  // current digit of count to display
  logic [16:0] clk_div_count; // count used to divide clock 
  logic [11:0] result; // ADC result
  logic [11:0] colorjoystick; // ADC result of the joystick
  logic  set; //used to divide the 50Mhz 
  logic [3:0] red_choice = 0; //variable for the red color of each LED 
  logic [3:0] green_choice = 0; //variable for the red color of each LED 
  logic [3:0] blue_choice = 0;  //variable for the red color of each LED 
  logic [24:0] setcount = 0 ; //count to control the "set" variable
  logic [24:0] speed = 2000000; //the period at which the "set" varibale will be on for 1 clock pulse
  logic [7:0] enc_count; // count used to track encoder movement and to display
  logic enc1_cw, enc1_ccw;  // encoder module outputs
  logic enc2_cw, enc2_ccw;  // encoder module outputs

  decode2 decode2_0 (.digit,.ct) ;
  decode7 decode7_0 (.num(disp_digit),.leds) ;
  encoder encoder_1 (.clk(CLOCK_50), .a(enc1_a), .b(enc1_b), .cw(enc1_cw), .ccw(enc1_ccw));
  enc2color enc2color_1 (.clk(CLOCK_50), .cw(enc1_cw), .ccw(enc1_ccw), .color(red_choice), .reset_n(s1));
  encoder encoder_2 (.clk(CLOCK_50), .a(enc2_a), .b(enc2_b), .cw(enc2_cw), .ccw(enc2_ccw));
  enc2color enc2color_2 (.clk(CLOCK_50), .cw(enc2_cw), .ccw(enc2_ccw), .color(blue_choice), .reset_n(s1));
  adcinterface adcinterface (.clk(clk_div_count[15]), .reset_n(s1), .ADC_CONVST, .ADC_SCK, .ADC_SDI, .ADC_SDO, .colorjoystick(colorjoystick), .result);
  updatePattern updatePattern (.clk(CLOCK_50), .reset_n(s1), .set(set), .result, .pattern);
  colorchoice colorchoice (.clk(CLOCK_50), .colorjoystick(colorjoystick), .color(green_choice), .reset_n(s1));
  showPattern showPattern (.clk(CLOCK_50), .red(red_choice), .blue(blue_choice), .green(green_choice), .pattern, .data(GPIO_0[0]), .on(set));


  always_ff @(posedge CLOCK_50) begin

    clk_div_count <= clk_div_count + 1'b1 ;

    //controls the speed at which we send data to the LED array panel, sending one clock pulse ever "speed" variable
    setcount <= setcount + 1'b1;
    if (setcount > speed) begin
      set <= 1;
      setcount <=0;
    end
    else if(set) set <= 0;
   end


    // assign the top two bits of count to select digit to display
  assign digit = clk_div_count[15:14]; 


  //displayes varius paratemers to the 7-segment display
  always_comb begin
    case (digit)
        2'b00: disp_digit = blue_choice; //displays the brightness level from 0-F of the blue color
        2'b01: disp_digit = green_choice; //displays the brightness level from 0-F of the green color
        2'b10: disp_digit = red_choice; //displays the brightness level from 0-F of the red color
        2'b11: disp_digit = result[3:0]; //displayed the level of sound picked up from the microphone
    endcase
  end

  assign {red, green, blue} = '0;

endmodule