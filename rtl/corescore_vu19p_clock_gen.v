`default_nettype none
module corescore_vu19p_clock_gen
  (input wire  i_clk,
   output wire o_clk,
   output reg  o_rst);

   wire   clkfb;
   wire   locked;
   reg 	  locked_r;

   MMCME4_ADV
     #(.DIVCLK_DIVIDE    (4),
       .CLKFBOUT_MULT_F  (32.000),
       .CLKOUT0_DIVIDE_F (50.0),
       .CLKIN1_PERIOD    (10.0), //100MHz
       .STARTUP_WAIT     ("FALSE"))
   mmcm
     (.CLKFBOUT    (clkfb),
      .CLKFBOUTB   (),
      .CLKOUT0     (o_clk),      // 16MHz
      .CLKOUT0B    (),
      .CLKOUT1     (),
      .CLKOUT1B    (),
      .CLKOUT2     (),
      .CLKOUT2B    (),
      .CLKOUT3     (),
      .CLKOUT3B    (),
      .CLKOUT4     (),
      .CLKOUT5     (),
      .CLKOUT6     (),
      .CLKIN1      (i_clk),
      .CLKIN2      (1'b0),
      .CLKINSEL    (1'b1),
      .LOCKED      (locked),
      .PWRDWN      (1'b0),
      .RST         (1'b0),
      .CLKFBIN     (clkfb));

   always @(posedge o_clk) begin
      locked_r <= locked;
      o_rst  <= !locked_r;
   end

endmodule
