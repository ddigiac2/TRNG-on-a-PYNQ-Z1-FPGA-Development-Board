# TRNG on a PYNQ-Z1 FPGA Development Board
This tutorial goes through the hardware/software implementation for a true random number generator design based on a cellular automata topology on a PYNQ-Z1 FPGA Development Board.

# Introduction/Context
A True Random Number Generator (TRNG) is a system that generates unpredictable random numbers and bits of data from non-deterministic phenomena. Such examples of these phenomena include thermal noise, glitch of a digital circuit, or any other hard-to-measure physical characteristics. This differs from the other common random number generator in a pseudo-random number generator, as that design is built from linear feedback shift registers (LSFR) and are vulnerable to cryptanalytic attacks if seed or algorithm is known. 

There are many different designs for a TRNG, both digital and analog, however, to make a TRNG easily implemented in applications of processing systems, digital circuits is the preferred method. In regard to analog designs, there are metastability based designs that fall short in being high cost and sensitive to aging (decrease in entropy), and ring-oscillator based designs that are vulnerable to attacks. With higher utilization rates in reconfigurable devices, like FPGA, to be less susceptible to external attacks, the digital TRNG designs can be used. For a preexisting self-timed digital circuit-based TRNG using a ring oscillator, the main element is a “C element” composed of a Muller gate and an inverter. These are interleaved to form an asynchronous micropipeline to improve performance and speed of generation. Although the design used in this tutorial is similar with using a self-timed ring structure, there is the difference of it being based on cellular automata topology. 

A cellular automata is composed of λ identical cellular automata elements, that each have k possible states represented by colors. These states/colors repeatedly change based on an updating rule (U) that is applied to all elements. The colors are jointly determined by colors of neighbor cells (Nx) and itself, where neighbors are determined by range (r) from cell (x). The specific rule used in this design is CA30, in which the patterns of the rule are unpredictable by known formula and therefore formally proved of chaotic behavior. In further sections of this tutorial, this rule will be used to create an ACR30 design, the base of the TRNG.

# Tutorial Software Setup
- Ensure you have Xilinx Vivado v.2025.2 installed or any other version that can be used for this tutorial. This will be where the FPGA design will be made and programmed to the device 
    - For programming to the specific device used in this tutorial, the device needs to be installed for the Xilinx tools. To do this, follow these instructions: 
          Open your Xilinx Vivado application 
          Go to the Help tab  Add Design Tools or Devices (this will open up the AMD Tools installer) 
          Enter email and password associated with AMD account 
          Select Vivado ML Standard 
          Check the box for Zynq-7000 All Programmable SoC 
          Follow through the remainder of the Installer instructions and install (you may have to reopen the Vivado application after installation) 
- Ensure you have the latest version of Python installed on your machine 
- Ensure you have Microsoft Visual Studio Code installed on your machine. This will be where we create a Juptyer Notebook python script to open a serial terminal, collect, and analyze data output from the device. 

# Tutorial Hardware Setup 
- A Digilent PYNQ-Z1 Zynq-7000s ARM FPGA Development Board is necessary
- A Micro-USB to USB-A cable is necessary. The USB-A side will be plugged into the PC and the Micro-USB side will be plugged into the PROG UART port on the board for programming. 
  - Ensure that the jumper on the connector above the PROG UART port on the board is set-up for JTAG programming. This allows the device to read from the Micro        USB port rather than the Micro-SD slot on the bottom of the board 
- An external AC power supply is necessary. The barrel jack of the AC power supply can be plugged into the barrel jack on the board. 
     - Ensure that the jumper on the connector J5 is set-up for REG 
- A CP2102 USB to TTL adapter module along with two female to male jumper wires are necessary. This will be used for receiving TRNG output values to PC for statistical analysis
    - The USB-A side will be plugged into the PC 
    - The first jumper wire will be connecting the Rx pin on the CP2102 module and the upper-left most pin on the header PMOD JA 
    - The second jumper wire will be connecting the GND pin on the CP2102 module and the upper GND pin on the header PMOD JA 
o The second jumper wire will be connecting the GND pin on the CP2102 module 
and the upper GND pin on the header PMOD JA

