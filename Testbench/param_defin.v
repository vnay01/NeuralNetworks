`ifndef num_width
    `define num_width 8
    `endif 
`ifndef data_bus
    `define data_bus (2*`num_width)
    `endif 
`ifndef high_val
    `define high_val 1'b1
    `endif 
`ifndef low_val    
    `define low_val 1'b0
    `endif 
  
  `ifndef mul
    `include "multiply.v"
    `endif
  
  `ifndef adder
    `include "adder.v"
    `endif 