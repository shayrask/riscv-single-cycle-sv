`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    top
// Description:    Top-Level Processor Module (RISC-V Single Cycle).
//                 Integrates the Datapath components:
//                 - PC (Program Counter)
//                 - Adder (PC + 4)
//                 - Instruction Memory (IMEM)
//                 - Sign Extension Unit
//////////////////////////////////////////////////////////////////////////////////

module top (
    input  logic        clk,
    input  logic        rst,
    input  logic [1:0]  immsrc,  // Temporary Control Signal for Sign Extension

    output logic [31:0] instr,   // Visible instruction for debugging
    output logic [31:0] pc,      // Debug: Current Program Counter
    output logic [31:0] immext   // Debug: Sign Extended Immediate
);

    // -------------------------------------------------------------------------
    // Internal Signals
    // -------------------------------------------------------------------------
    logic [31:0] pc_next;    // Output of Adder, Input to PC
    logic [31:0] pc_current; // Output of PC, Input to IMEM and Adder

    // -------------------------------------------------------------------------
    // Fetch Stage Instantiation
    // -------------------------------------------------------------------------

    // 1. Program Counter Register
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc_current)
    );

    // 2. PC Adder (Calculates PC + 4)
    adder pc_adder (
        .a(pc_current),
        .b(32'd4),       // Constant increment by 4
        .y(pc_next)
    );

    // 3. Instruction Memory
    imem imem_inst (
        .a(pc_current),
        .rd(instr)       // Output instruction
    );

    // -------------------------------------------------------------------------
    // Decode Stage Instantiation
    // -------------------------------------------------------------------------

    // 4. Sign Extension Unit
    signext signext_inst (
        .instr(instr),     // Input: Full Instruction
        .immsrc(immsrc),   // Input: Control Signal (I-Type/S-Type/B-Type)
        .immext(immext)   // Output: Extended 32-bit Immediate
    );

    // -------------------------------------------------------------------------
    // Output Assignments
    // -------------------------------------------------------------------------
    assign pc = pc_current;

endmodule