`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    signext
// Description:    Sign Extension Unit for RISC-V Processor.
//                 Extends the immediate field from the instruction to 32 bits.
//                 Supported Types based on 'immsrc' control:
//                 - 00: I-Type (12-bit signed) -> e.g., addi, lw
//                 - 01: S-Type (12-bit signed) -> e.g., sw
//                 - 10: B-Type (13-bit signed) -> e.g., beq
//////////////////////////////////////////////////////////////////////////////////

module signext (
    input  logic [31:0] instr,   // The full instruction
    input  logic [1:0]  immsrc,  // Selector: 00=I-Type, 01=S-Type, 10=B-Type
    output logic [31:0] immext   // The sign-extended 32-bit immediate result
);

    // -------------------------------------------------------------------------
    // Intermediate Signals (Calculate all options in parallel)
    // -------------------------------------------------------------------------
    logic [31:0] imm_i;
    logic [31:0] imm_s;
    logic [31:0] imm_b;

    // -----------------------------------------------------------------
    // 1. I-Type (Immediate)
    // Immediate is 12 bits: instr[31:20]
    // Logic: Replicate Sign bit (instr[31]) 20 times + instr[31:20]
    // -----------------------------------------------------------------
    assign imm_i = {{20{instr[31]}}, instr[31:20]};

    // -----------------------------------------------------------------
    // 2. S-Type (Store)
    // Immediate is 12 bits split: instr[31:25] (upper) + instr[11:7] (lower)
    // Logic: Replicate Sign bit 20 times + Upper 7 bits + Lower 5 bits
    // -----------------------------------------------------------------
    assign imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};

    // -----------------------------------------------------------------
    // 3. B-Type (Branch)
    // Immediate is 13 bits (bit 0 is always 0)
    // Bits are scrambled: {Sign, Bit 11, Bits 10:5, Bits 4:1, 0}
    // Logic: Replicate Sign 20 times + instr[31] + instr[7] + ... + 0
    // -----------------------------------------------------------------
    assign imm_b = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};


    // -------------------------------------------------------------------------
    // Multiplexer Logic (Select the correct one)
    // -------------------------------------------------------------------------
    always_comb begin
        case (immsrc)
            2'b00:   immext = imm_i; // Select I-Type
            2'b01:   immext = imm_s; // Select S-Type
            2'b10:   immext = imm_b; // Select B-Type
            default: immext = 32'b0;
        endcase
    end

endmodule