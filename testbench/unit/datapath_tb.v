`timescale 1ns/1ps

/*
To compile and run:
iverilog -g2012 -o datapath_tb.vvp src/register_file.sv src/datapath.sv src/pc_register.sv src/adder.sv src/mux21.sv src/imm_ext.sv src/alu.sv src/mux4.sv testbench/datapath_tb.sv
vvp datapath_tb.vvp
*/

module datapath_tb;

    // Inputs
    reg        clk;
    reg        rst;
    reg [31:0] instr;
    reg        PCSrc;
    reg [1:0]  ResultSrc;
    reg        ALUSrc;
    reg [2:0]  ImmSrc;
    reg        RegWrite;
    reg [3:0]  ALUControl;
    reg [31:0] ReadData;

    // Outputs
    wire [31:0] PC;
    wire        zero;
    wire        comparison;
    wire [31:0] ALUResult;
    wire [31:0] WriteData;

    // Test variables
    integer test_num;
    integer pass_count;
    integer fail_count;
    reg [31:0] prev_pc;

    // Instantiate DUT
    datapath dut(
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .ReadData(ReadData),
        .PC(PC),
        .zero(zero),
        .comparison(comparison),
        .ALUResult(ALUResult),
        .WriteData(WriteData)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars(0, datapath_tb);

        // Initialize counters
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("\n========================================");
        $display("  DATAPATH TESTBENCH - Alternative");
        $display("========================================\n");

        // Initialize signals
        rst = 1;
        instr = 32'h0;
        PCSrc = 0;
        ResultSrc = 2'b00;
        ALUSrc = 0;
        ImmSrc = 3'b000;
        RegWrite = 0;
        ALUControl = 4'b0000;
        ReadData = 32'h0;

        // Reset sequence
        @(posedge clk);
        #1;
        rst = 0;

        //==============================================
        // TEST 1: R-type ADD (x1 = x2 + x3)
        // Instruction format: add x1, x2, x3
        // Assumes x2=5, x3=10 (we'll simulate by loading them)
        //==============================================
        test_num = 1;
        $display("TEST %0d: R-type ADD instruction ADD (x1 = x2 + x3)", test_num);
        
        // First write 5 to register x2 (using immediate add: addi x2, x0, 5)
        @(posedge clk);
        instr = {12'd5, 5'd0, 3'b000, 5'd2, 7'b0010011}; // addi x2, x0, 5
        RegWrite = 1;
        ALUSrc = 1;    // use immediate
        ImmSrc = 3'b000; // I-type
        ALUControl = 4'b0000; // ADD
        ResultSrc = 2'b00; // ALU result
        PCSrc = 0;
        @(posedge clk);
        #10;
        $display("   addi x2, x0, 5");

        // Write 10 to register x3 (addi x3, x0, 10)
        @(posedge clk);
        instr = {12'd10, 5'd0, 3'b000, 5'd3, 7'b0010011}; // addi x3, x0, 10
        @(posedge clk);
        #10;
        $display("   addi x3, x0, 10");

        // Now perform: add x1, x2, x3 (x1 = x2 + x3 = 5 + 10 = 15)
        @(posedge clk);
        instr = {7'd0, 5'd3, 5'd2, 3'b000, 5'd1, 7'b0110011}; // add x1, x2, x3
        ALUSrc = 0;    // use register
        ALUControl = 4'b0000; // ADD
        ResultSrc = 2'b00;
        RegWrite = 1;
        @(posedge clk);
        #10;
        $display("   add x1, x2, x3");
        if (ALUResult == 15) begin
            $display("  PASS: x1 = x2 + x3 = %0d (expected 15)\n", ALUResult);
            pass_count++;
        end else begin
            $display("  FAIL: x1 = %0d (expected 15)\n", ALUResult);
            fail_count++;
        end

        //==============================================
        // TEST 2: R-type SUB (x4 = x2 - x3)
        //==============================================
        test_num = 2;
        $display("TEST %0d: R-type SUB instruction SUB (x4 = x2 - x3)", test_num);
        
        @(posedge clk);
        instr = {7'd32, 5'd3, 5'd2, 3'b000, 5'd4, 7'b0110011}; // sub x4, x2, x3
        ALUSrc = 0;
        ALUControl = 4'b0001; // SUB
        ResultSrc = 2'b00;
        RegWrite = 1;
        @(posedge clk);
        #10;
        $display("   sub x4, x2, x3");
        if (ALUResult == -5) begin
            $display("  PASS: x4 = x2 - x3 = %0d (expected -5)\n", ALUResult);
            pass_count++;
        end else begin
            $display("  FAIL: x4 = %0d (expected -5)\n", ALUResult);
            fail_count++;
        end

        //==============================================
        // TEST 3: I-type ADDI with negative immediate
        // addi x5, x2, -3  (x5 = 5 + (-3) = 2)
        //==============================================
        test_num = 3;
        $display("TEST %0d: I-type ADDI with negative immediate (x5 = x2 + (-3))", test_num);
        
        @(posedge clk);
        instr = {12'hFFD, 5'd2, 3'b000, 5'd5, 7'b0010011}; // addi x5, x2, -3
        ALUSrc = 1;
        ImmSrc = 3'b000; // I-type
        ALUControl = 4'b0000; // ADD
        ResultSrc = 2'b00;
        RegWrite = 1;
        @(posedge clk);
        #10;
        $display("   addi x5, x2, -3");
        if (ALUResult == 2) begin
            $display("  PASS: x5 = x2 + (-3) = %0d (expected 2)\n", ALUResult);
            pass_count++;
        end else begin
            $display("  FAIL: x5 = %0d (expected 2)\n", ALUResult);
            fail_count++;
        end

        //==============================================
        // TEST 4: Load instruction simulation (LW)
        // lw x6, 0(x2) - load from memory address in x2
        //==============================================
        test_num = 4;
        $display("TEST %0d: Load Word LW (x6 = mem[x2 + 0])", test_num);
        
        @(posedge clk);
        ReadData = 32'hDEADBEEF; // simulate memory read
        instr = {12'd0, 5'd2, 3'b010, 5'd6, 7'b0000011}; // lw x6, 0(x2)
        ALUSrc = 1;
        ImmSrc = 3'b000; // I-type
        ALUControl = 4'b0000; // ADD for address calculation
        ResultSrc = 2'b01; // select ReadData
        RegWrite = 1;
        @(posedge clk);
        #10;
        $display("   lw x6, 0(x2)");
        // Check that address calculation is correct (should be x2 + 0 = 5)
        if (ALUResult == 5) begin
            $display("  PASS: Load address = %0d (expected 5)", ALUResult);
            pass_count++;
        end else begin
            $display("  FAIL: Load address = %0d (expected 5)", ALUResult);
            fail_count++;
        end
        $display("  Memory data loaded: %08h\n", ReadData);

        //==============================================
        // TEST 5: PC increment (verify PC+4)
        //==============================================
        test_num = 5;
        $display("TEST %0d: PC increment (PC = PC + 4)", test_num);
        
        prev_pc = PC;
        @(posedge clk);
        PCSrc = 0; // select PC+4
        RegWrite = 0;
        #10;
        if (PC == prev_pc + 4) begin
            $display("  PASS: PC incremented by 4 (%0d -> %0d)\n", prev_pc, PC);
            pass_count++;
        end else begin
            $display("  FAIL: PC = %0d (expected %0d)\n", PC, prev_pc + 4);
            fail_count++;
        end

        //==============================================
        // TEST 6: Branch target calculation (B-type)
        // beq x2, x3, offset (PC + offset)
        //==============================================
        test_num = 6;
        #10;
        $display("TEST %0d: Branch target BEQ (PC = PC + offset)", test_num);
        
        @(posedge clk);
        prev_pc = PC;
        instr = {7'd0, 5'd3, 5'd2, 3'b000, 5'd8, 7'b1100011}; // beq with offset=16
        PCSrc = 1; // take branch
        ImmSrc = 3'b010; // B-type
        @(posedge clk);
        #10;
        $display("   beq x2, x3, 16");
        // Branch target should be PC + sign_extended_offset
        $display("  Branch taken: PC = %0d (previous PC = %0d)\n", PC, prev_pc);

        //==============================================
        // TEST 7: Zero flag test
        // Subtract equal values: x2 - x2 should set zero=1
        //==============================================
        test_num = 7;
        #10;
        $display("TEST %0d: Zero flag SUB (x7 = x2 - x2, zero flag check)", test_num);
        
        @(posedge clk);
        instr = {7'd32, 5'd2, 5'd2, 3'b000, 5'd7, 7'b0110011}; // sub x7, x2, x2
        ALUSrc = 0;
        ALUControl = 4'b0001; // SUB
        ResultSrc = 2'b00;
        RegWrite = 1;
        PCSrc = 0;
        @(posedge clk);
        #1;
        $display("   sub x7, x2, x2");
        if (zero == 1 && ALUResult == 0) begin
            #10;
            $display("  PASS: zero flag = %0d, ALUResult = %0d\n", zero, ALUResult);
            pass_count++;
        end else begin
            #10;
            $display("  FAIL: zero flag = %0d, ALUResult = %0d (expected zero=1, result=0)\n", zero, ALUResult);
            fail_count++;
        end

        //==============================================
        // TEST 8: Store Word (SW) then Load Word (LW)
        // Store x1 (=15 from TEST 1) to memory, then load it back to x8
        // sw x1, 0(x2)  - store x1 to memory address x2
        // lw x8, 0(x2)  - load from memory address x2 to x8
        //==============================================
        test_num = 8;
        #10;
        $display("TEST %0d: Store Word then Load Word (x1 -> mem -> x8)", test_num);
        
        // Store x1 (which contains 15 from TEST 1) to memory at address x2 (=5)
        @(posedge clk);
        instr = {7'd0, 5'd1, 5'd2, 3'b010, 5'd0, 7'b0100011}; // sw x1, 0(x2)
        ALUSrc = 1;    // use immediate for address calculation
        ImmSrc = 3'b001; // S-type
        ALUControl = 4'b0000; // ADD for address
        ResultSrc = 2'b00;
        RegWrite = 0;  // no register write for store
        PCSrc = 0;
        @(posedge clk);
        #10;
        $display("   sw x1, 0(x2)      Store x1=%0d to address=%0d", WriteData, ALUResult);
        
        // Now load from the same address back to x8
        @(posedge clk);
        ReadData = WriteData; // simulate memory returning the stored value
        instr = {12'd0, 5'd2, 3'b010, 5'd8, 7'b0000011}; // lw x8, 0(x2)
        ALUSrc = 1;
        ImmSrc = 3'b000; // I-type
        ALUControl = 4'b0000; // ADD for address
        ResultSrc = 2'b01; // select ReadData
        RegWrite = 1;
        @(posedge clk);
        #10;
        $display("   lw x8, 0(x2)      Load from address=%0d", ALUResult);
        
        // Verify that ReadData matches the original x1 value (15)
        if (ReadData == 15) begin
            $display("  PASS: Loaded value = %0d (expected 15 from x1)\n", ReadData);
            pass_count++;
        end else begin
            $display("  FAIL: Loaded value = %0d (expected 15)\n", ReadData);
            fail_count++;
        end

        //==============================================
        // Summary
        //==============================================
        #20;
        $display("========================================");
        $display("  TEST SUMMARY");
        $display("========================================");
        $display("  Total tests: %0d", test_num);
        $display("  PASS: %0d", pass_count);
        $display("  FAIL: %0d", fail_count);
        $display("========================================\n");

        $finish;
    end

endmodule
