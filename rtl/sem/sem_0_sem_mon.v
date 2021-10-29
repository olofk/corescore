/////////////////////////////////////////////////////////////////////////////
//
//
//
/////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /
// \   \   \/    Core:          sem
//  \   \        Module:        sem_0_sem_mon
//  /   /        Filename:      sem_0_sem_mon.v
// /___/   /\    Purpose:       MON Shim for RS232 Port.
// \   \  /  \
//  \___\/\___\
//
/////////////////////////////////////////////////////////////////////////////
//
// (c) Copyright 2010 - 2019 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES. 
//
/////////////////////////////////////////////////////////////////////////////
//
// Module Description:
//
// This module is a MON Shim implementation for communication with external
// RS232 devices.  Examples of external devices include a desktop or laptop
// computer, or an embedded processor system.  This shim may be replaced with
// a custom user-supplied design to enable communication with other devices.
//
/////////////////////////////////////////////////////////////////////////////
//
// Port Definition:
//
// Name                          Type   Description
// ============================= ====== ====================================
// icap_clk                      input  The system clock signal.
//
// monitor_tx                    output Serial status output.  Synchronous
//                                      to icap_clk, but received externally
//                                      by another device as an asynchronous
//                                      signal, perceived as lower bitrate.
//                                      Uses 8N1 protocol.
//
// monitor_rx                    input  Serial command input.  Asynchronous
//                                      signal provided by another device at
//                                      a lower bitrate, synchronized to the
//                                      icap_clk and oversampled.  Uses 8N1
//                                      protocol.
//
// monitor_txdata[7:0]           input  Output data from controller,
//                                      qualified by monitor_txwrite.
//                                      Synchronous to icap_clk.
//
// monitor_txwrite               input  Write strobe, used by peripheral
//                                      to capture data.  Synchronous to
//                                      icap_clk.
//
// monitor_txfull                output Flow control signal indicating the
//                                      peripheral is not ready to receive
//                                      additional data writes.  Synchronous
//                                      to icap_clk.
//
// monitor_rxdata[7:0]           output Input data to controller qualified
//                                      by monitor_rxread. Synchronous to
//                                      icap_clk.
//
// monitor_rxread                input  Read strobe, used by peripheral
//                                      to change state.  Synchronous to
//                                      icap_clk.
//
// monitor_rxempty               output Flow control signal indicating the
//                                      peripheral is not ready to service
//                                      additional data reads.  Synchronous
//                                      to icap_clk.
//
/////////////////////////////////////////////////////////////////////////////
//
// Parameter and Localparam Definition:
//
// Name                          Type   Description
// ============================= ====== ====================================
// TCQ                           int    Sets the clock-to-out for behavioral
//                                      descriptions of sequential logic.
//
// V_ENABLETIME                  int    This sets communication baud rate;
//                                      see user guide for additional detail.
//
/////////////////////////////////////////////////////////////////////////////
//
// Module Dependencies:
//
// sem_0_sem_mon
// |
// +- sem_0_sem_mon_fifo
// |
// +- sem_0_sem_mon_piso
// |
// \- sem_0_sem_mon_sipo
//
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

/////////////////////////////////////////////////////////////////////////////
// Module
/////////////////////////////////////////////////////////////////////////////

module sem_0_sem_mon (
  input  wire        icap_clk,
  output wire        monitor_tx,
  input  wire        monitor_rx,
  input  wire  [7:0] monitor_txdata,
  input  wire        monitor_txwrite,
  output wire        monitor_txfull,
  output wire  [7:0] monitor_rxdata,
  input  wire        monitor_rxread,
  output wire        monitor_rxempty
  );

  ///////////////////////////////////////////////////////////////////////////
  // Define local constants.
  ///////////////////////////////////////////////////////////////////////////

  localparam TCQ = 1;
  // for 115200 baud @ 100 MHz:     100e6 / 16 / 115200 - 1 = 53
  localparam V_ENABLETIME = 53;

  ///////////////////////////////////////////////////////////////////////////
  // Declare signals.
  ///////////////////////////////////////////////////////////////////////////

  reg  [11:0] en_16_x_counter = 12'h000;
  wire        en_16_x_baud;
  wire        fifo_read;
  wire        fifo_data_present;
  wire  [7:0] fifo_data_out;
  wire        txfull_p;
  wire        fifo_write;
  wire  [7:0] fifo_data_in;
  wire        fifo_unused;
  wire        rxempty_n;

  ///////////////////////////////////////////////////////////////////////////
  // Create the 16x enable signal for baud rate generation.  This has an
  // initial value, but no functional reset; it runs continuously.
  ///////////////////////////////////////////////////////////////////////////

  always @(posedge icap_clk)
  begin
    if (en_16_x_baud)
      en_16_x_counter <= #TCQ 12'h000;
    else
      en_16_x_counter <= #TCQ en_16_x_counter + 12'h001;
  end

  assign en_16_x_baud = (en_16_x_counter == V_ENABLETIME[11:0]);

  ///////////////////////////////////////////////////////////////////////////
  // Implement the transmit channel with a FIFO and PISO.
  ///////////////////////////////////////////////////////////////////////////

  sem_0_sem_mon_fifo example_mon_fifo_tx (
    .data_in(monitor_txdata),
    .data_out(fifo_data_out),
    .write(monitor_txwrite),
    .read(fifo_read),
    .full(txfull_p),
    .data_present(fifo_data_present),
    .icap_clk(icap_clk)
    );

  sem_0_sem_mon_piso example_mon_piso (
    .data_in(fifo_data_out),
    .send_character(fifo_data_present),
    .en_16_x_baud(en_16_x_baud),
    .serial_out(monitor_tx),
    .tx_complete(fifo_read),
    .icap_clk(icap_clk)
    );

  assign monitor_txfull = txfull_p;

  ///////////////////////////////////////////////////////////////////////////
  // Implement the receive channel with a SIPO and FIFO.
  ///////////////////////////////////////////////////////////////////////////

  sem_0_sem_mon_sipo example_mon_sipo (
    .serial_in(monitor_rx),
    .data_out(fifo_data_in),
    .data_strobe(fifo_write),
    .en_16_x_baud(en_16_x_baud),
    .icap_clk(icap_clk)
    );

  sem_0_sem_mon_fifo example_mon_fifo_rx (
    .data_in(fifo_data_in),
    .data_out(monitor_rxdata),
    .write(fifo_write),
    .read(monitor_rxread),
    .full(fifo_unused),
    .data_present(rxempty_n),
    .icap_clk(icap_clk)
    );

  assign monitor_rxempty = !rxempty_n;

  ///////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////////

endmodule

/////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////
