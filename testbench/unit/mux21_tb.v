`timescale 1ns/1ps
/*

To compile and run this testbench, use the following command on your terminal:

iverilog -g2012 -o mux21_tb.vvp src/mux21.sv testbench/mux21_tb.sv
vvp mux21_tb.vvp

*/
module mux21_tb;

    reg sel;
    reg [31:0] ina;
    reg [31:0] inb;
    wire [31:0] out;

    mux21 dut(
        .sel(sel),
        .ina(ina),
        .inb(inb),
        .out(out)
    );

    initial begin
        $dumpfile("mux21_tb.vcd");
        $dumpvars(0, mux21_tb);
    end

    initial begin
        $display("Begin of simulation\n");

        //Initialize Signals in 0
        sel = 0;
        ina = 0;
        inb = 0;

        //Test MUX output when sel signla is modified
        #10
        sel = 0;
        ina = 11;
        inb = 22;
        #10
        $display("Input A = %d\nInputB = %d\nSelected output: %b\nOutput: %d\n", ina, inb, sel, out);

        #10
        sel = 1;
        ina = 11;
        inb = 22;
        #10
        $display("Input A = %d\nInputB = %d\nSelected output: %b\nOutput: %d\n", ina, inb, sel, out);
    end
endmodule