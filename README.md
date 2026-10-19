# RISC-V Single-Cycle Processor in SystemVerilog 🚀

![Status: Work in Progress](https://img.shields.io/badge/Status-Work_in_Progress-orange)
![Language: SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-blue)
![Tools: Icarus Verilog](https://img.shields.io/badge/Tools-Icarus_Verilog%20%7C%20GTKWave-lightgrey)

## 📌 Overview
This repository contains the RTL implementation of a **32-bit Single-Cycle RISC-V Processor** (RV32I base integer instruction set) written in SystemVerilog. The project is designed with a strong emphasis on clean code, modular architecture, and modern hardware design methodologies.

## 🏗️ Architecture & Current Status
The processor follows a classic single-cycle datapath. 

**Currently Implemented Modules:**
- ✅ **PC (Program Counter):** Instruction pointer management.
- ✅ **Instruction Memory (IMEM):** Read-only memory for fetching instructions.
- ✅ **Register File:** 32x32-bit registers with x0 hardwired to zero.
- ✅ **ALU (Arithmetic Logic Unit):** Core execution unit.
- ✅ **Adders:** Dedicated adders for PC routing.

**In Progress:**
- ⏳ Control Unit
- ⏳ Immediate Generator
- ⏳ Data Memory (DMEM)

*Placeholder: [Insert an image of your Block Diagram/Datapath here]*

## 🗺️ Project Roadmap
This project is part of a larger continuous learning path aimed at building a full System-on-Chip (SoC) ecosystem:
1. **Phase 1:** Complete the RV32I Single-Cycle Datapath & Control.
2. **Phase 2 (Bus Integration):** Implement an **AXI4-Lite** interface from scratch to connect the CPU to peripherals/memory.
3. **Phase 3 (Verification):** Upgrade the testbench environment to a **UVM (Universal Verification Methodology)** framework.
4. **Phase 4 (Physical Design):** Run a basic RTL-to-GDSII flow (Synthesis, STA) to analyze timing and area.
5. **Phase 5 (SoC Integration):** Integrate this RISC-V core with the [taoFPGA Hardware Accelerator](https://github.com/shayrask/accelerator) as the Host CPU managing matrix operations.

## 📂 Repository Structure
```text
riscv-single-cycle-sv/
├── rtl/           # SystemVerilog source files (pc.sv, alu.sv, top.sv, etc.)
├── tb/            # Testbenches for module and system verification
├── reports/       # Simulation logs and results (fetch_results, alu_results)
├── memfile.dat    # Memory initialization files
├── run_test.bat   # Script to compile and run tests
└── README.md      # Project documentation
