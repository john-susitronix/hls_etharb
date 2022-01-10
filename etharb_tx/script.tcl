open_project etharb_tx
set_top etharb_tx
add_files etharb_tx.cpp
open_solution "solution1"
#set_part {xc7z045-ffg900-2} -tool vivado
set_part zynq -tool vivado
create_clock -period 8 -name default
config_export -format ip_catalog -rtl verilog -vivado_optimization_level 2 -vivado_phys_opt place -vivado_report_level 0
csynth_design
export_design -rtl verilog -format ip_catalog -version "0.0.0"
