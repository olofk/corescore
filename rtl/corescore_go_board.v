`default_nettype none
module corescore_go_board
(
 input wire  i_clk,
 output wire o_uart_tx,
 output wire o_led1,
 output wire o_led2 = 0,
 output wire o_led3 = 0,
 output wire o_led4 = 0,
 output wire o_pmod1);

   // Mirror UART output to LED1 and PMOD1
   assign o_led1 = !o_uart_tx;
   assign o_pmod1 = o_uart_tx;

   // Assert reset for 64 clock cycles. Use the 7th bit as the reset signal.
   reg [6:0]      rst_count;
   wire           rst_r = !rst_count[6];

   always @(posedge i_clk) begin
      if (rst_r == 1) begin
         rst_count <= rst_count + 1;
      end
   end

   wire [7:0]  tdata;
   wire        tvalid;
   wire        tready;

   corescorecore corescorecore
     (.i_clk     (i_clk),
      .i_rst     (rst_r),
      .o_tdata   (tdata),
      .o_tlast   (),
      .o_tvalid  (tvalid),
      .i_tready  (tready));

   emitter_uart #(.clk_freq_hz (25_000_000)) emitter
     (.i_clk     (i_clk),
      .i_rst     (rst_r),
      .i_tdata   (tdata),
      .i_tvalid  (tvalid),
      .o_tready  (tready),
      .o_uart_tx (o_uart_tx));

endmodule
