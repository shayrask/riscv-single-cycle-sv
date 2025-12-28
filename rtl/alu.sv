`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    alu
// Description:    Arithmetic Logic Unit (ALU).
//                 Performs arithmetic and logical operations based on ALUControl.
//                 Generates a Zero flag output for branch decisions.
//////////////////////////////////////////////////////////////////////////////////

module alu (
    input  logic [31:0] SrcA,       // Input A
    input  logic [31:0] SrcB,       // Input B
    input  logic [3:0]  ALUControl, // Operation Control Code
    output logic [31:0] ALUResult,  // ALU Output Result
    output logic        Zero        // Zero Flag (1 if ALUResult == 0)
);

    // -------------------------------------------------------------------------
    // ALU Core Logic
    // -------------------------------------------------------------------------
    always_comb begin
        // Default assignment to avoid latches
        ALUResult = 32'b0;

        case (ALUControl)
            4'b0000: ALUResult = SrcA + SrcB;        // ADD
            4'b0001: ALUResult = SrcA - SrcB;        // SUB
            4'b0010: ALUResult = SrcA & SrcB;        // AND
            4'b0011: ALUResult = SrcA | SrcB;        // OR
            4'b0100: ALUResult = SrcA ^ SrcB;        // XOR
            4'b0101: ALUResult = SrcA << SrcB[4:0];  // SLL (Shift Left Logical)
            4'b0110: ALUResult = SrcA >> SrcB[4:0];  // SRL (Shift Right Logical)
            default: ALUResult = 32'b0;              // Default case
        endcase
    end

    // -------------------------------------------------------------------------
    // Output Flag Generation
    // -------------------------------------------------------------------------
    assign Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;

endmodule