/////////////////////////////////////////////////////////////////////////////
//
//
//
/////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /
// \   \   \/    Core:          sem
//  \   \        Module:        sem_0_sem_mon_sipo
//  /   /        Filename:      sem_0_sem_mon_sipo.v
// /___/   /\    Purpose:       MON Shim 8N1 SIPO.
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
// This module contains an 8N1 SIPO implementation.
//
/////////////////////////////////////////////////////////////////////////////
//
// Port Definition:
//
// Name                          Type   Description
// ============================= ====== ====================================
// icap_clk                      input  The system clock signal.
//
// data_out[7:0]                 output Output from the SIPO.  Synchronous
//                                      to icap_clk.
//
// serial_in                     output Asynchronous serial input.
//
// en_16_x_baud                  input  Enable signal with periodic single
//                                      cycle pulses at 16 times baud rate.
//                                      Synchronous to icap_clk.
//
// data_strobe                   output Indicates reception complete.
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
// sem_0_sem_mon_sipo
// |
// \- FD (unisim)
//
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

/////////////////////////////////////////////////////////////////////////////
// Module
/////////////////////////////////////////////////////////////////////////////

module sem_0_sem_mon_sipo (
  input  wire        icap_clk,
  output wire  [7:0] data_out,
  input  wire        serial_in,
  input  wire        en_16_x_baud,
  output wire        data_strobe
  );

  ///////////////////////////////////////////////////////////////////////////
  // Define local constants.
  ///////////////////////////////////////////////////////////////////////////

  localparam TCQ = 1;

  ///////////////////////////////////////////////////////////////////////////
  // Declare signals.
  ///////////////////////////////////////////////////////////////////////////

  wire        sync_serial_a;
  wire        sync_serial_b;
  wire        sync_serial_c;
  wire        stop_bit;
  wire        edge_delay;
  wire        start_edge;
  reg [150:0] delay_line = 151'b0;
  reg [151:0] valid_delay = 152'b0;
  reg         data_strobe_int = 1'b0;
  reg         valid_char = 1'b0;
  reg         purge = 1'b0;

  ///////////////////////////////////////////////////////////////////////////
  // Synchronize serial input.
  ///////////////////////////////////////////////////////////////////////////

  (* ASYNC_REG = "TRUE" *)
  FD sync_reg_a (.D(serial_in), .Q(sync_serial_a), .C(icap_clk));
  (* ASYNC_REG = "TRUE" *)
  FD sync_reg_b (.D(sync_serial_a), .Q(sync_serial_b), .C(icap_clk));
  (* ASYNC_REG = "TRUE" *)
  FD sync_reg_c (.D(sync_serial_b), .Q(sync_serial_c), .C(icap_clk));
  (* ASYNC_REG = "TRUE" *)
  FD sync_reg_d (.D(sync_serial_c), .Q(stop_bit), .C(icap_clk));

  ///////////////////////////////////////////////////////////////////////////
  // Create a delay line to pick out various bits of the serial signal by
  // capturing the incoming signal at 16 times the baud rate.  This block
  // also delays the valid_char pulse, the length of time equivalent to
  // purge the data shift register.  This is used to generate purge signal
  // which locks out additional strobes that might otherwise occur while
  // the most recent captured data makes it way out of the shift register.
  ///////////////////////////////////////////////////////////////////////////

  always @(posedge icap_clk)
  begin
    if (en_16_x_baud)
    begin
      delay_line <= #TCQ {delay_line[149:0], stop_bit};
      valid_char <= #TCQ !edge_delay && start_edge && stop_bit && !purge;
      valid_delay <= #TCQ {valid_delay[150:0], valid_char};
      purge <= #TCQ (purge || valid_char) && !valid_delay[151];
    end
  end

  assign data_out   = {delay_line[ 15],
                       delay_line[ 31],
                       delay_line[ 47],
                       delay_line[ 63],
                       delay_line[ 79],
                       delay_line[ 95],
                       delay_line[111],
                       delay_line[127]};
  assign edge_delay  = delay_line[149];
  assign start_edge  = delay_line[150];

  ///////////////////////////////////////////////////////////////////////////
  // Generate a single-cycle output data strobe when the character is valid.
  ///////////////////////////////////////////////////////////////////////////

  always @(posedge icap_clk)
  begin
    data_strobe_int <= #TCQ valid_char && en_16_x_baud;
  end

  assign data_strobe = data_strobe_int;

  ///////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////////

endmodule

/////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////
