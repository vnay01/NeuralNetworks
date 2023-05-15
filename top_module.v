`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Vinay Singh
// Create Date: 05/13/2023 09:28:35 AM
//////////////////////////////////////////////////////////////////////////////////
`ifndef DataPath
   `include "/media/vnay01/New Volume1/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/DataPath.v"
`endif

`ifndef controller
    `include "/media/vnay01/New Volume1/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/controller.v"
    `endif

module top_module(  clk,
                    reset,
                    INIT,
                    READY,
                    DONE,
                    conv_out
                    );


input clk;
input reset;
input INIT;
output reg READY;
output reg DONE;
output reg [19:0] conv_out;

/// Wire connections between modules
wire w_START;
wire w_ready;
wire w_input_matrix_ram_en;
reg w_input_matrix_ram_wea;
wire [8:0] w_input_matrix_ram_address;
reg [63:0] w_input_matrix_ram_dina;            /// will be unconnected for the time being
wire [63:0] w_input_matrix_ram_douta;
wire w_filter_matrix_rom_read_en;
//// filter matrix signals
wire w_filter_matrix_rom_en;
wire [0:0] w_filter_matrix_rom_address;     // This is because the filter depth is 2 words!!!! 
wire [63:0]w_filter_matrix_rom_douta;


// datapath wires & registers

reg [127:0] w_input_matrix_reg;
reg [127:0] w_filter_matrix_reg;
wire [4:0]w_data_path_signal;
wire w_mul_enable;
wire w_l1_add_enable;
wire w_l2_add_enable;
wire w_l3_add_enable;
wire w_l4_add_enable;

// Module instantations

// Input Matrix RAM
input_matrix input_matrix_0 (
  .clka(clk),    // input wire clka
  .ena(w_input_matrix_ram_en),      // input wire ena
  .wea(w_input_matrix_ram_wea),      // input wire [0 : 0] wea
  .addra(w_input_matrix_ram_address),  // input wire [8 : 0] addra
  .dina(w_input_matrix_ram_dina),    // input wire [63 : 0] dina
  .douta(w_input_matrix_ram_douta)  // output wire [63 : 0] douta
);

// Filter matrix RAM
filter_matrix filter_matrix_0 (
  .clka(clk),    // input wire clka
  .ena(w_filter_matrix_rom_en),      // input wire ena
  .addra(w_filter_matrix_rom_address),  // input wire [0 : 0] addra
  .douta(w_filter_matrix_rom_douta)  // output wire [63 : 0] douta
);

// Controller
 controller controller_0(  
                    .clk(clk),
                    .reset(reset),  // ACTIVE LOW reset
                    .START(w_START),         
                    .BUSY(w_BUSY),
                    .DONE(w_DONE),
                    .input_matrix_ram_en(w_input_matrix_ram_en),
                    .input_matrix_ram_read_en(w_input_matrix_ram_read_en),
                    .input_matrix_ram_address(w_input_matrix_ram_address),
                    .filter_matrix_rom_en(w_filter_matrix_rom_en),
                    .filter_matrix_rom_read_en(w_filter_matrix_rom_read_en),
                    .filter_matrix_rom_address(w_filter_matrix_rom_address),
                    .data_path_signal(w_data_path_signal)                             
    );


//assign {w_mul_enable, w_l1_add_enable, w_l2_add_enable, w_l3_add_enable, w_l4_add_enable} = {w_data_path_signal[4], w_data_path_signal[3], w_data_path_signal[2],w_data_path_signal[1],w_data_path_signal[0]};
assign {w_mul_enable, w_l1_add_enable, w_l2_add_enable, w_l3_add_enable, w_l4_add_enable} = {w_data_path_signal};
// DataPath

DataPath data_path_0 (
                    .clk(clk), 
                    .reset(reset),
                    .mul_enable(w_mul_enable),                          // from controller
                    .l1_add_enable(w_l1_add_enable),                    // from controller
                    .l2_add_enable(w_l2_add_enable),                    // from controller
                    .l3_add_enable(w_l3_add_enable),                    // from controller
                    .l4_add_enable(w_l4_add_enable),                    // from controller
                    .input_matrix_reg(w_input_matrix_reg),
                    .filter_matrix_reg(w_filter_matrix_reg),
                    .conv_out(w_conv_out)
                    );
                    

///// this RAM is controlled by the memory controller
/// Memory controller to be designed

convoluted_matrix convoluted_matrix_0 (
  .clka(clk),    // input wire clka
  .ena(w_conv_matrix_ena),      // input wire ena
  .wea(w_conv_matrix_wea),      // input wire [0 : 0] wea
  .addra(w_conv_matrix_address),  // input wire [8 : 0] addra
  .dina(w_conv_matrix_dina),    // input wire [63 : 0] dina
  .douta(w_conv_matrix_douta)  // output wire [63 : 0] douta
);


/// buffers RAM & ROM reads 
always@(posedge clk)
    begin
//    if(w_input_matrix_ram_en) begin
    
    w_input_matrix_reg[63:0] <= w_input_matrix_ram_douta;
    w_input_matrix_reg[127:64] <= w_input_matrix_reg[63:0];
//    end
    
//    if(w_filter_matrix_rom_en) begin   
    w_filter_matrix_reg[63:0] <= w_filter_matrix_rom_douta;
    w_filter_matrix_reg[127:64] <= w_filter_matrix_reg[63:0];
//    end
end
/// signal assignments
always@(*)
    begin
     conv_out = w_conv_out;
     w_input_matrix_ram_wea = 1'b0;   /// default :: RAM is not written for now. input matrix isloaded from .coe file
     w_input_matrix_ram_dina = {64{1'b0}};
     READY = ~ w_BUSY;
     DONE = w_DONE;
     
    end
   
assign w_START = INIT;   

endmodule