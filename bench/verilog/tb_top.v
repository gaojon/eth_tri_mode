//******************************************************************************
//verilog file is created by Jon 
//******************************************************************************
module tb_top ( 
Mdo                           ,
MdoEn                         ,
Mdi                           ,
Mdc                           );
output                                Mdo                           ;// MII Management Data Output
output                                MdoEn                         ;// MII Management Data Output Enable
input                                 Mdi                           ;
output                                Mdc                           ;// MII Management Data Clock
//******************************************************************************
//internal signals specification 						
//******************************************************************************


wire                                  Reset                         ;
wire                                  Clk_user                      ;
wire                                  Clk_reg                       ;
wire                                  Clk_125M                      ;
wire                                  Gtx_clk                       ;//used only in GMII mode
wire                                  Rx_clk                        ;
wire                                  Tx_clk                        ;//used only in MII mode
wire                                  Tx_er                         ;
wire                                  Tx_en                         ;
wire    [7:0]                         Txd                           ;
wire                                  Rx_er                         ;
wire                                  Rx_dv                         ;
wire    [7:0]                         Rxd                           ;
wire                                  Crs                           ;
wire                                  Col                           ;
wire    [2:0]                         Speed                         ;
wire    [31:0]                        M_AXIS_tdata                  ;
wire                                  M_AXIS_tdest                  ;
wire                                  M_AXIS_tid                    ;
wire                                  M_AXIS_tlast                  ;
wire                                  M_AXIS_tready                 ;
wire    [3:0]                         M_AXIS_tstrb                  ;
wire                                  M_AXIS_tvalid                 ;
wire                                  S_AXIS_tready                 ;
wire                                  S_AXIS_tvalid                 ;
wire    [31:0]                        S_AXIS_tdata                  ;
wire    [3:0]                         S_AXIS_tstrb                  ;
wire                                  S_AXIS_tlast                  ;
wire                                  S_AXIS_tdest                  ;
wire                                  S_AXIS_tid                    ;
wire    [31:0]                        S_AXI_araddr                  ;
wire                                  S_AXI_arready                 ;
wire                                  S_AXI_arvalid                 ;
wire    [31:0]                        S_AXI_awaddr                  ;
wire                                  S_AXI_awready                 ;
wire                                  S_AXI_awvalid                 ;
wire                                  S_AXI_bready                  ;
wire    [1:0]                         S_AXI_bresp                   ;
wire                                  S_AXI_bvalid                  ;
wire    [31:0]                        S_AXI_rdata                   ;
wire                                  S_AXI_rready                  ;
wire    [1:0]                         S_AXI_rresp                   ;
wire                                  S_AXI_rvalid                  ;
wire    [31:0]                        S_AXI_wdata                   ;
wire                                  S_AXI_wready                  ;
wire                                  S_AXI_wvalid                  ;
wire                                  CPU_init_end                  ;
//external signals with reg specification						
//******************************************************************************
//internal logical specification 						
//******************************************************************************


rst_clk_gen U_rst_clk_gen (
.Reset                         (Reset                         ),
.Clk_125M                      (Clk_125M                      ),
.Clk_user                      (Clk_user                      ),
.Clk_reg                       (Clk_reg                       ));


MAC_top U_MAC_top (
.Speed                         (Speed                         ),
.Reset                         (Reset                         ),
.Clk_user                      (Clk_user                      ),
.M_AXIS_tdata                  (M_AXIS_tdata                  ),
.M_AXIS_tdest                  (M_AXIS_tdest                  ),
.M_AXIS_tid                    (M_AXIS_tid                    ),
.M_AXIS_tlast                  (M_AXIS_tlast                  ),
.M_AXIS_tready                 (M_AXIS_tready                 ),
.M_AXIS_tstrb                  (M_AXIS_tstrb                  ),
.M_AXIS_tvalid                 (M_AXIS_tvalid                 ),
.S_AXIS_tready                 (S_AXIS_tready                 ),
.S_AXIS_tvalid                 (S_AXIS_tvalid                 ),
.S_AXIS_tdata                  (S_AXIS_tdata                  ),
.S_AXIS_tstrb                  (S_AXIS_tstrb                  ),
.S_AXIS_tlast                  (S_AXIS_tlast                  ),
.S_AXIS_tdest                  (S_AXIS_tdest                  ),
.S_AXIS_tid                    (S_AXIS_tid                    ),
.Clk_reg                       (Clk_reg                       ),
.Tx_er                         (Tx_er                         ),
.Tx_en                         (Tx_en                         ),
.Txd                           (Txd                           ),
.Rx_er                         (Rx_er                         ),
.Rx_dv                         (Rx_dv                         ),
.Rxd                           (Rxd                           ),
.Crs                           (Crs                           ),
.Col                           (Col                           ),
.Clk_125M                      (Clk_125M                      ),
.Gtx_clk                       (Gtx_clk                       ),
.Rx_clk                        (Rx_clk                        ),
.Tx_clk                        (Tx_clk                        ),
.Mdo                           (Mdo                           ),
.MdoEn                         (MdoEn                         ),
.Mdi                           (Mdi                           ),
.Mdc                           (Mdc                           ),
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
.S_AXI_wvalid                  (S_AXI_wvalid                  ));


Phy_sim U_Phy_sim (
.Gtx_clk                       (Gtx_clk                       ),
.Rx_clk                        (Rx_clk                        ),
.Tx_clk                        (Tx_clk                        ),
.Tx_er                         (Tx_er                         ),
.Tx_en                         (Tx_en                         ),
.Txd                           (Txd                           ),
.Rx_er                         (Rx_er                         ),
.Rx_dv                         (Rx_dv                         ),
.Rxd                           (Rxd                           ),
.Crs                           (Crs                           ),
.Col                           (Col                           ),
.Speed                         (Speed                         ));


User_int_sim U_User_int_sim (
.Reset                         (Reset                         ),
.Clk_user                      (Clk_user                      ),
.CPU_init_end                  (CPU_init_end                  ),
.M_AXIS_tdata                  (M_AXIS_tdata                  ),
.M_AXIS_tdest                  (M_AXIS_tdest                  ),
.M_AXIS_tid                    (M_AXIS_tid                    ),
.M_AXIS_tlast                  (M_AXIS_tlast                  ),
.M_AXIS_tready                 (M_AXIS_tready                 ),
.M_AXIS_tstrb                  (M_AXIS_tstrb                  ),
.M_AXIS_tvalid                 (M_AXIS_tvalid                 ),
.S_AXIS_tready                 (S_AXIS_tready                 ),
.S_AXIS_tvalid                 (S_AXIS_tvalid                 ),
.S_AXIS_tdata                  (S_AXIS_tdata                  ),
.S_AXIS_tstrb                  (S_AXIS_tstrb                  ),
.S_AXIS_tlast                  (S_AXIS_tlast                  ),
.S_AXIS_tdest                  (S_AXIS_tdest                  ),
.S_AXIS_tid                    (S_AXIS_tid                    ));


host_sim U_host_sim (
.Clk_reg                       (Clk_reg                       ),
.Reset                         (Reset                         ),
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
.CPU_init_end                  (CPU_init_end                  ));


endmodule
