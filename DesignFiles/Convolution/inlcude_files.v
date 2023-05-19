/*
`ifndef top_module
    `include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/top_module.v"
    `endif
    */

`ifndef controller
    `include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/controller.v"
    `endif


`ifndef DataPath
   `include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/DataPath.v"
`endif
     
`ifndef multiplier_array
`include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/multiplier_array.v"
`endif


`ifndef L1_adder_array
`include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/L1_adder_array.v"
`endif

`ifndef L2_adder_array
`include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/L2_adder_array.v"
`endif

`ifndef L3_adder_array
`include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/L3_adder_array.v"
`endif

`ifndef L4_adder_array
`include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/L4_adder.v"
`endif
        
`ifndef fifo_buffer
     `include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/fifo_buffer.v"
    `endif    

`ifndef memory_controller
    `include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/memory_controller.v"
    `endif

`ifndef ram_buffer
    `include "/home/vnay01/Desktop/ConvNeuralNet/ConvNeuralNet.srcs/sources_1/new/ram_buffer.v"
    `endif


