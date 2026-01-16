/*
module imm_ext
Immediate Extension module for RISC-V processor

instr      [input]  32-bit instruction
ImmSrc     [input]  3-bit immediate source selection signal
ImmExt     [output] 32-bit sign-extended immediate value
*/

module imm_ext (
    input  wire [31:0] instr,
    input  wire [2:0]  ImmSrc,
    output reg  [31:0] ImmExt
);

    //Extend Immediate based on instruction type
    //ImmSrc selects the instruction type
    always @(*) begin
        case (ImmSrc)
            3'b000: ImmExt = {{20{instr[31]}}, instr[31:20]}; //I-Type
            3'b001: ImmExt = {{20{instr[31]}}, instr[31:25], instr[11:7]}; //S-Type
            3'b010: ImmExt = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; //B-Type
            3'b011: ImmExt = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; //J-Type
            3'b100: ImmExt = instr[31:12] << 12; //lui
            default: ImmExt = 32'bx;
        endcase
    end
    
endmodule
