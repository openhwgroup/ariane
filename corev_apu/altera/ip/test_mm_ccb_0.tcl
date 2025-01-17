# Quartus Pro License required to use this file
package require -exact qsys 24.1

# create the system "test_mm_ccb_0"
proc do_create_test_mm_ccb_0 {} {
	# create the system
	create_system test_mm_ccb_0
	set_project_property BOARD {default}
	set_project_property DEVICE {AGFB014R24B2E2V}
	set_project_property DEVICE_FAMILY {Agilex 7}
	set_project_property HIDE_FROM_IP_CATALOG {false}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_instance mm_ccb_0 mm_ccb 19.2.1
	set_instance_parameter_value mm_ccb_0 {ADDRESS_UNITS} {SYMBOLS}
	set_instance_parameter_value mm_ccb_0 {ADDRESS_WIDTH} {27}
	set_instance_parameter_value mm_ccb_0 {COMMAND_FIFO_DEPTH} {256}
	set_instance_parameter_value mm_ccb_0 {DATA_WIDTH} {512}
	set_instance_parameter_value mm_ccb_0 {MASTER_SYNC_DEPTH} {2}
	set_instance_parameter_value mm_ccb_0 {MAX_BURST_SIZE} {128}
	set_instance_parameter_value mm_ccb_0 {RESPONSE_FIFO_DEPTH} {256}
	set_instance_parameter_value mm_ccb_0 {SLAVE_SYNC_DEPTH} {2}
	set_instance_parameter_value mm_ccb_0 {SYMBOL_WIDTH} {8}
	set_instance_parameter_value mm_ccb_0 {SYNC_RESET} {1}
	set_instance_parameter_value mm_ccb_0 {USE_AUTO_ADDRESS_WIDTH} {0}
	set_instance_property mm_ccb_0 AUTO_EXPORT true

	# add wirelevel expressions

	# preserve ports for debug

	# add the exports
	set_interface_property m0_clk EXPORT_OF mm_ccb_0.m0_clk
	set_interface_property m0_reset EXPORT_OF mm_ccb_0.m0_reset
	set_interface_property s0_clk EXPORT_OF mm_ccb_0.s0_clk
	set_interface_property s0_reset EXPORT_OF mm_ccb_0.s0_reset
	set_interface_property s0 EXPORT_OF mm_ccb_0.s0
	set_interface_property m0 EXPORT_OF mm_ccb_0.m0

	# set values for exposed HDL parameters

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="mm_ccb_0">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {ip/test_mm_ccb_0.ip}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {test_mm_ccb_0}

	# save the system
	sync_sysinfo_parameters
	save_system test_mm_ccb_0
}

proc do_set_exported_interface_sysinfo_parameters {} {
	load_system test_mm_ccb_0.ip
	set_exported_interface_sysinfo_parameter_value m0 address_width {10}
	save_system test_mm_ccb_0.ip
}

# create all the systems, from bottom up
do_create_test_mm_ccb_0

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
