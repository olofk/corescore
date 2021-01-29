module corescore_polarfire
(
 input wire  i_clk,
 input wire resetbtn,
 output wire q,
 output reg h,
 output wire o_uart_tx);

   wire      clk;
   wire      rst;

   //Mirror UART output to LED
   assign q = o_uart_tx;

   assign rst = ~resetbtn;

   PF_CCC_C0_PF_CCC_C0_0_PF_CCC clock_gen
     (.REF_CLK_0 (i_clk),
      .OUT0_FABCLK_0 (clk));

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


  // Heartbeat led
  reg [$clog2(16000000)-1:0] count = 0;
   always @(posedge clk) begin
      if (rst) begin
        count <= 0;
        h <= 0;
      end else
        count <= count + 1;
      if (count == 16000000-1) begin
         h <= !h;
         count <= 0;
      end
   end

endmodule
