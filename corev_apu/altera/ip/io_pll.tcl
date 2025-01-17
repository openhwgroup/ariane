# Quartus Pro License required to use this file
package require -exact qsys 24.1

# create the system "io_pll"
proc do_create_io_pll {} {
	# create the system
	create_system io_pll
	set_project_property BOARD {default}
	set_project_property DEVICE {AGFB014R24B2E2V}
	set_project_property DEVICE_FAMILY {Agilex 7}
	set_project_property HIDE_FROM_IP_CATALOG {true}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_instance iopll_0 altera_iopll 19.3.1
	set_instance_parameter_value iopll_0 {gui_active_clk} {0}
	set_instance_parameter_value iopll_0 {gui_c_cnt_in_src0} {c_m_cnt_in_src_ph_mux_clk}
	set_instance_parameter_value iopll_0 {gui_c_cnt_in_src1} {c_m_cnt_in_src_ph_mux_clk}
	set_instance_parameter_value iopll_0 {gui_c_cnt_in_src2} {c_m_cnt_in_src_ph_mux_clk}
	set_instance_parameter_value iopll_0 {gui_c_cnt_in_src3} {c_m_cnt_in_src_ph_mux_clk}
	set_instance_parameter_value iopll_0 {gui_c_cnt_in_src4} {c_m_cnt_in_src_ph_mux_clk}
	set_instance_parameter_value iopll_0 {gui_c_cnt_in_src5} {c_m_cnt_in_src_ph_mux_clk}
	set_instance_parameter_value iopll_0 {gui_c_cnt_in_src6} {c_m_cnt_in_src_ph_mux_clk}
	set_instance_parameter_value iopll_0 {gui_c_cnt_in_src7} {c_m_cnt_in_src_ph_mux_clk}
	set_instance_parameter_value iopll_0 {gui_c_cnt_in_src8} {c_m_cnt_in_src_ph_mux_clk}
	set_instance_parameter_value iopll_0 {gui_cal_code_hex_file} {iossm.hex}
	set_instance_parameter_value iopll_0 {gui_cal_converge} {0}
	set_instance_parameter_value iopll_0 {gui_cal_error} {cal_clean}
	set_instance_parameter_value iopll_0 {gui_cascade_counter0} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter1} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter10} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter11} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter12} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter13} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter14} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter15} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter16} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter17} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter2} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter3} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter4} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter5} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter6} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter7} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter8} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_counter9} {0}
	set_instance_parameter_value iopll_0 {gui_cascade_outclk_index} {0}
	set_instance_parameter_value iopll_0 {gui_clk_bad} {0}
	set_instance_parameter_value iopll_0 {gui_clock_name_global} {0}
	set_instance_parameter_value iopll_0 {gui_clock_name_string0} {outclk0}
	set_instance_parameter_value iopll_0 {gui_clock_name_string1} {outclk1}
	set_instance_parameter_value iopll_0 {gui_clock_name_string10} {outclk10}
	set_instance_parameter_value iopll_0 {gui_clock_name_string11} {outclk11}
	set_instance_parameter_value iopll_0 {gui_clock_name_string12} {outclk12}
	set_instance_parameter_value iopll_0 {gui_clock_name_string13} {outclk13}
	set_instance_parameter_value iopll_0 {gui_clock_name_string14} {outclk14}
	set_instance_parameter_value iopll_0 {gui_clock_name_string15} {outclk15}
	set_instance_parameter_value iopll_0 {gui_clock_name_string16} {outclk16}
	set_instance_parameter_value iopll_0 {gui_clock_name_string17} {outclk17}
	set_instance_parameter_value iopll_0 {gui_clock_name_string2} {outclk2}
	set_instance_parameter_value iopll_0 {gui_clock_name_string3} {outclk3}
	set_instance_parameter_value iopll_0 {gui_clock_name_string4} {outclk4}
	set_instance_parameter_value iopll_0 {gui_clock_name_string5} {outclk5}
	set_instance_parameter_value iopll_0 {gui_clock_name_string6} {outclk6}
	set_instance_parameter_value iopll_0 {gui_clock_name_string7} {outclk7}
	set_instance_parameter_value iopll_0 {gui_clock_name_string8} {outclk8}
	set_instance_parameter_value iopll_0 {gui_clock_name_string9} {outclk9}
	set_instance_parameter_value iopll_0 {gui_clock_to_compensate} {0}
	set_instance_parameter_value iopll_0 {gui_debug_mode} {0}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c0} {1}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c1} {25}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c10} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c11} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c12} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c13} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c14} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c15} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c16} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c17} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c2} {25}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c3} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c4} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c5} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c6} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c7} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c8} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_c9} {6}
	set_instance_parameter_value iopll_0 {gui_divide_factor_n} {6}
	set_instance_parameter_value iopll_0 {gui_dps_cntr} {C0}
	set_instance_parameter_value iopll_0 {gui_dps_dir} {Positive}
	set_instance_parameter_value iopll_0 {gui_dps_num} {1}
	set_instance_parameter_value iopll_0 {gui_dsm_out_sel} {1st_order}
	set_instance_parameter_value iopll_0 {gui_duty_cycle0} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle1} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle10} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle11} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle12} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle13} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle14} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle15} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle16} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle17} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle2} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle3} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle4} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle5} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle6} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle7} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle8} {50.0}
	set_instance_parameter_value iopll_0 {gui_duty_cycle9} {50.0}
	set_instance_parameter_value iopll_0 {gui_en_adv_params} {0}
	set_instance_parameter_value iopll_0 {gui_en_dps_ports} {0}
	set_instance_parameter_value iopll_0 {gui_en_extclkout_ports} {0}
	set_instance_parameter_value iopll_0 {gui_en_iossm_reconf} {0}
	set_instance_parameter_value iopll_0 {gui_en_lvds_ports} {Disabled}
	set_instance_parameter_value iopll_0 {gui_en_periphery_ports} {0}
	set_instance_parameter_value iopll_0 {gui_en_phout_ports} {0}
	set_instance_parameter_value iopll_0 {gui_en_reconf} {0}
	set_instance_parameter_value iopll_0 {gui_enable_cascade_in} {0}
	set_instance_parameter_value iopll_0 {gui_enable_cascade_out} {0}
	set_instance_parameter_value iopll_0 {gui_enable_mif_dps} {0}
	set_instance_parameter_value iopll_0 {gui_enable_output_counter_cascading} {0}
	set_instance_parameter_value iopll_0 {gui_enable_permit_cal} {0}
	set_instance_parameter_value iopll_0 {gui_enable_upstream_out_clk} {0}
	set_instance_parameter_value iopll_0 {gui_existing_mif_file_path} {~/pll.mif}
	set_instance_parameter_value iopll_0 {gui_extclkout_0_source} {C0}
	set_instance_parameter_value iopll_0 {gui_extclkout_1_source} {C0}
	set_instance_parameter_value iopll_0 {gui_extclkout_source} {C0}
	set_instance_parameter_value iopll_0 {gui_feedback_clock} {Global Clock}
	set_instance_parameter_value iopll_0 {gui_fix_vco_frequency} {0}
	set_instance_parameter_value iopll_0 {gui_fixed_vco_frequency} {600.0}
	set_instance_parameter_value iopll_0 {gui_fixed_vco_frequency_ps} {1667.0}
	set_instance_parameter_value iopll_0 {gui_frac_multiply_factor} {1.0}
	set_instance_parameter_value iopll_0 {gui_fractional_cout} {32}
	set_instance_parameter_value iopll_0 {gui_include_iossm} {0}
	set_instance_parameter_value iopll_0 {gui_location_type} {I/O Bank}
	set_instance_parameter_value iopll_0 {gui_lock_setting} {Low Lock Time}
	set_instance_parameter_value iopll_0 {gui_mif_config_name} {unnamed}
	set_instance_parameter_value iopll_0 {gui_mif_gen_options} {Generate New MIF File}
	set_instance_parameter_value iopll_0 {gui_multiply_factor} {25}
	set_instance_parameter_value iopll_0 {gui_new_mif_file_path} {~/pll.mif}
	set_instance_parameter_value iopll_0 {gui_number_of_clocks} {5}
	set_instance_parameter_value iopll_0 {gui_operation_mode} {direct}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency0} {200.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency1} {125.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency10} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency11} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency12} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency13} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency14} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency15} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency16} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency17} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency2} {200.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency3} {125.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency4} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency5} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency6} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency7} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency8} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency9} {100.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps0} {5000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps1} {8000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps10} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps11} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps12} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps13} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps14} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps15} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps16} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps17} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps2} {5000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps3} {8000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps4} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps5} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps6} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps7} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps8} {10000.0}
	set_instance_parameter_value iopll_0 {gui_output_clock_frequency_ps9} {10000.0}
	set_instance_parameter_value iopll_0 {gui_parameter_table_hex_file} {seq_params_sim.hex}
	set_instance_parameter_value iopll_0 {gui_phase_shift0} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift1} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift10} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift11} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift12} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift13} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift14} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift15} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift16} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift17} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift2} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift3} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift4} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift5} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift6} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift7} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift8} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift9} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg0} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg1} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg10} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg11} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg12} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg13} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg14} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg15} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg16} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg17} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg2} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg3} {90.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg4} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg5} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg6} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg7} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg8} {0.0}
	set_instance_parameter_value iopll_0 {gui_phase_shift_deg9} {0.0}
	set_instance_parameter_value iopll_0 {gui_phout_division} {1}
	set_instance_parameter_value iopll_0 {gui_pll_auto_reset} {0}
	set_instance_parameter_value iopll_0 {gui_pll_bandwidth_preset} {Medium}
	set_instance_parameter_value iopll_0 {gui_pll_cal_done} {0}
	set_instance_parameter_value iopll_0 {gui_pll_cascading_mode} {adjpllin}
	set_instance_parameter_value iopll_0 {gui_pll_freqcal_en} {1}
	set_instance_parameter_value iopll_0 {gui_pll_freqcal_req_flag} {1}
	set_instance_parameter_value iopll_0 {gui_pll_m_cnt_in_src} {c_m_cnt_in_src_ph_mux_clk}
	set_instance_parameter_value iopll_0 {gui_pll_mode} {Integer-N PLL}
	set_instance_parameter_value iopll_0 {gui_pll_tclk_mux_en} {0}
	set_instance_parameter_value iopll_0 {gui_pll_tclk_sel} {pll_tclk_m_src}
	set_instance_parameter_value iopll_0 {gui_pll_type} {S10_Simple}
	set_instance_parameter_value iopll_0 {gui_pll_vco_freq_band_0} {pll_freq_clk0_band18}
	set_instance_parameter_value iopll_0 {gui_pll_vco_freq_band_1} {pll_freq_clk1_band18}
	set_instance_parameter_value iopll_0 {gui_prot_mode} {UNUSED}
	set_instance_parameter_value iopll_0 {gui_ps_units0} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units1} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units10} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units11} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units12} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units13} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units14} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units15} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units16} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units17} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units2} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units3} {degrees}
	set_instance_parameter_value iopll_0 {gui_ps_units4} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units5} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units6} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units7} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units8} {ps}
	set_instance_parameter_value iopll_0 {gui_ps_units9} {ps}
	set_instance_parameter_value iopll_0 {gui_refclk1_frequency} {100.0}
	set_instance_parameter_value iopll_0 {gui_refclk_might_change} {0}
	set_instance_parameter_value iopll_0 {gui_refclk_switch} {0}
	set_instance_parameter_value iopll_0 {gui_reference_clock_frequency} {100.0}
	set_instance_parameter_value iopll_0 {gui_reference_clock_frequency_ps} {10000.0}
	set_instance_parameter_value iopll_0 {gui_simulation_type} {0}
	set_instance_parameter_value iopll_0 {gui_skip_sdc_generation} {0}
	set_instance_parameter_value iopll_0 {gui_switchover_delay} {0}
	set_instance_parameter_value iopll_0 {gui_switchover_mode} {Automatic Switchover}
	set_instance_parameter_value iopll_0 {gui_use_NDFB_modes} {0}
	set_instance_parameter_value iopll_0 {gui_use_coreclk} {1}
	set_instance_parameter_value iopll_0 {gui_use_locked} {1}
	set_instance_parameter_value iopll_0 {gui_use_logical} {0}
	set_instance_parameter_value iopll_0 {gui_user_base_address} {0}
	set_instance_parameter_value iopll_0 {gui_usr_device_speed_grade} {1}
	set_instance_parameter_value iopll_0 {gui_vco_frequency} {1250.0}
	set_instance_parameter_value iopll_0 {hp_qsys_scripting_mode} {0}
	set_instance_parameter_value iopll_0 {system_info_device_iobank_rev} {}
	set_instance_property iopll_0 AUTO_EXPORT true

	# add wirelevel expressions

	# preserve ports for debug

	# add the exports
	set_interface_property refclk EXPORT_OF iopll_0.refclk
	set_interface_property locked EXPORT_OF iopll_0.locked
	set_interface_property reset EXPORT_OF iopll_0.reset
	set_interface_property outclk0 EXPORT_OF iopll_0.outclk0
	set_interface_property outclk1 EXPORT_OF iopll_0.outclk1
	set_interface_property outclk2 EXPORT_OF iopll_0.outclk2
	set_interface_property outclk3 EXPORT_OF iopll_0.outclk3
	set_interface_property outclk4 EXPORT_OF iopll_0.outclk4

	# set values for exposed HDL parameters

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="iopll_0">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {io_pll.ip}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {io_pll}

	# save the system
	sync_sysinfo_parameters
	save_system io_pll
}

proc do_set_exported_interface_sysinfo_parameters {} {
}

# create all the systems, from bottom up
do_create_io_pll

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
