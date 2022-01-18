open_project eth_tstsrc
set_top eth_tstsrc
add_files ../cpp/eth_tstsrc.cpp
open_solution "solution1"
set_part zynq -tool vivado
create_clock -period 8 -name default
config_export -format ip_catalog -rtl verilog
csynth_design
export_design -rtl verilog -format ip_catalog -version "0.0.0"
