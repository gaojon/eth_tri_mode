module host_sim (
input					Clk_reg					,
input					Reset					,
output 	reg		[31:0]	S_AXI_araddr			,
input 					S_AXI_arready         	,
output 	reg				S_AXI_arvalid         	,
output 	reg		[31:0]	S_AXI_awaddr          	,
input 					S_AXI_awready         	,
output 	reg				S_AXI_awvalid         	,
output 	reg				S_AXI_bready          	,
input 			[1:0]	S_AXI_bresp           	,
input 					S_AXI_bvalid          	,
input 			[31:0]	S_AXI_rdata           	,
output 	reg				S_AXI_rready          	,
input 			[1:0]	S_AXI_rresp           	,
input 					S_AXI_rvalid          	,
output 	reg		[31:0]	S_AXI_wdata           	,
input 					S_AXI_wready          	,
output 	reg				S_AXI_wvalid          	,
output	reg				CPU_init_end
);

////////////////////////////////////////
task    CPU_init;
begin
	S_AXI_araddr	  =0;		
	S_AXI_arvalid     =0;   
	S_AXI_awaddr      =0;   
	S_AXI_awvalid     =0;   
	S_AXI_bready      =1'b1;   
	S_AXI_rready      =1'b1;   
	S_AXI_wdata       =0;   
	S_AXI_wvalid      =0;   
end
endtask

////////////////////////////////////////
task    CPU_wr;
input[6:0]      Addr;
input[15:0]     Data;
begin


		@ (posedge Clk_reg) ;
		
        S_AXI_awaddr      ={Addr,2'b0};
		S_AXI_awvalid		=1'b1;
		
		S_AXI_wdata		=Data;
		S_AXI_wvalid		=1'b1;
		
		@ (posedge Clk_reg) ;
        S_AXI_awaddr      =0;
		S_AXI_awvalid		=0;
		
		S_AXI_wdata		=0;
		S_AXI_wvalid		=0;		
		
		repeat (8) 
			@ (posedge Clk_reg) ;

		
end
endtask
/////////////////////////////////////////
task    CPU_rd;
input[6:0]      Addr;
begin

		@ (posedge Clk_reg) ;
	
		S_AXI_araddr		= {Addr,2'b0};
		S_AXI_arvalid		=1'b1;
		
		@ (posedge Clk_reg) ;
		S_AXI_araddr		= 0 ;
		S_AXI_arvalid		=1'b0;
		
	repeat (8)
			@ (posedge Clk_reg) ;

end
endtask
/////////////////////////////////////////

integer         i;

reg     [31:0]  CPU_data [255:0];
reg     [7:0]   write_times;
reg     [7:0]   write_add;
reg     [15:0]  write_data;


initial
    begin
    
    end
    

initial
    begin
        CPU_init;
        CPU_init_end=0;  
		i=0;
        $readmemh("../data/CPU.vec",CPU_data);
        {write_times,write_add,write_data}=CPU_data[0];
    	#90 ;
        for (i=0;i<write_times;i=i+1)
            begin
            {write_times,write_add,write_data}=CPU_data[i];
            CPU_wr(write_add[6:0],write_data);
            end
        CPU_init_end=1;
    end
endmodule 	    	