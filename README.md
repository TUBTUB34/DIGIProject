# FPGA LED Matrix Control Project

This project uses an FPGA to control an NxM LED matrix. The code includes various SystemVerilog files for interfacing, pattern generation, color selection, and display updates for the LED matrix.

## Project Structure

- **FPGA Design Files**: Core SystemVerilog (.sv) files for handling the LED matrix functionality.
  - `LEDtopLevel.sv`: Top-level module for controlling the LED matrix.
  - `adcinterface.sv`: Interface module for handling ADC inputs.
  - `colorchoice.sv`: Module for selecting colors for the LED matrix.
  - `decode2.sv` / `decode7.sv`: Decoder modules for LED control signals.
  - `enc2color.sv`: Encoder for color selection.
  - `showPattern.sv` / `updatePattern.sv`: Modules for managing the pattern display and updates.

- **Backup and Configuration Files**:
  - `.bak` files: Backup versions of primary modules.
  - `.qws`, `.qsf`, and `.qpf` files: Project and configuration files for the Quartus environment.

- **Simulation and Testing**:
  - Testbench files (e.g., `showPattern_tb.sv`, `updatePattern_tb.sv`) to verify the functionality of the pattern display and update modules.
  - ModelSim simulation files (`.cr.mti`, `.mpf`) for further verification.

- **Other Files**:
  - `export_db`, `incremental_db`, `output_files`: Directories containing synthesized and intermediate output files.
  - `ELEX7660_BOM_Alex_Braedon.xlsx`: Bill of Materials for the project.

## Usage

To set up and run the project:

1. Open the Quartus project files (`.qpf` and `.qsf`) in the Quartus environment.
2. Compile the project to generate the FPGA bitstream.
3. Use ModelSim to simulate the design if needed by opening the appropriate `.sv` testbench files.

### Required Tools

- **Quartus**: For compiling and programming the FPGA.
- **ModelSim**: For simulation and verification of the SystemVerilog modules.

## Additional Information

This project includes:
- **Real-time pattern updates** on the LED matrix.
- **Color selection** to display various patterns using different colors.
- **ADC input handling** for potential interactions with external sensors.

