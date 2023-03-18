/* RTL model of a ROM
  Specs:
    word_length : 32
    mem_depth : whatever I want for the time being!
    each location stores one row of the coefficient matrix
*/
`define data_width 32
`define mem_depth 3

module rom_dual_port(
            clk,
            enable,
            addr_1,
            addr_2, 
            data_1,
            data_2
            );

// port direction
    input clk;
    input enable;
    input [`mem_depth-1:0] addr_1;
    input [`mem_depth-1:0] addr_2;
    output reg [`data_width-1:0] data_1;
    output reg [`data_width-1:0] data_2;

// pipeline registers
    reg [`data_width-1:0] data_1_reg, data_1_reg_next;
    reg [`data_width-1:0] data_2_reg, data_2_reg_next;
// final output register    
    reg [`data_width-1:0] data_1_out, data_2_out;

// ROM data :
    wire [`data_width-1:0] loc0;
    wire [`data_width-1:0] loc1;
    wire [`data_width-1:0] loc2;
    wire [`data_width-1:0] loc3;
    wire [`data_width-1:0] loc4;
    wire [`data_width-1:0] loc5;
    wire [`data_width-1:0] loc6;
    wire [`data_width-1:0] loc7;
// actual value being stored here
// I will find a way to update this automatically. Maybe automatically
    assign loc0 = 32'h11112222;
    assign loc1 = 32'h33334444;
    assign loc2 = 32'h55556666;
    assign loc3 = 32'h77778888;
    assign loc4 = 32'h9999aaaa;
    assign loc5 = 32'hbbbbcccc;
    assign loc6 = 32'hddddeeee;
    assign loc7 = 32'hffff0000;

always@(loc0 or loc1 or loc2 or loc3 or loc4 or loc5 or loc6 or loc7 or addr_1 or addr_2) begin
    case(addr_1)
        3'b000: data_1_out = loc0;
        3'b001: data_1_out = loc1;
        3'b010: data_1_out = loc2;
        3'b011: data_1_out = loc3;
        3'b100: data_1_out = loc4;
        3'b101: data_1_out = loc5;
        3'b110: data_1_out = loc6;
        3'b111: data_1_out = loc7;
        default:            data_1_out = loc0;
    endcase

        
    case(addr_2)
        3'b000: data_2_out = loc0;
        3'b001: data_2_out = loc1;
        3'b010: data_2_out = loc2;
        3'b011: data_2_out = loc3;
        3'b100: data_2_out = loc4;
        3'b101: data_2_out = loc5;
        3'b110: data_2_out = loc6;
        3'b111: data_2_out = loc7;
        default:            data_2_out = loc0;
    endcase
end

// Pipelinig registers for data line 1

always@(posedge clk)
    begin
        data_1_reg <= data_1_out;
        data_1_reg_next <= data_1_reg;
        
    end


// Pipelinig registers for data line 2

always@(posedge clk)
    begin
        data_2_reg <= data_2_out;
        data_2_reg_next <= data_2_reg;
    end
always@(posedge clk)
    begin
    data_2 <= data_2_reg_next;
    data_1 <= data_1_reg_next;
    end
endmodule