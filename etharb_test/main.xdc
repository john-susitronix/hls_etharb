#////////////////////////////////////////////////////////////////////
#///                              __                             ////
#///                             |  |                            ////
#///                             |  |                            ////
#///                       ___   |  |                            ////
#///                   ___ \  \__/  /                            ////
#///                  /  /  \______/                             ////
#///                 /  /________________                        ////
#///                |   _________________|                       ////
#///                \  \                                         ////
#///                 \__\ John M Mower                           ////
#///                                                             ////
#/// Copyright (C) 2017 - 2022 Susitronix, LLC                   ////
#///                                                             ////
#///     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
#/// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
#/// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
#/// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
#/// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
#/// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
#/// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
#/// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
#/// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
#/// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
#/// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
#/// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
#/// POSSIBILITY OF SUCH DAMAGE.                                 ////
#///                                                             ////
#////////////////////////////////////////////////////////////////////


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

