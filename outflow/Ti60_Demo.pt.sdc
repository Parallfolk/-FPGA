
# Auto-generated by Interface Designer
#
# WARNING: Any manual changes made to this file will be lost when generating constraints.

# Efinity Interface Designer SDC
# Version: 2023.2.307
# Date: 2024-11-11 23:31

# Copyright (C) 2013 - 2023 Efinix Inc. All rights reserved.

# Device: Ti60F100S3F2
# Project: Ti60_Demo
# Timing Model: C4 (final)

# PLL Constraints
#################
create_clock -waveform {0.1666 0.8331} -period 1.3329 dsi_serclk_i
create_clock -waveform {0.4998 1.1663} -period 1.3329 dsi_txcclk_i
create_clock -period 5.3317 dsi_byteclk_i
create_clock -period 32.3232 dsi_fb_i
create_clock -waveform {0.5051 1.1785} -period 1.3468 hdmi_pixel_10x
create_clock -period 13.4680 hdmi_pixel
create_clock -period 37.0370 sensor_xclk_i
create_clock -period 10.1010 sys_clk_i
create_clock -period 4.0404 hbramClk
create_clock -waveform {1.0101 3.0303} -period 4.0404 hbramClk90
create_clock -period 4.0404 hbramClk_Cal

# HSIO GPIO Constraints
#########################
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {uart_rx_i}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {uart_rx_i}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {dsi_pwm_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {dsi_pwm_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {led_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {led_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {uart_tx_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {uart_tx_o}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi2_sda_i}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi2_sda_i}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi2_sda_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi2_sda_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi2_sda_oe}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi2_sda_oe}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi_trig_i}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi_trig_i}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi_trig_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi_trig_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi_trig_oe}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi_trig_oe}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi_tx_scl_i}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi_tx_scl_i}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi_tx_scl_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi_tx_scl_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi_tx_scl_oe}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi_tx_scl_oe}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi_tx_sda_i}]
# set_input_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi_tx_sda_i}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi_tx_sda_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi_tx_sda_o}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {csi_tx_sda_oe}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {csi_tx_sda_oe}]

# LVDS Tx Constraints
#######################
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~119}] -max 0.378 [get_ports {hdmi_txc_o[*]}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~119}] -min -0.140 [get_ports {hdmi_txc_o[*]}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~119}] -max 0.378 [get_ports {hdmi_txc_oe}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~119}] -min -0.140 [get_ports {hdmi_txc_oe}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~102}] -max 0.378 [get_ports {hdmi_txd0_o[*]}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~102}] -min -0.140 [get_ports {hdmi_txd0_o[*]}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~102}] -max 0.378 [get_ports {hdmi_txd0_oe}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~102}] -min -0.140 [get_ports {hdmi_txd0_oe}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~135}] -max 0.378 [get_ports {hdmi_txd1_o[*]}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~135}] -min -0.140 [get_ports {hdmi_txd1_o[*]}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~135}] -max 0.378 [get_ports {hdmi_txd1_oe}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~135}] -min -0.140 [get_ports {hdmi_txd1_oe}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~152}] -max 0.378 [get_ports {hdmi_txd2_o[*]}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~152}] -min -0.140 [get_ports {hdmi_txd2_o[*]}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~152}] -max 0.378 [get_ports {hdmi_txd2_oe}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~152}] -min -0.140 [get_ports {hdmi_txd2_oe}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~119}] -max 0.420 [get_ports {hdmi_txc_rst_o}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~119}] -min -0.175 [get_ports {hdmi_txc_rst_o}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~102}] -max 0.420 [get_ports {hdmi_txd0_rst_o}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~102}] -min -0.175 [get_ports {hdmi_txd0_rst_o}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~135}] -max 0.420 [get_ports {hdmi_txd1_rst_o}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~135}] -min -0.175 [get_ports {hdmi_txd1_rst_o}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~152}] -max 0.420 [get_ports {hdmi_txd2_rst_o}]
set_output_delay -clock hdmi_pixel -reference_pin [get_ports {hdmi_pixel~CLKOUT~1~152}] -min -0.175 [get_ports {hdmi_txd2_rst_o}]

