`default_nettype none

module corescore_intel_agilex7
(
// input  wire rstn,
 input  wire i_clk,
 input  wire i_rstn
 );

  wire        clk;
  wire        rst;
  wire [7:0]  tdata;
  wire        tlast;
  wire        tvalid;
  reg         tready;
  reg [7:0]   r_dat;
  wire        r_ena;
  wire        ninit_done;
  wire        locked;

  reg         rst_reg1;
  reg         rst_reg2;

  assign rst = rst_reg2;

  // ================================================================
  // CPU Magic Inside
  // ================================================================
  corescorecore corescorecore
  (
   .i_clk     (clk),
   .i_rst     (rst),
   .o_tdata   (tdata),
   .o_tlast   (tlast),
   .o_tvalid  (tvalid),
   .i_tready  (tready)
   );

  // ================================================================
  // Synchronize Reset
  // ================================================================
  always @(posedge clk) begin
    if (!locked || !i_rstn) begin
      rst_reg1 <= 1'b1;
      rst_reg2 <= 1'b1;
    end else begin
      rst_reg1 <= 1'b0;
      rst_reg2 <= rst_reg1;
    end
  end

  // ================================================================
  // Agilex Reset Release
  // ================================================================
	altera_agilex_config_reset_release_endpoint config_reset_release_endpoint(
		.conf_reset(ninit_done)
	);

  // ================================================================
  // Basic Intel Parameterizable Macro for IOPLL
  // ================================================================
	ipm_iopll_basic #(
				.REFERENCE_CLOCK_FREQUENCY ("100.0 MHz"),
				.N_CNT                     (1),
				.M_CNT                     (8),
				.C0_CNT                    (50),
				.C1_CNT                    (1),
				.C2_CNT                    (1),
				.C3_CNT                    (1),
				.C4_CNT                    (1),
				.C5_CNT                    (1),
				.C6_CNT                    (1)
  ) core_pll (
				.refclk                             (i_clk),        //input, width = 1
				.reset                              (ninit_done),   //input, width = 1
				.outclk0                            (clk),          //output, width = 1
				.outclk1                            (),             //output, width = 1
				.outclk2                            (),             //output, width = 1
				.outclk3                            (),             //output, width = 1
				.outclk4                            (),             //output, width = 1
				.outclk5                            (),             //output, width = 1
				.outclk6                            (),             //output, width = 1
				.locked                             (locked)        //output, width = 1
	);

  // ================================================================
  // Pipeline response as UART expects 1 clk delay after r_ena goes active
  // before you can push characters into it.
  // ================================================================
  always @(posedge clk) begin
   if (tvalid & r_ena) begin
     tready <= 1'b1;
     r_dat  <= tdata;
   end else begin
     tready <= 1'b0;
   end
  end

  // ================================================================
  // Instantiate the internal JTAG-UART interface as the GX Devkit has no UART pins.
  //
  // NOTE - UART will stall indefinety when its tx-fifo is full,
  // so you must run nios-terminal.exe to allow things to flow
  // ================================================================
  alt_jtag_atlantic #(
  .INSTANCE_ID(0),
   .LOG2_RXFIFO_DEPTH(6),
   .LOG2_TXFIFO_DEPTH(6),
   .SLD_AUTO_INSTANCE_INDEX("YES")
  ) i_uart (
   .clk    (clk),
   .rst_n   (~rst),
   .r_dat  (r_dat),
   .r_ena  (r_ena),
   .r_val  (tready),
   // Not interested in RX
   .t_dat  (),
   .t_dav  (1'b1),
   .t_ena  (),
   .t_pause()
  );

endmodule
