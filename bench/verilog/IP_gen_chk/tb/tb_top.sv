`include "ip_packet_gen.sv"
`include "ip_packet_chk.sv"

`timescale 1 ns/ 1 ns

	

module tb_top;
	IP_packet_gen 	packet_gen;
	IP_packet_chk 	packet_chk;
	bit [31:0]		packet_data;
	bit [3:0]		packet_strobe;
	bit				packet_last;
	
	reg				clk;
	reg				rst;
	
	always begin
		#5		clk	= 1'b1;
		#5		clk = 1'b0;
	end
	
	
	initial begin
				rst = 1'b1;
		#100	rst = 1'b0;
	end
	
	initial begin
		clk			= 1'b0;
		
		packet_gen = new("../data/config.ini");
		packet_chk = new();
	
	end
	
	/*
	always begin
		packet_gen.rd_data32(packet_data,packet_strobe,packet_last);
		$display ("data[%02h] = 0x%08h, strobe =0b%04b, last =1b%b", packet_gen.pointer, packet_data, packet_strobe,packet_last);
		packet_chk.wr_data32(packet_data,packet_strobe,packet_last);
	end
	*/
	


	
wire [31:0]		M_AXIS_0_tdata		;
wire [0:0]		M_AXIS_0_tdest      ;
wire [0:0]		M_AXIS_0_tid        ;
wire [0:0]		M_AXIS_0_tlast      ;
reg  [0:0]		M_AXIS_0_tready     ;
wire [3:0]		M_AXIS_0_tstrb      ;
wire [0:0]		M_AXIS_0_tvalid     ;

reg  [31:0]		S_AXIS_0_tdata      ;
reg  [0:0]		S_AXIS_0_tdest      =1'b0;
reg  [0:0]		S_AXIS_0_tid        =1'b0;
reg  [0:0]		S_AXIS_0_tlast      ;
wire [0:0]		S_AXIS_0_tready     ;
reg  [3:0]		S_AXIS_0_tstrb      ;
reg  [0:0]		S_AXIS_0_tvalid     ;

	
axis_loop U_axis_loop (
.M_AXIS_0_tdata			(M_AXIS_0_tdata			),
.M_AXIS_0_tdest         (M_AXIS_0_tdest         ),
.M_AXIS_0_tid           (M_AXIS_0_tid           ),
.M_AXIS_0_tlast         (M_AXIS_0_tlast         ),
.M_AXIS_0_tready        (M_AXIS_0_tready        ),
.M_AXIS_0_tstrb         (M_AXIS_0_tstrb         ),
.M_AXIS_0_tvalid        (M_AXIS_0_tvalid        ),
.S_AXIS_0_tdata         (S_AXIS_0_tdata         ),
.S_AXIS_0_tdest         (S_AXIS_0_tdest         ),
.S_AXIS_0_tid           (S_AXIS_0_tid           ),
.S_AXIS_0_tlast         (S_AXIS_0_tlast         ),
.S_AXIS_0_tready        (S_AXIS_0_tready        ),
.S_AXIS_0_tstrb         (S_AXIS_0_tstrb         ),
.S_AXIS_0_tvalid        (S_AXIS_0_tvalid        ),
.aclk_0                 (clk                    ),
.aresetn_0              (rst                    )
);

always @ (posedge rst or posedge clk)
	if (rst)
		begin
		S_AXIS_0_tdata	<=32'b0;
		S_AXIS_0_tlast	<=1'b0;
		S_AXIS_0_tstrb	<=4'b0;
		S_AXIS_0_tvalid	<=1'b0;
		end			
	else if (S_AXIS_0_tready)
		begin
		packet_gen.rd_data32(S_AXIS_0_tdata,S_AXIS_0_tstrb,S_AXIS_0_tlast,S_AXIS_0_tvalid);
		end
	else
		begin
		S_AXIS_0_tdata	<=32'b0;
		S_AXIS_0_tlast	<=1'b0;
		S_AXIS_0_tstrb	<=4'b0;
		S_AXIS_0_tvalid	<=1'b0;
		end



always @ (posedge rst or posedge clk)
	if (rst)
		M_AXIS_0_tready	<=1'b0;
	else
		M_AXIS_0_tready <=1'b1;
		
		
			
always @ (posedge clk)
	if (M_AXIS_0_tvalid)
		packet_chk.wr_data32(M_AXIS_0_tdata,M_AXIS_0_tstrb,M_AXIS_0_tlast);

endmodule