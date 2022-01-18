
set_property -dict {PACKAGE_PIN AE15 IOSTANDARD LVCMOS25} [get_ports phy_rst_n]
set_property -dict {PACKAGE_PIN AH17 IOSTANDARD LVCMOS25} [get_ports clk_oe]
set_property -dict {PACKAGE_PIN AF18 IOSTANDARD LVCMOS25} [get_ports clk_fsel]
set_property -dict {PACKAGE_PIN AE16 IOSTANDARD LVCMOS25} [get_ports mdc]
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS25} [get_ports mdio_io]
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVCMOS25} [get_ports {rgmii_rd[0]}]
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS25} [get_ports {rgmii_rd[1]}]
set_property -dict {PACKAGE_PIN AG12 IOSTANDARD LVCMOS25} [get_ports {rgmii_rd[2]}]
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS25} [get_ports {rgmii_rd[3]}]
set_property -dict {PACKAGE_PIN AF13 IOSTANDARD LVCMOS25} [get_ports rgmii_rx_ctl]
set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVCMOS25} [get_ports rgmii_rxc]
set_property -dict {PACKAGE_PIN AJ15 IOSTANDARD LVCMOS25} [get_ports {rgmii_td[0]}]
set_property -dict {PACKAGE_PIN AD14 IOSTANDARD LVCMOS25} [get_ports {rgmii_td[1]}]
set_property -dict {PACKAGE_PIN AD13 IOSTANDARD LVCMOS25} [get_ports {rgmii_td[2]}]
set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS25} [get_ports {rgmii_td[3]}]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS25} [get_ports rgmii_tx_ctl]
set_property -dict {PACKAGE_PIN AK15 IOSTANDARD LVCMOS25} [get_ports rgmii_txc]
set_property DIFF_TERM TRUE [get_ports clk_in1_n]
set_property -dict {PACKAGE_PIN AG17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports clk_in1_p]

create_clock -period 8.000 -name ref_clk_clk_p -waveform {0.000 4.000} [get_ports clk_in1_p]

set_input_delay -clock [get_clocks *axi_ethernet_0/inst/mac/inst_rgmii_rx_clk] -max -1.4 [get_ports -of [get_nets -of [get_pins "*/axi_ethernet_0/rgmii_rd[*] */axi_ethernet_0/rgmii_rx_ctl"]]]
set_input_delay -clock [get_clocks *axi_ethernet_0/inst/mac/inst_rgmii_rx_clk] -min -2.8 [get_ports -of [get_nets -of [get_pins "*/axi_ethernet_0/rgmii_rd[*] */axi_ethernet_0/rgmii_rx_ctl"]]]
set_input_delay -clock [get_clocks *axi_ethernet_0/inst/mac/inst_rgmii_rx_clk] -clock_fall -max -1.4 -add_delay [get_ports -of [get_nets -of [get_pins "*/axi_ethernet_0/rgmii_rd[*] */axi_ethernet_0/rgmii_rx_ctl"]]]
set_input_delay -clock [get_clocks *axi_ethernet_0/inst/mac/inst_rgmii_rx_clk] -clock_fall -min -2.8 -add_delay [get_ports -of [get_nets -of [get_pins "*/axi_ethernet_0/rgmii_rd[*] */axi_ethernet_0/rgmii_rx_ctl"]]]





create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 4 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list design_main_i/clk_wiz_ethfmc/inst/clk_out2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {design_main_i/etharb_rx_0_RXS_OUT_TDATA[0]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[1]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[2]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[3]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[4]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[5]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[6]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[7]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[8]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[9]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[10]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[11]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[12]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[13]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[14]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[15]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[16]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[17]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[18]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[19]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[20]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[21]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[22]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[23]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[24]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[25]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[26]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[27]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[28]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[29]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[30]} {design_main_i/etharb_rx_0_RXS_OUT_TDATA[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_main_i/etharb_rx_0_RXS_OUT_TKEEP[0]} {design_main_i/etharb_rx_0_RXS_OUT_TKEEP[1]} {design_main_i/etharb_rx_0_RXS_OUT_TKEEP[2]} {design_main_i/etharb_rx_0_RXS_OUT_TKEEP[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {design_main_i/etharb_rx_0_RXD_OUT_TDATA[0]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[1]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[2]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[3]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[4]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[5]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[6]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[7]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[8]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[9]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[10]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[11]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[12]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[13]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[14]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[15]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[16]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[17]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[18]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[19]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[20]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[21]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[22]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[23]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[24]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[25]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[26]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[27]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[28]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[29]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[30]} {design_main_i/etharb_rx_0_RXD_OUT_TDATA[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {design_main_i/etharb_rx_0_RXD_OUT_TKEEP[0]} {design_main_i/etharb_rx_0_RXD_OUT_TKEEP[1]} {design_main_i/etharb_rx_0_RXD_OUT_TKEEP[2]} {design_main_i/etharb_rx_0_RXD_OUT_TKEEP[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {design_main_i/cstate[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[0]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[1]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[2]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[3]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[4]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[5]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[6]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[7]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[8]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[9]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[10]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[11]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[12]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[13]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[14]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[15]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[16]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[17]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[18]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[19]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[20]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[21]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[22]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[23]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[24]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[25]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[26]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[27]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[28]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[29]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[30]} {design_main_i/axi_ethernet_0_m_axis_rxs_TDATA[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 4 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {design_main_i/axi_ethernet_0_m_axis_rxd_TKEEP[0]} {design_main_i/axi_ethernet_0_m_axis_rxd_TKEEP[1]} {design_main_i/axi_ethernet_0_m_axis_rxd_TKEEP[2]} {design_main_i/axi_ethernet_0_m_axis_rxd_TKEEP[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[0]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[1]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[2]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[3]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[4]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[5]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[6]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[7]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[8]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[9]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[10]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[11]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[12]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[13]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[14]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[15]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[16]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[17]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[18]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[19]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[20]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[21]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[22]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[23]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[24]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[25]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[26]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[27]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[28]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[29]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[30]} {design_main_i/axi_ethernet_0_m_axis_rxd_TDATA[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list design_main_i/axi_ethernet_0_m_axis_rxd_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list design_main_i/axi_ethernet_0_m_axis_rxd_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list design_main_i/axi_ethernet_0_m_axis_rxd_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list design_main_i/axi_ethernet_0_m_axis_rxs_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list design_main_i/axi_ethernet_0_m_axis_rxs_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list design_main_i/axi_ethernet_0_m_axis_rxs_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list design_main_i/cstate_ap_vld]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list design_main_i/etharb_rx_0_RXD_OUT_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list design_main_i/etharb_rx_0_RXD_OUT_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list design_main_i/etharb_rx_0_RXD_OUT_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list design_main_i/etharb_rx_0_RXS_OUT_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list design_main_i/etharb_rx_0_RXS_OUT_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list design_main_i/etharb_rx_0_RXS_OUT_TVALID]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_out2]
