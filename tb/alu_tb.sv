`timescale 1ns / 1ps

module alu_tb;

    // -------------------------------------------------------------------------
    // Signal Declarations
    // -------------------------------------------------------------------------
    logic [31:0] SrcA, SrcB;
    logic [3:0]  ALUControl;
    logic [31:0] ALUResult;
    logic        Zero;

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
    // Test Stimulus
    // -------------------------------------------------------------------------
    initial begin
        $display("-----------------------------------------");
        $display("Starting ALU Verification Simulation");
        $display("-----------------------------------------");

        // --- Test Case 1: ADD Operation ---
        SrcA = 32'd10;
        SrcB = 32'd20;
        ALUControl = 4'b0000;   // ADD
        #10;                    // Wait for combinational logic to settle
        
        // Self-Checking
        if (ALUResult === 32'd30) 
            $display("[PASS] Test 1: ADD (10 + 20 = 30)");
        else 
            $display("[FAIL] Test 1: ADD. Expected 30, got %d", ALUResult);


        // --- Test Case 2: SUB Operation ---
        SrcA = 32'd100;
        SrcB = 32'd40;
        ALUControl = 4'b0001;   // SUB
        #10;

        if (ALUResult === 32'd60) 
            $display("[PASS] Test 2: SUB (100 - 40 = 60)");
        else 
            $display("[FAIL] Test 2: SUB. Expected 60, got %d", ALUResult);


        // --- Test Case 3: XOR Operation ---
        SrcA = 32'hF0F0F0F0;
        SrcB = 32'hFFFF0000;
        ALUControl = 4'b0100;   // XOR
        #10;

        if (ALUResult === 32'h0F0FF0F0) 
            $display("[PASS] Test 3: XOR (Bitwise check)");
        else 
            $display("[FAIL] Test 3: XOR. Expected 0F0FF0F0, got %h", ALUResult);


        // --- Test Case 4: Shift Left Logical (SLL) ---
        SrcA = 32'b0000_0001;   // 1
        SrcB = 32'd4;           // Shift by 4
        ALUControl = 4'b0101;   // SLL
        #10;

        if (ALUResult === 32'b0001_0000) // 16
            $display("[PASS] Test 4: SLL (1 << 4 = 16)");
        else 
            $display("[FAIL] Test 4: SLL. Expected 16, got %d", ALUResult);


        // End Simulation
        $display("-----------------------------------------");
        $display("Simulation Completed.");
        $display("-----------------------------------------");
        $finish;
    end

endmodule