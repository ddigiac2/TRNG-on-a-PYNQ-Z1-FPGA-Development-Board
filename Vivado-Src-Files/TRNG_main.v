`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Watson College of Enggineering and Applied Sciences EECE Department
// Engineer: Dylan DiGiacomo
// 
// Create Date: 03/03/2026 01:52:32 PM
// Design Name: 
// Module Name: TRNG_main
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


module TRNG_main(
    input fpga_set,
    input fpga_pass_capture,
    output wire [7:0] fpga_random_out
);

/*---------------------
    Local Resources
----------------------*/
(* DONT_TOUCH = "yes" *) wire ACR_current0;
(* DONT_TOUCH = "yes" *) wire ACR_current1;
(* DONT_TOUCH = "yes" *) wire ACR_current2;
(* DONT_TOUCH = "yes" *) wire ACR_current3;
(* DONT_TOUCH = "yes" *) wire ACR_current4;
(* DONT_TOUCH = "yes" *) wire ACR_current5;
(* DONT_TOUCH = "yes" *) wire ACR_current6;
(* DONT_TOUCH = "yes" *) wire ACR_current7;
(* DONT_TOUCH = "yes" *) wire middle;
wire osc_retrigger1;
wire osc_retrigger2;
wire set_middle;

reg [7:0] data_reg;


/*---------------------
    Logic
----------------------*/
AllZeroDetector detector_1(
    .ACR30_curr1(ACR_current0),
    .ACR30_curr2(ACR_current1),
    .ACR30_curr3(ACR_current2),
    .ACR30_curr4(ACR_current3),
    .osc_retrigger(osc_retrigger1)
);

AllZeroDetector detector_2(
    .ACR30_curr1(ACR_current4),
    .ACR30_curr2(ACR_current5),
    .ACR30_curr3(ACR_current6),
    .ACR30_curr4(ACR_current7),
    .osc_retrigger(osc_retrigger2)
);

assign set_middle = osc_retrigger1 & osc_retrigger2;

ACR30 ACR30_0(
    .previous(ACR_current7),
    .pass_capture(fpga_pass_capture),
    .set(fpga_set),
    .next(ACR_current1),
    .current(ACR_current0)
);

ACR30 ACR30_1(
    .previous(ACR_current0),
    .pass_capture(fpga_pass_capture),
    .set(fpga_set),
    .next(ACR_current2),
    .current(ACR_current1)
);

ACR30 ACR30_2(
    .previous(ACR_current1),
    .pass_capture(fpga_pass_capture),
    .set(fpga_set),
    .next(ACR_current3),
    .current(ACR_current2)
);

ACR30 ACR30_3(
    .previous(ACR_current2),
    .pass_capture(fpga_pass_capture),
    .set(fpga_set),
    .next(middle),
    .current(ACR_current3)
);

ACR30 ACR30_4(
    .previous(middle),
    .pass_capture(fpga_pass_capture),
    .set(fpga_set),
    .next(ACR_current5),
    .current(ACR_current4)
);

ACR30 ACR30_5(
    .previous(ACR_current4),
    .pass_capture(fpga_pass_capture),
    .set(fpga_set),
    .next(ACR_current6),
    .current(ACR_current5)
);

ACR30 ACR30_6(
    .previous(ACR_current5),
    .pass_capture(fpga_pass_capture),
    .set(fpga_set),
    .next(ACR_current7),
    .current(ACR_current6)
);

ACR30 ACR30_7(
    .previous(ACR_current6),
    .pass_capture(fpga_pass_capture),
    .set(fpga_set),
    .next(ACR_current0),
    .current(ACR_current7)
);

ACR30 ACR30_middle(
    .previous(ACR_current3),
    .pass_capture(fpga_pass_capture),
    .set(fpga_set),
    .next(ACR_current4),
    .current(middle)
);

always @(posedge fpga_pass_capture) begin
    data_reg[0] <= ACR_current0;
    data_reg[1] <= ACR_current1;
    data_reg[2] <= ACR_current2;
    data_reg[3] <= ACR_current3;
    data_reg[4] <= ACR_current4;
    data_reg[5] <= ACR_current5;
    data_reg[6] <= ACR_current6;
    data_reg[7] <= ACR_current7;
end

assign fpga_random_out = data_reg;

endmodule
