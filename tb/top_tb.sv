`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    top_tb
// Description:    Top-Level Testbench for the Instruction Fetch Stage.
//                 - Generates Clock and Reset signals.
//                 - Instantiates the processor (top).
//                 - Monitors PC and Instruction output to verify program flow.
//////////////////////////////////////////////////////////////////////////////////

module top_tb;

    // -------------------------------------------------------------------------
    // Signal Declarations
    // -------------------------------------------------------------------------
    logic        clk;
    logic        rst;
    logic [31:0] instr;
    logic [31:0] pc;

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
        .instr(instr),
        .pc(pc)
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
            $display("Time: %0t  | PC: 0x%h  | Instr: 0x%h", $time, pc, instr);
            
            // Write to File
            $fdisplay(f, "%-8t | 0x%-8h | 0x%-8h", $time, pc, instr);
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
        #10; // Hold reset

        // 4. Release Reset
        rst = 0;
        
        // 5. Run Simulation
        // Run enough time to read all lines in memfile.dat plus some extra
        #150;

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