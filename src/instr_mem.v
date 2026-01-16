/*
module instr_mem
Instruction memory for RISC-V processor

a          [input]  32-bit address for instruction fetch
rd         [output] 32-bit instruction data

Initialization:
- The instruction memory is initialized using $readmemh() to load from "Test1.hex"
- If the file is not found or empty, it defaults to NOP instructions (32'h00000013)
- Memory size is 64 words (256 bytes)

To change the instruction file:
1. Replace "src/binary files/Test1.hex" with your desired .hex file path
2. Ensure the hex file contains 32-bit instruction words in hexadecimal format
3. The file should be in the correct relative path from your simulation directory
*/
module instr_mem (
    input  wire [31:0] a,
    output wire [31:0] rd
);
    reg [31:0] RAM[63:0];
    
 initial begin
        $readmemh("src/binary files/Test1.hex", RAM);
    end
    
    assign rd = RAM[a[31:2]]; // word aligned

endmodule