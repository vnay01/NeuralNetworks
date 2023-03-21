`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Vinay Singh
// 
// Create Date: 02/05/2023 09:02:31 PM
// Design Name: 
// Module Name: mac_unit
// Tool Versions: 
// Description: Performs Multiply and Accumulate operation. Must be parameterized and clocked
// 				Signals
//				1) two numbers
//				2) enable
//				3) reset
//				4) clk
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
`ifndef num_width
    `define num_width 8
    `endif 
`ifndef high_val
    `define high_val 1'b1
    `endif 
`ifndef low_val    
    `define low_val 1'b0
    `endif 

module mul (	
            input clk, reset, enable,
			input [`num_width-1 :0]num_1, num_2,
			output reg [2*`num_width - 1 :0] out_num
			);
				
// Multiply
parameter word_length = 2* `num_width;


always@(posedge clk, negedge reset)
    begin
        if (!reset)
            out_num <={word_length{`low_val}};
        else if (enable)
            out_num <= num_1 * num_2;
        end            
				
endmodule
