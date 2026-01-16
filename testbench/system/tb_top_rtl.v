`timescale 1ns/1ps

/*

To compile and run this testbench, use the following commands on your terminal (Windows PowerShell):

iverilog -g2012 -o tb_top_gls.vvp src/register_file.sv src/datapath.sv src/pc_register.sv src/adder.sv src/mux21.sv src/imm_ext.sv src/alu.sv src/mux4.sv src/data_mem.sv src/instr_mem.sv src/RISCVunicycle.sv src/control_unit.sv src/maindeco.sv src/aludeco.sv src/top.sv testbench/tb_top_gls.sv
vvp tb_top_gls.vvp

then execute bash "GTKwave" to view the waveform: \proyecto2-grupo-9\testbench\GTKwave_sim\dump_gls.vcd
and use the template: \proyecto2-grupo-9\testbenchtop_tb.gtkw

*/
module tb_top_rtl ();

    reg         clk;
    reg         rst;
    wire        MemWrite;
    wire [31:0] WriteData;
    wire [31:0] DataAdr;

    // Smart termination variables
    integer cycle_count;
    integer max_cycles;
    integer branch_count;
    wire [31:0] current_instr;
    
    parameter MAX_BRANCHES = 20;   // Max loop iterations

    top dut(
        .clk(clk),
        .rst(rst),
        .MemWrite(MemWrite),
        .WriteData(WriteData),
        .DataAdr(DataAdr)
    );
    
    // Access internal instruction for monitoring
    assign current_instr = dut.instr;
    
    initial begin
        $dumpfile("dump_rtl.vcd");
        $dumpvars(0, tb_top_rtl);
    end
    
    // Clock generator
    initial begin
        clk = 0;
        forever #20 clk = ~clk; // 40 ns period
    end
initial begin

        // Initialize counters
        cycle_count = 0;
        max_cycles = 1000;  // Safety limit
        branch_count = 0;
        
        // Reset sequence
        rst = 1;
        @(posedge clk);
        rst = 0;
        
        // Execute until halt condition or max cycles
        cycle_count = 0;
        while (cycle_count < max_cycles) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;
            
            // HALT CONDITION 1: ECALL instruction (00000073)
            if (current_instr == 32'h00000073) begin
                cycle_count = max_cycles; // Force exit
            end
            
            // HALT CONDITION 2: Invalid/HALT instruction (FFFFFFFF)
            if (current_instr == 32'hFFFFFFFF) begin
                cycle_count = max_cycles; // Force exit
            end
            
            // HALT CONDITION 3: Branch limit (for detecting infinite loops)
            if (current_instr[6:0] == 7'b1100011) begin  // B-type opcode
                branch_count = branch_count + 1;
                if (branch_count > MAX_BRANCHES) begin
                    cycle_count = max_cycles; // Force exit
                end
            end
        end
        
        if (cycle_count >= max_cycles && current_instr != 32'h00000073 && 
            current_instr != 32'hFFFFFFFF) begin
        end
        $finish();
    end

    // Monitor
    initial begin
        $monitor("t=%0t | clk=%b rst=%b MemWrite=%b WriteData=%0h DataAdr=%h",$time, clk, rst, MemWrite, WriteData, DataAdr);
    end
    
endmodule