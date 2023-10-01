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
//  `include "/media/vnay01/B8BA7DCEBA7D89A0/Users/vnay0/Documents/GitHub/NeuralNetworks/DesignFiles/BuildingBlocks/multiply.v"
  `include "multiply.v"
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
output  [(2*num_width * array_size) -1 : 0] out_num;

wire [num_width - 1: 0] w_num_1 [array_size - 1 : 0];
wire [num_width - 1: 0] w_num_2 [array_size - 1 : 0];

wire [2*num_width - 1 : 0] w_out_num [array_size -1 : 0];

/// Using generate for module instantiation
parameter input_width = (num_width * array_size);

         
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
assign out_num = { w_out_num[15], w_out_num[14], w_out_num[13], w_out_num[12],
                         w_out_num[11],w_out_num[10],w_out_num[9],w_out_num[8],
                         w_out_num[7], w_out_num[6], w_out_num[5], w_out_num[4], 
                         w_out_num[3], w_out_num[2], w_out_num[1], w_out_num[0]};        

/*
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

  */  
endmodule
