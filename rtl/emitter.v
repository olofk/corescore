module emitter
  (input wire 	    i_clk,
   input wire 	    i_rst,
   input wire [7:0] i_tdata,
   input wire 	    i_tlast,
   input wire 	    i_tvalid,
   output wire 	    o_tready,
   output wire 	    o_uart_tx);

   parameter memfile = "";
   parameter memsize = 256;
   parameter sim = 0;

   wire [31:0] 	wb_ibus_adr;
   wire 	wb_ibus_cyc;
   wire [31:0] 	wb_ibus_rdt;
   wire 	wb_ibus_ack;

   wire [31:0] 	wb_dbus_adr;
   wire [31:0] 	wb_dbus_dat;
   wire [3:0] 	wb_dbus_sel;
   wire 	wb_dbus_we;
   wire 	wb_dbus_cyc;
   wire [31:0] 	wb_dbus_rdt;
   wire 	wb_dbus_ack;

   wire [31:0] 	wb_dmem_adr;
   wire [31:0] 	wb_dmem_dat;
   wire [3:0] 	wb_dmem_sel;
   wire 	wb_dmem_we;
   wire 	wb_dmem_cyc;
   wire [31:0] 	wb_dmem_rdt;
   wire 	wb_dmem_ack;

   wire [31:0] 	wb_mem_adr;
   wire [31:0] 	wb_mem_dat;
   wire [3:0] 	wb_mem_sel;
   wire 	wb_mem_we;
   wire 	wb_mem_cyc;
   wire [31:0] 	wb_mem_rdt;
   wire 	wb_mem_ack;

   wire 	wb_gpio_dat;
   wire 	wb_gpio_cyc;
