# 🖥️ Hardware HDMI Video Pattern Generator

This repository contains a fully hardware-based video image generator and multiplexer over the HDMI interface, implemented entirely in programmable logic (FPGA) without the use of microprocessors or operating systems.

## 👨‍💻 Project Overview
Developed as an academic engineering project, this system generates a strictly timed 640x480 @ 60Hz video stream. The core logic is implemented in VHDL and deployed on an AUP-ZU3 evaluation board featuring a Zynq UltraScale+ FPGA. 

### 🚀 Key Engineering Features
* **Hardware Video Timing Controller:** Engineered a custom 2D coordinate counter that strictly adheres to VGA/HDMI timing standards, accurately driving `HSync`, `VSync`, and `DE` (Display Enable) signals.
* **On-the-fly Image Generation:** Implemented combinational logic to calculate pixel colors in real-time based on current coordinates, effectively bypassing the need for extensive VRAM frame buffers and saving critical FPGA resources.
* **Hardware Multiplexer:** Integrated a real-time display mode switcher controlled via physical Slide Switches (mapped strictly to the LVCMOS12 standard). Modes include:
  * Animated bouncing square with gradient backgrounds.
  * Standard color test bars.
  * 32x32 checkerboard generated efficiently using XOR bitwise operations (eliminating the need for hardware dividers).
* **Clock Domain Management:** Utilized Vivado Clocking Wizard (PLL/MMCM) to synthesize highly stable, phase-aligned 25 MHz (pixel logic) and 125 MHz (TMDS serialization) clocks from a 100 MHz system source.
* **On-Chip Debugging:** Verified hardware performance directly on the silicon matrix using the Xilinx Integrated Logic Analyzer (ILA) to ensure exact adherence to mathematical timing models.

### 🛠️ Tech Stack & Environment
* **Language:** VHDL
* **Environment:** Xilinx Vivado
* **Hardware:** Zynq UltraScale+ (AUP-ZU3 Board)
* **Protocols & Standards:** TMDS, LVDS, LVCMOS (3.3V / 1.2V), Custom VGA timing logic
