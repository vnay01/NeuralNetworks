`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Vinay Singh 
// Create Date: 05/06/2023 01:33:44 PM
// Design Name: 
// Module Name: DataPath
//////////////////////////////////////////////////////////////////////////////////

`ifndef multiplier_array
`include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/multiplier_array.v"
`endif


`ifndef L1_adder_array
`include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/L1_adder_array.v"
`endif

`ifndef L2_adder_array
`include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/L2_adder_array.v"
`endif

`ifndef L3_adder_array
`include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/L3_adder_array.v"
`endif

`ifndef L4_adder_array
`include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/L4_adder.v"
`endif

// `include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/inlcude_files.v"

module DataPath #(parameter mul_out_width = 256, 
                  parameter l1_adder_out_width = 136,
                  parameter l2_adder_out_width = 72,
                  parameter l3_adder_out_width = 38,
                  parameter l4_adder_out_width = 20)(
                clk, reset,
                mul_enable,
                l1_add_enable,
                l2_add_enable,
                l3_add_enable,
                l4_add_enable,
                input_matrix_reg,
                filter_matrix_reg,
                conv_out
                );

// Port direction

input clk;
input reset;
input mul_enable;
input l1_add_enable;
input l2_add_enable;
input l3_add_enable;
input l4_add_enable;
input [127:0]input_matrix_reg;     // size : 16 x 8 bits
input [127:0] filter_matrix_reg;   // size : 16 x 8 bits
output reg [l4_adder_out_width -1 :0] conv_out;

//// Internal Wirings
wire [mul_out_width -1 : 0] multiplier_out;
wire [l1_adder_out_width -1 : 0] l1_adder_out;
wire [l2_adder_out_width -1 : 0] l2_adder_out;
wire [l3_adder_out_width -1 : 0] l3_adder_out;
wire [l4_adder_out_width -1 : 0] l4_adder_out;


// module instantiations

multiplier_array #(16,8) m0 (
                          .clk(clk),
                          .reset(reset),
                          .enable(mul_enable),
                          .num_1(input_matrix_reg),
                          .num_2(filter_matrix_reg),
                          .out_num(multiplier_out)  
                          );

L1_adder_array a0 (
                        .clk(clk),
                        .reset(reset),
                        .enable(l1_add_enable),
                        .num_1(multiplier_out[255:128]),
                        .num_2(multiplier_out[127:0]),
                        .out_num(l1_adder_out)
                        );
L2_adder_array a1 (
                    .clk(clk),
                    .reset(reset),
                    .enable(l2_add_enable),
                    .num_1(l1_adder_out[135:68]),
                    .num_2(l1_adder_out[67:0]),
                    .out_num(l2_adder_out)
                    );
L3_adder_array a2 (
                    .clk(clk),
                    .reset(reset),
                    .enable(l3_add_enable),
                    .num_1(l2_adder_out[71:36]),
                    .num_2(l2_adder_out[35:0]),
                    .out_num(l3_adder_out)
                    );          

L4_adder_array a3 (
                    .clk(clk),
                    .reset(reset),
                    .enable(l4_add_enable),
                    .num_1(l3_adder_out[37:19]),
                    .num_2(l3_adder_out[18:0]),
                    .out_num(l4_adder_out)
                    );                              


                                           
always@(posedge clk)
    begin
        if(!reset)
        conv_out <= {l4_adder_out_width{1'b0}};
        else
        conv_out <= l4_adder_out;
    end                                           
                  
endmodule
