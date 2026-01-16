/*
module register_file
Register file for RISC-V processor

clk  [input]  Clock signal
we3  [input]  Write enable
a1   [input]  5-bit read address 1
a2   [input]  5-bit read address 2
a3   [input]  5-bit write address
wd3  [input]  32-bit write data
rd1  [output] 32-bit read data 1
rd2  [output] 32-bit read data 2
*/

module register_file(
    input  wire        clk,
    input  wire        we3,
    input  wire [4:0]  a1,
    input  wire [4:0]  a2,
    input  wire [4:0]  a3,
    input  wire [31:0] wd3,
    output wire [31:0] rd1,
    output wire [31:0] rd2
    );
    
    //Registers
    reg [31:0] rf[31:0];

    //When Write Enable is 1, puts Data on register
    always @(posedge clk) begin
        if (we3) rf[a3] <= wd3;
    end
    
    //Updates Read Data signals with the information on Addresses
    assign rd1 = (a1 != 0) ? rf[a1] : 0;
    assign rd2 = (a2 != 0) ? rf[a2] : 0;

endmodule