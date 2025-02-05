
// Efinity Top-level template
// Version: 2023.2.307
// Date: 2024-11-11 23:31

// Copyright (C) 2013 - 2023 Efinix Inc. All rights reserved.

// This file may be used as a starting point for Efinity synthesis top-level target.
// The port list here matches what is expected by Efinity constraint files generated
// by the Efinity Interface Designer.

// To use this:
//     #1)  Save this file with a different name to a different directory, where source files are kept.
//              Example: you may wish to save as C:\Users\pc\Desktop\file\eye\Ti60_Demo.v
//     #2)  Add the newly saved file into Efinity project as design file
//     #3)  Edit the top level entity in Efinity project to:  Ti60_Demo
//     #4)  Insert design content.


module Ti60_Demo
(
  input hbramClk_pll_lock,
  input hdmi_pll_lock,
  input dsi_pll_lock,
  input dsi_txcclk_i,
  input dsi_serclk_i,
  input dsi_byteclk_i,
  input dsi_fb_i,
  input hdmi_pixel,
  input hdmi_pixel_10x,
  input sensor_xclk_i,
  input sys_clk_i,
  input hbramClk90,
  input csi_rxc_i,
  input csi2_rxc_i,
  input hbramClk,
  input hbramClk_Cal,
  input clk_27m,
  input csi2_sda_i,
  input csi_trig_i,
  input csi_tx_scl_i,
  input csi_tx_sda_i,
  input uart_rx_i,
  input csi_rxc_lp_n_i,
  input csi_rxc_lp_p_i,
  input [7:0] csi_rxd0_hs_i,
  input csi_rxd0_lp_n_i,
  input csi_rxd0_lp_p_i,
  input [7:0] csi_rxd1_hs_i,
  input csi_rxd1_lp_n_i,
  input csi_rxd1_lp_p_i,
  input [7:0] csi_rxd2_hs_i,
  input csi_rxd2_lp_n_i,
  input csi_rxd2_lp_p_i,
  input [7:0] csi_rxd3_hs_i,
  input csi_rxd3_lp_n_i,
  input csi_rxd3_lp_p_i,
  input csi_txd0_lp_n_i,
  input csi_txd0_lp_p_i,
  input csi_txd1_lp_n_i,
  input csi_txd1_lp_p_i,
  input csi_txd2_lp_n_i,
  input csi_txd2_lp_p_i,
  input csi_txd3_lp_n_i,
  input csi_txd3_lp_p_i,
  input csi2_rxc_lp_n_i,
  input csi2_rxc_lp_p_i,
  input [7:0] csi2_rxd0_hs_i,
  input csi2_rxd0_lp_n_i,
  input csi2_rxd0_lp_p_i,
  input [7:0] csi2_rxd1_hs_i,
  input csi2_rxd1_lp_n_i,
  input csi2_rxd1_lp_p_i,
  input [7:0] csi2_rxd2_hs_i,
  input csi2_rxd2_lp_n_i,
  input csi2_rxd2_lp_p_i,
  input [7:0] csi2_rxd3_hs_i,
  input csi2_rxd3_lp_n_i,
  input csi2_rxd3_lp_p_i,
  input dsi_txd0_lp_n_i,
  input dsi_txd0_lp_p_i,
  input dsi_txd1_lp_n_i,
  input dsi_txd1_lp_p_i,
  input dsi_txd2_lp_n_i,
  input dsi_txd2_lp_p_i,
  input dsi_txd3_lp_n_i,
  input dsi_txd3_lp_p_i,
  input spi_holdn_d3_i,
  input spi_miso_d1_i,
  input spi_mosi_d0_i,
  input spi_wpn_d2_i,
  input [15:0] hbram_DQ_IN_HI,
  input [15:0] hbram_DQ_IN_LO,
  input [1:0] hbram_RWDS_IN_HI,
  input [1:0] hbram_RWDS_IN_LO,
  output hbramClk_pll_rstn_o,
  output [2:0] hbramClk_shift,
  output hbramClk_shift_ena,
  output [4:0] hbramClk_shift_sel,
  output hdmi_pll_rstn_o,
  output dsi_pll_rstn_o,
  output hdmi_txc_oe,
  output [9:0] hdmi_txc_o,
  output hdmi_txc_rst_o,
  output hdmi_txd0_oe,
  output [9:0] hdmi_txd0_o,
  output hdmi_txd0_rst_o,
  output hdmi_txd1_oe,
  output [9:0] hdmi_txd1_o,
  output hdmi_txd1_rst_o,
  output hdmi_txd2_oe,
  output [9:0] hdmi_txd2_o,
  output hdmi_txd2_rst_o,
  output csi2_sda_o,
  output csi2_sda_oe,
  output csi_trig_o,
  output csi_trig_oe,
  output csi_tx_scl_o,
  output csi_tx_scl_oe,
  output csi_tx_sda_o,
  output csi_tx_sda_oe,
  output dsi_pwm_o,
  output led_o,
  output uart_tx_o,
  output csi_rxc_hs_en_o,
  output csi_rxc_hs_term_en_o,
  output csi_rxd0_hs_en_o,
  output csi_rxd0_hs_term_en_o,
  output csi_rxd0_rst_o,
  output csi_rxd1_hs_en_o,
  output csi_rxd1_hs_term_en_o,
  output csi_rxd1_rst_o,
  output csi_rxd2_hs_en_o,
  output csi_rxd2_hs_term_en_o,
  output csi_rxd2_rst_o,
  output csi_rxd3_hs_en_o,
  output csi_rxd3_hs_term_en_o,
  output csi_rxd3_rst_o,
  output csi_txc_hs_oe,
  output [7:0] csi_txc_hs_o,
  output csi_txc_lp_n_oe,
  output csi_txc_lp_n_o,
  output csi_txc_lp_p_oe,
  output csi_txc_lp_p_o,
  output csi_txc_rst_o,
  output csi_txd0_hs_oe,
  output [7:0] csi_txd0_hs_o,
  output csi_txd0_lp_n_oe,
  output csi_txd0_lp_n_o,
  output csi_txd0_lp_p_oe,
  output csi_txd0_lp_p_o,
  output csi_txd0_rst_o,
  output csi_txd1_hs_oe,
  output [7:0] csi_txd1_hs_o,
  output csi_txd1_lp_n_oe,
  output csi_txd1_lp_n_o,
  output csi_txd1_lp_p_oe,
  output csi_txd1_lp_p_o,
  output csi_txd1_rst_o,
  output csi_txd2_hs_oe,
  output [7:0] csi_txd2_hs_o,
  output csi_txd2_lp_n_oe,
  output csi_txd2_lp_n_o,
  output csi_txd2_lp_p_oe,
  output csi_txd2_lp_p_o,
  output csi_txd2_rst_o,
  output csi_txd3_hs_oe,
  output [7:0] csi_txd3_hs_o,
  output csi_txd3_lp_n_oe,
  output csi_txd3_lp_n_o,
  output csi_txd3_lp_p_oe,
  output csi_txd3_lp_p_o,
  output csi_txd3_rst_o,
  output csi2_rxc_hs_en_o,
  output csi2_rxc_hs_term_en_o,
  output csi2_rxd0_hs_en_o,
  output csi2_rxd0_hs_term_en_o,
  output csi2_rxd0_rst_o,
  output csi2_rxd1_hs_en_o,
  output csi2_rxd1_hs_term_en_o,
  output csi2_rxd1_rst_o,
  output csi2_rxd2_hs_en_o,
  output csi2_rxd2_hs_term_en_o,
  output csi2_rxd2_rst_o,
  output csi2_rxd3_hs_en_o,
  output csi2_rxd3_hs_term_en_o,
  output csi2_rxd3_rst_o,
  output dsi_txc_hs_oe,
  output [7:0] dsi_txc_hs_o,
  output dsi_txc_lp_n_oe,
  output dsi_txc_lp_n_o,
  output dsi_txc_lp_p_oe,
  output dsi_txc_lp_p_o,
  output dsi_txc_rst_o,
  output dsi_txd0_hs_oe,
  output [7:0] dsi_txd0_hs_o,
  output dsi_txd0_lp_n_oe,
  output dsi_txd0_lp_n_o,
  output dsi_txd0_lp_p_oe,
  output dsi_txd0_lp_p_o,
  output dsi_txd0_rst_o,
  output dsi_txd1_hs_oe,
  output [7:0] dsi_txd1_hs_o,
  output dsi_txd1_lp_n_oe,
  output dsi_txd1_lp_n_o,
  output dsi_txd1_lp_p_oe,
  output dsi_txd1_lp_p_o,
  output dsi_txd1_rst_o,
  output dsi_txd2_hs_oe,
  output [7:0] dsi_txd2_hs_o,
  output dsi_txd2_lp_n_oe,
  output dsi_txd2_lp_n_o,
  output dsi_txd2_lp_p_oe,
  output dsi_txd2_lp_p_o,
  output dsi_txd2_rst_o,
  output dsi_txd3_hs_oe,
  output [7:0] dsi_txd3_hs_o,
  output dsi_txd3_lp_n_oe,
  output dsi_txd3_lp_n_o,
  output dsi_txd3_lp_p_oe,
  output dsi_txd3_lp_p_o,
  output dsi_txd3_rst_o,
  output spi_cs_o,
  output spi_cs_oe,
  output spi_holdn_d3_o,
  output spi_holdn_d3_oe,
  output spi_miso_d1_o,
  output spi_miso_d1_oe,
  output spi_mosi_d0_o,
  output spi_mosi_d0_oe,
  output spi_sck_o,
  output spi_sck_oe,
  output spi_wpn_d2_o,
  output spi_wpn_d2_oe,
  output hbram_CK_N_HI,
  output hbram_CK_N_LO,
  output hbram_CK_P_HI,
  output hbram_CK_P_LO,
  output hbram_CS_N,
  output [15:0] hbram_DQ_OUT_HI,
  output [15:0] hbram_DQ_OUT_LO,
  output [15:0] hbram_DQ_OE,
  output hbram_RST_N,
  output [1:0] hbram_RWDS_OUT_HI,
  output [1:0] hbram_RWDS_OUT_LO,
  output [1:0] hbram_RWDS_OE
);


endmodule

