/*
module top
Top-level module containing RISC-V processor and memories

clk        [input]  Clock signal
rst        [input]  Reset signal
MemWrite   [output] Memory write enable signal
MemRead    [output] Memory read enable signal
WriteData  [output] 32-bit data to write to memory
DataAdr    [output] 32-bit data address
*/
module top (
    input  wire        clk,
    input  wire        rst,
    output wire        MemWrite,
    output wire        MemRead,
    output wire [31:0] WriteData,
    output wire [31:0] DataAdr
);

    //Main Signals
    wire [31:0] PCreg;
    wire [31:0] instr;
    wire [31:0] ReadData;

    //Processor Control
    RISCVunicycle rv_unicycle(
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .ReadData(ReadData),
        .PC(PCreg),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUResult(DataAdr),
        .WriteData(WriteData)
    );

    //Instruction Memory
    instr_mem instr_mem(
        .a(PCreg),
        .rd(instr)
    );

    //Data Memory
    data_mem data_mem(
        .clk(clk),
        .we(MemWrite),
        .en(MemRead),
        .a(DataAdr),
        .wd(WriteData),
        .rd(ReadData)
    );
    
endmodule