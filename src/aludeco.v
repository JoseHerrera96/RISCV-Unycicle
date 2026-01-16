/*
module aludeco
ALU Decoder module for RISC-V processor

opcode     [input]  7-bit opcode signal
funct3     [input]  3-bit function code from instruction
funct7     [input]  7-bit function code from instruction  
ALUOp      [input]  2-bit ALU operation type from control unit
ALUControl [output] 4-bit control signal for ALU operation selection
*/

module aludeco (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    input  wire [1:0] ALUOp,
    output reg  [3:0] ALUControl
);

    //Flag for sub, sra, srai instructions
    wire instr_sel;
    assign instr_sel = funct7[5] && opcode[5] ? 1'b1 : 1'b0;

    //ALUOp choose the instruction type
    //funct3 choose the instruction to execute
    //instr_sel is needed when 2 instructions have the same ALUOp and funct3 signal
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0000; //add -> lw, sw
            
            2'b01: case (funct3)
                3'b000:  ALUControl = 4'b0001; //sub -> beq
                3'b001:  ALUControl = 4'b1010; //bne
                3'b100:  ALUControl = 4'b1011; //blt
                3'b101:  ALUControl = 4'b1100; //bge
                default: ALUControl = 4'bx;
            endcase

            2'b10: case (funct3)
                3'b000: begin
                    if (instr_sel) ALUControl = 4'b0001; //sub
                    else ALUControl = 4'b0000; //add
                end
                3'b001: ALUControl = 4'b0111; //sll, slli
                3'b010: ALUControl = 4'b0101; //slt, slti
                3'b011: ALUControl = 4'b0110; //sltu, sltui
                3'b100: ALUControl = 4'b0100; //xor, xori
                3'b101: begin
                    if (instr_sel) ALUControl = 4'b1001; //sra, srai
                    else ALUControl = 4'b1000; //srl, srli
                end
                3'b110: ALUControl = 4'b0011; //or, ori
                3'b111: ALUControl = 4'b0010; //and, andi
                default: ALUControl = 4'bx;
            endcase

            2'b11: ALUControl = 4'b0000;  //jalr

            default: ALUControl = 4'bx;
        endcase
    end
    
endmodule