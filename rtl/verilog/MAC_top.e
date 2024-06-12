( 
cout		Speed	3	;
) (        
) {


instantiate MAC_rx.v (
Clk                        	:MAC_rx_clk_div          
MAC_add_prom_data          	:MAC_rx_add_prom_data       
MAC_add_prom_add           	:MAC_rx_add_prom_add        
MAC_add_prom_wr            	:MAC_rx_add_prom_wr          
)


instantiate MAC_tx.v (
Clk                        	:MAC_tx_clk_div              
TxD                        	:MTxD                       
TxEn                       	:MTxEn                      
CRS                        	:MCRS    
MAC_add_prom_data          	:MAC_tx_add_prom_data       
MAC_add_prom_add           	:MAC_tx_add_prom_add        
MAC_add_prom_wr            	:MAC_tx_add_prom_wr         
)

instantiate RMON.v U_RMON(
Clk                        :Clk_reg                    
)


instantiate Phy_int.v (
)


instantiate Clk_ctrl.v (
)


instantiate eth_miim.v (   
Clk                        	:Clk_reg                    
) 



instantiate reg_int.v (
aclk                  		:Clk_reg
)


}

















