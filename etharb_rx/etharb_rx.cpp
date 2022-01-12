#include "ap_int.h"
#include "hls_stream.h"
#include <stdint.h>

#define NETSWAP(x) ((((x) & 0x000000FF) << 24) | (((x) & 0x0000FF00) << 8) | (((x) & 0x00FF0000) >> 8) | (((x) & 0xFF000000) >> 24))

struct ap_axis_dma_t {
        ap_int<32>   data;
        ap_uint<4>   keep;
        ap_uint<1>   last;
};

struct ap_axis_byp_t {
	ap_int<32>   data;
	ap_uint<16>  user;
	ap_uint<1>   last;
};

typedef hls::stream<ap_axis_dma_t> AXIS_DMA;
typedef hls::stream<ap_axis_byp_t> AXIS_BYP;

void etharb_rx(
		AXIS_DMA& RXS_IN, AXIS_DMA& RXS_OUT,
		AXIS_DMA& RXD_IN, AXIS_DMA& RXD_OUT,
		AXIS_BYP& BYP_OUT,
		uint32_t *filt_ip, uint16_t *filt_port, // ip broadcast 0xFFFFFFFF
		uint64_t *byte_cnt, uint32_t *pckt_cnt,
		bool *allow
		)
{
#pragma HLS INTERFACE axis port=RXD_IN
#pragma HLS INTERFACE axis port=RXS_IN
#pragma HLS INTERFACE axis port=RXD_OUT
#pragma HLS INTERFACE axis port=RXS_OUT
#pragma HLS INTERFACE axis port=BYP_OUT
#pragma HLS INTERFACE ap_ctrl_none port=return
#ifdef AXI_IFACE
 #pragma HLS INTERFACE s_axilite port=filt_ip     bundle=CTRL  clock=ctrl_clk
 #pragma HLS INTERFACE s_axilite port=filt_port   bundle=CTRL
 #pragma HLS INTERFACE s_axilite port=byte_cnt    bundle=CTRL
 #pragma HLS INTERFACE s_axilite port=pckt_cnt    bundle=CTRL
 #pragma HLS INTERFACE s_axilite port=allow       bundle=CTRL
 #pragma HLS INTERFACE s_axilite port=return      bundle=CTRL
#endif

	uint32_t filtip = *filt_ip;
	uint16_t filtpt = *filt_port;
	bool filt = *allow;

	uint32_t tmpip;
	uint16_t tmppt;
	uint16_t pckt_bytes;
	ap_axis_dma_t rxs_buf[6];
	ap_axis_dma_t rxd_buf[10];

	for (int i = 0; i < 6; i++)
#pragma HLS PIPELINE
		RXS_IN >> rxs_buf[i];

	for (int i = 0; i < 10; i++) {
#pragma HLS PIPELINE
		RXD_IN >> rxd_buf[i];
		/*
		if (i == 5 && NETSWAP(rxd_buf[i].data) != 0x40004011)
			filt = false;
		else if (i == 7)
			tmpip = NETSWAP(rxd_buf[i].data) << 16;
		else if (i == 8)
			tmpip |= NETSWAP(rxd_buf[i].data) >> 16;
		else if (i == 9) {
			tmppt = NETSWAP(rxd_buf[i].data) >> 16;
			pckt_bytes = (NETSWAP(rxd_buf[i].data) & 0xFFFF) - 8;
		}
		*/
	}

	/*
	if (filt && (tmpip == 0xFFFFFFFF || tmpip == filtip) && tmppt == filtpt)
		;
	else { */
		for (int i = 0; i < 6; i++)
#pragma HLS PIPELINE
			RXS_OUT << rxs_buf[i];
		for (int i = 0; i < 10; i++)
#pragma HLS PIPELINE
			RXD_OUT << rxd_buf[i];
		for (int i = 0; i < 2250; i++) {
#pragma HLS PIPELINE
			ap_axis_dma_t tmp;
			RXD_IN >> tmp;
			RXD_OUT << tmp;
			if (tmp.last)
				break;
		}

	//}


}

