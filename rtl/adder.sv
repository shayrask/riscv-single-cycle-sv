`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    adder
// Description:    32-bit Combinational Adder.
//                 Used for calculating next PC address (PC+4) and branch targets.
//////////////////////////////////////////////////////////////////////////////////

module adder (
    input  logic [31:0] a,  // First operand
    input  logic [31:0] b,  // Second operand
    output logic [31:0] y   // Sum result
);

    // Perform 32-bit addition
    assign y = a + b;

endmodule