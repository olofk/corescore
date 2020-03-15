`default_nettype none
module wb2axis
  (
   input wire 	     i_clk,
   input wire 	     i_rst,
   input wire [8:0]  i_wb_dat,
   input wire 	     i_wb_we,
   input wire 	     i_wb_stb,
   output reg 	     o_wb_ack,
   output wire [7:0] o_tdata,
   output wire 	     o_tlast,
   output wire 	     o_tvalid,
   input wire 	     i_tready);

   always @(posedge i_clk) begin
      o_wb_ack <= i_wb_stb & i_tready & !o_wb_ack;
      if (i_rst)
	o_wb_ack <= 1'b0;
   end

   assign o_tvalid = i_wb_stb & i_wb_we & !o_wb_ack;
   assign o_tdata  = i_wb_dat[7:0];
   assign o_tlast  = i_wb_dat[8];

endmodule
