/*
module datapath
RISC-V processor datapath module
 
Handles instruction execution, register file operations, ALU operations,
and data flow control for a RISC-V processor implementation.

Inputs:
- clk: Clock signal
- rst: Reset signal  
- instr[31:0]: 32-bit instruction
- PCSrc: Program counter source select
- ResultSrc[1:0]: Result multiplexer select
- ALUSrc: ALU source multiplexer select
- ImmSrc[2:0]: Immediate extension type select
- RegWrite: Register write enable
- ALUControl[3:0]: ALU operation control
- ReadData[31:0]: Data memory read data

Outputs:
- PC[31:0]: Program counter
- zero: ALU zero flag
- comparison: ALU comparison result
- ALUResult[31:0]: ALU computation result
- WriteData[31:0]: Data to write to memory
*/


module datapath (
    input wire        clk,
    input wire        rst,
    input wire [31:0] instr,
    input wire        PCSrc,
    input wire [1:0]  ResultSrc,
    input wire        ALUSrc,
    input wire [2:0]  ImmSrc,
    input wire        RegWrite,
    input wire [3:0]  ALUControl,
    input wire [31:0] ReadData,
    input wire        JumpSrc,

    output wire [31:0] PC,
    output wire        zero,
    output wire        comparison,
    output wire signed [31:0] ALUResult,
    output wire [31:0] WriteData
);

    wire [31:0] PCNext;
    wire [31:0] PCPlus4;
    wire [31:0] PCTarget;
    wire [31:0] PCBranch;
    wire [31:0] PCJump;
    wire [31:0] SrcA;
    wire [31:0] SrcB;
    wire [31:0] ImmExt;
    wire [31:0] Result;
    wire [31:0] SrcAPlusImm;

    //PC Logic
    pc_register pc_reg(
        .clk(clk),
        .rst(rst),
        .pcnext(PCNext),
        .pc(PC)
    );

    adder pc_4(
        .ina(PC),
        .inb(32'd4),
        .out(PCPlus4)
    );

    adder pc_branch(
        .ina(PC),
        .inb(ImmExt),
        .out(PCBranch)
    );
    
    adder jalr_add(
        .ina(SrcA),
        .inb(ImmExt),
        .out(SrcAPlusImm)
    );
    
    mux21 target_mux(
        .sel(JumpSrc),
        .ina(PCBranch),     // Branch target
        .inb(SrcAPlusImm),
        .out(PCTarget)
    );

    mux21 pc_mux(
        .sel(PCSrc),
        .ina(PCPlus4),
        .inb(PCTarget),
        .out(PCNext)
    );

    //Register File Logic
    register_file regfile(
        .clk(clk),
        .we3(RegWrite),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .wd3(Result),
        .rd1(SrcA),
        .rd2(WriteData)
    );

    imm_ext imm_extend(
        .instr(instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );
    
    //ALU Logic
    mux21 alu_mux(
        .sel(ALUSrc),
        .ina(WriteData),
        .inb(ImmExt),
        .out(SrcB)
    );

    alu alu(
        .ALUControl(ALUControl),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUResult(ALUResult),
        .zero(zero),
        .comparison(comparison)
    );

    mux4 result_mux(
        .d0(ALUResult),
        .d1(ReadData),
        .d2(PCPlus4),
        .d3(ImmExt),
        .sel(ResultSrc),
        .out(Result)
    );

endmodule
