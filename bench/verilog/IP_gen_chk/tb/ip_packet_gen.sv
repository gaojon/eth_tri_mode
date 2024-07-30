class IP_packet_gen;
	bit[15:0]			lgth;
	bit[15:0]			pointer;
	bit[15:0]			seq;
	bit[3:0]			strobe;
	bit					last;
	bit[2000:0][7:0]	data ;
	bit[15:0]			start_lgth;
	bit[15:0]			end_lgth;	
	bit[15:0]			packet_numb;	
	bit					random;
	bit					gen_completed;
	bit					send_completed;
	
	
	
	function new (string file_name = "../data/config.ini");
		int fd;
			
		fd = $fopen (file_name, "r");
		
		if (fd) begin
			$display("configure file:%s opened sucessfully", file_name);
			$fscanf(fd, "%d,%d,%d,%d", this.start_lgth, this.end_lgth, this.packet_numb,this.random );
			$display("Provisioned config from file: start_lgth->%d, end_lgth->%d, packet_numb->%d,random->%d ",this.start_lgth, this.end_lgth, this.packet_numb,this.random  );
			this.seq = 0;
			this.send_completed = 0;
			this.init_packet();
		end
		else	
			$display("failed to open configure file:%s, please check if file exist!", file_name);
			
			
		$fclose(fd);
		
	endfunction
	

	function init_packet ();
		bit[31:0] crc_gen		;

		

		
		if (this.random == 1'b0) begin
			
			if (this.lgth  >= this.end_lgth)
				this.gen_completed = 1;	
			else
				this.lgth	= this.start_lgth + this.seq;
				
		end else begin
			
			if (this.seq >= this.packet_numb)
				this.gen_completed = 1;
			else
				this.lgth	= $urandom_range(this.start_lgth, this.end_lgth);
		end
			
		//repeat last packet if compelted	
		if (this.gen_completed) begin
			this.pointer	= 16'd0;
			this.strobe 	= 4'b0;
			this.last		= 1'b0;
		
			this.data[0]	= 8'hff;
			this.data[1]	= 8'hff;
			this.data[2]	= 8'haa;
			this.data[3]	= 8'haa;
			this.data[4]	= this.lgth[15:8] ;
			this.data[5]	= this.lgth[7:0];
			this.data[6]	= 8'hff;
			this.data[7]	= 8'hff;
		end else begin
			this.pointer	= 16'd0;
			this.strobe 	= 4'b0;
			this.last		= 1'b0;
		
			this.data[0]	= 8'hff;
			this.data[1]	= 8'hff;
			this.data[2]	= 8'haa;
			this.data[3]	= 8'haa;
			this.data[4]	= this.lgth[15:8] ;
			this.data[5]	= this.lgth[7:0];
			this.data[6]	= this.seq[15:8];
			this.data[7]	= this.seq[7:0];	

			this.seq = this.seq + 1;				
		end
				
		
		//append data content
		for (int i = 8; i < (lgth-4) ; i++)
			this.data[i]	= i;
		
		
		this.gen_CRC32();

	endfunction	



	function void gen_CRC32();
    int unsigned i, j;
    bit [31:0] crc32_val = 32'hffffffff; // shiftregister,startvalue 
    bit [7:0]  data;
	localparam CRC32POL = 32'hEDB88320; /* Ethernet CRC-32 Polynom, reverse Bits */

    //The result of the loop generate 32-Bit-mirrowed CRC
		for (i = 0; i < this.lgth -4; i++)  // Byte-Stream
    begin
        data = this.data[i];
        for (j=0; j < 8; j++) // Bitwise from LSB to MSB
        begin
            if ((crc32_val[0]) != (data[0])) begin
                crc32_val = (crc32_val >> 1) ^ CRC32POL;
            end else begin
                crc32_val >>= 1;
            end
            data >>= 1;
        end
    end
    crc32_val ^= 32'hffffffff; //invert results
    
    
    //append CRC
	this.data[this.lgth - 4 ]	= crc32_val[31:24];
	this.data[this.lgth - 3 ]	= crc32_val[23:16];
	this.data[this.lgth - 2 ]	= crc32_val[15:8];
	this.data[this.lgth - 1 ]	= crc32_val[7:0];
		
    
	endfunction
	
	
	function void	rd_data32(output bit [31:0] rd_data, output bit [3:0] rd_strobe, output bit rd_last, output bit data_valid);


		if (this.send_completed == 1)
			begin
			rd_data		= 0;	
			rd_strobe	=0;
			rd_last		=0;
			data_valid	=0;			
			end
		else begin
			rd_data	= {this.data[this.pointer], this.data[this.pointer+1],this.data[this.pointer+2],this.data[this.pointer+3]};
			data_valid = 1'b1;
			if (this.pointer + 4 < this.lgth) begin
				this.pointer = this.pointer + 4;
				this.strobe	 =4'b1111;
				end
			else begin
				this.last	= 1'b1;
				case (this.lgth[1:0])
					2'b00:	this.strobe	 =4'b1111;
					2'b01:	this.strobe	 =4'b1000;
					2'b10:	this.strobe	 =4'b1100;
					2'b11:	this.strobe	 =4'b1110;
				endcase
			end
			
			rd_strobe = this.strobe;
			rd_last	  = this.last;
			
			if (this.last == 1'b1 && this.gen_completed != 1)
				this.init_packet();
			else if (this.last == 1'b1 && this.gen_completed == 1 )
				this.send_completed = 1;			
		end
		
	endfunction
	
	
	function void display ();
		for (int i =0 ; i < this.lgth ; i++)
			$display ("data[%02h] = 0x%02h ", i, this.data[i]);
		
	endfunction
	
	
	
endclass