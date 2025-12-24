@echo off
echo Running ALU Simulation...

:: 1. Create the report file and write the Date/Time (Overwriting old file)
:: The single > creates a new file.
echo ---------------------------------------------------------------------------------- > reports\alu_results.txt
echo RUN DATE: %DATE%  TIME: %TIME% >> reports\alu_results.txt
echo ---------------------------------------------------------------------------------- >> reports\alu_results.txt

:: 2. Compile (Using -g2012 for SystemVerilog)
iverilog -g2012 -o alu_test.vvp rtl/alu.sv tb/alu_tb.sv

:: 3. Run Simulation
:: Since the Verilog code uses "a" (append), it will add to the file we just created.
vvp alu_test.vvp

echo.
echo Done! Check reports\alu_results.txt for the full report.
