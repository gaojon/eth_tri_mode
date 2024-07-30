//******************************************************************************
//verilog file is created by Jon 
//******************************************************************************
module MAC_top ( 
Speed                         ,
ResetB                        ,
Clk_user                      ,
M_AXIS_tdata                  ,
M_AXIS_tdest                  ,
M_AXIS_tid                    ,
M_AXIS_tlast                  ,
M_AXIS_tready                 ,
M_AXIS_tstrb                  ,
M_AXIS_tvalid                 ,
S_AXIS_tready                 ,
S_AXIS_tvalid                 ,
S_AXIS_tdata                  ,
S_AXIS_tstrb                  ,
S_AXIS_tlast                  ,
S_AXIS_tdest                  ,
S_AXIS_tid                    ,
Clk_reg                       ,
Tx_er                         ,
Tx_en                         ,
Txd                           ,
Rx_er                         ,
Rx_dv                         ,
Rxd                           ,
Crs                           ,
Col                           ,
Clk_125M                      ,
Gtx_clk                       ,
Rx_clk                        ,
Tx_clk                        ,
Mdo                           ,
MdoEn                         ,
Mdi                           ,
Mdc                           ,
S_AXI_araddr                  ,
S_AXI_arready                 ,
S_AXI_arvalid                 ,
S_AXI_awaddr                  ,
S_AXI_awready                 ,
S_AXI_awvalid                 ,
S_AXI_bready                  ,
S_AXI_bresp                   ,
S_AXI_bvalid                  ,
S_AXI_rdata                   ,
S_AXI_rready                  ,
S_AXI_rresp                   ,
S_AXI_rvalid                  ,
S_AXI_wdata                   ,
S_AXI_wready                  ,
S_AXI_wvalid                  );
output  [2:0]                         Speed                         ;
input                                 ResetB                        ;
input                                 Clk_user                      ;
output  [31:0]                        M_AXIS_tdata                  ;
output                                M_AXIS_tdest                  ;
output                                M_AXIS_tid                    ;
output                                M_AXIS_tlast                  ;
input                                 M_AXIS_tready                 ;
output  [3:0]                         M_AXIS_tstrb                  ;
output                                M_AXIS_tvalid                 ;
output                                S_AXIS_tready                 ;
input                                 S_AXIS_tvalid                 ;
input   [31:0]                        S_AXIS_tdata                  ;
input   [3:0]                         S_AXIS_tstrb                  ;
input                                 S_AXIS_tlast                  ;
input                                 S_AXIS_tdest                  ;
input                                 S_AXIS_tid                    ;
input                                 Clk_reg                       ;
output                                Tx_er                         ;
output                                Tx_en                         ;
output  [7:0]                         Txd                           ;
input                                 Rx_er                         ;
input                                 Rx_dv                         ;
input   [7:0]                         Rxd                           ;
input                                 Crs                           ;
input                                 Col                           ;
input                                 Clk_125M                      ;
output                                Gtx_clk                       ;//used only in GMII mode
input                                 Rx_clk                        ;
input                                 Tx_clk                        ;//used only in MII mode
output                                Mdo                           ;// MII Management Data Output
output                                MdoEn                         ;// MII Management Data Output Enable
input                                 Mdi                           ;
output                                Mdc                           ;// MII Management Data Clock
input   [31:0]                        S_AXI_araddr                  ;
output                                S_AXI_arready                 ;
input                                 S_AXI_arvalid                 ;
input   [31:0]                        S_AXI_awaddr                  ;
output                                S_AXI_awready                 ;
input                                 S_AXI_awvalid                 ;
input                                 S_AXI_bready                  ;
output  [1:0]                         S_AXI_bresp                   ;
output                                S_AXI_bvalid                  ;
output  [31:0]                        S_AXI_rdata                   ;
input                                 S_AXI_rready                  ;
output  [1:0]                         S_AXI_rresp                   ;
output                                S_AXI_rvalid                  ;
input   [31:0]                        S_AXI_wdata                   ;
output                                S_AXI_wready                  ;
input                                 S_AXI_wvalid                  ;
//******************************************************************************
//internal signals specification 						
//******************************************************************************
wire    [15:0]                        pause_quanta                  ;
wire                                  pause_quanta_val              ;
wire    [2:0]                         Tx_pkt_type_rmon              ;
wire    [15:0]                        Tx_pkt_length_rmon            ;
wire                                  Tx_apply_rmon                 ;
wire    [2:0]                         Tx_pkt_err_type_rmon          ;
wire    [2:0]                         Rx_pkt_type_rmon              ;
wire    [15:0]                        Rx_pkt_length_rmon            ;
wire                                  Rx_apply_rmon                 ;
wire    [2:0]                         Rx_pkt_err_type_rmon          ;
wire                                  MCrs_dv                       ;
wire    [7:0]                         MRxD                          ;
wire                                  MRxErr                        ;
wire    [7:0]                         MTxD                          ;
wire                                  MTxEn                         ;
wire                                  MCRS                          ;
wire                                  MAC_tx_clk                    ;
wire                                  MAC_rx_clk                    ;
wire                                  MAC_tx_clk_div                ;
wire                                  MAC_rx_clk_div                ;
wire    [4:0]                         Tx_Hwmark                     ;
wire    [4:0]                         Tx_Lwmark                     ;
wire                                  pause_frame_send_en           ;
wire    [15:0]                        pause_quanta_set              ;
wire                                  MAC_tx_add_en                 ;
wire                                  FullDuplex                    ;
wire    [3:0]                         MaxRetry                      ;
wire    [5:0]                         IFGset                        ;
wire    [7:0]                         MAC_tx_add_prom_data          ;
wire    [2:0]                         MAC_tx_add_prom_add           ;
wire                                  MAC_tx_add_prom_wr            ;
wire                                  tx_pause_en                   ;
wire                                  xoff_cpu                      ;
wire                                  xon_cpu                       ;
wire                                  MAC_rx_add_chk_en             ;
wire    [7:0]                         MAC_rx_add_prom_data          ;
wire    [2:0]                         MAC_rx_add_prom_add           ;
wire                                  MAC_rx_add_prom_wr            ;
wire                                  broadcast_filter_en           ;
wire    [15:0]                        broadcast_bucket_depth        ;
wire    [15:0]                        broadcast_bucket_interval     ;
wire                                  RX_APPEND_CRC                 ;
wire    [4:0]                         Rx_Hwmark                     ;
wire    [4:0]                         Rx_Lwmark                     ;
wire                                  CRC_chk_en                    ;
wire    [5:0]                         RX_IFG_SET                    ;
wire    [15:0]                        RX_MAX_LENGTH                 ;// 1518
wire    [6:0]                         RX_MIN_LENGTH                 ;// 64
wire    [5:0]                         CPU_rd_addr                   ;
wire                                  CPU_rd_apply                  ;
wire                                  CPU_rd_grant                  ;
wire    [31:0]                        CPU_rd_dout                   ;
wire                                  Line_loop_en                  ;
wire    [7:0]                         Divider                       ;// Divider for the host clock
wire    [15:0]                        CtrlData                      ;// Control Data (to be written to the PHY reg.)
wire    [4:0]                         Rgad                          ;// Register Address (within the PHY)
wire    [4:0]                         Fiad                          ;// PHY Address
wire                                  NoPre                         ;// No Preamble (no 32-bit preamble)
wire                                  WCtrlData                     ;// Write Control Data operation
wire                                  RStat                         ;// Read Status operation
wire                                  ScanStat                      ;// Scan Status operation
wire                                  Busy                          ;// Busy Signal
wire                                  LinkFail                      ;// Link Integrity Signal
wire                                  Nvalid                        ;// Invalid Status (qualifier for the valid scan result)
wire    [15:0]                        Prsd                          ;// Read Status Data (data read from the PHY)
wire                                  WCtrlDataStart                ;// This signals resets the WCTRLDATA bit in the MIIM Command register
wire                                  RStatStart                    ;// This signal resets the RSTAT BIT in the MIIM Command register
wire                                  UpdateMIIRX_DATAReg           ;
//external signals with reg specification						
//******************************************************************************
//internal logical specification 						
//******************************************************************************


