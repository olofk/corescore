`default_nettype none
module axis2wb
  (
   input wire 	     i_clk,
   input wire 	     i_rst,
   input wire [0:0]  i_wb_sel,
   input wire 	     i_wb_stb,
   output wire [9:0] o_wb_rdt,
   output reg 	     o_wb_ack,
   input wire [7:0]  i_tdata,
   input wire 	     i_tlast,
   input wire 	     i_tvalid,
   output wire 	     o_tready);

   always @(posedge i_clk) begin
      o_wb_ack <= i_wb_stb & !o_wb_ack;
      if (i_rst)
	o_wb_ack <= 1'b0;
   end

   assign o_tready = i_wb_sel[0] & o_wb_ack;
   assign o_wb_rdt = {i_tvalid, i_tlast, i_tdata};

endmodule
