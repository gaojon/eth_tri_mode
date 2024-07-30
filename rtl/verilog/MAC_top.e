( 
cout		Speed	3	;
in			ResetB		;
) (        
) {


instantiate MAC_rx.v (
Reset						:!ResetB
Clk                        	:MAC_rx_clk_div          
MAC_add_prom_data          	:MAC_rx_add_prom_data       
MAC_add_prom_add           	:MAC_rx_add_prom_add        
MAC_add_prom_wr            	:MAC_rx_add_prom_wr          
)


instantiate MAC_tx.v (
Reset						:!ResetB
Clk                        	:MAC_tx_clk_div              
TxD                        	:MTxD                       
TxEn                       	:MTxEn                      
CRS                        	:MCRS    
MAC_add_prom_data          	:MAC_tx_add_prom_data       
MAC_add_prom_add           	:MAC_tx_add_prom_add        
MAC_add_prom_wr            	:MAC_tx_add_prom_wr         
)

instantiate RMON.v U_RMON(
Reset						:!ResetB
Clk                        :Clk_reg                    
)


instantiate Phy_int.v (
Reset						:!ResetB
)


instantiate Clk_ctrl.v (
Reset						:!ResetB
)


instantiate eth_miim.v (   
Reset						:!ResetB
Clk                        	:Clk_reg                    
) 



instantiate reg_int.v (
Reset						:!ResetB
aclk                  		:Clk_reg
)


}

















