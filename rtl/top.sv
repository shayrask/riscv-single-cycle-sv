`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    top
// Description:    Top-Level Processor Module.
//                 Connects the Fetch stage components: PC, Adder, and IMEM.
//////////////////////////////////////////////////////////////////////////////////

module top (
    input  logic        clk,
    input  logic        rst,
    output logic [31:0] instr,   // Visible instruction for debugging
    output logic [31:0] pc       // Visible PC for debugging
);

    // -------------------------------------------------------------------------
    // Internal Signals
    // -------------------------------------------------------------------------
    logic [31:0] pc_next;   // Output of Adder, Input to PC
    logic [31:0] pc_current; // Output of PC, Input to IMEM and Adder

    // -------------------------------------------------------------------------
    // Component Instantiation (Fetch Stage)
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
    // Debug Outputs
    // -------------------------------------------------------------------------
    assign pc = pc_current;

endmodule