`default_nettype none
module qm_xcvu13p_clock_gen
  (input wire  i_clk,
   output wire o_clk,
   output wire o_rst);

   wire   clkfb;
   wire   locked;
   reg 	  locked_r;
   reg 	  rst = 1'b1;

   assign o_rst = rst;

   MMCME4_BASE
     #(.DIVCLK_DIVIDE    (1),
       .CLKFBOUT_MULT_F  (16.0),
       .CLKOUT0_DIVIDE_F (100.0),
       .CLKIN1_PERIOD    (10.0), // 100 MHz
       .STARTUP_WAIT     ("FALSE"))
   mmcm
     (.CLKFBOUT    (clkfb),
      .CLKOUT0     (o_clk),
      .CLKIN1      (i_clk),
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
