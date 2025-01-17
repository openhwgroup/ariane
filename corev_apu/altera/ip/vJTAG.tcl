# Quartus Pro License required to use this file
package require -exact qsys 24.1

# create the system "vJTAG"
proc do_create_vJTAG {} {
	# create the system
	create_system vJTAG
	set_project_property BOARD {default}
	set_project_property DEVICE {AGFB014R24B2E2V}
	set_project_property DEVICE_FAMILY {Agilex 7}
	set_project_property HIDE_FROM_IP_CATALOG {true}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_instance virtual_jtag_0 altera_virtual_jtag 19.2.1
	set_instance_parameter_value virtual_jtag_0 {CREATE_PRIMITIVE_JTAG_STATE_SIGNAL_PORTS} {1}
	set_instance_parameter_value virtual_jtag_0 {gui_use_auto_index} {1}
	set_instance_parameter_value virtual_jtag_0 {sld_instance_index} {0}
	set_instance_parameter_value virtual_jtag_0 {sld_ir_width} {10}
	set_instance_property virtual_jtag_0 AUTO_EXPORT true

	# add wirelevel expressions

	# preserve ports for debug

	# add the exports
	set_interface_property jtag EXPORT_OF virtual_jtag_0.jtag
	set_interface_property tck EXPORT_OF virtual_jtag_0.tck

	# set values for exposed HDL parameters

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="virtual_jtag_0">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {vJTAG.ip}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {vJTAG}

	# save the system
	sync_sysinfo_parameters
	save_system vJTAG
}

proc do_set_exported_interface_sysinfo_parameters {} {
}

# create all the systems, from bottom up
do_create_vJTAG

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
