`default_nettype none
module de5_net_clock_gen (
    input wire  i_clk,
    input wire  i_rst,
    output wire o_clk,
    output wire o_rst
  );

  wire        locked;
  reg [9:0]   r;

  assign o_rst = r[9];

  always @(posedge o_clk) begin
    if (locked)
      r <= {r[8:0], 1'b0};
    else
      r <= 10'b1111111111;
  end

  wire   clk;
  assign o_clk = clk;

  altera_pll #(
    .reference_clock_frequency("50.0 MHz"),
    .operation_mode("direct"),
    .output_clock_frequency0("16.000000 MHz")
  ) altera_pll_i (
    .rst(i_rst),
    .outclk({clk}),
    .locked(locked),
    .fboutclk(),
    .fbclk(1'b0),
    .refclk(i_clk)
  );

endmodule
