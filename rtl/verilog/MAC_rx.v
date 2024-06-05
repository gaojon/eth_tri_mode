//******************************************************************************
//verilog file is created by Jon 
//******************************************************************************
module MAC_rx ( 
Reset                         ,
Clk                           ,
MCrs_dv                       ,
MRxD                          ,
MRxErr                        ,
pause_quanta                  ,
pause_quanta_val              ,
Rx_pkt_length_rmon            ,
Rx_apply_rmon                 ,
Rx_pkt_err_type_rmon          ,
Rx_pkt_type_rmon              ,
RX_IFG_SET                    ,
RX_MAX_LENGTH                 ,
RX_MIN_LENGTH                 ,
Clk_user                      ,
RX_APPEND_CRC                 ,
Rx_Hwmark                     ,
Rx_Lwmark                     ,
M_AXIS_tdata                  ,
M_AXIS_tdest                  ,
M_AXIS_tid                    ,
M_AXIS_tlast                  ,
M_AXIS_tready                 ,
M_AXIS_tstrb                  ,
M_AXIS_tvalid                 ,
broadcast_filter_en           ,
broadcast_bucket_depth        ,
broadcast_bucket_interval     ,
CRC_chk_en                    ,
MAC_rx_add_chk_en             ,
MAC_add_prom_data             ,
MAC_add_prom_add              ,
MAC_add_prom_wr               );
input                                 Reset                         ;
input                                 Clk                           ;
input                                 MCrs_dv                       ;
input   [7:0]                         MRxD                          ;
input                                 MRxErr                        ;
output  [15:0]                        pause_quanta                  ;
output                                pause_quanta_val              ;
output  [15:0]                        Rx_pkt_length_rmon            ;
output                                Rx_apply_rmon                 ;
output  [2:0]                         Rx_pkt_err_type_rmon          ;
output  [2:0]                         Rx_pkt_type_rmon              ;
input   [5:0]                         RX_IFG_SET                    ;
input   [15:0]                        RX_MAX_LENGTH                 ;// 1518
input   [6:0]                         RX_MIN_LENGTH                 ;// 64
input                                 Clk_user                      ;
input                                 RX_APPEND_CRC                 ;
input   [4:0]                         Rx_Hwmark                     ;
input   [4:0]                         Rx_Lwmark                     ;
output  [31:0]                        M_AXIS_tdata                  ;
output                                M_AXIS_tdest                  ;
output                                M_AXIS_tid                    ;
output                                M_AXIS_tlast                  ;
input                                 M_AXIS_tready                 ;
output  [3:0]                         M_AXIS_tstrb                  ;
output                                M_AXIS_tvalid                 ;
input                                 broadcast_filter_en           ;
input   [15:0]                        broadcast_bucket_depth        ;
input   [15:0]                        broadcast_bucket_interval     ;
input                                 CRC_chk_en                    ;
input                                 MAC_rx_add_chk_en             ;
input   [7:0]                         MAC_add_prom_data             ;
input   [2:0]                         MAC_add_prom_add              ;
input                                 MAC_add_prom_wr               ;
//******************************************************************************
//internal signals specification 						
//******************************************************************************
wire    [7:0]                         Fifo_data                     ;
wire                                  Fifo_data_en                  ;
wire                                  Fifo_full                     ;
wire                                  Fifo_data_err                 ;
wire                                  Fifo_data_end                 ;
wire                                  broadcast_ptr                 ;
wire                                  broadcast_drop                ;
wire                                  CRC_init                      ;
wire                                  CRC_en                        ;
wire                                  CRC_err                       ;
wire                                  MAC_add_en                    ;
wire                                  MAC_rx_add_chk_err            ;
//external signals with reg specification						
//******************************************************************************
//internal logical specification 						
//******************************************************************************



