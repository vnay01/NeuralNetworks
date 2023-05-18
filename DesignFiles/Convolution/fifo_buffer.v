`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Vinay Singh 
// Create Date: 05/18/2023 11:34:18 AM 
// Module Name: fifo_buffer
//////////////////////////////////////////////////////////////////////////////////


module fifo_buffer #(parameter data_width = 20,
                     parameter fifo_depth = 3)(
                    clk,
                    reset,
                    data_in,
                    data_out,
                    command,
                    status
                    );
                    
// port direction
input clk;
input reset;
input [1:0] command;            /// controller sends a read/ write command -- default is to write
input [data_width -1 : 0] data_in;
output reg [data_width -1 : 0] data_out;
output reg [1:0] status;


/// Internal signals 

reg [fifo_depth/3 + 1 : 0] write_ptr, write_ptr_next;
reg [fifo_depth/3 + 1: 0] read_ptr, read_ptr_next;
// fifo register array
reg [data_width-1:0] register_array [fifo_depth-1:0];       // [depth  2:0] ::[ Wdith 19:0]

// status flags
reg full, empty;

// default is to always write when fifo is not full

// register updates
    always@(posedge clk)
        begin
        if(!reset) begin
            read_ptr <= {fifo_depth{1'b0}};
            write_ptr <= {fifo_depth{1'b0}}; 
        end
        else
            begin
            write_ptr <= write_ptr_next;
            read_ptr <= read_ptr_next;
            register_array[write_ptr] <= data_in;       // sample     
            data_out <= register_array[read_ptr];
        end
        end


    // changing write_ptr and read_ptr value
    
    always@(*)
        begin
                // default values
         write_ptr_next = write_ptr;
         read_ptr_next = read_ptr;

         status = {full, empty};    

    case(command)       

        2'b10: 
            begin
                if(full != 1'b1)begin
                write_ptr_next = write_ptr + 1;                
                end
            end
        2'b01:
            begin
                if(empty != 1'b1) begin
                read_ptr_next = read_ptr + 1;
                end
            end
        default:             
            begin
             write_ptr_next = write_ptr;
             read_ptr_next = read_ptr;              
            end
        endcase
        
        end

        
///  status logic
// full logic -- check if MSB of counters are not equal and remaining two bits are equal
    always@(*)
        begin
        full = 1'b0;
        empty = 1'b0;
        
        if ((write_ptr[fifo_depth/3 + 1] != read_ptr[fifo_depth/3 + 1]) && (write_ptr[fifo_depth/3 :0] == read_ptr[fifo_depth/3 :0]))
           begin
            full = 1'b1;
            end


        if ((write_ptr[fifo_depth/3 + 1] == read_ptr[fifo_depth/3 + 1]) && (write_ptr[fifo_depth/3 :0] == read_ptr[fifo_depth/3 :0]))
           begin
            empty = 1'b1;
            end

            end            
             
          
              
endmodule
