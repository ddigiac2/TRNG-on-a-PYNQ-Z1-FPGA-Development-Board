`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Watson College of Enggineering and Applied Sciences EECE Department
// Engineer: Dylan DiGiacomo
// 
// Create Date: 04/28/2026 11:16:29 AM
// Design Name: 
// Module Name: uart_tx
// Project Name: TRNG Based on Chaotic Cellular Automata Topology
// Target Devices: 
// Tool Versions: 
// Description: Uart transfer for 112 500 Baud Rate
// 125Mhz/115200 = 1085 cycles per duration of bit send.
// Dependencies: 
//          04/28/2026 | DD | Initial Module
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx #(parameter CYC_PER_BIT = 1085)(
    input clk,
    input data_avail_i,
    input [7:0] data_byte_i,
    output uart_active_o,
    output tx_o,
    output done_o
);

/*---------------------
    Local Resources
----------------------*/
reg active;
reg tx;
reg done;
    
localparam IDLE_STATE      = 2'b00;
localparam START_STATE     = 2'b01;
localparam SEND_BIT_STATE  = 2'b10;
localparam STOP_STATE      = 2'b11;

reg [1:0] state;
reg [15:0] counter;
reg [2:0] bit_index;
reg [7:0] data_byte;

/*---------------------
    UART FSM
----------------------*/

initial begin
    state = IDLE_STATE;
    counter = 0;
    bit_index = 0;
    data_byte = 0;
end

always @(posedge clk) begin
    case(state)
        IDLE_STATE:
            begin
                tx <= 1;
                done <= 0;
                counter <= 0;
                bit_index <= 0;
                
                if (data_avail_i == 1) begin
                    active <= 1;
                    data_byte <= data_byte_i;
                    state <= START_STATE;
                end
                else begin
                    state <= IDLE_STATE;
                    active <= 0;
                end
            end
        
        START_STATE:
            begin
                tx <= 0;
                if(counter < CYC_PER_BIT-1) begin
                    counter <= counter + 16'b1;
                    state <= START_STATE;
                end
                else begin 
                    counter <= 0;
                    state <= SEND_BIT_STATE;
                end
            end
            
        SEND_BIT_STATE:
            begin
                tx <= data_byte[bit_index];
                if(counter < CYC_PER_BIT -1) begin
                    counter <= counter + 16'b1;
                    state <= SEND_BIT_STATE;
                end
                else begin 
                    counter <= 0;
                    if(bit_index < 7) begin
                        bit_index <= bit_index + 3'b1;
                        state <= SEND_BIT_STATE;
                    end
                    else begin
                        bit_index <= 0;
                        state <= STOP_STATE;
                    end
                end
            end
                            
        STOP_STATE:
            begin
                tx <= 1;
                if (counter < CYC_PER_BIT-1) begin
                    counter <= counter + 16'b1;
                    state <= STOP_STATE;
                end
                else begin
                    done <= 1;
                    state <= IDLE_STATE;
                    active <= 0;
                end
            end 
    endcase
end

assign uart_active_o = active;
assign tx_o = tx;
assign done_o = done;

endmodule
