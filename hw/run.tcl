create_project project_1 ./project_1 -part xcu50-fsvh2104-2-e -force

set_property board_part xilinx.com:au50:part0:1.3 [current_project]

add_files {
 ../rtl/verilog/MAC_rx/MAC_rx_add_chk.v 
 ../rtl/verilog/MAC_tx/CRC_gen.v 
 ../rtl/verilog/reg_int.v 
 ../rtl/verilog/miim/eth_shiftreg.v 
 ../rtl/verilog/header.v 
 ../rtl/verilog/Clk_ctrl.v 
 ../rtl/verilog/RMON/RMON_addr_gen.v 
 ../rtl/verilog/MAC_rx/MAC_rx_ctrl.v 
 ../rtl/verilog/MAC_top.v 
 ../rtl/verilog/MAC_rx/Broadcast_filter.v 
 ../rtl/verilog/RMON.v 
 ../rtl/verilog/MAC_tx/MAC_tx_Ctrl.v 
 ../rtl/verilog/MAC_tx/flow_ctrl.v 
 ../rtl/verilog/eth_miim.v 
 ../rtl/verilog/miim/eth_clockgen.v 
 ../rtl/verilog/MAC_rx/MAC_rx_FF.v 
 ../rtl/verilog/MAC_tx/MAC_tx_addr_add.v 
 ../rtl/verilog/TECH/xilinx/duram.v 
 ../rtl/verilog/TECH/xilinx/xpm_afifo.v 
 ../rtl/verilog/TECH/xilinx/CLK_DIV2.v 
 ../rtl/verilog/TECH/xilinx/CLK_SWITCH.v 
 ../rtl/verilog/miim/eth_outputcontrol.v 
 ../rtl/verilog/RMON/RMON_ctrl.v 
 ../rtl/verilog/miim/timescale.v 
 ../rtl/verilog/RMON/RMON_dpram.v 
 ../rtl/verilog/MAC_rx/CRC_chk.v 
 ../rtl/verilog/MAC_tx/Ramdon_gen.v 
 ../rtl/verilog/MAC_tx/MAC_tx_FF.v 
 ../rtl/verilog/MAC_tx.v 
 ../rtl/verilog/Phy_int.v 
 ../rtl/verilog/MAC_rx.v}
 
 
 #set_property IS_GLOBAL_INCLUDE 1 [get_files -all ../rtl/verilog/header.v]
 #set_property IS_GLOBAL_INCLUDE 1 [get_files -all ../rtl/verilog/miim/timescale.v]
 
add_files -fileset sim_1 -norecurse {
../bench/verilog/Phy_sim.v 
../bench/verilog/User_int_sim.sv 
../bench/verilog/host_sim.v 
../bench/verilog/tb_top.v 
../bench/verilog/rst_clk_gen.v 
../bench/verilog/reg_int_sim.v}

update_compile_order -fileset sim_1
 


set_property include_dirs ../rtl/verilog [current_fileset]

set_property include_dirs ../rtl/verilog [get_filesets sim_1]
set_property include_dirs {../bench/verilog/IP_gen_chk/tb ../rtl/verilog} [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sources_1


ipx::package_project -root_dir ../ip_repo -vendor user.org -library user -taxonomy /UserIP -import_files

ipx::infer_bus_interface Clk_reg xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface Clk_user xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

ipx::associate_bus_interfaces -busif S_AXI -clock Clk_reg [ipx::current_core]
ipx::associate_bus_interfaces -busif M_AXIS -clock Clk_user [ipx::current_core]
ipx::associate_bus_interfaces -busif S_AXIS -clock Clk_user [ipx::current_core]

#ipx::add_bus_parameter POLARITY [ipx::get_bus_interfaces Reset -of_objects [ipx::current_core]]
#set_property value 1 [ipx::get_bus_parameters POLARITY -of_objects [ipx::get_bus_interfaces Reset -of_objects [ipx::current_core]]]

ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]



