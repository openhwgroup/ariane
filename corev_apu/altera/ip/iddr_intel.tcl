# Quartus Pro License required to use this file
package require -exact qsys 24.1

# create the system "iddr_intel"
proc do_create_iddr_intel {} {
	# create the system
	create_system iddr_intel
	set_project_property BOARD {default}
	set_project_property DEVICE {AGFB014R24B2E2V}
	set_project_property DEVICE_FAMILY {Agilex 7}
	set_project_property HIDE_FROM_IP_CATALOG {true}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_instance gpio_0 altera_gpio 22.1.0
	set_instance_parameter_value gpio_0 {EXT_DRIVER_PARAM} {0}
	set_instance_parameter_value gpio_0 {GENERATE_SDC_FILE} {0}
	set_instance_parameter_value gpio_0 {IP_MIGRATE_PORT_MAP_FILE} {altddio_bidir_port_map.csv}
	set_instance_parameter_value gpio_0 {PIN_TYPE_GUI} {Input}
	set_instance_parameter_value gpio_0 {SIZE} {1}
	set_instance_parameter_value gpio_0 {gui_areset_mode} {None}
	set_instance_parameter_value gpio_0 {gui_bus_hold} {0}
	set_instance_parameter_value gpio_0 {gui_ddio_with_delay} {0}
	set_instance_parameter_value gpio_0 {gui_diff_buff} {0}
	set_instance_parameter_value gpio_0 {gui_enable_cke} {0}
	set_instance_parameter_value gpio_0 {gui_enable_migratable_port_names} {0}
	set_instance_parameter_value gpio_0 {gui_enable_termination_ports} {0}
	set_instance_parameter_value gpio_0 {gui_hr_logic} {0}
	set_instance_parameter_value gpio_0 {gui_io_reg_mode} {DDIO}
	set_instance_parameter_value gpio_0 {gui_open_drain} {0}
	set_instance_parameter_value gpio_0 {gui_pseudo_diff} {0}
	set_instance_parameter_value gpio_0 {gui_separate_io_clks} {0}
	set_instance_parameter_value gpio_0 {gui_sreset_mode} {None}
	set_instance_parameter_value gpio_0 {gui_use_oe} {0}
	set_instance_property gpio_0 AUTO_EXPORT true

	# add wirelevel expressions

	# preserve ports for debug

	# add the exports
	set_interface_property ck EXPORT_OF gpio_0.ck
	set_interface_property dout EXPORT_OF gpio_0.dout
	set_interface_property pad_in EXPORT_OF gpio_0.pad_in

	# set values for exposed HDL parameters

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="gpio_0">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {iddr_intel.ip}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {iddr_intel}

	# save the system
	sync_sysinfo_parameters
	save_system iddr_intel
}

proc do_set_exported_interface_sysinfo_parameters {} {
}

# create all the systems, from bottom up
do_create_iddr_intel

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
