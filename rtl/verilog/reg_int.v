module Reg_int (


input 			[31:0]	S_AXI_araddr			,
output 					S_AXI_arready         	,
input 					S_AXI_arvalid         	,
input 			[31:0]	S_AXI_awaddr          	,
output 					S_AXI_awready         	,
input 					S_AXI_awvalid         	,
input 					S_AXI_bready          	,
output 			[1:0]	S_AXI_bresp           	,
output 	reg				S_AXI_bvalid          	,
output 	reg		[31:0]	S_AXI_rdata           	,
input 					S_AXI_rready          	,
output 			[1:0]	S_AXI_rresp           	,
output 	reg				S_AXI_rvalid          	,
input 			[31:0]	S_AXI_wdata           	,
output 					S_AXI_wready          	,
input 					S_AXI_wvalid          	,
input 					aclk                    ,
input 					Reset                   ,

                        //Tx host interface 
output          [4:0]   Tx_Hwmark               ,
output          [4:0]   Tx_Lwmark               ,   
output                  pause_frame_send_en     ,               
output          [15:0]  pause_quanta_set        ,
output                  MAC_tx_add_en           ,               
output                  FullDuplex              ,
output          [3:0]   MaxRetry                ,
output          [5:0]   IFGset                  ,
output          [7:0]   MAC_tx_add_prom_data    ,
output          [2:0]   MAC_tx_add_prom_add     ,
output                  MAC_tx_add_prom_wr      ,
output                  tx_pause_en             ,
output                  xoff_cpu                ,
output                  xon_cpu                 ,
                        //Rx host interface     
output                  MAC_rx_add_chk_en       ,   
output          [7:0]   MAC_rx_add_prom_data    ,   
output          [2:0]   MAC_rx_add_prom_add     ,   
output                  MAC_rx_add_prom_wr      ,   
output                  broadcast_filter_en     ,
output          [15:0]  broadcast_bucket_depth              ,
output          [15:0]  broadcast_bucket_interval           ,
output                  RX_APPEND_CRC           ,
output          [4:0]   Rx_Hwmark           ,
output          [4:0]   Rx_Lwmark           ,
output                  CRC_chk_en              ,               
output          [5:0]   RX_IFG_SET              ,
output          [15:0]  RX_MAX_LENGTH           ,// 1518
output          [6:0]   RX_MIN_LENGTH           ,// 64
                        //RMON host interface
output          [5:0]   CPU_rd_addr             ,
output                  CPU_rd_apply            ,
input                   CPU_rd_grant            ,
input           [31:0]  CPU_rd_dout             ,
                        //Phy int host interface     
output                  Line_loop_en            ,
output          [2:0]   Speed                   ,
                        //MII to CPU 
output          [7:0]   Divider                 ,// Divider for the host clock
output          [15:0]  CtrlData                ,// Control Data (to be written to the PHY reg.)
output          [4:0]   Rgad                    ,// Register Address (within the PHY)
output          [4:0]   Fiad                    ,// PHY Address
output                  NoPre                   ,// No Preamble (no 32-bit preamble)
output                  WCtrlData               ,// Write Control Data operation
output                  RStat                   ,// Read Status operation
output                  ScanStat                ,// Scan Status operation
input                   Busy                    ,// Busy Signal
input                   LinkFail                ,// Link Integrity Signal
input                   Nvalid                  ,// Invalid Status (qualifier for the valid scan result)
input           [15:0]  Prsd                    ,// Read Status Data (data read from the PHY)
input                   WCtrlDataStart          ,// This signals resets the WCTRLDATA bit in the MIIM Command register
input                   RStatStart              ,// This signal resets the RSTAT BIT in the MIIM Command register
input                   UpdateMIIRX_DATAReg     // Updates MII RX_DATA register with read data
);



reg                   	wr_en                    ;
reg                   	wr_start                 ;
reg						rd_start                 ;
reg						rd_en                    ;



reg           	[15:0]  CD_in                    ;
reg           	[8:0]   awaddr                   ;

wire					Reset                    ;

reg             [8:0]   araddr                   ;



assign S_AXI_awready 	=1'b1 	;   
assign S_AXI_wready	=1'b1	;
assign S_AXI_bresp    =2'b00 	;     
assign S_AXI_arready 	=1'b1   ;   



