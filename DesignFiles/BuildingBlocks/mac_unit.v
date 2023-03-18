`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Vinay Singh
// 
// Create Date: 02/05/2023 11:31:03 PM
// Design Name: 
// Module Name: mac_unit
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
  
  `ifndef mul
    `include "multiply.v"
    `endif
  
  `ifndef adder
    `include "adder.v"
    `endif 

module mac_unit ( input clk, reset, enable,
                  input [`num_width-1 :0] num_1, num_2,
                  output reg [`data_bus : 0] output_num                           
                  );


parameter word_length = `num_width;
                  
// Internal wires
wire [`data_bus-1 : 0] w_mult_out;
reg [`data_bus : 0] w_mult;
reg [`data_bus : 0] add_feed_back;
wire [`data_bus : 0] w_output_num;

// Module instantiations 

// Multiply unit
    mul m_0( .clk(clk),
             .reset(reset),
             .enable(enable),
             .num_1(num_1),
             .num_2(num_2),
             .out_num(w_mult_out)
                         );
                    
// Adder unit
   adder a_0( .clk(clk),
              .reset(reset),
              .enable(enable),
              .num_1(w_mult),
              .num_2(add_feed_back),
              .out_num(w_output_num)
              );
   
   // Assigning feedback loop to adder
   always@(posedge clk)
    begin
    if (enable)
    add_feed_back <= w_output_num;
    end             

// Connect output
always@*
    begin    
    w_mult = {word_length{`low_val}}|w_mult_out; // Bitwise ORing removes 'Z' state of MSB
    
    output_num = w_output_num;
    end
                  
endmodule
