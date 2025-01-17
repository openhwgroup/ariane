# Quartus Pro License required to use this file
package require -exact qsys 24.1

# create the system "emif_cal"
proc do_create_emif_cal {} {
	# create the system
	create_system emif_cal
	set_project_property BOARD {default}
	set_project_property DEVICE {AGFB014R24B2E2V}
	set_project_property DEVICE_FAMILY {Agilex 7}
	set_project_property HIDE_FROM_IP_CATALOG {true}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_instance emif_cal_0 altera_emif_cal 2.7.4
	set_instance_parameter_value emif_cal_0 {AXM_ID_NUM} {0}
	set_instance_parameter_value emif_cal_0 {DIAG_ENABLE_JTAG_UART} {0}
	set_instance_parameter_value emif_cal_0 {DIAG_EXPORT_SEQ_AVALON_SLAVE} {CAL_DEBUG_EXPORT_MODE_DISABLED}
	set_instance_parameter_value emif_cal_0 {DIAG_EXPORT_VJI} {0}
	set_instance_parameter_value emif_cal_0 {DIAG_EXTRA_CONFIGS} {}
	set_instance_parameter_value emif_cal_0 {DIAG_SIM_CAL_MODE_ENUM} {SIM_CAL_MODE_SKIP}
	set_instance_parameter_value emif_cal_0 {DIAG_SIM_VERBOSE} {0}
	set_instance_parameter_value emif_cal_0 {DIAG_SYNTH_FOR_SIM} {0}
	set_instance_parameter_value emif_cal_0 {ENABLE_DDRT} {0}
	set_instance_parameter_value emif_cal_0 {NUM_CALBUS_INTERFACE} {1}
	set_instance_parameter_value emif_cal_0 {PHY_DDRT_EXPORT_CLK_STP_IF} {0}
	set_instance_parameter_value emif_cal_0 {SHORT_QSYS_INTERFACE_NAMES} {1}
	set_instance_property emif_cal_0 AUTO_EXPORT true

	# add wirelevel expressions

	# preserve ports for debug

	# add the exports
	set_interface_property emif_calbus_0 EXPORT_OF emif_cal_0.emif_calbus_0
	set_interface_property emif_calbus_clk EXPORT_OF emif_cal_0.emif_calbus_clk

	# set values for exposed HDL parameters

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="emif_cal_0">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {emif_cal.ip}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {emif_cal}

	# save the system
	sync_sysinfo_parameters
	save_system emif_cal
}

proc do_set_exported_interface_sysinfo_parameters {} {
}

# create all the systems, from bottom up
do_create_emif_cal

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