/*
void etharb_rx(
		ap_axis_dma_t rxs_in[6], AXIS_DMA& rxs_out,
		ap_axis_dma_t rxd_in[32], AXIS_DMA& rxd_out
						)
{
#pragma HLS INTERFACE axis port=rxs_in
#pragma HLS INTERFACE axis port=rxs_out
#pragma HLS INTERFACE axis port=rxd_in
#pragma HLS INTERFACE axis port=rxd_out
#pragma HLS INTERFACE ap_ctrl_none port=return

	for (int i = 0; i < 6; i++) {
#pragma HLS PIPELINE
		rxs_out << rxs_in[i];


	}
}
*/

/*
 * typedef hls::stream<ap_axis_dma_t> AXIS_DMA;

 *
#define NETSWAP(x) ((((x) & 0x000000FF) << 24) | (((x) & 0x0000FF00) << 8) | (((x) & 0x00FF0000) >> 8) | (((x) & 0xFF000000) >> 24))

uint64_t bcount = 0;
uint32_t pcount = 0;

void etharb_rx(
		AXIS_DMA& RXD_IN, AXIS_DMA& RXS_IN,
		AXIS_DMA& RXD_OUT, AXIS_DMA& RXS_OUT,
		uint32_t *filt_ip, uint16_t *filt_port, // ip broadcast 0xFFFFFFFF
		uint64_t *byte_cnt, uint32_t *pckt_cnt,
		bool *allow
		)
{
#pragma HLS INTERFACE axis port=RXD_IN
#pragma HLS INTERFACE axis port=RXS_IN
#pragma HLS INTERFACE axis port=RXD_OUT
#pragma HLS INTERFACE axis port=RXS_OUT
#pragma HLS INTERFACE ap_ctrl_none port=return
#ifdef AXI_IFACE
 #pragma HLS INTERFACE s_axilite port=filt_ip     bundle=CTRL  clock=ctrl_clk
 #pragma HLS INTERFACE s_axilite port=filt_port   bundle=CTRL
 #pragma HLS INTERFACE s_axilite port=byte_cnt    bundle=CTRL
 #pragma HLS INTERFACE s_axilite port=pckt_cnt    bundle=CTRL
 #pragma HLS INTERFACE s_axilite port=allow       bundle=CTRL
 #pragma HLS INTERFACE s_axilite port=return      bundle=CTRL
#endif

}



	uint32_t fltip = *filt_ip;
	uint16_t fltpt = *filt_port;

	*byte_cnt = bcount;
	*pckt_cnt = pcount;

	bool bypass = *allow;
	ap_axis_dma_t rxstmp[6];
	ap_axis_dma_t rxdtmp[10];

	if (!RXS_IN.empty()) {

		for (int i = 0; i < 6; i++)
			RXS_IN >> rxstmp[i];

		for (int i = 0; i < 10; i++) {
#pragma HLS PIPELINE
			RXD_IN >> rxdtmp[i];

			if (i == 3 && ((rxdtmp[i].data & 0xFF) != 0x08))
				bypass = false;

			if (fltip != 0xFFFFFFFF) {
				if (i == 6 && (NETSWAP(rxdtmp[i].data) && 0xFFFF) != (fltip >> 16))
					bypass = false;
				if (i == 7 && (NETSWAP(rxdtmp[i].data) >> 32) != (fltip & 0xFFFF))
					bypass = false;
			}

			if (i == 9 && (NETSWAP(rxdtmp[i].data) >> 32) != fltpt)
				bypass = false;
		}

		if (!bypass) {
			for (int i = 0; i < 6; i++)
				RXS_OUT << rxstmp[i];

			for (int i = 0; i < 10; i++)
				RXD_OUT << rxdtmp[i];

			for (int i = 0; i < 2490; i++) {
#pragma HLS PIPELINE
				RXS_IN >> rxdtmp[0];
				RXD_OUT << rxdtmp[0];
				if (rxdtmp[0].last)
					break;
			}
		}
		else {
			;
		}
	}
}
*/
