`timescale 1ns/1ps
/*

To compile and run this testbench, use the following command on your terminal:

iverilog -g2012 -o alu_tb.vvp src/alu.sv testbench/alu_tb.sv
vvp alu_tb.vvp

*/

module alu_tb();

    reg [3:0]  ALUControl;
    reg signed [31:0] SrcA;
    reg signed [31:0] SrcB;
    wire signed [31:0] ALUResult;
    wire        zero;
    wire        comparison;

    alu dut(
        .ALUControl(ALUControl),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUResult(ALUResult),
        .zero(zero),
        .comparison(comparison)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0,alu_tb);
    end

    initial begin
        $display("Begin of simulation\n");

        //Initialize Signals in 0
        ALUControl = 0;
        #10
        SrcA = 0;
        SrcB = 0;

        //Stimulates the circuit to exexcute the instructions
        $display("=== ARITHMETIC OPERATIONS ===");
        #20
        ALUControl = 4'b0000; //add
        SrcA = 10;
        SrcB = 5;
        #10
        $display("ADD Operation:");
        $display("Control Signal: %b\nSource A = %d\nSource B = %d\nResult: %d\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        #20
        ALUControl = 4'b0001; //sub
        SrcA = 10;
        SrcB = 5;
        #10
        $display("SUB Operation:");
        $display("Control Signal: %b\nSource A = %d\nSource B = %d\nResult: %d\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        $display("\n=== LOGICAL OPERATIONS ===");
        #20
        ALUControl = 4'b0010; //and
        SrcA = 1;
        SrcB = 1;
        #10
        $display("AND Operation:");
        $display("Control Signal: %b\nSource A = %b\nSource B = %b\nResult: %b\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        #20
        ALUControl = 4'b0010; //and
        SrcA = 0;
        SrcB = 1;
        #10
        $display("AND Operation:");
        $display("Control Signal: %b\nSource A = %b\nSource B = %b\nResult: %b\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        #20
        ALUControl = 4'b0011; //or
        SrcA = 0;
        SrcB = 1;
        #10
        $display("OR Operation:");
        $display("Control Signal: %b\nSource A = %b\nSource B = %b\nResult: %b\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        #20
        ALUControl = 4'b0011; //or
        SrcA = 0;
        SrcB = 0;
        #10
        $display("OR Operation:");
        $display("Control Signal: %b\nSource A = %b\nSource B = %b\nResult: %b\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        #20
        ALUControl = 4'b0100; //xor
        SrcA = 0;
        SrcB = 1;
        #10
        $display("XOR Operation:");
        $display("Control Signal: %b\nSource A = %b\nSource B = %b\nResult: %b\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        #20
        ALUControl = 4'b0100; //xor
        SrcA = 0;
        SrcB = 0;
        #10
        $display("XOR Operation:");
        $display("Control Signal: %b\nSource A = %b\nSource B = %b\nResult: %b\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        $display("\n=== COMPARISON OPERATIONS ===");
        #20
        ALUControl = 4'b0101; //slt
        SrcA = 3'b001;
        SrcB = 3'b111;
        #10
        $display("SLT Operation:");
        $display("Control Signal: %b\nSource A = %d\nSource B = %d\nResult: %d\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        #20
        ALUControl = 4'b0110; //sltu
        SrcA = 2;
        SrcB = 1;
        #10
        $display("SLTU Operation:");
        $display("Control Signal: %b\nSource A = %d\nSource B = %d\nResult: %d\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        $display("\n=== SHIFT OPERATIONS ===");
        #20
        ALUControl = 4'b0111; //sll
        SrcA = 4'b0001;
        SrcB = 2;
        #10
        $display("SLL Operation:");
        $display("Control Signal: %b\nSource A = %b\nSource B = %b\nResult: %b\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        #20
        ALUControl = 4'b1000; //srl
        SrcA = 4'b1000;
        SrcB = 2;
        #10
        $display("SRL Operation:");
        $display("Control Signal: %b\nSource A = %b\nSource B = %b\nResult: %b\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        #20
        ALUControl = 4'b1001; //sra
        SrcA = 4'b1000;
        SrcB = 2;
        #10
        $display("SRA Operation:");
        $display("Control Signal: %b\nSource A = %b\nSource B = %b\nResult: %b\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, ALUResult, zero, comparison);

        $display("\n=== BRANCH OPERATIONS ===");
        #20
        ALUControl = 4'b1010; //bne
        SrcA = 1;
        SrcB = 1;
        #10
        $display("BNE Operation:");
        $display("Control Signal: %b\nSource A = %d\nSource B = %d\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, zero, comparison);

        #20
        ALUControl = 4'b1010; //bne
        SrcA = 0;
        SrcB = 1;
        #10
        $display("BNE Operation:");
        $display("Control Signal: %b\nSource A = %d\nSource B = %d\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, zero, comparison);

        #20
        ALUControl = 4'b1011; //blt
        SrcA = 0;
        SrcB = 1;
        #10
        $display("BLT Operation:");
        $display("Control Signal: %b\nSource A = %d\nSource B = %d\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, zero, comparison);

        #20
        ALUControl = 4'b1011; //blt
        SrcA = 2;
        SrcB = 1;
        #10
        $display("BLT Operation:");
        $display("Control Signal: %b\nSource A = %d\nSource B = %d\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, zero, comparison);

        #20
        ALUControl = 4'b1100; //bge
        SrcA = 2;
        SrcB = 1;
        #10
        $display("BGE Operation:");
        $display("Control Signal: %b\nSource A >= %d\nSource B = %d\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, zero, comparison);

        #20
        ALUControl = 4'b1100; //bge
        SrcA = 0;
        SrcB = 1;
        #10
        $display("BGE Operation:");
        $display("Control Signal: %b\nSource A = %d\nSource B = %d\nZero Flag: %b\nComparison Flag: %b\n", ALUControl, SrcA, SrcB, zero, comparison);
    end
endmodule