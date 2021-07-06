`default_nettype none
module corescore_ep2c5t144_devboard
(
 input wire  clk50,
 output wire led0,
 output wire uart_txd);

   wire      clk;
   wire      rst;

   //Mirror UART output to LED
   assign led0 = uart_txd;

   ep2c5t144_clock_gen clock_gen
     (.i_clk (clk50),
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
      .o_uart_tx (uart_txd));

endmodule
