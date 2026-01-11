`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    top_tb
// Description:    Top-Level Testbench for Fetch & Decode Stages.
//                 - Generates Clock and Reset.
//                 - Controls Sign Extension type (immsrc).
//                 - Monitors PC, Instruction, and Extended Immediate.
//////////////////////////////////////////////////////////////////////////////////

module top_tb;

    // -------------------------------------------------------------------------
    // Signal Declarations
    // -------------------------------------------------------------------------
    logic        clk;
    logic        rst;
    logic [1:0]  immsrc;
    logic [31:0] instr;
    logic [31:0] pc;
    logic [31:0] immext;

    // -------------------------------------------------------------------------
    // Simulation Variables
    // -------------------------------------------------------------------------
    integer f; // File descriptor

    // -------------------------------------------------------------------------
    // DUT Instantiation
    // -------------------------------------------------------------------------
    top dut (
        .clk(clk),
        .rst(rst),
        .immsrc(immsrc),
        .instr(instr),
        .pc(pc),
        .immext(immext)
    );

    // -------------------------------------------------------------------------
    // Clock Generation
    // -------------------------------------------------------------------------
    // Generate a clock with 10ns period (5ns high, 5ns low)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // -------------------------------------------------------------------------
    // Data Logging (Runs every clock cycle)
    // -------------------------------------------------------------------------
    // We log on negedge to ensure signals (PC, Instr) are stable and settled.
    always @(negedge clk) begin
        if (!rst) begin // Don't log during reset
            // Print to Console
            $display("Time: %0t | PC: 0x%h | Instr: 0x%h | ImmSrc: %b | ImmExt: 0x%h (%0d)", 
                     $time, pc, instr, immsrc, immext, $signed(immext));
            
            // Write to File
            $fdisplay(f, "%-8t | 0x%-8h | 0x%-8h | %b      | 0x%-8h", 
                      $time, pc, instr, immsrc, immext);
        end
    end

    // -------------------------------------------------------------------------
    // Main Test Sequence
    // -------------------------------------------------------------------------
    initial begin
        // 1. Open Log File
        f = $fopen("reports/fetch_results.txt", "w");

        if (f == 0) begin
            $display("Error: Could not open log file!");
            $finish;
        end

        // 2. Write Header to File
        $fdisplay(f, "========================================================");
        $fdisplay(f, "               FETCH STAGE SIMULATION REPORT            ");
        $fdisplay(f, "========================================================");
        $fdisplay(f, "TIME     | PC         | INSTRUCTION (Hex)               ");
        $fdisplay(f, "---------|------------|---------------------------------");

        $display("-----------------------------------------");
        $display("Starting Fetch Stage Verification...");
        $display("-----------------------------------------");

        // 3. Apply Reset
        rst = 1;
        immsrc = 2'b00; // Defult to I-Type 
        #10; // Hold reset

        // 4. Release Reset
        rst = 0;
        
        // 5. Run Simulation
        // We will change immsrc dynamicallly to test different interpretations
        
        // Time 0-30ns: Treat instructions as I-Type (00)
        immsrc = 2'b00; 
        #30; 
        
        // Time 30-60ns: Treat instructions as S-Type (01)
        immsrc = 2'b01;
        #30;

        // Time 60-90ns: Treat instructions as B-Type (10)
        immsrc = 2'b10;
        #30;

        // 6. End Simulation
        $fdisplay(f, "========================================================");
        $fdisplay(f, "Simulation Finished.");
        $fclose(f);

        $display("-----------------------------------------");
        $display("Simulation Completed. Report saved to reports/fetch_results.txt");
        $display("-----------------------------------------");
        $finish;
    end

endmodule