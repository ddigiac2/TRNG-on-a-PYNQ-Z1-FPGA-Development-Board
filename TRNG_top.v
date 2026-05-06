`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Watson College of Enggineering and Applied Sciences EECE Department
// Engineer: Dylan DiGiacomo
// 
// Create Date: 03/17/2026 02:01:36 PM
// Design Name: 
// Module Name: TRNG_top
// Project Name: TRNG Based on Chaotic Cellular Automata Topology
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: 
//          03/17/2026 | DD | Initial Module
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TRNG_top(
    input sys_clk,
    output top_random_out
);

/*---------------------
    Local Resources
----------------------*/
wire top_set = 0;
wire [7:0] trng_out1;
wire [7:0] trng_out2;
wire [7:0] trng_out3;
wire [7:0] trng_out4;
wire uart_active;
wire uart_done;

(* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire [7:0] xor_out1;
(* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire [7:0] xor_out2;
(* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire [7:0] xor_out3;

wire sample_trigger;
wire data_available;
reg sample_trigger_reg = 1'b1;
reg [15:0] counter = 0;
reg data_available_reg = 1'b0;

// 125 MHz sys_clk / SAMPLE_INTERVAL = 1 kHz clock for sampling
localparam SAMPLE_INTERVAL = 32'd11000; // 1E848 hex -> 125,000 decimal

/*---------------------
    Logic
----------------------*/
always @(posedge sys_clk) begin
    if (counter >= 11000) begin
        sample_trigger_reg <= 1'b0;
        counter <= 0;
        data_available_reg <= 1'b1;
    end else begin
        sample_trigger_reg <= 1'b1;
        counter <= counter + 1;
        data_available_reg <= 1'b0;
    end
end

assign sample_trigger = sample_trigger_reg;
assign data_available = data_available_reg;

TRNG_main TRNG_inst1(
    .fpga_set(top_set),
    .fpga_pass_capture(sample_trigger),
    .fpga_random_out(trng_out1)
);

TRNG_main TRNG_inst2(
    .fpga_set(top_set),
    .fpga_pass_capture(sample_trigger),
    .fpga_random_out(trng_out2)
);

TRNG_main TRNG_inst3(
    .fpga_set(top_set),
    .fpga_pass_capture(sample_trigger),
    .fpga_random_out(trng_out3)
);

TRNG_main TRNG_inst4(
    .fpga_set(top_set),
    .fpga_pass_capture(sample_trigger),
    .fpga_random_out(trng_out4)
);

uart_tx uart_controller(
    .clk(sys_clk),              
    .data_avail_i(data_available),
    .data_byte_i(xor_out3),
    .uart_active_o(uart_active),
    .tx_o(top_random_out),
    .done_o(uart_done)
);

assign xor_out1 = trng_out1 ^ trng_out2;

assign xor_out2 = trng_out3 ^ trng_out4;

assign xor_out3 = xor_out1 ^ xor_out2;

endmodule
