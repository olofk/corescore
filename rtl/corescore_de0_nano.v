`default_nettype none
module corescore_de0_nano
(
 input wire  i_clk,
 input wire  i_rst_n,
 output wire q,
 output wire o_uart_tx);

   wire      clk;
   wire      rst;

   //Mirror UART output to LED
   assign q = o_uart_tx;

   de0_nano_clock_gen clock_gen
     (.i_clk (i_clk),
      .i_rst (!i_rst_n),
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
