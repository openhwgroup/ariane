# Quartus Pro License required to use this file
package require -exact qsys 24.1

# create the system "cva6_intel_jtag_uart_0"
proc do_create_cva6_intel_jtag_uart_0 {} {
	# create the system
	create_system cva6_intel_jtag_uart_0
	set_project_property BOARD {default}
	set_project_property DEVICE {AGFB014R24B2E2V}
	set_project_property DEVICE_FAMILY {Agilex 7}
	set_project_property HIDE_FROM_IP_CATALOG {false}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_instance jtag_uart_0 altera_avalon_jtag_uart 19.2.4
	set_instance_parameter_value jtag_uart_0 {allowMultipleConnections} {0}
	set_instance_parameter_value jtag_uart_0 {hubInstanceID} {0}
	set_instance_parameter_value jtag_uart_0 {readBufferDepth} {64}
	set_instance_parameter_value jtag_uart_0 {readIRQThreshold} {8}
	set_instance_parameter_value jtag_uart_0 {simInputCharacterStream} {}
	set_instance_parameter_value jtag_uart_0 {simInteractiveOptions} {NO_INTERACTIVE_WINDOWS}
	set_instance_parameter_value jtag_uart_0 {useRegistersForReadBuffer} {0}
	set_instance_parameter_value jtag_uart_0 {useRegistersForWriteBuffer} {0}
	set_instance_parameter_value jtag_uart_0 {useRelativePathForSimFile} {0}
	set_instance_parameter_value jtag_uart_0 {writeBufferDepth} {64}
	set_instance_parameter_value jtag_uart_0 {writeIRQThreshold} {8}
	set_instance_property jtag_uart_0 AUTO_EXPORT true

	# add wirelevel expressions

	# preserve ports for debug

	# add the exports
	set_interface_property clk EXPORT_OF jtag_uart_0.clk
	set_interface_property reset EXPORT_OF jtag_uart_0.reset
	set_interface_property avalon_jtag_slave EXPORT_OF jtag_uart_0.avalon_jtag_slave
	set_interface_property irq EXPORT_OF jtag_uart_0.irq

	# set values for exposed HDL parameters

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="jtag_uart_0">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {cva6_intel_jtag_uart_0.ip}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {cva6_intel_jtag_uart_0}

	# save the system
	sync_sysinfo_parameters
	save_system cva6_intel_jtag_uart_0
}

proc do_set_exported_interface_sysinfo_parameters {} {
	load_system cva6_intel_jtag_uart_0.ip
	set_exported_interface_sysinfo_parameter_value clk clock_rate {300000000}
	save_system cva6_intel_jtag_uart_0.ip
}

# create all the systems, from bottom up
do_create_cva6_intel_jtag_uart_0

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
