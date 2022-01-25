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

#ifndef _GENERICIO_H_
#define _GENERICIO_H_

#ifdef __KERNEL__
#include <asm/io.h>
#include <linux/delay.h>
#include <linux/types.h>
#else
#include "xil_io.h"
#include <stdint.h>
#endif

#ifdef __KERNEL__
typedef volatile void __iomem * genericioPtr;
#else
typedef uintptr_t genericioPtr;
#endif

void genericioUdelay(uint32_t usec)
{
#ifdef __KERNEL__
  udelay(usec);
#else
  volatile uint32_t t;
  for (t = 0; t < usec * 1000; t++) {;}
#endif
}

void genericioHwWrite(genericioPtr addr, uint32_t val)
{
#ifdef __KERNEL__
  iowrite32(val, addr);
#else
  Xil_Out32(addr, val);
#endif
}

uint32_t genericioHwRead(genericioPtr addr)
{
#ifdef __KERNEL__
  return ioread32(addr);
#else
  return Xil_In32(addr);
#endif
}

#endif
