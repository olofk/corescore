
module corescore_de10_nano_mistral
  (
   input  wire     i_clk,
   input wire i_rst_n,
   output wire o_uart_tx);

   
   reg  div_clk = 0;
   reg  counter = 0;
   

   always@(posedge i_clk) begin

      counter <= counter + 1;
      if(counter == 1) div_clk <= ~div_clk;
      
   end   

   
   wire	       rst;
   
   assign rst  = !i_rst_n;

   parameter memfile_emitter = "emitter.hex";

   wire [7:0]  tdata;
   wire        tlast;
   wire        tvalid;
   wire        tready;

   corescorecore corescorecore
     (.i_clk     (div_clk),
      .i_rst     (rst),
      .o_tdata   (tdata),
      .o_tlast   (tlast),
      .o_tvalid  (tvalid),
      .i_tready  (tready));

   corescore_emitter_uart #(.clk_freq_hz (12_500_000)) emitter
     (.i_clk     (div_clk),
      .i_rst     (rst),
      .i_data    (tdata),
      .i_valid   (tvalid),
      .o_ready   (tready),
      .o_uart_tx (o_uart_tx));

endmodule