# MIPI RX Lane Constraints
############################
# create_clock -period <USER_PERIOD> [get_ports {csi2_rxc_i}]
# create_clock -period <USER_PERIOD> [get_ports {csi_rxc_i}]
set_output_delay -clock csi2_rxc_i -max 0.315 [get_ports {csi2_rxd0_rst_o}]
set_output_delay -clock csi2_rxc_i -min -0.140 [get_ports {csi2_rxd0_rst_o}]
set_input_delay -clock csi2_rxc_i -max 0.512 [get_ports {csi2_rxd0_hs_i[*]}]
set_input_delay -clock csi2_rxc_i -min 0.342 [get_ports {csi2_rxd0_hs_i[*]}]
set_output_delay -clock csi2_rxc_i -max 0.315 [get_ports {csi2_rxd1_rst_o}]
set_output_delay -clock csi2_rxc_i -min -0.140 [get_ports {csi2_rxd1_rst_o}]
set_input_delay -clock csi2_rxc_i -max 0.512 [get_ports {csi2_rxd1_hs_i[*]}]
set_input_delay -clock csi2_rxc_i -min 0.342 [get_ports {csi2_rxd1_hs_i[*]}]
set_output_delay -clock csi2_rxc_i -max 0.315 [get_ports {csi2_rxd2_rst_o}]
set_output_delay -clock csi2_rxc_i -min -0.140 [get_ports {csi2_rxd2_rst_o}]
set_input_delay -clock csi2_rxc_i -max 0.512 [get_ports {csi2_rxd2_hs_i[*]}]
set_input_delay -clock csi2_rxc_i -min 0.342 [get_ports {csi2_rxd2_hs_i[*]}]
set_output_delay -clock csi2_rxc_i -max 0.315 [get_ports {csi2_rxd3_rst_o}]
set_output_delay -clock csi2_rxc_i -min -0.140 [get_ports {csi2_rxd3_rst_o}]
set_input_delay -clock csi2_rxc_i -max 0.512 [get_ports {csi2_rxd3_hs_i[*]}]
set_input_delay -clock csi2_rxc_i -min 0.342 [get_ports {csi2_rxd3_hs_i[*]}]
set_output_delay -clock csi_rxc_i -max 0.315 [get_ports {csi_rxd0_rst_o}]
set_output_delay -clock csi_rxc_i -min -0.140 [get_ports {csi_rxd0_rst_o}]
set_input_delay -clock csi_rxc_i -max 0.512 [get_ports {csi_rxd0_hs_i[*]}]
set_input_delay -clock csi_rxc_i -min 0.342 [get_ports {csi_rxd0_hs_i[*]}]
set_output_delay -clock csi_rxc_i -max 0.315 [get_ports {csi_rxd1_rst_o}]
set_output_delay -clock csi_rxc_i -min -0.140 [get_ports {csi_rxd1_rst_o}]
set_input_delay -clock csi_rxc_i -max 0.512 [get_ports {csi_rxd1_hs_i[*]}]
set_input_delay -clock csi_rxc_i -min 0.342 [get_ports {csi_rxd1_hs_i[*]}]
set_output_delay -clock csi_rxc_i -max 0.315 [get_ports {csi_rxd2_rst_o}]
set_output_delay -clock csi_rxc_i -min -0.140 [get_ports {csi_rxd2_rst_o}]
set_input_delay -clock csi_rxc_i -max 0.512 [get_ports {csi_rxd2_hs_i[*]}]
set_input_delay -clock csi_rxc_i -min 0.342 [get_ports {csi_rxd2_hs_i[*]}]
set_output_delay -clock csi_rxc_i -max 0.315 [get_ports {csi_rxd3_rst_o}]
set_output_delay -clock csi_rxc_i -min -0.140 [get_ports {csi_rxd3_rst_o}]
set_input_delay -clock csi_rxc_i -max 0.512 [get_ports {csi_rxd3_hs_i[*]}]
set_input_delay -clock csi_rxc_i -min 0.342 [get_ports {csi_rxd3_hs_i[*]}]

