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

sysdef="./etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/main.sysdef"

if ! command -v vivado -v &> /dev/null; then
    echo "source vivado"
    exit 1
fi
if ! command -v petalinux-config -h &> /dev/null; then
    echo "source petalinux"
    exit 1
fi

pushd hls
if [ ! -d "etharb_tx" ]; then
    vivado_hls etharb_tx.tcl
fi
if [ ! -d "eth_tstsrc" ]; then
    vivado_hls eth_tstsrc.tcl
fi
popd

pushd etharb_test
if [ ! -d "./zc706_etharb" ]; then
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
cp $sysdef linux/main.hdf

pushd linux
if [ ! -d "./linux_zc706" ]; then
    petalinux-create -t project -n linux_zc706 --template zynq
    pushd linux_zc706

    petalinux-config --get-hw-description=../ --silentconfig
    
    cp ../system-user.dtsi project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi
    cp -r ../recipes-kernel project-spec/meta-user/
    cp -r ../recipes-modules project-spec/meta-user/
    cp -r ../recipes-apps project-spec/meta-user/
    petalinux-build
    petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --fpga ../../etharb_test/zc706_etharb/zc706_etharb.runs/impl_1/main.bit --u-boot
    popd
fi
popd
