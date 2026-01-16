/*
module mux4
4-to-1 multiplexer for RISC-V processor

d0, d1, d2, d3 [input]  32-bit data inputs
sel            [input]  2-bit selection signal
out            [output] 32-bit selected output
*/

module mux4 (
    input  wire [31:0] d0,
    input  wire [31:0] d1,
    input  wire [31:0] d2,
    input  wire [31:0] d3,
    input  wire [1:0]  sel,
    output wire [31:0] out
);

    //MUX 4:1
    assign out = (sel[1]) ? ((sel[0]) ? d3 : d2) : ((sel[0]) ? d1 : d0);
    
endmodule