// This packge contains parameter definitions

package top_pkg;

// global parameters
localparam RST_INITIAL_DELAY = 50;
localparam RST_HOLD_DELAY = 100;
localparam CLOCK_PERIOD = 10;

// AXI4 interface parameters
// AXI4 full
localparam ID_WIDTH = 2;
localparam AXI4_ADDR_WIDTH = 32;
localparam AXI4_DATA_WIDTH = 32;

// AXI4 Lite
localparam AXI4LITE_ADDR_WIDTH = 32;
localparam AXI4LITE_DATA_WIDTH = 32;


// parameter for mac_unit
    localparam DATA_WIDTH = 8;    
    localparam ACC_DATA_WIDTH = (2*DATA_WIDTH);

    localparam NOF_COEFF = 12;
    localparam NOF_MACS = NOF_COEFF-1;

    localparam FILTER_OUTPUT_DATA_WIDTH = 20;

endpackage