MAC_rx U_MAC_rx (
.Reset                         (!ResetB                       ),
.Clk                           (MAC_rx_clk_div                ),
.MCrs_dv                       (MCrs_dv                       ),
.MRxD                          (MRxD                          ),
.MRxErr                        (MRxErr                        ),
.pause_quanta                  (pause_quanta                  ),
.pause_quanta_val              (pause_quanta_val              ),
.Rx_pkt_length_rmon            (Rx_pkt_length_rmon            ),
.Rx_apply_rmon                 (Rx_apply_rmon                 ),
.Rx_pkt_err_type_rmon          (Rx_pkt_err_type_rmon          ),
.Rx_pkt_type_rmon              (Rx_pkt_type_rmon              ),
.RX_IFG_SET                    (RX_IFG_SET                    ),
.RX_MAX_LENGTH                 (RX_MAX_LENGTH                 ),
.RX_MIN_LENGTH                 (RX_MIN_LENGTH                 ),
.Clk_user                      (Clk_user                      ),
.RX_APPEND_CRC                 (RX_APPEND_CRC                 ),
.Rx_Hwmark                     (Rx_Hwmark                     ),
.Rx_Lwmark                     (Rx_Lwmark                     ),
.M_AXIS_tdata                  (M_AXIS_tdata                  ),
.M_AXIS_tdest                  (M_AXIS_tdest                  ),
.M_AXIS_tid                    (M_AXIS_tid                    ),
.M_AXIS_tlast                  (M_AXIS_tlast                  ),
.M_AXIS_tready                 (M_AXIS_tready                 ),
.M_AXIS_tstrb                  (M_AXIS_tstrb                  ),
.M_AXIS_tvalid                 (M_AXIS_tvalid                 ),
.broadcast_filter_en           (broadcast_filter_en           ),
.broadcast_bucket_depth        (broadcast_bucket_depth        ),
.broadcast_bucket_interval     (broadcast_bucket_interval     ),
.CRC_chk_en                    (CRC_chk_en                    ),
.MAC_rx_add_chk_en             (MAC_rx_add_chk_en             ),
.MAC_add_prom_data             (MAC_rx_add_prom_data          ),
.MAC_add_prom_add              (MAC_rx_add_prom_add           ),
.MAC_add_prom_wr               (MAC_rx_add_prom_wr            ));



