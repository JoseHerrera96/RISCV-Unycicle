/*
module adder
Simple 32-bit signed adder
 
ina [input]  32-bit signed input A
inb [input]  32-bit signed input B
out [output] 32-bit signed sum (ina + inb)
 */


module adder (
    input  wire signed [31:0] ina,
    input  wire signed [31:0] inb,
    output wire signed [31:0] out
);

    //Simple Adder
    assign out = ina + inb;

endmodule