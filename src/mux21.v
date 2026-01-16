/*
module mux21
2-to-1 multiplexer for RISC-V processor

ina, inb       [input]  32-bit data inputs
sel            [input]  1-bit selection signal
out            [output] 32-bit selected output
*/
module mux21 (
    input  wire sel,
    input  wire [31:0] ina,
    input  wire [31:0] inb,
    output wire [31:0] out
);

    //MUX 2:1
    assign out = (sel) ? inb : ina;

endmodule