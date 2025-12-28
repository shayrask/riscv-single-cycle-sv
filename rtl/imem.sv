`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    imem
// Description:    Instruction Memory (ROM).
//                 - Stores program instructions loaded from "memfile.dat".
//                 - Word-aligned addressing (ignores 2 LSBs of input address).
//////////////////////////////////////////////////////////////////////////////////

module imem (
    input  logic [31:0] a,  // Address input (Byte address)
    output logic [31:0] rd  // Read Data output (Instruction)
);

    // -------------------------------------------------------------------------
    // Memory Array Definition
    // -------------------------------------------------------------------------
    // 64 words, each 32-bit wide
    logic [31:0] RAM [63:0];

    // -------------------------------------------------------------------------
    // Initialization
    // -------------------------------------------------------------------------
    initial begin
        // Load memory content from external hex file
        $readmemh("memfile.dat", RAM);
    end

    // -------------------------------------------------------------------------
    // Read Logic
    // -------------------------------------------------------------------------
    // Address is byte-aligned, but memory is word-aligned.
    // Shift right by 2 (divide by 4) to map byte address to word index.
    assign rd = RAM[a[7:2]];

endmodule