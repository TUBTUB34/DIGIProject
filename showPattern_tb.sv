module showPattern_tb();

logic clk;			 // clock and reset
logic [2:0] color;			 
logic [4:0][4:0] pattern;
logic data = 0;  
	

showPattern dut_0 (.*);  // device under test


initial begin
    pattern = {5'b10101,5'b00100,5'b00100,5'b00100,5'b10101};
	clk = 0;
	color = 3;
	
	// cycles threw the first pattern. 
	repeat(3000) @(posedge clk);
		
	$stop;
end

// generate clock
always
	#10ns clk = ~clk;
	
endmodule

