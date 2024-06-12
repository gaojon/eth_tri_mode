( 
) (
) {

instantiate MAC_tx/MAC_tx_Ctrl.v (       
)

instantiate MAC_tx/CRC_gen.v (
Init                     :CRC_init               
)

instantiate MAC_tx/flow_ctrl.v (
)

`ifdef MAC_SOURCE_REPLACE_EN
instantiate MAC_tx/MAC_tx_addr_add.v (
)
`else
assign MAC_tx_addr_data ( 0 )
`endif

instantiate MAC_tx/MAC_tx_FF.v (
Clk_MAC                  :Clk                    
Clk_SYS                  :Clk_user               
)

instantiate MAC_tx/Ramdon_gen.v (
Init                     :Random_init            
)

}
