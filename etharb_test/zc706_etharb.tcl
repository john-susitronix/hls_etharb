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

set design_name zc706_etharb

set origin_dir "."
set orig_proj_dir "[file normalize "$origin_dir/$design_name"]"
create_project $design_name $origin_dir/$design_name -part xc7z045ffg900-2
set proj_dir [get_property directory [current_project]]
set obj [get_projects $design_name]
set_property -name "board_part" -value "xilinx.com:zc706:part0:1.4" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/$design_name.cache/ip" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj

set_property -name "dsa.accelerator_binary_content" -value "bitstream" -objects $obj
set_property -name "dsa.accelerator_binary_format" -value "xclbin2" -objects $obj
set_property -name "dsa.board_id" -value "zc706" -objects $obj
set_property -name "dsa.description" -value "Vivado generated DSA" -objects $obj
set_property -name "dsa.dr_bd_base_address" -value "0" -objects $obj
set_property -name "dsa.emu_dir" -value "emu" -objects $obj
set_property -name "dsa.flash_interface_type" -value "bpix16" -objects $obj
set_property -name "dsa.flash_offset_address" -value "0" -objects $obj
set_property -name "dsa.flash_size" -value "1024" -objects $obj
set_property -name "dsa.host_architecture" -value "x86_64" -objects $obj
set_property -name "dsa.host_interface" -value "pcie" -objects $obj
set_property -name "dsa.num_compute_units" -value "60" -objects $obj
set_property -name "dsa.platform_state" -value "pre_synth" -objects $obj
set_property -name "dsa.vendor" -value "xilinx" -objects $obj
set_property -name "dsa.version" -value "0.0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_FIFO XPM_MEMORY" -objects $obj


if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

set obj [get_filesets sources_1]
set_property "ip_repo_paths" "[file normalize "$origin_dir/../hls/etharb_tx"] [file normalize "$origin_dir/../hls/eth_tstsrc"]" $obj
update_ip_catalog -rebuild

source $origin_dir/design_main.tcl

set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/zc706_etharb/zc706_etharb.srcs/sources_1/bd/design_main/design_main.bd"] \
 [file normalize "${origin_dir}/main.v"] \
]
add_files -norecurse -fileset $obj $files
 
set file "$origin_dir/zc706_etharb/zc706_etharb.srcs/sources_1/bd/design_main/design_main.bd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "registered_with_manager" -value "1" -objects $file_obj
 
set obj [get_filesets sources_1]
set_property -name "top" -value "main" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

set obj [get_filesets constrs_1]
 
set file "[file normalize "$origin_dir/main.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "$origin_dir/main.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7z045ffg900-2 -flow {Vivado Synthesis 2019} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2019" [get_runs synth_1]
}

set obj [get_runs synth_1]

current_run -synthesis [get_runs synth_1]

if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7z045ffg900-2 -flow {Vivado Implementation 2019} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2019" [get_runs impl_1]
}

set obj [get_runs impl_1]
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

current_run -implementation [get_runs impl_1]

launch_runs impl_1 -to_step write_bitstream -jobs 4

