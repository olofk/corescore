`default_nettype none
module corescore_marble (
    input wire  i_clk_p,
    input wire  i_clk_n,
    output wire o_uart_tx
);

    wire main_crg_clkin;
    IBUFDS IBUFDS(
        .I(i_clk_p),
        .IB(i_clk_n),
        .O(main_crg_clkin)
    );

    // Create a 128 MHz clock usin MMCME
    wire builder_mmcm_fb;
    wire locked;
    MMCME2_ADV #(
        .BANDWIDTH("OPTIMIZED"),
        .CLKFBOUT_MULT_F(4'd16),
        .CLKIN1_PERIOD(8.0),
        .CLKOUT0_DIVIDE_F(15.625),
        .CLKOUT0_PHASE(1'd0),
        .DIVCLK_DIVIDE(1'd1),
        .REF_JITTER1(0.01)
    ) MMCME2_ADV (
        .CLKFBIN(builder_mmcm_fb),
        .CLKIN1(main_crg_clkin),
        .PWRDWN(0),
        .RST(),
        .CLKFBOUT(builder_mmcm_fb),
        .CLKOUT0(main_crg_clkout0),
        .LOCKED(locked)
    );

    wire clk;
    reg rst = 1;
    reg locked_r = 0;

    BUFG BUFG(
        .I(main_crg_clkout0),
        .O(clk)
    );

    always @(posedge clk) begin
      locked_r <= locked;
      rst <= !locked_r;
    end

   parameter memfile_emitter = "emitter.hex";

   wire [7:0]  tdata;
   wire        tlast;
   wire        tvalid;
   wire        tready;

   corescorecore corescorecore
     (.i_clk     (clk),
      .i_rst     (rst),
      .o_tdata   (tdata),
      .o_tlast   (tlast),
      .o_tvalid  (tvalid),
      .i_tready  (tready));

   emitter #(.memfile (memfile_emitter)) emitter
     (.i_clk     (clk),
      .i_rst     (rst),
      .i_tdata   (tdata),
      .i_tlast   (tlast),
      .i_tvalid  (tvalid),
      .o_tready  (tready),
      .o_uart_tx (o_uart_tx));

endmodule
