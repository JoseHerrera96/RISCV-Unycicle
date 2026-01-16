`timescale 1ns/1ps
/*

To compile and run this testbench, use the following command on your terminal:

iverilog -g2012 -o mux4_tb.vvp src/mux4.sv testbench/mux4_tb.sv
vvp mux4_tb.vvp

*/
module mux4_tb;

    reg [31:0] d0;
    reg [31:0] d1;
    reg [31:0] d2;
    reg [31:0] d3;
    reg [1:0]  sel;
    wire [31:0] out;

    mux4 dut(
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .out(out)
    );

    initial begin
        $dumpfile("mux4_tb.vcd");
        $dumpvars(0, mux4_tb);
    end

    initial begin
        //Initialize Signals in 0
        sel = 0;
        d0 = 0;
        d1 = 0;
        d2 = 0;
        d3 = 0;
        $display("Simulation started\n");
        //Test the MUX output when sel signal is modified
        #10
        sel = 0;
        d0 = 1;
        d1 = 2;
        d2 = 3;
        d3 = 4;
        #10
        $display("Input A = %d\nInputB = %d\nInput C = %d\nInputD = %d\nSelected output: %b\nOutput: %d\n", d0, d1, d2, d3, sel, out);

        #10
        sel = 1;
        d0 = 1;
        d1 = 2;
        d2 = 3;
        d3 = 4;
        #10
        $display("Input A = %d\nInputB = %d\nInput C = %d\nInputD = %d\nSelected output: %b\nOutput: %d\n", d0, d1, d2, d3, sel, out);

        #10
        sel = 2;
        d0 = 1;
        d1 = 2;
        d2 = 3;
        d3 = 4;
        #10
        $display("Input A = %d\nInputB = %d\nInput C = %d\nInputD = %d\nSelected output: %b\nOutput: %d\n", d0, d1, d2, d3, sel, out);

        #10
        sel = 3;
        d0 = 1;
        d1 = 2;
        d2 = 3;
        d3 = 4;
        #10
        $display("Input A = %d\nInputB = %d\nInput C = %d\nInputD = %d\nSelected output: %b\nOutput: %d\n", d0, d1, d2, d3, sel, out);
    end
    
endmodule