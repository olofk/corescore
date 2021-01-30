`default_nettype none
module corescore_fpc_iii_clock_gen( input i_clk, output o_clk, output o_rst );
    
    wire locked;

    reg[ 1:0 ] rst_reg;
    always @( posedge o_clk )
	rst_reg <= { !locked, rst_reg[ 1 ] };

    assign o_rst = rst_reg[ 0 ];

    pll pll( .clki( i_clk ), .clko( o_clk ), .locked( locked ) );
endmodule
