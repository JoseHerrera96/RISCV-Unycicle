/*
Control Unit module for RISC-V processor

opcode     [input]  7-bit opcode from instruction
funct3     [input]  3-bit function code from instruction
funct7     [input]  7-bit function code from instruction
zero       [input]  1-bit zero flag from ALU
comparison [input]  1-bit comparison result
PCSrc      [output] 1-bit PC source select signal
Jump       [output] 1-bit jump control signal
ResultSrc  [output] 2-bit result source select signal
MemWrite   [output] 1-bit memory write enable
MemRead    [output] 1-bit memory read enable
ALUSrc     [output] 1-bit ALU source select signal
ImmSrc     [output] 3-bit immediate source select signal
RegWrite   [output] 1-bit register write enable
ALUControl [output] 4-bit ALU control signal
*/

module control_unit (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    input wire       zero,
    input wire       comparison,

    output wire       PCSrc,
    output wire       Jump,
    output wire [1:0] ResultSrc,
    output wire       MemWrite,
    output wire       MemRead,
    output wire       ALUSrc,
    output wire [2:0] ImmSrc,
    output wire       RegWrite,
    output wire [3:0] ALUControl,
    output wire       JumpSrc
);

    wire [1:0] ALUOp;
    wire Branch;

    //Main Decoder control signals
    maindeco main_decoder(
        .opcode(opcode),
        .Branch(Branch),
        .Jump(Jump),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .JumpSrc(JumpSrc)
    );

    //ALU Decoder control signals
    aludeco alu_decoder(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
        );

    //PC MUX control signal
    assign PCSrc = zero | comparison & Branch | Jump;
    
endmodule