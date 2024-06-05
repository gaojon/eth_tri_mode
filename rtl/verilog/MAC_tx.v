//******************************************************************************
//verilog file is created by Jon 
//******************************************************************************
module MAC_tx ( 
Reset                         ,
Clk                           ,
TxD                           ,
TxEn                          ,
CRS                           ,
Tx_pkt_type_rmon              ,
Tx_pkt_length_rmon            ,
Tx_apply_rmon                 ,
Tx_pkt_err_type_rmon          ,
pause_frame_send_en           ,
pause_quanta_set              ,
MAC_tx_add_en                 ,
FullDuplex                    ,
MaxRetry                      ,
IFGset                        ,
tx_pause_en                   ,
xoff_cpu                      ,
xon_cpu                       ,
pause_quanta                  ,
pause_quanta_val              ,
MAC_add_prom_data             ,
MAC_add_prom_add              ,
MAC_add_prom_wr               ,
Clk_user                      ,
S_AXIS_tready                 ,
S_AXIS_tvalid                 ,
S_AXIS_tdata                  ,
S_AXIS_tstrb                  ,
S_AXIS_tlast                  ,
S_AXIS_tdest                  ,
S_AXIS_tid                    ,
Tx_Hwmark                     ,
Tx_Lwmark                     );
input                                 Reset                         ;
input                                 Clk                           ;
output  [7:0]                         TxD                           ;
output                                TxEn                          ;
input                                 CRS                           ;
output  [2:0]                         Tx_pkt_type_rmon              ;
output  [15:0]                        Tx_pkt_length_rmon            ;
output                                Tx_apply_rmon                 ;
output  [2:0]                         Tx_pkt_err_type_rmon          ;
input                                 pause_frame_send_en           ;
input   [15:0]                        pause_quanta_set              ;
input                                 MAC_tx_add_en                 ;
input                                 FullDuplex                    ;
input   [3:0]                         MaxRetry                      ;
input   [5:0]                         IFGset                        ;
input                                 tx_pause_en                   ;
input                                 xoff_cpu                      ;
input                                 xon_cpu                       ;
input   [15:0]                        pause_quanta                  ;
input                                 pause_quanta_val              ;
input   [7:0]                         MAC_add_prom_data             ;
input   [2:0]                         MAC_add_prom_add              ;
input                                 MAC_add_prom_wr               ;
input                                 Clk_user                      ;
output                                S_AXIS_tready                 ;
input                                 S_AXIS_tvalid                 ;
input   [31:0]                        S_AXIS_tdata                  ;
input   [3:0]                         S_AXIS_tstrb                  ;
input                                 S_AXIS_tlast                  ;
input                                 S_AXIS_tdest                  ;
input                                 S_AXIS_tid                    ;
input   [4:0]                         Tx_Hwmark                     ;
input   [4:0]                         Tx_Lwmark                     ;
//******************************************************************************
//internal signals specification 						
//******************************************************************************
wire                                  CRC_init                      ;
wire    [7:0]                         Frame_data                    ;
wire                                  Data_en                       ;
wire                                  CRC_rd                        ;
wire    [7:0]                         CRC_out                       ;
wire                                  CRC_end                       ;
wire                                  pause_apply                   ;
wire                                  pause_quanta_sub              ;
wire                                  xoff_gen                      ;
wire                                  xoff_gen_complete             ;
wire                                  xon_gen                       ;
wire                                  xon_gen_complete              ;
wire                                  MAC_tx_addr_rd                ;
wire                                  MAC_tx_addr_init              ;
wire    [7:0]                         MAC_tx_addr_data              ;
wire    [7:0]                         Fifo_data                     ;
wire                                  Fifo_rd                       ;
wire                                  Fifo_rd_finish                ;
wire                                  Fifo_rd_retry                 ;
wire                                  Fifo_eop                      ;
wire                                  Fifo_da                       ;
wire                                  Fifo_ra                       ;
wire                                  Fifo_data_err_empty           ;
wire                                  Fifo_data_err_full            ;
wire                                  Random_init                   ;
wire    [3:0]                         RetryCnt                      ;
wire                                  Random_time_meet              ;
//external signals with reg specification						
//******************************************************************************
//internal logical specification 						
//******************************************************************************

