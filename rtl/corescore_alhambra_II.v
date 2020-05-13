`default_nettype none
module corescore_alhambra_II
  (
   input i_clk,
   output wire locked_led,
   output wire o_uart_tx);

   wire        clk;
   wire        locked;

   //Mirror locked PLL to LED
   assign locked_led = locked;

  //Create a 16MHz clock from 12MHz using PLL
  pll pll48
    (.clock_in  (i_clk),
     .clock_out (clk),
     .locked    (locked));

   reg 	     rst = 1'b1;

   always @(posedge clk)
     rst <= !locked;

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
