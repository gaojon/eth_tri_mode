#################################################################################
#
# Power Constraint to warn User if design will possibly be over cards power limit
#
set_operating_conditions -design_power_budget 63
#
# Bitstream generation
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK Enable [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 63.8 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes [current_design]
#################################################################################


###PCIE

set_property IOSTANDARD LVCMOS18 [get_ports pcie_rstn]
set_property PACKAGE_PIN AW27 [get_ports pcie_rstn]

set_property PACKAGE_PIN AB8 [get_ports {pcie_ref_clk_n[0]}]
set_property PACKAGE_PIN AB9 [get_ports {pcie_ref_clk_p[0]}]

set_property LOC GTYE4_CHANNEL_X1Y12 [get_cells {design_1_i/xdma_0/inst/pcie4c_ip_i/inst/design_1_xdma_0_0_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/design_1_xdma_0_0_pcie4c_ip_gt_i/inst/gen_gtwizard_gtye4_top.design_1_xdma_0_0_pcie4c_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[27].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN AN2 [get_ports {pci_exp_rxp[3]}]
set_property PACKAGE_PIN AN1 [get_ports {pci_exp_rxn[3]}]
set_property PACKAGE_PIN AC7 [get_ports {pci_exp_txp[3]}]
set_property PACKAGE_PIN AC6 [get_ports {pci_exp_txn[3]}]
set_property LOC GTYE4_CHANNEL_X1Y13 [get_cells {design_1_i/xdma_0/inst/pcie4c_ip_i/inst/design_1_xdma_0_0_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/design_1_xdma_0_0_pcie4c_ip_gt_i/inst/gen_gtwizard_gtye4_top.design_1_xdma_0_0_pcie4c_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[27].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN AK4 [get_ports {pci_exp_rxp[2]}]
set_property PACKAGE_PIN AK3 [get_ports {pci_exp_rxn[2]}]
set_property PACKAGE_PIN AB5 [get_ports {pci_exp_txp[2]}]
set_property PACKAGE_PIN AB4 [get_ports {pci_exp_txn[2]}]
set_property LOC GTYE4_CHANNEL_X1Y14 [get_cells {design_1_i/xdma_0/inst/pcie4c_ip_i/inst/design_1_xdma_0_0_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/design_1_xdma_0_0_pcie4c_ip_gt_i/inst/gen_gtwizard_gtye4_top.design_1_xdma_0_0_pcie4c_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[27].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN AM4 [get_ports {pci_exp_rxp[1]}]
set_property PACKAGE_PIN AM3 [get_ports {pci_exp_rxn[1]}]
set_property PACKAGE_PIN AA7 [get_ports {pci_exp_txp[1]}]
set_property PACKAGE_PIN AA6 [get_ports {pci_exp_txn[1]}]
set_property LOC GTYE4_CHANNEL_X1Y15 [get_cells {design_1_i/xdma_0/inst/pcie4c_ip_i/inst/design_1_xdma_0_0_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/design_1_xdma_0_0_pcie4c_ip_gt_i/inst/gen_gtwizard_gtye4_top.design_1_xdma_0_0_pcie4c_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[27].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN AL2 [get_ports {pci_exp_rxp[0]}]
set_property PACKAGE_PIN AL1 [get_ports {pci_exp_rxn[0]}]
set_property PACKAGE_PIN Y5 [get_ports {pci_exp_txp[0]}]
set_property PACKAGE_PIN Y4 [get_ports {pci_exp_txn[0]}]

###HBM #################################################################################

set_property PACKAGE_PIN BB18 [get_ports {hbm_ref_clk_p[0]}]
set_property IOSTANDARD LVDS [get_ports {hbm_ref_clk_p[0]}]
set_property DQS_BIAS TRUE [get_ports {hbm_ref_clk_p[0]}]

# HBM Catastrophic Over temperature Output signal to Satellite Controller
#    HBM_CATTRIP Active high indicator to Satellite controller to indicate the HBM has exceded its maximum allowable temperature.
#                This signal is not a dedicated FPGA output and is a derived signal in RTL. Making the signal Active will shut
#                the FPGA power rails off.
#
set_property PACKAGE_PIN J18 [get_ports HBM_CATTRIP]
set_property IOSTANDARD LVCMOS18 [get_ports HBM_CATTRIP]
set_property PULLTYPE PULLDOWN [get_ports HBM_CATTRIP]

#################################################################################

create_clock -period 10.000 -name hbm_ref_clk -waveform {0.000 5.000} [get_ports {hbm_ref_clk_p[0]}]
create_clock -period 10.000 -name pcie_ref_clk -waveform {0.000 5.000} [get_ports {pcie_ref_clk_p[0]}]