# MIPI TX Lane Constraints
############################
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~114}] -max 0.378 [get_ports {csi_txc_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~114}] -min -0.140 [get_ports {csi_txc_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~114}] -max 0.315 [get_ports {csi_txc_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~114}] -min -0.140 [get_ports {csi_txc_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~154}] -max 0.378 [get_ports {csi_txd0_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~154}] -min -0.140 [get_ports {csi_txd0_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~154}] -max 0.315 [get_ports {csi_txd0_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~154}] -min -0.140 [get_ports {csi_txd0_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~143}] -max 0.378 [get_ports {csi_txd1_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~143}] -min -0.140 [get_ports {csi_txd1_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~143}] -max 0.315 [get_ports {csi_txd1_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~143}] -min -0.140 [get_ports {csi_txd1_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~131}] -max 0.378 [get_ports {csi_txd2_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~131}] -min -0.140 [get_ports {csi_txd2_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~131}] -max 0.315 [get_ports {csi_txd2_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~131}] -min -0.140 [get_ports {csi_txd2_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~99}] -max 0.378 [get_ports {csi_txd3_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~99}] -min -0.140 [get_ports {csi_txd3_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~99}] -max 0.315 [get_ports {csi_txd3_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~218~99}] -min -0.140 [get_ports {csi_txd3_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~211}] -max 0.378 [get_ports {dsi_txc_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~211}] -min -0.140 [get_ports {dsi_txc_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~211}] -max 0.315 [get_ports {dsi_txc_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~211}] -min -0.140 [get_ports {dsi_txc_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~228}] -max 0.378 [get_ports {dsi_txd0_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~228}] -min -0.140 [get_ports {dsi_txd0_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~228}] -max 0.315 [get_ports {dsi_txd0_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~228}] -min -0.140 [get_ports {dsi_txd0_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~175}] -max 0.378 [get_ports {dsi_txd1_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~175}] -min -0.140 [get_ports {dsi_txd1_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~175}] -max 0.315 [get_ports {dsi_txd1_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~175}] -min -0.140 [get_ports {dsi_txd1_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~185}] -max 0.378 [get_ports {dsi_txd2_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~185}] -min -0.140 [get_ports {dsi_txd2_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~185}] -max 0.315 [get_ports {dsi_txd2_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~185}] -min -0.140 [get_ports {dsi_txd2_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~199}] -max 0.378 [get_ports {dsi_txd3_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~199}] -min -0.140 [get_ports {dsi_txd3_hs_o[*]}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~199}] -max 0.315 [get_ports {dsi_txd3_rst_o}]
set_output_delay -clock dsi_byteclk_i -reference_pin [get_ports {dsi_byteclk_i~CLKOUT~1~199}] -min -0.140 [get_ports {dsi_txd3_rst_o}]

# SPI Flash Constraints
########################
# create_generated_clock -source <SOURCE_CLK> <CLOCK RELATIONSHIP> [get_ports {spi_sck_o}]
# set_input_delay -clock spi_sck_o -max <MAX CALCULATION> [get_ports {spi_miso_d1_i}]
# set_input_delay -clock spi_sck_o -min <MIN CALCULATION> [get_ports {spi_miso_d1_i}]
# set_input_delay -clock spi_sck_o -max <MAX CALCULATION> [get_ports {spi_holdn_d3_i}]
# set_input_delay -clock spi_sck_o -min <MIN CALCULATION> [get_ports {spi_holdn_d3_i}]
# set_input_delay -clock spi_sck_o -max <MAX CALCULATION> [get_ports {spi_wpn_d2_i}]
# set_input_delay -clock spi_sck_o -min <MIN CALCULATION> [get_ports {spi_wpn_d2_i}]
# set_input_delay -clock spi_sck_o -max <MAX CALCULATION> [get_ports {spi_mosi_d0_i}]
# set_input_delay -clock spi_sck_o -min <MIN CALCULATION> [get_ports {spi_mosi_d0_i}]
# set_output_delay -clock spi_sck_o -max <MAX CALCULATION> [get_ports {spi_cs_o}]
# set_output_delay -clock spi_sck_o -min <MIN CALCULATION> [get_ports {spi_cs_o}]
# set_output_delay -clock spi_sck_o -max <MAX CALCULATION> [get_ports {spi_holdn_d3_o}]
# set_output_delay -clock spi_sck_o -min <MIN CALCULATION> [get_ports {spi_holdn_d3_o}]
# set_output_delay -clock spi_sck_o -max <MAX CALCULATION> [get_ports {spi_wpn_d2_o}]
# set_output_delay -clock spi_sck_o -min <MIN CALCULATION> [get_ports {spi_wpn_d2_o}]
# set_output_delay -clock spi_sck_o -max <MAX CALCULATION> [get_ports {spi_mosi_d0_o}]
# set_output_delay -clock spi_sck_o -min <MIN CALCULATION> [get_ports {spi_mosi_d0_o}]
# set_output_delay -clock spi_sck_o -max <MAX CALCULATION> [get_ports {spi_miso_d1_o}]
# set_output_delay -clock spi_sck_o -min <MIN CALCULATION> [get_ports {spi_miso_d1_o}]

