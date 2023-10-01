// This packge contains parameter definitions

package top_pkg;

//
localparam RST_INITIAL_DELAY = 50;
localparam RST_HOLD_DELAY = 100;
localparam CLOCK_PERIOD = 10;


// parameter for mac_unit
    localparam DATA_WIDTH = 8;    
    localparam ACC_DATA_WIDTH = (2*DATA_WIDTH);

    localparam NOF_COEFF = 12;
    localparam NOF_MACS = NOF_COEFF-1;

    localparam FILTER_OUTPUT_DATA_WIDTH = 20;

endpackage