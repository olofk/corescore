`default_nettype none
module corescore_tinyfpga_bx
(input wire  i_clk,
 inout wire  pin_usb_p,
 inout wire  pin_usb_n,
 output wire pin_pu);

   wire      clk;
   wire      clk_locked;

   // USB Host Detect Pull Up
   assign pin_pu = 1'b1;

   pll pll48
     (.clock_in  (i_clk),
      .clock_out (clk),
      .locked    (clk_locked));

    // Generate reset signal
    reg [5:0] reset_cnt = 0;
    wire reset = ~reset_cnt[5];
    always @(posedge clk)
        if ( clk_locked )
            reset_cnt <= reset_cnt + reset;

   reg 	 rst;
   reg 	 rst_r;

   always @(posedge i_clk) begin
      rst_r <= reset;
      rst <= rst_r;
   end
   wire [7:0]  tdata;
   wire        tvalid;
   wire        tready;

   wire [7:0]  usb_tdata;
   wire        usb_tvalid;
   wire        usb_tready;

   corescorecore corescorecore
     (.i_clk     (i_clk),
      .i_rst     (rst),
      .o_tdata   (tdata),
      .o_tlast   (),
      .o_tvalid  (tvalid),
      .i_tready  (tready));

   axis_async_fifo
     #(
       .DEPTH(4),
       .DATA_WIDTH(8),
       .KEEP_ENABLE(0),
       .KEEP_WIDTH(0),
       .LAST_ENABLE(0),
       .ID_ENABLE(0),
       .ID_WIDTH(0),
       .DEST_ENABLE(0),
       .DEST_WIDTH(0),
       .USER_ENABLE(0),
       .USER_WIDTH(0),
       .FRAME_FIFO(0),
       .USER_BAD_FRAME_VALUE(0),
       .USER_BAD_FRAME_MASK(0),
       .DROP_BAD_FRAME(0),
       .DROP_WHEN_FULL(0))
   UUT
     (// Common reset
      .async_rst (rst),
      // AXI input
      .s_clk(i_clk),
      .s_axis_tdata(tdata),
    .s_axis_tkeep(),
    .s_axis_tvalid(tvalid),
    .s_axis_tready(tready),
    .s_axis_tlast(),
    .s_axis_tid(),
    .s_axis_tdest(),
    .s_axis_tuser(),
    // AXI output
    .m_clk(clk),
    .m_axis_tdata  (usb_tdata),
    .m_axis_tkeep  (),
    .m_axis_tvalid (usb_tvalid),
    .m_axis_tready (usb_tready),
    .m_axis_tlast  (),
    .m_axis_tid    (),
    .m_axis_tdest  (),
    .m_axis_tuser  (),
    // Status
    .s_status_overflow   (),
    .s_status_bad_frame  (),
    .s_status_good_frame (),
    .m_status_overflow   (),
    .m_status_bad_frame  (),
    .m_status_good_frame ());

    wire usb_p_tx;
    wire usb_n_tx;
    wire usb_p_rx;
    wire usb_n_rx;
    wire usb_tx_en;

   usb_uart_core uart
     (
      .clk_48mhz  (clk),
      .reset      (reset),
      // pins - these must be connected properly to the outside world.  See below.
      .usb_p_tx   (usb_p_tx),
      .usb_n_tx   (usb_n_tx),
      .usb_p_rx   (usb_p_rx),
      .usb_n_rx   (usb_n_rx),
      .usb_tx_en  (usb_tx_en),
      // uart pipeline in
      .uart_in_data  (usb_tdata),
      .uart_in_valid (usb_tvalid),
      .uart_in_ready (usb_tready),
      // uart pipeline out
      .uart_out_data  (),
      .uart_out_valid (/*tvalid*/),
      .uart_out_ready (tready),
      .debug          ());

   wire        usb_p_in;
   wire        usb_n_in;

   assign usb_p_rx = usb_tx_en ? 1'b1 : usb_p_in;
   assign usb_n_rx = usb_tx_en ? 1'b0 : usb_n_in;

   SB_IO
     #(.PIN_TYPE(6'b 1010_01), // PIN_OUTPUT_TRISTATE - PIN_INPUT
       .PULLUP(1'b 0))
   iobuf_usbp
     (.PACKAGE_PIN   (pin_usb_p),
      .OUTPUT_ENABLE (usb_tx_en),
      .D_OUT_0       (usb_p_tx),
      .D_IN_0        (usb_p_in));

    SB_IO #(
        .PIN_TYPE(6'b 1010_01), // PIN_OUTPUT_TRISTATE - PIN_INPUT
        .PULLUP(1'b 0)
    ) iobuf_usbn (
        .PACKAGE_PIN(pin_usb_n),
        .OUTPUT_ENABLE(usb_tx_en),
        .D_OUT_0(usb_n_tx),
        .D_IN_0(usb_n_in)
    );

endmodule
