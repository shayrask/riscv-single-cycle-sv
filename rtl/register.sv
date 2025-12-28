`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    regfile
// Description:    32x32 Register File.
//                 - 32 General Purpose Registers (32-bit wide).
//                 - 2 Asynchronous Read Ports (rd1, rd2).
//                 - 1 Synchronous Write Port (wd3).
//                 - Register 0 (x0) is hardwired to 0.
//////////////////////////////////////////////////////////////////////////////////

module regfile (
    input  logic        clk,    // Clock
    input  logic        we3,    // Write Enable
    input  logic [4:0]  a1,     // Read Address 1
    input  logic [4:0]  a2,     // Read Address 2
    input  logic [4:0]  a3,     // Write Address
    input  logic [31:0] wd3,    // Write Data
    output logic [31:0] rd1,    // Read Data 1 output
    output logic [31:0] rd2     // Read Data 2 output
);

    // -------------------------------------------------------------------------
    // Register Storage Declaration
    // -------------------------------------------------------------------------
    logic [31:0] rf [31:0];

    // -------------------------------------------------------------------------
    // Write Logic (Synchronous)
    // -------------------------------------------------------------------------
    always_ff @(posedge clk) begin  
        if (we3) begin
             // Prevent writing to Register 0 (x0)
             if (a3 != 5'b0) begin
                rf[a3] <= wd3;
             end 
             else begin
                // Simulation warning for illegal write attempt
                $display("Time: %0t | WARNING: Attempt to write to Register 0 (x0). Write ignored.", $time);
             end 
        end
    end

    // -------------------------------------------------------------------------
    // Read Logic (Asynchronous)
    // -------------------------------------------------------------------------
    assign rd1 = (a1 == 5'b0) ? 32'b0 : rf[a1];
    assign rd2 = (a2 == 5'b0) ? 32'b0 : rf[a2];

endmodule