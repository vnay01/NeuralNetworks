// Direct form 2 structure of Finite Impulse Response filter
import top_pkg::*;
module fir (
            input clk,
            input rst_n,
            input enable,
            input signed [DATA_WIDTH-1:0] input_sample,
            input signed [DATA_WIDTH-1:0] coeff [NOF_COEFF],
            output signed [FILTER_OUTPUT_DATA_WIDTH-1:0]  fir_output
            );


// FIR filter signals
logic signed [ACC_DATA_WIDTH-1:0] first_input,first_input_reg;
logic signed [ACC_DATA_WIDTH-1:0] mac_data_conn[NOF_COEFF];

always @(posedge clk) begin
    if (rst_n) begin
        first_input     <= '{default:0};
        first_input_reg <= '{default:0};
    end
    else if(enable) begin
        first_input     <= ((input_sample) * (coeff[NOF_COEFF-1]));
        first_input_reg <= first_input;
    end else begin
        first_input     <= '{default:0};
        first_input_reg <= '{default:0};
    end
end

// Assign first input
assign mac_data_conn[0] = first_input_reg;

// generate MAC units
genvar i;
    generate
        for(i=0; i < NOF_MACS; i++) begin
            mac_unit mac_unit_i(
                      .clk(clk),
                      .rst_n(rst_n),
                      .enable(enable),
                      .operand_1(input_sample),
                      .operand_2(coeff[NOF_MACS-1-i]),
                      .pre_adder_input(mac_data_conn[i]),
                      .mac_data(mac_data_conn[i+1])
            );
        end
    endgenerate

// output assignmnet
assign fir_output = (rst_n)? 0 :((enable)?(mac_data_conn[NOF_COEFF-1]):0);         

endmodule