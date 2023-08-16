module base
  (input wire 	     i_clk,
   input wire	     i_rst,
   input wire [7:0]  i_data,
   input wire	     i_last,
   input wire	     i_valid,
   input wire	     i_token,
   output wire [7:0] o_data,
   output wire	     o_last,
   output wire	     o_valid,
   output wire	     o_token);

   parameter [0:0]   TOKEN_INIT=1'b0;
   parameter memfile = "";
   parameter memsize = 8192;

   wire [31:0] 	     wb_dat;
   wire 	     wb_we;
   wire 	     wb_stb;
   wire 	     wb_ack;

   wire [7:0]	     tdata;
   wire		     tlast;
   wire		     tvalid;
   wire		     tready;

   servcle_entry
     #(.DW (8),
       .TOKEN_INIT (TOKEN_INIT))
   servcle_entry
     (
      .i_clk (i_clk),
      .i_rst (i_rst),

      .i_reg_data (tdata),
      .i_reg_last (tlast),
      .i_reg_valid (tvalid),
      .o_reg_ready (tready),

      .i_data  (i_data ),
      //.i_last  (i_last ),
      .i_valid (i_valid),
      .i_token (i_token),
      .o_data  (o_data ),
      //.o_last  (o_last ),
      .o_valid (o_valid),
      .o_token (o_token));

   wb2axis w2s
     (.i_clk (i_clk),
      .i_rst (i_rst),
      .i_wb_dat (wb_dat[8:0]),
      .i_wb_we  (wb_we),
      .i_wb_stb (wb_stb),
      .o_wb_ack (wb_ack),
      .o_tdata  (tdata),
      .o_tlast  (tlast),
      .o_tvalid (tvalid),
      .i_tready (tready));

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
