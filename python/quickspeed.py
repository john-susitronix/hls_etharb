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
