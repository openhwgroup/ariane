set_false_path -from [get_clocks {inst_ddr4|emif_fm_0_core_usr_clk}] -to [get_clocks {clocks|iopll_0_outclk0}]
set_false_path -from [get_clocks {clocks|iopll_0_outclk0}] -to [get_clocks {inst_ddr4|emif_fm_0_core_usr_clk}]
set_false_path -from [get_clocks {clocks|iopll_0_outclk0}] -to [get_clocks {clocks|iopll_0_refclk}]
set_false_path -from [get_clocks {clocks|iopll_0_refclk}] -to [get_clocks {clocks|iopll_0_outclk0}]
set_disable_timing [get_ports led[*]]
set_false_path -hold -through [get_pins -hierarchical "*async*"]
set_max_delay -through [get_pins -hierarchical "*async*"] 5.000
