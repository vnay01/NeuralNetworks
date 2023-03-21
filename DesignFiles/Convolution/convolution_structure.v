`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Vinay Singh
// 
// Create Date: 03/21/2023 03:31:03 AM
// Design Name: Computation Structure using MAC units
// Module Name: 
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
/*
`ifndef in_Col              ///// Number of columns in Input Matrix
    `define in_Col 4
    `endif
`ifndef in_Row             ///// Number of rows in Input Matrix
    `define in_Row 4
    `endif

`ifndef num_width
    `define num_width 8
    `endif 
`ifndef data_bus
    `define data_bus (2*`num_width)
    `endif 
`ifndef scratchpad_width
    `define scratchpad_width (`in_Col*`num_width)    
    `endif
`ifndef high_val
    `define high_val 1'b1
    `endif 
`ifndef low_val    
    `define low_val 1'b0
    `endif 
    
*/    
`include "definition.v"

`ifndef mul
  `include "multiply.v"
  `endif

`ifndef adder
  `include "adder.v"
  `endif
 
/////////////////////////////////////////////////////////////////////////////////////    

//// Weight Stationary Structure
/////// RESET  = ACTIVE LOW 
module convolution_structure( clk, reset, enable, data_in, weight_in, data_out);

/// Port Direction
    input clk;
    input reset;
    input enable;
    input [`scratchpad_width-1 : 0] data_in;
    input [`scratchpad_width-1 : 0] weight_in;
    
    
    output reg [`data_bus+1:0] data_out;
    
    ///// Internal registers
    reg [(`scratchpad_width/4 -1) : 0] elem_0;         // [7:0]
    reg [`scratchpad_width/2 -1 : `scratchpad_width/4]  elem_1; //[15:8]
    reg [(`scratchpad_width - `scratchpad_width/4 -1) : `scratchpad_width/2]  elem_2;             //[23:16]
    reg [`scratchpad_width-1 : (`scratchpad_width - `scratchpad_width/4)] elem_3;              // [31:24]
    
    reg [(`scratchpad_width/4 -1) : 0] weight_0;         // [7:0]
    reg [`scratchpad_width/2 -1 : `scratchpad_width/4]  weight_1; //[15:8]
    reg [(`scratchpad_width - `scratchpad_width/4 -1) : `scratchpad_width/2]  weight_2;             //[23:16]
    reg [`scratchpad_width-1 : (`scratchpad_width - `scratchpad_width/4)] weight_3;              // [31:24]
    
    //// 16 bits each
    wire [`data_bus-1 :0] mult_out_0;         
    wire [`data_bus-1 :0] mult_out_1;
    wire [`data_bus-1 :0] mult_out_2;
    wire [`data_bus-1 :0] mult_out_3; 
   
   ///// 17 bits each
   wire [`data_bus:0] add_out_0;
   wire [`data_bus:0] add_out_1;
   
   ///// 18 bits 
   wire [`data_bus+1:0] add_out_3;
    ///// Structure
    
    //// Multipliers            //// Use Generate block here to avoid writing like a retard
    mul m_0 (
               .clk(clk), 
               .reset(reset), 
               .enable(enable),
               .num_1(elem_0), 
               .num_2(weight_0),
               .out_num(mult_out_0)
                );
    
    mul m_1 (
               .clk(clk), 
               .reset(reset), 
               .enable(enable),
               .num_1(elem_1), 
               .num_2(weight_1),
               .out_num(mult_out_1)
                );
    mul m_2 (
               .clk(clk), 
               .reset(reset), 
               .enable(enable),
               .num_1(elem_2), 
               .num_2(weight_2),
               .out_num(mult_out_2)
                );
            
    mul m_3 (
               .clk(clk), 
               .reset(reset), 
               .enable(enable),
               .num_1(elem_3), 
               .num_2(weight_3),
               .out_num(mult_out_3)
                );    
    
    
    //// Adders
    adder a_0(
               .clk(clk), 
               .reset(reset), 
               .enable(enable),
               .num_1(mult_out_0), 
               .num_2(mult_out_1),                    
               .out_num(add_out_0)
                    );
    adder a_1(
               .clk(clk), 
               .reset(reset), 
               .enable(enable),
               .num_1(mult_out_2), 
               .num_2(mult_out_3),                    
               .out_num(add_out_1)
                    );                    
    adder a_3(
               .clk(clk), 
               .reset(reset), 
               .enable(enable),
               .num_1(add_out_0), 
               .num_2(add_out_1),                    
               .out_num(add_out_3)
                    );
                 
    
   ////// Procedural blocks
////////// Block sample input
   always@(posedge clk)
    if (enable) begin
        elem_0 <= data_in[(`scratchpad_width/4 -1) : 0];
        elem_1 <= data_in[`scratchpad_width/2 -1 : `scratchpad_width/4];
        elem_2 <= data_in[(`scratchpad_width - `scratchpad_width/4 -1) : `scratchpad_width/2];
        elem_3 <= data_in[`scratchpad_width-1 : (`scratchpad_width - `scratchpad_width/4)];        
    end        
    
////////// Block samples weights     
    always@(posedge clk)
        if(enable) begin
        weight_0 <= weight_in[(`scratchpad_width/4 -1) : 0];
        weight_1 <= weight_in[`scratchpad_width/2 -1 : `scratchpad_width/4];
        weight_2 <= weight_in[(`scratchpad_width - `scratchpad_width/4 -1) : `scratchpad_width/2];
        weight_3 <= weight_in[`scratchpad_width-1 : (`scratchpad_width - `scratchpad_width/4)];
        end
 
 /////// Block to assign output
   always@(posedge clk)
        if(enable) begin
        data_out <= add_out_3;
        end
         
    endmodule
    
    
    

