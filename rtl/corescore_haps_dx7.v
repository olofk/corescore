`default_nettype none
module corescore_haps_dx7
(
 input wire  i_clk_in,
 output wire o_clk_en,
 output wire q,
 output wire o_uart_tx);

   wire      i_clk;
   wire      clk;
   wire      rst;

   //Enable clock input
   assign o_clk_en = 1'b1;

   //Mirror UART output to LED
   assign q = o_uart_tx;

   IBUF ibuf
     (.I  (i_clk_in),
      .O  (i_clk));

   corescore_haps_dx7_clock_gen
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
      .o_uart_tx (o_uart_tx));

endmodule
