open_project etharb_tx
set_top etharb_tx
add_files ../cpp/etharb_tx.cpp
add_files ../cpp/etharb_common.h
open_solution "solution1"
set_part zynq -tool vivado
create_clock -period 8 -name default
config_export -format ip_catalog -rtl verilog -vivado_optimization_level 2 -vivado_phys_opt place -vivado_report_level 0
csynth_design
export_design -rtl verilog -format ip_catalog -version "0.0.0"
