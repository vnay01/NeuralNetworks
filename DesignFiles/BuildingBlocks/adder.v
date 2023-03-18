`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Vinay Singh
// 
// Create Date: 02/05/2023 11:20:51 PM
// Design Name: 
// Module Name: adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`ifndef num_width
    `define num_width 8
`endif
`ifndef data_bus
    `define data_bus (2*`num_width)
    `endif 

`ifndef high_val
    `define high_val 1'b1
    `endif 
`ifndef low_val
    `define low_val 1'b0
    `endif

module adder(
                input [`data_bus -1 : 0] num_1, num_2,
                input clk, reset, enable,
                output reg [`data_bus : 0] out_num
                );

// Adding 
parameter word_length = `data_bus;

always@(posedge clk or negedge reset)
    begin
        if (!reset)
            out_num <= {word_length{`low_val}};
            else if (enable)
            out_num <= num_1 + num_2;
    end
                                        
endmodule
