`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Vinay Singh
// Create Date: 05/06/2023 08:09:01 AM
// Design Name: 
// Module Name: multiplier_array
//////////////////////////////////////////////////////////////////////////////////

`ifndef high_val
    `define high_val 1'b1
    `endif 
`ifndef low_val    
    `define low_val 1'b0
    `endif 


// Module file inclusion
`ifndef mul
  `include "/media/vnay01/B8BA7DCEBA7D89A0/Users/vnay0/Documents/GitHub/NeuralNetworks/DesignFiles/BuildingBlocks/multiply.v"
  `endif
    
    
/*This module is an array of 4 multiplier units*/

module multiplier_array #(parameter array_size = 16,
                          parameter num_width = 8 )(
                    clk,
                    reset,
                    enable,
                    num_1,
                    num_2,
                    out_num
                    );
                    
                    

// Port Direction   
input clk;
input reset;
input enable;
input [(num_width * array_size )-1:0] num_1;
input [(num_width * array_size )-1:0] num_2;
output reg [(2*num_width * array_size) -1 : 0] out_num;

wire [num_width - 1: 0] w_num_1 [array_size - 1 : 0];
wire [num_width - 1: 0] w_num_2 [array_size - 1 : 0];

wire [2*num_width - 1 : 0] w_out_num [array_size -1 : 0];

/// Using generate for module instantiation
parameter input_width = (num_width * array_size);

/// Get rid of the block below.
/*
assign w_num_1[15] = num_1[(16*input_width/16) -1 :(15 * input_width/16)];
assign w_num_1[14] = num_1[(15*input_width/16) -1 :(14 * input_width/16)];
assign w_num_1[13] = num_1[(14*input_width/16) -1 :(13* input_width/16)];
assign w_num_1[12] = num_1[(13*input_width/16) -1 :(12 * input_width/16)];
assign w_num_1[11] = num_1[(12*input_width/16) -1 :(11 * input_width/16)];
assign w_num_1[10] = num_1[(11*input_width/16) -1 :(10 * input_width/16)];
assign w_num_1[9] = num_1[(10*input_width/16) -1 :(9 * input_width/16)];
assign w_num_1[8] = num_1[(9*input_width/16) -1 :(8 * input_width/16)];
assign w_num_1[7] = num_1[(8*input_width/16) -1 :(7 * input_width/16)];
assign w_num_1[6] = num_1[(7*input_width/16) -1 :(6 * input_width/16)];
assign w_num_1[5] = num_1[(6*input_width/16) -1 :(5 * input_width/16)];
assign w_num_1[4] = num_1[(5*input_width/16) -1 :(4 * input_width/16)];
assign w_num_1[3] = num_1[(4*input_width/16) -1 :(3 * input_width/16)];
assign w_num_1[2] = num_1[(3*input_width/16) -1 :(2 * input_width/16)];
assign w_num_1[1] = num_1[(2* input_width/16) -1 :(input_width/16)];
assign w_num_1[0]= num_1[(input_width/16) - 1:0];                 

assign w_num_2[15] = num_2[(16*input_width/16) -1 :(15 * input_width/16)];
assign w_num_2[14] = num_2[(15*input_width/16) -1 :(14 * input_width/16)];
assign w_num_2[13] = num_2[(14*input_width/16) -1 :(13* input_width/16)];
assign w_num_2[12] = num_2[(13*input_width/16) -1 :(12 * input_width/16)];
assign w_num_2[11] = num_2[(12*input_width/16) -1 :(11 * input_width/16)];
assign w_num_2[10] = num_2[(11*input_width/16) -1 :(10 * input_width/16)];
assign w_num_2[9] = num_2[(10*input_width/16) -1 :(9 * input_width/16)];
assign w_num_2[8] = num_2[(9*input_width/16) -1 :(8 * input_width/16)];
assign w_num_2[7] = num_2[(8*input_width/16) -1 :(7 * input_width/16)];
assign w_num_2[6] = num_2[(7*input_width/16) -1 :(6 * input_width/16)];
assign w_num_2[5] = num_2[(6*input_width/16) -1 :(5 * input_width/16)];
assign w_num_2[4] = num_2[(5*input_width/16) -1 :(4 * input_width/16)];
assign w_num_2[3] = num_2[(4*input_width/16) -1 :(3 * input_width/16)];
assign w_num_2[2] = num_2[(3*input_width/16) -1 :(2 * input_width/16)];
assign w_num_2[1] = num_2[(2* input_width/16) -1 :(input_width/16)];
assign w_num_2[0]= num_2[(input_width/16) - 1:0];                 
*/
         
genvar i;

for (i = 0; i < array_size ; i = i + 1) begin
    assign w_num_1[i] = num_1[((i+1)*input_width/(array_size) -1 ):(i*input_width/(array_size))];
    assign w_num_2[i] = num_2[((i+1)*input_width/(array_size) -1 ):(i*input_width/(array_size))];
    end

generate 
for (i = 0; i < array_size; i = i + 1) begin
        mul #(num_width) mo(
               .clk(clk),
               .reset(reset),
               .enable(enable),
               .num_1(w_num_1[i]),
               .num_2(w_num_2[i]),
               .out_num(w_out_num[i])         
                );
    end 
    endgenerate   
                        
/// wiring

always@(posedge clk)
    begin
        if(!reset)
            out_num <= {(2*num_width * array_size){`low_val}};
            else
            out_num <= { w_out_num[15], w_out_num[14], w_out_num[13], w_out_num[12],
                         w_out_num[11],w_out_num[10],w_out_num[9],w_out_num[8],
                         w_out_num[7], w_out_num[6], w_out_num[5], w_out_num[4], 
                         w_out_num[3], w_out_num[2], w_out_num[1], w_out_num[0]};            
    end

    
endmodule
