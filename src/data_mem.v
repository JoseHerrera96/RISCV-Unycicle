/*
Data Memory module for RISC-V processor

clk [input]  Clock signal
we  [input]  Write enable signal
en  [input]  Memory enable signal
a   [input]  32-bit address input
wd  [input]  32-bit write data input
rd  [output] 32-bit read data output

The data memory is initialized from a hex file at simulation start.
To change the data memory file:
1. Modify the file path in $readmemh("src/binary files/data.hex", RAM)
2. Ensure the new hex file contains 32-bit hexadecimal values
3. The file should have one hex value per line (without 0x prefix)
4. Maximum 64 entries (RAM size is 64 words)

Example hex file format:
12345678
ABCDEF00
00000001

*/
module data_mem (
    input  wire clk,
    input  wire we, en,
    input  wire [31:0] a,
    input  wire [31:0] wd,
    output reg  [31:0] rd
);

    reg [31:0] RAM[63:0];  // 64 words = 256 bytes


    initial begin
        $display("Loading data memory from 'data.hex'...");
        $readmemh("src/binary files/data.hex", RAM);
        
    end

    // LECTURA COMBINACIONAL (disponible en el mismo ciclo)
    always @(negedge clk) begin
        if (en) begin
            rd <= RAM[a[31:2]];  // word-aligned read
        end else begin
            rd <= 32'h0;
        end
    end

    
    // ESCRITURA SINCRÓNICA
    always @(posedge clk) begin
        if (we) begin
            RAM[a[31:2]] <= wd;  // word-aligned write
        end
    end
    
endmodule
