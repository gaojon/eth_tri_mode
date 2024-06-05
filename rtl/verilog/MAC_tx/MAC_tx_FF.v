                                      

module MAC_tx_FF ( 
Reset               ,      
Clk_MAC             ,            
Clk_SYS             ,            
//MAC_rx_ctrl interface    
Fifo_data           ,
Fifo_rd             ,
Fifo_rd_finish      ,
Fifo_rd_retry       ,
Fifo_eop            ,
Fifo_da             ,
Fifo_ra             ,
Fifo_data_err_empty ,
Fifo_data_err_full  ,
//user interface          
S_AXIS_tready        ,
S_AXIS_tvalid        ,
S_AXIS_tdata         ,
S_AXIS_tstrb         ,
S_AXIS_tlast         ,
S_AXIS_tdest		 ,
S_AXIS_tid			 ,
//host interface   
FullDuplex          ,
Tx_Hwmark           ,         
Tx_Lwmark           

);
input           Reset               ;
input           Clk_MAC             ;
input           Clk_SYS             ;
                //MAC_tx_ctrl
output  [7:0]   Fifo_data           ;
input           Fifo_rd             ;
input           Fifo_rd_finish      ;
input           Fifo_rd_retry       ;
output          Fifo_eop            ;
output          Fifo_da             ;
output          Fifo_ra             ;
output          Fifo_data_err_empty ;
output          Fifo_data_err_full  ;
                //user interface 
output          S_AXIS_tready       ;
input           S_AXIS_tvalid       ;
input   [31:0]  S_AXIS_tdata        ;
input [3:0]		S_AXIS_tstrb      	;
input           S_AXIS_tlast        ;
	
input 			S_AXIS_tdest      	;
input 			S_AXIS_tid        	;

                //host interface 
input           FullDuplex          ;
input   [4:0]   Tx_Hwmark           ;
input   [4:0]   Tx_Lwmark           ;
//******************************************************************************
//internal signals                                                              
//******************************************************************************
parameter       MAC_byte3               =4'd00;     
parameter       MAC_byte2               =4'd01;
parameter       MAC_byte1               =4'd02; 
parameter       MAC_byte0               =4'd03; 
parameter       MAC_wait_finish         =4'd04;
parameter       MAC_retry               =4'd08;
parameter       MAC_idle                =4'd09;
parameter       MAC_FFEmpty             =4'd10;
parameter       MAC_FFEmpty_drop        =4'd11;
parameter       MAC_pkt_sub             =4'd12;
parameter       MAC_FF_Err              =4'd13;


reg [3:0]       Current_state_MAC           /* synthesis syn_preserve =1 */ ;   
reg [3:0]       Current_state_MAC_reg       /* synthesis syn_preserve =1 */ ;     
reg [3:0]       Next_state_MAC              ;


parameter       SYS_idle                =4'd0;
parameter       SYS_WaitSop             =4'd1;
parameter       SYS_SOP                 =4'd2;
parameter       SYS_MOP                 =4'd3;
parameter       SYS_DROP                =4'd4;
parameter       SYS_EOP_ok              =4'd5;  
parameter       SYS_FFEmpty             =4'd6;         
parameter       SYS_EOP_err             =4'd7;
parameter       SYS_SOP_err             =4'd8;

reg [3:0]       Current_state_SYS   /* synthesis syn_preserve =1 */;
reg [3:0]       Next_state_SYS;

reg [`MAC_RX_FF_DEPTH-1:0]       Add_wr          ;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_wr_ungray   ;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_wr_gray     ;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_wr_gray_dl1 ;
wire[`MAC_RX_FF_DEPTH-1:0]       Add_wr_gray_tmp ;

reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd          ;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd_reg      ;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd_gray     ;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd_gray_dl1 ;
wire[`MAC_RX_FF_DEPTH-1:0]       Add_rd_gray_tmp ;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd_ungray   ;
wire[35:0]      Din             ;
wire[35:0]      Dout            ;
reg             Wr_en           ;
wire[`MAC_RX_FF_DEPTH-1:0]       Add_wr_pluse    ;
wire[`MAC_RX_FF_DEPTH-1:0]       Add_wr_pluse_pluse;
wire[`MAC_RX_FF_DEPTH-1:0]       Add_rd_pluse    ;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd_reg_dl1  ;
reg             Full            /* synthesis syn_keep=1 */;
reg             AlmostFull      /* synthesis syn_keep=1 */;
reg             Empty           /* synthesis syn_keep=1 */;

reg             S_AXIS_tready           ;
reg             S_AXIS_tvalid_dl1           ;
reg [31:0]      S_AXIS_tdata_dl1         ;
reg [1:0]       Tx_mac_BE_dl1           ;

reg             S_AXIS_tlast_dl1          ;
reg             FF_FullErr              ;
wire[1:0]       Dout_BE                 ;
wire            Dout_eop                ;
wire            Dout_err                ;
wire[31:0]      Dout_data               ;     
reg [35:0]      Dout_reg                /* synthesis syn_preserve=1 */;
reg             Packet_number_sub_dl1   ;
reg             Packet_number_sub_dl2   ;
reg             Packet_number_sub_edge  /* synthesis syn_preserve=1 */;
reg             Packet_number_add       /* synthesis syn_preserve=1 */;
reg [4:0]       Fifo_data_count         ;
reg             Fifo_ra                 /* synthesis syn_keep=1 */;
reg [7:0]       Fifo_data               ;
reg             Fifo_da                 ;
reg             Fifo_data_err_empty     /* synthesis syn_preserve=1 */;
reg             Fifo_eop                ;
reg             Fifo_rd_dl1             ;
reg             Fifo_ra_tmp             ;      
reg [5:0]       Packet_number_inFF      /* synthesis syn_keep=1 */;   
reg [5:0]       Packet_number_inFF_reg  /* synthesis syn_preserve=1 */;
reg             Pkt_sub_apply_tmp       ;
reg             Pkt_sub_apply           ;
reg             Add_rd_reg_rdy_tmp      ;
reg             Add_rd_reg_rdy          ;   
reg             Add_rd_reg_rdy_dl1      ;   
reg             Add_rd_reg_rdy_dl2      ;
reg [4:0]       Tx_Hwmark_pl            ;
reg [4:0]       Tx_Lwmark_pl            ;
reg             Add_rd_jump_tmp         ;
reg             Add_rd_jump_tmp_pl1     ;
reg             Add_rd_jump             ;
reg             Add_rd_jump_wr_pl1      ;

integer         i                       ;

reg   [1:0]   	Tx_mac_BE           ;//big endian
reg				Tx_mac_sop			;
//******************************************************************************
//write data to from FF .
//domain Clk_SYS
//******************************************************************************
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Current_state_SYS   <=SYS_idle;
    else
        Current_state_SYS   <=Next_state_SYS;
        
always @ (Current_state_SYS or S_AXIS_tvalid or Tx_mac_sop or Full or AlmostFull 
            or S_AXIS_tlast )
    case (Current_state_SYS)
        SYS_idle:
            if (S_AXIS_tvalid&&Tx_mac_sop&&!Full)
                Next_state_SYS      =SYS_SOP;
            else
                Next_state_SYS      =Current_state_SYS ;
        SYS_SOP:
                Next_state_SYS      =SYS_MOP;
        SYS_MOP:
            if (AlmostFull)
                Next_state_SYS      =SYS_DROP;
            else if (S_AXIS_tvalid&&Tx_mac_sop)
                Next_state_SYS      =SYS_SOP_err;
            else if (S_AXIS_tvalid&&S_AXIS_tlast)
                Next_state_SYS      =SYS_EOP_ok;
            else
                Next_state_SYS      =Current_state_SYS ;
        SYS_EOP_ok:
            if (S_AXIS_tvalid&&Tx_mac_sop)
                Next_state_SYS      =SYS_SOP;
            else
                Next_state_SYS      =SYS_idle;
        SYS_EOP_err:
            if (S_AXIS_tvalid&&Tx_mac_sop)
                Next_state_SYS      =SYS_SOP;
            else
                Next_state_SYS      =SYS_idle;
        SYS_SOP_err:
                Next_state_SYS      =SYS_DROP;
        SYS_DROP: //FIFO overflow           
            if (S_AXIS_tvalid&&S_AXIS_tlast)
                Next_state_SYS      =SYS_EOP_err;
            else 
                Next_state_SYS      =Current_state_SYS ;
        default:
                Next_state_SYS      =SYS_idle;
    endcase
	
always @ (*)
if (Current_state_SYS==SYS_idle&&S_AXIS_tvalid||Current_state_SYS==SYS_EOP_ok&&S_AXIS_tvalid)
		Tx_mac_sop	<=1'b1;
	else 
		Tx_mac_sop	<=1'b0;
    
//delay signals 
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        begin       
        S_AXIS_tvalid_dl1           <=0;
        S_AXIS_tdata_dl1         <=0;
        S_AXIS_tlast_dl1          <=0;
        end  
    else
        begin       
        S_AXIS_tvalid_dl1           <=S_AXIS_tvalid     ;
        S_AXIS_tdata_dl1         <=S_AXIS_tdata   ;
        S_AXIS_tlast_dl1          <=S_AXIS_tlast    ;
        end 
		
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)	
		Tx_mac_BE_dl1           <=0;
	else
		case (S_AXIS_tstrb	)
			4'b1111	:	Tx_mac_BE_dl1 <=2'b00;
			4'b1000	:	Tx_mac_BE_dl1 <=2'b01;
			4'b1100	:	Tx_mac_BE_dl1 <=2'b10;
			4'b1110	:	Tx_mac_BE_dl1 <=2'b11;
			default :	Tx_mac_BE_dl1 <=2'b00;
		endcase
			

always @(Current_state_SYS) 
    if (Current_state_SYS==SYS_EOP_err)
        FF_FullErr      =1;
    else
        FF_FullErr      =0; 

reg     S_AXIS_tlast_gen;

always @(Current_state_SYS) 
    if (Current_state_SYS==SYS_EOP_err||Current_state_SYS==SYS_EOP_ok)
        S_AXIS_tlast_gen      =1;
    else
        S_AXIS_tlast_gen      =0; 
                
assign  Din={S_AXIS_tlast_gen,FF_FullErr,Tx_mac_BE_dl1,S_AXIS_tdata_dl1};

always @(Current_state_SYS or S_AXIS_tvalid_dl1)
    if ((Current_state_SYS==SYS_SOP||Current_state_SYS==SYS_EOP_ok||
        Current_state_SYS==SYS_MOP||Current_state_SYS==SYS_EOP_err)&&S_AXIS_tvalid_dl1)
        Wr_en   = 1;
    else
        Wr_en   = 0;
        
        
//
        
        
always @ (posedge Reset or posedge Clk_SYS)
    if (Reset)
        Add_wr_gray         <=0;
    else 
		begin
		Add_wr_gray[`MAC_RX_FF_DEPTH-1]	<=Add_wr[`MAC_RX_FF_DEPTH-1];
		for (i=`MAC_RX_FF_DEPTH-2;i>=0;i=i-1)
		Add_wr_gray[i]			<=Add_wr[i+1]^Add_wr[i];
		end                             

//

always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Add_rd_gray_dl1         <=0;
    else
        Add_rd_gray_dl1         <=Add_rd_gray;
                    
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Add_rd_jump_wr_pl1  <=0;
    else        
        Add_rd_jump_wr_pl1  <=Add_rd_jump;
                    
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Add_rd_ungray       =0;
    else if (!Add_rd_jump_wr_pl1)       
		begin
		Add_rd_ungray[`MAC_RX_FF_DEPTH-1]	=Add_rd_gray_dl1[`MAC_RX_FF_DEPTH-1];	
		for (i=`MAC_RX_FF_DEPTH-2;i>=0;i=i-1)
			Add_rd_ungray[i]	    =Add_rd_ungray[i+1]^Add_rd_gray_dl1[i];	
		end    
assign          Add_wr_pluse        =Add_wr+1;
assign          Add_wr_pluse_pluse  =Add_wr+4;

always @ (Add_wr_pluse or Add_rd_ungray)
    if (Add_wr_pluse==Add_rd_ungray)
        Full    =1;
    else
        Full    =0;

always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        AlmostFull  <=0;
    else if (Add_wr_pluse_pluse==Add_rd_ungray)
        AlmostFull  <=1;
    else
        AlmostFull  <=0;
        
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Add_wr  <= 0;
    else if (Wr_en&&!Full)
        Add_wr  <= Add_wr +1;
        
        
//
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        begin
        Packet_number_sub_dl1   <=0;
        Packet_number_sub_dl2   <=0;
        end
    else 
        begin
        Packet_number_sub_dl1   <=Pkt_sub_apply;
        Packet_number_sub_dl2   <=Packet_number_sub_dl1;
        end
        
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Packet_number_sub_edge  <=0;
    else if (Packet_number_sub_dl1&!Packet_number_sub_dl2)
        Packet_number_sub_edge  <=1;
    else
        Packet_number_sub_edge  <=0;

always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Packet_number_add       <=0;    
    else if (Current_state_SYS==SYS_EOP_ok||Current_state_SYS==SYS_EOP_err)
        Packet_number_add       <=1;
    else
        Packet_number_add       <=0;    
        

always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Packet_number_inFF      <=0;
    else if (Packet_number_add&&!Packet_number_sub_edge)
        Packet_number_inFF      <=Packet_number_inFF + 1'b1;
    else if (!Packet_number_add&&Packet_number_sub_edge)
        Packet_number_inFF      <=Packet_number_inFF - 1'b1;


always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Packet_number_inFF_reg      <=0;
    else
        Packet_number_inFF_reg      <=Packet_number_inFF;

always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        begin
        Add_rd_reg_rdy_dl1          <=0;
        Add_rd_reg_rdy_dl2          <=0;
        end
    else
        begin
        Add_rd_reg_rdy_dl1          <=Add_rd_reg_rdy;
        Add_rd_reg_rdy_dl2          <=Add_rd_reg_rdy_dl1;
        end     

always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Add_rd_reg_dl1              <=0;
    else if (Add_rd_reg_rdy_dl1&!Add_rd_reg_rdy_dl2)
        Add_rd_reg_dl1              <=Add_rd_reg;



always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Fifo_data_count     <=0;
    else if (FullDuplex)
        Fifo_data_count     <=Add_wr[`MAC_RX_FF_DEPTH-1:`MAC_RX_FF_DEPTH-5]-Add_rd_ungray[`MAC_RX_FF_DEPTH-1:`MAC_RX_FF_DEPTH-5];
    else
        Fifo_data_count     <=Add_wr[`MAC_RX_FF_DEPTH-1:`MAC_RX_FF_DEPTH-5]-Add_rd_reg_dl1[`MAC_RX_FF_DEPTH-1:`MAC_RX_FF_DEPTH-5]; //for half duplex backoff requirement
        

always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Fifo_ra_tmp <=0;    
    else if (Packet_number_inFF_reg>=1||Fifo_data_count>=Tx_Lwmark)
        Fifo_ra_tmp <=1;        
    else 
        Fifo_ra_tmp <=0;

always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        begin 
        Tx_Hwmark_pl        <=0;
        Tx_Lwmark_pl        <=0;    
        end
    else
        begin 
        Tx_Hwmark_pl        <=Tx_Hwmark;
        Tx_Lwmark_pl        <=Tx_Lwmark;    
        end    
    
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        S_AXIS_tready   <=0;  
    else if (Fifo_data_count>=Tx_Hwmark_pl)
        S_AXIS_tready   <=0;
    else if (Fifo_data_count<Tx_Lwmark_pl)
        S_AXIS_tready   <=1;

//******************************************************************************

    
























    
//******************************************************************************
//rd data to from FF .
//domain Clk_MAC
//******************************************************************************
reg[35:0]   Dout_dl1;
reg         Dout_reg_en /* synthesis syn_keep=1 */;

always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Dout_dl1    <=0;
    else
        Dout_dl1    <=Dout;

always @ (Current_state_MAC or Next_state_MAC)
    if ((Current_state_MAC==MAC_idle||Current_state_MAC==MAC_byte0)&&Next_state_MAC==MAC_byte3)
        Dout_reg_en     =1;
    else
        Dout_reg_en     =0; 
            
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Dout_reg        <=0;
    else if (Dout_reg_en)
        Dout_reg    <=Dout_dl1;     
        
assign {Dout_eop,Dout_err,Dout_BE,Dout_data}=Dout_reg;

always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Current_state_MAC   <=MAC_idle;
    else
        Current_state_MAC   <=Next_state_MAC;       
        
always @ (Current_state_MAC or Fifo_rd or Dout_BE or Dout_eop or Fifo_rd_retry
            or Fifo_rd_finish or Empty or Fifo_rd or Fifo_eop)
        case (Current_state_MAC)
            MAC_idle:
                if (Empty&&Fifo_rd)
                    Next_state_MAC=MAC_FF_Err;
                else if (Fifo_rd)
                    Next_state_MAC=MAC_byte3;
                else
                    Next_state_MAC=Current_state_MAC;
            MAC_byte3:
                if (Fifo_rd_retry)
                    Next_state_MAC=MAC_retry;           
                else if (Fifo_eop)
                    Next_state_MAC=MAC_wait_finish;
                else if (Fifo_rd&&!Fifo_eop)
                    Next_state_MAC=MAC_byte2;
                else
                    Next_state_MAC=Current_state_MAC;
            MAC_byte2:
                if (Fifo_rd_retry)
                    Next_state_MAC=MAC_retry;
                else if (Fifo_eop)
                    Next_state_MAC=MAC_wait_finish;
                else if (Fifo_rd&&!Fifo_eop)
                    Next_state_MAC=MAC_byte1;
                else
                    Next_state_MAC=Current_state_MAC;       
            MAC_byte1:
                if (Fifo_rd_retry)
                    Next_state_MAC=MAC_retry;
                else if (Fifo_eop)
                    Next_state_MAC=MAC_wait_finish;
                else if (Fifo_rd&&!Fifo_eop)
                    Next_state_MAC=MAC_byte0;
                else
                    Next_state_MAC=Current_state_MAC;   
            MAC_byte0:
                if (Empty&&Fifo_rd&&!Fifo_eop)
                    Next_state_MAC=MAC_FFEmpty;
                else if (Fifo_rd_retry)
                    Next_state_MAC=MAC_retry;
                else if (Fifo_eop)
                    Next_state_MAC=MAC_wait_finish;     
                else if (Fifo_rd&&!Fifo_eop)
                    Next_state_MAC=MAC_byte3;
                else
                    Next_state_MAC=Current_state_MAC;   
            MAC_retry:
                    Next_state_MAC=MAC_idle;
            MAC_wait_finish:
                if (Fifo_rd_finish)
                    Next_state_MAC=MAC_pkt_sub;
                else
                    Next_state_MAC=Current_state_MAC;
            MAC_pkt_sub:
                    Next_state_MAC=MAC_idle;
            MAC_FFEmpty:
                if (!Empty)
                    Next_state_MAC=MAC_byte3;
                else
                    Next_state_MAC=Current_state_MAC;
            MAC_FF_Err:  //stopped state-machine need change                         
                    Next_state_MAC=Current_state_MAC;
            default
                    Next_state_MAC=MAC_idle;    
        endcase
//
always @ (posedge Reset or posedge Clk_MAC)
    if (Reset)
        Add_rd_gray         <=0;
    else 
		begin
		Add_rd_gray[`MAC_RX_FF_DEPTH-1]	<=Add_rd[`MAC_RX_FF_DEPTH-1];
		for (i=`MAC_RX_FF_DEPTH-2;i>=0;i=i-1)
		Add_rd_gray[i]			<=Add_rd[i+1]^Add_rd[i];
		end
//

always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Add_wr_gray_dl1     <=0;
    else
        Add_wr_gray_dl1     <=Add_wr_gray;
            
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Add_wr_ungray       =0;
    else        
		begin
		Add_wr_ungray[`MAC_RX_FF_DEPTH-1]	=Add_wr_gray_dl1[`MAC_RX_FF_DEPTH-1];	
		for (i=`MAC_RX_FF_DEPTH-2;i>=0;i=i-1)
			Add_wr_ungray[i]	=Add_wr_ungray[i+1]^Add_wr_gray_dl1[i];	
		end                   
//empty     
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)      
        Empty   <=1;
    else if (Add_rd==Add_wr_ungray)
        Empty   <=1;
    else
        Empty   <=0;    
        
//ra
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Fifo_ra <=0;
    else
        Fifo_ra <=Fifo_ra_tmp;



always @ (posedge Clk_MAC or posedge Reset)     
    if (Reset)  
        Pkt_sub_apply_tmp   <=0;
    else if (Current_state_MAC==MAC_pkt_sub)
        Pkt_sub_apply_tmp   <=1;
    else
        Pkt_sub_apply_tmp   <=0;
        
always @ (posedge Clk_MAC or posedge Reset) 
    if (Reset)
        Pkt_sub_apply   <=0;
    else if ((Current_state_MAC==MAC_pkt_sub)||Pkt_sub_apply_tmp)
        Pkt_sub_apply   <=1;
    else                
        Pkt_sub_apply   <=0;

//reg Add_rd for collison retry
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Add_rd_reg      <=0;
    else if (Fifo_rd_finish)
        Add_rd_reg      <=Add_rd;

always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Add_rd_reg_rdy_tmp      <=0;
    else if (Fifo_rd_finish)
        Add_rd_reg_rdy_tmp      <=1;
    else
        Add_rd_reg_rdy_tmp      <=0;
        
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Add_rd_reg_rdy      <=0;
    else if (Fifo_rd_finish||Add_rd_reg_rdy_tmp)
        Add_rd_reg_rdy      <=1;
    else
        Add_rd_reg_rdy      <=0;         
 
reg Add_rd_add /* synthesis syn_keep=1 */;

always @ (Current_state_MAC or Next_state_MAC)
    if ((Current_state_MAC==MAC_idle||Current_state_MAC==MAC_byte0)&&Next_state_MAC==MAC_byte3)
        Add_rd_add  =1;
    else
        Add_rd_add  =0;
        
        
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Add_rd          <=0;
    else if (Current_state_MAC==MAC_retry)
        Add_rd          <= Add_rd_reg;
    else if (Add_rd_add)
        Add_rd          <= Add_rd + 1;  
                    
always @ (posedge Clk_MAC or posedge Reset)
	if (Reset)
	    Add_rd_jump_tmp <=0;
	else if (Current_state_MAC==MAC_retry)
	    Add_rd_jump_tmp <=1;
	else
	    Add_rd_jump_tmp <=0;

always @ (posedge Clk_MAC or posedge Reset)
	if (Reset)
	    Add_rd_jump_tmp_pl1 <=0;
	else
	    Add_rd_jump_tmp_pl1 <=Add_rd_jump_tmp;	 
	    
always @ (posedge Clk_MAC or posedge Reset)
	if (Reset)
	    Add_rd_jump <=0;
	else if (Current_state_MAC==MAC_retry)
	    Add_rd_jump <=1;
	else if (Add_rd_jump_tmp_pl1)
	    Add_rd_jump <=0;	
	    					
//gen Fifo_data 

        
always @ (Dout_data or Current_state_MAC)
    case (Current_state_MAC)
        MAC_byte3:
            Fifo_data   =Dout_data[31:24];
        MAC_byte2:
            Fifo_data   =Dout_data[23:16];
        MAC_byte1:
            Fifo_data   =Dout_data[15:8];
        MAC_byte0:
            Fifo_data   =Dout_data[7:0];
        default:
            Fifo_data   =0;     
    endcase
//gen Fifo_da           
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Fifo_rd_dl1     <=0;
    else
        Fifo_rd_dl1     <=Fifo_rd;
        
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Fifo_da         <=0;
    else if ((Current_state_MAC==MAC_byte0||Current_state_MAC==MAC_byte1||
              Current_state_MAC==MAC_byte2||Current_state_MAC==MAC_byte3)&&Fifo_rd&&!Fifo_eop)
        Fifo_da         <=1;
    else
        Fifo_da         <=0;

//gen Fifo_data_err_empty
assign  Fifo_data_err_full=Dout_err;
//gen Fifo_data_err_empty
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Current_state_MAC_reg   <=0;
    else
        Current_state_MAC_reg   <=Current_state_MAC;
        
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Fifo_data_err_empty     <=0;
    else if (Current_state_MAC_reg==MAC_FFEmpty)
        Fifo_data_err_empty     <=1;
    else
        Fifo_data_err_empty     <=0;
    
always @ (posedge Clk_MAC)
    if (Current_state_MAC_reg==MAC_FF_Err)  
        begin
        $finish(2); 
        $display("mac_tx_FF meet error status at time :%t",$time);
        end

//gen Fifo_eop aligned to last valid data byte��            
always @ (Current_state_MAC or Dout_eop)
    if (((Current_state_MAC==MAC_byte0&&Dout_BE==2'b00||
        Current_state_MAC==MAC_byte1&&Dout_BE==2'b11||
        Current_state_MAC==MAC_byte2&&Dout_BE==2'b10||
        Current_state_MAC==MAC_byte3&&Dout_BE==2'b01)&&Dout_eop))
        Fifo_eop        =1; 
    else
        Fifo_eop        =0;         
//******************************************************************************
//******************************************************************************

duram #(36,`MAC_TX_FF_DEPTH,"auto") U_duram(           
.data_a         (Din        ), 
.wren_a         (Wr_en      ), 
.address_a      (Add_wr     ), 
.wren_b			(1'b0		),
.address_b      (Add_rd     ), 
.clock_a        (Clk_SYS    ), 
.clock_b        (Clk_MAC    ), 
.q_b            (Dout       ));

endmodule