MAC_tx U_MAC_tx (
.Reset                         (!ResetB                       ),
.Clk                           (MAC_tx_clk_div                ),
.TxD                           (MTxD                          ),
.TxEn                          (MTxEn                         ),
.CRS                           (MCRS                          ),
.Tx_pkt_type_rmon              (Tx_pkt_type_rmon              ),
.Tx_pkt_length_rmon            (Tx_pkt_length_rmon            ),
.Tx_apply_rmon                 (Tx_apply_rmon                 ),
.Tx_pkt_err_type_rmon          (Tx_pkt_err_type_rmon          ),
.pause_frame_send_en           (pause_frame_send_en           ),
.pause_quanta_set              (pause_quanta_set              ),
.MAC_tx_add_en                 (MAC_tx_add_en                 ),
.FullDuplex                    (FullDuplex                    ),
.MaxRetry                      (MaxRetry                      ),
.IFGset                        (IFGset                        ),
.tx_pause_en                   (tx_pause_en                   ),
.xoff_cpu                      (xoff_cpu                      ),
.xon_cpu                       (xon_cpu                       ),
.pause_quanta                  (pause_quanta                  ),
.pause_quanta_val              (pause_quanta_val              ),
.MAC_add_prom_data             (MAC_tx_add_prom_data          ),
.MAC_add_prom_add              (MAC_tx_add_prom_add           ),
.MAC_add_prom_wr               (MAC_tx_add_prom_wr            ),
.Clk_user                      (Clk_user                      ),
.S_AXIS_tready                 (S_AXIS_tready                 ),
.S_AXIS_tvalid                 (S_AXIS_tvalid                 ),
.S_AXIS_tdata                  (S_AXIS_tdata                  ),
.S_AXIS_tstrb                  (S_AXIS_tstrb                  ),
.S_AXIS_tlast                  (S_AXIS_tlast                  ),
.S_AXIS_tdest                  (S_AXIS_tdest                  ),
.S_AXIS_tid                    (S_AXIS_tid                    ),
.Tx_Hwmark                     (Tx_Hwmark                     ),
.Tx_Lwmark                     (Tx_Lwmark                     ));


