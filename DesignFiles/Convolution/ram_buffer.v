`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Vinay Singh
// Create Date: 05/19/2023 09:46:26 AM
// Module Name: ram_buffer
// Project Name: CNN
// This block samples 3 elements of convoluted matrix in a single 64 bit word
// It also makes MSB = 1 to indicate a valid read from FIFO.
//////////////////////////////////////////////////////////////////////////////////


module ram_buffer(
                    clk,
                    reset,
                    fifo_status,
                    data_in,
                    data_valid,     // Use this to indicate one word is available to write
                    data_out
    );
    
// Port Direction
input clk;
input reset;
input [1:0] fifo_status;
input [19:0] data_in;
output data_valid;
output [63:0] data_out;    

// internal registers and wires
wire [19:0] w_data_in;
reg [59:0] sampling_register;

reg w_data_valid, w_data_valid_next;
reg [3:0] shift_counter, shift_counter_next;
    


assign w_data_in = data_in;
assign data_valid = w_data_valid;
///// Start sampling input data into a 64 bit word.
always@(posedge clk)
    begin
        if(!reset) begin
            shift_counter <= {4{1'b0}};
            sampling_register <= {60{1'b0}};
            w_data_valid <= 1'b0;
            end
        else begin
        if((fifo_status == 2'b10) && (fifo_status != 2'b01)) begin
        sampling_register[19:0] <= w_data_in;
        sampling_register[39:20] <= sampling_register[19:0];
        sampling_register[59:40] <= sampling_register[39:20];        
        end
        shift_counter <= shift_counter_next;  
        w_data_valid <= w_data_valid_next;   
        end
        
    end                



always@(*)
begin
    //w_data_valid = 1'b0;          // dafaults to 0
    w_data_valid_next = w_data_valid;
    
    if((fifo_status == 2'b10) && (fifo_status != 2'b01)) 
    begin
        if ((shift_counter < 3)&&(w_data_valid != 1'b1)) 
        begin
            shift_counter_next = shift_counter + 1;
        end     
    
    end
    if(shift_counter == 2) 
    begin
        shift_counter_next = 4'b0000;               // 
        w_data_valid_next = 1'b1;      // if 0 -> Data Not Valid :: 1 -> Data Valid
    end   
    else 
    begin
        if((fifo_status == 2'b01)) begin 
        w_data_valid_next = 1'b0;
        end
    end
    end  
       

// Data Out logic;
assign data_out = { w_data_valid, 3'b000 , sampling_register};

endmodule
