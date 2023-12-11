`default_nettype none
module corescore_xyloni
(
 input wire  i_clk,
 input wire  i_pll_locked,
 output wire q,
 output wire o_uart_tx);

   wire [7:0]  tdata;
   wire        tlast;
   wire        tvalid;
   wire        tready;

   reg	       pll_locked_r;
   reg	       rst;

   assign q = o_uart_tx;

   always @(posedge i_clk) begin
      pll_locked_r <= i_pll_locked;
      rst <= ~pll_locked_r;
   end

   corescorecore corescorecore
     (.i_clk     (i_clk),
      .i_rst     (rst),
      .o_tdata   (tdata),
      .o_tlast   (tlast),
      .o_tvalid  (tvalid),
      .i_tready  (tready));

   emitter_uart emitter
     (.i_clk     (i_clk),
      .i_rst     (rst),
      .i_tdata   (tdata),
      .i_tvalid  (tvalid),
      .o_tready  (tready),
      .o_uart_tx (o_uart_tx));

endmodule
