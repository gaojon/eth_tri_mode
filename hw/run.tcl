create_project project_1 ./project_1 -part xcu50-fsvh2104-2-e

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
 ../rtl/verilog/TECH/duram.v 
 ../rtl/verilog/MAC_rx/Broadcast_filter.v 
 ../rtl/verilog/RMON.v 
 ../rtl/verilog/MAC_tx/MAC_tx_Ctrl.v 
 ../rtl/verilog/MAC_tx/flow_ctrl.v 
 ../rtl/verilog/eth_miim.v 
 ../rtl/verilog/miim/eth_clockgen.v 
 ../rtl/verilog/MAC_rx/MAC_rx_FF.v 
 ../rtl/verilog/MAC_tx/MAC_tx_addr_add.v 
 ../rtl/verilog/TECH/CLK_SWITCH.v 
 ../rtl/verilog/miim/eth_outputcontrol.v 
 ../rtl/verilog/RMON/RMON_ctrl.v 
 ../rtl/verilog/miim/timescale.v 
 ../rtl/verilog/RMON/RMON_dpram.v 
 ../rtl/verilog/TECH/CLK_DIV2.v 
 ../rtl/verilog/MAC_rx/CRC_chk.v 
 ../rtl/verilog/MAC_tx/Ramdon_gen.v 
 ../rtl/verilog/MAC_tx/MAC_tx_FF.v 
 ../rtl/verilog/MAC_tx.v 
 ../rtl/verilog/afifo.v
 ../rtl/verilog/Phy_int.v 
 ../rtl/verilog/MAC_rx.v}
 
 set_property IS_GLOBAL_INCLUDE 1 [get_files -all ../rtl/verilog/header.v]
 set_property IS_GLOBAL_INCLUDE 1 [get_files -all ../rtl/verilog/miim/timescale.v]
 
add_files -fileset sim_1 -norecurse {
../bench/verilog/Phy_sim.v 
../bench/verilog/User_int_sim.sv 
../bench/verilog/host_sim.v 
../bench/verilog/tb_top.v 
../bench/verilog/rst_clk_gen.v 
../bench/verilog/reg_int_sim.v}

update_compile_order -fileset sim_1
update_compile_order -fileset sim_1
 
 
set_property is_global_include true [get_files ../rtl/verilog/header.v]
set_property is_global_include true [get_files ../rtl/verilog/miim/timescale.v]
 
update_compile_order -fileset sources_1
update_compile_order -fileset sources_1

set_property include_dirs ..//bench/verilog/IP_gen_chk/tb [current_fileset]
