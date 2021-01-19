`default_nettype none
module corescore_haps_dx7_clock_gen
  (input wire  i_clk,
   output wire o_clk,
   output wire o_rst);

   wire   clkfb;
   wire   locked;
   reg 	  locked_r;
   reg 	  rst = 1'b1;

   assign o_rst = rst;

   MMCME2_ADV
     #(.DIVCLK_DIVIDE    (5),
       .CLKFBOUT_MULT_F  (30.000),
       .CLKOUT0_DIVIDE_F (50.0),
       .CLKIN1_PERIOD    (7.5001875), //133.33 MHz
       .STARTUP_WAIT     ("FALSE"))
   mmcm
     (.CLKFBOUT    (clkfb),
      .CLKFBOUTB   (),
      .CLKOUT0     (o_clk),
      .CLKOUT0B    (),
      .CLKOUT1     (),
      .CLKOUT1B    (),
      .CLKOUT2     (),
      .CLKOUT2B    (),
      .CLKOUT3     (),
      .CLKOUT3B    (),
      .CLKOUT4     (),
      .CLKOUT5     (),
      .CLKIN1      (i_clk),
      .CLKIN2      (1'b0),
      .CLKINSEL    (1'b1),
      .LOCKED      (locked),
      .PWRDWN      (1'b0),
      .RST         (1'b0),
      .CLKFBIN     (clkfb));

   always @(posedge o_clk) begin
      locked_r <= locked;
      if (locked_r) begin
          rst <= 1'b0;
      end else begin
          rst <= rst;
      end
   end

endmodule
