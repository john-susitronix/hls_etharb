#include "ap_int.h"
#include "hls_stream.h"
#include <stdint.h>

#include "etharb_common.h"

#define ID_LOW 0x8000

#define IDLE_STATE   0
#define PASS_STATE   1
#define BYPASS_STATE 2

uint8_t state = IDLE_STATE;
uint16_t id = ID_LOW;
uint64_t bcount = 0;
uint32_t pcount = 0;

void etharb_tx(
	       AXIS_DMA& TXD_IN, AXIS_DMA& TXC_IN,
	       AXIS_DMA& TXD_OUT, AXIS_DMA& TXC_OUT,
	       AXIS_BYP& BYP_IN,
	       uint32_t *src_ip, uint32_t *dst_ip,
	       uint64_t *src_mac, uint64_t *dst_mac,
	       uint16_t *src_port, uint16_t *dst_port,
	       uint64_t *tx_byte_cnt, uint32_t *tx_pckt_cnt,
	       bool *allow_tx
	       )
{
#pragma HLS INTERFACE axis port=TXD_IN
#pragma HLS INTERFACE axis port=TXC_IN
#pragma HLS INTERFACE axis port=TXD_OUT
#pragma HLS INTERFACE axis port=TXC_OUT
#pragma HLS INTERFACE axis port=BYP_IN
#pragma HLS INTERFACE ap_ctrl_none port=return
#ifdef AXI_IFACE
#pragma HLS INTERFACE s_axilite port=src_ip       bundle=CTRL clock=ctrl_clk
#pragma HLS INTERFACE s_axilite port=dst_ip       bundle=CTRL
#pragma HLS INTERFACE s_axilite port=src_mac      bundle=CTRL
#pragma HLS INTERFACE s_axilite port=dst_mac      bundle=CTRL
#pragma HLS INTERFACE s_axilite port=src_port     bundle=CTRL
#pragma HLS INTERFACE s_axilite port=dst_port     bundle=CTRL
#pragma HLS INTERFACE s_axilite port=tx_byte_cnt  bundle=CTRL
#pragma HLS INTERFACE s_axilite port=tx_pckt_cnt  bundle=CTRL
#pragma HLS INTERFACE s_axilite port=allow_tx     bundle=CTRL
#pragma HLS INTERFACE s_axilite port=return       bundle=CTRL
#endif

  uint32_t srcip = *src_ip;
  uint32_t dstip = *dst_ip;
  uint64_t srcmac = *src_mac;
  uint64_t dstmac = *dst_mac;
  uint16_t srcport = *src_port;
  uint16_t dstport = *dst_port;

  *tx_byte_cnt = bcount;
  *tx_pckt_cnt = pcount;

  ap_axis_dma_t tmp;

  if (state == IDLE_STATE && !TXC_IN.empty())
    {
      for (int i = 0; i < 6; i++) {
#pragma HLS PIPELINE
	TXC_IN >> tmp;
	TXC_OUT << tmp;
	if (tmp.last)
	  break;
      }
      state = PASS_STATE;
    }
  else if (state == PASS_STATE) {
    for (int i = 0; i < 2500; i++) {
#pragma HLS PIPELINE
      TXD_IN >> tmp;
      TXD_OUT << tmp;
      if (tmp.last)
	break;
    }
    state = IDLE_STATE;
  }
  else if (state == IDLE_STATE && !BYP_IN.empty() && *allow_tx) {
    tmp.keep = 0xF;
    tmp.last = 0;

    tmp.data = 0xA0000000;
    TXC_OUT << tmp;
    tmp.data = 0x00000002;
    TXC_OUT << tmp;
    tmp.data = 0;
    TXC_OUT << tmp;
    TXC_OUT << tmp;
    TXC_OUT << tmp;
    tmp.last = 1;
    TXC_OUT << tmp;

    state = BYPASS_STATE;
  }
  else if (state == BYPASS_STATE) {
    ap_axis_byp_t byptmp;

    BYP_IN >> byptmp;
    uint16_t udp_bytes = byptmp.user + 8;
    uint16_t ipv4_bytes = byptmp.user + 28;

    tmp.keep = 0xF;
    tmp.last = 0;

    tmp.data = NETSWAP((dstmac >> 16) & 0xFFFFFFFF);
    TXD_OUT << tmp;
    tmp.data = NETSWAP((dstmac << 16) | ((srcmac >> 32) & 0x0000FFFF));
    TXD_OUT << tmp;
    tmp.data = NETSWAP(srcmac);
    TXD_OUT << tmp;
    tmp.data = NETSWAP(0x08004500);
    TXD_OUT << tmp;
    tmp.data = NETSWAP((ipv4_bytes << 16) | id);
    TXD_OUT << tmp;
    tmp.data = NETSWAP(0x40004011);
    TXD_OUT << tmp;
    tmp.data = NETSWAP(srcip >> 16);
    TXD_OUT << tmp;
    tmp.data = NETSWAP((srcip << 16) | (dstip >> 16));
    TXD_OUT << tmp;
    tmp.data = NETSWAP((dstip << 16) | srcport);
    TXD_OUT << tmp;
    tmp.data = NETSWAP((dstport << 16) | udp_bytes);
    TXD_OUT << tmp;

    tmp.data = NETSWAP(NETSWAP(byptmp.data) >> 16);
    uint32_t bypdlast = NETSWAP(byptmp.data);
    TXD_OUT << tmp;
    bcount += 44;

    for (int i = 0; i < (8972 / 4); i++){
#pragma HLS PIPELINE

      if (!byptmp.last) {
	BYP_IN >> byptmp;
	tmp.data = NETSWAP((bypdlast << 16) | (NETSWAP(byptmp.data) >> 16));
	bypdlast = NETSWAP(byptmp.data);
	bcount += 4;
      }
      else {
	tmp.data = NETSWAP(bypdlast << 16);
	tmp.keep = 0x3;
	tmp.last = 1;
	bcount += 2;
      }

      TXD_OUT << tmp;

      if (tmp.last)
	break;
    }

    pcount++;
    if (id++ == 0)
      id = ID_LOW;
    state = IDLE_STATE;
  }
}