# HyperRAM Constraints
########################
set_output_delay -clock_fall -clock hbramClk90 -reference_pin [get_ports {hbramClk90~CLKOUT~83~322}] -max 0.263 [get_ports {hbram_CK_N_LO hbram_CK_N_HI}]
set_output_delay -clock_fall -clock hbramClk90 -reference_pin [get_ports {hbramClk90~CLKOUT~83~322}] -min -0.140 [get_ports {hbram_CK_N_LO hbram_CK_N_HI}]
set_output_delay -clock_fall -clock hbramClk90 -reference_pin [get_ports {hbramClk90~CLKOUT~75~322}] -max 0.263 [get_ports {hbram_CK_P_LO hbram_CK_P_HI}]
set_output_delay -clock_fall -clock hbramClk90 -reference_pin [get_ports {hbramClk90~CLKOUT~75~322}] -min -0.140 [get_ports {hbram_CK_P_LO hbram_CK_P_HI}]
set_output_delay -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~122~322}] -max 0.263 [get_ports {hbram_CS_N}]
set_output_delay -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~122~322}] -min -0.140 [get_ports {hbram_CS_N}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -max <MAX CALCULATION> [get_ports {hbram_RST_N}]
# set_output_delay -clock <CLOCK> [-reference_pin <clkout_pad>] -min <MIN CALCULATION> [get_ports {hbram_RST_N}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~165~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[0] hbram_DQ_IN_HI[0]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~165~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[0] hbram_DQ_IN_HI[0]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~167~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[0] hbram_DQ_OUT_HI[0]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~167~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[0] hbram_DQ_OUT_HI[0]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~167~322}] -max 0.263 [get_ports {hbram_DQ_OE[0]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~167~322}] -min -0.140 [get_ports {hbram_DQ_OE[0]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~164~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[1] hbram_DQ_IN_HI[1]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~164~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[1] hbram_DQ_IN_HI[1]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~166~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[1] hbram_DQ_OUT_HI[1]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~166~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[1] hbram_DQ_OUT_HI[1]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~166~322}] -max 0.263 [get_ports {hbram_DQ_OE[1]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~166~322}] -min -0.140 [get_ports {hbram_DQ_OE[1]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~157~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[2] hbram_DQ_IN_HI[2]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~157~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[2] hbram_DQ_IN_HI[2]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~159~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[2] hbram_DQ_OUT_HI[2]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~159~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[2] hbram_DQ_OUT_HI[2]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~159~322}] -max 0.263 [get_ports {hbram_DQ_OE[2]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~159~322}] -min -0.140 [get_ports {hbram_DQ_OE[2]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~156~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[3] hbram_DQ_IN_HI[3]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~156~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[3] hbram_DQ_IN_HI[3]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~158~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[3] hbram_DQ_OUT_HI[3]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~158~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[3] hbram_DQ_OUT_HI[3]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~158~322}] -max 0.263 [get_ports {hbram_DQ_OE[3]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~158~322}] -min -0.140 [get_ports {hbram_DQ_OE[3]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~149~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[4] hbram_DQ_IN_HI[4]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~149~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[4] hbram_DQ_IN_HI[4]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~151~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[4] hbram_DQ_OUT_HI[4]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~151~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[4] hbram_DQ_OUT_HI[4]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~151~322}] -max 0.263 [get_ports {hbram_DQ_OE[4]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~151~322}] -min -0.140 [get_ports {hbram_DQ_OE[4]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~148~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[5] hbram_DQ_IN_HI[5]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~148~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[5] hbram_DQ_IN_HI[5]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~150~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[5] hbram_DQ_OUT_HI[5]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~150~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[5] hbram_DQ_OUT_HI[5]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~150~322}] -max 0.263 [get_ports {hbram_DQ_OE[5]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~150~322}] -min -0.140 [get_ports {hbram_DQ_OE[5]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~141~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[6] hbram_DQ_IN_HI[6]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~141~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[6] hbram_DQ_IN_HI[6]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~143~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[6] hbram_DQ_OUT_HI[6]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~143~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[6] hbram_DQ_OUT_HI[6]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~143~322}] -max 0.263 [get_ports {hbram_DQ_OE[6]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~143~322}] -min -0.140 [get_ports {hbram_DQ_OE[6]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~140~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[7] hbram_DQ_IN_HI[7]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~140~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[7] hbram_DQ_IN_HI[7]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~142~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[7] hbram_DQ_OUT_HI[7]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~142~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[7] hbram_DQ_OUT_HI[7]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~142~322}] -max 0.263 [get_ports {hbram_DQ_OE[7]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~142~322}] -min -0.140 [get_ports {hbram_DQ_OE[7]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~65~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[8] hbram_DQ_IN_HI[8]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~65~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[8] hbram_DQ_IN_HI[8]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~67~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[8] hbram_DQ_OUT_HI[8]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~67~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[8] hbram_DQ_OUT_HI[8]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~67~322}] -max 0.263 [get_ports {hbram_DQ_OE[8]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~67~322}] -min -0.140 [get_ports {hbram_DQ_OE[8]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~64~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[9] hbram_DQ_IN_HI[9]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~64~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[9] hbram_DQ_IN_HI[9]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~66~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[9] hbram_DQ_OUT_HI[9]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~66~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[9] hbram_DQ_OUT_HI[9]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~66~322}] -max 0.263 [get_ports {hbram_DQ_OE[9]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~66~322}] -min -0.140 [get_ports {hbram_DQ_OE[9]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~57~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[10] hbram_DQ_IN_HI[10]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~57~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[10] hbram_DQ_IN_HI[10]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~59~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[10] hbram_DQ_OUT_HI[10]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~59~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[10] hbram_DQ_OUT_HI[10]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~59~322}] -max 0.263 [get_ports {hbram_DQ_OE[10]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~59~322}] -min -0.140 [get_ports {hbram_DQ_OE[10]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~56~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[11] hbram_DQ_IN_HI[11]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~56~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[11] hbram_DQ_IN_HI[11]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~58~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[11] hbram_DQ_OUT_HI[11]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~58~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[11] hbram_DQ_OUT_HI[11]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~58~322}] -max 0.263 [get_ports {hbram_DQ_OE[11]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~58~322}] -min -0.140 [get_ports {hbram_DQ_OE[11]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~49~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[12] hbram_DQ_IN_HI[12]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~49~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[12] hbram_DQ_IN_HI[12]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~51~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[12] hbram_DQ_OUT_HI[12]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~51~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[12] hbram_DQ_OUT_HI[12]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~51~322}] -max 0.263 [get_ports {hbram_DQ_OE[12]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~51~322}] -min -0.140 [get_ports {hbram_DQ_OE[12]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~48~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[13] hbram_DQ_IN_HI[13]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~48~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[13] hbram_DQ_IN_HI[13]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~50~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[13] hbram_DQ_OUT_HI[13]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~50~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[13] hbram_DQ_OUT_HI[13]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~50~322}] -max 0.263 [get_ports {hbram_DQ_OE[13]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~50~322}] -min -0.140 [get_ports {hbram_DQ_OE[13]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~25~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[14] hbram_DQ_IN_HI[14]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~25~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[14] hbram_DQ_IN_HI[14]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~27~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[14] hbram_DQ_OUT_HI[14]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~27~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[14] hbram_DQ_OUT_HI[14]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~27~322}] -max 0.263 [get_ports {hbram_DQ_OE[14]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~27~322}] -min -0.140 [get_ports {hbram_DQ_OE[14]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~24~322}] -max 0.414 [get_ports {hbram_DQ_IN_LO[15] hbram_DQ_IN_HI[15]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~24~322}] -min 0.276 [get_ports {hbram_DQ_IN_LO[15] hbram_DQ_IN_HI[15]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~26~322}] -max 0.263 [get_ports {hbram_DQ_OUT_LO[15] hbram_DQ_OUT_HI[15]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~26~322}] -min -0.140 [get_ports {hbram_DQ_OUT_LO[15] hbram_DQ_OUT_HI[15]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~26~322}] -max 0.263 [get_ports {hbram_DQ_OE[15]}]
set_output_delay -clock_fall -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~26~322}] -min -0.140 [get_ports {hbram_DQ_OE[15]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~129~322}] -max 0.414 [get_ports {hbram_RWDS_IN_LO[0] hbram_RWDS_IN_HI[0]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~129~322}] -min 0.276 [get_ports {hbram_RWDS_IN_LO[0] hbram_RWDS_IN_HI[0]}]
set_output_delay -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~131~322}] -max 0.263 [get_ports {hbram_RWDS_OUT_LO[0] hbram_RWDS_OUT_HI[0]}]
set_output_delay -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~131~322}] -min -0.140 [get_ports {hbram_RWDS_OUT_LO[0] hbram_RWDS_OUT_HI[0]}]
set_output_delay -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~131~322}] -max 0.263 [get_ports {hbram_RWDS_OE[0]}]
set_output_delay -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~131~322}] -min -0.140 [get_ports {hbram_RWDS_OE[0]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~72~322}] -max 0.414 [get_ports {hbram_RWDS_IN_LO[1] hbram_RWDS_IN_HI[1]}]
set_input_delay -clock hbramClk_Cal -reference_pin [get_ports {hbramClk_Cal~CLKOUT~72~322}] -min 0.276 [get_ports {hbram_RWDS_IN_LO[1] hbram_RWDS_IN_HI[1]}]
set_output_delay -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~74~322}] -max 0.263 [get_ports {hbram_RWDS_OUT_LO[1] hbram_RWDS_OUT_HI[1]}]
set_output_delay -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~74~322}] -min -0.140 [get_ports {hbram_RWDS_OUT_LO[1] hbram_RWDS_OUT_HI[1]}]
set_output_delay -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~74~322}] -max 0.263 [get_ports {hbram_RWDS_OE[1]}]
set_output_delay -clock hbramClk -reference_pin [get_ports {hbramClk~CLKOUT~74~322}] -min -0.140 [get_ports {hbram_RWDS_OE[1]}]

