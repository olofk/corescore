`default_nettype none
module corescore_arty_a7
(
 input wire  i_clk,
 output wire q,
 output wire o_uart_tx);

   wire      clk;
   wire      rst;

   //Mirror UART output to LED
   assign q = o_uart_tx;

   arty_a7_clock_gen clock_gen
     (.i_clk (i_clk),
      .o_clk (clk),
      .o_rst (rst));

   wire [7:0]  tdata;
   wire        tlast;
   wire        tvalid;
   wire        tready;

   corescorecore corescorecore
     (.i_clk     (clk),
      .i_rst     (rst),
      .o_tdata   (tdata),
      .o_tlast   (tlast),
      .o_tvalid  (tvalid),
      .i_tready  (tready));

   emitter_uart emitter
     (.i_clk     (clk),
      .i_rst     (rst),
      .i_tdata   (tdata),
      .i_tvalid  (tvalid),
      .o_tready  (tready),
      .o_uart_tx (o_uart_tx));

endmodule