# Creating the TRNG Design in Vivado
Please see: [Vivado-Src-Files](https://github.com/ddigiac2/TRNG-on-a-PYNQ-Z1-FPGA-Development-Board/tree/main/Vivado-Src-Files)

# Validating Design and Programming Device in Vivado
After completing the above sections, run the synthesis and then implementation in the project workspace. After ensuring that there are no errors in running both of these processes, do not yet generate the bitstream, and rather open up the implemented design. On the left side of the project workspace, under the ‘Implementation’ section, click on ‘Open Implemented Design’, and then click on ‘Schematic’. Once this opens, the schematic should look similar to that of Figure 5. The yellow boxes in the schematic represent LUTs (look-up tables for logic gates), registers, FFs, or any other circuit blocks. The blue boxes are module instances that have been created throughout the design in source files, as these can be expanded to show the modularity of the design. The green wires represent all of the interconnecting signals of the design along with the sole input and output signals to the logic.
 
<img width="975" height="270" alt="image" src="https://github.com/user-attachments/assets/3c0e63ba-f954-496e-9f73-4c9c3b610732" />

The main reason for analyzing this schematic is to make sure that Vivado did not optimize the design during synthesis as we had stated in multiple spots in both the source and constraints files. When clicking the plus sign in the top left corner of one of the TRNG instantiations in the schematic, this should expand the module to see the logic circuits inside that module, as seen in Figure 6. Within this circuitry, there should be the nine ACR30 modules along with the eight FFs that are driven by the pass_capture enable.
 
<img width="975" height="415" alt="image" src="https://github.com/user-attachments/assets/5c7e677c-98bf-49cf-a1ae-15c015f7f211" />

Now, expand one of the eight ACR30 modules that have the current output wire being fed to a FF. Inside this module, there should be the lowest-level logic circuitry and no more modules to be expanded as shown in Figure 7. To acknowledge that the logic was not optimized, there should be two inverting buffers connected in series as outlined in Figure 8. If there is rather only one inverting buffer, then this circuitry was optimized and the constraints have to be updated to what is represented in the constraints file in the source files of the repository.
 
<img width="975" height="207" alt="image" src="https://github.com/user-attachments/assets/881a5e77-0f4f-473d-a47f-7321750d5152" />

<img width="975" height="210" alt="image" src="https://github.com/user-attachments/assets/d561d5cc-793c-4931-903c-0f0ca6306847" />

Another logic validation check that can be completed is to look at some of the LUTs truth tables. For example, if you right-click on the LUT that represents the 2x1 mux and then click ‘Cell Properties’, a section in the properties contains the truth table for that block as seen in Figure 9. Nets and order of inputs may be altered for every implementation schematic, however the functionality of the LUT should match that of a 2x1 mux with the select being the pass_capture signal.

<img width="477" height="386" alt="image" src="https://github.com/user-attachments/assets/467a453c-04c9-452a-8b78-92decb8ed8b6" />

Once majority of the logic has been validated with looking at the schematic and ensuring the truth table logic is correct, a bitstream can finally be generated. When this has been generated, follow the hardware setup section of this tutorial for connecting the power supply along with the Micro-USB cable and CP2102 module, and switch the power switch to the ON position. This should cause a red power LED to remain steady on and signify that the board is receiving sufficient power. Now, in the project workspace in Vivado, click on ‘Open Hardware Manager’, this brings the application to a workspace for programming the device. Click on ‘Auto-connect’ as this will cause the FPGA part to pop-up as a programmable device in the application. If auto-connect does not work, then the device may not be powered on or the USB cables are not connected. When the device pops up, then click on ‘Program Device’ and select the proper .bit file for programming. The progress bar in the application will have a status of the device being programmed and a green LED on the PYNQ-Z1 board will remain steady on after the device has been programmed successfully over the JTAG chain. Since programming over JTAG is volatile, the device when powered off will lose the .bit file that was used for programming and will require to re-program it. So, during the entire process of completing the statistical analysis in the next section of the tutorial, do not remove the AC power supply to the board.

# Analyzing TRNG Output Data with Entropy
Please see: [Python-Analysis](https://github.com/ddigiac2/TRNG-on-a-PYNQ-Z1-FPGA-Development-Board/tree/main/Python-Analysis)
