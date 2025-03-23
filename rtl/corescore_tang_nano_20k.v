`default_nettype none
module corescore_tang_nano_20k
(
    input wire i_clk,
    input wire i_rst,
    output wire led,
    output wire o_uart_tx
);

    wire clk;
    wire locked;
    reg rst = 1'b1;

    // UART output to LED
    assign led = o_uart_tx;

    // Create a 16MHz clock from 27MHz using PLL
    tang_nano_20k_clock_gen pll (
        .lock (locked),
        .clkoutd (clk),
        .reset(i_rst),
        .clkin (i_clk)
    );

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

