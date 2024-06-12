(
) (
) {



instantiate MAC_rx/MAC_rx_ctrl.v (
)


instantiate MAC_rx/MAC_rx_FF.v (
Clk_MAC                     :Clk                      
Clk_SYS                     :Clk_user                 
)

`ifdef MAC_BROADCAST_FILTER_EN
instantiate MAC_rx/Broadcast_filter.v (
)
`else
assign broadcast_drop  (0 )

`endif


instantiate MAC_rx/CRC_chk.v (
CRC_data                    :Fifo_data                 
)



`ifdef MAC_TARGET_CHECK_EN

instantiate MAC_rx/MAC_rx_add_chk.v (
Init                       :CRC_init                   
data                       :Fifo_data                 
)
`else
assign MAC_rx_add_chk_err ( 0 )

`endif


} 