//   wire 	wb_gpio_rdt;

   wire [0:0]	wb_fifo_sel;
   wire 	wb_fifo_stb;
   wire [9:0] 	wb_fifo_rdt;
   wire  	wb_fifo_ack;

   servant_arbiter arbiter
     (.i_wb_cpu_dbus_adr (wb_dmem_adr),
      .i_wb_cpu_dbus_dat (wb_dmem_dat),
      .i_wb_cpu_dbus_sel (wb_dmem_sel),
      .i_wb_cpu_dbus_we  (wb_dmem_we ),
      .i_wb_cpu_dbus_cyc (wb_dmem_cyc),
      .o_wb_cpu_dbus_rdt (wb_dmem_rdt),
      .o_wb_cpu_dbus_ack (wb_dmem_ack),

      .i_wb_cpu_ibus_adr (wb_ibus_adr),
      .i_wb_cpu_ibus_cyc (wb_ibus_cyc),
      .o_wb_cpu_ibus_rdt (wb_ibus_rdt),
      .o_wb_cpu_ibus_ack (wb_ibus_ack),

      .o_wb_cpu_adr (wb_mem_adr),
      .o_wb_cpu_dat (wb_mem_dat),
      .o_wb_cpu_sel (wb_mem_sel),
      .o_wb_cpu_we  (wb_mem_we ),
      .o_wb_cpu_cyc (wb_mem_cyc),
      .i_wb_cpu_rdt (wb_mem_rdt),
      .i_wb_cpu_ack (wb_mem_ack));

   emitter_mux #(sim) dmux
     (
      .i_clk (i_clk),
      .i_rst (i_rst),
      .i_wb_cpu_adr (wb_dbus_adr),
      .i_wb_cpu_dat (wb_dbus_dat),
      .i_wb_cpu_sel (wb_dbus_sel),
      .i_wb_cpu_we  (wb_dbus_we),
      .i_wb_cpu_cyc (wb_dbus_cyc),
      .o_wb_cpu_rdt (wb_dbus_rdt),
      .o_wb_cpu_ack (wb_dbus_ack),

      .o_wb_mem_adr (wb_dmem_adr),
      .o_wb_mem_dat (wb_dmem_dat),
      .o_wb_mem_sel (wb_dmem_sel),
      .o_wb_mem_we  (wb_dmem_we),
      .o_wb_mem_cyc (wb_dmem_cyc),
      .i_wb_mem_rdt (wb_dmem_rdt),

      .o_wb_gpio_dat (wb_gpio_dat),
      .o_wb_gpio_cyc (wb_gpio_cyc),
//      .i_wb_gpio_rdt (wb_gpio_rdt),

      .o_wb_timer_dat (),
      .o_wb_timer_we  (),
      .o_wb_timer_cyc (),
      .i_wb_timer_rdt (32'd0),

      .o_wb_fifo_sel (wb_fifo_sel),
      .o_wb_fifo_stb (wb_fifo_stb),
      .i_wb_fifo_rdt (wb_fifo_rdt),
      .i_wb_fifo_ack (wb_fifo_ack));

   servant_ram
     #(.memfile (memfile),
       .RESET_STRATEGY ("MINI"),
       .depth (memsize))
   ram
     (// Wishbone interface
      .i_wb_clk (i_clk),
      .i_wb_rst (i_rst),
      .i_wb_adr (wb_mem_adr[$clog2(memsize)-1:2]),
      .i_wb_cyc (wb_mem_cyc),
      .i_wb_we  (wb_mem_we) ,
      .i_wb_sel (wb_mem_sel),
      .i_wb_dat (wb_mem_dat),
      .o_wb_rdt (wb_mem_rdt),
      .o_wb_ack (wb_mem_ack));

   servant_gpio gpio
     (.i_wb_clk (i_clk),
      .i_wb_dat (wb_gpio_dat),
      .i_wb_we  (1'b1),
      .i_wb_cyc (wb_gpio_cyc),
      .o_wb_rdt (),
      .o_gpio   (o_uart_tx));

   axis2wb s2w
     (.i_clk (i_clk),
      .i_rst (i_rst),
      .i_wb_sel (wb_fifo_sel),
      .i_wb_stb (wb_fifo_stb),
      .o_wb_rdt (wb_fifo_rdt),
      .o_wb_ack (wb_fifo_ack),
      .i_tdata  (i_tdata),
      .i_tlast  (i_tlast),
      .i_tvalid (i_tvalid),
      .o_tready (o_tready));

   serv_rf_top
     #(.RESET_PC (32'h0000_0000),
       .WITH_CSR (0))
   cpu
     (
      .clk      (i_clk),
      .i_rst    (i_rst),
      .i_timer_irq  (1'b0),
`ifdef RISCV_FORMAL
      .rvfi_valid     (),
      .rvfi_order     (),
      .rvfi_insn      (),
      .rvfi_trap      (),
      .rvfi_halt      (),
      .rvfi_intr      (),
      .rvfi_mode      (),
      .rvfi_ixl       (),
      .rvfi_rs1_addr  (),
      .rvfi_rs2_addr  (),
      .rvfi_rs1_rdata (),
      .rvfi_rs2_rdata (),
      .rvfi_rd_addr   (),
      .rvfi_rd_wdata  (),
      .rvfi_pc_rdata  (),
      .rvfi_pc_wdata  (),
      .rvfi_mem_addr  (),
      .rvfi_mem_rmask (),
      .rvfi_mem_wmask (),
      .rvfi_mem_rdata (),
      .rvfi_mem_wdata (),
`endif

      .o_ibus_adr   (wb_ibus_adr),
      .o_ibus_cyc   (wb_ibus_cyc),
      .i_ibus_rdt   (wb_ibus_rdt),
      .i_ibus_ack   (wb_ibus_ack),

      .o_dbus_adr   (wb_dbus_adr),
      .o_dbus_dat   (wb_dbus_dat),
      .o_dbus_sel   (wb_dbus_sel),
      .o_dbus_we    (wb_dbus_we),
      .o_dbus_cyc   (wb_dbus_cyc),
      .i_dbus_rdt   (wb_dbus_rdt),
      .i_dbus_ack   (wb_dbus_ack));

endmodule
