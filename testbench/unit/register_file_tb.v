`timescale 1ns/1ps
/*

To compile and run this testbench, use the following commands on your terminal (Windows PowerShell):

iverilog -g2012 -o register_file_tb.vvp src/register_file.sv testbench/register_file_tb.sv
vvp register_file_tb.vvp

*/
module register_file_tb;

    // Clock and control
    reg clk;
    reg we3;

    // Addresses and data
    reg [4:0] a1;
    reg [4:0] a2;
    reg [4:0] a3;
    reg [31:0] wd3;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Instantiate DUT
    register_file dut(
        .clk(clk),
        .we3(we3),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .wd3(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generator: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, register_file_tb);
    end

    initial begin
        $display("Begin of simulation\n");

        // Initialize
        we3 = 0;
        a1 = 0;
        a2 = 0;
        a3 = 0;
        wd3 = 0;

        // Wait a bit
        #10;

        // Write to register 1 (a3 = 1) and check reads
        a1 = 1; // read port 1
        a2 = 2; // read port 2
        a3 = 1; // write to reg 1
        wd3 = 32'h0000_00AA;
        $display("Read r1 before write 0x%0h to r1.\n r1=%0h\n", wd3, rd1);
        we3 = 1;
        #10; // on posedge, write happens
        we3 = 0;
        #5; // allow combinational read
        $display("Read r1 after write 0x%0h to r1.\n r1=%0h\n", wd3, rd1);
          
        // Second, read from x0 to ensure it's always 0
        a1 = 1; a2 = 0;
        we3 = 1;
        #10; // on posedge, write happens
        we3 = 0;
        #5;
        $display("Read x0 (should be 0): r1=%0h, r0=%0h\n", rd1, rd2);

        // Read r2 before writing to it
        a1 = 1; a2 = 2; #5;
        $display("Read r2 before write: r2=%0h\n", rd2);
        
        // Overwrite r1 and write r2
        a3 = 2; wd3 = 32'hDEADBEEF; we3 = 1;
        #10; we3 = 0; #5;
        $display("Wrote 0x%0h to r2.\n", wd3);

        // Read both r1 and r2
        a1 = 1; a2 = 2; #5;
        $display("Read \nr1=%0h \nr2=%0h\n", rd1, rd2);

        // Write to register with we3=0 shouldn't change
        a3 = 1; wd3 = 32'h11111111; we3 = 0;
        #10; #5;
        $display("Attempted write %0h with we3=0 to r1. \n r1=%0h (should remain previous)\n", wd3, rd1);

        $display("End of simulation\n");
        #10 $finish;
    end
endmodule
