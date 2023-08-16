/*
 * emitter_uart.v : Simple UA(R)T used as emitter in CoreScore
 *
 * SPDX-FileCopyrightText: 2023 Olof Kindgren <olof@award-winning.me>
 * SPDX-License-Identifier: Apache-2.0
 */

module emitter_uart
  #(parameter clk_freq_hz = 16_000_000,
    parameter baud_rate = 57600)
   (input wire	     i_clk,
    input wire	     i_rst,
    input wire [7:0] i_tdata,
    input wire	     i_tvalid,
    output reg	     o_tready,
    output wire	     o_uart_tx);

   localparam START_VALUE = clk_freq_hz/baud_rate;

   localparam WIDTH = $clog2(START_VALUE);

   reg [WIDTH:0] cnt;

   reg [9:0]	 data;

   assign o_uart_tx = data[0] | !(|data);

   always @(posedge i_clk) begin
      if (cnt[WIDTH] & !(|data))
        o_tready <= 1'b1;
      else if (i_tvalid & o_tready)
        o_tready <= 1'b0;

      if (o_tready | cnt[WIDTH])
        cnt <= {1'b0,START_VALUE[WIDTH-1:0]};
      else
        cnt <= cnt-1;

      if (cnt[WIDTH])
        data <= {1'b0, data[9:1]};
      else if (i_tvalid & o_tready)
        data <= {1'b1, i_tdata, 1'b0};
   end

endmodule
