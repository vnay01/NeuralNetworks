// @vnay01
// module acts as a 8 Byte register bank
// register_select controls where the incoming byte is stored.
// Input data_bus width = 32
///////////////////////////////////////////////////////////////
`include "register_8bit.v" 
`define low_val 1'b0
`define bank_depth 8
`define data_width 8
`define select 3
///////////////////////////////////////////////////////////////

module register_bank_8byte
                    ( input clk, 
                      input reset,
                      input enable,
                      input [`select-1:0] select_line, 
                      input [`bank_depth/2-1:0][`data_width-1:0] data_in,
                      output [`bank_depth-1:0][`data_width-1:0] out_data
                    );

parameter data_bus_width = `bank_depth * `data_width;
// Sample input data
reg [data_bus_width-1:0] sample_data_in;
reg [`bank_depth-1:0] register_select;      // Not reduced to a 1 bit signal to maintain re-usability.


// logic to determince which register will be updated
always@(*)
begin
    case(select_line)
    3'b000 : register_select = 8'h10;
    3'b001 : register_select = 8'h20;
   /* 3'b010 : register_select = 8'h04;
    3'b011 : register_select = 8'h08;
    3'b100 : register_select = 8'h10;
    3'b101 : register_select = 8'h20;
    3'b110 : register_select = 8'h40;
    3'b111 : register_select = 8'h80;
    */
    default : register_select = 8'h00;      // default case . Use in debugging

    endcase

end



// register update block
always@(posedge clk , posedge reset)
    begin
        if (reset)
        sample_data_in <= {data_bus_width{`low_val}};
    else if(enable)
        sample_data_in[data_bus_width-1:data_bus_width/2] <= data_in;
        sample_data_in[data_bus_width/2-1:0] <= data_in;                // controller to ensure correct register update 
    end
    
    
    


// module instantiations to create a register bank of dimension 8 x 8 bits


register_8bit u0(
                    .clk(clk),
                    .reset(reset),
                    .enable(register_select[4]),
                    .data_in(sample_data_in[data_bus_width/8-1:0]),     // 7:0
                    .data_out(out_data[0])
                    );
register_8bit u1(
                   .clk(clk),
                   .reset(reset),
                   .enable(register_select[4]),
                   .data_in(sample_data_in[data_bus_width/4-1 : data_bus_width/8]), // 15:8
                   .data_out(out_data[1])
                   );

register_8bit u2(
                   .clk(clk),
                   .reset(reset),
                   .enable(register_select[4]),
                   .data_in(sample_data_in[(data_bus_width/4 + `data_width -1) : data_bus_width/4]),  //23:16
                   .data_out(out_data[2])
                   );
register_8bit u3(
                  .clk(clk),
                  .reset(reset),
                  .enable(register_select[4]),
                  .data_in(sample_data_in[(data_bus_width/2-1):(data_bus_width/4 + `data_width)]),              //31:24
                  .data_out(out_data[3])
                  );                  

register_8bit u4(
                  .clk(clk),
                  .reset(reset),
                  .enable(register_select[5]),
                  .data_in(sample_data_in[data_bus_width/2 + `data_width -1 :data_bus_width/2]),    // 39:32
                  .data_out(out_data[4])
                  );
register_8bit u5(
                 .clk(clk),
                 .reset(reset),
                 .enable(register_select[5]),
                 .data_in(sample_data_in[data_bus_width/2 + (2*`data_width)-1 : data_bus_width/2 + `data_width]),    //47:40
                 .data_out(out_data[5])
                 );

register_8bit u6(
                 .clk(clk),
                 .reset(reset),
                 .enable(register_select[5]),
                 .data_in(sample_data_in[data_bus_width - `data_width -1 :data_bus_width/2 + (2*`data_width)]),  // 55:48
                 .data_out(out_data[6])
                 );
register_8bit u7(
                .clk(clk),
                .reset(reset),
                .enable(register_select[5]),  
                .data_in(sample_data_in[data_bus_width-1:data_bus_width - `data_width]), // 63:56
                .data_out(out_data[7])
                );  

endmodule
