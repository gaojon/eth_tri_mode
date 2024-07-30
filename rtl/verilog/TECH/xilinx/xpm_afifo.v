module xpm_afifo #(
parameter integer DATA_WIDTH    = 36, 
parameter integer ADDR_WIDTH    = 9 
)
(
output					data_valid		,
output [DATA_WIDTH-1:0]	dout			,
output					empty			,
output					full			,
output                  almost_full     ,
output					overflow		,
output					rd_rst_busy		,
output					underflow		,
input					wr_ack			,
input [DATA_WIDTH-1:0]	din				,
input					rd_clk			,
input					rd_en			,
input					rst				,
input					wr_clk			,
input					wr_en			,
output [4:0]			rd_data_count
);

localparam integer DATA_DEPTH = 2**ADDR_WIDTH;



xpm_fifo_async #(
      .CASCADE_HEIGHT(0),        // DECIMAL
      .CDC_SYNC_STAGES(2),       // DECIMAL
      .DOUT_RESET_VALUE("0"),    // String
      .ECC_MODE("no_ecc"),       // String
      .FIFO_MEMORY_TYPE("auto"), // String
	  .FIFO_READ_LATENCY(0),     // DECIMAL
      .FIFO_WRITE_DEPTH(DATA_DEPTH),   // DECIMAL
      .FULL_RESET_VALUE(0),      // DECIMAL
      .PROG_EMPTY_THRESH(10),    // DECIMAL
      .PROG_FULL_THRESH(10),     // DECIMAL
      .RD_DATA_COUNT_WIDTH(5),   // DECIMAL
      .READ_DATA_WIDTH(DATA_WIDTH),      // DECIMAL
	  .READ_MODE("fwft"),         // String
      .RELATED_CLOCKS(0),        // DECIMAL
      .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_ADV_FEATURES("1f1f"), // String
      .WAKEUP_TIME(0),           // DECIMAL
      .WRITE_DATA_WIDTH(DATA_WIDTH),     // DECIMAL
      .WR_DATA_COUNT_WIDTH(5)    // DECIMAL
   )
   xpm_fifo_async_inst (
      .almost_empty(),
      .almost_full(almost_full),    
      .data_valid(data_valid),      
      .dbiterr(),            
      .dout(dout),
      .empty(empty),   
      .full(full),  
      .overflow(overflow),
      .prog_empty(), 
      .prog_full(),  
      .rd_data_count(rd_data_count),
      .rd_rst_busy(rd_rst_busy), 
      .sbiterr(),   
      .underflow(underflow),  
      .wr_ack(wr_ack), 
      .wr_data_count(),
      .wr_rst_busy(), 
      .din(din),                 
	  .injectdbiterr(1'b0),
	  .injectsbiterr(1'b0),
      .rd_clk(rd_clk),       
      .rd_en(rd_en),   
      .rst(rst),  
	  .sleep(1'b0), 
      .wr_clk(wr_clk),  
      .wr_en(wr_en)   
   );
	
endmodule