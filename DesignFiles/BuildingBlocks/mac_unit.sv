// mac_unit : 1-stage pipelined

import top_pkg::*;
module mac_unit (
                input clk,
                input rst_n,
                input enable,
                input signed [DATA_WIDTH-1:0] operand_1,
                input signed [DATA_WIDTH-1:0] operand_2,
                input signed [DATA_WIDTH-1:0] pre_adder_input,
                output signed [ACC_DATA_WIDTH-1:0] mac_data
);

// Internal wirings
logic signed [ACC_DATA_WIDTH-1:0] mul_reg;  // stores multiplication result
logic signed [ACC_DATA_WIDTH-1:0] acc_reg;  // stores result of addition


// calculations
always @(posedge clk) begin
    if (rst_n) begin
        mul_reg <= '{default:0};
        acc_reg <= '{default:0};
    end else if (enable) begin
        mul_reg <= ((operand_1) * (operand_2));
        acc_reg <= (pre_adder_input + mul_reg);
    end 
    else begin
        mul_reg <= '{default:0};
        acc_reg <= '{default:0};
    end
end

// output assignments
assign mac_data = acc_reg;

endmodule