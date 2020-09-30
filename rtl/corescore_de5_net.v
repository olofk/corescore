`default_nettype none
module corescore_de5_net (
    input wire        i_clk,
    input wire        i_rst_n,
    output wire       o_led_n,
    output wire       o_hex0_dp_n,
    output wire       o_hex1_dp_n,
    output wire       o_uart_txd,
    output wire       o_rs422_de,
    output wire       o_rs422_re_n,
    output wire       o_rs422_te
  );

  wire      clk;
  wire      rst;

  // Mirror UART output to LED and decimal point on 7-seg
  assign o_led_n = ~o_uart_txd;
  assign o_hex0_dp_n = o_uart_txd;
  assign o_hex1_dp_n = ~o_uart_txd;

  de5_net_clock_gen clock_gen
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
     .o_uart_tx (o_uart_txd));

  assign o_rs422_de = 1'b1;        // Driver enable
  assign o_rs422_re_n = 1'b1;      // Receiver disabled
  assign o_rs422_te = 1'b0;        // Disable RS-485 termination

endmodule
