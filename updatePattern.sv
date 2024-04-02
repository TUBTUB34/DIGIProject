module updatePattern
                   (input logic clk, reset_n, // clock and reset
                    input logic [11:0] result,
                    input logic set,
                    output logic [15:0][14:0] pattern //will need to change depending on cols, and led's per col
                    );

    // logic [24:0][24:0] patMask = {25'h1000000,25'h800000,25'h400000,25'h200000,25'h100000, 25'h80000, 25'h40000, 25'h20000, 25'h10000, 25'h8000,
    //                               25'h4000, 25'h2000, 25'h1000, 25'h800, 25'h400, 25'h200, 25'h100, 25'h80, 25'h40, 25'h20, 25'h10, 25'h8, 25'h4, 25'h2, 25'h1}; // ones shifting all the way down
    logic [24:0][24:0] patMask = {25'h1ffffff,25'hffffff,25'h7fffff,25'h3fffff,25'h1fffff, 25'hfffff, 25'h7ffff, 25'h3ffff, 25'h1ffff, 25'hffff,
                                  25'h7fff, 25'h3fff, 25'h1fff, 25'hfff, 25'h7ff, 25'h3ff, 25'h1ff, 25'hFF, 25'h7F, 25'h3F, 25'h1F, 25'hF, 25'h7, 25'h3, 25'h1};
    
    logic set1;
    logic [11:0] resultf;                      
    always_ff @(posedge clk) begin
        
        if (~reset_n) pattern <= '0;
        else if (set) begin
            set1 <= 1;
            resultf <= result;
        end
        else if (set1) begin
            set1 <= 0;
            pattern[15] <= pattern[14];
            pattern[14] <= pattern[13];
            pattern[13] <= pattern[12];
            pattern[12] <= pattern[11];
            pattern[11] <= pattern[10];
            pattern[10] <= pattern[9];
            pattern[9] <= pattern[8];
            pattern[8] <= pattern[7];
            pattern[7] <= pattern[6];
            pattern[6] <= pattern[5];
            pattern[5] <= pattern[4];
            pattern[4] <= pattern[3];
            pattern[3] <= pattern[2];
            pattern[2] <= pattern[1];
            pattern[1] <= pattern[0];
            pattern[0] <= (patMask[resultf] | '0); // filling the newst pattern with zeros other then the mask
        end

    end
    
endmodule