(
) (


) {


instantiate rst_clk_gen.v (
)

instantiate ../../rtl/verilog/MAC_top.v (
)

instantiate Phy_sim.v (
)

instantiate User_int_sim.sv ( 
Reset		:!ResetB
)

instantiate host_sim.v (
Reset		:!ResetB
)

}
