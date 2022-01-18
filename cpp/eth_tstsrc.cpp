
#include "ap_int.h"
#include "hls_stream.h"
#include <stdint.h>

#include "etharb_common.h"

#define MAXBIGBYTES 8972
#define MAXSMLBYTES 1472

void eth_tstsrc( AXIS_BYP& BYP_OUT, uint16_t *nbytes, bool *jumbo)
{
#pragma HLS INTERFACE axis port=BYP_OUT
#pragma HLS INTERFACE ap_ctrl_none port=return

  static uint32_t counter = 0;

  ap_axis_byp_t byp;

  uint16_t abytes;

  if (*nbytes > (*jumbo ? MAXBIGBYTES : MAXSMLBYTES))
    abytes = (*jumbo ? MAXBIGBYTES : MAXSMLBYTES);
  else
    abytes = 4 * (*nbytes / 4);

  byp.user = abytes;
  byp.last = 0;

  for (int i = 0; i < (abytes / 4); i++){
#pragma HLS PIPELINE
    byp.data = counter++;
    if (i == (abytes / 4) - 1)
      byp.last = 1;
    BYP_OUT << byp;
  }
}


