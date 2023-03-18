`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2023 06:09:54 AM
// Design Name: 
// Module Name: test_rom_data_holder
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
`include "rom_dual_port.v"
`include "controller.v"
`include "input_mat_reg_bank.v"

`define clockperiod 5 

module testbench( );
                            
//output [`data_width-1:0] dout1, dout2; 
                           
    
// testbench connections
reg tb_clk;
reg tb_enable;
reg tb_reset;
//reg [`mem_depth-1:0] addr_1;
//reg [`mem_depth-1:0] addr_2;
wire tb_read_en;
wire  [`data_width*4-1:0] tb_data_1, tb_data_2; 
wire [`mem_depth-1:0] tb_rom_address, tb_ram_address;  
wire [`count_depth-1:0] tb_count;
wire [`select - 1:0] tb_select_line;
wire [`select:0] tb_bank_select_line;

parameter data_bus_width = 2 * `data_width;
wire [data_bus_width-1:0] tb_data_out;

rom_dual_port rom_u_0(
                       .clk(tb_clk),
                       .addr_1(tb_rom_address),
                       .addr_2(tb_rom_address),
                       .data_1(tb_data_1),
                       .data_2(tb_data_2) 
                        );

controller contr(
                    .clk(tb_clk),
                    .reset(tb_reset),
                    .enable(tb_enable),
                    .count(tb_count),
                    .read_en(tb_read_en),
                    .rom_address(tb_rom_address),
                    .ram_address(tb_ram_address),
                    .bank_select_line(tb_bank_select_line),
                    .select_line(tb_select_line)
                    );
                     
input_mat_reg_bank input_reg_bank(
                .clk(tb_clk),
                .reset(tb_reset),
                .enable(tb_read_en),
                .bank_select_line(tb_bank_select_line[`select-1:0]),       
                .select_line(tb_select_line),
                .data_in(tb_data_1),
                .data_out(tb_data_out)
            );

// stimulus - change the address every clock 10 ns ( i.e every 1 clock period )
initial
begin
    tb_clk = 1'b0;
    tb_reset = 1'b1;
    tb_enable = 1'b0;
//    tb_select_line = {`select{`low_val}}; 
    
    #1 tb_reset = 1'b0;
       tb_enable = 1'b1;
//       tb_select_line = 8'h00;
           
    #1000 tb_enable = 1'b0;
       
    #100
    $stop;        

end    
 
// Simulate 100Mhz clock
always
#`clockperiod tb_clk <= ~tb_clk;

endmodule
