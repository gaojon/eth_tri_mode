
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu50-fsvh2104-2-e
   set_property BOARD_PART xilinx.com:au50:part0:1.3 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:hbm:1.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:axi_apb_bridge:3.0\
xilinx.com:ip:proc_sys_reset:5.0\
user.org:user:MAC_top:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axis_dwidth_converter:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set pci_exp [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_exp ]

  set pcie_ref [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_ref ]

  set hbm_ref [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 hbm_ref ]


  # Create ports
  set pcie_rstn [ create_bd_port -dir I -type rst pcie_rstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $pcie_rstn
  set HBM_CATTRIP [ create_bd_port -dir O HBM_CATTRIP ]

  # Create instance: xdma_0, and set properties
  set xdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0 ]
  set_property -dict [list \
    CONFIG.PCIE_BOARD_INTERFACE {Custom} \
    CONFIG.SYS_RST_N_BOARD_INTERFACE {Custom} \
    CONFIG.axi_bypass_64bit_en {false} \
    CONFIG.axi_data_width {256_bit} \
    CONFIG.axil_master_64bit_en {false} \
    CONFIG.axilite_master_en {true} \
    CONFIG.axilite_master_scale {Kilobytes} \
    CONFIG.axilite_master_size {128} \
    CONFIG.axist_bypass_en {true} \
    CONFIG.axist_bypass_scale {Kilobytes} \
    CONFIG.axist_bypass_size {256} \
    CONFIG.en_gt_selection {true} \
    CONFIG.enable_auto_rxeq {False} \
    CONFIG.enable_ibert {false} \
    CONFIG.enable_jtag_dbg {true} \
    CONFIG.enable_ltssm_dbg {true} \
    CONFIG.enable_mark_debug {false} \
    CONFIG.enable_pcie_debug {False} \
    CONFIG.enable_pcie_debug_ports {False} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pcie_blk_locn {PCIE4C_X1Y1} \
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X4} \
    CONFIG.xdma_axi_intf_mm {AXI_Stream} \
    CONFIG.xdma_rnum_chnl {1} \
    CONFIG.xdma_wnum_chnl {1} \
  ] $xdma_0


  # Create instance: pcie_ref, and set properties
  set pcie_ref [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 pcie_ref ]
  set_property -dict [list \
    CONFIG.C_BUF_TYPE {IBUFDSGTE} \
    CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $pcie_ref


  # Create instance: hbm_0, and set properties
  set hbm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:hbm:1.0 hbm_0 ]
  set_property -dict [list \
    CONFIG.USER_MC_ENABLE_01 {FALSE} \
    CONFIG.USER_MC_ENABLE_02 {FALSE} \
    CONFIG.USER_MC_ENABLE_03 {FALSE} \
    CONFIG.USER_MC_ENABLE_04 {FALSE} \
    CONFIG.USER_MC_ENABLE_05 {FALSE} \
    CONFIG.USER_MC_ENABLE_06 {FALSE} \
    CONFIG.USER_MC_ENABLE_07 {FALSE} \
    CONFIG.USER_SAXI_01 {false} \
    CONFIG.USER_SINGLE_STACK_SELECTION {RIGHT} \
    CONFIG.USER_SWITCH_ENABLE_00 {FALSE} \
  ] $hbm_0


  # Create instance: hbm_ref, and set properties
  set hbm_ref [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 hbm_ref ]
  set_property -dict [list \
    CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $hbm_ref


  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property CONFIG.NUM_SI {1} $smartconnect_1


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {INTERFACE} \
    CONFIG.C_NUM_MONITOR_SLOTS {4} \
    CONFIG.C_SLOT_1_APC_EN {0} \
    CONFIG.C_SLOT_1_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_1_AXI_TRIG_SEL {1} \
    CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_2_APC_EN {0} \
    CONFIG.C_SLOT_2_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_2_AXI_TRIG_SEL {1} \
    CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_3_APC_EN {0} \
    CONFIG.C_SLOT_3_AXI_AR_SEL_DATA {1} \
    CONFIG.C_SLOT_3_AXI_AR_SEL_TRIG {1} \
    CONFIG.C_SLOT_3_AXI_AW_SEL_DATA {1} \
    CONFIG.C_SLOT_3_AXI_AW_SEL_TRIG {1} \
    CONFIG.C_SLOT_3_AXI_B_SEL_DATA {1} \
    CONFIG.C_SLOT_3_AXI_B_SEL_TRIG {1} \
    CONFIG.C_SLOT_3_AXI_R_SEL_DATA {1} \
    CONFIG.C_SLOT_3_AXI_R_SEL_TRIG {1} \
    CONFIG.C_SLOT_3_AXI_W_SEL_DATA {1} \
    CONFIG.C_SLOT_3_AXI_W_SEL_TRIG {1} \
    CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
  ] $system_ila_0


  # Create instance: axi_apb_bridge_0, and set properties
  set axi_apb_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_apb_bridge:3.0 axi_apb_bridge_0 ]
  set_property CONFIG.C_APB_NUM_SLAVES {1} $axi_apb_bridge_0


  # Create instance: smartconnect_2, and set properties
  set smartconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_2 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_2


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [list \
    CONFIG.RESET_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $proc_sys_reset_0


  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {NATIVE} \
    CONFIG.C_NUM_OF_PROBES {4} \
    CONFIG.C_PROBE0_TYPE {0} \
    CONFIG.C_PROBE1_TYPE {0} \
    CONFIG.C_PROBE2_TYPE {0} \
    CONFIG.C_PROBE3_TYPE {0} \
  ] $system_ila_1


  # Create instance: MAC_top_0, and set properties
  set MAC_top_0 [ create_bd_cell -type ip -vlnv user.org:user:MAC_top:1.0 MAC_top_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: axis_dwidth_converter_0, and set properties
  set axis_dwidth_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_0 ]
  set_property CONFIG.M_TDATA_NUM_BYTES {4} $axis_dwidth_converter_0


  # Create instance: axis_dwidth_converter_1, and set properties
  set axis_dwidth_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_1 ]
  set_property CONFIG.M_TDATA_NUM_BYTES {32} $axis_dwidth_converter_1


  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports pcie_ref] [get_bd_intf_pins pcie_ref/CLK_IN_D]
  connect_bd_intf_net -intf_net CLK_IN_D_0_2 [get_bd_intf_ports hbm_ref] [get_bd_intf_pins hbm_ref/CLK_IN_D]
  connect_bd_intf_net -intf_net MAC_top_0_M_AXIS [get_bd_intf_pins MAC_top_0/M_AXIS] [get_bd_intf_pins axis_dwidth_converter_1/S_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets MAC_top_0_M_AXIS] [get_bd_intf_pins MAC_top_0/M_AXIS] [get_bd_intf_pins system_ila_0/SLOT_2_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets MAC_top_0_M_AXIS]
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M [get_bd_intf_pins axi_apb_bridge_0/APB_M] [get_bd_intf_pins hbm_0/SAPB_0]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_dwidth_converter_0/M_AXIS] [get_bd_intf_pins MAC_top_0/S_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_dwidth_converter_0_M_AXIS] [get_bd_intf_pins axis_dwidth_converter_0/M_AXIS] [get_bd_intf_pins system_ila_0/SLOT_1_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axis_dwidth_converter_0_M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_1_M_AXIS [get_bd_intf_pins axis_dwidth_converter_1/M_AXIS] [get_bd_intf_pins xdma_0/S_AXIS_C2H_0]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins hbm_0/SAXI_00_RT] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_2_M00_AXI [get_bd_intf_pins smartconnect_2/M00_AXI] [get_bd_intf_pins axi_apb_bridge_0/AXI4_LITE]
  connect_bd_intf_net -intf_net smartconnect_2_M01_AXI [get_bd_intf_pins smartconnect_2/M01_AXI] [get_bd_intf_pins MAC_top_0/S_AXI]
  connect_bd_intf_net -intf_net xdma_0_M_AXIS_H2C_0 [get_bd_intf_pins xdma_0/M_AXIS_H2C_0] [get_bd_intf_pins axis_dwidth_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net xdma_0_M_AXI_BYPASS [get_bd_intf_pins xdma_0/M_AXI_BYPASS] [get_bd_intf_pins smartconnect_1/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets xdma_0_M_AXI_BYPASS] [get_bd_intf_pins xdma_0/M_AXI_BYPASS] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  connect_bd_intf_net -intf_net xdma_0_M_AXI_LITE [get_bd_intf_pins xdma_0/M_AXI_LITE] [get_bd_intf_pins smartconnect_2/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets xdma_0_M_AXI_LITE] [get_bd_intf_pins xdma_0/M_AXI_LITE] [get_bd_intf_pins system_ila_0/SLOT_3_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets xdma_0_M_AXI_LITE]
  connect_bd_intf_net -intf_net xdma_0_pcie_mgt [get_bd_intf_ports pci_exp] [get_bd_intf_pins xdma_0/pcie_mgt]

  # Create port connections
  connect_bd_net -net MAC_top_0_Gtx_clk [get_bd_pins MAC_top_0/Gtx_clk] [get_bd_pins MAC_top_0/Rx_clk] [get_bd_pins MAC_top_0/Tx_clk]
  connect_bd_net -net MAC_top_0_Tx_en [get_bd_pins MAC_top_0/Tx_en] [get_bd_pins MAC_top_0/Rx_dv] [get_bd_pins MAC_top_0/Crs]
  connect_bd_net -net MAC_top_0_Tx_er [get_bd_pins MAC_top_0/Tx_er] [get_bd_pins MAC_top_0/Rx_er]
  connect_bd_net -net MAC_top_0_Txd [get_bd_pins MAC_top_0/Txd] [get_bd_pins MAC_top_0/Rxd]
  connect_bd_net -net apb_complete_0 [get_bd_pins hbm_0/apb_complete_0] [get_bd_pins system_ila_1/probe3]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets apb_complete_0]
  connect_bd_net -net hbm_0_DRAM_0_STAT_CATTRIP [get_bd_pins hbm_0/DRAM_0_STAT_CATTRIP] [get_bd_ports HBM_CATTRIP]
  connect_bd_net -net pcie_perstn_1 [get_bd_ports pcie_rstn] [get_bd_pins xdma_0/sys_rst_n] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins xdma_0/s_axis_c2h_tkeep_0]
  connect_bd_net -net pcie_ref_IBUF_DS_ODIV2 [get_bd_pins pcie_ref/IBUF_DS_ODIV2] [get_bd_pins xdma_0/sys_clk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_apb_bridge_0/s_axi_aresetn] [get_bd_pins hbm_0/APB_0_PRESET_N] [get_bd_pins system_ila_1/probe0]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets proc_sys_reset_0_interconnect_aresetn]
  connect_bd_net -net user_lnk_up [get_bd_pins xdma_0/user_lnk_up] [get_bd_pins system_ila_1/probe1]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets user_lnk_up]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins pcie_ref/IBUF_OUT] [get_bd_pins xdma_0/sys_clk_gt]
  connect_bd_net -net util_ds_buf_1_IBUF_OUT [get_bd_pins hbm_ref/IBUF_OUT] [get_bd_pins hbm_0/HBM_REF_CLK_0] [get_bd_pins hbm_0/APB_0_PCLK] [get_bd_pins axi_apb_bridge_0/s_axi_aclk] [get_bd_pins smartconnect_2/aclk1] [get_bd_pins system_ila_1/clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net xdma_0_axi_aclk [get_bd_pins xdma_0/axi_aclk] [get_bd_pins hbm_0/AXI_00_ACLK] [get_bd_pins smartconnect_1/aclk] [get_bd_pins system_ila_0/clk] [get_bd_pins smartconnect_2/aclk] [get_bd_pins axis_dwidth_converter_0/aclk] [get_bd_pins axis_dwidth_converter_1/aclk] [get_bd_pins MAC_top_0/Clk_user] [get_bd_pins MAC_top_0/Clk_reg] [get_bd_pins MAC_top_0/Clk_125M]
  connect_bd_net -net xdma_0_axi_aresetn [get_bd_pins xdma_0/axi_aresetn] [get_bd_pins hbm_0/AXI_00_ARESET_N] [get_bd_pins smartconnect_1/aresetn] [get_bd_pins system_ila_0/resetn] [get_bd_pins smartconnect_2/aresetn] [get_bd_pins system_ila_1/probe2] [get_bd_pins axis_dwidth_converter_0/aresetn] [get_bd_pins axis_dwidth_converter_1/aresetn] [get_bd_pins MAC_top_0/ResetB]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets xdma_0_axi_aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins MAC_top_0/Col] [get_bd_pins MAC_top_0/Mdi]

  # Create address segments
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_BYPASS] [get_bd_addr_segs hbm_0/SAXI_00_RT/HBM_MEM00] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_LITE] [get_bd_addr_segs MAC_top_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x00400000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_LITE] [get_bd_addr_segs hbm_0/SAPB_0/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


