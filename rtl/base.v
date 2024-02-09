module base
  (input wire 	     i_clk,
   input wire	     i_rst,
   output wire [7:0] o_waddr,
   output wire [7:0] o_wdata,
   output wire	     o_wen,
   output wire [7:0] o_raddr,
   input wire [7:0]  i_rdata,
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

   wire [31:0] 	wb_mem_adr;
   wire [31:0] 	wb_mem_dat;
   wire [3:0] 	wb_mem_sel;
   wire 	wb_mem_we;
   wire 	wb_mem_stb;
   wire [31:0] 	wb_mem_rdt;
   wire 	wb_mem_ack;

   wire [6:0] rf_waddr;
   wire [7:0] rf_wdata;
   wire	      rf_wen;
   wire [6:0] rf_raddr;
   wire [7:0] rf_rdata;
   wire	      rf_ren;


   servile_rf_mem_if
     #(.depth   (memsize))
   rf_mem_if
     (// Wishbone interface
      .i_clk (i_clk),
      .i_rst (i_rst),

      .i_waddr  (rf_waddr),
      .i_wdata  (rf_wdata),
      .i_wen    (rf_wen),
      .i_raddr  (rf_raddr),
      .o_rdata  (rf_rdata),
      .i_ren    (rf_ren),

      .o_sram_waddr (o_waddr),
      .o_sram_wdata (o_wdata),
      .o_sram_wen   (o_wen),
      .o_sram_raddr (o_raddr),
      .i_sram_rdata (i_rdata),
      .o_sram_ren   (),

      .i_wb_adr (wb_mem_adr[$clog2(memsize)-1:2]),
      .i_wb_stb (wb_mem_stb),
      .i_wb_we  (wb_mem_we) ,
      .i_wb_sel (wb_mem_sel),
      .i_wb_dat (wb_mem_dat),
      .o_wb_rdt (wb_mem_rdt),
      .o_wb_ack (wb_mem_ack));

   servile
     #(.reset_strategy ("NONE"),
       .with_csr (0))
   servile
     (.i_clk       (i_clk),
      .i_rst       (i_rst),
      .i_timer_irq (1'b0),

      //Memory interface
      .o_wb_mem_adr   (wb_mem_adr),
      .o_wb_mem_dat   (wb_mem_dat),
      .o_wb_mem_sel   (wb_mem_sel),
      .o_wb_mem_we    (wb_mem_we),
      .o_wb_mem_stb   (wb_mem_stb),
      .i_wb_mem_rdt   (wb_mem_rdt),
      .i_wb_mem_ack   (wb_mem_ack),

      //Extension interface
      .o_wb_ext_adr   (),
      .o_wb_ext_dat   (wb_dat),
      .o_wb_ext_sel   (),
      .o_wb_ext_we    (wb_we),
      .o_wb_ext_stb   (wb_stb),
      .i_wb_ext_rdt   (32'd0),
      .i_wb_ext_ack   (wb_ack),

      //RF IF
      .o_rf_waddr  (rf_waddr),
      .o_rf_wdata  (rf_wdata),
      .o_rf_wen    (rf_wen),
      .o_rf_raddr  (rf_raddr),
      .o_rf_ren    (rf_ren),
      .i_rf_rdata  (rf_rdata));

endmodule
