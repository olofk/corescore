`default_nettype none
module corescore_cisco_hwic_3g_cdma
(
 input wire  clk25,
 output wire led0,
 output wire uart_txd,
 output wire uart_drv_ena_,
 output wire uart_drv_sd_);

   wire      clk;
   wire      rst;

   //Mirror UART output to LED
   assign led0 = uart_txd;
   assign uart_drv_ena_     = 1'b0;            // ADM3222 EN_: Set 0 to enable RX
   assign uart_drv_sd_      = 1'b1;            // ADM3222 SD_: Set 1 to enabel TX

   cisco_hwic_3g_cdma_clock_gen clock_gen
     (.i_clk (clk25),
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
