`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Vinay Singh
// 
// Create Date: 12/09/2023 08:57:06 AM
// Design Name: 
// Module Name: heartbeat
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


module heartbeat(
        input clk,
        input rst_n,
        output heartbeat
    );
    
    //slow down incoming clk
    logic [29:0] counter, counter_nxt;
    
    always_ff@(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            counter <= 0;
        end else begin
            counter <= counter_nxt + 1;        
        end
    end
    
    always_comb begin
        counter_nxt = counter;
        if(counter == 10000000)begin        
            counter_nxt = 0;
        end    
    end
    
    assign heartbeat = counter[27];   
    
endmodule
