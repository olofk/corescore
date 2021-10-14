`default_nettype none

module corescore_intel_a10gx_devkit
(
 input  wire rstn,
 input  wire clk50
 );

  wire        clk;
  wire        rst;
  wire [7:0]  tdata;
  wire        tlast;
  wire        tvalid;
  reg         tready;
  reg [7:0]   r_dat;
  wire        r_ena;

  // ================================================================
  // Generate 16MHz from 50MHz board Clock
  // ================================================================
  intel_a10gx_devkit_clock_gen clock_gen
  (
    .i_rst (~rstn),
    .i_clk (clk50),
    .o_clk (clk),
    .o_rst (rst)
  );

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
