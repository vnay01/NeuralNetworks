// Testbench
//`define FULL_TEST_BENCH

import top_pkg::*;

module tb;

//testbench signals
logic clk_gen;
logic rst_gen;

integer tv_counter;

logic tb_enable;

logic signed [DATA_WIDTH-1:0] tb_input_sample;
logic signed [DATA_WIDTH-1:0] tb_coeff [NOF_COEFF];

logic signed [ACC_DATA_WIDTH-1:0]tb_fir_output;
logic tb_hearbeat;



// VIP initialization for clock & reset
initial begin
    tb.clk_i.inst.IF.start_clock();
    #(RST_INITIAL_DELAY);
    tb.rst_i.inst.IF.assert_reset();
    #(RST_HOLD_DELAY);
    tb.rst_i.inst.IF.deassert_reset();
end


// Stimulus

initial begin
    tb_enable = 0;
    tb_input_sample = 0;
    #120ns;
    tb_enable = 1;
    tb_input_sample = 1; // test sample
end


// Module Instantiations
// ToDo: Make it generic
clk_vip_0 clk_i (
  .clk_out(clk_gen)  // output wire clk_out
);

rst_vip_0 rst_i (
  .rst_out(rst_gen)  // output wire rst_out
);

`ifdef FULL_TEST_BENCH
// DUT
fir fir_i (
          .clk(clk_gen),
          .rst_n(rst_gen),
          .enable(tb_enable),
          .input_sample(tb_input_sample),
          .coeff(tb_coeff),
          .fir_output(tb_fir_output)
        );
        
// AXI Verification IP

axi_vip_0 axi_vip_mst (
  .aclk(clk_gen),                      // input wire aclk
  .aresetn(rst_n),                // input wire aresetn
  .m_axi_awaddr(m_axi_awaddr),      // output wire [31 : 0] m_axi_awaddr
  .m_axi_awlen(m_axi_awlen),        // output wire [7 : 0] m_axi_awlen
  .m_axi_awsize(m_axi_awsize),      // output wire [2 : 0] m_axi_awsize
  .m_axi_awburst(m_axi_awburst),    // output wire [1 : 0] m_axi_awburst
  .m_axi_awlock(m_axi_awlock),      // output wire [0 : 0] m_axi_awlock
  .m_axi_awcache(m_axi_awcache),    // output wire [3 : 0] m_axi_awcache
  .m_axi_awprot(m_axi_awprot),      // output wire [2 : 0] m_axi_awprot
  .m_axi_awregion(m_axi_awregion),  // output wire [3 : 0] m_axi_awregion
  .m_axi_awqos(m_axi_awqos),        // output wire [3 : 0] m_axi_awqos
  .m_axi_awvalid(m_axi_awvalid),    // output wire m_axi_awvalid
  .m_axi_awready(m_axi_awready),    // input wire m_axi_awready
  .m_axi_wdata(m_axi_wdata),        // output wire [31 : 0] m_axi_wdata
  .m_axi_wstrb(m_axi_wstrb),        // output wire [3 : 0] m_axi_wstrb
  .m_axi_wlast(m_axi_wlast),        // output wire m_axi_wlast
  .m_axi_wvalid(m_axi_wvalid),      // output wire m_axi_wvalid
  .m_axi_wready(m_axi_wready),      // input wire m_axi_wready
  .m_axi_bresp(m_axi_bresp),        // input wire [1 : 0] m_axi_bresp
  .m_axi_bvalid(m_axi_bvalid),      // input wire m_axi_bvalid
  .m_axi_bready(m_axi_bready),      // output wire m_axi_bready
  .m_axi_araddr(m_axi_araddr),      // output wire [31 : 0] m_axi_araddr
  .m_axi_arlen(m_axi_arlen),        // output wire [7 : 0] m_axi_arlen
  .m_axi_arsize(m_axi_arsize),      // output wire [2 : 0] m_axi_arsize
  .m_axi_arburst(m_axi_arburst),    // output wire [1 : 0] m_axi_arburst
  .m_axi_arlock(m_axi_arlock),      // output wire [0 : 0] m_axi_arlock
  .m_axi_arcache(m_axi_arcache),    // output wire [3 : 0] m_axi_arcache
  .m_axi_arprot(m_axi_arprot),      // output wire [2 : 0] m_axi_arprot
  .m_axi_arregion(m_axi_arregion),  // output wire [3 : 0] m_axi_arregion
  .m_axi_arqos(m_axi_arqos),        // output wire [3 : 0] m_axi_arqos
  .m_axi_arvalid(m_axi_arvalid),    // output wire m_axi_arvalid
  .m_axi_arready(m_axi_arready),    // input wire m_axi_arready
  .m_axi_rdata(m_axi_rdata),        // input wire [31 : 0] m_axi_rdata
  .m_axi_rresp(m_axi_rresp),        // input wire [1 : 0] m_axi_rresp
  .m_axi_rlast(m_axi_rlast),        // input wire m_axi_rlast
  .m_axi_rvalid(m_axi_rvalid),      // input wire m_axi_rvalid
  .m_axi_rready(m_axi_rready)      // output wire m_axi_rready
);
`else

    heartbeat heartbeat_i(
        .clk(clk_gen),
        .rst_n(rst_gen),
        .heartbeat(tb_hearbeat)
    );
        
`endif

endmodule    