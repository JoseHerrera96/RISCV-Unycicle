/*
module pc_register
Program Counter register for RISC-V processor

clk            [input]  clock signal
rst            [input]  reset signal
pcnext         [input]  32-bit next PC value
pc             [output] 32-bit current PC value
*/
module pc_register (
    input  wire clk,
    input  wire rst,
    input  wire [31:0] pcnext,
    output reg  [31:0] pc
);

    //Updates PC when clk or rst signal raises
    always @(posedge clk, posedge rst) begin  
        if (rst) begin
            pc <= 32'b0;
        end 
        else begin
            pc <= pcnext;
        end
    end

endmodule