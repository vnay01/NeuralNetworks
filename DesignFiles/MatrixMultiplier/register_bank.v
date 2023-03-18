// Module implements Regsiter Bank
`timescale 1ns/1ps

module register_bank #(parameter data_width = 8,
                        parameter bank_width = 64)
                        ( clk, reset, enable, data_in, data_out);

// Port direction
 input clk;
 input reset;
 input enable;
 input [data_width - 1: 0] data_in;
 output reg [data_width -1 :0] data_out;

// Generate registerbank here


endmodule