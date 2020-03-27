module base
  (input wire 	     i_clk,
   input wire 	     i_rst,
   output wire [7:0] o_tdata,
   output wire 	     o_tlast,
   output wire 	     o_tvalid,
   input wire 	     i_tready);

   parameter memfile = "";
   parameter memsize = 8192;

   wire [31:0] 	     wb_dat;
   wire 	     wb_we;
   wire 	     wb_stb;
   wire 	     wb_ack;

   wb2axis w2s
     (.i_clk (i_clk),
      .i_rst (i_rst),
      .i_wb_dat (wb_dat[8:0]),
      .i_wb_we  (wb_we),
      .i_wb_stb (wb_stb),
      .o_wb_ack (wb_ack),
      .o_tdata  (o_tdata),
      .o_tlast  (o_tlast),
      .o_tvalid (o_tvalid),
      .i_tready (i_tready));

   serving
     #(.memfile  (memfile),
       .memsize  (memsize),
       .WITH_CSR (0))
   serving
     (.i_clk       (i_clk),
      .i_rst       (i_rst),
      .i_timer_irq (1'b0),

      .o_wb_adr   (),
      .o_wb_dat   (wb_dat),
      .o_wb_sel   (),
      .o_wb_we    (wb_we),
      .o_wb_stb   (wb_stb),
      .i_wb_rdt   (32'd0),
      .i_wb_ack   (wb_ack));

endmodule