MAC_tx_ctrl U_MAC_tx_ctrl (
.Reset                         (Reset                         ),
.Clk                           (Clk                           ),
.CRC_init                      (CRC_init                      ),
.Frame_data                    (Frame_data                    ),
.Data_en                       (Data_en                       ),
.CRC_rd                        (CRC_rd                        ),
.CRC_end                       (CRC_end                       ),
.CRC_out                       (CRC_out                       ),
.Random_init                   (Random_init                   ),
.RetryCnt                      (RetryCnt                      ),
.Random_time_meet              (Random_time_meet              ),
.pause_apply                   (pause_apply                   ),
.pause_quanta_sub              (pause_quanta_sub              ),
.xoff_gen                      (xoff_gen                      ),
.xoff_gen_complete             (xoff_gen_complete             ),
.xon_gen                       (xon_gen                       ),
.xon_gen_complete              (xon_gen_complete              ),
.Fifo_data                     (Fifo_data                     ),
.Fifo_rd                       (Fifo_rd                       ),
.Fifo_eop                      (Fifo_eop                      ),
.Fifo_da                       (Fifo_da                       ),
.Fifo_rd_finish                (Fifo_rd_finish                ),
.Fifo_rd_retry                 (Fifo_rd_retry                 ),
.Fifo_ra                       (Fifo_ra                       ),
.Fifo_data_err_empty           (Fifo_data_err_empty           ),
.Fifo_data_err_full            (Fifo_data_err_full            ),
.TxD                           (TxD                           ),
.TxEn                          (TxEn                          ),
.CRS                           (CRS                           ),
.MAC_tx_addr_init              (MAC_tx_addr_init              ),
.MAC_tx_addr_rd                (MAC_tx_addr_rd                ),
.MAC_tx_addr_data              (MAC_tx_addr_data              ),
.Tx_pkt_type_rmon              (Tx_pkt_type_rmon              ),
.Tx_pkt_length_rmon            (Tx_pkt_length_rmon            ),
.Tx_apply_rmon                 (Tx_apply_rmon                 ),
.Tx_pkt_err_type_rmon          (Tx_pkt_err_type_rmon          ),
.pause_frame_send_en           (pause_frame_send_en           ),
.pause_quanta_set              (pause_quanta_set              ),
.MAC_tx_add_en                 (MAC_tx_add_en                 ),
.FullDuplex                    (FullDuplex                    ),
.MaxRetry                      (MaxRetry                      ),
.IFGset                        (IFGset                        ));


CRC_gen U_CRC_gen (
.Reset                         (Reset                         ),
.Clk                           (Clk                           ),
.Init                          (CRC_init                      ),
.Frame_data                    (Frame_data                    ),
.Data_en                       (Data_en                       ),
.CRC_rd                        (CRC_rd                        ),
.CRC_out                       (CRC_out                       ),
.CRC_end                       (CRC_end                       ));


flow_ctrl U_flow_ctrl (
.Reset                         (Reset                         ),
.Clk                           (Clk                           ),
.tx_pause_en                   (tx_pause_en                   ),
.xoff_cpu                      (xoff_cpu                      ),
.xon_cpu                       (xon_cpu                       ),
.pause_quanta                  (pause_quanta                  ),
.pause_quanta_val              (pause_quanta_val              ),
.pause_apply                   (pause_apply                   ),
.pause_quanta_sub              (pause_quanta_sub              ),
.xoff_gen                      (xoff_gen                      ),
.xoff_gen_complete             (xoff_gen_complete             ),
.xon_gen                       (xon_gen                       ),
.xon_gen_complete              (xon_gen_complete              ));


`ifdef MAC_SOURCE_REPLACE_EN
MAC_tx_addr_add U_MAC_tx_addr_add (
.Reset                         (Reset                         ),
.Clk                           (Clk                           ),
.MAC_tx_addr_rd                (MAC_tx_addr_rd                ),
.MAC_tx_addr_init              (MAC_tx_addr_init              ),
.MAC_tx_addr_data              (MAC_tx_addr_data              ),
.MAC_add_prom_data             (MAC_add_prom_data             ),
.MAC_add_prom_add              (MAC_add_prom_add              ),
.MAC_add_prom_wr               (MAC_add_prom_wr               ));

`else
assign MAC_tx_addr_data     =0;
`endif

MAC_tx_FF U_MAC_tx_FF (
.Reset                         (Reset                         ),
.Clk_MAC                       (Clk                           ),
.Clk_SYS                       (Clk_user                      ),
.Fifo_data                     (Fifo_data                     ),
.Fifo_rd                       (Fifo_rd                       ),
.Fifo_rd_finish                (Fifo_rd_finish                ),
.Fifo_rd_retry                 (Fifo_rd_retry                 ),
.Fifo_eop                      (Fifo_eop                      ),
.Fifo_da                       (Fifo_da                       ),
.Fifo_ra                       (Fifo_ra                       ),
.Fifo_data_err_empty           (Fifo_data_err_empty           ),
.Fifo_data_err_full            (Fifo_data_err_full            ),
.S_AXIS_tready                 (S_AXIS_tready                 ),
.S_AXIS_tvalid                 (S_AXIS_tvalid                 ),
.S_AXIS_tdata                  (S_AXIS_tdata                  ),
.S_AXIS_tstrb                  (S_AXIS_tstrb                  ),
.S_AXIS_tlast                  (S_AXIS_tlast                  ),
.S_AXIS_tdest                  (S_AXIS_tdest                  ),
.S_AXIS_tid                    (S_AXIS_tid                    ),
.FullDuplex                    (FullDuplex                    ),
.Tx_Hwmark                     (Tx_Hwmark                     ),
.Tx_Lwmark                     (Tx_Lwmark                     ));


Ramdon_gen U_Ramdon_gen (
.Reset                         (Reset                         ),
.Clk                           (Clk                           ),
.Init                          (Random_init                   ),
.RetryCnt                      (RetryCnt                      ),
.Random_time_meet              (Random_time_meet              ));


endmodule
