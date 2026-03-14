`default_nettype none
module corescore_qm_xcvu13p
(
 input wire  i_clk_in,
 output wire q,
 output wire o_uart_tx,
 output wire o_uart_tx_dir);

   wire      i_clk;
   wire      clk;
   wire      rst;

   //Enable UART TX GPIO output
   assign o_uart_tx_dir = 1;

   //Mirror UART output to LED
   assign q = o_uart_tx;

   IBUF ibuf
     (.I  (i_clk_in),
      .O  (i_clk));

   qm_xcvu13p_clock_gen
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
