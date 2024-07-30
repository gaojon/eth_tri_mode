The original design was public on opencores as https://opencores.org/projects/ethernet_tri_mode about 19 years ago. But I can't even download the full source code from this website anymore. So, I have to restart from here, https://github.com/freecores/ethernet_tri_mode. 

The purpose of project is to migrate design to AXI stream interfaces for data flow and AXI lite interface for register accessing. The simulation DLLs which are used to generate and check packets have already been replaced by system verilog and shared with source code. Vivado simulator is the only simulator for this new release now. There is not a plan to support other simulators such as questa or ncsim. It should be doable by youself through referencing to the scripts for XSIM. It's quite straightforward. At the same time, the TK GUI is still there and it will make it easier to config stimulus and run verfication in batch mode. 

The loopback design also validated on hardware. Addtional project provided to hook this ethernet IP together with XDMA to validate data flow from a host. We can't say this design passed exhaustive hardware verfication. It still have a large gap to run through more test cases if you want to use this as your final products.  




# Environment Setup 
* Vivado 2023.2. Other release version should also work as well. 
* tcl/tk for the GUI support




# verification through simulation

Please refer to following PDF to go through the simulation. 

[Tri-mode_Ethernet_MAC_Verification_plan.pdf](./doc/Tri-mode_Ethernet_MAC_Verification_plan.pdf)

The simple steps as following:

```
$cd eth_tri_mode/sim/rtl_sim/xsim/script
$wish run.tcl
```

a TK GUI will bring up. Click set_stimulus to setup the packaget length from 64-1500 sequencial pattern. Then, click start_verify to run through the simulation. The testbench was set up in MII loop mode and sending/receiving packets through AXI intefaces. The testbench will check the packet length, packet sequence and CRC check to validate the integrety of ethernet packets. The following output will be expected from GUI window:


```
Packet passed check successfully! The packet sequence is:1425 and packet lgth is:1489
Packet passed check successfully! The packet sequence is:1426 and packet lgth is:1490
Packet passed check successfully! The packet sequence is:1427 and packet lgth is:1491
Packet passed check successfully! The packet sequence is:1428 and packet lgth is:1492
Packet passed check successfully! The packet sequence is:1429 and packet lgth is:1493
Packet passed check successfully! The packet sequence is:1430 and packet lgth is:1494
Packet passed check successfully! The packet sequence is:1431 and packet lgth is:1495
Packet passed check successfully! The packet sequence is:1432 and packet lgth is:1496
Packet passed check successfully! The packet sequence is:1433 and packet lgth is:1497
Packet passed check successfully! The packet sequence is:1434 and packet lgth is:1498
Packet passed check successfully! The packet sequence is:1435 and packet lgth is:1499
Packet passed check successfully! The packet sequence is:1436 and packet lgth is:1500
The final packet with seq number:0xffff received and it means the simulation is completed without error
```

There is anther way to launch XSIM GUI to show the waveform for further signal debugging. 

```
$cd eth_tri_mode/sim/rtl_sim/xsim/
$./sim -g
```


# Verification through hardware


## hardware design 
This will leverage a PCIe FPGA acceleration card to validate function with hardware as well. This example was verified with U50. Another IP is need to pass test pattern from host. XDMA is an easy one to start with. The idea is to package the ethernet core into a IP and add it in IPI design to integerate with XDMA. Use following command to package ethernet core into IP. 

```
$cd eth_tri_mode/hw
$make
```

Then launch a full project to integrate ethernet IP and XDMA. Go through the Vivado flow till get the bitstream. Then, it's done for hardware design. 
```
$cd eth_tri_mode/u50_xdma/hw
$make
```

## XDMA software 
This will clone the xdma driver and leverage test scripts for ethernet packets testing. The AXI lite interface will be used for register access and AXI stream interface will be used for packet data stream. 

```
$git clone https://github.com/Xilinx/dma_ip_drivers
$cd dma_ip_drivers/XDMA/linux-kernel/xdma
$sudo make install
$cd ../tools
$make
$cd ../tests
$sudo ./load_driver.sh
$sudo ./dma_streaming_test.sh 256 1 1
```

The expected results will be:
```
$ sudo ./dma_streaming_test.sh 256 32 1
Info: Running PCIe DMA streaming test
      transfer size:  256
      transfer count: 32
Info: Only channels that have both h2c and c2h will be tested as the other
      interfaces are left unconnected in the PCIe DMA example design.
Info: DMA setup to read from c2h channel 0. Waiting on write data to channel 0.
Info: Writing to h2c channel 0. This will also start reading data on c2h channel 0.
Info: Wait the for current transactions to complete.
/dev/xdma0_h2c_0 ** Average BW = 256, 5.609783
/dev/xdma0_c2h_0 ** Average BW = 256, 1.353972
Info: Checking data integrity.
Info: Data check passed for c2h and h2c channel 0.
Info: All PCIe DMA streaming tests passed.
```


