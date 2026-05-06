`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Watson College of Enggineering and Applied Sciences EECE Department
// Engineer: Dylan DiGiacomo
// 
// Create Date: 02/17/2026 04:32:26 PM
// Design Name: 
// Module Name: ACR30
// Project Name: TRNG Based on Chaotic Cellular Automata Topology
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
//          02/17/2026 | DD | Initial Module
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ACR30(
    input previous,
    input pass_capture,
    input set,
    input next,
    output current
);

/*---------------------
    Local Resources
----------------------*/
(* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire next_or_current;
(* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire pass;
(* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire mux_pass_capture;
(* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire buf1;
(* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire buf2;

/*---------------------
    Logic
----------------------*/
assign next_or_current = current | next;

assign pass = previous ^ next_or_current;

assign mux_pass_capture = (pass_capture) ? pass : current;

assign buf1 = ~mux_pass_capture;
assign buf2 = ~buf1;

assign current = set | buf2;

endmodule
