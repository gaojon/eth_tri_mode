class IP_packet_chk;
	bit[15:0]			lgth;
	bit[15:0]			seq;
	bit[3:0]			strobe;
	bit					last;
	bit[2000:0][7:0]	data ;
	bit[31:0]			crc32;
	
	
	function new (bit[15:0] seq = 16'h0);
	
			
		this.lgth 		= 16'd0;
		this.seq	    = seq;
		this.strobe 	= 4'b0;
		this.last		= 1'b0;
				
	endfunction
	
	
	
	function void wr_data32 (input bit [31:0]	wr_data,input bit [3:0] wr_strobe, input bit wr_last);
		bit[31:0]	crc32;
		bit[15:0]	seq;
		bit[15:0]	lgth;
		
		int fd;
			
		

		this.data[this.lgth]	=wr_data[31:24];
		this.data[this.lgth+1]	=wr_data[23:16];
		this.data[this.lgth+2]	=wr_data[15:8];
		this.data[this.lgth+3]	=wr_data[7:0];
		
		if (wr_last == 1'b0) begin	
			this.lgth = this.lgth + 4;
		end
		else begin
			case (wr_strobe)
				4'b1000:	this.lgth = this.lgth + 1;
				4'b1100:	this.lgth = this.lgth + 2;
				4'b1110:	this.lgth = this.lgth + 3;
				4'b1111:	this.lgth = this.lgth + 4;
			endcase
			this.strobe = wr_strobe;
			this.last	= 1'b1;
			
			//check length
			lgth ={this.data[4], this.data[5]};
			
			if (lgth != this.lgth) begin
				$display ("Packet lgth mismatch detected! The expected lgth is:%04d but received packet lgth is:%04d", lgth, this.lgth);
				fd = $fopen ("../log/.sim_failed", "w");
				$finish;
			end
			

			//check seq
			seq  ={this.data[6], this.data[7]};
			
			if (seq==16'hffff) begin
				$display ("The final packet with seq number:0xffff received and it means the simulation is completed without error");
				fd = $fopen ("../log/.sim_succeed", "w");
				$fclose(fd);
				$finish;
				end
			
			
			if (seq != this.seq ) begin
				$display ("Packet sequence number mismatch detected! The expected seq is:%04d but received packet seq is:%04d", this.seq, seq);
				fd = $fopen ("../log/.sim_failed", "w");
				$fclose(fd);
				$finish;
			end
			
			//check crc
			crc32={this.data[this.lgth-4], this.data[this.lgth-3],this.data[this.lgth-2],this.data[this.lgth-1]};
			if (crc32 != this.gen_CRC32() ) begin
				$display ("Packet CRC32 mismatch detected! The expected lgth is:%04h but received packet lgth is:%04h", crc32,this.crc32);
				fd = $fopen ("../log/.sim_failed", "w");
				$fclose(fd);
				$finish;
			end
			
			
			$display ("Packet passed check successfully! The packet sequence is:%02d and packet lgth is:%02d", this.seq, this.lgth);
			

			//initial for next new packet
			
			this.seq = this.seq + 1;
			this.lgth 		= 16'd0;
			this.strobe 	= 4'b0;
			this.last		= 1'b0;
			
		end
	endfunction
	
	
	function bit[31:0] gen_CRC32();
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
	
	this.crc32 = crc32_val;
    return crc32_val;
  
	endfunction		
		
		
endclass