always @ (posedge aclk or posedge Reset)
	if (Reset)
		awaddr	<=0;
	else if (S_AXI_awvalid)
		awaddr	<= S_AXI_awaddr[8:0];

always @ (posedge aclk or posedge Reset)
	if (Reset)
		CD_in	<=0;
	else if (S_AXI_wvalid)
		CD_in = S_AXI_wdata[15:0];


always @ (posedge aclk or posedge Reset)
	if (Reset)
		wr_en	<=1'b0;
	else if (S_AXI_wvalid)
		wr_en	<=1'b1;
	else	
		wr_en	<=1'b0;



always @ (posedge aclk or posedge Reset)
	if (Reset)
		wr_start	<=1'b0;
	else if (S_AXI_wvalid)
		wr_start	<=1'b1;
	else if (S_AXI_bvalid)	
		wr_start	<=1'b0;		
		
		
//write response 

always @ (posedge aclk or posedge Reset)
	if (Reset)
		S_AXI_bvalid<=1'b0;
	else if (wr_en && S_AXI_bready)
		S_AXI_bvalid<=1'b1;
	else
		S_AXI_bvalid<=1'b0;





    RegCPUData U_000(Tx_Hwmark                ,7'd000,16'h0009,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_001(Tx_Lwmark                ,7'd001,16'h0008,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_002(pause_frame_send_en      ,7'd002,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_003(pause_quanta_set         ,7'd003,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_004(IFGset                   ,7'd004,16'h000c,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_005(FullDuplex               ,7'd005,16'h0001,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_006(MaxRetry                 ,7'd006,16'h0002,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_007(MAC_tx_add_en            ,7'd007,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_008(MAC_tx_add_prom_data     ,7'd008,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_009(MAC_tx_add_prom_add      ,7'd009,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_010(MAC_tx_add_prom_wr       ,7'd010,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_011(tx_pause_en              ,7'd011,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_012(xoff_cpu                 ,7'd012,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_013(xon_cpu                  ,7'd013,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_014(MAC_rx_add_chk_en        ,7'd014,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_015(MAC_rx_add_prom_data     ,7'd015,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_016(MAC_rx_add_prom_add      ,7'd016,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_017(MAC_rx_add_prom_wr       ,7'd017,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_018(broadcast_filter_en      ,7'd018,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_019(broadcast_bucket_depth   ,7'd019,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_020(broadcast_bucket_interval,7'd020,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_021(RX_APPEND_CRC            ,7'd021,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_022(Rx_Hwmark                ,7'd022,16'h001a,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_023(Rx_Lwmark                ,7'd023,16'h0010,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_024(CRC_chk_en               ,7'd024,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_025(RX_IFG_SET               ,7'd025,16'h000c,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_026(RX_MAX_LENGTH            ,7'd026,16'h2710,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_027(RX_MIN_LENGTH            ,7'd027,16'h0040,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_028(CPU_rd_addr              ,7'd028,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_029(CPU_rd_apply             ,7'd029,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
//  RegCPUData U_030(CPU_rd_grant             ,7'd030,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
//  RegCPUData U_031(CPU_rd_dout_l            ,7'd031,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
//  RegCPUData U_032(CPU_rd_dout_h            ,7'd032,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_033(Line_loop_en             ,7'd033,16'h0000,Reset,aclk,wr_en,awaddr,CD_in);
    RegCPUData U_034(Speed                    ,7'd034,16'h0004,Reset,aclk,wr_en,awaddr,CD_in);







always @ (posedge aclk or posedge Reset)
	if (Reset)
		araddr	<=0;
	else if (S_AXI_arvalid)
		araddr	<=S_AXI_araddr;
		

always @ (posedge aclk or posedge Reset)
	if (Reset)
		rd_en			<=1'b0;
	else if (S_AXI_arvalid)	
		rd_en			<=1'b1;
	else	
		rd_en			<=1'b0;
		
		
always @ (posedge aclk or posedge Reset)
	if (Reset)
		rd_start		<=1'b0;
	else if (S_AXI_arvalid)
		rd_start		<=1'b1;
	else if (S_AXI_rvalid)
		rd_start		<=1'b0;

always @ (posedge aclk or posedge Reset)
	if (Reset)	
		S_AXI_rvalid	<=1'b0;
	else if (rd_start && S_AXI_rready)
		S_AXI_rvalid	<=1'b1;
	else
		S_AXI_rvalid	<=1'b0;

		

always @ (posedge aclk or posedge Reset)
    if (Reset)
        S_AXI_rdata  <=0;
    else if (rd_en)
        case (araddr[8:2])
                7'd00:    S_AXI_rdata<=Tx_Hwmark                  ;
                7'd01:    S_AXI_rdata<=Tx_Lwmark                  ; 
                7'd02:    S_AXI_rdata<=pause_frame_send_en        ; 
                7'd03:    S_AXI_rdata<=pause_quanta_set           ;
                7'd04:    S_AXI_rdata<=IFGset                     ; 
                7'd05:    S_AXI_rdata<=FullDuplex                 ; 
                7'd06:    S_AXI_rdata<=MaxRetry                   ;
                7'd07:    S_AXI_rdata<=MAC_tx_add_en              ; 
                7'd08:    S_AXI_rdata<=MAC_tx_add_prom_data       ;
                7'd09:    S_AXI_rdata<=MAC_tx_add_prom_add        ; 
                7'd10:    S_AXI_rdata<=MAC_tx_add_prom_wr         ; 
                7'd11:    S_AXI_rdata<=tx_pause_en                ; 
                7'd12:    S_AXI_rdata<=xoff_cpu                   ;
                7'd13:    S_AXI_rdata<=xon_cpu                    ; 
                7'd14:    S_AXI_rdata<=MAC_rx_add_chk_en          ; 
                7'd15:    S_AXI_rdata<=MAC_rx_add_prom_data       ;
                7'd16:    S_AXI_rdata<=MAC_rx_add_prom_add        ; 
                7'd17:    S_AXI_rdata<=MAC_rx_add_prom_wr         ; 
                7'd18:    S_AXI_rdata<=broadcast_filter_en        ; 
                7'd19:    S_AXI_rdata<=broadcast_bucket_depth     ;    
                7'd20:    S_AXI_rdata<=broadcast_bucket_interval  ;   
                7'd21:    S_AXI_rdata<=RX_APPEND_CRC              ; 
                7'd22:    S_AXI_rdata<=Rx_Hwmark                  ; 
                7'd23:    S_AXI_rdata<=Rx_Lwmark                  ; 
                7'd24:    S_AXI_rdata<=CRC_chk_en                 ; 
                7'd25:    S_AXI_rdata<=RX_IFG_SET                 ; 
                7'd26:    S_AXI_rdata<=RX_MAX_LENGTH              ; 
                7'd27:    S_AXI_rdata<=RX_MIN_LENGTH              ; 
                7'd28:    S_AXI_rdata<=CPU_rd_addr                ; 
                7'd29:    S_AXI_rdata<=CPU_rd_apply               ;
                7'd30:    S_AXI_rdata<=CPU_rd_grant               ;
                7'd31:    S_AXI_rdata<=CPU_rd_dout[15:0]          ; 
                7'd32:    S_AXI_rdata<=CPU_rd_dout[31:16]         ;                 
                7'd33:    S_AXI_rdata<=Line_loop_en               ;
                7'd34:    S_AXI_rdata<=Speed                      ; 
                default:  S_AXI_rdata<=0                          ;
        endcase


endmodule   

module RegCPUData(
RegOut,   
awaddr_reg_set, 
RegInit,  
          
Reset,    
Clk,      
CWR_pulse,
awaddr_reg,     
CD_in_reg
);
output[15:0]    RegOut; 
input[6:0]      awaddr_reg_set;  
input[15:0]     RegInit;
//
input           Reset;
input           Clk;
input           CWR_pulse;

input[8:0]      awaddr_reg;
input[15:0]     CD_in_reg;
// 
reg[15:0]       RegOut; 

always  @(posedge Reset or posedge Clk)
    if(Reset)
        RegOut      <=RegInit;
    else if (CWR_pulse && awaddr_reg[8:2] ==awaddr_reg_set[6:0])  
        RegOut      <=CD_in_reg;

endmodule           