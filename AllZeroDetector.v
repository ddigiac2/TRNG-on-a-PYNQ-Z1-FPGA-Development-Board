`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Watson College of Enggineering and Applied Sciences EECE Department
// Engineer: Dylan DiGiacomo
// 
// Create Date: 02/17/2026 04:32:26 PM
// Design Name: 
// Module Name: AllZeroDetector
// Project Name: TRNG Based on Chaotic Cellular Automata Topology
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: 
//          03/03/2026 | DD | Initial Module
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AllZeroDetector(
    input ACR30_curr1,
    input ACR30_curr2,
    input ACR30_curr3,
    input ACR30_curr4,
    output osc_retrigger
);

/*---------------------
    Local Resources
----------------------*/
wire nor1;
wire nor2;

/*---------------------
    Logic
----------------------*/
assign nor1 = ~(ACR30_curr1 | ACR30_curr2);
assign nor2 = ~(ACR30_curr3 | ACR30_curr4);

assign osc_retrigger = nor1 & nor2;

endmodule
