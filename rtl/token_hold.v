module token_hold
  (
   input wire  i_clk,
   input wire  i_rst,
   input wire  i_token,
   input wire  i_hold,
   output wire o_token);

   reg	       token;

   assign o_token = i_hold ? 1'b0 : (i_token | token);

   always @(posedge i_clk)
     token <= (i_hold & i_token) | token & !(o_token | i_rst);

endmodule
     
