`include "ip_packet_gen.sv"
`include "ip_packet_chk.sv"

module User_int_sim (
input								 Reset			   ,		
input								 Clk_user		   ,
input								 CPU_init_end      ,
//user inputerface      ,
input  [31:0]                        M_AXIS_tdata      ,
input                                M_AXIS_tdest      ,
input                                M_AXIS_tid        ,
input                                M_AXIS_tlast      ,
output reg                           M_AXIS_tready     ,
input  [3:0]                         M_AXIS_tstrb      ,
input                                M_AXIS_tvalid     ,
	
input                                S_AXIS_tready     ,
output  reg                          S_AXIS_tvalid     ,
output  reg [31:0]                   S_AXIS_tdata      ,
output  reg [3:0]                    S_AXIS_tstrb      ,
output  reg                          S_AXIS_tlast      ,
output                               S_AXIS_tdest      ,
output                               S_AXIS_tid        

);
	
IP_packet_gen 	packet_gen;
IP_packet_chk 	packet_chk;

assign S_AXIS_tdest  =0;
assign S_AXIS_tid    =0;
	
	
	
initial begin
	packet_gen = new("../data/config.ini");
	packet_chk = new();
end
	
always @ (posedge Reset or posedge Clk_user)
	if (Reset)
		begin
		S_AXIS_tdata	<=32'b0;
		S_AXIS_tlast	<=1'b0;
		S_AXIS_tstrb	<=4'b0;
		S_AXIS_tvalid	<=1'b0;
		end			
	else if (S_AXIS_tready&&CPU_init_end)
		begin
		packet_gen.rd_data32(S_AXIS_tdata,S_AXIS_tstrb,S_AXIS_tlast,S_AXIS_tvalid);
		end
//	else
//		begin
//		S_AXIS_tdata	<=32'b0;
//		S_AXIS_tlast	<=1'b0;
//		S_AXIS_tstrb	<=4'b0;
//		S_AXIS_tvalid	<=1'b0;
//		end

always @ (posedge Reset or posedge Clk_user)
	if (Reset)
		M_AXIS_tready	<=1'b0;
	else if (CPU_init_end)
		M_AXIS_tready <=1'b1;
		
		
			
always @ (posedge Clk_user)
	if (M_AXIS_tvalid&&M_AXIS_tready)
		packet_chk.wr_data32(M_AXIS_tdata,M_AXIS_tstrb,M_AXIS_tlast);
	

	

				
endmodule
						