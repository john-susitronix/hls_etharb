# ETHARB_TX



vivado & vivado_hls & petalinux 2019.1

./build_zc706.sh

## NOTE: this design uses 9000 byte jumbo frames - either adjust in block design or increase your MTU to 9000 on host and zynq.

python:
I use Debian on Zynq to test and python is easy.  To test system, quickspeed.py (a quick dirty line rate test) will be on host, and other python files on zynq.

first, run etharb_tx_test.py as root on zynq,
second, run quickspeed.py on host (runs for 10 seconds) and reports average linerate (I usually get 992 Mbps).
