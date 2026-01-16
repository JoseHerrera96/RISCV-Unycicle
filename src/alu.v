/*
module alu
32-bit Arithmetic Logic Unit (ALU) with comparison support

ALUControl [input]  4-bit control signal to select operation
SrcA       [input]  32-bit signed input A
SrcB       [input]  32-bit signed input B
ALUResult  [output] 32-bit signed result of selected operation
zero       [output] Zero flag (1 if ALUResult == 0)
comparison [output] Comparison result flag for branch instructions

Operations:
0000: ADD    - Addition (SrcA + SrcB)
0001: SUB    - Subtraction (SrcA - SrcB)  
0010: AND    - Bitwise AND (SrcA & SrcB)
0011: OR     - Bitwise OR (SrcA | SrcB)
0100: XOR    - Bitwise XOR (SrcA ^ SrcB)
0101: SLT    - Set Less Than signed (SrcA < SrcB)
0110: SLTU   - Set Less Than unsigned (SrcA < SrcB)
0111: SLL    - Shift Left Logical (SrcA << SrcB)
1000: SRL    - Shift Right Logical (SrcA >> SrcB)
1001: SRA    - Shift Right Arithmetic (SrcA >>> SrcB)
1010: BNE    - Branch Not Equal comparison (SrcA != SrcB)
1011: BLT    - Branch Less Than comparison (SrcA < SrcB)
1100: BGE    - Branch Greater Equal comparison (SrcA >= SrcB)
*/


module alu (
    input  wire [3:0]  ALUControl,
    input  wire signed [31:0] SrcA,
    input  wire signed [31:0] SrcB,
    output reg  signed [31:0] ALUResult,
    output reg         zero,
    output reg         comparison
);

    //ALUControl selects which operation will be execute
    always @(*) begin
        comparison = 0; //Flag for branch instructions
        case (ALUControl)
            4'b0000: ALUResult = SrcA + SrcB; //add, addi
            4'b0001: ALUResult = SrcA - SrcB; //sub
            4'b0010: ALUResult = SrcA & SrcB; //and, andi
            4'b0011: ALUResult = SrcA | SrcB; //or, ori
            4'b0100: ALUResult = SrcA ^ SrcB; //xor, xori
            4'b0101: ALUResult = (SrcA) < (SrcB) ? 1 : 0; //slt, slti
            4'b0110: ALUResult = ($unsigned(SrcA) < $unsigned(SrcB)) ? 1 : 0; //sltu, sltui
            4'b0111: ALUResult = SrcA << SrcB; //sll, slli
            4'b1000: ALUResult = SrcA >> SrcB; //srl, srli
            4'b1001: ALUResult = SrcA >>> SrcB; //sra, srai

            4'b1010: comparison = (SrcA) != (SrcB) ? 1 : 0; //bne
            4'b1011: comparison = (SrcA < SrcB) ? 1 : 0; //blt
            4'b1100: comparison = (SrcA >= SrcB) ? 1 : 0; //bge

            default: begin
                ALUResult = 32'bx;
                comparison = 0;
            end
        endcase
    end

    always @(*) begin
        case (ALUControl)
            4'b0001: zero = (SrcA == SrcB) ? 1 : 0; // beq - branch if equal
            default: zero = 0; // Default: zero flag for ALUResult
        endcase
    end

endmodule