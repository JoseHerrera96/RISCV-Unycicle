`timescale 1ns/1ps
/*

To compile and run this testbench, use the following command on your terminal:

iverilog -g2012 -o pc_register_tb.vvp src/pc_register.sv testbench/pc_register_tb.sv
vvp pc_register_tb.vvp

*/
module pc_register_tb ();

reg clk;
reg rst;
reg [31:0] pcnext;
wire [31:0] pc;

// Instancia del PC
pc_register dut (
    .clk(clk),
    .rst(rst),
    .pcnext(pcnext),
    .pc(pc)
);

always #5 clk = ~clk; //Clock Generator

initial begin
    $dumpfile("pc_register_tb.vcd");
    $dumpvars(0,pc_register_tb);
end

initial begin
    $display("Begin of simulatio\n");
    //Initialize Signals in 0
    clk = 0;
    rst = 0;
    pcnext = 0;
    #10;
    //Change pcnext to observe how pc updates
    $display("pcnext: %d, pc: %d\n", pcnext, pc);
    pcnext = 4;
    #10;
    $display("pcnext: %d, pc: %d\n", pcnext, pc);
    pcnext = 8;
    #10;
    $display("pcnext: %d, pc: %d\n", pcnext, pc);
    pcnext = 12;
    #10;
    $display("pcnext: %d, pc: %d\n", pcnext, pc);
    rst = 1;
    #10;
    $display("rst: %b, pcnext: %d, pc: %d\n", rst, pcnext, pc);
    rst = 0;
    #20;
    $display("rst: %b, pcnext: %d, pc: %d\n", rst, pcnext, pc);
    pcnext = 100;
    #20;
    $display("pcnext: %d, pc: %d\n", pcnext, pc);
    $finish;
end

endmodule