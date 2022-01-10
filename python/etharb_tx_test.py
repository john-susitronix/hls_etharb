
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
