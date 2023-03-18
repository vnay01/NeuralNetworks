// created by @vnay01
// file contains controller of matrix multiplier

`timescale 1ns/1ps
`define low_val 1'b0
`define count_depth 8
`define data_width 32
`define mem_depth 3
`define select 3

module controller(
                    clk,
                    reset,
                    enable,
                    count,
                    read_en,
                    rom_address,
                    ram_address,
                    bank_select_line,
                    select_line
                    
);
// port direction
    input clk;
    input reset;
    input enable;
    output reg [`count_depth-1:0] count;
    output reg read_en;
    output reg [`mem_depth-1:0] rom_address;
    output reg [`mem_depth-1:0] ram_address;
    output reg [`select:0] bank_select_line;
    output reg [`select-1:0] select_line;

//  internal signals
    reg read_en_next;
    reg [`mem_depth-1:0] rom_address_next;
    reg [`mem_depth-1:0] ram_address_next;  
    reg [`count_depth-1:0] count_next;
    reg [`select:0] bank_select_line_next;
    reg [`select-1:0] select_line_next;
    
// state parameters
localparam STATE_SIZE = 4;
localparam  START = 3'd0,
            READ = 3'd1,
            LOAD = 3'd2,
            MAC = 3'd3,
            STORE = 3'd4,
            DONE = 3'd5,
            STATE_6_PLACEHOLDER = 3'd6,
            STATE_7_PLACEHOLDER = 3'd7;
            
reg [STATE_SIZE-1:0]current_state, next_state;


//////////////////////////////////////////////////////
///////// Behavioral description starts here//////////
//////////////////////////////////////////////////////

// register update
always@(posedge clk , posedge reset)
begin
    if (reset)
    begin
    current_state <= START;
    count <= {`count_depth{`low_val}};
    rom_address <= {`mem_depth{`low_val}};
    ram_address <= {`mem_depth{`low_val}};
    read_en <= 1'b0;
    bank_select_line <= {`select{`low_val}};
    select_line <= {`select{`low_val}};
    end
    else if(enable) begin
    current_state <= next_state; 
    count <= count_next;
    rom_address <= rom_address_next;
    ram_address <= ram_address_next;
    read_en <= read_en_next;
    bank_select_line <= bank_select_line_next;
    select_line <= select_line_next;
    end

end

// State Change logic

always@(*)
    begin
      count_next = count + 1;
      next_state = current_state;
      read_en_next <= read_en;
      rom_address_next = rom_address;
      ram_address_next = ram_address;
      bank_select_line_next = bank_select_line;
      select_line_next = select_line;
      
        case(current_state)
        START : if(enable) 
                begin
                next_state = READ; 
                count_next = {`count_depth{`low_val}};
                bank_select_line_next = {`select+1{`low_val}};
                read_en_next <= 1'b1;           // enable memory blocks
                end
        // READ state enables reading of matrix elements into registerbank of accelarator 
        
        READ : begin 
//                read_en_next <= 1'b1;           // enable memory blocks
                rom_address_next = rom_address + 1;     // reads RAM locations : latency 2 clk cyc
                ram_address_next = ram_address + 1;     // reads ROM locations : latency 2 clk cyc

                // Two nested counters to run         
                select_line_next = select_line + 1;

                if (select_line == 3'b111)
                        bank_select_line_next = bank_select_line + 1;
                if (bank_select_line == 4'b1000) begin
                        next_state = LOAD;
                        read_en_next = 1'b0;            // disable memory blocks
                end
           
                end      
                          
        LOAD : if(count!=20)
                begin
                next_state = MAC;
                count_next = {`count_depth{`low_val}};
                end
        MAC : if(count==1)
                begin
                next_state = LOAD;
                count_next = {`count_depth{`low_val}};
                end
        STORE : if(count==10)
                begin
                next_state = START;
                count_next = {`count_depth{`low_val}};
                end 
        DONE : begin 
                next_state = START;
                count_next = {`count_depth{`low_val}};
                end  
        STATE_6_PLACEHOLDER : begin 
                              next_state = START;
                              count_next = {`count_depth{`low_val}};
                              end
        STATE_7_PLACEHOLDER :begin 
                             next_state = START;
                             count_next = {`count_depth{`low_val}};
                             end                              
        //default : next_state = START;               
        endcase    
    end

endmodule