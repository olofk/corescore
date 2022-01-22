`default_nettype none
module cmod_a7_clock_gen
  (input wire  i_clk,
   output wire o_clk,
   output reg  o_rst);

   wire   clkfb;
   wire   locked;
   reg 	  locked_r;

   MMCME2_ADV #(
       .BANDWIDTH("OPTIMIZED"),
       .CLKFBOUT_MULT_F(64),
       .CLKIN1_PERIOD(83.33), // 12 MHz (not possible with PLLE2_BASE)
       .CLKOUT0_DIVIDE_F(48),
       .CLKOUT0_PHASE(1'd0),
       .DIVCLK_DIVIDE(1'd1),
       .REF_JITTER1(0.01)
   ) MMCME2_ADV (
       .CLKFBIN(clkfb),
       .CLKIN1(i_clk),
       .PWRDWN(0),
       .RST(1'b0),
       .CLKFBOUT(clkfb),
       .CLKOUT0(o_clk),
       .LOCKED(locked)
   );

   always @(posedge o_clk) begin
      locked_r <= locked;
      o_rst  <= !locked_r;
   end

endmodule
