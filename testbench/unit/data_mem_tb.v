`timescale 1ns/1ps
/*

To compile and run this testbench, use the following command on your terminal:

iverilog -g2012 -o data_mem_tb.vvp src/data_mem.sv testbench/data_mem_tb.sv
vvp data_mem_tb.vvp

*/
module data_mem_tb;

    // Signals
    reg clk;
    reg we, en;
    reg [31:0] a;
    reg [31:0] wd;
    wire [31:0] rd;

    // Test variables (module scope)
    reg [31:0] expected;
    integer i;
    reg [31:0] prev;
    reg [31:0] sampled_rd;
    integer sampled_addr;

    // Instantiate DUT
    data_mem dut(
        .clk(clk),
        .we(we),
        .en(en),
        .a(a),
        .wd(wd),
        .rd(rd)
    );

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence: write some words and read them back
    initial begin
        $dumpfile("data_mem_tb.vcd");
        $dumpvars(0, data_mem_tb);

        // Init
        we = 0; en = 0; a = 0; wd = 0;
        #10;
        $display("Simulation started\n");
        // Write 4 words at addresses 0,4,8,12
        for (i = 0; i < 4; i++) begin
                @(posedge clk);
                we = 1; en = 0;
                a = i * 4; // word-aligned address
                wd = 32'h0000_00A0 + i; // some test data
                $display("[WRITE ] addr=%0d wd=%08h", a, wd);
                // write happens on posedge (always_ff)
                @(posedge clk);
                we = 0;
                // small gap before reading
                @(posedge clk);
                en = 1;
                // read value will be available after posedge because rd is updated on posedge
                @(posedge clk);
                expected = 32'h0000_00A0 + i;
                $display("[READ  ] addr=%0d rd=%08h expected=%08h => %s\n", a, rd, expected, (rd === expected) ? "PASS" : "FAIL");
                if (rd !== expected) begin
                    $display("ERROR: read mismatch at addr %0d: got %08h expected %08h\n", a, rd, expected);
                end 
        end
        en = 0;
    
        // ACTION A: Attempt WRITE with we=0 to addr=0 (should NOT write)
        $display("\n== ACTION A: attempt WRITE with we=0 to addr=0 wd=DEADBEEF (should NOT write)");
        // First, sample the current content at addr=0 (BEFORE)
        @(posedge clk);
        en = 1; a = 0; we = 0;
        @(posedge clk);
        prev = rd;
        $display("BEFORE: memory[0]=%08h (will attempt write with we=0 wd=DEADBEEF)", prev);

        // Attempt write with we=0 (should not change memory)
        @(posedge clk);
        en = 0; a = 0; wd = 32'hDEAD_BEEF; we = 0; // attempt write but we==0
        @(posedge clk);

        // Read back to observe memory[0] after attempted write (AFTER)
        @(posedge clk);
        en = 1; a = 0; we = 0;
        @(posedge clk);
        $display("AFTER : memory[0]=%08h expected(before)=%08h => %s", rd, prev, (rd === prev) ? "PASS (no write occurred)" : "FAIL (was overwritten)");


    // ACTION B: verify rd does NOT change when en==0 and address changes
    $display("\n== ACTION B: verify rd does NOT change when en==0 and address changes");
    // First, sample memory[8] with en=1 so we have a known previous value
    @(posedge clk);
    en = 1; a = 8; we = 0;
    @(posedge clk);
    sampled_addr = a;
    sampled_rd = rd;
    $display("SAMPLED BEFORE CHANGE: addr=%0d rd=%08h", sampled_addr, sampled_rd);

    // Now disable en and change the address; rd should remain sampled_rd
    @(posedge clk);
    en = 0; a = 0; // change address while read-enable is low
    @(posedge clk);
    $display("AFTER CHANGE: attempted addr=%0d rd=%08h (should remain %08h) => %s", a, rd, sampled_rd, (rd === sampled_rd) ? "PASS (rd unchanged)" : "FAIL (rd changed)");

        #10 $finish;
    end

endmodule
