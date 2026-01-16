`timescale 1ns/1ps
/*

To compile and run this testbench, use the following command on your terminal:

iverilog -g2012 -o adder_tb.vvp src/adder.sv testbench/adder_tb.sv
vvp adder_tb.vvp
*/

module adder_tb;

    reg signed [31:0] ina;
    reg signed [31:0] inb;
    wire signed [31:0] out;

    adder dut(
        .ina(ina),
        .inb(inb),
        .out(out)
    );

    initial begin
        $dumpfile("adder_tb.vcd");
        $dumpvars(0, adder_tb);
    end

    initial begin
        $display("Begin of simulation/n");
        ina = 0;
        inb = 0;

        #10
        ina = 10;
        inb = 5;
        $display("Input A = %d\nInput B = %d\nout = %d\n", ina, inb, out);
        
        #10
        ina = 10;
        inb = -5;
        $display("Input A = %d\nInput B = %d\nout = %d\n", ina, inb, out);

        #10
        ina = -10;
        inb = 5;
        $display("Input A = %d\nInput B = %d\nout = %d\n", ina, inb, out);

        #10
        ina = -10;
        inb = -5;
        $display("Input A = %d\nInput B = %d\nout = %d\n", ina, inb, out);

        #10
        ina = 8'hFFFFFFFF;
        inb = 8'hFFFFFFFF;
        $display("Input A = %d\nInput B = %d\nout = %d\n", ina, inb, out);
    end
    
endmodule