#ifndef _ETHARB_COMMON_H_
#define _ETHARB_COMMON_H_

struct ap_axis_dma_t {
  ap_uint<32>  data;
  ap_uint<4>   keep;
  ap_uint<1>   last;
};

struct ap_axis_byp_t {
  ap_uint<32>  data;
  ap_uint<16>  user;
  ap_uint<1>   last;
};

typedef hls::stream<ap_axis_dma_t> AXIS_DMA;
typedef hls::stream<ap_axis_byp_t> AXIS_BYP;

#define NETSWAP(x) ((((x) & 0x000000FF) << 24) | (((x) & 0x0000FF00) << 8) | (((x) & 0x00FF0000) >> 8) | (((x) & 0xFF000000) >> 24))

#define AXI_IFACE

#endif
