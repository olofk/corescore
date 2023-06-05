
module corescore_de10_nano_mistral
  (
   input  wire     i_clk,
   input wire i_rst_n,
   output wire o_uart_tx);

 //  wire        clk;
 //  wire        locked;

  //Create a 16MHz clock from 12MHz using PLL
 // pll pll12
 //   (.clock_in  (i_clk),
 //    .clock_out (clk),
 //    .locked    (locked));
   wire	       rst;
   
   assign rst  = !i_rst_n;

  // always @(posedge clk)
  //   rst <= !locked;

   parameter memfile_emitter = "emitter.hex";

   wire [7:0]  tdata;
   wire        tlast;
   wire        tvalid;
   wire        tready;

   corescorecore corescorecore
     (.i_clk     (i_clk),
      .i_rst     (rst),
      .o_tdata   (tdata),
      .o_tlast   (tlast),
      .o_tvalid  (tvalid),
      .i_tready  (tready));

   corescore_emitter_uart #(.clk_freq_hz (50_000_000)) emitter
     (.i_clk     (i_clk),
      .i_rst     (rst),
      .i_data    (tdata),
      .i_valid   (tvalid),
      .o_ready   (tready),
      .o_uart_tx (o_uart_tx));

endmodule

