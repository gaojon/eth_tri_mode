  
  
create_project -force project_1 u50_xdma -part xcu50-fsvh2104-2-e
set_property BOARD_PART xilinx.com:au50:part0:1.3 [current_project]

set_property  ip_repo_paths  ../../ip_repo [current_project]
update_ip_catalog -rebuild

source bd.tcl

assign_bd_address
validate_bd_design 

make_wrapper -files [get_files ./u50_xdma/project_1.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ./u50_xdma/project_1.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v

add_files -fileset constrs_1 -norecurse ../xdc/pins.xdc

launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1


write_cfgmem -force -format mcs -interface spix4 -size 128 -loadbit "up 0x01002000 ./u50_xdma/project_1.runs/impl_1/design_1_wrapper.bit" -file "u50_xdma.mcs"
