`timescale 1ns/1ps

/*
Alternative testbench for RISCVunicycle.sv
Tests the complete RISC-V single-cycle processor with a simple program

To compile and run:
iverilog -g2012 -o RISCVunicycle_tb.vvp src/register_file.sv src/datapath.sv src/pc_register.sv src/adder.sv src/mux21.sv src/imm_ext.sv src/alu.sv src/mux4.sv src/data_mem.sv src/instr_mem.sv src/RISCVunicycle.sv src/control_unit.sv src/maindeco.sv src/aludeco.sv testbench/RISCVunicycle_tb_alt.sv
vvp RISCVunicycle_tb.vvp
gtkwave RISCVunicycle_tb_alt.vcd
*/

module RISCVunicycle_tb;

    // Inputs
    reg        clk;
    reg        rst;
    reg [31:0] instr;
    reg [31:0] ReadData;

    // Outputs
    wire [31:0] PCreg;
    wire        MemWrite;
    wire        MemRead;
    wire [31:0] ALUResult;
    wire [31:0] WriteData;

    // Test variables
    integer cycle_count;
    integer test_num;
    integer pass_count;
    integer fail_count;
    integer i;
    reg [31:0] expected_pc;

    // Simulated instruction memory (program)
    reg [31:0] programa[0:31];
    
    // Simulated data memory
    reg [31:0] data_memory [0:63];

    // Instantiate DUT
    RISCVunicycle dut(
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .ReadData(ReadData),
        .PC(PCreg),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUResult(ALUResult),
        .WriteData(WriteData)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simulate instruction memory fetch
    always @(*) begin
        instr = programa[PCreg[31:2]]; // word-aligned fetch
    end

    // Simulate data memory (read)
    always @(*) begin
        if (MemRead) begin
            ReadData = data_memory[ALUResult[31:2]];
        end else begin
            ReadData = 32'h0;
        end
    end

    // Simulate data memory (write)
    always @(posedge clk) begin
        if (MemWrite) begin
            data_memory[ALUResult[31:2]] <= WriteData;
            $display("   [MEM WRITE] addr=%0d data=%08h", ALUResult, WriteData);
        end
    end

    // Test sequence
    initial begin
        $dumpfile("RISCVunicycle_tb.vcd");
        $dumpvars(0, RISCVunicycle_tb);

        // Initialize counters
        cycle_count = 0;
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("\n============================================");
        $display("  RISC-V SINGLE-CYCLE PROCESSOR TESTBENCH");
        $display("============================================\n");

        // Initialize program memory with a simple RISC-V program
        // Program:
        // 0:  addi x1, x0, 10      # x1 = 10
        // 4:  addi x2, x0, 20      # x2 = 20
        // 8:  add  x3, x1, x2      # x3 = x1 + x2 = 30
        // 12: sub  x4, x2, x1      # x4 = x2 - x1 = 10
        // 16: sw   x3, 0(x0)       # mem[0] = x3 = 30
        // 20: lw   x5, 0(x0)       # x5 = mem[0] = 30
        // 24: addi x6, x0, 5       # x6 = 5
        // 28: beq  x1, x6, 8       # if x1==x6, branch (should not take)
        // 32: addi x7, x0, 100     # x7 = 100
        // 36: beq  x1, x1, 8       # if x1==x1, branch (should take -> PC+8)
        // 40: addi x8, x0, 200     # x8 = 200 (should be skipped)
        // 44: addi x9, x0, 50      # x9 = 50

        programa[0]  = 32'h00A00093; // addi x1, x0, 10
        programa[1]  = 32'h01400113; // addi x2, x0, 20
        programa[2]  = 32'h002081B3; // add  x3, x1, x2
        programa[3]  = 32'h40110233; // sub  x4, x2, x1
        programa[4]  = 32'h00302023; // sw   x3, 0(x0)
        programa[5]  = 32'h00002283; // lw   x5, 0(x0)
        programa[6]  = 32'h00500313; // addi x6, x0, 5
        programa[7]  = 32'h00608463; // beq  x1, x6, 8
        programa[8]  = 32'h06400393; // addi x7, x0, 100
        programa[9]  = 32'h00108463; // beq  x1, x1, 8
        programa[10] = 32'h0C800413; // addi x8, x0, 200
        programa[11] = 32'h03200493; // addi x9, x0, 50

        // Fill rest with nops
        for (i = 12; i < 32; i = i + 1) begin
            programa[i] = 32'h00000013; // addi x0, x0, 0 (nop)
        end

        // Initialize data memory
        for (i = 0; i < 64; i = i + 1) begin
            data_memory[i] = 32'h0;
        end

        // Reset sequence
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        $display("Program loaded. Starting execution...\n");

        //==============================================
        // Execute program and track progress
        //==============================================
        
        // Cycle 1: addi x1, x0, 10
        cycle_count++;
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("   addi x1, x0, 10");
        
        // Cycle 2: addi x2, x0, 20
        @(posedge clk);
        cycle_count++;
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("   addi x2, x0, 20");
        
        // Cycle 3: add x3, x1, x2
        @(posedge clk);
        cycle_count++;
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("   add x3, x1, x2");
        test_num++;
        if (ALUResult == 32'h1E) begin
            $display("   PASS: x3 = %0d (expected 30)\n", ALUResult);
            pass_count++;
        end else begin
            $display("   FAIL: x3 = %0d (expected 30)\n", ALUResult);
            fail_count++;
        end

        // Cycle 4: sub x4, x2, x1
        @(posedge clk);
        cycle_count++;
        $display(ALUResult);
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("sub x4, x2, x1");
        test_num++;
        if (ALUResult == 32'hA) begin
            $display("   PASS: x4 = %0d (expected 10)\n", ALUResult);
            pass_count++;
        end else begin
            $display("   FAIL: x4 = %0d (expected 10)\n", ALUResult);
            fail_count++;
        end
        
        // Cycle 5: sw x3, 0(x0)
        @(posedge clk);
        cycle_count++;
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("   sw x3, 0(x0)");
        test_num++;
        if (MemWrite && ALUResult == 0) begin
            $display("   PASS: Store to address %0d\n", ALUResult);
            pass_count++;
        end else begin
            $display("   FAIL: Store operation failed\n");
            fail_count++;
        end
        
        // Cycle 6: lw x5, 0(x0)
        @(posedge clk);
        cycle_count++;
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("   lw x5, 0(x0)");
        test_num++;
        if (MemRead && ALUResult == 0 && ReadData == 30) begin
            $display("   PASS: Load from address %0d, data=%0d\n", ALUResult, ReadData);
            pass_count++;
        end else begin
            $display("   FAIL: Load operation failed (ReadData=%0d)\n", ReadData);
            fail_count++;
        end
        
        // Cycle 7: addi x6, x0, 5
        @(posedge clk);
        cycle_count++;
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("   addi x6, x0, 5\n");
        
        // Cycle 8: beq x1, x6, 8 (should NOT branch: x1=10, x6=5)
        @(posedge clk);
        cycle_count++;
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("   beq x1, x6, 8");
        @(posedge clk);
        test_num++;
        expected_pc = 32;
        if (PCreg == expected_pc) begin
            $display("   PASS: Branch not taken, PC=%0d (expected %0d)\n", PCreg, expected_pc);
            pass_count++;
        end else begin
            $display("   FAIL: PC=%0d (expected %0d)\n", PCreg, expected_pc);
            fail_count++;
        end
        
        // Cycle 9: addi x7, x0, 100
        cycle_count++;
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("   addi x7, x0, 100\n");
        
        // Cycle 10: beq x1, x1, 8 (should branch: x1==x1)
        @(posedge clk);
        cycle_count++;
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("   beq x1, x1, 8");
        @(posedge clk);
        test_num++;
        expected_pc = 44; // 36 + 8
        if (PCreg == expected_pc) begin
            $display("   PASS: Branch taken, PC=%0d (expected %0d)\n", PCreg, expected_pc);
            pass_count++;
        end else begin
            $display("   FAIL: PC=%0d (expected %0d)\n", PCreg, expected_pc);
            fail_count++;
        end
        
        // Cycle 11: addi x9, x0, 50 (after branch, skipped x8 instruction)
        cycle_count++;
        $display("Cycle %0d: PC=%0d", cycle_count, PCreg);
        $display("   addi x9, x0, 50\n");
        
        //==============================================
        // Summary
        //==============================================
        $display("============================================");
        $display("  TEST SUMMARY");
        $display("============================================");
        $display("  Total cycles executed: %0d", cycle_count);
        $display("  Total tests: %0d", test_num);
        $display("  PASS: %0d", pass_count);
        $display("  FAIL: %0d", fail_count);
        $display("============================================\n");
        $finish;
    end

endmodule
