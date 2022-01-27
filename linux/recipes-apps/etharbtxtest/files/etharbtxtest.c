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

#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <net/if.h>
#include <unistd.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <byteswap.h>
#include <signal.h>

#include "etharbtx_ioctl.h"

#define DEF_DST_ADDR "192.168.1.100"
#define DEF_DST_PORT 8888

/*
  usage is options: -a <dst ip addr> -p <dst/src port> -i (<--increment src mac and ip)

  Increment bumps the src (ps) mac and addr up one.  This removes any possible contention
  for packet id.  While unlikely, there you have it...

  This program assumes no ARP tables so dst mac is broadcast.
*/

static volatile int running = 1;

void intHandler(int i) {
  running = 0;
}

void getSrc(char *iface, uint32_t *src_ip, uint64_t *src_mac);

int main(int argc, char **argv)
{
  int ethfd;
  
  uint32_t src_ip;
  uint64_t src_mac;

  uint32_t dst_ip;
  uint64_t dst_mac = 0xFFFFFFFFFFFF; // broadcast, no easy arp
  uint16_t dst_port = DEF_DST_PORT;

  int inc_flag = 0;

  struct etharbtx_cfg_t config;
  struct etharbtx_sts_t status;
  
  inet_pton(AF_INET, DEF_DST_ADDR, &dst_ip);
  dst_ip = bswap_32(dst_ip);

  int c;
  while ((c = getopt(argc, argv, "a:p:i")) != -1)
    switch (c)
      {
      case 'a':
	inet_pton(AF_INET, optarg, &dst_ip);
	dst_ip = bswap_32(dst_ip);
	break;
      case 'p':
	dst_port = atoi(optarg);
	break;
      case 'i':
	inc_flag = 1;
	break;
      case '?':
	printf("invalid argument\n");
	abort();
      }

  getSrc("eth0", &src_ip, &src_mac);

  printf("\n\n");
  
  printf("eth0 is %d.%d.%d.%d - %04x%08x\n", src_ip >> 24, (src_ip >> 16) & 0xFF,
	 (src_ip >> 8) & 0xFF, src_ip & 0xFF,
	 (uint32_t)(src_mac >> 32), (uint32_t)(src_mac));

  if (inc_flag) {
    printf("will add one to both fields\n");
    src_ip++;
    src_mac++;
  }
  
  printf("fpga is %d.%d.%d.%d - %04x%08x\n", src_ip >> 24, (src_ip >> 16) & 0xFF,
	 (src_ip >> 8) & 0xFF, src_ip & 0xFF,
	 (uint32_t)(src_mac >> 32), (uint32_t)(src_mac));

  printf("\n\n");
  
  printf("dest is %d.%d.%d.%d:%d\n", dst_ip >> 24, (dst_ip >> 16) & 0xFF,
	 (dst_ip >> 8) & 0xFF, dst_ip & 0xFF, dst_port);
  

  if ( (ethfd = open("/dev/etharbtx", O_RDONLY)) < 0 ) {
    printf("could not open /dev/etharbtx\n");
    abort();
  }

  config.src_ip = src_ip;
  config.dst_ip = dst_ip;
  config.src_mac = src_mac;
  config.dst_mac = dst_mac;
  config.src_port = dst_port;
  config.dst_port = dst_port;

  ioctl(ethfd, ETHARBTX_CFG, &config);

  int run = 1;
  ioctl(ethfd, ETHARBTX_ALLOW, &run);

  signal(SIGINT, intHandler);

  while (running)
    sleep(1);

  run = 0;
  ioctl(ethfd, ETHARBTX_ALLOW, &run);

  ioctl(ethfd, ETHARBTX_STS, &status);

  close(ethfd);

  printf("\n\n%d packets sent\n\n", status.packet_cnt);
  
  return 0;
}


void getSrc(char *iface, uint32_t *src_ip, uint64_t *src_mac)
{
  int fd;
  struct ifreq ifr;
  unsigned char *mac;
  int i;
  
  fd = socket(AF_INET, SOCK_DGRAM, 0);

  ifr.ifr_addr.sa_family = AF_INET;
  strncpy(ifr.ifr_name , iface , IFNAMSIZ-1);

  ioctl(fd, SIOCGIFADDR, &ifr);
  *src_ip = bswap_32( ( (struct sockaddr_in *)&ifr.ifr_addr )->sin_addr.s_addr );

  ioctl(fd, SIOCGIFHWADDR, &ifr);

  close(fd);

  mac = (unsigned char *)ifr.ifr_hwaddr.sa_data;
  *src_mac = 0;
  for (i=0; i<6; i++)
    *src_mac += (uint64_t)mac[i] << ((5-i)*8);
}

