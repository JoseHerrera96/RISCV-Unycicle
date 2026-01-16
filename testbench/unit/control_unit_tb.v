`timescale 1ns/1ps
/*

To compile and run this testbench, use the following command on your terminal:

iverilog -g2012 -o control_unit_tb.vvp src/control_unit.sv src/maindeco.sv src/aludeco.sv  testbench/control_unit_tb.sv
vvp control_unit_tb.vvp

*/
module control_unit_tb();

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg       zero;
    reg       comparison;

    wire       PCSrc;
    wire       Jump;
    wire [1:0] ResultSrc;
    wire       MemWrite;
    wire       MemRead;
    wire       ALUSrc;
    wire [2:0] ImmSrc;
    wire       RegWrite;
    wire [3:0] ALUControl;

    control_unit dut(
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
        .ALUControl(ALUControl)
    );

    initial begin
        $dumpfile("control_unit_tb.vcd");
        $dumpvars(0, control_unit_tb);
    end

    initial begin
        $display("Begin of simulation\n");

        //Initialize Signals in 0
        opcode = 0;
        funct3 = 0;
        funct7 = 0;
        zero = 0;
        comparison = 0;

        //Inputs opcode, funct3, funct7 and zero signals to see controls signals outputs
        #50
        opcode = 7'b011_0011; //Type-R
        funct3 = 3'b000;
        funct7 = 7'b0000001;
        zero = 0;
        comparison = 0;
        #10
        $display("Type-R Instruction:");
        $display("Opcode = %b\nFunct3 = %b\nFunct7 = %b\nZero = %b\nComparison = %b\nPCSrc = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nMemRead = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUControl = %b\n", opcode, funct3, funct7, zero, comparison, PCSrc, Jump, ResultSrc, MemWrite, MemRead, ALUSrc,ImmSrc, RegWrite, ALUControl);

        #50
        opcode = 7'b001_0011; //Type-I
        funct3 = 3'b000;
        funct7 = 7'b0110011;
        zero = 0;
        comparison = 0;
        #10
        $display("Type-I Instruction:");
        $display("Opcode = %b\nFunct3 = %b\nFunct7 = %b\nZero = %b\nComparison = %b\nPCSrc = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nMemRead = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUControl = %b\n", opcode, funct3, funct7, zero, comparison, PCSrc, Jump, ResultSrc, MemWrite, MemRead, ALUSrc,ImmSrc, RegWrite, ALUControl);

        #50
        opcode = 7'b000_0011; //lw
        funct3 = 3'b010;
        funct7 = 7'b0000011;
        zero = 0;
        comparison = 0;
        #10
        $display("Load Word (lw) Instruction:");
        $display("Opcode = %b\nFunct3 = %b\nFunct7 = %b\nZero = %b\nComparison = %b\nPCSrc = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nMemRead = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUControl = %b\n", opcode, funct3, funct7, zero, comparison, PCSrc, Jump, ResultSrc, MemWrite, MemRead, ALUSrc,ImmSrc, RegWrite, ALUControl);

        #50
        opcode = 7'b010_0011; //sw
        funct3 = 3'b010;
        funct7 = 7'b0100011;
        zero = 0;
        comparison = 0;
        #10
        $display("Store Word (sw) Instruction:");
        $display("Opcode = %b\nFunct3 = %b\nFunct7 = %b\nZero = %b\nComparison = %b\nPCSrc = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nMemRead = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUControl = %b\n", opcode, funct3, funct7, zero, comparison, PCSrc, Jump, ResultSrc, MemWrite, MemRead, ALUSrc, ImmSrc, RegWrite, ALUControl);

        #50
        opcode = 7'b011_0111; //lui
        funct3 = 3'bx;
        funct7 = 7'b0110111;
        zero = 0;
        comparison = 0;
        #10
        $display("Load Upper Immediate (lui) Instruction:");
        $display("Opcode = %b\nFunct3 = %b\nFunct7 = %b\nZero = %b\nComparison = %b\nPCSrc = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nMemRead = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUControl = %b\n", opcode, funct3, funct7, zero, comparison, PCSrc, Jump, ResultSrc, MemWrite, MemRead, ALUSrc, ImmSrc, RegWrite, ALUControl);

        #50
        opcode = 7'b110_0011; //Type-B
        funct3 = 3'b101;
        funct7 = 7'b1100011;
        zero = 0;
        comparison = 1;
        #10
        $display("Type-B Instruction:");
        $display("Opcode = %b\nFunct3 = %b\nFunct7 = %b\nZero = %b\nComparison = %b\nPCSrc = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nMemRead = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUControl = %b\n", opcode, funct3, funct7, zero, comparison, PCSrc, Jump, ResultSrc, MemWrite, MemRead, ALUSrc, ImmSrc, RegWrite, ALUControl);
    end
endmodule