module updatePattern_tb();

logic clk;			 // clock and reset
logic [11:0] result;			 
logic [4:0][4:0] pattern;
logic data = 0;  
	

updatePattern dut_0 (.*);  // device under test
logic set, reset_n;

initial begin
    pattern = {'0,'0,'0,'0,'0};
	clk = 0;
	result  = 2;
    set =0;
	
	// cycles threw the first pattern. 
	repeat(2) @(posedge clk);
    set=1;
    repeat(1) @(posedge clk);
    set=0;
    result  = 1;
    repeat(2) @(posedge clk);
    set=1;
    repeat(1) @(posedge clk);
    set=0;
    result  = 4;
	repeat(2) @(posedge clk);
    set=1;
    repeat(1) @(posedge clk);
    set=0;
    result  = 0;
    repeat(2) @(posedge clk);
    set=1;
    repeat(1) @(posedge clk);
    set=0;
    result  = 0;
	repeat(2) @(posedge clk);
    set=1;
    repeat(1) @(posedge clk);
    repeat(1) @(posedge clk);
    set=0;
    reset_n = 0;	
	repeat(6) @(posedge clk);

	$stop;
end

// generate clock
always
	#10ns clk = ~clk;
	
endmodule

