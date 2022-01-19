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

import os
import mmap
import struct
from ethhelper import *
import time
from etharb_regs import *

DSTIP = '192.168.1.100'
IFACE = 'eth0'
PORTS  = 8888

def getEtharbOffset():
    ls = os.listdir('/sys/firmware/devicetree/base/amba_pl/')
    for s in ls:
        if s.startswith('etharb_tx'):
            break
    return int(s.split('@')[1], 16)

devmem = open('/dev/mem', 'r+b')
etharb = mmap.mmap(devmem.fileno(), 0x10000, offset=getEtharbOffset())

srcmac,_,srcip,_,_ = getSrcNic(iface=IFACE)

#bump both src mac and IP up one (check first....) to avoid IVP4 ID collision
srcmac += 1
srcip += 1

dstmac = getMacByIp(DSTIP)
dstip = ipStr2Int(DSTIP)

etharb[ETHTX_SRCIP_REG:ETHTX_SRCIP_REG+4] = struct.pack('<I', srcip)
etharb[ETHTX_DSTIP_REG:ETHTX_DSTIP_REG+4] = struct.pack('<I', dstip)
etharb[ETHTX_SRCMAC_LREG:ETHTX_SRCMAC_LREG+4] = struct.pack('<I', srcmac & 0xFFFFFFFF)
etharb[ETHTX_SRCMAC_HREG:ETHTX_SRCMAC_HREG+4] = struct.pack('<I', srcmac >> 32)
etharb[ETHTX_DSTMAC_LREG:ETHTX_DSTMAC_LREG+4] = struct.pack('<I', dstmac & 0xFFFFFFFF)
etharb[ETHTX_DSTMAC_HREG:ETHTX_DSTMAC_HREG+4] = struct.pack('<I', dstmac >> 32)
etharb[ETHTX_SRCPRT_REG:ETHTX_SRCPRT_REG+4] = struct.pack('<I', PORTS)
etharb[ETHTX_DSTPRT_REG:ETHTX_DSTPRT_REG+4] = struct.pack('<I', PORTS)
etharb[ETHTX_ALLOW_REG:ETHTX_ALLOW_REG+4] = struct.pack('<I', 1)

while True:
    try:
        time.sleep(.25)
    except KeyboardInterrupt:
        break
etharb[ETHTX_ALLOW_REG:ETHTX_ALLOW_REG+4] = struct.pack('<I', 0)

lbytes = struct.unpack('<I', etharb[ETHTX_BYTCNT_LREG:ETHTX_BYTCNT_LREG+4])[0]
hbytes = struct.unpack('<I', etharb[ETHTX_BYTCNT_HREG:ETHTX_BYTCNT_HREG+4])[0]
npacks = struct.unpack('<I', etharb[ETHTX_PCTCNT_REG:ETHTX_PCTCNT_REG+4])[0]

etharb.close()
devmem.close()

print('%d bytes\n%d packets' % (((hbytes << 32) + lbytes), npacks))
