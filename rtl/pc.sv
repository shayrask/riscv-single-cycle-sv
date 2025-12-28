`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    pc
// Description:    Program Counter (PC) Register.
//                 Holds the address of the current instruction.
//                 Resets to 0x00000000 on active-high reset.
//////////////////////////////////////////////////////////////////////////////////

module pc (
    input  logic        clk,     // System Clock
    input  logic        rst,     // Active High Reset
    input  logic [31:0] pc_next, // Next Program Counter value
    output logic [31:0] pc       // Current Program Counter value
);

    // -------------------------------------------------------------------------
    // PC Register Update Logic
    // -------------------------------------------------------------------------
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Asynchronous Reset: Clear PC to 0
            pc <= 32'b0;
        end 
        else begin
            // Synchronous Update: Load next address
            pc <= pc_next;
        end
    end

endmodule