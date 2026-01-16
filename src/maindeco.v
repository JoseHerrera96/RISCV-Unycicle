/*
module maindeco
Main decoder for RISC-V processor control unit

opcode     [input]  7-bit instruction opcode
Branch     [output] Branch control signal (1 for branch instructions)
Jump       [output] Jump control signal (1 for jump instructions)
ResultSrc  [output] 2-bit result source MUX control signal
MemWrite   [output] Memory write enable control signal
ALUSrc     [output] ALU source B MUX control signal
ImmSrc     [output] 3-bit immediate extend control signal
RegWrite   [output] Register file write enable control signal
ALUOp      [output] 2-bit ALU operation control signal
*/

module maindeco (
    input  wire [6:0] opcode,
    output reg        Branch,
    output reg        Jump,
    output reg  [1:0] ResultSrc,
    output reg        MemWrite,
    output reg        MemRead,
    output reg        ALUSrc,
    output reg  [2:0] ImmSrc,
    output reg        RegWrite,
    output reg  [1:0] ALUOp,
    output reg        JumpSrc
);

    //Parameters based on instruction type opcode
    parameter R_type = 7'b0110011;
    parameter I_type = 7'b0010011;
    parameter B_type = 7'b1100011;
    parameter lw     = 7'b0000011;
    parameter sw     = 7'b0100011;
    parameter lui    = 7'b0110111;
    parameter jal    = 7'b1101111;
    parameter jalr   = 7'b1100111;

    always @(*) begin
        case (opcode)
            R_type: begin
                Branch    = 1'b0;
                Jump      = 1'b0;
                JumpSrc   = 1'bx;
                ResultSrc = 2'b00;
                MemWrite  = 1'b0;
                MemRead   = 1'b0;
                ALUSrc    = 1'b0;
                ImmSrc    = 3'bx;
                RegWrite  = 1'b1;
                ALUOp     = 2'b10;
            end 

            I_type: begin
                Branch    = 1'b0;
                Jump      = 1'b0;
                JumpSrc   = 1'bx;
                ResultSrc = 2'b00;
                MemWrite  = 1'b0;
                MemRead   = 1'b0;
                ALUSrc    = 1'b1;
                ImmSrc    = 3'b0;
                RegWrite  = 1'b1;
                ALUOp     = 2'b10;
            end

            B_type: begin
                Branch    = 1'b1;
                Jump      = 1'b0;
                JumpSrc   = 1'b0;
                ResultSrc = 2'bx;
                MemWrite  = 1'b0;
                MemRead   = 1'b0;
                ALUSrc    = 1'b0;
                ImmSrc    = 3'b010;
                RegWrite  = 1'b0;
                ALUOp     = 2'b01;
            end

            lw: begin
                Branch    = 1'b0;
                Jump      = 1'b0;
                JumpSrc   = 1'bx;
                ResultSrc = 2'b01;
                MemWrite  = 1'b0;
                MemRead   = 1'b1;
                ALUSrc    = 1'b1;
                ImmSrc    = 3'b000;
                RegWrite  = 1'b1;
                ALUOp     = 2'b00;
            end

            sw: begin
                Branch    = 1'b0;
                Jump      = 1'b0;
                JumpSrc   = 1'bx;
                ResultSrc = 2'bx;
                MemWrite  = 1'b1;
                MemRead   = 1'b0;
                ALUSrc    = 1'b1;
                ImmSrc    = 3'b001;
                RegWrite  = 1'b0;
                ALUOp     = 2'b00;
            end

            lui: begin
                Branch    = 1'b0;
                Jump      = 1'b0;
                JumpSrc   = 1'bx;
                ResultSrc = 2'b11;
                MemWrite  = 1'b0;
                MemRead   = 1'b0;
                ALUSrc    = 1'bx;
                ImmSrc    = 3'b100;
                RegWrite  = 1'b1;
                ALUOp     = 2'bx;
            end

            jal: begin
                Branch    = 1'b0;
                Jump      = 1'b1;
                JumpSrc   = 1'b0;
                ResultSrc = 2'b10;
                MemWrite  = 1'b0;
                MemRead   = 1'b0;
                ALUSrc    = 1'bx;
                ImmSrc    = 3'b011;
                RegWrite  = 1'b1;
                ALUOp     = 2'bx;
            end

            jalr: begin
                Branch    = 1'b0;
                Jump      = 1'b1;
                JumpSrc   = 1'b1;
                ResultSrc = 2'b00;
                MemWrite  = 1'b0;
                MemRead   = 1'b0;
                ALUSrc    = 1'b1;
                ImmSrc    = 3'b000;
                RegWrite  = 1'b1;
                ALUOp     = 2'b11;
            end

            default: begin
                Branch    = 1'bx;
                Jump      = 1'bx;
                JumpSrc   = 1'bx;
                ResultSrc = 2'bx;
                MemWrite  = 1'bx;
                MemRead   = 1'bx;
                ALUSrc    = 1'bx;
                ImmSrc    = 3'bx;
                RegWrite  = 1'bx;
                ALUOp     = 2'bx;
            end
        endcase
    end
    
endmodule
