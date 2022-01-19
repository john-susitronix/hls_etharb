/////////////////////////////////////////////////////////////////////
////                              __                             ////
////                             |  |                            ////
////                             |  |                            ////
////                       ___   |  |                            ////
////                   ___ \  \__/  /                            ////
////                  /  /  \______/                             ////
////                 /  /________________                        ////
////                |   _________________|                       ////
////                \  \                                         ////
////                 \__\ John M Mower                           ////
////                                                             ////
//// Copyright (C) 2017 - 2022 Susitronix, LLC                   ////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

module main
   (
    inout [14:0] DDR_addr,
    inout [2:0]  DDR_ba,
    inout 	 DDR_cas_n,
    inout 	 DDR_ck_n,
    inout 	 DDR_ck_p,
    inout 	 DDR_cke,
    inout 	 DDR_cs_n,
    inout [3:0]  DDR_dm,
    inout [31:0] DDR_dq,
    inout [3:0]  DDR_dqs_n,
    inout [3:0]  DDR_dqs_p,
    inout 	 DDR_odt,
    inout 	 DDR_ras_n,
    inout 	 DDR_reset_n,
    inout 	 DDR_we_n,
    inout 	 FIXED_IO_ddr_vrn,
    inout 	 FIXED_IO_ddr_vrp,
    inout [53:0] FIXED_IO_mio,
    inout 	 FIXED_IO_ps_clk,
    inout 	 FIXED_IO_ps_porb,
    inout 	 FIXED_IO_ps_srstb,
    output 	 mdc,
    inout 	 mdio_io,
    input [3:0]  rgmii_rd,
    input 	 rgmii_rx_ctl,
    input 	 rgmii_rxc,
    output [3:0] rgmii_td,
    output 	 rgmii_tx_ctl,
    output 	 rgmii_txc,
    input 	 clk_in1_n,
    input 	 clk_in1_p,
    output 	 phy_rst_n,
    output 	 clk_oe,
    output 	 clk_fsel
    );

   assign clk_oe = 1;
   assign clk_fsel = 1;
      
   wire 	 mdio_i;
   wire 	 mdio_o;
   wire 	 mdio_t;

   IOBUF MDIO_mdio_iobuf
     (
      .I(mdio_o),
      .IO(mdio_io),
      .O(mdio_i),
      .T(mdio_t)
      );

   design_main design_main_i
     (
      .DDR_addr(DDR_addr),
      .DDR_ba(DDR_ba),
      .DDR_cas_n(DDR_cas_n),
      .DDR_ck_n(DDR_ck_n),
      .DDR_ck_p(DDR_ck_p),
      .DDR_cke(DDR_cke),
      .DDR_cs_n(DDR_cs_n),
      .DDR_dm(DDR_dm),
      .DDR_dq(DDR_dq),
      .DDR_dqs_n(DDR_dqs_n),
      .DDR_dqs_p(DDR_dqs_p),
      .DDR_odt(DDR_odt),
      .DDR_ras_n(DDR_ras_n),
      .DDR_reset_n(DDR_reset_n),
      .DDR_we_n(DDR_we_n),
      .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
      .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
      .FIXED_IO_mio(FIXED_IO_mio),
      .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
      .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
      .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
      .MDIO_mdc(mdc),
      .MDIO_mdio_i(mdio_i),
      .MDIO_mdio_o(mdio_o),
      .MDIO_mdio_t(mdio_t),
      .RGMII_rd(rgmii_rd),
      .RGMII_rx_ctl(rgmii_rx_ctl),
      .RGMII_rxc(rgmii_rxc),
      .RGMII_td(rgmii_td),
      .RGMII_tx_ctl(rgmii_tx_ctl),
      .RGMII_txc(rgmii_txc),
      .clk_in1_n(clk_in1_n),
      .clk_in1_p(clk_in1_p),
      .phy_rst_n(phy_rst_n)
      );
   
endmodule
