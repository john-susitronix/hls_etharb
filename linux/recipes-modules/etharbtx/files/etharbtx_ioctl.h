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

#ifndef _ETHARBTX_IOCTL_H_
#define _ETHARBTX_IOCTL_H_

#ifdef __KERNEL__
#include <linux/ioctl.h>
#else
#include <sys/ioctl.h>
#endif

struct etharbtx_cfg_t {
  uint32_t src_ip;
  uint32_t dst_ip;
  uint64_t src_mac;
  uint64_t dst_mac;
  uint16_t src_port;
  uint16_t dst_port;
};

struct etharbtx_sts_t {
  uint64_t byte_cnt;
  uint32_t packet_cnt;
};

#define ETHARBTX_MAGIC 'j'

#define ETHARBTX_ALLOW   _IOW(ETHARBTX_MAGIC, 1, int)
#define ETHARBTX_CFG     _IOW(ETHARBTX_MAGIC, 2, struct etharbtx_cfg_t)
#define ETHARBTX_STS     _IOR(ETHARBTX_MAGIC, 3, struct etharbtx_sts_t)

#endif

