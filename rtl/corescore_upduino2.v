`default_nettype none
module corescore_upduino2
  (
   output wire g,
   output wire b,
   output wire r,
   output wire o_uart_tx);

   wire        clk48;
   wire        clk;
   wire        locked;


   SB_HFOSC inthosc
     (
      .CLKHFPU(1'b1),
      .CLKHFEN(1'b1),
      .CLKHF(clk48));

   SB_PLL40_CORE
     #(
       .FEEDBACK_PATH("SIMPLE"),
       .DIVR(4'b0010),
       .DIVF(7'b0111111),
       .DIVQ(3'b110),
       .FILTER_RANGE(3'b001))
   pll
     (.LOCK(locked),
      .RESETB(1'b1),
      .BYPASS(1'b0),
      .REFERENCECLK(clk48),
      .PLLOUTCORE(clk));

   SB_RGBA_DRV
     #(
       .CURRENT_MODE ("0b1"),
       .RGB0_CURRENT ("0b000111"),
       .RGB1_CURRENT ("0b000111"),
       .RGB2_CURRENT ("0b000111"))
   RGBA_DRIVER
     (
      .CURREN(1'b1),
      .RGBLEDEN(1'b1),
      .RGB0PWM(o_uart_tx),
      .RGB1PWM(o_uart_tx),
      .RGB2PWM(o_uart_tx),
      .RGB0(g),
      .RGB1(b),
      .RGB2(r));

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
