#!/bin/bash

pushd etharb_tx
vivado_hls script.tcl
popd

pushd eth_tstsrc
vivado_hls script.tcl
popd

pushd etharb_test
vivado -mode batch -source zc706_etharb.tcl
popd

pushd linux
petalinux-create -t project -n linux_zc706 --template zynq
pushd linux_zc706
cp ../../etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/main.sysdef ../../etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/main.hdf
petalinux-config --get-hw-description=../../etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/ --silentconfig
echo "I normally will configure for SD debian here"
cp ../system-user.dtsi project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi
cp -r ../recipes-kernel project-spec/meta-user/
petalinux-build
petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --fpga ../../etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/main.bit --u-boot --force
popd
popd