# Clock Latency Constraints
############################
# set_clock_latency -source -setup <pll_clk_latency_sys_clk_i_max -0.041> [get_ports {dsi_serclk_i}]
# set_clock_latency -source -hold <pll_clk_latency_sys_clk_i_min -0.026> [get_ports {dsi_serclk_i}]
# set_clock_latency -source -setup <pll_clk_latency_sys_clk_i_max -0.041> [get_ports {dsi_txcclk_i}]
# set_clock_latency -source -hold <pll_clk_latency_sys_clk_i_min -0.026> [get_ports {dsi_txcclk_i}]
# set_clock_latency -source -setup <pll_clk_latency_sys_clk_i_max -0.041> [get_ports {dsi_byteclk_i}]
# set_clock_latency -source -hold <pll_clk_latency_sys_clk_i_min -0.026> [get_ports {dsi_byteclk_i}]
# set_clock_latency -source -setup <pll_clk_latency_sys_clk_i_max -0.041> [get_ports {dsi_fb_i}]
# set_clock_latency -source -hold <pll_clk_latency_sys_clk_i_min -0.026> [get_ports {dsi_fb_i}]
# set_clock_latency -source -setup <board_max -0.966> [get_ports {hdmi_pixel_10x}]
# set_clock_latency -source -hold <board_min -0.609> [get_ports {hdmi_pixel_10x}]
# set_clock_latency -source -setup <board_max -0.966> [get_ports {hdmi_pixel}]
# set_clock_latency -source -hold <board_min -0.609> [get_ports {hdmi_pixel}]
# set_clock_latency -source -setup <board_max -0.966> [get_ports {sensor_xclk_i}]
# set_clock_latency -source -hold <board_min -0.609> [get_ports {sensor_xclk_i}]
# set_clock_latency -source -setup <board_max -0.966> [get_ports {sys_clk_i}]
# set_clock_latency -source -hold <board_min -0.609> [get_ports {sys_clk_i}]
# set_clock_latency -source -setup <pll_clk_latency_sys_clk_i_max -0.004> [get_ports {hbramClk}]
# set_clock_latency -source -hold <pll_clk_latency_sys_clk_i_min -0.003> [get_ports {hbramClk}]
# set_clock_latency -source -setup <pll_clk_latency_sys_clk_i_max -0.004> [get_ports {hbramClk90}]
# set_clock_latency -source -hold <pll_clk_latency_sys_clk_i_min -0.003> [get_ports {hbramClk90}]
# set_clock_latency -source -setup <pll_clk_latency_sys_clk_i_max -0.004> [get_ports {hbramClk_Cal}]
# set_clock_latency -source -hold <pll_clk_latency_sys_clk_i_min -0.003> [get_ports {hbramClk_Cal}]