RMON U_RMON (
.Clk                           (Clk_reg                       ),
.Reset                         (!ResetB                       ),
.Tx_pkt_type_rmon              (Tx_pkt_type_rmon              ),
.Tx_pkt_length_rmon            (Tx_pkt_length_rmon            ),
.Tx_apply_rmon                 (Tx_apply_rmon                 ),
.Tx_pkt_err_type_rmon          (Tx_pkt_err_type_rmon          ),
.Rx_pkt_type_rmon              (Rx_pkt_type_rmon              ),
.Rx_pkt_length_rmon            (Rx_pkt_length_rmon            ),
.Rx_apply_rmon                 (Rx_apply_rmon                 ),
.Rx_pkt_err_type_rmon          (Rx_pkt_err_type_rmon          ),
.CPU_rd_addr                   (CPU_rd_addr                   ),
.CPU_rd_apply                  (CPU_rd_apply                  ),
.CPU_rd_grant                  (CPU_rd_grant                  ),
.CPU_rd_dout                   (CPU_rd_dout                   ));



Phy_int U_Phy_int (
.Reset                         (!ResetB                       ),
.MAC_rx_clk                    (MAC_rx_clk                    ),
.MAC_tx_clk                    (MAC_tx_clk                    ),
.MCrs_dv                       (MCrs_dv                       ),
.MRxD                          (MRxD                          ),
.MRxErr                        (MRxErr                        ),
.MTxD                          (MTxD                          ),
.MTxEn                         (MTxEn                         ),
.MCRS                          (MCRS                          ),
.Tx_er                         (Tx_er                         ),
.Tx_en                         (Tx_en                         ),
.Txd                           (Txd                           ),
.Rx_er                         (Rx_er                         ),
.Rx_dv                         (Rx_dv                         ),
.Rxd                           (Rxd                           ),
.Crs                           (Crs                           ),
.Col                           (Col                           ),
.Line_loop_en                  (Line_loop_en                  ),
.Speed                         (Speed                         ));



Clk_ctrl U_Clk_ctrl (
.Reset                         (!ResetB                       ),
.Clk_125M                      (Clk_125M                      ),
.Speed                         (Speed                         ),
.Gtx_clk                       (Gtx_clk                       ),
.Rx_clk                        (Rx_clk                        ),
.Tx_clk                        (Tx_clk                        ),
.MAC_tx_clk                    (MAC_tx_clk                    ),
.MAC_rx_clk                    (MAC_rx_clk                    ),
.MAC_tx_clk_div                (MAC_tx_clk_div                ),
.MAC_rx_clk_div                (MAC_rx_clk_div                ));



eth_miim U_eth_miim (
.Clk                           (Clk_reg                       ),
.Reset                         (!ResetB                       ),
.Divider                       (Divider                       ),
.CtrlData                      (CtrlData                      ),
.Rgad                          (Rgad                          ),
.Fiad                          (Fiad                          ),
.NoPre                         (NoPre                         ),
.WCtrlData                     (WCtrlData                     ),
.RStat                         (RStat                         ),
.ScanStat                      (ScanStat                      ),
.Mdo                           (Mdo                           ),
.MdoEn                         (MdoEn                         ),
.Mdi                           (Mdi                           ),
.Mdc                           (Mdc                           ),
.Busy                          (Busy                          ),
.LinkFail                      (LinkFail                      ),
.Nvalid                        (Nvalid                        ),
.Prsd                          (Prsd                          ),
.WCtrlDataStart                (WCtrlDataStart                ),
.RStatStart                    (RStatStart                    ),
.UpdateMIIRX_DATAReg           (UpdateMIIRX_DATAReg           ));