MAC_rx_ctrl U_MAC_rx_ctrl (
.Reset                         (Reset                         ),
.Clk                           (Clk                           ),
.MCrs_dv                       (MCrs_dv                       ),
.MRxD                          (MRxD                          ),
.MRxErr                        (MRxErr                        ),
.CRC_en                        (CRC_en                        ),
.CRC_init                      (CRC_init                      ),
.CRC_err                       (CRC_err                       ),
.MAC_add_en                    (MAC_add_en                    ),
.MAC_rx_add_chk_err            (MAC_rx_add_chk_err            ),
.broadcast_ptr                 (broadcast_ptr                 ),
.broadcast_drop                (broadcast_drop                ),
.pause_quanta                  (pause_quanta                  ),
.pause_quanta_val              (pause_quanta_val              ),
.Fifo_data                     (Fifo_data                     ),
.Fifo_data_en                  (Fifo_data_en                  ),
.Fifo_data_err                 (Fifo_data_err                 ),
.Fifo_data_end                 (Fifo_data_end                 ),
.Fifo_full                     (Fifo_full                     ),
.Rx_pkt_length_rmon            (Rx_pkt_length_rmon            ),
.Rx_apply_rmon                 (Rx_apply_rmon                 ),
.Rx_pkt_err_type_rmon          (Rx_pkt_err_type_rmon          ),
.Rx_pkt_type_rmon              (Rx_pkt_type_rmon              ),
.RX_IFG_SET                    (RX_IFG_SET                    ),
.RX_MAX_LENGTH                 (RX_MAX_LENGTH                 ),
.RX_MIN_LENGTH                 (RX_MIN_LENGTH                 ));



MAC_rx_FF U_MAC_rx_FF (
.Reset                         (Reset                         ),
.Clk_MAC                       (Clk                           ),
.Clk_SYS                       (Clk_user                      ),
.Fifo_data                     (Fifo_data                     ),
.Fifo_data_en                  (Fifo_data_en                  ),
.Fifo_full                     (Fifo_full                     ),
.Fifo_data_err                 (Fifo_data_err                 ),
.Fifo_data_end                 (Fifo_data_end                 ),
.RX_APPEND_CRC                 (RX_APPEND_CRC                 ),
.Rx_Hwmark                     (Rx_Hwmark                     ),
.Rx_Lwmark                     (Rx_Lwmark                     ),
.M_AXIS_tdata                  (M_AXIS_tdata                  ),
.M_AXIS_tdest                  (M_AXIS_tdest                  ),
.M_AXIS_tid                    (M_AXIS_tid                    ),
.M_AXIS_tlast                  (M_AXIS_tlast                  ),
.M_AXIS_tready                 (M_AXIS_tready                 ),
.M_AXIS_tstrb                  (M_AXIS_tstrb                  ),
.M_AXIS_tvalid                 (M_AXIS_tvalid                 ));


`ifdef MAC_BROADCAST_FILTER_EN
Broadcast_filter U_Broadcast_filter (
.Reset                         (Reset                         ),
.Clk                           (Clk                           ),
.broadcast_ptr                 (broadcast_ptr                 ),
.broadcast_drop                (broadcast_drop                ),
.broadcast_filter_en           (broadcast_filter_en           ),
.broadcast_bucket_depth        (broadcast_bucket_depth        ),
.broadcast_bucket_interval     (broadcast_bucket_interval     ));

`else
assign broadcast_drop       =0;

`endif


CRC_chk U_CRC_chk (
.Reset                         (Reset                         ),
.Clk                           (Clk                           ),
.CRC_data                      (Fifo_data                     ),
.CRC_init                      (CRC_init                      ),
.CRC_en                        (CRC_en                        ),
.CRC_chk_en                    (CRC_chk_en                    ),
.CRC_err                       (CRC_err                       ));




`ifdef MAC_TARGET_CHECK_EN

MAC_rx_add_chk U_MAC_rx_add_chk (
.Reset                         (Reset                         ),
.Clk                           (Clk                           ),
.Init                          (CRC_init                      ),
.data                          (Fifo_data                     ),
.MAC_add_en                    (MAC_add_en                    ),
.MAC_rx_add_chk_err            (MAC_rx_add_chk_err            ),
.MAC_rx_add_chk_en             (MAC_rx_add_chk_en             ),
.MAC_add_prom_data             (MAC_add_prom_data             ),
.MAC_add_prom_add              (MAC_add_prom_add              ),
.MAC_add_prom_wr               (MAC_add_prom_wr               ));

`else
assign MAC_rx_add_chk_err   =0;

`endif


endmodule
