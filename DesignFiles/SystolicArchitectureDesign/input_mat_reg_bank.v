// @vnay01
////////////////////////////////////////////////
//////////// register bank to store input matrix
////////////////////////////////////////////////

////// Design specification will determine how 
////// 'select_line' needs to be handled
////// Currently, each read operation of RAM
////// produces 4 elements of input matrix
`include "register_bank_8byte.v"
`define in_data_bus_width (`bank_depth/2) * `data_width
`define data_bus_width `bank_depth*`data_width



module input_mat_reg_bank(
            input clk,
            input reset,
            input enable,
            input [`select-1:0] bank_select_line,       // controller to ensure correct register bank selection
            input [`select-1:0] select_line,            // controller to ensure correct internal register selection                
            input [`in_data_bus_width-1:0] data_in,
            output[`bank_depth-1:0][`bank_depth-1:0][`data_width-1:0] data_out
            );


// Internal wirings
// parameter data_bus_width = `bank_depth * `data_width;
reg [`data_bus_width-1:0] sample_data_in;
reg [`bank_depth-1:0] bank_select;
reg [`select-1:0] bank_select_line_delay_1, bank_select_line_delay_2, bank_select_line_delay_3;
reg [`select-1:0] select_line_delay_1,select_line_delay_2, select_line_delay_3;
// sample input data
always@(posedge clk, posedge reset)
begin
    if(reset)
    sample_data_in <= {`data_width{`low_val}};
    else if(enable) begin
    bank_select_line_delay_1 <= bank_select_line;
    bank_select_line_delay_2 <= bank_select_line_delay_1;
    bank_select_line_delay_3 <= bank_select_line_delay_2;
    select_line_delay_1 <= select_line;
    select_line_delay_2 <= select_line_delay_1;
    select_line_delay_3 <= select_line_delay_2;
    sample_data_in[`data_bus_width-1:`data_bus_width/2] <= data_in;
    sample_data_in[`data_bus_width/2-1:0] <= data_in;                // controller to ensure correct register update
    end 
end

// register bank selection logic
always@(*)
begin
    case(bank_select_line_delay_3)
    3'b000 : bank_select = 8'h01;
    3'b001 : bank_select = 8'h02;
    3'b010 : bank_select = 8'h04;
    3'b011 : bank_select = 8'h08;
    3'b100 : bank_select = 8'h10;
    3'b101 : bank_select = 8'h20;
    3'b110 : bank_select = 8'h40;
    3'b111 : bank_select = 8'h80;
    default : bank_select = 8'h00;      // default case . Use in debugging

    endcase
end


// module instantiations to create 64 byte register bank
// each instantiation will store 8 elements of the input matrix

register_bank_8byte rb_0 (
                            .clk(clk),
                            .reset(reset),
                            .enable(bank_select[0]),
                            .select_line(select_line_delay_3),                       // this has to be 3 bit long
                            .data_in(sample_data_in[`data_bus_width-1:`data_bus_width/2]),
                            .out_data(data_out[0])
                            );
register_bank_8byte rb_1 (
                            .clk(clk),
                            .reset(reset),
                            .enable(bank_select[1]),
                            .select_line(select_line_delay_3),
                            .data_in(sample_data_in[`data_bus_width-1:`data_bus_width/2]),
                            .out_data(data_out[1])
                            );
register_bank_8byte rb_2 (
                            .clk(clk),
                            .reset(reset),
                            .enable(bank_select[2]),
                            .select_line(select_line_delay_3),
                            .data_in(sample_data_in[`data_bus_width-1:`data_bus_width/2]),
                            .out_data(data_out[2])
                            );
register_bank_8byte rb_3 (
                            .clk(clk),
                            .reset(reset),
                            .enable(bank_select[3]),
                            .select_line(select_line_delay_3),
                            .data_in(sample_data_in[`data_bus_width-1:`data_bus_width/2]),
                            .out_data(data_out[3])
                            );
register_bank_8byte rb_4 (
                            .clk(clk),
                            .reset(reset),
                            .enable(bank_select[4]),
                            .select_line(select_line_delay_3),
                            .data_in(sample_data_in[`data_bus_width/2-1:0] ),
                            .out_data(data_out[4])
                            );
register_bank_8byte rb_5 (
                            .clk(clk),
                            .reset(reset),
                            .enable(bank_select[5]),
                            .select_line(select_line_delay_3),
                            .data_in(sample_data_in[`data_bus_width/2-1:0] ),
                            .out_data(data_out[5])
                            );
register_bank_8byte rb_6 (
                            .clk(clk),
                            .reset(reset),
                            .enable(bank_select[6]),
                            .select_line(select_line_delay_3),
                            .data_in(sample_data_in[`data_bus_width/2-1:0] ),
                            .out_data(data_out[6])
                            );
register_bank_8byte rb_7 (
                            .clk(clk),
                            .reset(reset),
                            .enable(bank_select[7]),
                            .select_line(select_line_delay_3),
                            .data_in(sample_data_in[`data_bus_width/2-1:0]),
                            .out_data(data_out[7])
                            );                                                                                                                                                                                                    

endmodule