Reg_int U_Reg_int (
.S_AXI_araddr                  (S_AXI_araddr                  ),
.S_AXI_arready                 (S_AXI_arready                 ),
.S_AXI_arvalid                 (S_AXI_arvalid                 ),
.S_AXI_awaddr                  (S_AXI_awaddr                  ),
.S_AXI_awready                 (S_AXI_awready                 ),
.S_AXI_awvalid                 (S_AXI_awvalid                 ),
.S_AXI_bready                  (S_AXI_bready                  ),
.S_AXI_bresp                   (S_AXI_bresp                   ),
.S_AXI_bvalid                  (S_AXI_bvalid                  ),
.S_AXI_rdata                   (S_AXI_rdata                   ),
.S_AXI_rready                  (S_AXI_rready                  ),
.S_AXI_rresp                   (S_AXI_rresp                   ),
.S_AXI_rvalid                  (S_AXI_rvalid                  ),
.S_AXI_wdata                   (S_AXI_wdata                   ),
.S_AXI_wready                  (S_AXI_wready                  ),
.S_AXI_wvalid                  (S_AXI_wvalid                  ),
.aclk                          (Clk_reg                       ),
.Reset                         (!ResetB                       ),
.Tx_Hwmark                     (Tx_Hwmark                     ),
.Tx_Lwmark                     (Tx_Lwmark                     ),
.pause_frame_send_en           (pause_frame_send_en           ),
.pause_quanta_set              (pause_quanta_set              ),
.MAC_tx_add_en                 (MAC_tx_add_en                 ),
.FullDuplex                    (FullDuplex                    ),
.MaxRetry                      (MaxRetry                      ),
.IFGset                        (IFGset                        ),
.MAC_tx_add_prom_data          (MAC_tx_add_prom_data          ),
.MAC_tx_add_prom_add           (MAC_tx_add_prom_add           ),
.MAC_tx_add_prom_wr            (MAC_tx_add_prom_wr            ),
.tx_pause_en                   (tx_pause_en                   ),
.xoff_cpu                      (xoff_cpu                      ),
.xon_cpu                       (xon_cpu                       ),
.MAC_rx_add_chk_en             (MAC_rx_add_chk_en             ),
.MAC_rx_add_prom_data          (MAC_rx_add_prom_data          ),
.MAC_rx_add_prom_add           (MAC_rx_add_prom_add           ),
.MAC_rx_add_prom_wr            (MAC_rx_add_prom_wr            ),
.broadcast_filter_en           (broadcast_filter_en           ),
.broadcast_bucket_depth        (broadcast_bucket_depth        ),
.broadcast_bucket_interval     (broadcast_bucket_interval     ),
.RX_APPEND_CRC                 (RX_APPEND_CRC                 ),
.Rx_Hwmark                     (Rx_Hwmark                     ),
.Rx_Lwmark                     (Rx_Lwmark                     ),
.CRC_chk_en                    (CRC_chk_en                    ),
.RX_IFG_SET                    (RX_IFG_SET                    ),
.RX_MAX_LENGTH                 (RX_MAX_LENGTH                 ),
.RX_MIN_LENGTH                 (RX_MIN_LENGTH                 ),
.CPU_rd_addr                   (CPU_rd_addr                   ),
.CPU_rd_apply                  (CPU_rd_apply                  ),
.CPU_rd_grant                  (CPU_rd_grant                  ),
.CPU_rd_dout                   (CPU_rd_dout                   ),
.Line_loop_en                  (Line_loop_en                  ),
.Speed                         (Speed                         ),
.Divider                       (Divider                       ),
.CtrlData                      (CtrlData                      ),
.Rgad                          (Rgad                          ),
.Fiad                          (Fiad                          ),
.NoPre                         (NoPre                         ),
.WCtrlData                     (WCtrlData                     ),
.RStat                         (RStat                         ),
.ScanStat                      (ScanStat                      ),
.Busy                          (Busy                          ),
.LinkFail                      (LinkFail                      ),
.Nvalid                        (Nvalid                        ),
.Prsd                          (Prsd                          ),
.WCtrlDataStart                (WCtrlDataStart                ),
.RStatStart                    (RStatStart                    ),
.UpdateMIIRX_DATAReg           (UpdateMIIRX_DATAReg           ));



endmodule
