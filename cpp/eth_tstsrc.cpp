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


