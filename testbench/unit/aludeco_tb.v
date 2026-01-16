`timescale 1ns/1ps
/*

To compile and run this testbench, use the following command on your terminal:

iverilog -g2012 -o aludeco_tb.vvp src/aludeco.sv testbench/aludeco_tb.sv
vvp aludeco_tb.vvp

*/
module aludeco_tb();

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [1:0] ALUOp;
    wire [3:0] ALUControl;

    aludeco dut(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    initial begin
        $dumpfile("aludeco_tb.vcd");
        $dumpvars(0, aludeco_tb);
    end

    initial begin
        $display("Begin of simulation/n");

        //Initialize Signals in 0
        opcode = 0;
        funct3 = 0;
        funct7 = 0;
        ALUOp = 0;

        //Change ALUOp, opcode, funct3 and funct7 to observe ALUControl changes
        #10
        ALUOp = 2'b00; //lw, sw
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        funct3 = 3'b000; //beq
        ALUOp = 2'b01;
        #10
        $display("ALUControl = %b", ALUControl);

        #10
        funct3 = 3'b001; //bne
        #10
        $display("ALUControl = %b", ALUControl);

        #10
        funct3 = 3'b100; //blt
        #10
        $display("ALUControl = %b", ALUControl);

        #10
        funct3 = 3'b101; //bge
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        opcode = 1;
        funct3 = 3'b000; //sub
        funct7 = 1;
        ALUOp = 2'b10;
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        funct3 = 3'b001; //sll
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        funct3 = 3'b010; //slt
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        funct3 = 3'b011; //sltu
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        funct3 = 3'b100; //xor
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        funct3 = 3'b110; //or
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        funct3 = 3'b111; //and
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        funct3 = 3'b101; //sra
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        funct3 = 3'b101; //srl
        funct7 = 0;
        #10
        $display("ALUControl = %b", ALUControl);

        #20
        ALUOp = 2'b11; //jalr
        #10
        $display("ALUControl = %b", ALUControl);
    end
endmodule