`timescale 1ns / 1ps

module alu (
    input  logic [31:0] SrcA,       // Operand A
    input  logic [31:0] SrcB,       // Operand B
    input  logic [3:0]  ALUControl, // Operation selector
    output logic [31:0] ALUResult,  // The result
    output logic        Zero        // Zero Flag
);

    always_comb begin
        // Default assignment to prevent latches
        ALUResult = 32'b0;

        case (ALUControl)
            4'b0000: ALUResult = SrcA + SrcB;       // ADD
            4'b0001: ALUResult = SrcA - SrcB;       // SUB
            4'b0010: ALUResult = SrcA & SrcB;       // AND
            4'b0011: ALUResult = SrcA | SrcB;       // OR
            
            // TODO: Complete the missing operations using SrcA and SrcB
            4'b0100: ALUResult = ... ;              // XOR (Use ^)
            4'b0101: ALUResult = ... ;              // SLL (Shift Left Logical <<)
            4'b0110: ALUResult = ... ;              // SRL (Shift Right Logical >>)

            default: ALUResult = 32'b0;
        endcase
    end

    // Zero flag is 1 if ALUResult is 0
    assign Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;

endmodule