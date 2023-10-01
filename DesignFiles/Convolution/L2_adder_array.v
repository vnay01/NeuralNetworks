`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Vinay Singh
// Create Date: 05/06/2023 10:02:17 AM
// Module Name: L1_adder_array
// Dependencies: Adder.v 
//////////////////////////////////////////////////////////////////////////////////
`ifndef adder
    `include "/media/vnay01/B8BA7DCEBA7D89A0/Users/vnay0/Documents/GitHub/NeuralNetworks/DesignFiles/BuildingBlocks/adder.v"
   `endif    
   
`ifndef high_val
    `define high_val 1'b1
    `endif 
`ifndef low_val    
    `define low_val 1'b0
    `endif     
        


module L2_adder_array #(parameter data_width = 17,
                        parameter array_size = 4
                        )(
                        clk,
                        reset,
                        enable,
                        num_1,
                        num_2,
                        out_num                            
                        );
// Port directions

input clk;
input reset;
input enable;
input [(data_width * array_size )-1:0] num_1;           
input [(data_width * array_size )-1:0] num_2; 
output [((data_width  * array_size ) + array_size - 1) :0] out_num;        // total output bit size : 136 bits

wire [data_width-1: 0] w_num_1 [array_size-1 : 0];
wire [data_width-1: 0] w_num_2[array_size-1 : 0];
wire [data_width : 0] w_out_num [array_size -1 : 0];

parameter output_width = (data_width  * array_size ) + array_size;

genvar i;

// Input sampling
for (i = 0 ; i < array_size ; i = i + 1) begin
    assign w_num_1[i] = num_1[((i+1)*data_width) -1 :(i*data_width)];
    assign w_num_2[i] = num_2[((i+1)*data_width) -1 :(i*data_width)];
end

// Adder module instantiations
generate
for(i = 0; i < array_size; i = i + 1) begin
        adder #(.num_width(17)) a0(
                  .clk(clk),
                  .reset(reset),
                  .enable(enable),
                  .num_1(w_num_1[i]),
                  .num_2(w_num_2[i]),
                  .out_num(w_out_num[i])  
                  );
end
endgenerate

// Output sampling -- Reduce registers once design is functional

for (i = 0 ; i < array_size; i = i + 1) begin
assign out_num[((i+1)*output_width/array_size)-1 : ((i)*output_width/array_size)] = w_out_num[i];
end


 

                     
endmodule
