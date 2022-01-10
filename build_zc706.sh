#!/bin/bash

pushd etharb_tx
vivado_hls script.tcl
popd

pushd eth_tstsrc
vivado_hls script.tcl
popd

pushd etharb_test
vivado -source zc706_etharb.tcl
popd

