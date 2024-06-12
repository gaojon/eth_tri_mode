GCC = eon

objs =	./rtl/verilog/MAC_rx.v \
		./rtl/verilog/MAC_tx.v \
		./rtl/verilog/MAC_top.v \
		./bench/verilog/tb_top.v 


%.v:%.e
	$(GCC)  $<                                           

all : ${objs}
clean :
	rm ${objs}
