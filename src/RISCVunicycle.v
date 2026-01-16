/*
module RISCVunicycle
Single-cycle RISC-V processor implementation

clk        [input]  Clock signal
rst        [input]  Reset signal
instr      [input]  32-bit instruction from instruction memory
ReadData   [input]  32-bit data from data memory
PC         [output] 32-bit program counter
MemWrite   [output] Memory write enable signal
MemRead    [output] Memory read enable signal
ALUResult  [output] 32-bit ALU result
WriteData  [output] 32-bit data to write to memory
*/
module RISCVunicycle (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] instr,
    input  wire [31:0] ReadData,
    output wire [31:0] PC,
    output wire        MemWrite,
    output wire        MemRead,
    output wire signed [31:0] ALUResult,
    output wire [31:0] WriteData
);

    //Control Signals
    wire ALUSrc;
    wire RegWrite;
    wire Jump;
    wire PCSrc;
    wire zero;
    wire comparison;

    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
    wire [3:0] ALUControl;

    // Instruction field signals
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    // Combinational assignments for instruction fields
    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    //Control unit
    control_unit ctrl_unit(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .zero(zero),
        .comparison(comparison),
        .PCSrc(PCSrc),
        .Jump(Jump),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .JumpSrc(JumpSrc)
    );

    //Datapath
    datapath datapath(
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .ReadData(ReadData),
        .PC(PC),
        .zero(zero),
        .comparison(comparison),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .JumpSrc(JumpSrc)
    );

    
endmodule