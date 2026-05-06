
This section of the repository describes the statistical analysis of the TRNG random byte outputs from the design made in the previous sections. The PYNQ-Z1 board shall already be programmed with the proper bitstream and the CP2102 module is connected both to the PC and board as instructed in the hardware tutorial setup. Then open up the Microsoft Visual Studio Code application and create a new Jupyter Notebook file (.ipynb) to hold the Python code that will be performed.

In the first cell of the notebook, enter the first section of Python code shown. This code opens a serial terminal at the proper baud rate and port number using the Python library serial. If the library is not already installed on the PC, open a command line and use ‘pip install pyserial’ to install the library. To determine the correct port number to insert into the code, open Device Manager on the PC and check the COM ports to see which port the CP2102 device is connected to. Also, the cell of code saves 1 megabyte of output data from the serial terminal to a binary file (.bin) that can be saved in any desired location on the PC if you alter the save directory in the cell. In the serial terminal that opens when running this cell for the course of the five minutes it takes to complete; the terminal will print a percentage status of saving the data to the binary file.

For a second cell of the notebook, enter the second section of the Python code, which utilizes the pyplot and numpy libraries to create a bitmap from the output dataset. This 512x512 bitmap should visually resemble black and white television static as shown in Figure 10, representing randomness in the output byte values.

<img width="524" height="530" alt="image" src="https://github.com/user-attachments/assets/5b4e65a5-0fa4-4f98-9bc9-4a8754c159f9" />

For the final cell of the notebook, enter the final section of the Python code from Appendix B and run the cell. With using the same Python libraries, the amount of entropy in the TRNG output values can be seen with the Shannon entropy formula:
∑▒〖p*〖log〗_2 p〗
The entropy formula requires the probabilities of each different byte value occurring out of the megabyte of data. Since a byte represents eight bits of data, the ideal entropy value would be approximately eight bits, which would illustrate uniformity and total unpredictability in the TRNG outputs. Furthermore, the notebook cell also will create a histogram of all the byte output values with the frequencies that they occurred. To validate the functionality of the design, the histogram frequencies should be relatively similar to each other with no extreme outliers in the dataset as seen in Figure 11. 

<img width="759" height="640" alt="image" src="https://github.com/user-attachments/assets/40af4998-61fa-4d75-9cfe-325d222e0b26" />

If all of these entropy measures and plots show proper randomness and unpredictability, then the TRNG implementation based on cellular automata topology is a success! This design is proven to pass thermal attacks, power attacks, and frequency injection attacks while having a low hardware footprint, high energy efficiency, and flexibility with reconfigurable patterns.
