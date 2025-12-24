`timescale 1ns / 1ps

module alu_tb;

    // -------------------------------------------------------------------------
    // Signal Declarations
    // -------------------------------------------------------------------------
    logic [31:0] SrcA, SrcB;
    logic [3:0]  ALUControl;
    logic [31:0] ALUResult;
    logic        Zero;

    // Simulation Variables
    integer f;              // File descriptor
    integer pass_count = 0; // Counter for passed tests
    integer fail_count = 0; // Counter for failed tests

    // -------------------------------------------------------------------------
    // DUT Instantiation
    // -------------------------------------------------------------------------
    alu dut (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // -------------------------------------------------------------------------
    // Task: Verify Operation
    // Purpose: Automates checking, printing to console, and logging to file
    // -------------------------------------------------------------------------
    task verify_op(
        input string test_name,
        input [31:0] expected_val
    );
        begin
            // Wait for combinational logic to settle
            #10;

            // Check Result
            if (ALUResult === expected_val) begin
                pass_count++;
                // Print to Console
                $display("[PASS] %s   | A:0x%h B:0x%h Op:%b | Res:0x%h", 
                         test_name, SrcA, SrcB, ALUControl, ALUResult);
                
                // Write to File
                $fdisplay(f, "PASS   | %-15s | Inputs: A=%h, B=%h, Op=%b | Expected: %h | Actual: %h", 
                          test_name, SrcA, SrcB, ALUControl, expected_val, ALUResult);
            end else begin
                fail_count++;
                // Print to Console
                $display("[FAIL] %s   | Expected:0x%h Got:0x%h", test_name, expected_val, ALUResult);
                
                // Write to File
                $fdisplay(f, "FAIL   | %-15s | Inputs: A=%h, B=%h, Op=%b | Expected: %h | Actual: %h", 
                          test_name, SrcA, SrcB, ALUControl, expected_val, ALUResult);
            end
        end
    endtask

    // -------------------------------------------------------------------------
    // Main Test Stimulus
    // -------------------------------------------------------------------------
    initial begin

        // 1. Open Log File
        // We use "a" so we will be in APPEND mode
        f = $fopen("reports/alu_results.txt", "a");

        if (f == 0) begin
            $display("Error: Could not open log file!");
            $finish;
        end
        
        // 2. Write Header to File (Appended after date)
        $fdisplay(f, "==================================================================================");
        $fdisplay(f, "                        ALU SIMULATION REPORT");
        $fdisplay(f, "==================================================================================");
        $fdisplay(f, "STATUS | TEST NAME       | DETAILS                                        ");
        $fdisplay(f, "-------|-----------------|--------------------------------------------------------");

        $display("-----------------------------------------");
        $display("Starting ALU Verification...");
        $display("-----------------------------------------");

        // --- Test Case 1: ADD ---
        SrcA = 32'd10; SrcB = 32'd20; ALUControl = 4'b0000;
        verify_op("ADD_OP", 32'd30);

        // --- Test Case 2: SUB ---
        SrcA = 32'd100; SrcB = 32'd40; ALUControl = 4'b0001;
        verify_op("SUB_OP", 32'd60);

        // --- Test Case 3: XOR ---
        SrcA = 32'hF0F0F0F0; SrcB = 32'hFFFF0000; ALUControl = 4'b0100;
        verify_op("XOR_OP", 32'h0F0FF0F0);

        // --- Test Case 4: SLL ---
        SrcA = 32'b0000_0001; SrcB = 32'd4; ALUControl = 4'b0101;
        verify_op("SLL_OP", 32'd16);

        // --- Test Case 5: SRL (Shift Right) - NEW ---
        SrcA = 32'd32; SrcB = 32'd2; ALUControl = 4'b0110;
        verify_op("SRL_OP", 32'd8);

        
        // 3. Write Summary to File
        $fdisplay(f, "----------------------------------------------------------------------------------");
        $fdisplay(f, "SUMMARY:");
        $fdisplay(f, "Total Tests: %0d", pass_count + fail_count);
        $fdisplay(f, "Passed:      %0d", pass_count);
        $fdisplay(f, "Failed:      %0d", fail_count);
        $fdisplay(f, "==================================================================================");

        // Close File
        $fclose(f);

        $display("-----------------------------------------");
        $display("Simulation Completed. Report saved to reports/alu_results.txt");
        $display("-----------------------------------------");
        $finish;
    end

endmodule