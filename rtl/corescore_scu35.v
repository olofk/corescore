`default_nettype none
module corescore_scu35
(
 input wire  SYSCLK_P,
 input wire  SYSCLK_N,
 output wire led0_g,
 output wire scu35_uartb_txd);

   wire      i_clk;
   wire      clk;
   wire      rst;

   //Mirror UART output to LED
   assign led0_g = scu35_uartb_txd;

   IBUFGDS ibufds(
      .I (SYSCLK_P),
      .IB(SYSCLK_N),
      .O (i_clk));

   corescore_scu35_clock_gen
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
      .o_uart_tx (scu35_uartb_txd));

endmodule
