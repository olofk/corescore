/////////////////////////////////////////////////////////////////////////////
//
//
//
/////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /
// \   \   \/    Core:          sem
//  \   \        Module:        sem_0_sem_cfg
//  /   /        Filename:      sem_0_sem_cfg.v
// /___/   /\    Purpose:       Wrapper file for configuration logic.
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
// This module is a wrapper to encapsulate the FRAME_ECC and ICAP primitives.
//
/////////////////////////////////////////////////////////////////////////////
//
// Port Definition:
//
// Name                          Type   Description
// ============================= ====== ====================================
// icap_clk                      input  The controller clock, used to clock
//                                      the configuration logic as well.
//
// icap_o[31:0]                  output ICAP data output.  Synchronous to
//                                      icap_clk.
//
// icap_csib                     input  ICAP chip select, active low.  Used
//                                      to enable the ICAP for read or write.
//                                      Synchronous to icap_clk.
//
// icap_rdwrb                    input  ICAP write select, active low.  Used
//                                      to select between read or write.
//                                      Synchronous to icap_clk.
//
// icap_i[31:0]                  input  ICAP data input.  Synchronous to
//                                      icap_clk.
//
// fecc_crcerr                   output FRAME_ECC status indicating a device
//                                      CRC check at end of readback cycle
//                                      has failed.  Synchronous to icap_clk.
//
// fecc_eccerr                   output FRAME_ECC status indicating a frame
//                                      ECC check at end of frame readback
//                                      has failed.  Synchronous to icap_clk.
//
// fecc_eccerrsingle             output FRAME_ECC status indicating syndrome
//                                      appears to be for a single bit error.
//                                      Synchronous to icap_clk.
//
// fecc_syndromevalid            output FRAME_ECC status indicating syndrome
//                                      is valid in this cycle.  Synchronous
//                                      to icap_clk.
//
// fecc_syndrome[12:0]           output FRAME_ECC syndrome.  Synchronous to
//                                      icap_clk.
//
// fecc_far[25:0]                output FRAME_ECC status showing FAR or EFAR.
//                                      Synchronous to icap_clk.
//
// fecc_synbit[4:0]              output FRAME_ECC status indicating location
//                                      of error in a word.  Synchronous to
//                                      icap_clk.
//
// fecc_synword[6:0]             output FRAME_ECC status indicating location
//                                      of error word in a frame.  Synchronous
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
/////////////////////////////////////////////////////////////////////////////
//
// Module Dependencies:
//
// sem_0_sem_cfg
// |
// +- ICAPE2 (unisim)
// |
// \- FRAME_ECCE2 (unisim)
//
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

/////////////////////////////////////////////////////////////////////////////
// Module
/////////////////////////////////////////////////////////////////////////////

module sem_0_sem_cfg (
  input  wire        icap_clk,
  output wire [31:0] icap_o,
  input  wire        icap_csib,
  input  wire        icap_rdwrb,
  input  wire [31:0] icap_i,
  output wire        fecc_crcerr,
  output wire        fecc_eccerr,
  output wire        fecc_eccerrsingle,
  output wire        fecc_syndromevalid,
  output wire [12:0] fecc_syndrome,
  output wire [25:0] fecc_far,
  output wire  [4:0] fecc_synbit,
  output wire  [6:0] fecc_synword
  );

  ///////////////////////////////////////////////////////////////////////////
  // Define local constants.
  ///////////////////////////////////////////////////////////////////////////

  localparam TCQ = 1;

  ///////////////////////////////////////////////////////////////////////////
  // Declare signals.
  ///////////////////////////////////////////////////////////////////////////

  // None

  ///////////////////////////////////////////////////////////////////////////
  // Instantiate the FRAME_ECC primitive.
  ///////////////////////////////////////////////////////////////////////////

  FRAME_ECCE2 #(
    .FRAME_RBT_IN_FILENAME("NONE"),
    .FARSRC("EFAR")
    )
  example_frame_ecc (
    .CRCERROR(fecc_crcerr),
    .ECCERROR(fecc_eccerr),
    .ECCERRORSINGLE(fecc_eccerrsingle),
    .FAR(fecc_far),
    .SYNBIT(fecc_synbit),
    .SYNDROME(fecc_syndrome),
    .SYNDROMEVALID(fecc_syndromevalid),
    .SYNWORD(fecc_synword)
    );

  ///////////////////////////////////////////////////////////////////////////
  // Instantiate the ICAP primitive.
  ///////////////////////////////////////////////////////////////////////////

  ICAPE2 #(
    .DEVICE_ID(32'hFFFFFFFF),
    .SIM_CFG_FILE_NAME("NONE"),
    .ICAP_WIDTH("X32")
    )
  example_icap (
    .O(icap_o),
    .CLK(icap_clk),
    .CSIB(icap_csib),
    .I(icap_i),
    .RDWRB(icap_rdwrb)
    );

  ///////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////////

endmodule

/////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////
