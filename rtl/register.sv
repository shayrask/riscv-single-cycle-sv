`timescale 1ns / 1ps

module regfile (
    input  logic        clk,    // Clock
    input  logic        we3,    // Write Enable (Active High)
    input  logic [4:0]  a1,     // Read Address 1 (Source A)
    input  logic [4:0]  a2,     // Read Address 2 (Source B)
    input  logic [4:0]  a3,     // Write Address (Destination)
    input  logic [31:0] wd3,    // Write Data
    output logic [31:0] rd1,    // Read Data 1
    output logic [31:0] rd2     // Read Data 2
);

    // -------------------------------------------------------------------------
    // 1. Register File Storage Declaration
    // -------------------------------------------------------------------------
    // 32 registers, each 32-bit wide
    logic [31:0] rf [31:0];

    // -------------------------------------------------------------------------
    // 2. Write Process (Sequential Logic)
    // -------------------------------------------------------------------------
    always_ff @(posedge clk) begin  
        if (we3) begin
             if (a3 != 0) begin
                rf[a3] <= wd3;
             end 
             else begin
                $display("Time: %0t | WARNING: Attempt to write to Register 0 (x0). Write ignored.", $time);
                // $error("Time: %0t | ERROR: Illegal write to x0 detected!", $time);
             end 
        end
    end

    // -------------------------------------------------------------------------
    // 3. Read Process (Combinational Logic)
    // -------------------------------------------------------------------------
    assign rd1 = (a1 == 5'b0) ? 32'b0 : rf[a1];
    assign rd2 = (a2 == 5'b0) ? 32'b0 : rf[a2];

endmodule