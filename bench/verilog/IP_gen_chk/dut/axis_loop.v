`timescale 1ns/ 1ns

module axis_loop (
output [31:0]	M_AXIS_0_tdata		,
output [0:0]	M_AXIS_0_tdest      ,
output [0:0]	M_AXIS_0_tid        ,
output [0:0]	M_AXIS_0_tlast      ,
input [0:0]		M_AXIS_0_tready     ,
output [3:0]	M_AXIS_0_tstrb      ,
output [0:0]	M_AXIS_0_tvalid     ,
input [31:0]	S_AXIS_0_tdata      ,
input [0:0]		S_AXIS_0_tdest      ,
input [0:0]		S_AXIS_0_tid        ,
input [0:0]		S_AXIS_0_tlast      ,
output [0:0]	S_AXIS_0_tready     ,
input [3:0]		S_AXIS_0_tstrb      ,
input [0:0]		S_AXIS_0_tvalid     ,
input 			aclk_0              ,
input 			aresetn_0
	
);

assign M_AXIS_0_tdata		=S_AXIS_0_tdata		;
assign M_AXIS_0_tdest       =S_AXIS_0_tdest 	;
assign M_AXIS_0_tid         =S_AXIS_0_tid   	;
assign M_AXIS_0_tlast	    =S_AXIS_0_tlast 	;
assign M_AXIS_0_tstrb 		=S_AXIS_0_tstrb 	;
assign M_AXIS_0_tvalid      =S_AXIS_0_tvalid	;
	
assign S_AXIS_0_tready		=M_AXIS_0_tready	;

endmodule