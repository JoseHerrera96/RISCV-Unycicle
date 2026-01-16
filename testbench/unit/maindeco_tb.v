`timescale 1ns/1ps
/*

To compile and run this testbench, use the following command on your terminal:

iverilog -g2012 -o maindeco_tb.vvp src/maindeco.sv testbench/maindeco_tb.sv
vvp maindeco_tb.vvp

*/
module maindeco_tb();

    reg [6:0] opcode;
    wire       Branch;
    wire       Jump;
    wire [1:0] ResultSrc;
    wire       MemWrite;
    wire       ALUSrc;
    wire [2:0] ImmSrc;
    wire       RegWrite;
    wire [1:0] ALUOp;

    maindeco dut(
        .opcode(opcode),
        .Branch(Branch),
        .Jump(Jump),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );

    initial begin
        $dumpfile("maindeco_tb.vcd");
        $dumpvars(0, maindeco_tb);
    end

    initial begin
        $display("Begin of simulation\n");

        //Initialize Signals in 0
        opcode = 0;

        //Stimulates the main decoder with different opcodes to observe the control signals outputs
        #10
        opcode = 7'b011_0011; //Type-R
        #10
        $display("Type-R Instruction");
        $display("Opcode = %b\nBranch = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUOp = %b\n", opcode, Branch, Jump, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);

        #20
        opcode = 7'b001_0011; //Type-I
        #10
        $display("Type-I Instruction");
        $display("Opcode = %b\nBranch = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUOp = %b\n", opcode, Branch, Jump, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);

        #20
        opcode = 7'b110_0011; //Type-B
        #10
        $display("Type-B Instruction");
        $display("Opcode = %b\nBranch = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUOp = %b\n", opcode, Branch, Jump, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);

        #20
        opcode = 7'b000_0011; //lw
        #10
        $display("lw Instruction");
        $display("Opcode = %b\nBranch = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUOp = %b\n", opcode, Branch, Jump, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);

        #20
        opcode = 7'b010_0011; //sw
        #10
        $display("sw Instruction");
        $display("Opcode = %b\nBranch = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUOp = %b\n", opcode, Branch, Jump, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);

        #20
        opcode = 7'b011_0111; //LUI
        #10
        $display("LUI Instruction");
        $display("Opcode = %b\nBranch = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUOp = %b\n", opcode, Branch, Jump, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);

        #20
        opcode = 7'b110_1111; //JAL
        #10
        $display("JAL Instruction");
        $display("Opcode = %b\nBranch = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUOp = %b\n", opcode, Branch, Jump, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);

        #20
        opcode = 7'b110_0111; //JALR
        #10
        $display("JALR Instruction");
        $display("Opcode = %b\nBranch = %b\nJump = %b\nResultSrc = %b\nMemWrite = %b\nALUSrc = %b\nImmSrc = %b\nRegWrite = %b\nALUOp = %b\n", opcode, Branch, Jump, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUOp);
    end
endmodule