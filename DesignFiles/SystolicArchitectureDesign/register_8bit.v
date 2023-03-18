// module will act as a 1 byte register

`timescale 1ns/1ps

`define data_bus 8
`define low_val 1'b0
`define high_val 1'b1


module register_8bit(
		input clk,
		input reset,
		input enable,
		input [`data_bus -1 :0] data_in,
		output reg [`data_bus-1:0] data_out
		);
		

// behavioral model

	always@(posedge clk, posedge reset)
	 begin
		if (reset)
			data_out <= {`data_bus{`low_val}};
			else if(enable)
			data_out <= data_in;
	 end

endmodule	 