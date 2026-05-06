# TRNG-on-a-PYNQ-Z1-FPGA-Development-Board
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
Please see: Vivado-Src-Files

# Validating Design and Programming Device in Vivado

# Analyzing TRNG Output Data with Entropy
Please see:
