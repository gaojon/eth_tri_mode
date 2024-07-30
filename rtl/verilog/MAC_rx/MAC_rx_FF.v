`include "header.v"                                     

module MAC_rx_FF (
Reset       ,                                                                                                                                             
Clk_MAC     ,                                                                                                                                             
Clk_SYS     ,                                                                                                                                             
//MAC_rx_ctrl interface                                                                                                                                          
Fifo_data       ,                                                                                                                                         
Fifo_data_en    ,                                                                                                                                         
Fifo_full       ,                                                                                                                                         
Fifo_data_err   ,                                                                                                                                         
Fifo_data_end   ,   
//CPU
Rx_Hwmark,
Rx_Lwmark,
RX_APPEND_CRC,                                                                                                                                      
//user interface      
M_AXIS_tdata	,	
M_AXIS_tdest    ,  	
M_AXIS_tid      ,  	
M_AXIS_tlast    ,  	
M_AXIS_tready   ,  	
M_AXIS_tstrb    ,  	
M_AXIS_tvalid                                                                                                                            
);
input           Reset       ;
input           Clk_MAC     ;
input           Clk_SYS     ;
                //MAC_rx_ctrl interface 
input   [7:0]   Fifo_data       ;
input           Fifo_data_en    ;
output          Fifo_full       ;
input           Fifo_data_err   ;
input           Fifo_data_end   ;
                //CPU
input           RX_APPEND_CRC       ;
input   [4:0]   Rx_Hwmark           ;
input   [4:0]   Rx_Lwmark           ;
                //user interface 
output [31:0]	M_AXIS_tdata		;
output 			M_AXIS_tdest      	;
output 			M_AXIS_tid        	;
output 			M_AXIS_tlast      	;
input 			M_AXIS_tready     	;
output 	[3:0]	M_AXIS_tstrb      	;
output 			M_AXIS_tvalid     	;

//******************************************************************************
//internal signals                                                              
//******************************************************************************
parameter       State_byte3     =4'd0;      
parameter       State_byte2     =4'd1;
parameter       State_byte1     =4'd2;      
parameter       State_byte0     =4'd3;
parameter       State_be0       =4'd4;
parameter       State_be3       =4'd5;
parameter       State_be2       =4'd6;
parameter       State_be1       =4'd7;
parameter       State_err_end   =4'd8;
parameter       State_idle      =4'd9;

parameter       SYS_read        =3'd0;
parameter       SYS_pause       =3'd1;
parameter       SYS_pre   		=3'd2;
parameter       SYS_idle        =3'd3;
parameter       SYS_lag	    	=3'd5;
parameter       FF_emtpy_err    =3'd6;

reg [`MAC_RX_FF_DEPTH-1:0]       Add_wr;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_wr_ungray;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_wr_gray;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_wr_gray_dl1;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_wr_reg;

reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd_pl1;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd_gray;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd_gray_dl1;
reg [`MAC_RX_FF_DEPTH-1:0]       Add_rd_ungray;
reg [35:0]      Din;
reg [35:0]      Din_tmp;
reg [35:0]      Din_tmp_reg;
wire[35:0]      Dout;
reg             Wr_en;
reg             Wr_en_tmp;
reg             Wr_en_ptr;
wire[`MAC_RX_FF_DEPTH-1:0]       Add_wr_pluse;
wire[`MAC_RX_FF_DEPTH-1:0]       Add_wr_pluse4;
wire[`MAC_RX_FF_DEPTH-1:0]       Add_wr_pluse3;
wire[`MAC_RX_FF_DEPTH-1:0]       Add_wr_pluse2;

wire             Empty /* synthesis syn_keep=1 */;
reg [3:0]       Current_state /* synthesis syn_keep=1 */;
reg [3:0]       Next_state;
reg [7:0]       Fifo_data_byte0;
reg [7:0]       Fifo_data_byte1;
reg [7:0]       Fifo_data_byte2;
reg [7:0]       Fifo_data_byte3;
reg             Fifo_data_en_dl1;
reg [7:0]       Fifo_data_dl1;

reg             Rx_mac_sop  ;
reg             Rx_mac_ra   ;
reg             Rx_mac_pa   ;


reg 	[3:0]	M_AXIS_tstrb      	;
reg 			M_AXIS_tvalid     	;


reg [2:0]       Current_state_SYS /* synthesis syn_keep=1 */;
reg [2:0]       Next_state_SYS ;
reg [5:0]       Packet_number_inFF /* synthesis syn_keep=1 */;
reg             Packet_number_sub ;
wire            Packet_number_add_edge;
reg             Packet_number_add_dl1;
reg             Packet_number_add_dl2;
reg             Packet_number_add ;
reg             Packet_number_add_tmp    ;
reg             Packet_number_add_tmp_dl1;
reg             Packet_number_add_tmp_dl2;

reg             Rx_mac_sop_tmp_dl1;

wire [4:0]       Fifo_data_count;
reg             Add_wr_jump_tmp     ;
reg             Add_wr_jump_tmp_pl1 ;
reg             Add_wr_jump         ;
reg             Add_wr_jump_rd_pl1  ;
reg [4:0]       Rx_Hwmark_pl        ;
reg [4:0]       Rx_Lwmark_pl        ;
reg             Addr_freshed_ptr    ;
integer         i                   ;
//******************************************************************************
//domain Clk_MAC,write data to dprom.a-port for write
//******************************************************************************    
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Current_state   <=State_idle;
    else
        Current_state   <=Next_state;
        
always @(Current_state or Fifo_data_en or Fifo_data_err or Fifo_data_end)
    case (Current_state)
        State_idle:
                if (Fifo_data_en)
                    Next_state  =State_byte3;
                else
                    Next_state  =Current_state;                 
        State_byte3:
                if (Fifo_data_en)
                    Next_state  =State_byte2;
                else if (Fifo_data_err)
                    Next_state  =State_err_end;
                else if (Fifo_data_end)
                    Next_state  =State_be1; 
                else
                    Next_state  =Current_state;                 
        State_byte2:
                if (Fifo_data_en)
                    Next_state  =State_byte1;
                else if (Fifo_data_err)
                    Next_state  =State_err_end;
                else if (Fifo_data_end)
                    Next_state  =State_be2; 
                else
                    Next_state  =Current_state;         
        State_byte1:
                if (Fifo_data_en)
                    Next_state  =State_byte0;
                else if (Fifo_data_err)
                    Next_state  =State_err_end;
                else if (Fifo_data_end)
                    Next_state  =State_be3; 
                else
                    Next_state  =Current_state;         
        State_byte0:
                if (Fifo_data_en)
                    Next_state  =State_byte3;
                else if (Fifo_data_err)
                    Next_state  =State_err_end;
                else if (Fifo_data_end)
                    Next_state  =State_be0; 
                else
                    Next_state  =Current_state; 
        State_be1:
                Next_state      =State_idle;
        State_be2:
                Next_state      =State_idle;
        State_be3:
                Next_state      =State_idle;
        State_be0:
                Next_state      =State_idle;
        State_err_end:
                Next_state      =State_idle;
        default:
                Next_state      =State_idle;                
    endcase


                    


always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Fifo_data_en_dl1    <=0;
    else 
        Fifo_data_en_dl1    <=Fifo_data_en;
        
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Fifo_data_dl1   <=0;
    else 
        Fifo_data_dl1   <=Fifo_data;
        
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Fifo_data_byte3     <=0;
    else if (Current_state==State_byte3&&Fifo_data_en_dl1)
        Fifo_data_byte3     <=Fifo_data_dl1;

always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Fifo_data_byte2     <=0;
    else if (Current_state==State_byte2&&Fifo_data_en_dl1)
        Fifo_data_byte2     <=Fifo_data_dl1;
        
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Fifo_data_byte1     <=0;
    else if (Current_state==State_byte1&&Fifo_data_en_dl1)
        Fifo_data_byte1     <=Fifo_data_dl1;

always @ (* )
    case (Current_state)
        State_be0:
            Din_tmp ={4'b1000,Fifo_data_byte3,Fifo_data_byte2,Fifo_data_byte1,Fifo_data_dl1};       
        State_be1:
            Din_tmp ={4'b1001,Fifo_data_byte3,24'h0};
        State_be2:
            Din_tmp ={4'b1010,Fifo_data_byte3,Fifo_data_byte2,16'h0};
        State_be3:
            Din_tmp ={4'b1011,Fifo_data_byte3,Fifo_data_byte2,Fifo_data_byte1,8'h0};
		State_err_end:
			Din_tmp ={4'b1000,32'h0};
        default:
            Din_tmp ={4'b0000,Fifo_data_byte3,Fifo_data_byte2,Fifo_data_byte1,Fifo_data_dl1};
    endcase
    
always @ (*)
    if (Current_state==State_be0||Current_state==State_be1||
       Current_state==State_be2||Current_state==State_be3||Current_state==State_err_end||
      (Current_state==State_byte0&&Fifo_data_en))
        Wr_en_tmp   =1;
    else 
        Wr_en_tmp   =0; 

always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Din_tmp_reg <=0;
    else if(Wr_en_tmp)
        Din_tmp_reg <=Din_tmp;  
        
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Wr_en_ptr   <=0;
    else if(Current_state==State_idle)
        Wr_en_ptr   <=0;    
    else if(Wr_en_tmp)
        Wr_en_ptr   <=1;

//if not append FCS,delay one cycle write data and Wr_en signal to drop FCS
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        begin
        Wr_en           <=0;
        Din             <=0;
        end
    else if(RX_APPEND_CRC)
        begin
        Wr_en           <=Wr_en_tmp;
        Din             <=Din_tmp;
        end         
    else
        begin
        Wr_en           <=Wr_en_tmp&&Wr_en_ptr;
        Din             <={Din_tmp[35:32],Din_tmp_reg[31:0]};
        end                                 
        
//this signal for read side to handle the packet number in fifo
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Packet_number_add_tmp   <=0;
    else if (Current_state==State_be0||Current_state==State_be1||
             Current_state==State_be2||Current_state==State_be3||Current_state==State_err_end)
        Packet_number_add_tmp   <=1;
    else 
        Packet_number_add_tmp   <=0;
        
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        begin
        Packet_number_add_tmp_dl1   <=0;
        Packet_number_add_tmp_dl2   <=0;
        end
    else
        begin
        Packet_number_add_tmp_dl1   <=Packet_number_add_tmp;
        Packet_number_add_tmp_dl2   <=Packet_number_add_tmp_dl1;
        end     
        
//Packet_number_add delay to Din[35] is needed to make sure the data have been wroten to ram.       
//expand to two cycles long almost=16 ns
//if the Clk_SYS period less than 16 ns ,this signal need to expand to 3 or more clock cycles       
always @ (posedge Clk_MAC or posedge Reset)
    if (Reset)
        Packet_number_add   <=0;
    else if (Packet_number_add_tmp_dl1||Packet_number_add_tmp_dl2)
        Packet_number_add   <=1;
    else 
        Packet_number_add   <=0;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
//******************************************************************************
//domain Clk_SYS,read data from dprom.b-port for read
//******************************************************************************
reg 	[3:0]	state_counter	;
wire			data_valid		;
reg				fifo_rd			;

always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
		state_counter <=0;
	else if (Current_state_SYS==Next_state_SYS)
		state_counter <=state_counter + 1'b1;
	else	
		state_counter <=0;

always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Current_state_SYS   <=SYS_idle;
    else 
        Current_state_SYS   <=Next_state_SYS;
        
always @ (*)
    case (Current_state_SYS)
        SYS_idle:
			if (M_AXIS_tready&&Rx_mac_ra&&!Empty)
                Next_state_SYS  =SYS_read;
		    else if(M_AXIS_tready&&Rx_mac_ra&&Empty)
		        Next_state_SYS	=FF_emtpy_err;
            else
                Next_state_SYS  =Current_state_SYS;
        SYS_read:
            if (Dout[35])                
                Next_state_SYS  =SYS_idle;
            else if (Empty)
                Next_state_SYS  =FF_emtpy_err;
            else
                Next_state_SYS  =Current_state_SYS;
        FF_emtpy_err:
            if (!Empty)
                Next_state_SYS  =SYS_read;
            else
                Next_state_SYS  =Current_state_SYS;  
        default:
                Next_state_SYS  =SYS_idle;
    endcase
    
        
//gen Rx_mac_ra 
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        begin
        Packet_number_add_dl1   <=0;
        Packet_number_add_dl2   <=0;
        end
    else 
        begin
        Packet_number_add_dl1   <=Packet_number_add;
        Packet_number_add_dl2   <=Packet_number_add_dl1;
        end
assign  Packet_number_add_edge=Packet_number_add_dl1&!Packet_number_add_dl2;

always @ (Current_state_SYS or Next_state_SYS)
    if (Current_state_SYS==SYS_read&&Next_state_SYS==SYS_idle)
        Packet_number_sub       =1;
    else
        Packet_number_sub       =0;
        
always @ (posedge Clk_SYS or posedge Reset)
    if (Reset)
        Packet_number_inFF      <=0;
    else if (Packet_number_add_edge&&!Packet_number_sub)
        Packet_number_inFF      <=Packet_number_inFF + 1;
	else if (!Packet_number_add_edge&&Packet_number_sub&&Packet_number_inFF!=0)
        Packet_number_inFF      <=Packet_number_inFF - 1;



always @ (posedge Clk_SYS or posedge Reset)                                                         
    if (Reset) 
        begin
        Rx_Hwmark_pl        <=0;
        Rx_Lwmark_pl        <=0;
        end
    else
        begin
        Rx_Hwmark_pl        <=Rx_Hwmark;
        Rx_Lwmark_pl        <=Rx_Lwmark;
        end   
        
always @ (*)
    if (Packet_number_inFF==0&&Fifo_data_count<=Rx_Lwmark_pl)
        Rx_mac_ra   =1'b0;
    else 
        Rx_mac_ra   =1'b1;


 
 always @ (*)
    if (Current_state_SYS==SYS_read&&M_AXIS_tready)  
		fifo_rd		=1'b1;
	else
		fifo_rd		=1'b0;
		
     

assign  M_AXIS_tdata     =Dout[31:0];
assign  M_AXIS_tlast     =Dout[35];

always @ (*)
	case (Dout[33:32])
		2'b00:	M_AXIS_tstrb =4'b1111;
		2'b01:	M_AXIS_tstrb =4'b1000;
		2'b10:	M_AXIS_tstrb =4'b1100;
		2'b11:	M_AXIS_tstrb =4'b1110;
		default:M_AXIS_tstrb =4'b1111;
	endcase
		


always @ (*) 
    if (Current_state_SYS==SYS_read)
        M_AXIS_tvalid   =data_valid;
    else 
        M_AXIS_tvalid   =1'b0;
 

assign 			M_AXIS_tdest      	=1'b0;
assign 			M_AXIS_tid        	=1'b0; 

    


//******************************************************************************

xpm_afifo #(36,`MAC_RX_FF_DEPTH) u_xpm_afifo (
.data_valid				(data_valid			),
.dout			        (Dout               ),
.empty			        (Empty              ),
.almost_full            (Fifo_full          ),
.full			        (                   ),
.overflow		        (                   ),
.rd_rst_busy	        (                   ),
.underflow		        (                   ),
.wr_ack			        (                   ),
.din				    (Din                ),
.rd_clk			        (Clk_SYS            ),
.rd_en			        (fifo_rd            ),
.rst				    (1'b0               ),
.wr_clk			        (Clk_MAC            ),
.rd_data_count			(Fifo_data_count	),
.wr_en                  (Wr_en              )
);


endmodule





