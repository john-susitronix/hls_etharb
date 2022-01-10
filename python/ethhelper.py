
import socket
import fcntl
import struct
import os

def ipStr2Int(s):
    ss = s.split('.')
    return int(ss[3]) | (int(ss[2]) << 8) | (int(ss[1]) << 16) | (int(ss[0]) << 24)

def getMacByIp(ipstr):
    os.popen('timeout .25 ping -c 1 %s' % ipstr)
    fields = os.popen('grep "%s " /proc/net/arp' % ipstr).read().split()
    if len(fields) == 0:
        return None
    return int(fields[3].translate(None, ":.- "), 16)
# fix cat blah mtu for proper eth interface
def getSrcNic(iface='eth0'):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    macinfo = fcntl.ioctl(sock.fileno(), 0x8927, struct.pack('256s', iface))
    macstr = ''.join(['%02x:' % ord(char) for char in macinfo[18:24]])[:-1]
    ipstr = socket.inet_ntoa(fcntl.ioctl(sock.fileno(), 0x8915, struct.pack('256s', iface))[20:24])
    sock.close()
    srcmac = int(macstr.translate(None, ":.- "), 16)
    ip = ipStr2Int(ipstr)
    mtu = int(os.popen('cat /sys/class/net/eth0/mtu').read())
    return [srcmac, macstr, ip, ipstr, mtu]
                        
