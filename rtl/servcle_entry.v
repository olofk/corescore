`default_nettype none
module servcle_entry
  #(parameter DW = 8,
    parameter [0:0] TOKEN_INIT = 1'b0)
   (
   input wire	       i_clk,
   input wire	       i_rst,
   //Control
   input wire [DW-1:0] i_reg_data,
   input wire	       i_reg_last,
   input wire	       i_reg_valid,
   output wire	       o_reg_ready,
   //Ring bus
   input wire [DW-1:0] i_data,
   input wire	       i_valid,
   input wire	       i_token,
   output reg [DW-1:0] o_data,
   output reg	       o_valid,
   output reg	       o_token);

   reg		       has_token;

   assign o_reg_ready = has_token;

   always @(posedge i_clk) begin
      /*
       Pass on token when we transmit the last data word
       or when a token came in but we have nothing to send
       */
      o_token <= (has_token & i_reg_valid & i_reg_last) | (i_token & !i_reg_valid);

      /*
       We have the token if a new one is coming in and we have something to
       send, or if we already had it and haven't transmitted the final word
       */
      has_token <= (i_token & i_reg_valid) | (has_token & !(i_reg_valid & i_reg_last));

      /*
       If we have the token, we set output as valid if we have something to
       send. Otherwise, we pass on the input to the output
       */
      o_valid <= has_token ? i_reg_valid : i_valid;

      if (!has_token | i_reg_valid)
	o_data <= has_token ? i_reg_data : i_data;

      if (i_rst) begin
	 has_token <= 1'b0;
	 o_valid <= 1'b0;
	 o_token <= TOKEN_INIT;
      end
   end

endmodule
`default_nettype wire
