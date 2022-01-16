`default_nettype none
module corescore_icebreaker
  (
   input i_clk,
   output wire o_uart_tx);

   wire        clk;
   wire        locked;

   //Create a 16MHz clock from 12MHz using PLL
   SB_PLL40_PAD
     #(
       .FEEDBACK_PATH("SIMPLE"),
       .DIVR(4'b0000),
       .DIVF(7'b1010100),
       .DIVQ(3'b110),
       .FILTER_RANGE(3'b001))
   pll
     (.LOCK(locked),
      .RESETB(1'b1),
      .BYPASS(1'b0),
      .PACKAGEPIN(i_clk),
      .PLLOUTCORE(clk));

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
