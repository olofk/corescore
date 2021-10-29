/////////////////////////////////////////////////////////////////////////////
//
//
//
/////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /
// \   \   \/    Core:          sem
//  \   \        Module:        sem_0_sem_mon_piso
//  /   /        Filename:      sem_0_sem_mon_piso.v
// /___/   /\    Purpose:       MON Shim 8N1 PISO.
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
// This module contains an 8N1 PISO implementation.
//
/////////////////////////////////////////////////////////////////////////////
//
// Port Definition:
//
// Name                          Type   Description
// ============================= ====== ====================================
// icap_clk                      input  The system clock signal.
//
// data_in[7:0]                  input  Input to the PISO. Synchronous
//                                      to icap_clk.
//
// send_character                input  Qualifies availability of valid
//                                      data on data_in port.  Synchronous
//                                      to icap_clk.
//
// en_16_x_baud                  input  Enable signal with periodic single
//                                      cycle pulses at 16 times baud rate.
//                                      Synchronous to icap_clk.
//
// serial_out                    output Serialized output.  Synchronous
//                                      to icap_clk.
//
// tx_complete                   output Indicates transmission complete.
//                                      Synchronous to icap_clk.
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
/////////////////////////////////////////////////////////////////////////////
//
// Module Dependencies:
//
// sem_0_sem_mon_piso
// |
// \- FD (unisim)
//
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

/////////////////////////////////////////////////////////////////////////////
// Module
/////////////////////////////////////////////////////////////////////////////

module sem_0_sem_mon_piso (
  input  wire        icap_clk,
  input  wire  [7:0] data_in,
  input  wire        send_character,
  input  wire        en_16_x_baud,
  output wire        serial_out,
  output wire        tx_complete
  );

  ///////////////////////////////////////////////////////////////////////////
  // Define local constants.
  ///////////////////////////////////////////////////////////////////////////

  localparam TCQ = 1;

  ///////////////////////////////////////////////////////////////////////////
  // Declare signals.
  ///////////////////////////////////////////////////////////////////////////

  reg  [15:0] hot_delay = 16'h0000;
  reg   [2:0] bit_select = 3'b000;
  reg         piso_out = 1'b1;
  reg         all_done = 1'b0;
  reg         tx_start = 1'b0;
  reg         tx_stop = 1'b0;
  reg         tx_run = 1'b0;
  wire        tx_bit;

  ///////////////////////////////////////////////////////////////////////////
  // Convert parallel data to serial data with provision for stop and start.
  // Follow this by a flip-flop instance specifically for packing to pin.
  ///////////////////////////////////////////////////////////////////////////

  always @(posedge icap_clk)
  begin
    if (tx_start)
      piso_out <= #TCQ 1'b0;
    else if (tx_stop)
      piso_out <= #TCQ 1'b1;
    else if (tx_run)
      piso_out <= #TCQ data_in[bit_select];
    else
      piso_out <= #TCQ 1'b1;
  end

  FD #(.INIT(1'b1)) pipeline_serial (
    .D(piso_out),
    .Q(serial_out),
    .C(icap_clk)
    );

  ///////////////////////////////////////////////////////////////////////////
  // Transmit bit counter.
  ///////////////////////////////////////////////////////////////////////////

  always @(posedge icap_clk)
  begin
    if (tx_start)
      bit_select <= #TCQ 3'b000;
    else if (en_16_x_baud && tx_run && tx_bit)
      bit_select <= #TCQ bit_select + 3'b001;
  end

  ///////////////////////////////////////////////////////////////////////////
  // Start bit enable.
  ///////////////////////////////////////////////////////////////////////////

  always @(posedge icap_clk)
  begin
    if (en_16_x_baud)
      tx_start <= #TCQ (
        (!tx_start &&  (send_character && !tx_start && !tx_run) && !tx_stop && !tx_bit) ||
        (!tx_start &&  (send_character && !tx_start && !tx_run) &&  tx_stop &&  tx_bit) ||
        ( tx_start && !(send_character && !tx_start && !tx_run) && !tx_stop && !tx_bit) );
  end

  ///////////////////////////////////////////////////////////////////////////
  // Stop bit enable.
  ///////////////////////////////////////////////////////////////////////////

  always @(posedge icap_clk)
  begin
    if (en_16_x_baud)
      tx_stop <= #TCQ (
        (!tx_stop &&  (tx_bit && (bit_select == 3'b111)) &&  tx_run &&  tx_bit) ||
        ( tx_stop && !(tx_bit && (bit_select == 3'b111)) && !tx_run && !tx_bit) );
  end

  ///////////////////////////////////////////////////////////////////////////
  // Run bit enable.
  ///////////////////////////////////////////////////////////////////////////

  always @(posedge icap_clk)
  begin
    if (en_16_x_baud)
      tx_run <= #TCQ (
        (!tx_run &&  tx_start &&  tx_bit && !(tx_bit && (bit_select == 3'b111))) ||
        ( tx_run && !tx_start && !tx_bit && !(tx_bit && (bit_select == 3'b111))) ||
        ( tx_run && !tx_start &&  tx_bit && !(tx_bit && (bit_select == 3'b111))) ||
        ( tx_run &&  tx_start && !tx_bit && !(tx_bit && (bit_select == 3'b111))) );
  end

  ///////////////////////////////////////////////////////////////////////////
  // Bit rate enable.
  ///////////////////////////////////////////////////////////////////////////

  always @(posedge icap_clk)
  begin
    if (en_16_x_baud)
    begin
      hot_delay[0] <= #TCQ (
        (!tx_stop && !(send_character && !tx_start && !tx_run) &&  tx_bit) ||
        ( tx_stop &&  (send_character && !tx_start && !tx_run) &&  tx_bit) ||
        (!tx_stop &&  (send_character && !tx_start && !tx_run) && !tx_bit) );
      hot_delay[15:1] <= #TCQ hot_delay[14:0];
    end
  end

  assign tx_bit = hot_delay[15];

  ///////////////////////////////////////////////////////////////////////////
  // Transmit complete strobe.
  ///////////////////////////////////////////////////////////////////////////

  always @(posedge icap_clk)
  begin
    all_done <= #TCQ (en_16_x_baud && (tx_bit && (bit_select == 3'b111)));
  end

  assign tx_complete = all_done;

  ///////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////////

endmodule

/////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////
