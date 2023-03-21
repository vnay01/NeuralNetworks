`ifndef in_Col              ///// Number of columns in Input Matrix
    `define in_Col 4
    `endif
`ifndef in_Row             ///// Number of rows in Input Matrix
    `define in_Row 4
    `endif

`ifndef num_width
    `define num_width 8
    `endif 
`ifndef data_bus
    `define data_bus (2*`num_width)
    `endif 
`ifndef scratchpad_width
    `define scratchpad_width (`in_Col*`num_width)    
    `endif
`ifndef high_val
    `define high_val 1'b1
    `endif 
`ifndef low_val    
    `define low_val 1'b0
    `endif 