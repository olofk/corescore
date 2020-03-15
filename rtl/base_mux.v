/*
 mem = 00
 coll = 01
 timer = 10
 FIFO = 11
 */
module base_mux
  (
   input wire 	      i_clk,
   input wire 	      i_rst,
   input wire [31:0]  i_wb_cpu_adr,
   input wire [31:0]  i_wb_cpu_dat,
   input wire [3:0]   i_wb_cpu_sel,
   input wire 	      i_wb_cpu_we,
   input wire 	      i_wb_cpu_cyc,
   output wire [31:0] o_wb_cpu_rdt,
   output wire 	      o_wb_cpu_ack,
   //RW
   output wire [31:0] o_wb_mem_adr,
   output wire [31:0] o_wb_mem_dat,
   output wire [3:0]  o_wb_mem_sel,
   output wire 	      o_wb_mem_we,
   output wire 	      o_wb_mem_cyc,
   input wire [31:0]  i_wb_mem_rdt,
   //RW
   output wire [31:0] o_wb_coll_adr,
   output wire [31:0] o_wb_coll_dat,
   output wire 	      o_wb_coll_we,
   output wire 	      o_wb_coll_stb,
   input wire [31:0]  i_wb_coll_rdt,
   input wire 	      i_wb_coll_ack,
   //RW
   output wire [31:0] o_wb_timer_dat,
   output wire 	      o_wb_timer_we,
   output wire 	      o_wb_timer_cyc,
   input wire [31:0]  i_wb_timer_rdt,
   //W
   output wire [8:0]  o_wb_fifo_dat,
   output wire 	      o_wb_fifo_we,
   output wire 	      o_wb_fifo_stb,
   input wire 	      i_wb_fifo_ack);

   parameter sim = 0;

   reg 		      ack;

   wire 	  dmem_en  = i_wb_cpu_adr[31:30] == 2'b00;
   wire 	  coll_en  = i_wb_cpu_adr[31:30] == 2'b01;
   wire 	  timer_en = i_wb_cpu_adr[31:30] == 2'b10;
   wire 	  fifo_en  = i_wb_cpu_adr[31:30] == 2'b11;

   assign o_wb_cpu_rdt = coll_en  ? i_wb_coll_rdt :
			  timer_en ? i_wb_timer_rdt :
			  i_wb_mem_rdt;
   assign o_wb_cpu_ack = coll_en ? i_wb_coll_ack :
			  fifo_en ? i_wb_fifo_ack :
			  ack;

   always @(posedge i_clk) begin
      ack <= 1'b0;
      if (i_wb_cpu_cyc & (dmem_en | timer_en) & !ack)
	ack <= 1'b1;
      if (i_rst)
	ack <= 1'b0;
   end

   assign o_wb_mem_adr = i_wb_cpu_adr;
   assign o_wb_mem_dat = i_wb_cpu_dat;
   assign o_wb_mem_sel = i_wb_cpu_sel;
   assign o_wb_mem_we  = i_wb_cpu_we;
   assign o_wb_mem_cyc = i_wb_cpu_cyc & dmem_en;

   assign o_wb_coll_adr = i_wb_cpu_adr;
   assign o_wb_coll_dat = i_wb_cpu_dat;
   assign o_wb_coll_we  = i_wb_cpu_we;
   assign o_wb_coll_stb = i_wb_cpu_cyc & coll_en;

   assign o_wb_timer_dat = i_wb_cpu_dat;
   assign o_wb_timer_we  = i_wb_cpu_we;
   assign o_wb_timer_cyc = i_wb_cpu_cyc & timer_en;

   assign o_wb_fifo_dat = i_wb_cpu_dat[8:0];
   assign o_wb_fifo_we  = i_wb_cpu_we;
   assign o_wb_fifo_stb = i_wb_cpu_cyc & fifo_en;
endmodule
