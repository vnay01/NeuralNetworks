// AXI4 interface definitions
// parameter definitions in file "top_pkg.sv"

// slave
import top_pkg::*;
interface axi_full_intf (
                        input logic clk,
                        input logic rst_n
                        );
// AXI4 signals
logic [ID_WIDTH-1:0] arid;
logic [ID_WIDTH-1:0] rid;
logic [ID_WIDTH-1:0] awid;
logic [ID_WIDTH-1:0] bid;
logic [AXI4_ADDR_WIDTH-1:0] awaddr;
logic [AXI4_ADDR_WIDTH-1:0] araddr;
logic [AXI4_DATA_WIDTH-1:0] wdata;
logic [AXI4_DATA_WIDTH-1:0] rdata;
logic [7:0] awlen;
logic [2:0] awsize;
logic [1:0] awburst;
logic       awlock;
logic [3:0] awcache;
logic [2:0] awprot;
logic       awvalid;
logic [3:0] awqos;
logic       awready;
logic [(AXI4_DATA_WIDTH/8)-1:0] wstrb;
logic       wlast;
logic       wvalid;
logic       wready;
logic       bready;
logic [1:0] bresp;
logic       bvalid;
logic [7:0] arlen;
logic [2:0] arsize;
logic       arvalid;
logic [3:0] arqos;
logic       arready;
logic       rready;
logic       rlast;
logic       rvalid;
logic [1:0] rresp;

modport axi_slv(
    //ID
    input arid,awid,
    output rid,bid,
    //Address
    input awaddr, araddr,
    //Data
    input wdata,
    output rdata,
    // Wrire address channel
    input awlen, awsize, awburst, awlock, awcache, awprot, awvalid, awqos,
    output awready,
    // Write channel
    input wstrb, wlast, wvalid,
    output wready,
    // Write response channel
    input bready,
    output bresp, bvalid,
    // Read address channel
    input arlen, arsize, arburst, arlock, arcache, arprot, awvalid, arqos,
    output arready,
    // Read Channel
    input rready,
    output rlast, rvalid, rresp,
    input clk, rst_n
);
// Master interface
modport axi_mst(
    //ID
    output arid,awid,
    input rid,bid,
    //Address
    output awaddr, araddr,
    //Data
    output wdata,
    input rdata,
    // Wrire address channel
    output awlen, awsize, awburst, awlock, awcache, awprot, awvalid, awqos,
    input awready,
    // Write channel
    output wstrb, wlast, wvalid,
    input wready,
    // Write response channel
    output bready,
    input bresp, bvalid,
    // Read address channel
    output arlen, arsize, arburst, arlock, arcache, arprot, awvalid, arqos,
    input arready,
    // Read Channel
    output rready,
    input rlast, rvalid, rresp,
    input clk, rst_n
);
endinterface    

interface axi_lite_intf(input logic clk,
                        input logic rst_n
                        );

logic [AXI4LITE_ADDR_WIDTH-1:0] awaddr;
logic [2:0] awprot;
logic   awvalid;
logic   awready;
logic [AXI4LITE_DATA_WIDTH-1:0] wdata;
logic [(AXI4LITE_DATA_WIDTH/8)-1:0] wstrb;
logic                               wvalid;
logic wready;
logic [1:0] bresp;
logic bvalid;
logic bready;
logic [AXI4LITE_ADDR_WIDTH-1:0] araddr;
logic [2:0] arprot;
logic arvalid;
logic arready;
logic [AXI4LITE_DATA_WIDTH-1:0] rdata;
logic [1:0] rresp;
logic rvalid;
logic rready;

modport axi_lite_slv_intf (

input awaddr,
input awprot,
input awvalid,
output awready,
input wdata,
input wstrb,
input wvalid,
output wready,
output bresp,
output bvalid,
input bready,
input araddr,
input arprot,
input arvalid,
output arready,
output rdata,
output rresp,
output rvalid,
input rready,
input clk,
input rst_n
);

// axi4lite master
modport axi_lite_mst_intf (

output awaddr,
output awprot,
output awvalid,
output awready,
output wdata,
output wstrb,
output wvalid,
input wready,
input bresp,
input bvalid,
output bready,
output araddr,
output arprot,
output arvalid,
input arready,
input rdata,
input rresp,
input rvalid,
output rready,
input clk,
input rst_n
);

endinterface                        