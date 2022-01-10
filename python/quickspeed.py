
import socket as sc
from time import time

Nsec = 10

s = sc.socket(sc.AF_INET, sc.SOCK_DGRAM)
s.bind(('',8888))
tic = time()
cnt = 0
while True:
    cnt += len(s.recvfrom(16384)[0])
    toc = time()
    if (tic + Nsec) < toc:
        break

print('%d bytes in %d seconds' % (cnt, Nsec))
print('%f Mbps' % (8.0*cnt/Nsec/1e6))
