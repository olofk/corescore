`default_nettype none
module corescore_vcu128
(
 input wire  QDR4_CLK_100MHZ_P,
 input wire  QDR4_CLK_100MHZ_N,
 output wire GPIO_LED_0_LS,
 output wire UART1_TXD);

   wire      i_clk;
   wire      clk;
   wire      rst;

   //Mirror UART output to LED
   assign GPIO_LED_0_LS = UART1_TXD;

   IBUFGDS ibufds(
      .I (QDR4_CLK_100MHZ_P),
      .IB(QDR4_CLK_100MHZ_N),
      .O (i_clk));

   corescore_vcu128_clock_gen
   clock_gen
     (.i_clk (i_clk),
      .o_clk (clk),
      .o_rst (rst));

   parameter memfile_emitter = "emitter.hex";

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

   emitter #(.memfile (memfile_emitter)) emitter
     (.i_clk     (clk),
      .i_rst     (rst),
      .i_tdata   (tdata),
      .i_tlast   (tlast),
      .i_tvalid  (tvalid),
      .o_tready  (tready),
      .o_uart_tx (UART1_TXD));

endmodule
