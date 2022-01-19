#!/bin/bash

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

force=0
usesd=0

sysdef="./etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/main.sysdef"

while [ -n "$1" ]; do
    case "$1" in
	-f) force=1 ;;
	-s) usesd=1 ;;
	*) echo "$1 not an option" ;;
    esac
    shift
done

if ! command -v vivado -v &> /dev/null; then
    echo "source vivado"
    exit 1
fi
if ! command -v petalinux-config -h &> /dev/null; then
    echo "source petalinux"
    exit 1
fi

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
    rm $sysdef
    vivado -mode batch -source zc706_etharb.tcl
fi
popd

printf "waiting for sysdef file"
while : ; do
    if [ -f "$sysdef" ]; then
	break
    fi
    printf "."
    sleep 1
done
printf "\n"
cp $sysdef linux

pushd linux
if [ ! -d "./linux_zc706" ] || [ "$force" -gt 0 ]; then
    petalinux-create -t project -n linux_zc706 --template zynq --force
    pushd linux_zc706

    petalinux-config --get-hw-description=../ --silentconfig
    
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
