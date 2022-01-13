#!/bin/bash

force=0
usesd=0

while [ -n "$1" ]; do
    case "$1" in
	-f) force=1 ;;
	-s) usesd=1 ;;
	*) echo "$1 not an option" ;;
    esac
    shift
done

declare -a ListOfHls=("etharb_tx" "eth_tstsrc")
for n in ${ListOfHls[@]}; do
    pushd $n
    if [ ! -d "$n" ] || [ "$force" -gt 0 ]; then
	vivado_hls script.tcl
    fi
    popd
done

pushd etharb_test
if [ ! -d "./zc706_etharb" ] || [ "$force" -gt 0 ]; then
    vivado -mode batch -source zc706_etharb.tcl -force
fi
popd

pushd linux
if [ ! -d "./linux_zc706" ] || [ "$force" -gt 0 ]; then
    petalinux-create -t project -n linux_zc706 --template zynq --force
    pushd linux_zc706
    cp ../../etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/main.sysdef ../../etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/main.hdf
    petalinux-config --get-hw-description=../../etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/ --silentconfig
    
    if [ $usesd -gt 0 ]; then
	cp ../config_sdcard project-spec/configs/config
    fi

    cp ../system-user.dtsi project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi
    cp -r ../recipes-kernel project-spec/meta-user/
    petalinux-build
    petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --fpga ../../etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/main.bit --u-boot --force
    popd
fi
popd
