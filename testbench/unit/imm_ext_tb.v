`timescale 1ns/1ps
/*

To compile and run this testbench, use the following command on your terminal:

iverilog -g2012 -o imm_ext_tb.vvp src/imm_ext.sv testbench/imm_ext_tb.sv
vvp imm_ext_tb.vvp

*/
module imm_ext_tb();

    reg [31:0] instr;
    reg [2:0]  ImmSrc;
    wire [31:0] ImmExt;

    imm_ext dut(
        .instr(instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    initial begin
        $dumpfile("imm_ext_tb.vcd");
        $dumpvars(0, imm_ext_tb);
    end

    initial begin
        $display("Begin of simulation\n");

        //Initialize Signals in 0
        instr = 0;
        ImmSrc = 0;

        //Inputs an immediate to observe the output
        #10
        instr = 32'b1111_1111_1111_00101_000_00110_0010011; //Type-I
        ImmSrc = 3'b000;
        #10
        $display("Type-I Instruction:");
        $display("Instruction = %h\nSelection = %b\nOutput = %d\n", instr, ImmSrc, ImmExt);

        #20
        instr = 32'b0001100_00110_00101_010_00100_0100011; //Type-S
        ImmSrc = 3'b001;
        #10
        $display("Type-S Instruction:");
        $display("Instruction = %h\nSelection = %b\nOutput = %d\n", instr, ImmSrc, ImmExt);

        #20
        instr = 32'b0000001_00110_00101_000_11111_1100011; //B-Type
        ImmSrc = 3'b010;
        #10
        $display("B-Type Instruction:");
        $display("Instruction = %h\nSelection = %b\nOutput = %d\n", instr, ImmSrc, ImmExt);

        #20
        instr = 32'b00000_11111_00000_11111_00101_1101111; //J-Type
        ImmSrc = 3'b011;
        #10
        $display("J-Type Instruction:");
        $display("Instruction = %h\nSelection = %b\nOutput = %d\n", instr, ImmSrc, ImmExt);

        #20
        instr = 32'b00000_11111_00000_11111_00110_0110111; //LUI
        ImmSrc = 3'b100;
        #10
        $display("LUI Instruction:");
        $display("Instruction = %h\nSelection = %b\nOutput = %d\n", instr, ImmSrc, ImmExt);
    end
endmodule