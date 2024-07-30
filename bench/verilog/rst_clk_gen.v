module rst_clk_gen (
output reg				ResetB					,
output reg				Clk_125M				,
output reg				Clk_user				,
output reg				Clk_reg				
	
);
	


initial 
	begin
			ResetB	=0;
	#20		ResetB	=1;
	end
always 
	begin
	#4		Clk_125M=0;
	#4		Clk_125M=1;
	end

always 
	begin
	#5		Clk_user=0;
	#5		Clk_user=1;
	end
	
always 
	begin
	#10		Clk_reg=0;
	#10		Clk_reg=1;
	end


initial	
	begin
	$shm_open("tb_top.shm",,900000000,);
	$shm_probe("AS");
	end

endmodule;
