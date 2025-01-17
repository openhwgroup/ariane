# Quartus Pro License required to use this file
package require -exact qsys 24.1

# create the system "interconnect"
proc do_create_interconnect {} {
	# create the system
	create_system interconnect
	set_project_property BOARD {default}
	set_project_property DEVICE {AGFB014R24B2E2V}
	set_project_property DEVICE_FAMILY {Agilex 7}
	set_project_property HIDE_FROM_IP_CATALOG {false}
	set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	add_component axi_bridge_0 ip/interconnect/interconnect_axi_bridge_0.ip altera_axi_bridge axi_bridge_0 19.4.0
	load_component axi_bridge_0
	set_component_parameter_value ACE_LITE_SUPPORT {0}
	set_component_parameter_value ADDR_WIDTH {64}
	set_component_parameter_value AXI_VERSION {AXI4}
	set_component_parameter_value BACKPRESSURE_DURING_RESET {0}
	set_component_parameter_value COMBINED_ACCEPTANCE_CAPABILITY {16}
	set_component_parameter_value COMBINED_ISSUING_CAPABILITY {16}
	set_component_parameter_value DATA_WIDTH {64}
	set_component_parameter_value ENABLE_CONCURRENT_SUBORDINATE_ACCESS {0}
	set_component_parameter_value ENABLE_OOO {0}
	set_component_parameter_value M0_ID_WIDTH {8}
	set_component_parameter_value NO_REPEATED_IDS_BETWEEN_SUBORDINATES {0}
	set_component_parameter_value READ_ACCEPTANCE_CAPABILITY {16}
	set_component_parameter_value READ_ADDR_USER_WIDTH {32}
	set_component_parameter_value READ_DATA_REORDERING_DEPTH {1}
	set_component_parameter_value READ_DATA_USER_WIDTH {32}
	set_component_parameter_value READ_ISSUING_CAPABILITY {16}
	set_component_parameter_value S0_ID_WIDTH {8}
	set_component_parameter_value SYNC_RESET {0}
	set_component_parameter_value USE_M0_ARBURST {1}
	set_component_parameter_value USE_M0_ARCACHE {1}
	set_component_parameter_value USE_M0_ARID {1}
	set_component_parameter_value USE_M0_ARLEN {1}
	set_component_parameter_value USE_M0_ARLOCK {1}
	set_component_parameter_value USE_M0_ARQOS {0}
	set_component_parameter_value USE_M0_ARREGION {0}
	set_component_parameter_value USE_M0_ARSIZE {1}
	set_component_parameter_value USE_M0_ARUSER {0}
	set_component_parameter_value USE_M0_AWBURST {1}
	set_component_parameter_value USE_M0_AWCACHE {1}
	set_component_parameter_value USE_M0_AWID {1}
	set_component_parameter_value USE_M0_AWLEN {1}
	set_component_parameter_value USE_M0_AWLOCK {1}
	set_component_parameter_value USE_M0_AWQOS {0}
	set_component_parameter_value USE_M0_AWREGION {0}
	set_component_parameter_value USE_M0_AWSIZE {1}
	set_component_parameter_value USE_M0_AWUSER {0}
	set_component_parameter_value USE_M0_BID {1}
	set_component_parameter_value USE_M0_BRESP {1}
	set_component_parameter_value USE_M0_BUSER {0}
	set_component_parameter_value USE_M0_RID {1}
	set_component_parameter_value USE_M0_RLAST {1}
	set_component_parameter_value USE_M0_RRESP {1}
	set_component_parameter_value USE_M0_RUSER {0}
	set_component_parameter_value USE_M0_WSTRB {1}
	set_component_parameter_value USE_M0_WUSER {0}
	set_component_parameter_value USE_PIPELINE {1}
	set_component_parameter_value USE_S0_ARCACHE {1}
	set_component_parameter_value USE_S0_ARLOCK {1}
	set_component_parameter_value USE_S0_ARPROT {1}
	set_component_parameter_value USE_S0_ARQOS {0}
	set_component_parameter_value USE_S0_ARREGION {0}
	set_component_parameter_value USE_S0_ARUSER {0}
	set_component_parameter_value USE_S0_AWCACHE {1}
	set_component_parameter_value USE_S0_AWLOCK {1}
	set_component_parameter_value USE_S0_AWPROT {1}
	set_component_parameter_value USE_S0_AWQOS {0}
	set_component_parameter_value USE_S0_AWREGION {0}
	set_component_parameter_value USE_S0_AWUSER {0}
	set_component_parameter_value USE_S0_BRESP {1}
	set_component_parameter_value USE_S0_BUSER {0}
	set_component_parameter_value USE_S0_RRESP {1}
	set_component_parameter_value USE_S0_RUSER {0}
	set_component_parameter_value USE_S0_WLAST {1}
	set_component_parameter_value USE_S0_WUSER {0}
	set_component_parameter_value WRITE_ACCEPTANCE_CAPABILITY {16}
	set_component_parameter_value WRITE_ADDR_USER_WIDTH {32}
	set_component_parameter_value WRITE_DATA_USER_WIDTH {32}
	set_component_parameter_value WRITE_ISSUING_CAPABILITY {16}
	set_component_parameter_value WRITE_RESP_USER_WIDTH {32}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation axi_bridge_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.dts.compatible {simple-bus}
	set_instantiation_assignment_value embeddedsw.dts.group {bridge}
	set_instantiation_assignment_value embeddedsw.dts.name {bridge}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk aclk clk 1 STD_LOGIC Input
	add_instantiation_interface clk_reset reset INPUT
	set_instantiation_interface_parameter_value clk_reset associatedClock {clk}
	set_instantiation_interface_parameter_value clk_reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port clk_reset aresetn reset_n 1 STD_LOGIC Input
	add_instantiation_interface s0 axi4 INPUT
	set_instantiation_interface_parameter_value s0 associatedClock {clk}
	set_instantiation_interface_parameter_value s0 associatedReset {clk_reset}
	set_instantiation_interface_parameter_value s0 bridgesToMaster {m0}
	set_instantiation_interface_parameter_value s0 combinedAcceptanceCapability {16}
	set_instantiation_interface_parameter_value s0 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s0 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureType {3}
	set_instantiation_interface_parameter_value s0 dfhGroupId {0}
	set_instantiation_interface_parameter_value s0 dfhParameterData {}
	set_instantiation_interface_parameter_value s0 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s0 dfhParameterId {}
	set_instantiation_interface_parameter_value s0 dfhParameterName {}
	set_instantiation_interface_parameter_value s0 dfhParameterVersion {}
	set_instantiation_interface_parameter_value s0 maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value s0 maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value s0 maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value s0 poison {false}
	set_instantiation_interface_parameter_value s0 readAcceptanceCapability {16}
	set_instantiation_interface_parameter_value s0 readDataReorderingDepth {1}
	set_instantiation_interface_parameter_value s0 traceSignals {false}
	set_instantiation_interface_parameter_value s0 trustzoneAware {true}
	set_instantiation_interface_parameter_value s0 uniqueIdSupport {false}
	set_instantiation_interface_parameter_value s0 wakeupSignals {false}
	set_instantiation_interface_parameter_value s0 writeAcceptanceCapability {16}
	set_instantiation_interface_sysinfo_parameter_value s0 address_map {}
	set_instantiation_interface_sysinfo_parameter_value s0 address_width {}
	set_instantiation_interface_sysinfo_parameter_value s0 max_slave_data_width {}
	add_instantiation_interface_port s0 s0_awid awid 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awaddr awaddr 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awlen awlen 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awsize awsize 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awburst awburst 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awlock awlock 1 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awcache awcache 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awprot awprot 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awvalid awvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_awready awready 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_wdata wdata 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_wstrb wstrb 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_wlast wlast 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_wvalid wvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_wready wready 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_bid bid 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_bresp bresp 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_bvalid bvalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_bready bready 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_arid arid 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_araddr araddr 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arlen arlen 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arsize arsize 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arburst arburst 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arlock arlock 1 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arcache arcache 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arprot arprot 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arvalid arvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_arready arready 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_rid rid 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_rdata rdata 64 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_rresp rresp 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_rlast rlast 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_rvalid rvalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_rready rready 1 STD_LOGIC Input
	add_instantiation_interface m0 axi4 OUTPUT
	set_instantiation_interface_parameter_value m0 associatedClock {clk}
	set_instantiation_interface_parameter_value m0 associatedReset {clk_reset}
	set_instantiation_interface_parameter_value m0 combinedIssuingCapability {16}
	set_instantiation_interface_parameter_value m0 issuesFIXEDBursts {true}
	set_instantiation_interface_parameter_value m0 issuesINCRBursts {true}
	set_instantiation_interface_parameter_value m0 issuesWRAPBursts {true}
	set_instantiation_interface_parameter_value m0 maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value m0 maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value m0 maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value m0 poison {false}
	set_instantiation_interface_parameter_value m0 readIssuingCapability {16}
	set_instantiation_interface_parameter_value m0 traceSignals {false}
	set_instantiation_interface_parameter_value m0 trustzoneAware {true}
	set_instantiation_interface_parameter_value m0 uniqueIdSupport {false}
	set_instantiation_interface_parameter_value m0 wakeupSignals {false}
	set_instantiation_interface_parameter_value m0 writeIssuingCapability {16}
	add_instantiation_interface_port m0 m0_awid awid 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awaddr awaddr 64 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awlen awlen 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awsize awsize 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awburst awburst 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awlock awlock 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awcache awcache 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awprot awprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awvalid awvalid 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_awready awready 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_wdata wdata 64 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_wstrb wstrb 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_wlast wlast 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_wvalid wvalid 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_wready wready 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_bid bid 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_bresp bresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_bvalid bvalid 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_bready bready 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_arid arid 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_araddr araddr 64 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arlen arlen 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arsize arsize 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arburst arburst 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arlock arlock 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arcache arcache 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arprot arprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arvalid arvalid 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_arready arready 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_rid rid 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_rdata rdata 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_rresp rresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_rlast rlast 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_rvalid rvalid 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_rready rready 1 STD_LOGIC Output
	save_instantiation
	add_component axi_bridge_1 ip/interconnect/interconnect_axi_bridge_0.ip altera_axi_bridge axi_bridge_0 19.4.0
	load_component axi_bridge_1
	set_component_parameter_value ACE_LITE_SUPPORT {0}
	set_component_parameter_value ADDR_WIDTH {64}
	set_component_parameter_value AXI_VERSION {AXI4}
	set_component_parameter_value BACKPRESSURE_DURING_RESET {0}
	set_component_parameter_value COMBINED_ACCEPTANCE_CAPABILITY {16}
	set_component_parameter_value COMBINED_ISSUING_CAPABILITY {16}
	set_component_parameter_value DATA_WIDTH {64}
	set_component_parameter_value ENABLE_CONCURRENT_SUBORDINATE_ACCESS {0}
	set_component_parameter_value ENABLE_OOO {0}
	set_component_parameter_value M0_ID_WIDTH {8}
	set_component_parameter_value NO_REPEATED_IDS_BETWEEN_SUBORDINATES {0}
	set_component_parameter_value READ_ACCEPTANCE_CAPABILITY {16}
	set_component_parameter_value READ_ADDR_USER_WIDTH {32}
	set_component_parameter_value READ_DATA_REORDERING_DEPTH {1}
	set_component_parameter_value READ_DATA_USER_WIDTH {32}
	set_component_parameter_value READ_ISSUING_CAPABILITY {16}
	set_component_parameter_value S0_ID_WIDTH {8}
	set_component_parameter_value SYNC_RESET {0}
	set_component_parameter_value USE_M0_ARBURST {1}
	set_component_parameter_value USE_M0_ARCACHE {1}
	set_component_parameter_value USE_M0_ARID {1}
	set_component_parameter_value USE_M0_ARLEN {1}
	set_component_parameter_value USE_M0_ARLOCK {1}
	set_component_parameter_value USE_M0_ARQOS {0}
	set_component_parameter_value USE_M0_ARREGION {0}
	set_component_parameter_value USE_M0_ARSIZE {1}
	set_component_parameter_value USE_M0_ARUSER {0}
	set_component_parameter_value USE_M0_AWBURST {1}
	set_component_parameter_value USE_M0_AWCACHE {1}
	set_component_parameter_value USE_M0_AWID {1}
	set_component_parameter_value USE_M0_AWLEN {1}
	set_component_parameter_value USE_M0_AWLOCK {1}
	set_component_parameter_value USE_M0_AWQOS {0}
	set_component_parameter_value USE_M0_AWREGION {0}
	set_component_parameter_value USE_M0_AWSIZE {1}
	set_component_parameter_value USE_M0_AWUSER {0}
	set_component_parameter_value USE_M0_BID {1}
	set_component_parameter_value USE_M0_BRESP {1}
	set_component_parameter_value USE_M0_BUSER {0}
	set_component_parameter_value USE_M0_RID {1}
	set_component_parameter_value USE_M0_RLAST {1}
	set_component_parameter_value USE_M0_RRESP {1}
	set_component_parameter_value USE_M0_RUSER {0}
	set_component_parameter_value USE_M0_WSTRB {1}
	set_component_parameter_value USE_M0_WUSER {0}
	set_component_parameter_value USE_PIPELINE {1}
	set_component_parameter_value USE_S0_ARCACHE {1}
	set_component_parameter_value USE_S0_ARLOCK {1}
	set_component_parameter_value USE_S0_ARPROT {1}
	set_component_parameter_value USE_S0_ARQOS {0}
	set_component_parameter_value USE_S0_ARREGION {0}
	set_component_parameter_value USE_S0_ARUSER {0}
	set_component_parameter_value USE_S0_AWCACHE {1}
	set_component_parameter_value USE_S0_AWLOCK {1}
	set_component_parameter_value USE_S0_AWPROT {1}
	set_component_parameter_value USE_S0_AWQOS {0}
	set_component_parameter_value USE_S0_AWREGION {0}
	set_component_parameter_value USE_S0_AWUSER {0}
	set_component_parameter_value USE_S0_BRESP {1}
	set_component_parameter_value USE_S0_BUSER {0}
	set_component_parameter_value USE_S0_RRESP {1}
	set_component_parameter_value USE_S0_RUSER {0}
	set_component_parameter_value USE_S0_WLAST {1}
	set_component_parameter_value USE_S0_WUSER {0}
	set_component_parameter_value WRITE_ACCEPTANCE_CAPABILITY {16}
	set_component_parameter_value WRITE_ADDR_USER_WIDTH {32}
	set_component_parameter_value WRITE_DATA_USER_WIDTH {32}
	set_component_parameter_value WRITE_ISSUING_CAPABILITY {16}
	set_component_parameter_value WRITE_RESP_USER_WIDTH {32}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation axi_bridge_1
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.dts.compatible {simple-bus}
	set_instantiation_assignment_value embeddedsw.dts.group {bridge}
	set_instantiation_assignment_value embeddedsw.dts.name {bridge}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk aclk clk 1 STD_LOGIC Input
	add_instantiation_interface clk_reset reset INPUT
	set_instantiation_interface_parameter_value clk_reset associatedClock {clk}
	set_instantiation_interface_parameter_value clk_reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port clk_reset aresetn reset_n 1 STD_LOGIC Input
	add_instantiation_interface s0 axi4 INPUT
	set_instantiation_interface_parameter_value s0 associatedClock {clk}
	set_instantiation_interface_parameter_value s0 associatedReset {clk_reset}
	set_instantiation_interface_parameter_value s0 bridgesToMaster {m0}
	set_instantiation_interface_parameter_value s0 combinedAcceptanceCapability {16}
	set_instantiation_interface_parameter_value s0 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureId {35}
	set_instantiation_interface_parameter_value s0 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value s0 dfhFeatureType {3}
	set_instantiation_interface_parameter_value s0 dfhGroupId {0}
	set_instantiation_interface_parameter_value s0 dfhParameterData {}
	set_instantiation_interface_parameter_value s0 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value s0 dfhParameterId {}
	set_instantiation_interface_parameter_value s0 dfhParameterName {}
	set_instantiation_interface_parameter_value s0 dfhParameterVersion {}
	set_instantiation_interface_parameter_value s0 maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value s0 maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value s0 maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value s0 poison {false}
	set_instantiation_interface_parameter_value s0 readAcceptanceCapability {16}
	set_instantiation_interface_parameter_value s0 readDataReorderingDepth {1}
	set_instantiation_interface_parameter_value s0 traceSignals {false}
	set_instantiation_interface_parameter_value s0 trustzoneAware {true}
	set_instantiation_interface_parameter_value s0 uniqueIdSupport {false}
	set_instantiation_interface_parameter_value s0 wakeupSignals {false}
	set_instantiation_interface_parameter_value s0 writeAcceptanceCapability {16}
	set_instantiation_interface_sysinfo_parameter_value s0 address_map {}
	set_instantiation_interface_sysinfo_parameter_value s0 address_width {}
	set_instantiation_interface_sysinfo_parameter_value s0 max_slave_data_width {}
	add_instantiation_interface_port s0 s0_awid awid 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awaddr awaddr 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awlen awlen 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awsize awsize 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awburst awburst 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awlock awlock 1 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awcache awcache 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awprot awprot 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_awvalid awvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_awready awready 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_wdata wdata 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_wstrb wstrb 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_wlast wlast 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_wvalid wvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_wready wready 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_bid bid 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_bresp bresp 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_bvalid bvalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_bready bready 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_arid arid 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_araddr araddr 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arlen arlen 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arsize arsize 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arburst arburst 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arlock arlock 1 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arcache arcache 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arprot arprot 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port s0 s0_arvalid arvalid 1 STD_LOGIC Input
	add_instantiation_interface_port s0 s0_arready arready 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_rid rid 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_rdata rdata 64 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_rresp rresp 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port s0 s0_rlast rlast 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_rvalid rvalid 1 STD_LOGIC Output
	add_instantiation_interface_port s0 s0_rready rready 1 STD_LOGIC Input
	add_instantiation_interface m0 axi4 OUTPUT
	set_instantiation_interface_parameter_value m0 associatedClock {clk}
	set_instantiation_interface_parameter_value m0 associatedReset {clk_reset}
	set_instantiation_interface_parameter_value m0 combinedIssuingCapability {16}
	set_instantiation_interface_parameter_value m0 issuesFIXEDBursts {true}
	set_instantiation_interface_parameter_value m0 issuesINCRBursts {true}
	set_instantiation_interface_parameter_value m0 issuesWRAPBursts {true}
	set_instantiation_interface_parameter_value m0 maximumOutstandingReads {1}
	set_instantiation_interface_parameter_value m0 maximumOutstandingTransactions {1}
	set_instantiation_interface_parameter_value m0 maximumOutstandingWrites {1}
	set_instantiation_interface_parameter_value m0 poison {false}
	set_instantiation_interface_parameter_value m0 readIssuingCapability {16}
	set_instantiation_interface_parameter_value m0 traceSignals {false}
	set_instantiation_interface_parameter_value m0 trustzoneAware {true}
	set_instantiation_interface_parameter_value m0 uniqueIdSupport {false}
	set_instantiation_interface_parameter_value m0 wakeupSignals {false}
	set_instantiation_interface_parameter_value m0 writeIssuingCapability {16}
	add_instantiation_interface_port m0 m0_awid awid 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awaddr awaddr 64 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awlen awlen 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awsize awsize 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awburst awburst 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awlock awlock 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awcache awcache 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awprot awprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_awvalid awvalid 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_awready awready 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_wdata wdata 64 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_wstrb wstrb 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_wlast wlast 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_wvalid wvalid 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_wready wready 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_bid bid 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_bresp bresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_bvalid bvalid 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_bready bready 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_arid arid 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_araddr araddr 64 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arlen arlen 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arsize arsize 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arburst arburst 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arlock arlock 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arcache arcache 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arprot arprot 3 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port m0 m0_arvalid arvalid 1 STD_LOGIC Output
	add_instantiation_interface_port m0 m0_arready arready 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_rid rid 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_rdata rdata 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_rresp rresp 2 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port m0 m0_rlast rlast 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_rvalid rvalid 1 STD_LOGIC Input
	add_instantiation_interface_port m0 m0_rready rready 1 STD_LOGIC Output
	save_instantiation
	add_component emif_cal_0 intel/emif_cal.ip altera_emif_cal emif_cal_0 2.7.4
	load_component emif_cal_0
	set_component_parameter_value AXM_ID_NUM {0}
	set_component_parameter_value DIAG_ENABLE_JTAG_UART {0}
	set_component_parameter_value DIAG_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_DISABLED}
	set_component_parameter_value DIAG_EXPORT_VJI {0}
	set_component_parameter_value DIAG_EXTRA_CONFIGS {}
	set_component_parameter_value DIAG_SIM_CAL_MODE_ENUM {SIM_CAL_MODE_SKIP}
	set_component_parameter_value DIAG_SIM_VERBOSE {0}
	set_component_parameter_value DIAG_SYNTH_FOR_SIM {0}
	set_component_parameter_value ENABLE_DDRT {0}
	set_component_parameter_value NUM_CALBUS_INTERFACE {1}
	set_component_parameter_value PHY_DDRT_EXPORT_CLK_STP_IF {0}
	set_component_parameter_value SHORT_QSYS_INTERFACE_NAMES {1}
	set_component_project_property HIDE_FROM_IP_CATALOG {true}
	save_component
	load_instantiation emif_cal_0
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface emif_calbus_0 conduit INPUT
	set_instantiation_interface_parameter_value emif_calbus_0 associatedClock {emif_calbus_clk}
	set_instantiation_interface_parameter_value emif_calbus_0 associatedReset {}
	set_instantiation_interface_parameter_value emif_calbus_0 prSafe {false}
	add_instantiation_interface_port emif_calbus_0 calbus_read_0 calbus_read 1 STD_LOGIC Output
	add_instantiation_interface_port emif_calbus_0 calbus_write_0 calbus_write 1 STD_LOGIC Output
	add_instantiation_interface_port emif_calbus_0 calbus_address_0 calbus_address 20 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port emif_calbus_0 calbus_wdata_0 calbus_wdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port emif_calbus_0 calbus_rdata_0 calbus_rdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port emif_calbus_0 calbus_seq_param_tbl_0 calbus_seq_param_tbl 4096 STD_LOGIC_VECTOR Input
	add_instantiation_interface emif_calbus_clk clock OUTPUT
	set_instantiation_interface_parameter_value emif_calbus_clk associatedDirectClock {}
	set_instantiation_interface_parameter_value emif_calbus_clk clockRate {0}
	set_instantiation_interface_parameter_value emif_calbus_clk clockRateKnown {false}
	set_instantiation_interface_parameter_value emif_calbus_clk externallyDriven {false}
	set_instantiation_interface_parameter_value emif_calbus_clk ptfSchematicName {}
	set_instantiation_interface_sysinfo_parameter_value emif_calbus_clk clock_rate {0}
	add_instantiation_interface_port emif_calbus_clk calbus_clk clk 1 STD_LOGIC Output
	save_instantiation
	add_component emif_fm_0 intel/ed_synth_emif_fm_0.ip altera_emif_fm emif_fm_0 2.7.4
	load_component emif_fm_0
	set_component_parameter_value BOARD_DDR3_AC_TO_CK_SKEW_NS {0.0}
	set_component_parameter_value BOARD_DDR3_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_DDR3_BRD_SKEW_WITHIN_DQS_NS {0.02}
	set_component_parameter_value BOARD_DDR3_DQS_TO_CK_SKEW_NS {0.02}
	set_component_parameter_value BOARD_DDR3_IS_SKEW_WITHIN_AC_DESKEWED {1}
	set_component_parameter_value BOARD_DDR3_IS_SKEW_WITHIN_DQS_DESKEWED {0}
	set_component_parameter_value BOARD_DDR3_MAX_CK_DELAY_NS {0.6}
	set_component_parameter_value BOARD_DDR3_MAX_DQS_DELAY_NS {0.6}
	set_component_parameter_value BOARD_DDR3_PKG_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_DDR3_PKG_BRD_SKEW_WITHIN_DQS_NS {0.02}
	set_component_parameter_value BOARD_DDR3_SKEW_BETWEEN_DIMMS_NS {0.05}
	set_component_parameter_value BOARD_DDR3_SKEW_BETWEEN_DQS_NS {0.02}
	set_component_parameter_value BOARD_DDR3_USER_AC_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDR3_USER_AC_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_DDR3_USER_CK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_DDR3_USER_RCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDR3_USER_RCLK_SLEW_RATE {5.0}
	set_component_parameter_value BOARD_DDR3_USER_RDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDR3_USER_RDATA_SLEW_RATE {2.5}
	set_component_parameter_value BOARD_DDR3_USER_WCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDR3_USER_WCLK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_DDR3_USER_WDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDR3_USER_WDATA_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_DDR3_USE_DEFAULT_ISI_VALUES {1}
	set_component_parameter_value BOARD_DDR3_USE_DEFAULT_SLEW_RATES {1}
	set_component_parameter_value BOARD_DDR4_AC_TO_CK_SKEW_NS {0.0}
	set_component_parameter_value BOARD_DDR4_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_DDR4_BRD_SKEW_WITHIN_DQS_NS {0.02}
	set_component_parameter_value BOARD_DDR4_DQS_TO_CK_SKEW_NS {0.02}
	set_component_parameter_value BOARD_DDR4_IS_SKEW_WITHIN_AC_DESKEWED {0}
	set_component_parameter_value BOARD_DDR4_IS_SKEW_WITHIN_DQS_DESKEWED {1}
	set_component_parameter_value BOARD_DDR4_MAX_CK_DELAY_NS {0.6}
	set_component_parameter_value BOARD_DDR4_MAX_DQS_DELAY_NS {0.6}
	set_component_parameter_value BOARD_DDR4_PKG_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_DDR4_PKG_BRD_SKEW_WITHIN_DQS_NS {0.02}
	set_component_parameter_value BOARD_DDR4_SKEW_BETWEEN_DIMMS_NS {0.05}
	set_component_parameter_value BOARD_DDR4_SKEW_BETWEEN_DQS_NS {0.02}
	set_component_parameter_value BOARD_DDR4_USER_AC_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDR4_USER_AC_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_DDR4_USER_CK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_DDR4_USER_RCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDR4_USER_RCLK_SLEW_RATE {8.0}
	set_component_parameter_value BOARD_DDR4_USER_RDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDR4_USER_RDATA_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_DDR4_USER_WCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDR4_USER_WCLK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_DDR4_USER_WDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDR4_USER_WDATA_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_DDR4_USE_DEFAULT_ISI_VALUES {1}
	set_component_parameter_value BOARD_DDR4_USE_DEFAULT_SLEW_RATES {1}
	set_component_parameter_value BOARD_DDRT_AC_TO_CK_SKEW_NS {0.0}
	set_component_parameter_value BOARD_DDRT_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_DDRT_BRD_SKEW_WITHIN_DQS_NS {0.02}
	set_component_parameter_value BOARD_DDRT_DQS_TO_CK_SKEW_NS {0.02}
	set_component_parameter_value BOARD_DDRT_IS_SKEW_WITHIN_AC_DESKEWED {0}
	set_component_parameter_value BOARD_DDRT_IS_SKEW_WITHIN_DQS_DESKEWED {1}
	set_component_parameter_value BOARD_DDRT_MAX_CK_DELAY_NS {0.6}
	set_component_parameter_value BOARD_DDRT_MAX_DQS_DELAY_NS {0.6}
	set_component_parameter_value BOARD_DDRT_PKG_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_DDRT_PKG_BRD_SKEW_WITHIN_DQS_NS {0.02}
	set_component_parameter_value BOARD_DDRT_SKEW_BETWEEN_DIMMS_NS {0.05}
	set_component_parameter_value BOARD_DDRT_SKEW_BETWEEN_DQS_NS {0.02}
	set_component_parameter_value BOARD_DDRT_USER_AC_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDRT_USER_AC_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_DDRT_USER_CK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_DDRT_USER_RCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDRT_USER_RCLK_SLEW_RATE {8.0}
	set_component_parameter_value BOARD_DDRT_USER_RDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDRT_USER_RDATA_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_DDRT_USER_WCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDRT_USER_WCLK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_DDRT_USER_WDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_DDRT_USER_WDATA_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_DDRT_USE_DEFAULT_ISI_VALUES {1}
	set_component_parameter_value BOARD_DDRT_USE_DEFAULT_SLEW_RATES {1}
	set_component_parameter_value BOARD_LPDDR3_AC_TO_CK_SKEW_NS {0.0}
	set_component_parameter_value BOARD_LPDDR3_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_LPDDR3_BRD_SKEW_WITHIN_DQS_NS {0.02}
	set_component_parameter_value BOARD_LPDDR3_DQS_TO_CK_SKEW_NS {0.02}
	set_component_parameter_value BOARD_LPDDR3_IS_SKEW_WITHIN_AC_DESKEWED {1}
	set_component_parameter_value BOARD_LPDDR3_IS_SKEW_WITHIN_DQS_DESKEWED {0}
	set_component_parameter_value BOARD_LPDDR3_MAX_CK_DELAY_NS {0.6}
	set_component_parameter_value BOARD_LPDDR3_MAX_DQS_DELAY_NS {0.6}
	set_component_parameter_value BOARD_LPDDR3_PKG_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_LPDDR3_PKG_BRD_SKEW_WITHIN_DQS_NS {0.02}
	set_component_parameter_value BOARD_LPDDR3_SKEW_BETWEEN_DIMMS_NS {0.05}
	set_component_parameter_value BOARD_LPDDR3_SKEW_BETWEEN_DQS_NS {0.02}
	set_component_parameter_value BOARD_LPDDR3_USER_AC_ISI_NS {0.0}
	set_component_parameter_value BOARD_LPDDR3_USER_AC_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_LPDDR3_USER_CK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_LPDDR3_USER_RCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_LPDDR3_USER_RCLK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_LPDDR3_USER_RDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_LPDDR3_USER_RDATA_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_LPDDR3_USER_WCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_LPDDR3_USER_WCLK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_LPDDR3_USER_WDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_LPDDR3_USER_WDATA_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_LPDDR3_USE_DEFAULT_ISI_VALUES {1}
	set_component_parameter_value BOARD_LPDDR3_USE_DEFAULT_SLEW_RATES {1}
	set_component_parameter_value BOARD_QDR2_AC_TO_K_SKEW_NS {0.0}
	set_component_parameter_value BOARD_QDR2_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_QDR2_BRD_SKEW_WITHIN_D_NS {0.02}
	set_component_parameter_value BOARD_QDR2_BRD_SKEW_WITHIN_Q_NS {0.02}
	set_component_parameter_value BOARD_QDR2_IS_SKEW_WITHIN_AC_DESKEWED {1}
	set_component_parameter_value BOARD_QDR2_IS_SKEW_WITHIN_D_DESKEWED {0}
	set_component_parameter_value BOARD_QDR2_IS_SKEW_WITHIN_Q_DESKEWED {0}
	set_component_parameter_value BOARD_QDR2_MAX_K_DELAY_NS {0.6}
	set_component_parameter_value BOARD_QDR2_PKG_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_QDR2_PKG_BRD_SKEW_WITHIN_D_NS {0.02}
	set_component_parameter_value BOARD_QDR2_PKG_BRD_SKEW_WITHIN_Q_NS {0.02}
	set_component_parameter_value BOARD_QDR2_USER_AC_ISI_NS {0.0}
	set_component_parameter_value BOARD_QDR2_USER_AC_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_QDR2_USER_K_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_QDR2_USER_RCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_QDR2_USER_RCLK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_QDR2_USER_RDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_QDR2_USER_RDATA_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_QDR2_USER_WCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_QDR2_USER_WDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_QDR2_USER_WDATA_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_QDR2_USE_DEFAULT_ISI_VALUES {1}
	set_component_parameter_value BOARD_QDR2_USE_DEFAULT_SLEW_RATES {1}
	set_component_parameter_value BOARD_QDR4_AC_TO_CK_SKEW_NS {0.0}
	set_component_parameter_value BOARD_QDR4_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_QDR4_BRD_SKEW_WITHIN_QK_NS {0.02}
	set_component_parameter_value BOARD_QDR4_DK_TO_CK_SKEW_NS {-0.02}
	set_component_parameter_value BOARD_QDR4_IS_SKEW_WITHIN_AC_DESKEWED {1}
	set_component_parameter_value BOARD_QDR4_IS_SKEW_WITHIN_QK_DESKEWED {1}
	set_component_parameter_value BOARD_QDR4_MAX_CK_DELAY_NS {0.6}
	set_component_parameter_value BOARD_QDR4_MAX_DK_DELAY_NS {0.6}
	set_component_parameter_value BOARD_QDR4_PKG_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_QDR4_PKG_BRD_SKEW_WITHIN_QK_NS {0.02}
	set_component_parameter_value BOARD_QDR4_SKEW_BETWEEN_DIMMS_NS {0.05}
	set_component_parameter_value BOARD_QDR4_SKEW_BETWEEN_DK_NS {0.02}
	set_component_parameter_value BOARD_QDR4_USER_AC_ISI_NS {0.0}
	set_component_parameter_value BOARD_QDR4_USER_AC_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_QDR4_USER_CK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_QDR4_USER_RCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_QDR4_USER_RCLK_SLEW_RATE {5.0}
	set_component_parameter_value BOARD_QDR4_USER_RDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_QDR4_USER_RDATA_SLEW_RATE {2.5}
	set_component_parameter_value BOARD_QDR4_USER_WCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_QDR4_USER_WCLK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_QDR4_USER_WDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_QDR4_USER_WDATA_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_QDR4_USE_DEFAULT_ISI_VALUES {1}
	set_component_parameter_value BOARD_QDR4_USE_DEFAULT_SLEW_RATES {1}
	set_component_parameter_value BOARD_RLD3_AC_TO_CK_SKEW_NS {0.0}
	set_component_parameter_value BOARD_RLD3_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_RLD3_BRD_SKEW_WITHIN_QK_NS {0.02}
	set_component_parameter_value BOARD_RLD3_DK_TO_CK_SKEW_NS {-0.02}
	set_component_parameter_value BOARD_RLD3_IS_SKEW_WITHIN_AC_DESKEWED {1}
	set_component_parameter_value BOARD_RLD3_IS_SKEW_WITHIN_QK_DESKEWED {0}
	set_component_parameter_value BOARD_RLD3_MAX_CK_DELAY_NS {0.6}
	set_component_parameter_value BOARD_RLD3_MAX_DK_DELAY_NS {0.6}
	set_component_parameter_value BOARD_RLD3_PKG_BRD_SKEW_WITHIN_AC_NS {0.02}
	set_component_parameter_value BOARD_RLD3_PKG_BRD_SKEW_WITHIN_QK_NS {0.02}
	set_component_parameter_value BOARD_RLD3_SKEW_BETWEEN_DIMMS_NS {0.05}
	set_component_parameter_value BOARD_RLD3_SKEW_BETWEEN_DK_NS {0.02}
	set_component_parameter_value BOARD_RLD3_USER_AC_ISI_NS {0.0}
	set_component_parameter_value BOARD_RLD3_USER_AC_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_RLD3_USER_CK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_RLD3_USER_RCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_RLD3_USER_RCLK_SLEW_RATE {7.0}
	set_component_parameter_value BOARD_RLD3_USER_RDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_RLD3_USER_RDATA_SLEW_RATE {3.5}
	set_component_parameter_value BOARD_RLD3_USER_WCLK_ISI_NS {0.0}
	set_component_parameter_value BOARD_RLD3_USER_WCLK_SLEW_RATE {4.0}
	set_component_parameter_value BOARD_RLD3_USER_WDATA_ISI_NS {0.0}
	set_component_parameter_value BOARD_RLD3_USER_WDATA_SLEW_RATE {2.0}
	set_component_parameter_value BOARD_RLD3_USE_DEFAULT_ISI_VALUES {1}
	set_component_parameter_value BOARD_RLD3_USE_DEFAULT_SLEW_RATES {1}
	set_component_parameter_value CTRL_DDR3_ADDR_ORDER_ENUM {DDR3_CTRL_ADDR_ORDER_CS_R_B_C}
	set_component_parameter_value CTRL_DDR3_AUTO_POWER_DOWN_CYCS {32}
	set_component_parameter_value CTRL_DDR3_AUTO_POWER_DOWN_EN {0}
	set_component_parameter_value CTRL_DDR3_AUTO_PRECHARGE_EN {0}
	set_component_parameter_value CTRL_DDR3_AVL_PROTOCOL_ENUM {CTRL_AVL_PROTOCOL_MM}
	set_component_parameter_value CTRL_DDR3_ECC_AUTO_CORRECTION_EN {0}
	set_component_parameter_value CTRL_DDR3_ECC_EN {0}
	set_component_parameter_value CTRL_DDR3_ECC_READDATAERROR_EN {1}
	set_component_parameter_value CTRL_DDR3_ECC_STATUS_EN {0}
	set_component_parameter_value CTRL_DDR3_MMR_EN {0}
	set_component_parameter_value CTRL_DDR3_RD_TO_RD_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR3_RD_TO_WR_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR3_RD_TO_WR_SAME_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR3_REORDER_EN {1}
	set_component_parameter_value CTRL_DDR3_SELF_REFRESH_EN {0}
	set_component_parameter_value CTRL_DDR3_STARVE_LIMIT {10}
	set_component_parameter_value CTRL_DDR3_USER_PRIORITY_EN {0}
	set_component_parameter_value CTRL_DDR3_USER_REFRESH_EN {0}
	set_component_parameter_value CTRL_DDR3_WR_TO_RD_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR3_WR_TO_RD_SAME_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR3_WR_TO_WR_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR4_ADDR_ORDER_ENUM {DDR4_CTRL_ADDR_ORDER_CS_R_B_C_BG}
	set_component_parameter_value CTRL_DDR4_AUTO_POWER_DOWN_CYCS {32}
	set_component_parameter_value CTRL_DDR4_AUTO_POWER_DOWN_EN {0}
	set_component_parameter_value CTRL_DDR4_AUTO_PRECHARGE_EN {0}
	set_component_parameter_value CTRL_DDR4_AVL_PROTOCOL_ENUM {CTRL_AVL_PROTOCOL_MM}
	set_component_parameter_value CTRL_DDR4_ECC_AUTO_CORRECTION_EN {0}
	set_component_parameter_value CTRL_DDR4_ECC_EN {1}
	set_component_parameter_value CTRL_DDR4_ECC_READDATAERROR_EN {0}
	set_component_parameter_value CTRL_DDR4_ECC_STATUS_EN {0}
	set_component_parameter_value CTRL_DDR4_MAJOR_MODE_EN {0}
	set_component_parameter_value CTRL_DDR4_MMR_EN {0}
	set_component_parameter_value CTRL_DDR4_POST_REFRESH_EN {1}
	set_component_parameter_value CTRL_DDR4_POST_REFRESH_LOWER_LIMIT {0}
	set_component_parameter_value CTRL_DDR4_POST_REFRESH_UPPER_LIMIT {2}
	set_component_parameter_value CTRL_DDR4_PRE_REFRESH_EN {0}
	set_component_parameter_value CTRL_DDR4_PRE_REFRESH_UPPER_LIMIT {1}
	set_component_parameter_value CTRL_DDR4_RD_TO_RD_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR4_RD_TO_WR_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR4_RD_TO_WR_SAME_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR4_REORDER_EN {1}
	set_component_parameter_value CTRL_DDR4_SELF_REFRESH_EN {0}
	set_component_parameter_value CTRL_DDR4_STARVE_LIMIT {10}
	set_component_parameter_value CTRL_DDR4_USER_PRIORITY_EN {0}
	set_component_parameter_value CTRL_DDR4_USER_REFRESH_EN {0}
	set_component_parameter_value CTRL_DDR4_WR_TO_RD_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR4_WR_TO_RD_SAME_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDR4_WR_TO_WR_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDRT_ADDR_INTERLEAVING {COARSE}
	set_component_parameter_value CTRL_DDRT_ADDR_ORDER_ENUM {DDRT_CTRL_ADDR_ORDER_CS_R_B_C_BG}
	set_component_parameter_value CTRL_DDRT_AUTO_POWER_DOWN_CYCS {32}
	set_component_parameter_value CTRL_DDRT_AUTO_POWER_DOWN_EN {0}
	set_component_parameter_value CTRL_DDRT_AUTO_PRECHARGE_EN {0}
	set_component_parameter_value CTRL_DDRT_AVL_PROTOCOL_ENUM {CTRL_AVL_PROTOCOL_MM}
	set_component_parameter_value CTRL_DDRT_DIMM_DENSITY {128}
	set_component_parameter_value CTRL_DDRT_DIMM_VIRAL_FLOW_EN {0}
	set_component_parameter_value CTRL_DDRT_ECC_AUTO_CORRECTION_EN {0}
	set_component_parameter_value CTRL_DDRT_ECC_EN {0}
	set_component_parameter_value CTRL_DDRT_ECC_READDATAERROR_EN {1}
	set_component_parameter_value CTRL_DDRT_ECC_STATUS_EN {1}
	set_component_parameter_value CTRL_DDRT_ERR_INJECT_EN {0}
	set_component_parameter_value CTRL_DDRT_ERR_REPLAY_EN {0}
	set_component_parameter_value CTRL_DDRT_EXT_ERR_INJECT_EN {0}
	set_component_parameter_value CTRL_DDRT_GNT_TO_GNT_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDRT_GNT_TO_WR_DIFF_CHIP_DELTA_CYCS {1}
	set_component_parameter_value CTRL_DDRT_GNT_TO_WR_SAME_CHIP_DELTA_CYCS {1}
	set_component_parameter_value CTRL_DDRT_HOST_VIRAL_FLOW_EN {0}
	set_component_parameter_value CTRL_DDRT_MMR_EN {0}
	set_component_parameter_value CTRL_DDRT_NUM_OF_AXIS_ID {1}
	set_component_parameter_value CTRL_DDRT_PARITY_CMD_EN {0}
	set_component_parameter_value CTRL_DDRT_PMM_ADR_FLOW_EN {0}
	set_component_parameter_value CTRL_DDRT_PMM_WPQ_FLUSH_EN {0}
	set_component_parameter_value CTRL_DDRT_POISON_DETECTION_EN {0}
	set_component_parameter_value CTRL_DDRT_PORT_AFI_C_WIDTH {2}
	set_component_parameter_value CTRL_DDRT_RD_TO_RD_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDRT_RD_TO_WR_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDRT_RD_TO_WR_SAME_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDRT_REORDER_EN {1}
	set_component_parameter_value CTRL_DDRT_SELF_REFRESH_EN {0}
	set_component_parameter_value CTRL_DDRT_STARVE_LIMIT {10}
	set_component_parameter_value CTRL_DDRT_UPI_EN {0}
	set_component_parameter_value CTRL_DDRT_UPI_ID_WIDTH {8}
	set_component_parameter_value CTRL_DDRT_USER_PRIORITY_EN {0}
	set_component_parameter_value CTRL_DDRT_USER_REFRESH_EN {0}
	set_component_parameter_value CTRL_DDRT_WR_ACK_POLICY {POSTED}
	set_component_parameter_value CTRL_DDRT_WR_TO_GNT_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDRT_WR_TO_GNT_SAME_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDRT_WR_TO_RD_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDRT_WR_TO_RD_SAME_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDRT_WR_TO_WR_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_DDRT_ZQ_INTERVAL_MS {3}
	set_component_parameter_value CTRL_LPDDR3_ADDR_ORDER_ENUM {LPDDR3_CTRL_ADDR_ORDER_CS_R_B_C}
	set_component_parameter_value CTRL_LPDDR3_AUTO_POWER_DOWN_CYCS {32}
	set_component_parameter_value CTRL_LPDDR3_AUTO_POWER_DOWN_EN {0}
	set_component_parameter_value CTRL_LPDDR3_AUTO_PRECHARGE_EN {0}
	set_component_parameter_value CTRL_LPDDR3_AVL_PROTOCOL_ENUM {CTRL_AVL_PROTOCOL_MM}
	set_component_parameter_value CTRL_LPDDR3_MMR_EN {0}
	set_component_parameter_value CTRL_LPDDR3_RD_TO_RD_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_LPDDR3_RD_TO_WR_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_LPDDR3_RD_TO_WR_SAME_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_LPDDR3_REORDER_EN {1}
	set_component_parameter_value CTRL_LPDDR3_SELF_REFRESH_EN {0}
	set_component_parameter_value CTRL_LPDDR3_STARVE_LIMIT {10}
	set_component_parameter_value CTRL_LPDDR3_USER_PRIORITY_EN {0}
	set_component_parameter_value CTRL_LPDDR3_USER_REFRESH_EN {0}
	set_component_parameter_value CTRL_LPDDR3_WR_TO_RD_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_LPDDR3_WR_TO_RD_SAME_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_LPDDR3_WR_TO_WR_DIFF_CHIP_DELTA_CYCS {0}
	set_component_parameter_value CTRL_QDR2_AVL_ENABLE_POWER_OF_TWO_BUS {0}
	set_component_parameter_value CTRL_QDR2_AVL_MAX_BURST_COUNT {4}
	set_component_parameter_value CTRL_QDR2_AVL_PROTOCOL_ENUM {CTRL_AVL_PROTOCOL_MM}
	set_component_parameter_value CTRL_QDR4_ADD_RAW_TURNAROUND_DELAY_CYC {0}
	set_component_parameter_value CTRL_QDR4_ADD_WAR_TURNAROUND_DELAY_CYC {0}
	set_component_parameter_value CTRL_QDR4_AVL_ENABLE_POWER_OF_TWO_BUS {0}
	set_component_parameter_value CTRL_QDR4_AVL_MAX_BURST_COUNT {4}
	set_component_parameter_value CTRL_QDR4_AVL_PROTOCOL_ENUM {CTRL_AVL_PROTOCOL_MM}
	set_component_parameter_value CTRL_QDR4_DEF_RAW_TURNAROUND_DELAY_CYC {4}
	set_component_parameter_value CTRL_RLD2_AVL_PROTOCOL_ENUM {CTRL_AVL_PROTOCOL_MM}
	set_component_parameter_value CTRL_RLD3_ADDR_ORDER_ENUM {RLD3_CTRL_ADDR_ORDER_CS_R_B_C}
	set_component_parameter_value CTRL_RLD3_AVL_PROTOCOL_ENUM {CTRL_AVL_PROTOCOL_MM}
	set_component_parameter_value DIAG_ADD_READY_PIPELINE {1}
	set_component_parameter_value DIAG_BOARD_DELAY_CONFIG_STR {}
	set_component_parameter_value DIAG_DB_RESET_AUTO_RELEASE {avl_release}
	set_component_parameter_value DIAG_DDR3_ABSTRACT_PHY {0}
	set_component_parameter_value DIAG_DDR3_AC_PARITY_ERR {0}
	set_component_parameter_value DIAG_DDR3_CAL_ADDR0 {0}
	set_component_parameter_value DIAG_DDR3_CAL_ADDR1 {8}
	set_component_parameter_value DIAG_DDR3_CAL_ENABLE_MICRON_AP {0}
	set_component_parameter_value DIAG_DDR3_CAL_ENABLE_NON_DES {0}
	set_component_parameter_value DIAG_DDR3_CAL_FULL_CAL_ON_RESET {1}
	set_component_parameter_value DIAG_DDR3_CA_DESKEW_EN {1}
	set_component_parameter_value DIAG_DDR3_CA_LEVEL_EN {1}
	set_component_parameter_value DIAG_DDR3_DISABLE_AFI_P2C_REGISTERS {0}
	set_component_parameter_value DIAG_DDR3_EFFICIENCY_MONITOR {EFFMON_MODE_DISABLED}
	set_component_parameter_value DIAG_DDR3_ENABLE_DEFAULT_MODE {0}
	set_component_parameter_value DIAG_DDR3_ENABLE_USER_MODE {1}
	set_component_parameter_value DIAG_DDR3_EXPORT_SEQ_AVALON_HEAD_OF_CHAIN {1}
	set_component_parameter_value DIAG_DDR3_EXPORT_SEQ_AVALON_MASTER {0}
	set_component_parameter_value DIAG_DDR3_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_DISABLED}
	set_component_parameter_value DIAG_DDR3_EXPORT_TG_CFG_AVALON_SLAVE {TG_CFG_AMM_EXPORT_MODE_EXPORT}
	set_component_parameter_value DIAG_DDR3_EX_DESIGN_ISSP_EN {1}
	set_component_parameter_value DIAG_DDR3_EX_DESIGN_NUM_OF_SLAVES {1}
	set_component_parameter_value DIAG_DDR3_EX_DESIGN_SEPARATE_RZQS {1}
	set_component_parameter_value DIAG_DDR3_INTERFACE_ID {0}
	set_component_parameter_value DIAG_DDR3_SEPARATE_READ_WRITE_ITFS {0}
	set_component_parameter_value DIAG_DDR3_SIM_CAL_MODE_ENUM {SIM_CAL_MODE_SKIP}
	set_component_parameter_value DIAG_DDR3_SIM_VERBOSE {1}
	set_component_parameter_value DIAG_DDR3_TG2_TEST_DURATION {SHORT}
	set_component_parameter_value DIAG_DDR3_USER_SIM_MEMORY_PRELOAD {0}
	set_component_parameter_value DIAG_DDR3_USER_SIM_MEMORY_PRELOAD_PRI_EMIF_FILE {EMIF_PRI_PRELOAD.txt}
	set_component_parameter_value DIAG_DDR3_USER_SIM_MEMORY_PRELOAD_SEC_EMIF_FILE {EMIF_SEC_PRELOAD.txt}
	set_component_parameter_value DIAG_DDR3_USER_USE_SIM_MEMORY_VALIDATION_TG {1}
	set_component_parameter_value DIAG_DDR3_USE_NEW_EFFMON_S10 {0}
	set_component_parameter_value DIAG_DDR3_USE_TG_AVL_2 {0}
	set_component_parameter_value DIAG_DDR3_USE_TG_HBM {0}
	set_component_parameter_value DIAG_DDR4_ABSTRACT_PHY {0}
	set_component_parameter_value DIAG_DDR4_AC_PARITY_ERR {0}
	set_component_parameter_value DIAG_DDR4_CAL_ADDR0 {0}
	set_component_parameter_value DIAG_DDR4_CAL_ADDR1 {8}
	set_component_parameter_value DIAG_DDR4_CAL_ENABLE_NON_DES {0}
	set_component_parameter_value DIAG_DDR4_CAL_FULL_CAL_ON_RESET {1}
	set_component_parameter_value DIAG_DDR4_DISABLE_AFI_P2C_REGISTERS {0}
	set_component_parameter_value DIAG_DDR4_EFFICIENCY_MONITOR {EFFMON_MODE_DISABLED}
	set_component_parameter_value DIAG_DDR4_ENABLE_DEFAULT_MODE {0}
	set_component_parameter_value DIAG_DDR4_ENABLE_USER_MODE {1}
	set_component_parameter_value DIAG_DDR4_EXPORT_SEQ_AVALON_HEAD_OF_CHAIN {1}
	set_component_parameter_value DIAG_DDR4_EXPORT_SEQ_AVALON_MASTER {0}
	set_component_parameter_value DIAG_DDR4_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_JTAG}
	set_component_parameter_value DIAG_DDR4_EXPORT_TG_CFG_AVALON_SLAVE {TG_CFG_AMM_EXPORT_MODE_EXPORT}
	set_component_parameter_value DIAG_DDR4_EX_DESIGN_ISSP_EN {1}
	set_component_parameter_value DIAG_DDR4_EX_DESIGN_NUM_OF_SLAVES {1}
	set_component_parameter_value DIAG_DDR4_EX_DESIGN_SEPARATE_RZQS {1}
	set_component_parameter_value DIAG_DDR4_INTERFACE_ID {0}
	set_component_parameter_value DIAG_DDR4_SEPARATE_READ_WRITE_ITFS {0}
	set_component_parameter_value DIAG_DDR4_SIM_CAL_MODE_ENUM {SIM_CAL_MODE_SKIP}
	set_component_parameter_value DIAG_DDR4_SIM_VERBOSE {1}
	set_component_parameter_value DIAG_DDR4_SKIP_AC_PARITY_CHECK {0}
	set_component_parameter_value DIAG_DDR4_SKIP_CA_DESKEW {0}
	set_component_parameter_value DIAG_DDR4_SKIP_CA_LEVEL {0}
	set_component_parameter_value DIAG_DDR4_SKIP_VREF_CAL {0}
	set_component_parameter_value DIAG_DDR4_TG2_TEST_DURATION {SHORT}
	set_component_parameter_value DIAG_DDR4_USER_SIM_MEMORY_PRELOAD {0}
	set_component_parameter_value DIAG_DDR4_USER_SIM_MEMORY_PRELOAD_PRI_EMIF_FILE {EMIF_PRI_PRELOAD.txt}
	set_component_parameter_value DIAG_DDR4_USER_SIM_MEMORY_PRELOAD_SEC_EMIF_FILE {EMIF_SEC_PRELOAD.txt}
	set_component_parameter_value DIAG_DDR4_USER_USE_SIM_MEMORY_VALIDATION_TG {1}
	set_component_parameter_value DIAG_DDR4_USE_NEW_EFFMON_S10 {0}
	set_component_parameter_value DIAG_DDR4_USE_TG_AVL_2 {0}
	set_component_parameter_value DIAG_DDR4_USE_TG_HBM {0}
	set_component_parameter_value DIAG_DDRT_ABSTRACT_PHY {0}
	set_component_parameter_value DIAG_DDRT_AC_PARITY_ERR {0}
	set_component_parameter_value DIAG_DDRT_CAL_ADDR0 {0}
	set_component_parameter_value DIAG_DDRT_CAL_ADDR1 {8}
	set_component_parameter_value DIAG_DDRT_CAL_ENABLE_NON_DES {0}
	set_component_parameter_value DIAG_DDRT_CAL_FULL_CAL_ON_RESET {1}
	set_component_parameter_value DIAG_DDRT_DISABLE_AFI_P2C_REGISTERS {0}
	set_component_parameter_value DIAG_DDRT_EFFICIENCY_MONITOR {EFFMON_MODE_DISABLED}
	set_component_parameter_value DIAG_DDRT_EFF_TEST {0}
	set_component_parameter_value DIAG_DDRT_ENABLE_DEFAULT_MODE {0}
	set_component_parameter_value DIAG_DDRT_ENABLE_DRIVER_MARGINING {0}
	set_component_parameter_value DIAG_DDRT_ENABLE_ENHANCED_TESTING {0}
	set_component_parameter_value DIAG_DDRT_ENABLE_USER_MODE {1}
	set_component_parameter_value DIAG_DDRT_EXPORT_SEQ_AVALON_HEAD_OF_CHAIN {1}
	set_component_parameter_value DIAG_DDRT_EXPORT_SEQ_AVALON_MASTER {0}
	set_component_parameter_value DIAG_DDRT_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_DISABLED}
	set_component_parameter_value DIAG_DDRT_EXPORT_TG_CFG_AVALON_SLAVE {TG_CFG_AMM_EXPORT_MODE_JTAG}
	set_component_parameter_value DIAG_DDRT_EX_DESIGN_ISSP_EN {1}
	set_component_parameter_value DIAG_DDRT_EX_DESIGN_NUM_OF_SLAVES {1}
	set_component_parameter_value DIAG_DDRT_EX_DESIGN_SEPARATE_RZQS {1}
	set_component_parameter_value DIAG_DDRT_INTERFACE_ID {0}
	set_component_parameter_value DIAG_DDRT_SEPARATE_READ_WRITE_ITFS {0}
	set_component_parameter_value DIAG_DDRT_SIM_CAL_MODE_ENUM {SIM_CAL_MODE_SKIP}
	set_component_parameter_value DIAG_DDRT_SIM_VERBOSE {1}
	set_component_parameter_value DIAG_DDRT_SKIP_CA_DESKEW {0}
	set_component_parameter_value DIAG_DDRT_SKIP_CA_LEVEL {0}
	set_component_parameter_value DIAG_DDRT_SKIP_VREF_CAL {0}
	set_component_parameter_value DIAG_DDRT_TG2_TEST_DURATION {SHORT}
	set_component_parameter_value DIAG_DDRT_USER_SIM_MEMORY_PRELOAD {0}
	set_component_parameter_value DIAG_DDRT_USER_SIM_MEMORY_PRELOAD_PRI_EMIF_FILE {EMIF_PRI_PRELOAD.txt}
	set_component_parameter_value DIAG_DDRT_USER_SIM_MEMORY_PRELOAD_SEC_EMIF_FILE {EMIF_SEC_PRELOAD.txt}
	set_component_parameter_value DIAG_DDRT_USER_USE_SIM_MEMORY_VALIDATION_TG {1}
	set_component_parameter_value DIAG_DDRT_USE_NEW_EFFMON_S10 {0}
	set_component_parameter_value DIAG_DDRT_USE_TG_AVL_2 {1}
	set_component_parameter_value DIAG_DDRT_USE_TG_HBM {0}
	set_component_parameter_value DIAG_ECLIPSE_DEBUG {0}
	set_component_parameter_value DIAG_ENABLE_HPS_EMIF_DEBUG {0}
	set_component_parameter_value DIAG_ENABLE_JTAG_UART {0}
	set_component_parameter_value DIAG_ENABLE_JTAG_UART_HEX {0}
	set_component_parameter_value DIAG_EXPORT_PLL_LOCKED {1}
	set_component_parameter_value DIAG_EXPORT_PLL_REF_CLK_OUT {0}
	set_component_parameter_value DIAG_EXPORT_VJI {0}
	set_component_parameter_value DIAG_EXPOSE_DFT_SIGNALS {0}
	set_component_parameter_value DIAG_EXPOSE_EARLY_READY {0}
	set_component_parameter_value DIAG_EXPOSE_RD_TYPE {0}
	set_component_parameter_value DIAG_EXTRA_CONFIGS {}
	set_component_parameter_value DIAG_EXT_DOCS {0}
	set_component_parameter_value DIAG_EX_DESIGN_ADD_TEST_EMIFS {}
	set_component_parameter_value DIAG_EX_DESIGN_SEPARATE_RESETS {0}
	set_component_parameter_value DIAG_FAST_SIM_OVERRIDE {FAST_SIM_OVERRIDE_DEFAULT}
	set_component_parameter_value DIAG_HMC_HRC {auto}
	set_component_parameter_value DIAG_LPDDR3_ABSTRACT_PHY {0}
	set_component_parameter_value DIAG_LPDDR3_AC_PARITY_ERR {0}
	set_component_parameter_value DIAG_LPDDR3_DISABLE_AFI_P2C_REGISTERS {0}
	set_component_parameter_value DIAG_LPDDR3_EFFICIENCY_MONITOR {EFFMON_MODE_DISABLED}
	set_component_parameter_value DIAG_LPDDR3_ENABLE_DEFAULT_MODE {0}
	set_component_parameter_value DIAG_LPDDR3_ENABLE_USER_MODE {1}
	set_component_parameter_value DIAG_LPDDR3_EXPORT_SEQ_AVALON_HEAD_OF_CHAIN {1}
	set_component_parameter_value DIAG_LPDDR3_EXPORT_SEQ_AVALON_MASTER {0}
	set_component_parameter_value DIAG_LPDDR3_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_DISABLED}
	set_component_parameter_value DIAG_LPDDR3_EXPORT_TG_CFG_AVALON_SLAVE {TG_CFG_AMM_EXPORT_MODE_EXPORT}
	set_component_parameter_value DIAG_LPDDR3_EX_DESIGN_ISSP_EN {1}
	set_component_parameter_value DIAG_LPDDR3_EX_DESIGN_NUM_OF_SLAVES {1}
	set_component_parameter_value DIAG_LPDDR3_EX_DESIGN_SEPARATE_RZQS {1}
	set_component_parameter_value DIAG_LPDDR3_INTERFACE_ID {0}
	set_component_parameter_value DIAG_LPDDR3_SEPARATE_READ_WRITE_ITFS {0}
	set_component_parameter_value DIAG_LPDDR3_SIM_CAL_MODE_ENUM {SIM_CAL_MODE_SKIP}
	set_component_parameter_value DIAG_LPDDR3_SIM_VERBOSE {1}
	set_component_parameter_value DIAG_LPDDR3_SKIP_CA_DESKEW {0}
	set_component_parameter_value DIAG_LPDDR3_SKIP_CA_LEVEL {0}
	set_component_parameter_value DIAG_LPDDR3_TG2_TEST_DURATION {SHORT}
	set_component_parameter_value DIAG_LPDDR3_USER_SIM_MEMORY_PRELOAD {0}
	set_component_parameter_value DIAG_LPDDR3_USER_SIM_MEMORY_PRELOAD_PRI_EMIF_FILE {EMIF_PRI_PRELOAD.txt}
	set_component_parameter_value DIAG_LPDDR3_USER_SIM_MEMORY_PRELOAD_SEC_EMIF_FILE {EMIF_SEC_PRELOAD.txt}
	set_component_parameter_value DIAG_LPDDR3_USER_USE_SIM_MEMORY_VALIDATION_TG {1}
	set_component_parameter_value DIAG_LPDDR3_USE_NEW_EFFMON_S10 {0}
	set_component_parameter_value DIAG_LPDDR3_USE_TG_AVL_2 {0}
	set_component_parameter_value DIAG_LPDDR3_USE_TG_HBM {0}
	set_component_parameter_value DIAG_QDR2_ABSTRACT_PHY {0}
	set_component_parameter_value DIAG_QDR2_AC_PARITY_ERR {0}
	set_component_parameter_value DIAG_QDR2_DISABLE_AFI_P2C_REGISTERS {0}
	set_component_parameter_value DIAG_QDR2_EFFICIENCY_MONITOR {EFFMON_MODE_DISABLED}
	set_component_parameter_value DIAG_QDR2_ENABLE_DEFAULT_MODE {0}
	set_component_parameter_value DIAG_QDR2_ENABLE_USER_MODE {1}
	set_component_parameter_value DIAG_QDR2_EXPORT_SEQ_AVALON_HEAD_OF_CHAIN {1}
	set_component_parameter_value DIAG_QDR2_EXPORT_SEQ_AVALON_MASTER {0}
	set_component_parameter_value DIAG_QDR2_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_DISABLED}
	set_component_parameter_value DIAG_QDR2_EXPORT_TG_CFG_AVALON_SLAVE {TG_CFG_AMM_EXPORT_MODE_EXPORT}
	set_component_parameter_value DIAG_QDR2_EX_DESIGN_ISSP_EN {1}
	set_component_parameter_value DIAG_QDR2_EX_DESIGN_NUM_OF_SLAVES {1}
	set_component_parameter_value DIAG_QDR2_EX_DESIGN_SEPARATE_RZQS {1}
	set_component_parameter_value DIAG_QDR2_INTERFACE_ID {0}
	set_component_parameter_value DIAG_QDR2_SEPARATE_READ_WRITE_ITFS {0}
	set_component_parameter_value DIAG_QDR2_SIM_CAL_MODE_ENUM {SIM_CAL_MODE_SKIP}
	set_component_parameter_value DIAG_QDR2_SIM_VERBOSE {1}
	set_component_parameter_value DIAG_QDR2_TG2_TEST_DURATION {SHORT}
	set_component_parameter_value DIAG_QDR2_USER_SIM_MEMORY_PRELOAD {0}
	set_component_parameter_value DIAG_QDR2_USER_SIM_MEMORY_PRELOAD_PRI_EMIF_FILE {EMIF_PRI_PRELOAD.txt}
	set_component_parameter_value DIAG_QDR2_USER_SIM_MEMORY_PRELOAD_SEC_EMIF_FILE {EMIF_SEC_PRELOAD.txt}
	set_component_parameter_value DIAG_QDR2_USER_USE_SIM_MEMORY_VALIDATION_TG {1}
	set_component_parameter_value DIAG_QDR2_USE_NEW_EFFMON_S10 {0}
	set_component_parameter_value DIAG_QDR2_USE_TG_AVL_2 {0}
	set_component_parameter_value DIAG_QDR2_USE_TG_HBM {0}
	set_component_parameter_value DIAG_QDR4_ABSTRACT_PHY {0}
	set_component_parameter_value DIAG_QDR4_AC_PARITY_ERR {0}
	set_component_parameter_value DIAG_QDR4_DISABLE_AFI_P2C_REGISTERS {0}
	set_component_parameter_value DIAG_QDR4_EFFICIENCY_MONITOR {EFFMON_MODE_DISABLED}
	set_component_parameter_value DIAG_QDR4_ENABLE_DEFAULT_MODE {0}
	set_component_parameter_value DIAG_QDR4_ENABLE_USER_MODE {1}
	set_component_parameter_value DIAG_QDR4_EXPORT_SEQ_AVALON_HEAD_OF_CHAIN {1}
	set_component_parameter_value DIAG_QDR4_EXPORT_SEQ_AVALON_MASTER {0}
	set_component_parameter_value DIAG_QDR4_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_DISABLED}
	set_component_parameter_value DIAG_QDR4_EXPORT_TG_CFG_AVALON_SLAVE {TG_CFG_AMM_EXPORT_MODE_EXPORT}
	set_component_parameter_value DIAG_QDR4_EX_DESIGN_ISSP_EN {1}
	set_component_parameter_value DIAG_QDR4_EX_DESIGN_NUM_OF_SLAVES {1}
	set_component_parameter_value DIAG_QDR4_EX_DESIGN_SEPARATE_RZQS {1}
	set_component_parameter_value DIAG_QDR4_INTERFACE_ID {0}
	set_component_parameter_value DIAG_QDR4_SEPARATE_READ_WRITE_ITFS {0}
	set_component_parameter_value DIAG_QDR4_SIM_CAL_MODE_ENUM {SIM_CAL_MODE_SKIP}
	set_component_parameter_value DIAG_QDR4_SIM_VERBOSE {1}
	set_component_parameter_value DIAG_QDR4_SKIP_VREF_CAL {0}
	set_component_parameter_value DIAG_QDR4_TG2_TEST_DURATION {SHORT}
	set_component_parameter_value DIAG_QDR4_USER_SIM_MEMORY_PRELOAD {0}
	set_component_parameter_value DIAG_QDR4_USER_SIM_MEMORY_PRELOAD_PRI_EMIF_FILE {EMIF_PRI_PRELOAD.txt}
	set_component_parameter_value DIAG_QDR4_USER_SIM_MEMORY_PRELOAD_SEC_EMIF_FILE {EMIF_SEC_PRELOAD.txt}
	set_component_parameter_value DIAG_QDR4_USER_USE_SIM_MEMORY_VALIDATION_TG {1}
	set_component_parameter_value DIAG_QDR4_USE_NEW_EFFMON_S10 {0}
	set_component_parameter_value DIAG_QDR4_USE_TG_AVL_2 {0}
	set_component_parameter_value DIAG_QDR4_USE_TG_HBM {0}
	set_component_parameter_value DIAG_RLD2_ABSTRACT_PHY {0}
	set_component_parameter_value DIAG_RLD2_AC_PARITY_ERR {0}
	set_component_parameter_value DIAG_RLD2_DISABLE_AFI_P2C_REGISTERS {0}
	set_component_parameter_value DIAG_RLD2_EFFICIENCY_MONITOR {EFFMON_MODE_DISABLED}
	set_component_parameter_value DIAG_RLD2_ENABLE_DEFAULT_MODE {0}
	set_component_parameter_value DIAG_RLD2_ENABLE_USER_MODE {1}
	set_component_parameter_value DIAG_RLD2_EXPORT_SEQ_AVALON_HEAD_OF_CHAIN {1}
	set_component_parameter_value DIAG_RLD2_EXPORT_SEQ_AVALON_MASTER {0}
	set_component_parameter_value DIAG_RLD2_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_DISABLED}
	set_component_parameter_value DIAG_RLD2_EXPORT_TG_CFG_AVALON_SLAVE {TG_CFG_AMM_EXPORT_MODE_EXPORT}
	set_component_parameter_value DIAG_RLD2_EX_DESIGN_ISSP_EN {1}
	set_component_parameter_value DIAG_RLD2_EX_DESIGN_NUM_OF_SLAVES {1}
	set_component_parameter_value DIAG_RLD2_EX_DESIGN_SEPARATE_RZQS {1}
	set_component_parameter_value DIAG_RLD2_INTERFACE_ID {0}
	set_component_parameter_value DIAG_RLD2_SEPARATE_READ_WRITE_ITFS {0}
	set_component_parameter_value DIAG_RLD2_SIM_CAL_MODE_ENUM {SIM_CAL_MODE_SKIP}
	set_component_parameter_value DIAG_RLD2_SIM_VERBOSE {1}
	set_component_parameter_value DIAG_RLD2_TG2_TEST_DURATION {SHORT}
	set_component_parameter_value DIAG_RLD2_USER_SIM_MEMORY_PRELOAD {0}
	set_component_parameter_value DIAG_RLD2_USER_SIM_MEMORY_PRELOAD_PRI_EMIF_FILE {EMIF_PRI_PRELOAD.txt}
	set_component_parameter_value DIAG_RLD2_USER_SIM_MEMORY_PRELOAD_SEC_EMIF_FILE {EMIF_SEC_PRELOAD.txt}
	set_component_parameter_value DIAG_RLD2_USER_USE_SIM_MEMORY_VALIDATION_TG {1}
	set_component_parameter_value DIAG_RLD2_USE_NEW_EFFMON_S10 {0}
	set_component_parameter_value DIAG_RLD2_USE_TG_AVL_2 {0}
	set_component_parameter_value DIAG_RLD2_USE_TG_HBM {0}
	set_component_parameter_value DIAG_RLD3_ABSTRACT_PHY {0}
	set_component_parameter_value DIAG_RLD3_AC_PARITY_ERR {0}
	set_component_parameter_value DIAG_RLD3_CA_DESKEW_EN {1}
	set_component_parameter_value DIAG_RLD3_CA_LEVEL_EN {1}
	set_component_parameter_value DIAG_RLD3_DISABLE_AFI_P2C_REGISTERS {0}
	set_component_parameter_value DIAG_RLD3_EFFICIENCY_MONITOR {EFFMON_MODE_DISABLED}
	set_component_parameter_value DIAG_RLD3_ENABLE_DEFAULT_MODE {0}
	set_component_parameter_value DIAG_RLD3_ENABLE_USER_MODE {1}
	set_component_parameter_value DIAG_RLD3_EXPORT_SEQ_AVALON_HEAD_OF_CHAIN {1}
	set_component_parameter_value DIAG_RLD3_EXPORT_SEQ_AVALON_MASTER {0}
	set_component_parameter_value DIAG_RLD3_EXPORT_SEQ_AVALON_SLAVE {CAL_DEBUG_EXPORT_MODE_DISABLED}
	set_component_parameter_value DIAG_RLD3_EXPORT_TG_CFG_AVALON_SLAVE {TG_CFG_AMM_EXPORT_MODE_EXPORT}
	set_component_parameter_value DIAG_RLD3_EX_DESIGN_ISSP_EN {1}
	set_component_parameter_value DIAG_RLD3_EX_DESIGN_NUM_OF_SLAVES {1}
	set_component_parameter_value DIAG_RLD3_EX_DESIGN_SEPARATE_RZQS {1}
	set_component_parameter_value DIAG_RLD3_INTERFACE_ID {0}
	set_component_parameter_value DIAG_RLD3_SEPARATE_READ_WRITE_ITFS {0}
	set_component_parameter_value DIAG_RLD3_SIM_CAL_MODE_ENUM {SIM_CAL_MODE_SKIP}
	set_component_parameter_value DIAG_RLD3_SIM_VERBOSE {1}
	set_component_parameter_value DIAG_RLD3_TG2_TEST_DURATION {SHORT}
	set_component_parameter_value DIAG_RLD3_USER_SIM_MEMORY_PRELOAD {0}
	set_component_parameter_value DIAG_RLD3_USER_SIM_MEMORY_PRELOAD_PRI_EMIF_FILE {EMIF_PRI_PRELOAD.txt}
	set_component_parameter_value DIAG_RLD3_USER_SIM_MEMORY_PRELOAD_SEC_EMIF_FILE {EMIF_SEC_PRELOAD.txt}
	set_component_parameter_value DIAG_RLD3_USER_USE_SIM_MEMORY_VALIDATION_TG {1}
	set_component_parameter_value DIAG_RLD3_USE_NEW_EFFMON_S10 {0}
	set_component_parameter_value DIAG_RLD3_USE_TG_AVL_2 {0}
	set_component_parameter_value DIAG_RLD3_USE_TG_HBM {0}
	set_component_parameter_value DIAG_RS232_UART_BAUDRATE {57600}
	set_component_parameter_value DIAG_SEQ_RESET_AUTO_RELEASE {avl}
	set_component_parameter_value DIAG_SIM_REGTEST_MODE {0}
	set_component_parameter_value DIAG_SOFT_NIOS_CLOCK_FREQUENCY {100}
	set_component_parameter_value DIAG_SOFT_NIOS_MODE {SOFT_NIOS_MODE_DISABLED}
	set_component_parameter_value DIAG_SYNTH_FOR_SIM {0}
	set_component_parameter_value DIAG_TG_AVL_2_NUM_CFG_INTERFACES {0}
	set_component_parameter_value DIAG_TIMING_REGTEST_MODE {0}
	set_component_parameter_value DIAG_USE_BOARD_DELAY_MODEL {0}
	set_component_parameter_value DIAG_USE_RS232_UART {0}
	set_component_parameter_value DIAG_VERBOSE_IOAUX {0}
	set_component_parameter_value EMIF_0_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_0_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_0_STORED_PARAM {}
	set_component_parameter_value EMIF_10_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_10_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_10_STORED_PARAM {}
	set_component_parameter_value EMIF_11_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_11_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_11_STORED_PARAM {}
	set_component_parameter_value EMIF_12_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_12_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_12_STORED_PARAM {}
	set_component_parameter_value EMIF_13_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_13_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_13_STORED_PARAM {}
	set_component_parameter_value EMIF_14_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_14_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_14_STORED_PARAM {}
	set_component_parameter_value EMIF_15_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_15_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_15_STORED_PARAM {}
	set_component_parameter_value EMIF_1_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_1_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_1_STORED_PARAM {}
	set_component_parameter_value EMIF_2_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_2_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_2_STORED_PARAM {}
	set_component_parameter_value EMIF_3_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_3_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_3_STORED_PARAM {}
	set_component_parameter_value EMIF_4_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_4_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_4_STORED_PARAM {}
	set_component_parameter_value EMIF_5_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_5_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_5_STORED_PARAM {}
	set_component_parameter_value EMIF_6_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_6_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_6_STORED_PARAM {}
	set_component_parameter_value EMIF_7_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_7_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_7_STORED_PARAM {}
	set_component_parameter_value EMIF_8_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_8_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_8_STORED_PARAM {}
	set_component_parameter_value EMIF_9_CONN_TO_CALIP {CALIP_0}
	set_component_parameter_value EMIF_9_REF_CLK_SHARING {EXPORTED}
	set_component_parameter_value EMIF_9_STORED_PARAM {}
	set_component_parameter_value EX_DESIGN_GUI_DDR3_GEN_BSI {0}
	set_component_parameter_value EX_DESIGN_GUI_DDR3_GEN_CDC {0}
	set_component_parameter_value EX_DESIGN_GUI_DDR3_GEN_SIM {1}
	set_component_parameter_value EX_DESIGN_GUI_DDR3_GEN_SYNTH {1}
	set_component_parameter_value EX_DESIGN_GUI_DDR3_HDL_FORMAT {HDL_FORMAT_VERILOG}
	set_component_parameter_value EX_DESIGN_GUI_DDR3_PREV_PRESET {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_DDR3_SEL_DESIGN {AVAIL_EX_DESIGNS_GEN_DESIGN}
	set_component_parameter_value EX_DESIGN_GUI_DDR3_TARGET_DEV_KIT {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_DDR4_GEN_BSI {0}
	set_component_parameter_value EX_DESIGN_GUI_DDR4_GEN_CDC {0}
	set_component_parameter_value EX_DESIGN_GUI_DDR4_GEN_SIM {1}
	set_component_parameter_value EX_DESIGN_GUI_DDR4_GEN_SYNTH {1}
	set_component_parameter_value EX_DESIGN_GUI_DDR4_HDL_FORMAT {HDL_FORMAT_VERILOG}
	set_component_parameter_value EX_DESIGN_GUI_DDR4_PREV_PRESET {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_DDR4_SEL_DESIGN {AVAIL_EX_DESIGNS_GEN_DESIGN}
	set_component_parameter_value EX_DESIGN_GUI_DDR4_TARGET_DEV_KIT {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_DDRT_GEN_BSI {0}
	set_component_parameter_value EX_DESIGN_GUI_DDRT_GEN_CDC {0}
	set_component_parameter_value EX_DESIGN_GUI_DDRT_GEN_SIM {1}
	set_component_parameter_value EX_DESIGN_GUI_DDRT_GEN_SYNTH {1}
	set_component_parameter_value EX_DESIGN_GUI_DDRT_HDL_FORMAT {HDL_FORMAT_VERILOG}
	set_component_parameter_value EX_DESIGN_GUI_DDRT_PREV_PRESET {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_DDRT_SEL_DESIGN {AVAIL_EX_DESIGNS_GEN_DESIGN}
	set_component_parameter_value EX_DESIGN_GUI_DDRT_TARGET_DEV_KIT {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_LPDDR3_GEN_BSI {0}
	set_component_parameter_value EX_DESIGN_GUI_LPDDR3_GEN_CDC {0}
	set_component_parameter_value EX_DESIGN_GUI_LPDDR3_GEN_SIM {1}
	set_component_parameter_value EX_DESIGN_GUI_LPDDR3_GEN_SYNTH {1}
	set_component_parameter_value EX_DESIGN_GUI_LPDDR3_HDL_FORMAT {HDL_FORMAT_VERILOG}
	set_component_parameter_value EX_DESIGN_GUI_LPDDR3_PREV_PRESET {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_LPDDR3_SEL_DESIGN {AVAIL_EX_DESIGNS_GEN_DESIGN}
	set_component_parameter_value EX_DESIGN_GUI_LPDDR3_TARGET_DEV_KIT {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_QDR2_GEN_BSI {0}
	set_component_parameter_value EX_DESIGN_GUI_QDR2_GEN_CDC {0}
	set_component_parameter_value EX_DESIGN_GUI_QDR2_GEN_SIM {1}
	set_component_parameter_value EX_DESIGN_GUI_QDR2_GEN_SYNTH {1}
	set_component_parameter_value EX_DESIGN_GUI_QDR2_HDL_FORMAT {HDL_FORMAT_VERILOG}
	set_component_parameter_value EX_DESIGN_GUI_QDR2_PREV_PRESET {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_QDR2_SEL_DESIGN {AVAIL_EX_DESIGNS_GEN_DESIGN}
	set_component_parameter_value EX_DESIGN_GUI_QDR2_TARGET_DEV_KIT {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_QDR4_GEN_BSI {0}
	set_component_parameter_value EX_DESIGN_GUI_QDR4_GEN_CDC {0}
	set_component_parameter_value EX_DESIGN_GUI_QDR4_GEN_SIM {1}
	set_component_parameter_value EX_DESIGN_GUI_QDR4_GEN_SYNTH {1}
	set_component_parameter_value EX_DESIGN_GUI_QDR4_HDL_FORMAT {HDL_FORMAT_VERILOG}
	set_component_parameter_value EX_DESIGN_GUI_QDR4_PREV_PRESET {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_QDR4_SEL_DESIGN {AVAIL_EX_DESIGNS_GEN_DESIGN}
	set_component_parameter_value EX_DESIGN_GUI_QDR4_TARGET_DEV_KIT {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_RLD2_GEN_BSI {0}
	set_component_parameter_value EX_DESIGN_GUI_RLD2_GEN_CDC {0}
	set_component_parameter_value EX_DESIGN_GUI_RLD2_GEN_SIM {1}
	set_component_parameter_value EX_DESIGN_GUI_RLD2_GEN_SYNTH {1}
	set_component_parameter_value EX_DESIGN_GUI_RLD2_HDL_FORMAT {HDL_FORMAT_VERILOG}
	set_component_parameter_value EX_DESIGN_GUI_RLD2_PREV_PRESET {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_RLD2_SEL_DESIGN {AVAIL_EX_DESIGNS_GEN_DESIGN}
	set_component_parameter_value EX_DESIGN_GUI_RLD2_TARGET_DEV_KIT {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_RLD3_GEN_BSI {0}
	set_component_parameter_value EX_DESIGN_GUI_RLD3_GEN_CDC {0}
	set_component_parameter_value EX_DESIGN_GUI_RLD3_GEN_SIM {1}
	set_component_parameter_value EX_DESIGN_GUI_RLD3_GEN_SYNTH {1}
	set_component_parameter_value EX_DESIGN_GUI_RLD3_HDL_FORMAT {HDL_FORMAT_VERILOG}
	set_component_parameter_value EX_DESIGN_GUI_RLD3_PREV_PRESET {TARGET_DEV_KIT_NONE}
	set_component_parameter_value EX_DESIGN_GUI_RLD3_SEL_DESIGN {AVAIL_EX_DESIGNS_GEN_DESIGN}
	set_component_parameter_value EX_DESIGN_GUI_RLD3_TARGET_DEV_KIT {TARGET_DEV_KIT_NONE}
	set_component_parameter_value INTERNAL_TESTING_MODE {0}
	set_component_parameter_value IS_ED_SLAVE {0}
	set_component_parameter_value MEM_DDR3_ALERT_N_DQS_GROUP {0}
	set_component_parameter_value MEM_DDR3_ALERT_N_PLACEMENT_ENUM {DDR3_ALERT_N_PLACEMENT_AC_LANES}
	set_component_parameter_value MEM_DDR3_ASR_ENUM {DDR3_ASR_MANUAL}
	set_component_parameter_value MEM_DDR3_ATCL_ENUM {DDR3_ATCL_DISABLED}
	set_component_parameter_value MEM_DDR3_BANK_ADDR_WIDTH {3}
	set_component_parameter_value MEM_DDR3_BL_ENUM {DDR3_BL_BL8}
	set_component_parameter_value MEM_DDR3_BT_ENUM {DDR3_BT_SEQUENTIAL}
	set_component_parameter_value MEM_DDR3_CFG_GEN_DBE {0}
	set_component_parameter_value MEM_DDR3_CFG_GEN_SBE {0}
	set_component_parameter_value MEM_DDR3_CKE_PER_DIMM {1}
	set_component_parameter_value MEM_DDR3_CK_WIDTH {1}
	set_component_parameter_value MEM_DDR3_COL_ADDR_WIDTH {10}
	set_component_parameter_value MEM_DDR3_DISCRETE_CS_WIDTH {1}
	set_component_parameter_value MEM_DDR3_DISCRETE_MIRROR_ADDRESSING_EN {0}
	set_component_parameter_value MEM_DDR3_DLL_EN {1}
	set_component_parameter_value MEM_DDR3_DM_EN {1}
	set_component_parameter_value MEM_DDR3_DQ_PER_DQS {8}
	set_component_parameter_value MEM_DDR3_DQ_WIDTH {72}
	set_component_parameter_value MEM_DDR3_DRV_STR_ENUM {DDR3_DRV_STR_RZQ_7}
	set_component_parameter_value MEM_DDR3_FORMAT_ENUM {MEM_FORMAT_UDIMM}
	set_component_parameter_value MEM_DDR3_HIDE_ADV_MR_SETTINGS {1}
	set_component_parameter_value MEM_DDR3_LRDIMM_EXTENDED_CONFIG {000000000000000000}
	set_component_parameter_value MEM_DDR3_MIRROR_ADDRESSING_EN {1}
	set_component_parameter_value MEM_DDR3_NUM_OF_DIMMS {1}
	set_component_parameter_value MEM_DDR3_PD_ENUM {DDR3_PD_OFF}
	set_component_parameter_value MEM_DDR3_RANKS_PER_DIMM {1}
	set_component_parameter_value MEM_DDR3_RDIMM_CONFIG {0000000000000000}
	set_component_parameter_value MEM_DDR3_ROW_ADDR_WIDTH {15}
	set_component_parameter_value MEM_DDR3_RTT_NOM_ENUM {DDR3_RTT_NOM_ODT_DISABLED}
	set_component_parameter_value MEM_DDR3_RTT_WR_ENUM {DDR3_RTT_WR_RZQ_4}
	set_component_parameter_value MEM_DDR3_R_ODT0_1X1 {off}
	set_component_parameter_value MEM_DDR3_R_ODT0_2X2 {off off}
	set_component_parameter_value MEM_DDR3_R_ODT0_4X2 {off off on on}
	set_component_parameter_value MEM_DDR3_R_ODT0_4X4 {off off on off}
	set_component_parameter_value MEM_DDR3_R_ODT1_2X2 {off off}
	set_component_parameter_value MEM_DDR3_R_ODT1_4X2 {on on off off}
	set_component_parameter_value MEM_DDR3_R_ODT1_4X4 {off off off on}
	set_component_parameter_value MEM_DDR3_R_ODT2_4X4 {on off off off}
	set_component_parameter_value MEM_DDR3_R_ODT3_4X4 {off on off off}
	set_component_parameter_value MEM_DDR3_R_ODTN_1X1 {Rank\ 0}
	set_component_parameter_value MEM_DDR3_R_ODTN_2X2 {Rank\ 0 Rank\ 1}
	set_component_parameter_value MEM_DDR3_R_ODTN_4X2 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDR3_R_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDR3_SPEEDBIN_ENUM {DDR3_SPEEDBIN_2133}
	set_component_parameter_value MEM_DDR3_SRT_ENUM {DDR3_SRT_NORMAL}
	set_component_parameter_value MEM_DDR3_TCL {14}
	set_component_parameter_value MEM_DDR3_TDH_DC_MV {100}
	set_component_parameter_value MEM_DDR3_TDH_PS {55}
	set_component_parameter_value MEM_DDR3_TDQSCK_PS {180}
	set_component_parameter_value MEM_DDR3_TDQSQ_PS {75}
	set_component_parameter_value MEM_DDR3_TDQSS_CYC {0.27}
	set_component_parameter_value MEM_DDR3_TDSH_CYC {0.18}
	set_component_parameter_value MEM_DDR3_TDSS_CYC {0.18}
	set_component_parameter_value MEM_DDR3_TDS_AC_MV {135}
	set_component_parameter_value MEM_DDR3_TDS_PS {53}
	set_component_parameter_value MEM_DDR3_TFAW_NS {25.0}
	set_component_parameter_value MEM_DDR3_TIH_DC_MV {100}
	set_component_parameter_value MEM_DDR3_TIH_PS {95}
	set_component_parameter_value MEM_DDR3_TINIT_US {500}
	set_component_parameter_value MEM_DDR3_TIS_AC_MV {135}
	set_component_parameter_value MEM_DDR3_TIS_PS {60}
	set_component_parameter_value MEM_DDR3_TMRD_CK_CYC {4}
	set_component_parameter_value MEM_DDR3_TQH_CYC {0.38}
	set_component_parameter_value MEM_DDR3_TQSH_CYC {0.4}
	set_component_parameter_value MEM_DDR3_TRAS_NS {33.0}
	set_component_parameter_value MEM_DDR3_TRCD_NS {13.09}
	set_component_parameter_value MEM_DDR3_TREFI_US {7.8}
	set_component_parameter_value MEM_DDR3_TRFC_NS {160.0}
	set_component_parameter_value MEM_DDR3_TRP_NS {13.09}
	set_component_parameter_value MEM_DDR3_TRRD_CYC {6}
	set_component_parameter_value MEM_DDR3_TRTP_CYC {8}
	set_component_parameter_value MEM_DDR3_TWLH_PS {125.0}
	set_component_parameter_value MEM_DDR3_TWLS_PS {125.0}
	set_component_parameter_value MEM_DDR3_TWR_NS {15.0}
	set_component_parameter_value MEM_DDR3_TWTR_CYC {8}
	set_component_parameter_value MEM_DDR3_USE_DEFAULT_ODT {1}
	set_component_parameter_value MEM_DDR3_WTCL {10}
	set_component_parameter_value MEM_DDR3_W_ODT0_1X1 {on}
	set_component_parameter_value MEM_DDR3_W_ODT0_2X2 {on off}
	set_component_parameter_value MEM_DDR3_W_ODT0_4X2 {off off on on}
	set_component_parameter_value MEM_DDR3_W_ODT0_4X4 {on off on off}
	set_component_parameter_value MEM_DDR3_W_ODT1_2X2 {off on}
	set_component_parameter_value MEM_DDR3_W_ODT1_4X2 {on on off off}
	set_component_parameter_value MEM_DDR3_W_ODT1_4X4 {off on off on}
	set_component_parameter_value MEM_DDR3_W_ODT2_4X4 {on off on off}
	set_component_parameter_value MEM_DDR3_W_ODT3_4X4 {off on off on}
	set_component_parameter_value MEM_DDR3_W_ODTN_1X1 {Rank\ 0}
	set_component_parameter_value MEM_DDR3_W_ODTN_2X2 {Rank\ 0 Rank\ 1}
	set_component_parameter_value MEM_DDR3_W_ODTN_4X2 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDR3_W_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDR4_AC_PARITY_LATENCY {DDR4_AC_PARITY_LATENCY_DISABLE}
	set_component_parameter_value MEM_DDR4_AC_PERSISTENT_ERROR {0}
	set_component_parameter_value MEM_DDR4_ALERT_N_AC_LANE {3}
	set_component_parameter_value MEM_DDR4_ALERT_N_AC_PIN {8}
	set_component_parameter_value MEM_DDR4_ALERT_N_DQS_GROUP {0}
	set_component_parameter_value MEM_DDR4_ALERT_N_PLACEMENT_ENUM {DDR4_ALERT_N_PLACEMENT_FM_LANE3}
	set_component_parameter_value MEM_DDR4_ALERT_PAR_EN {1}
	set_component_parameter_value MEM_DDR4_ASR_ENUM {DDR4_ASR_MANUAL_NORMAL}
	set_component_parameter_value MEM_DDR4_ATCL_ENUM {DDR4_ATCL_DISABLED}
	set_component_parameter_value MEM_DDR4_BANK_ADDR_WIDTH {2}
	set_component_parameter_value MEM_DDR4_BANK_GROUP_WIDTH {2}
	set_component_parameter_value MEM_DDR4_BL_ENUM {DDR4_BL_BL8}
	set_component_parameter_value MEM_DDR4_BT_ENUM {DDR4_BT_SEQUENTIAL}
	set_component_parameter_value MEM_DDR4_CAL_MODE {0}
	set_component_parameter_value MEM_DDR4_CFG_GEN_DBE {0}
	set_component_parameter_value MEM_DDR4_CFG_GEN_SBE {0}
	set_component_parameter_value MEM_DDR4_CHIP_ID_WIDTH {0}
	set_component_parameter_value MEM_DDR4_CKE_PER_DIMM {1}
	set_component_parameter_value MEM_DDR4_CK_WIDTH {1}
	set_component_parameter_value MEM_DDR4_COL_ADDR_WIDTH {10}
	set_component_parameter_value MEM_DDR4_DB_DQ_DRV_ENUM {DDR4_DB_DRV_STR_RZQ_7}
	set_component_parameter_value MEM_DDR4_DB_RTT_NOM_ENUM {DDR4_DB_RTT_NOM_ODT_DISABLED}
	set_component_parameter_value MEM_DDR4_DB_RTT_PARK_ENUM {DDR4_DB_RTT_PARK_ODT_DISABLED}
	set_component_parameter_value MEM_DDR4_DB_RTT_WR_ENUM {DDR4_DB_RTT_WR_RZQ_3}
	set_component_parameter_value MEM_DDR4_DEFAULT_VREFOUT {1}
	set_component_parameter_value MEM_DDR4_DISCRETE_CS_WIDTH {1}
	set_component_parameter_value MEM_DDR4_DISCRETE_MIRROR_ADDRESSING_EN {0}
	set_component_parameter_value MEM_DDR4_DLL_EN {1}
	set_component_parameter_value MEM_DDR4_DM_EN {1}
	set_component_parameter_value MEM_DDR4_DQ_PER_DQS {8}
	set_component_parameter_value MEM_DDR4_DQ_WIDTH {72}
	set_component_parameter_value MEM_DDR4_DRV_STR_ENUM {DDR4_DRV_STR_RZQ_7}
	set_component_parameter_value MEM_DDR4_FINE_GRANULARITY_REFRESH {DDR4_FINE_REFRESH_FIXED_1X}
	set_component_parameter_value MEM_DDR4_FORMAT_ENUM {MEM_FORMAT_RDIMM}
	set_component_parameter_value MEM_DDR4_GEARDOWN {DDR4_GEARDOWN_HR}
	set_component_parameter_value MEM_DDR4_HIDE_ADV_MR_SETTINGS {1}
	set_component_parameter_value MEM_DDR4_INTEL_DEFAULT_TERM {1}
	set_component_parameter_value MEM_DDR4_INTERNAL_VREFDQ_MONITOR {0}
	set_component_parameter_value MEM_DDR4_LRDIMM_ODT_LESS_BS {1}
	set_component_parameter_value MEM_DDR4_LRDIMM_ODT_LESS_BS_PARK_OHM {240}
	set_component_parameter_value MEM_DDR4_LRDIMM_VREFDQ_VALUE {}
	set_component_parameter_value MEM_DDR4_MAX_POWERDOWN {0}
	set_component_parameter_value MEM_DDR4_MIRROR_ADDRESSING_EN {1}
	set_component_parameter_value MEM_DDR4_MPR_READ_FORMAT {DDR4_MPR_READ_FORMAT_SERIAL}
	set_component_parameter_value MEM_DDR4_NUM_OF_DIMMS {1}
	set_component_parameter_value MEM_DDR4_ODT_IN_POWERDOWN {1}
	set_component_parameter_value MEM_DDR4_PER_DRAM_ADDR {0}
	set_component_parameter_value MEM_DDR4_RANKS_PER_DIMM {1}
	set_component_parameter_value MEM_DDR4_RCD_CA_IBT_ENUM {DDR4_RCD_CA_IBT_100}
	set_component_parameter_value MEM_DDR4_RCD_CKE_IBT_ENUM {DDR4_RCD_CKE_IBT_100}
	set_component_parameter_value MEM_DDR4_RCD_CS_IBT_ENUM {DDR4_RCD_CS_IBT_100}
	set_component_parameter_value MEM_DDR4_RCD_ODT_IBT_ENUM {DDR4_RCD_ODT_IBT_100}
	set_component_parameter_value MEM_DDR4_READ_DBI {1}
	set_component_parameter_value MEM_DDR4_READ_PREAMBLE {2}
	set_component_parameter_value MEM_DDR4_READ_PREAMBLE_TRAINING {0}
	set_component_parameter_value MEM_DDR4_ROW_ADDR_WIDTH {16}
	set_component_parameter_value MEM_DDR4_RTT_NOM_ENUM {DDR4_RTT_NOM_RZQ_4}
	set_component_parameter_value MEM_DDR4_RTT_PARK {DDR4_RTT_PARK_ODT_DISABLED}
	set_component_parameter_value MEM_DDR4_RTT_WR_ENUM {DDR4_RTT_WR_ODT_DISABLED}
	set_component_parameter_value MEM_DDR4_R_ODT0_1X1 {off}
	set_component_parameter_value MEM_DDR4_R_ODT0_2X2 {off off}
	set_component_parameter_value MEM_DDR4_R_ODT0_4X2 {off off on on}
	set_component_parameter_value MEM_DDR4_R_ODT0_4X4 {off off on off}
	set_component_parameter_value MEM_DDR4_R_ODT1_2X2 {off off}
	set_component_parameter_value MEM_DDR4_R_ODT1_4X2 {on on off off}
	set_component_parameter_value MEM_DDR4_R_ODT1_4X4 {off off off on}
	set_component_parameter_value MEM_DDR4_R_ODT2_4X4 {on off off off}
	set_component_parameter_value MEM_DDR4_R_ODT3_4X4 {off on off off}
	set_component_parameter_value MEM_DDR4_R_ODTN_1X1 {Rank\ 0}
	set_component_parameter_value MEM_DDR4_R_ODTN_2X2 {Rank\ 0 Rank\ 1}
	set_component_parameter_value MEM_DDR4_R_ODTN_4X2 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDR4_R_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDR4_SELF_RFSH_ABORT {0}
	set_component_parameter_value MEM_DDR4_SPD_133_RCD_DB_VENDOR_LSB {0}
	set_component_parameter_value MEM_DDR4_SPD_134_RCD_DB_VENDOR_MSB {0}
	set_component_parameter_value MEM_DDR4_SPD_135_RCD_REV {0}
	set_component_parameter_value MEM_DDR4_SPD_137_RCD_CA_DRV {101}
	set_component_parameter_value MEM_DDR4_SPD_138_RCD_CK_DRV {5}
	set_component_parameter_value MEM_DDR4_SPD_139_DB_REV {0}
	set_component_parameter_value MEM_DDR4_SPD_140_DRAM_VREFDQ_R0 {29}
	set_component_parameter_value MEM_DDR4_SPD_141_DRAM_VREFDQ_R1 {29}
	set_component_parameter_value MEM_DDR4_SPD_142_DRAM_VREFDQ_R2 {29}
	set_component_parameter_value MEM_DDR4_SPD_143_DRAM_VREFDQ_R3 {29}
	set_component_parameter_value MEM_DDR4_SPD_144_DB_VREFDQ {37}
	set_component_parameter_value MEM_DDR4_SPD_145_DB_MDQ_DRV {21}
	set_component_parameter_value MEM_DDR4_SPD_148_DRAM_DRV {0}
	set_component_parameter_value MEM_DDR4_SPD_149_DRAM_RTT_WR_NOM {20}
	set_component_parameter_value MEM_DDR4_SPD_152_DRAM_RTT_PARK {39}
	set_component_parameter_value MEM_DDR4_SPD_155_DB_VREFDQ_RANGE {0}
	set_component_parameter_value MEM_DDR4_SPEEDBIN_ENUM {DDR4_SPEEDBIN_2666}
	set_component_parameter_value MEM_DDR4_TCCD_L_CYC {6}
	set_component_parameter_value MEM_DDR4_TCCD_S_CYC {4}
	set_component_parameter_value MEM_DDR4_TCL {21}
	set_component_parameter_value MEM_DDR4_TDIVW_DJ_CYC {0.1}
	set_component_parameter_value MEM_DDR4_TDIVW_TOTAL_UI {0.2}
	set_component_parameter_value MEM_DDR4_TDQSCK_PS {175}
	set_component_parameter_value MEM_DDR4_TDQSQ_PS {66}
	set_component_parameter_value MEM_DDR4_TDQSQ_UI {0.14}
	set_component_parameter_value MEM_DDR4_TDQSS_CYC {0.27}
	set_component_parameter_value MEM_DDR4_TDSH_CYC {0.18}
	set_component_parameter_value MEM_DDR4_TDSS_CYC {0.18}
	set_component_parameter_value MEM_DDR4_TDVWP_UI {0.72}
	set_component_parameter_value MEM_DDR4_TEMP_CONTROLLED_RFSH_ENA {0}
	set_component_parameter_value MEM_DDR4_TEMP_CONTROLLED_RFSH_RANGE {DDR4_TEMP_CONTROLLED_RFSH_NORMAL}
	set_component_parameter_value MEM_DDR4_TEMP_SENSOR_READOUT {0}
	set_component_parameter_value MEM_DDR4_TFAW_DLR_CYC {16}
	set_component_parameter_value MEM_DDR4_TFAW_NS {21.0}
	set_component_parameter_value MEM_DDR4_TIH_DC_MV {75}
	set_component_parameter_value MEM_DDR4_TIH_PS {87}
	set_component_parameter_value MEM_DDR4_TINIT_US {500}
	set_component_parameter_value MEM_DDR4_TIS_AC_MV {100}
	set_component_parameter_value MEM_DDR4_TIS_PS {62}
	set_component_parameter_value MEM_DDR4_TMRD_CK_CYC {8}
	set_component_parameter_value MEM_DDR4_TQH_CYC {0.38}
	set_component_parameter_value MEM_DDR4_TQH_UI {0.74}
	set_component_parameter_value MEM_DDR4_TQSH_CYC {0.4}
	set_component_parameter_value MEM_DDR4_TRAS_NS {32.0}
	set_component_parameter_value MEM_DDR4_TRCD_NS {14.16}
	set_component_parameter_value MEM_DDR4_TREFI_US {7.8}
	set_component_parameter_value MEM_DDR4_TRFC_DLR_NS {90.0}
	set_component_parameter_value MEM_DDR4_TRFC_NS {350.0}
	set_component_parameter_value MEM_DDR4_TRP_NS {14.16}
	set_component_parameter_value MEM_DDR4_TRRD_DLR_CYC {4}
	set_component_parameter_value MEM_DDR4_TRRD_L_CYC {6}
	set_component_parameter_value MEM_DDR4_TRRD_S_CYC {4}
	set_component_parameter_value MEM_DDR4_TWLH_CYC {0.13}
	set_component_parameter_value MEM_DDR4_TWLH_PS {0.0}
	set_component_parameter_value MEM_DDR4_TWLS_CYC {0.13}
	set_component_parameter_value MEM_DDR4_TWLS_PS {0.0}
	set_component_parameter_value MEM_DDR4_TWR_NS {15.0}
	set_component_parameter_value MEM_DDR4_TWTR_L_CYC {9}
	set_component_parameter_value MEM_DDR4_TWTR_S_CYC {3}
	set_component_parameter_value MEM_DDR4_USER_VREFDQ_TRAINING_RANGE {DDR4_VREFDQ_TRAINING_RANGE_1}
	set_component_parameter_value MEM_DDR4_USER_VREFDQ_TRAINING_VALUE {56.0}
	set_component_parameter_value MEM_DDR4_USE_DEFAULT_ODT {1}
	set_component_parameter_value MEM_DDR4_VDIVW_TOTAL {130}
	set_component_parameter_value MEM_DDR4_WRITE_CRC {0}
	set_component_parameter_value MEM_DDR4_WRITE_DBI {0}
	set_component_parameter_value MEM_DDR4_WRITE_PREAMBLE {1}
	set_component_parameter_value MEM_DDR4_WTCL {16}
	set_component_parameter_value MEM_DDR4_W_ODT0_1X1 {on}
	set_component_parameter_value MEM_DDR4_W_ODT0_2X2 {on off}
	set_component_parameter_value MEM_DDR4_W_ODT0_4X2 {off off on on}
	set_component_parameter_value MEM_DDR4_W_ODT0_4X4 {on off on off}
	set_component_parameter_value MEM_DDR4_W_ODT1_2X2 {off on}
	set_component_parameter_value MEM_DDR4_W_ODT1_4X2 {on on off off}
	set_component_parameter_value MEM_DDR4_W_ODT1_4X4 {off on off on}
	set_component_parameter_value MEM_DDR4_W_ODT2_4X4 {on off on off}
	set_component_parameter_value MEM_DDR4_W_ODT3_4X4 {off on off on}
	set_component_parameter_value MEM_DDR4_W_ODTN_1X1 {Rank\ 0}
	set_component_parameter_value MEM_DDR4_W_ODTN_2X2 {Rank\ 0 Rank\ 1}
	set_component_parameter_value MEM_DDR4_W_ODTN_4X2 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDR4_W_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDRT_AC_PARITY_LATENCY {DDRT_AC_PARITY_LATENCY_DISABLE}
	set_component_parameter_value MEM_DDRT_AC_PERSISTENT_ERROR {0}
	set_component_parameter_value MEM_DDRT_ALERT_N_AC_LANE {0}
	set_component_parameter_value MEM_DDRT_ALERT_N_AC_PIN {0}
	set_component_parameter_value MEM_DDRT_ALERT_N_DQS_GROUP {0}
	set_component_parameter_value MEM_DDRT_ALERT_N_PLACEMENT_ENUM {DDRT_ALERT_N_PLACEMENT_AUTO}
	set_component_parameter_value MEM_DDRT_ALERT_PAR_EN {1}
	set_component_parameter_value MEM_DDRT_ASR_ENUM {DDRT_ASR_MANUAL_NORMAL}
	set_component_parameter_value MEM_DDRT_ATCL_ENUM {DDRT_ATCL_DISABLED}
	set_component_parameter_value MEM_DDRT_BANK_ADDR_WIDTH {2}
	set_component_parameter_value MEM_DDRT_BANK_GROUP_WIDTH {2}
	set_component_parameter_value MEM_DDRT_BL_ENUM {DDRT_BL_BL8}
	set_component_parameter_value MEM_DDRT_BT_ENUM {DDRT_BT_SEQUENTIAL}
	set_component_parameter_value MEM_DDRT_CAL_MODE {0}
	set_component_parameter_value MEM_DDRT_CFG_GEN_DBE {0}
	set_component_parameter_value MEM_DDRT_CFG_GEN_SBE {0}
	set_component_parameter_value MEM_DDRT_CKE_PER_DIMM {1}
	set_component_parameter_value MEM_DDRT_COL_ADDR_WIDTH {10}
	set_component_parameter_value MEM_DDRT_DB_DQ_DRV_ENUM {DDRT_DB_DRV_STR_RZQ_7}
	set_component_parameter_value MEM_DDRT_DB_RTT_NOM_ENUM {DDRT_DB_RTT_NOM_ODT_DISABLED}
	set_component_parameter_value MEM_DDRT_DB_RTT_PARK_ENUM {DDRT_DB_RTT_PARK_ODT_DISABLED}
	set_component_parameter_value MEM_DDRT_DB_RTT_WR_ENUM {DDRT_DB_RTT_WR_RZQ_4}
	set_component_parameter_value MEM_DDRT_DEFAULT_ADDED_LATENCY {1}
	set_component_parameter_value MEM_DDRT_DEFAULT_PREAMBLE {1}
	set_component_parameter_value MEM_DDRT_DEFAULT_VREFOUT {1}
	set_component_parameter_value MEM_DDRT_DISCRETE_CS_WIDTH {1}
	set_component_parameter_value MEM_DDRT_DISCRETE_MIRROR_ADDRESSING_EN {0}
	set_component_parameter_value MEM_DDRT_DLL_EN {1}
	set_component_parameter_value MEM_DDRT_DM_EN {0}
	set_component_parameter_value MEM_DDRT_DQ_PER_DQS {4}
	set_component_parameter_value MEM_DDRT_DQ_WIDTH {72}
	set_component_parameter_value MEM_DDRT_DRV_STR_ENUM {DDRT_DRV_STR_RZQ_7}
	set_component_parameter_value MEM_DDRT_FINE_GRANULARITY_REFRESH {DDRT_FINE_REFRESH_FIXED_1X}
	set_component_parameter_value MEM_DDRT_FORMAT_ENUM {MEM_FORMAT_LRDIMM}
	set_component_parameter_value MEM_DDRT_GEARDOWN {DDRT_GEARDOWN_HR}
	set_component_parameter_value MEM_DDRT_HIDE_ADV_MR_SETTINGS {1}
	set_component_parameter_value MEM_DDRT_HIDE_LATENCY_SETTINGS {1}
	set_component_parameter_value MEM_DDRT_I2C_DIMM_0_SA {0}
	set_component_parameter_value MEM_DDRT_I2C_DIMM_1_SA {1}
	set_component_parameter_value MEM_DDRT_I2C_DIMM_2_SA {2}
	set_component_parameter_value MEM_DDRT_I2C_DIMM_3_SA {3}
	set_component_parameter_value MEM_DDRT_INTERNAL_VREFDQ_MONITOR {0}
	set_component_parameter_value MEM_DDRT_LRDIMM_ODT_LESS_BS {0}
	set_component_parameter_value MEM_DDRT_LRDIMM_ODT_LESS_BS_PARK_OHM {240}
	set_component_parameter_value MEM_DDRT_LRDIMM_VREFDQ_VALUE {}
	set_component_parameter_value MEM_DDRT_MAX_POWERDOWN {0}
	set_component_parameter_value MEM_DDRT_MIRROR_ADDRESSING_EN {1}
	set_component_parameter_value MEM_DDRT_MPR_READ_FORMAT {DDRT_MPR_READ_FORMAT_SERIAL}
	set_component_parameter_value MEM_DDRT_NUM_OF_DIMMS {1}
	set_component_parameter_value MEM_DDRT_ODT_IN_POWERDOWN {1}
	set_component_parameter_value MEM_DDRT_PARTIAL_WRITES {0}
	set_component_parameter_value MEM_DDRT_PERSISTENT_MODE {1}
	set_component_parameter_value MEM_DDRT_PER_DRAM_ADDR {0}
	set_component_parameter_value MEM_DDRT_PWR_MODE {DDRT_PWR_MODE_12W}
	set_component_parameter_value MEM_DDRT_RANKS_PER_DIMM {1}
	set_component_parameter_value MEM_DDRT_RCD_CA_IBT_ENUM {DDRT_RCD_CA_IBT_100}
	set_component_parameter_value MEM_DDRT_RCD_CKE_IBT_ENUM {DDRT_RCD_CKE_IBT_100}
	set_component_parameter_value MEM_DDRT_RCD_CS_IBT_ENUM {DDRT_RCD_CS_IBT_100}
	set_component_parameter_value MEM_DDRT_RCD_ODT_IBT_ENUM {DDRT_RCD_ODT_IBT_100}
	set_component_parameter_value MEM_DDRT_READ_DBI {0}
	set_component_parameter_value MEM_DDRT_READ_PREAMBLE_TRAINING {0}
	set_component_parameter_value MEM_DDRT_ROW_ADDR_WIDTH {18}
	set_component_parameter_value MEM_DDRT_RTT_NOM_ENUM {DDRT_RTT_NOM_RZQ_4}
	set_component_parameter_value MEM_DDRT_RTT_PARK {DDRT_RTT_PARK_ODT_DISABLED}
	set_component_parameter_value MEM_DDRT_RTT_WR_ENUM {DDRT_RTT_WR_ODT_DISABLED}
	set_component_parameter_value MEM_DDRT_R_ODT0_1X1 {off}
	set_component_parameter_value MEM_DDRT_R_ODT0_2X2 {off off}
	set_component_parameter_value MEM_DDRT_R_ODT0_4X2 {off off on on}
	set_component_parameter_value MEM_DDRT_R_ODT0_4X4 {off off off off}
	set_component_parameter_value MEM_DDRT_R_ODT1_2X2 {off off}
	set_component_parameter_value MEM_DDRT_R_ODT1_4X2 {on on off off}
	set_component_parameter_value MEM_DDRT_R_ODT1_4X4 {off off on on}
	set_component_parameter_value MEM_DDRT_R_ODT2_4X4 {off off off off}
	set_component_parameter_value MEM_DDRT_R_ODT3_4X4 {on on off off}
	set_component_parameter_value MEM_DDRT_R_ODTN_1X1 {Rank\ 0}
	set_component_parameter_value MEM_DDRT_R_ODTN_2X2 {Rank\ 0 Rank\ 1}
	set_component_parameter_value MEM_DDRT_R_ODTN_4X2 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDRT_R_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDRT_SELF_RFSH_ABORT {0}
	set_component_parameter_value MEM_DDRT_SPD_133_RCD_DB_VENDOR_LSB {0}
	set_component_parameter_value MEM_DDRT_SPD_134_RCD_DB_VENDOR_MSB {0}
	set_component_parameter_value MEM_DDRT_SPD_135_RCD_REV {0}
	set_component_parameter_value MEM_DDRT_SPD_137_RCD_CA_DRV {85}
	set_component_parameter_value MEM_DDRT_SPD_138_RCD_CK_DRV {5}
	set_component_parameter_value MEM_DDRT_SPD_139_DB_REV {0}
	set_component_parameter_value MEM_DDRT_SPD_140_DRAM_VREFDQ_R0 {29}
	set_component_parameter_value MEM_DDRT_SPD_141_DRAM_VREFDQ_R1 {29}
	set_component_parameter_value MEM_DDRT_SPD_142_DRAM_VREFDQ_R2 {29}
	set_component_parameter_value MEM_DDRT_SPD_143_DRAM_VREFDQ_R3 {29}
	set_component_parameter_value MEM_DDRT_SPD_144_DB_VREFDQ {25}
	set_component_parameter_value MEM_DDRT_SPD_145_DB_MDQ_DRV {21}
	set_component_parameter_value MEM_DDRT_SPD_148_DRAM_DRV {0}
	set_component_parameter_value MEM_DDRT_SPD_149_DRAM_RTT_WR_NOM {20}
	set_component_parameter_value MEM_DDRT_SPD_152_DRAM_RTT_PARK {39}
	set_component_parameter_value MEM_DDRT_SPEEDBIN_ENUM {DDRT_SPEEDBIN_2400}
	set_component_parameter_value MEM_DDRT_TCCD_L_CYC {6}
	set_component_parameter_value MEM_DDRT_TCCD_S_CYC {4}
	set_component_parameter_value MEM_DDRT_TCL {15}
	set_component_parameter_value MEM_DDRT_TDIVW_DJ_CYC {0.1}
	set_component_parameter_value MEM_DDRT_TDIVW_TOTAL_UI {0.2}
	set_component_parameter_value MEM_DDRT_TDQSCK_PS {165}
	set_component_parameter_value MEM_DDRT_TDQSQ_PS {66}
	set_component_parameter_value MEM_DDRT_TDQSQ_UI {0.16}
	set_component_parameter_value MEM_DDRT_TDQSS_CYC {0.27}
	set_component_parameter_value MEM_DDRT_TDSH_CYC {0.18}
	set_component_parameter_value MEM_DDRT_TDSS_CYC {0.18}
	set_component_parameter_value MEM_DDRT_TDVWP_UI {0.72}
	set_component_parameter_value MEM_DDRT_TEMP_CONTROLLED_RFSH_ENA {0}
	set_component_parameter_value MEM_DDRT_TEMP_CONTROLLED_RFSH_RANGE {DDRT_TEMP_CONTROLLED_RFSH_NORMAL}
	set_component_parameter_value MEM_DDRT_TEMP_SENSOR_READOUT {0}
	set_component_parameter_value MEM_DDRT_TFAW_DLR_CYC {16}
	set_component_parameter_value MEM_DDRT_TFAW_NS {21.0}
	set_component_parameter_value MEM_DDRT_TIH_DC_MV {75}
	set_component_parameter_value MEM_DDRT_TIH_PS {95}
	set_component_parameter_value MEM_DDRT_TINIT_US {500}
	set_component_parameter_value MEM_DDRT_TIS_AC_MV {100}
	set_component_parameter_value MEM_DDRT_TIS_PS {60}
	set_component_parameter_value MEM_DDRT_TMRD_CK_CYC {8}
	set_component_parameter_value MEM_DDRT_TQH_CYC {0.38}
	set_component_parameter_value MEM_DDRT_TQH_UI {0.76}
	set_component_parameter_value MEM_DDRT_TQSH_CYC {0.38}
	set_component_parameter_value MEM_DDRT_TRAS_NS {32.0}
	set_component_parameter_value MEM_DDRT_TRCD_NS {15.0}
	set_component_parameter_value MEM_DDRT_TREFI_US {7.8}
	set_component_parameter_value MEM_DDRT_TRFC_DLR_NS {90.0}
	set_component_parameter_value MEM_DDRT_TRFC_NS {260.0}
	set_component_parameter_value MEM_DDRT_TRP_NS {15.0}
	set_component_parameter_value MEM_DDRT_TRRD_DLR_CYC {4}
	set_component_parameter_value MEM_DDRT_TRRD_L_CYC {6}
	set_component_parameter_value MEM_DDRT_TRRD_S_CYC {4}
	set_component_parameter_value MEM_DDRT_TWLH_CYC {0.13}
	set_component_parameter_value MEM_DDRT_TWLH_PS {0.0}
	set_component_parameter_value MEM_DDRT_TWLS_CYC {0.13}
	set_component_parameter_value MEM_DDRT_TWLS_PS {0.0}
	set_component_parameter_value MEM_DDRT_TWR_NS {15.0}
	set_component_parameter_value MEM_DDRT_TWTR_L_CYC {9}
	set_component_parameter_value MEM_DDRT_TWTR_S_CYC {3}
	set_component_parameter_value MEM_DDRT_USER_READ_PREAMBLE {1}
	set_component_parameter_value MEM_DDRT_USER_TCL_ADDED {0}
	set_component_parameter_value MEM_DDRT_USER_VREFDQ_TRAINING_RANGE {DDRT_VREFDQ_TRAINING_RANGE_1}
	set_component_parameter_value MEM_DDRT_USER_VREFDQ_TRAINING_VALUE {56.0}
	set_component_parameter_value MEM_DDRT_USER_WRITE_PREAMBLE {1}
	set_component_parameter_value MEM_DDRT_USER_WTCL_ADDED {6}
	set_component_parameter_value MEM_DDRT_USE_DEFAULT_ODT {1}
	set_component_parameter_value MEM_DDRT_VDIVW_TOTAL {136}
	set_component_parameter_value MEM_DDRT_WRITE_CRC {0}
	set_component_parameter_value MEM_DDRT_WRITE_DBI {0}
	set_component_parameter_value MEM_DDRT_WTCL {18}
	set_component_parameter_value MEM_DDRT_W_ODT0_1X1 {on}
	set_component_parameter_value MEM_DDRT_W_ODT0_2X2 {on off}
	set_component_parameter_value MEM_DDRT_W_ODT0_4X2 {off off on on}
	set_component_parameter_value MEM_DDRT_W_ODT0_4X4 {on on off off}
	set_component_parameter_value MEM_DDRT_W_ODT1_2X2 {off on}
	set_component_parameter_value MEM_DDRT_W_ODT1_4X2 {on on off off}
	set_component_parameter_value MEM_DDRT_W_ODT1_4X4 {off off on on}
	set_component_parameter_value MEM_DDRT_W_ODT2_4X4 {off off on on}
	set_component_parameter_value MEM_DDRT_W_ODT3_4X4 {on on off off}
	set_component_parameter_value MEM_DDRT_W_ODTN_1X1 {Rank\ 0}
	set_component_parameter_value MEM_DDRT_W_ODTN_2X2 {Rank\ 0 Rank\ 1}
	set_component_parameter_value MEM_DDRT_W_ODTN_4X2 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_DDRT_W_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_LPDDR3_BANK_ADDR_WIDTH {3}
	set_component_parameter_value MEM_LPDDR3_BL {LPDDR3_BL_BL8}
	set_component_parameter_value MEM_LPDDR3_CK_WIDTH {1}
	set_component_parameter_value MEM_LPDDR3_COL_ADDR_WIDTH {10}
	set_component_parameter_value MEM_LPDDR3_DATA_LATENCY {LPDDR3_DL_RL12_WL6}
	set_component_parameter_value MEM_LPDDR3_DISCRETE_CS_WIDTH {1}
	set_component_parameter_value MEM_LPDDR3_DM_EN {1}
	set_component_parameter_value MEM_LPDDR3_DQODT {LPDDR3_DQODT_DISABLE}
	set_component_parameter_value MEM_LPDDR3_DQ_WIDTH {32}
	set_component_parameter_value MEM_LPDDR3_DRV_STR {LPDDR3_DRV_STR_40D_40U}
	set_component_parameter_value MEM_LPDDR3_PDODT {LPDDR3_PDODT_DISABLED}
	set_component_parameter_value MEM_LPDDR3_ROW_ADDR_WIDTH {15}
	set_component_parameter_value MEM_LPDDR3_R_ODT0_1X1 {off}
	set_component_parameter_value MEM_LPDDR3_R_ODT0_2X2 {off off}
	set_component_parameter_value MEM_LPDDR3_R_ODT0_4X4 {off off off off}
	set_component_parameter_value MEM_LPDDR3_R_ODT1_2X2 {off off}
	set_component_parameter_value MEM_LPDDR3_R_ODT1_4X4 {off off off off}
	set_component_parameter_value MEM_LPDDR3_R_ODT2_4X4 {off off off off}
	set_component_parameter_value MEM_LPDDR3_R_ODT3_4X4 {off off off off}
	set_component_parameter_value MEM_LPDDR3_R_ODTN_1X1 {Rank\ 0}
	set_component_parameter_value MEM_LPDDR3_R_ODTN_2X2 {Rank\ 0 Rank\ 1}
	set_component_parameter_value MEM_LPDDR3_R_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_LPDDR3_SPEEDBIN_ENUM {LPDDR3_SPEEDBIN_1600}
	set_component_parameter_value MEM_LPDDR3_TDH_DC_MV {100}
	set_component_parameter_value MEM_LPDDR3_TDH_PS {100}
	set_component_parameter_value MEM_LPDDR3_TDQSCKDL {614}
	set_component_parameter_value MEM_LPDDR3_TDQSQ_PS {135}
	set_component_parameter_value MEM_LPDDR3_TDQSS_CYC {1.25}
	set_component_parameter_value MEM_LPDDR3_TDSH_CYC {0.2}
	set_component_parameter_value MEM_LPDDR3_TDSS_CYC {0.2}
	set_component_parameter_value MEM_LPDDR3_TDS_AC_MV {150}
	set_component_parameter_value MEM_LPDDR3_TDS_PS {75}
	set_component_parameter_value MEM_LPDDR3_TFAW_NS {50.0}
	set_component_parameter_value MEM_LPDDR3_TIH_DC_MV {100}
	set_component_parameter_value MEM_LPDDR3_TIH_PS {100}
	set_component_parameter_value MEM_LPDDR3_TINIT_US {500}
	set_component_parameter_value MEM_LPDDR3_TIS_AC_MV {150}
	set_component_parameter_value MEM_LPDDR3_TIS_PS {75}
	set_component_parameter_value MEM_LPDDR3_TMRR_CK_CYC {4}
	set_component_parameter_value MEM_LPDDR3_TMRW_CK_CYC {10}
	set_component_parameter_value MEM_LPDDR3_TQH_CYC {0.38}
	set_component_parameter_value MEM_LPDDR3_TQSH_CYC {0.38}
	set_component_parameter_value MEM_LPDDR3_TRAS_NS {42.5}
	set_component_parameter_value MEM_LPDDR3_TRCD_NS {18.0}
	set_component_parameter_value MEM_LPDDR3_TREFI_US {3.9}
	set_component_parameter_value MEM_LPDDR3_TRFC_NS {210.0}
	set_component_parameter_value MEM_LPDDR3_TRP_NS {18.0}
	set_component_parameter_value MEM_LPDDR3_TRRD_CYC {8}
	set_component_parameter_value MEM_LPDDR3_TRTP_CYC {6}
	set_component_parameter_value MEM_LPDDR3_TWLH_PS {175.0}
	set_component_parameter_value MEM_LPDDR3_TWLS_PS {175.0}
	set_component_parameter_value MEM_LPDDR3_TWR_NS {15.0}
	set_component_parameter_value MEM_LPDDR3_TWTR_CYC {6}
	set_component_parameter_value MEM_LPDDR3_USE_DEFAULT_ODT {1}
	set_component_parameter_value MEM_LPDDR3_W_ODT0_1X1 {on}
	set_component_parameter_value MEM_LPDDR3_W_ODT0_2X2 {on on}
	set_component_parameter_value MEM_LPDDR3_W_ODT0_4X4 {on on on on}
	set_component_parameter_value MEM_LPDDR3_W_ODT1_2X2 {off off}
	set_component_parameter_value MEM_LPDDR3_W_ODT1_4X4 {off off off off}
	set_component_parameter_value MEM_LPDDR3_W_ODT2_4X4 {off off off off}
	set_component_parameter_value MEM_LPDDR3_W_ODT3_4X4 {off off off off}
	set_component_parameter_value MEM_LPDDR3_W_ODTN_1X1 {Rank\ 0}
	set_component_parameter_value MEM_LPDDR3_W_ODTN_2X2 {Rank\ 0 Rank\ 1}
	set_component_parameter_value MEM_LPDDR3_W_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
	set_component_parameter_value MEM_QDR2_ADDR_WIDTH {19}
	set_component_parameter_value MEM_QDR2_BL {4}
	set_component_parameter_value MEM_QDR2_BWS_EN {1}
	set_component_parameter_value MEM_QDR2_DATA_PER_DEVICE {36}
	set_component_parameter_value MEM_QDR2_INTERNAL_JITTER_NS {0.08}
	set_component_parameter_value MEM_QDR2_SPEEDBIN_ENUM {QDR2_SPEEDBIN_633}
	set_component_parameter_value MEM_QDR2_TCCQO_NS {0.45}
	set_component_parameter_value MEM_QDR2_TCQDOH_NS {-0.09}
	set_component_parameter_value MEM_QDR2_TCQD_NS {0.09}
	set_component_parameter_value MEM_QDR2_TCQH_NS {0.71}
	set_component_parameter_value MEM_QDR2_THA_NS {0.18}
	set_component_parameter_value MEM_QDR2_THD_NS {0.18}
	set_component_parameter_value MEM_QDR2_TRL_CYC {2.5}
	set_component_parameter_value MEM_QDR2_TSA_NS {0.23}
	set_component_parameter_value MEM_QDR2_TSD_NS {0.23}
	set_component_parameter_value MEM_QDR2_WIDTH_EXPANDED {0}
	set_component_parameter_value MEM_QDR4_AC_ODT_MODE_ENUM {QDR4_ODT_25_PCT}
	set_component_parameter_value MEM_QDR4_ADDR_INV_ENA {0}
	set_component_parameter_value MEM_QDR4_ADDR_WIDTH {21}
	set_component_parameter_value MEM_QDR4_CK_ODT_MODE_ENUM {QDR4_ODT_25_PCT}
	set_component_parameter_value MEM_QDR4_DATA_INV_ENA {1}
	set_component_parameter_value MEM_QDR4_DATA_ODT_MODE_ENUM {QDR4_ODT_25_PCT}
	set_component_parameter_value MEM_QDR4_DQ_PER_PORT_PER_DEVICE {36}
	set_component_parameter_value MEM_QDR4_MEM_TYPE_ENUM {MEM_XP}
	set_component_parameter_value MEM_QDR4_PD_OUTPUT_DRIVE_MODE_ENUM {QDR4_OUTPUT_DRIVE_25_PCT}
	set_component_parameter_value MEM_QDR4_PU_OUTPUT_DRIVE_MODE_ENUM {QDR4_OUTPUT_DRIVE_25_PCT}
	set_component_parameter_value MEM_QDR4_SKIP_ODT_SWEEPING {1}
	set_component_parameter_value MEM_QDR4_SPEEDBIN_ENUM {QDR4_SPEEDBIN_2133}
	set_component_parameter_value MEM_QDR4_TASH_PS {170}
	set_component_parameter_value MEM_QDR4_TCKDK_MAX_PS {150}
	set_component_parameter_value MEM_QDR4_TCKDK_MIN_PS {-150}
	set_component_parameter_value MEM_QDR4_TCKQK_MAX_PS {225}
	set_component_parameter_value MEM_QDR4_TCSH_PS {170}
	set_component_parameter_value MEM_QDR4_TISH_PS {150}
	set_component_parameter_value MEM_QDR4_TQH_CYC {0.4}
	set_component_parameter_value MEM_QDR4_TQKQ_MAX_PS {75}
	set_component_parameter_value MEM_QDR4_USE_ADDR_PARITY {0}
	set_component_parameter_value MEM_QDR4_WIDTH_EXPANDED {0}
	set_component_parameter_value MEM_RLD2_ADDR_WIDTH {21}
	set_component_parameter_value MEM_RLD2_BANK_ADDR_WIDTH {3}
	set_component_parameter_value MEM_RLD2_BL {4}
	set_component_parameter_value MEM_RLD2_CONFIG_ENUM {RLD2_CONFIG_TRC_8_TRL_8_TWL_9}
	set_component_parameter_value MEM_RLD2_DM_EN {1}
	set_component_parameter_value MEM_RLD2_DQ_PER_DEVICE {9}
	set_component_parameter_value MEM_RLD2_DRIVE_IMPEDENCE_ENUM {RLD2_DRIVE_IMPEDENCE_INTERNAL_50}
	set_component_parameter_value MEM_RLD2_ODT_MODE_ENUM {RLD2_ODT_ON}
	set_component_parameter_value MEM_RLD2_REFRESH_INTERVAL_US {0.24}
	set_component_parameter_value MEM_RLD2_SPEEDBIN_ENUM {RLD2_SPEEDBIN_18}
	set_component_parameter_value MEM_RLD2_TAH_NS {0.3}
	set_component_parameter_value MEM_RLD2_TAS_NS {0.3}
	set_component_parameter_value MEM_RLD2_TCKDK_MAX_NS {0.3}
	set_component_parameter_value MEM_RLD2_TCKDK_MIN_NS {-0.3}
	set_component_parameter_value MEM_RLD2_TCKH_CYC {0.45}
	set_component_parameter_value MEM_RLD2_TCKQK_MAX_NS {0.2}
	set_component_parameter_value MEM_RLD2_TDH_NS {0.17}
	set_component_parameter_value MEM_RLD2_TDS_NS {0.17}
	set_component_parameter_value MEM_RLD2_TQKH_HCYC {0.9}
	set_component_parameter_value MEM_RLD2_TQKQ_MAX_NS {0.12}
	set_component_parameter_value MEM_RLD2_TQKQ_MIN_NS {-0.12}
	set_component_parameter_value MEM_RLD2_WIDTH_EXPANDED {0}
	set_component_parameter_value MEM_RLD3_ADDR_WIDTH {20}
	set_component_parameter_value MEM_RLD3_AREF_PROTOCOL_ENUM {RLD3_AREF_BAC}
	set_component_parameter_value MEM_RLD3_BANK_ADDR_WIDTH {4}
	set_component_parameter_value MEM_RLD3_BL {2}
	set_component_parameter_value MEM_RLD3_DATA_LATENCY_MODE_ENUM {RLD3_DL_RL16_WL17}
	set_component_parameter_value MEM_RLD3_DEPTH_EXPANDED {0}
	set_component_parameter_value MEM_RLD3_DM_EN {1}
	set_component_parameter_value MEM_RLD3_DQ_PER_DEVICE {36}
	set_component_parameter_value MEM_RLD3_ODT_MODE_ENUM {RLD3_ODT_40}
	set_component_parameter_value MEM_RLD3_OUTPUT_DRIVE_MODE_ENUM {RLD3_OUTPUT_DRIVE_40}
	set_component_parameter_value MEM_RLD3_SPEEDBIN_ENUM {RLD3_SPEEDBIN_093E}
	set_component_parameter_value MEM_RLD3_TCKDK_MAX_CYC {0.27}
	set_component_parameter_value MEM_RLD3_TCKDK_MIN_CYC {-0.27}
	set_component_parameter_value MEM_RLD3_TCKQK_MAX_PS {135}
	set_component_parameter_value MEM_RLD3_TDH_DC_MV {100}
	set_component_parameter_value MEM_RLD3_TDH_PS {5}
	set_component_parameter_value MEM_RLD3_TDS_AC_MV {150}
	set_component_parameter_value MEM_RLD3_TDS_PS {-30}
	set_component_parameter_value MEM_RLD3_TIH_DC_MV {100}
	set_component_parameter_value MEM_RLD3_TIH_PS {65}
	set_component_parameter_value MEM_RLD3_TIS_AC_MV {150}
	set_component_parameter_value MEM_RLD3_TIS_PS {85}
	set_component_parameter_value MEM_RLD3_TQH_CYC {0.38}
	set_component_parameter_value MEM_RLD3_TQKQ_MAX_PS {75}
	set_component_parameter_value MEM_RLD3_T_RC_MODE_ENUM {RLD3_TRC_9}
	set_component_parameter_value MEM_RLD3_WIDTH_EXPANDED {0}
	set_component_parameter_value MEM_RLD3_WRITE_PROTOCOL_ENUM {RLD3_WRITE_1BANK}
	set_component_parameter_value NUM_IPS {1}
	set_component_parameter_value PHY_DDR3_CAL_ADDR0 {0}
	set_component_parameter_value PHY_DDR3_CAL_ADDR1 {8}
	set_component_parameter_value PHY_DDR3_CAL_ENABLE_NON_DES {0}
	set_component_parameter_value PHY_DDR3_CONFIG_ENUM {CONFIG_PHY_AND_HARD_CTRL}
	set_component_parameter_value PHY_DDR3_CORE_CLKS_SHARING_ENUM {CORE_CLKS_SHARING_DISABLED}
	set_component_parameter_value PHY_DDR3_CORE_CLKS_SHARING_EXPOSE_SLAVE_OUT {0}
	set_component_parameter_value PHY_DDR3_DEFAULT_IO {1}
	set_component_parameter_value PHY_DDR3_DEFAULT_REF_CLK_FREQ {1}
	set_component_parameter_value PHY_DDR3_HPS_ENABLE_EARLY_RELEASE {0}
	set_component_parameter_value PHY_DDR3_IO_VOLTAGE {1.5}
	set_component_parameter_value PHY_DDR3_MEM_CLK_FREQ_MHZ {1066.667}
	set_component_parameter_value PHY_DDR3_MIMIC_HPS_EMIF {0}
	set_component_parameter_value PHY_DDR3_RATE_ENUM {RATE_QUARTER}
	set_component_parameter_value PHY_DDR3_REF_CLK_JITTER_PS {10.0}
	set_component_parameter_value PHY_DDR3_USER_AC_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_AC_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_AC_MODE_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_AC_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_AUTO_STARTING_VREFIN_EN {1}
	set_component_parameter_value PHY_DDR3_USER_CK_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_CK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_CK_MODE_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_CK_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_DATA_IN_MODE_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_DATA_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_DATA_OUT_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_DATA_OUT_MODE_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_DATA_OUT_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_DLL_CORE_UPDN_EN {1}
	set_component_parameter_value PHY_DDR3_USER_PERIODIC_OCT_RECAL_ENUM {PERIODIC_OCT_RECAL_AUTO}
	set_component_parameter_value PHY_DDR3_USER_PING_PONG_EN {0}
	set_component_parameter_value PHY_DDR3_USER_PLL_REF_CLK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_REF_CLK_FREQ_MHZ {-1.0}
	set_component_parameter_value PHY_DDR3_USER_RZQ_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_DDR3_USER_STARTING_VREFIN {70.0}
	set_component_parameter_value PHY_DDR4_ALLOW_72_DQ_WIDTH {0}
	set_component_parameter_value PHY_DDR4_CONFIG_ENUM {CONFIG_PHY_AND_HARD_CTRL}
	set_component_parameter_value PHY_DDR4_CORE_CLKS_SHARING_ENUM {CORE_CLKS_SHARING_DISABLED}
	set_component_parameter_value PHY_DDR4_CORE_CLKS_SHARING_EXPOSE_SLAVE_OUT {0}
	set_component_parameter_value PHY_DDR4_DEFAULT_IO {0}
	set_component_parameter_value PHY_DDR4_DEFAULT_REF_CLK_FREQ {0}
	set_component_parameter_value PHY_DDR4_HPS_ENABLE_EARLY_RELEASE {0}
	set_component_parameter_value PHY_DDR4_IO_VOLTAGE {1.2}
	set_component_parameter_value PHY_DDR4_MEM_CLK_FREQ_MHZ {1200.0}
	set_component_parameter_value PHY_DDR4_MIMIC_HPS_EMIF {0}
	set_component_parameter_value PHY_DDR4_RATE_ENUM {RATE_QUARTER}
	set_component_parameter_value PHY_DDR4_REF_CLK_JITTER_PS {10.0}
	set_component_parameter_value PHY_DDR4_USER_AC_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_DDR4_USER_AC_IO_STD_ENUM {IO_STD_SSTL_12}
	set_component_parameter_value PHY_DDR4_USER_AC_MODE_ENUM {OUT_OCT_40_CAL}
	set_component_parameter_value PHY_DDR4_USER_AC_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_DDR4_USER_AUTO_STARTING_VREFIN_EN {1}
	set_component_parameter_value PHY_DDR4_USER_CK_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_DDR4_USER_CK_IO_STD_ENUM {IO_STD_SSTL_12}
	set_component_parameter_value PHY_DDR4_USER_CK_MODE_ENUM {OUT_OCT_40_CAL}
	set_component_parameter_value PHY_DDR4_USER_CK_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_DDR4_USER_CLAMSHELL_EN {0}
	set_component_parameter_value PHY_DDR4_USER_DATA_IN_MODE_ENUM {IN_OCT_60_CAL}
	set_component_parameter_value PHY_DDR4_USER_DATA_IO_STD_ENUM {IO_STD_POD_12}
	set_component_parameter_value PHY_DDR4_USER_DATA_OUT_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_DDR4_USER_DATA_OUT_MODE_ENUM {OUT_OCT_40_CAL}
	set_component_parameter_value PHY_DDR4_USER_DATA_OUT_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_DDR4_USER_DLL_CORE_UPDN_EN {1}
	set_component_parameter_value PHY_DDR4_USER_PERIODIC_OCT_RECAL_ENUM {PERIODIC_OCT_RECAL_AUTO}
	set_component_parameter_value PHY_DDR4_USER_PING_PONG_EN {0}
	set_component_parameter_value PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM {IO_STD_TRUE_DIFF_SIGNALING}
	set_component_parameter_value PHY_DDR4_USER_REF_CLK_FREQ_MHZ {33.333}
	set_component_parameter_value PHY_DDR4_USER_RZQ_IO_STD_ENUM {IO_STD_CMOS_12}
	set_component_parameter_value PHY_DDR4_USER_STARTING_VREFIN {70.0}
	set_component_parameter_value PHY_DDRT_2CH_EN {0}
	set_component_parameter_value PHY_DDRT_CONFIG_ENUM {CONFIG_PHY_AND_SOFT_CTRL}
	set_component_parameter_value PHY_DDRT_CORE_CLKS_SHARING_ENUM {CORE_CLKS_SHARING_DISABLED}
	set_component_parameter_value PHY_DDRT_CORE_CLKS_SHARING_EXPOSE_SLAVE_OUT {0}
	set_component_parameter_value PHY_DDRT_DEFAULT_IO {1}
	set_component_parameter_value PHY_DDRT_DEFAULT_REF_CLK_FREQ {1}
	set_component_parameter_value PHY_DDRT_EXPORT_CLK_STP_IF {0}
	set_component_parameter_value PHY_DDRT_HPS_ENABLE_EARLY_RELEASE {0}
	set_component_parameter_value PHY_DDRT_I2C_USE_SMC {0}
	set_component_parameter_value PHY_DDRT_IC_EN {1}
	set_component_parameter_value PHY_DDRT_IO_VOLTAGE {1.2}
	set_component_parameter_value PHY_DDRT_MEM_CLK_FREQ_MHZ {1200.0}
	set_component_parameter_value PHY_DDRT_MIMIC_HPS_EMIF {0}
	set_component_parameter_value PHY_DDRT_RATE_ENUM {RATE_QUARTER}
	set_component_parameter_value PHY_DDRT_REF_CLK_JITTER_PS {10.0}
	set_component_parameter_value PHY_DDRT_USER_AC_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_AC_IN_MODE_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_AC_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_AC_MODE_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_AC_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_AUTO_STARTING_VREFIN_EN {1}
	set_component_parameter_value PHY_DDRT_USER_CK_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_CK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_CK_MODE_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_CK_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_DATA_IN_MODE_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_DATA_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_DATA_OUT_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_DATA_OUT_MODE_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_DATA_OUT_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_DLL_CORE_UPDN_EN {0}
	set_component_parameter_value PHY_DDRT_USER_PERIODIC_OCT_RECAL_ENUM {PERIODIC_OCT_RECAL_AUTO}
	set_component_parameter_value PHY_DDRT_USER_PING_PONG_EN {0}
	set_component_parameter_value PHY_DDRT_USER_PLL_REF_CLK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_REF_CLK_FREQ_MHZ {-1.0}
	set_component_parameter_value PHY_DDRT_USER_RZQ_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_DDRT_USER_STARTING_VREFIN {70.0}
	set_component_parameter_value PHY_DDRT_USE_OLD_SMBUS_MULTICOL {0}
	set_component_parameter_value PHY_LPDDR3_CONFIG_ENUM {CONFIG_PHY_AND_HARD_CTRL}
	set_component_parameter_value PHY_LPDDR3_CORE_CLKS_SHARING_ENUM {CORE_CLKS_SHARING_DISABLED}
	set_component_parameter_value PHY_LPDDR3_CORE_CLKS_SHARING_EXPOSE_SLAVE_OUT {0}
	set_component_parameter_value PHY_LPDDR3_DEFAULT_IO {1}
	set_component_parameter_value PHY_LPDDR3_DEFAULT_REF_CLK_FREQ {1}
	set_component_parameter_value PHY_LPDDR3_HPS_ENABLE_EARLY_RELEASE {0}
	set_component_parameter_value PHY_LPDDR3_IO_VOLTAGE {1.2}
	set_component_parameter_value PHY_LPDDR3_MEM_CLK_FREQ_MHZ {800.0}
	set_component_parameter_value PHY_LPDDR3_MIMIC_HPS_EMIF {0}
	set_component_parameter_value PHY_LPDDR3_RATE_ENUM {RATE_QUARTER}
	set_component_parameter_value PHY_LPDDR3_REF_CLK_JITTER_PS {10.0}
	set_component_parameter_value PHY_LPDDR3_USER_AC_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_AC_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_AC_MODE_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_AC_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_AUTO_STARTING_VREFIN_EN {1}
	set_component_parameter_value PHY_LPDDR3_USER_CK_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_CK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_CK_MODE_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_CK_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_DATA_IN_MODE_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_DATA_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_DATA_OUT_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_DATA_OUT_MODE_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_DATA_OUT_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_DLL_CORE_UPDN_EN {0}
	set_component_parameter_value PHY_LPDDR3_USER_PERIODIC_OCT_RECAL_ENUM {PERIODIC_OCT_RECAL_AUTO}
	set_component_parameter_value PHY_LPDDR3_USER_PING_PONG_EN {0}
	set_component_parameter_value PHY_LPDDR3_USER_PLL_REF_CLK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_REF_CLK_FREQ_MHZ {-1.0}
	set_component_parameter_value PHY_LPDDR3_USER_RZQ_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_LPDDR3_USER_STARTING_VREFIN {70.0}
	set_component_parameter_value PHY_QDR2_CONFIG_ENUM {CONFIG_PHY_AND_SOFT_CTRL}
	set_component_parameter_value PHY_QDR2_CORE_CLKS_SHARING_ENUM {CORE_CLKS_SHARING_DISABLED}
	set_component_parameter_value PHY_QDR2_CORE_CLKS_SHARING_EXPOSE_SLAVE_OUT {0}
	set_component_parameter_value PHY_QDR2_DEFAULT_IO {1}
	set_component_parameter_value PHY_QDR2_DEFAULT_REF_CLK_FREQ {1}
	set_component_parameter_value PHY_QDR2_HPS_ENABLE_EARLY_RELEASE {0}
	set_component_parameter_value PHY_QDR2_IO_VOLTAGE {1.5}
	set_component_parameter_value PHY_QDR2_MEM_CLK_FREQ_MHZ {633.333}
	set_component_parameter_value PHY_QDR2_MIMIC_HPS_EMIF {0}
	set_component_parameter_value PHY_QDR2_RATE_ENUM {RATE_HALF}
	set_component_parameter_value PHY_QDR2_REF_CLK_JITTER_PS {10.0}
	set_component_parameter_value PHY_QDR2_USER_AC_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_AC_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_AC_MODE_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_AC_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_AUTO_STARTING_VREFIN_EN {1}
	set_component_parameter_value PHY_QDR2_USER_CK_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_CK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_CK_MODE_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_CK_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_DATA_IN_MODE_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_DATA_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_DATA_OUT_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_DATA_OUT_MODE_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_DATA_OUT_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_DLL_CORE_UPDN_EN {0}
	set_component_parameter_value PHY_QDR2_USER_PERIODIC_OCT_RECAL_ENUM {PERIODIC_OCT_RECAL_AUTO}
	set_component_parameter_value PHY_QDR2_USER_PING_PONG_EN {0}
	set_component_parameter_value PHY_QDR2_USER_PLL_REF_CLK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_REF_CLK_FREQ_MHZ {-1.0}
	set_component_parameter_value PHY_QDR2_USER_RZQ_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_QDR2_USER_STARTING_VREFIN {70.0}
	set_component_parameter_value PHY_QDR4_CONFIG_ENUM {CONFIG_PHY_AND_SOFT_CTRL}
	set_component_parameter_value PHY_QDR4_CORE_CLKS_SHARING_ENUM {CORE_CLKS_SHARING_DISABLED}
	set_component_parameter_value PHY_QDR4_CORE_CLKS_SHARING_EXPOSE_SLAVE_OUT {0}
	set_component_parameter_value PHY_QDR4_DEFAULT_IO {1}
	set_component_parameter_value PHY_QDR4_DEFAULT_REF_CLK_FREQ {1}
	set_component_parameter_value PHY_QDR4_HPS_ENABLE_EARLY_RELEASE {0}
	set_component_parameter_value PHY_QDR4_IO_VOLTAGE {1.2}
	set_component_parameter_value PHY_QDR4_MEM_CLK_FREQ_MHZ {1066.667}
	set_component_parameter_value PHY_QDR4_MIMIC_HPS_EMIF {0}
	set_component_parameter_value PHY_QDR4_RATE_ENUM {RATE_QUARTER}
	set_component_parameter_value PHY_QDR4_REF_CLK_JITTER_PS {10.0}
	set_component_parameter_value PHY_QDR4_USER_AC_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_AC_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_AC_MODE_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_AC_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_AUTO_STARTING_VREFIN_EN {1}
	set_component_parameter_value PHY_QDR4_USER_CK_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_CK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_CK_MODE_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_CK_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_DATA_IN_MODE_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_DATA_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_DATA_OUT_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_DATA_OUT_MODE_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_DATA_OUT_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_DLL_CORE_UPDN_EN {1}
	set_component_parameter_value PHY_QDR4_USER_PERIODIC_OCT_RECAL_ENUM {PERIODIC_OCT_RECAL_AUTO}
	set_component_parameter_value PHY_QDR4_USER_PING_PONG_EN {0}
	set_component_parameter_value PHY_QDR4_USER_PLL_REF_CLK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_REF_CLK_FREQ_MHZ {-1.0}
	set_component_parameter_value PHY_QDR4_USER_RZQ_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_QDR4_USER_STARTING_VREFIN {70.0}
	set_component_parameter_value PHY_RLD2_CONFIG_ENUM {CONFIG_PHY_AND_SOFT_CTRL}
	set_component_parameter_value PHY_RLD2_CORE_CLKS_SHARING_ENUM {CORE_CLKS_SHARING_DISABLED}
	set_component_parameter_value PHY_RLD2_CORE_CLKS_SHARING_EXPOSE_SLAVE_OUT {0}
	set_component_parameter_value PHY_RLD2_DEFAULT_IO {1}
	set_component_parameter_value PHY_RLD2_DEFAULT_REF_CLK_FREQ {1}
	set_component_parameter_value PHY_RLD2_HPS_ENABLE_EARLY_RELEASE {0}
	set_component_parameter_value PHY_RLD2_IO_VOLTAGE {1.8}
	set_component_parameter_value PHY_RLD2_MEM_CLK_FREQ_MHZ {533.333}
	set_component_parameter_value PHY_RLD2_MIMIC_HPS_EMIF {0}
	set_component_parameter_value PHY_RLD2_RATE_ENUM {RATE_HALF}
	set_component_parameter_value PHY_RLD2_REF_CLK_JITTER_PS {10.0}
	set_component_parameter_value PHY_RLD2_USER_AC_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_AC_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_AC_MODE_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_AC_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_AUTO_STARTING_VREFIN_EN {1}
	set_component_parameter_value PHY_RLD2_USER_CK_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_CK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_CK_MODE_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_CK_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_DATA_IN_MODE_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_DATA_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_DATA_OUT_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_DATA_OUT_MODE_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_DATA_OUT_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_DLL_CORE_UPDN_EN {0}
	set_component_parameter_value PHY_RLD2_USER_PERIODIC_OCT_RECAL_ENUM {PERIODIC_OCT_RECAL_AUTO}
	set_component_parameter_value PHY_RLD2_USER_PING_PONG_EN {0}
	set_component_parameter_value PHY_RLD2_USER_PLL_REF_CLK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_REF_CLK_FREQ_MHZ {-1.0}
	set_component_parameter_value PHY_RLD2_USER_RZQ_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_RLD2_USER_STARTING_VREFIN {70.0}
	set_component_parameter_value PHY_RLD3_CONFIG_ENUM {CONFIG_PHY_ONLY}
	set_component_parameter_value PHY_RLD3_CORE_CLKS_SHARING_ENUM {CORE_CLKS_SHARING_DISABLED}
	set_component_parameter_value PHY_RLD3_CORE_CLKS_SHARING_EXPOSE_SLAVE_OUT {0}
	set_component_parameter_value PHY_RLD3_DEFAULT_IO {1}
	set_component_parameter_value PHY_RLD3_DEFAULT_REF_CLK_FREQ {1}
	set_component_parameter_value PHY_RLD3_HPS_ENABLE_EARLY_RELEASE {0}
	set_component_parameter_value PHY_RLD3_IO_VOLTAGE {1.2}
	set_component_parameter_value PHY_RLD3_MEM_CLK_FREQ_MHZ {1066.667}
	set_component_parameter_value PHY_RLD3_MIMIC_HPS_EMIF {0}
	set_component_parameter_value PHY_RLD3_RATE_ENUM {RATE_QUARTER}
	set_component_parameter_value PHY_RLD3_REF_CLK_JITTER_PS {10.0}
	set_component_parameter_value PHY_RLD3_USER_AC_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_AC_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_AC_MODE_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_AC_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_AUTO_STARTING_VREFIN_EN {1}
	set_component_parameter_value PHY_RLD3_USER_CK_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_CK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_CK_MODE_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_CK_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_DATA_IN_MODE_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_DATA_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_DATA_OUT_DEEMPHASIS_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_DATA_OUT_MODE_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_DATA_OUT_SLEW_RATE_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_DLL_CORE_UPDN_EN {0}
	set_component_parameter_value PHY_RLD3_USER_PERIODIC_OCT_RECAL_ENUM {PERIODIC_OCT_RECAL_AUTO}
	set_component_parameter_value PHY_RLD3_USER_PING_PONG_EN {0}
	set_component_parameter_value PHY_RLD3_USER_PLL_REF_CLK_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_REF_CLK_FREQ_MHZ {-1.0}
	set_component_parameter_value PHY_RLD3_USER_RZQ_IO_STD_ENUM {unset}
	set_component_parameter_value PHY_RLD3_USER_STARTING_VREFIN {70.0}
	set_component_parameter_value PLL_ADD_EXTRA_CLKS {0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_0 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_1 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_2 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_3 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_4 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_5 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_6 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_7 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_8 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_0 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_1 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_2 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_3 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_4 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_5 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_6 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_7 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_8 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_0 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_1 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_2 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_3 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_4 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_5 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_6 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_7 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_8 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_0 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_1 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_2 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_3 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_4 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_5 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_6 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_7 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_8 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_0 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_1 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_2 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_3 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_4 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_5 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_6 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_7 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_8 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_0 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_1 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_2 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_3 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_4 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_5 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_6 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_7 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_8 {50.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_0 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_1 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_2 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_3 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_4 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_5 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_6 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_7 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_8 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_PHASE_GUI_0 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_PHASE_GUI_1 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_PHASE_GUI_2 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_PHASE_GUI_3 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_PHASE_GUI_4 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_PHASE_GUI_5 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_PHASE_GUI_6 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_PHASE_GUI_7 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_DESIRED_PHASE_GUI_8 {0.0}
	set_component_parameter_value PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_0 {ps}
	set_component_parameter_value PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_1 {ps}
	set_component_parameter_value PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_2 {ps}
	set_component_parameter_value PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_3 {ps}
	set_component_parameter_value PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_4 {ps}
	set_component_parameter_value PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_5 {ps}
	set_component_parameter_value PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_6 {ps}
	set_component_parameter_value PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_7 {ps}
	set_component_parameter_value PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_8 {ps}
	set_component_parameter_value PLL_USER_NUM_OF_EXTRA_CLKS {0}
	set_component_parameter_value PROTOCOL_ENUM {PROTOCOL_DDR4}
	set_component_parameter_value SHORT_QSYS_INTERFACE_NAMES {1}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation emif_fm_0
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface local_reset_req conduit INPUT
	set_instantiation_interface_parameter_value local_reset_req associatedClock {}
	set_instantiation_interface_parameter_value local_reset_req associatedReset {}
	set_instantiation_interface_parameter_value local_reset_req prSafe {false}
	add_instantiation_interface_port local_reset_req local_reset_req local_reset_req 1 STD_LOGIC Input
	add_instantiation_interface local_reset_status conduit INPUT
	set_instantiation_interface_parameter_value local_reset_status associatedClock {}
	set_instantiation_interface_parameter_value local_reset_status associatedReset {}
	set_instantiation_interface_parameter_value local_reset_status prSafe {false}
	add_instantiation_interface_port local_reset_status local_reset_done local_reset_done 1 STD_LOGIC Output
	add_instantiation_interface pll_ref_clk clock INPUT
	set_instantiation_interface_parameter_value pll_ref_clk clockRate {0}
	set_instantiation_interface_parameter_value pll_ref_clk externallyDriven {false}
	set_instantiation_interface_parameter_value pll_ref_clk ptfSchematicName {}
	add_instantiation_interface_port pll_ref_clk pll_ref_clk clk 1 STD_LOGIC Input
	add_instantiation_interface pll_locked conduit INPUT
	set_instantiation_interface_parameter_value pll_locked associatedClock {}
	set_instantiation_interface_parameter_value pll_locked associatedReset {}
	set_instantiation_interface_parameter_value pll_locked prSafe {false}
	add_instantiation_interface_port pll_locked pll_locked pll_locked 1 STD_LOGIC Output
	add_instantiation_interface oct conduit INPUT
	set_instantiation_interface_parameter_value oct associatedClock {}
	set_instantiation_interface_parameter_value oct associatedReset {}
	set_instantiation_interface_parameter_value oct prSafe {false}
	add_instantiation_interface_port oct oct_rzqin oct_rzqin 1 STD_LOGIC Input
	add_instantiation_interface mem conduit INPUT
	set_instantiation_interface_parameter_value mem associatedClock {}
	set_instantiation_interface_parameter_value mem associatedReset {}
	set_instantiation_interface_parameter_value mem prSafe {false}
	add_instantiation_interface_port mem mem_ck mem_ck 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_ck_n mem_ck_n 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_a mem_a 17 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_act_n mem_act_n 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_ba mem_ba 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_bg mem_bg 2 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_cke mem_cke 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_cs_n mem_cs_n 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_odt mem_odt 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_reset_n mem_reset_n 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_par mem_par 1 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port mem mem_alert_n mem_alert_n 1 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port mem mem_dqs mem_dqs 9 STD_LOGIC_VECTOR Bidir
	add_instantiation_interface_port mem mem_dqs_n mem_dqs_n 9 STD_LOGIC_VECTOR Bidir
	add_instantiation_interface_port mem mem_dq mem_dq 72 STD_LOGIC_VECTOR Bidir
	add_instantiation_interface_port mem mem_dbi_n mem_dbi_n 9 STD_LOGIC_VECTOR Bidir
	add_instantiation_interface status conduit INPUT
	set_instantiation_interface_parameter_value status associatedClock {}
	set_instantiation_interface_parameter_value status associatedReset {}
	set_instantiation_interface_parameter_value status prSafe {false}
	add_instantiation_interface_port status local_cal_success local_cal_success 1 STD_LOGIC Output
	add_instantiation_interface_port status local_cal_fail local_cal_fail 1 STD_LOGIC Output
	add_instantiation_interface emif_calbus conduit INPUT
	set_instantiation_interface_parameter_value emif_calbus associatedClock {emif_calbus_clk}
	set_instantiation_interface_parameter_value emif_calbus associatedReset {}
	set_instantiation_interface_parameter_value emif_calbus prSafe {false}
	add_instantiation_interface_port emif_calbus calbus_read calbus_read 1 STD_LOGIC Input
	add_instantiation_interface_port emif_calbus calbus_write calbus_write 1 STD_LOGIC Input
	add_instantiation_interface_port emif_calbus calbus_address calbus_address 20 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port emif_calbus calbus_wdata calbus_wdata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port emif_calbus calbus_rdata calbus_rdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port emif_calbus calbus_seq_param_tbl calbus_seq_param_tbl 4096 STD_LOGIC_VECTOR Output
	add_instantiation_interface emif_calbus_clk clock INPUT
	set_instantiation_interface_parameter_value emif_calbus_clk clockRate {0}
	set_instantiation_interface_parameter_value emif_calbus_clk externallyDriven {false}
	set_instantiation_interface_parameter_value emif_calbus_clk ptfSchematicName {}
	add_instantiation_interface_port emif_calbus_clk calbus_clk clk 1 STD_LOGIC Input
	add_instantiation_interface emif_usr_reset_n reset OUTPUT
	set_instantiation_interface_parameter_value emif_usr_reset_n associatedClock {}
	set_instantiation_interface_parameter_value emif_usr_reset_n associatedDirectReset {}
	set_instantiation_interface_parameter_value emif_usr_reset_n associatedResetSinks {none}
	set_instantiation_interface_parameter_value emif_usr_reset_n synchronousEdges {NONE}
	add_instantiation_interface_port emif_usr_reset_n emif_usr_reset_n reset_n 1 STD_LOGIC Output
	add_instantiation_interface emif_usr_clk clock OUTPUT
	set_instantiation_interface_parameter_value emif_usr_clk associatedDirectClock {}
	set_instantiation_interface_parameter_value emif_usr_clk clockRate {300000000}
	set_instantiation_interface_parameter_value emif_usr_clk clockRateKnown {true}
	set_instantiation_interface_parameter_value emif_usr_clk externallyDriven {false}
	set_instantiation_interface_parameter_value emif_usr_clk ptfSchematicName {}
	set_instantiation_interface_sysinfo_parameter_value emif_usr_clk clock_rate {300000000}
	add_instantiation_interface_port emif_usr_clk emif_usr_clk clk 1 STD_LOGIC Output
	add_instantiation_interface ctrl_ecc_user_interrupt_0 conduit INPUT
	set_instantiation_interface_parameter_value ctrl_ecc_user_interrupt_0 associatedClock {}
	set_instantiation_interface_parameter_value ctrl_ecc_user_interrupt_0 associatedReset {}
	set_instantiation_interface_parameter_value ctrl_ecc_user_interrupt_0 prSafe {false}
	add_instantiation_interface_port ctrl_ecc_user_interrupt_0 ctrl_ecc_user_interrupt_0 ctrl_ecc_user_interrupt 1 STD_LOGIC Output
	add_instantiation_interface ctrl_amm_0 avalon INPUT
	set_instantiation_interface_parameter_value ctrl_amm_0 addressAlignment {DYNAMIC}
	set_instantiation_interface_parameter_value ctrl_amm_0 addressGroup {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 addressSpan {8589934592}
	set_instantiation_interface_parameter_value ctrl_amm_0 addressUnits {WORDS}
	set_instantiation_interface_parameter_value ctrl_amm_0 alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 associatedClock {emif_usr_clk}
	set_instantiation_interface_parameter_value ctrl_amm_0 associatedReset {emif_usr_reset_n}
	set_instantiation_interface_parameter_value ctrl_amm_0 bitsPerSymbol {8}
	set_instantiation_interface_parameter_value ctrl_amm_0 bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 bridgesToMaster {}
	set_instantiation_interface_parameter_value ctrl_amm_0 burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value ctrl_amm_0 constantBurstBehavior {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhFeatureId {35}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhFeatureType {3}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhGroupId {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhParameterData {}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhParameterDataLength {}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhParameterId {}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhParameterName {}
	set_instantiation_interface_parameter_value ctrl_amm_0 dfhParameterVersion {}
	set_instantiation_interface_parameter_value ctrl_amm_0 explicitAddressSpan {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 holdTime {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 interleaveBursts {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 isBigEndian {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 isFlash {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 isMemoryDevice {true}
	set_instantiation_interface_parameter_value ctrl_amm_0 isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 linewrapBursts {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 maximumPendingReadTransactions {64}
	set_instantiation_interface_parameter_value ctrl_amm_0 maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 minimumReadLatency {1}
	set_instantiation_interface_parameter_value ctrl_amm_0 minimumResponseLatency {1}
	set_instantiation_interface_parameter_value ctrl_amm_0 minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value ctrl_amm_0 prSafe {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 printableDevice {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 readLatency {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 readWaitStates {1}
	set_instantiation_interface_parameter_value ctrl_amm_0 readWaitTime {1}
	set_instantiation_interface_parameter_value ctrl_amm_0 registerIncomingSignals {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 setupTime {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 timingUnits {Cycles}
	set_instantiation_interface_parameter_value ctrl_amm_0 transparentBridge {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 waitrequestAllowance {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value ctrl_amm_0 writeLatency {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 writeWaitStates {0}
	set_instantiation_interface_parameter_value ctrl_amm_0 writeWaitTime {0}
	set_instantiation_interface_assignment_value ctrl_amm_0 embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value ctrl_amm_0 embeddedsw.configuration.isMemoryDevice {1}
	set_instantiation_interface_assignment_value ctrl_amm_0 embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value ctrl_amm_0 embeddedsw.configuration.isPrintableDevice {0}
	set_instantiation_interface_sysinfo_parameter_value ctrl_amm_0 address_map {<address-map><slave name='ctrl_amm_0' start='0x0' end='0x200000000' datawidth='512' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value ctrl_amm_0 address_width {33}
	set_instantiation_interface_sysinfo_parameter_value ctrl_amm_0 max_slave_data_width {512}
	add_instantiation_interface_port ctrl_amm_0 amm_ready_0 waitrequest_n 1 STD_LOGIC Output
	add_instantiation_interface_port ctrl_amm_0 amm_read_0 read 1 STD_LOGIC Input
	add_instantiation_interface_port ctrl_amm_0 amm_write_0 write 1 STD_LOGIC Input
	add_instantiation_interface_port ctrl_amm_0 amm_address_0 address 27 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port ctrl_amm_0 amm_readdata_0 readdata 512 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port ctrl_amm_0 amm_writedata_0 writedata 512 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port ctrl_amm_0 amm_burstcount_0 burstcount 7 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port ctrl_amm_0 amm_byteenable_0 byteenable 64 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port ctrl_amm_0 amm_readdatavalid_0 readdatavalid 1 STD_LOGIC Output
	save_instantiation
	add_component jtag_uart_0 ip/interconnect/interconnect_jtag_uart_0.ip altera_avalon_jtag_uart jtag_uart_0 19.2.4
	load_component jtag_uart_0
	set_component_parameter_value allowMultipleConnections {0}
	set_component_parameter_value hubInstanceID {0}
	set_component_parameter_value readBufferDepth {64}
	set_component_parameter_value readIRQThreshold {8}
	set_component_parameter_value simInputCharacterStream {}
	set_component_parameter_value simInteractiveOptions {NO_INTERACTIVE_WINDOWS}
	set_component_parameter_value useRegistersForReadBuffer {0}
	set_component_parameter_value useRegistersForWriteBuffer {0}
	set_component_parameter_value useRelativePathForSimFile {0}
	set_component_parameter_value writeBufferDepth {64}
	set_component_parameter_value writeIRQThreshold {8}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation jtag_uart_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.CMacro.READ_DEPTH {64}
	set_instantiation_assignment_value embeddedsw.CMacro.READ_THRESHOLD {8}
	set_instantiation_assignment_value embeddedsw.CMacro.WRITE_DEPTH {64}
	set_instantiation_assignment_value embeddedsw.CMacro.WRITE_THRESHOLD {8}
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,juart-1.0}
	set_instantiation_assignment_value embeddedsw.dts.group {serial}
	set_instantiation_assignment_value embeddedsw.dts.name {juart}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {clk}
	set_instantiation_interface_parameter_value reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port reset rst_n reset_n 1 STD_LOGIC Input
	add_instantiation_interface avalon_jtag_slave avalon INPUT
	set_instantiation_interface_parameter_value avalon_jtag_slave addressAlignment {NATIVE}
	set_instantiation_interface_parameter_value avalon_jtag_slave addressGroup {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave addressSpan {2}
	set_instantiation_interface_parameter_value avalon_jtag_slave addressUnits {WORDS}
	set_instantiation_interface_parameter_value avalon_jtag_slave alwaysBurstMaxBurst {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave associatedClock {clk}
	set_instantiation_interface_parameter_value avalon_jtag_slave associatedReset {reset}
	set_instantiation_interface_parameter_value avalon_jtag_slave bitsPerSymbol {8}
	set_instantiation_interface_parameter_value avalon_jtag_slave bridgedAddressOffset {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave bridgesToMaster {}
	set_instantiation_interface_parameter_value avalon_jtag_slave burstOnBurstBoundariesOnly {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave burstcountUnits {WORDS}
	set_instantiation_interface_parameter_value avalon_jtag_slave constantBurstBehavior {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhFeatureGuid {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhFeatureId {35}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhFeatureMajorVersion {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhFeatureMinorVersion {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhFeatureType {3}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhGroupId {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhParameterData {}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhParameterDataLength {}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhParameterId {}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhParameterName {}
	set_instantiation_interface_parameter_value avalon_jtag_slave dfhParameterVersion {}
	set_instantiation_interface_parameter_value avalon_jtag_slave explicitAddressSpan {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave holdTime {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave interleaveBursts {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave isBigEndian {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave isFlash {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave isMemoryDevice {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave isNonVolatileStorage {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave linewrapBursts {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave maximumPendingReadTransactions {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave maximumPendingWriteTransactions {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave minimumReadLatency {1}
	set_instantiation_interface_parameter_value avalon_jtag_slave minimumResponseLatency {1}
	set_instantiation_interface_parameter_value avalon_jtag_slave minimumUninterruptedRunLength {1}
	set_instantiation_interface_parameter_value avalon_jtag_slave prSafe {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave printableDevice {true}
	set_instantiation_interface_parameter_value avalon_jtag_slave readLatency {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave readWaitStates {1}
	set_instantiation_interface_parameter_value avalon_jtag_slave readWaitTime {1}
	set_instantiation_interface_parameter_value avalon_jtag_slave registerIncomingSignals {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave registerOutgoingSignals {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave setupTime {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave timingUnits {Cycles}
	set_instantiation_interface_parameter_value avalon_jtag_slave transparentBridge {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave waitrequestAllowance {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave wellBehavedWaitrequest {false}
	set_instantiation_interface_parameter_value avalon_jtag_slave writeLatency {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave writeWaitStates {0}
	set_instantiation_interface_parameter_value avalon_jtag_slave writeWaitTime {0}
	set_instantiation_interface_assignment_value avalon_jtag_slave embeddedsw.configuration.isFlash {0}
	set_instantiation_interface_assignment_value avalon_jtag_slave embeddedsw.configuration.isMemoryDevice {0}
	set_instantiation_interface_assignment_value avalon_jtag_slave embeddedsw.configuration.isNonVolatileStorage {0}
	set_instantiation_interface_assignment_value avalon_jtag_slave embeddedsw.configuration.isPrintableDevice {1}
	set_instantiation_interface_sysinfo_parameter_value avalon_jtag_slave address_map {<address-map><slave name='avalon_jtag_slave' start='0x0' end='0x8' datawidth='32' /></address-map>}
	set_instantiation_interface_sysinfo_parameter_value avalon_jtag_slave address_width {3}
	set_instantiation_interface_sysinfo_parameter_value avalon_jtag_slave max_slave_data_width {32}
	add_instantiation_interface_port avalon_jtag_slave av_chipselect chipselect 1 STD_LOGIC Input
	add_instantiation_interface_port avalon_jtag_slave av_address address 1 STD_LOGIC Input
	add_instantiation_interface_port avalon_jtag_slave av_read_n read_n 1 STD_LOGIC Input
	add_instantiation_interface_port avalon_jtag_slave av_readdata readdata 32 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port avalon_jtag_slave av_write_n write_n 1 STD_LOGIC Input
	add_instantiation_interface_port avalon_jtag_slave av_writedata writedata 32 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port avalon_jtag_slave av_waitrequest waitrequest 1 STD_LOGIC Output
	add_instantiation_interface irq interrupt INPUT
	set_instantiation_interface_parameter_value irq associatedAddressablePoint {avalon_jtag_slave}
	set_instantiation_interface_parameter_value irq associatedClock {clk}
	set_instantiation_interface_parameter_value irq associatedReset {reset}
	set_instantiation_interface_parameter_value irq bridgedReceiverOffset {0}
	set_instantiation_interface_parameter_value irq bridgesToReceiver {}
	set_instantiation_interface_parameter_value irq irqScheme {NONE}
	add_instantiation_interface_port irq av_irq irq 1 STD_LOGIC Output
	save_instantiation
	add_component reset_bridge_0 ip/interconnect/interconnect_reset_bridge_0.ip altera_reset_bridge reset_bridge_0 19.2.0
	load_component reset_bridge_0
	set_component_parameter_value ACTIVE_LOW_RESET {0}
	set_component_parameter_value NUM_RESET_OUTPUTS {1}
	set_component_parameter_value SYNCHRONOUS_EDGES {deassert}
	set_component_parameter_value SYNC_RESET {0}
	set_component_parameter_value USE_RESET_REQUEST {0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation reset_bridge_0
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface in_reset reset INPUT
	set_instantiation_interface_parameter_value in_reset associatedClock {clk}
	set_instantiation_interface_parameter_value in_reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port in_reset in_reset reset 1 STD_LOGIC Input
	add_instantiation_interface out_reset reset OUTPUT
	set_instantiation_interface_parameter_value out_reset associatedClock {clk}
	set_instantiation_interface_parameter_value out_reset associatedDirectReset {in_reset}
	set_instantiation_interface_parameter_value out_reset associatedResetSinks {in_reset}
	set_instantiation_interface_parameter_value out_reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port out_reset out_reset reset 1 STD_LOGIC Output
	save_instantiation

	# add wirelevel expressions

	# preserve ports for debug

	# add the connections
	add_connection axi_bridge_0.m0/emif_fm_0.ctrl_amm_0
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 addressMapSysInfo {}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 addressWidthSysInfo {}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 arbitrationPriority {1}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 baseAddress {0x0000}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 defaultConnection {0}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 domainAlias {}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.syncResets {TRUE}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value axi_bridge_0.m0/emif_fm_0.ctrl_amm_0 slaveDataWidthSysInfo {-1}
	add_connection axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave addressMapSysInfo {}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave addressWidthSysInfo {}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave baseAddress {0x0000}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave defaultConnection {0}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave domainAlias {}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.burstAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.clockCrossingAdapter {HANDSHAKE}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.enableAllPipelines {FALSE}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.enableEccProtection {FALSE}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.enableInstrumentation {FALSE}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.enableOutOfOrderSupport {FALSE}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.insertDefaultSlave {FALSE}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.interconnectResetSource {DEFAULT}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.interconnectType {STANDARD}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.maxAdditionalLatency {1}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.optimizeRdFifoSize {FALSE}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.piplineType {PIPELINE_STAGE}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.responseFifoType {REGISTER_BASED}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.syncResets {TRUE}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave qsys_mm.widthAdapterImplementation {GENERIC_CONVERTER}
	set_connection_parameter_value axi_bridge_1.m0/jtag_uart_0.avalon_jtag_slave slaveDataWidthSysInfo {-1}
	add_connection emif_cal_0.emif_calbus_0/emif_fm_0.emif_calbus
	set_connection_parameter_value emif_cal_0.emif_calbus_0/emif_fm_0.emif_calbus endPort {}
	set_connection_parameter_value emif_cal_0.emif_calbus_0/emif_fm_0.emif_calbus endPortLSB {0}
	set_connection_parameter_value emif_cal_0.emif_calbus_0/emif_fm_0.emif_calbus startPort {}
	set_connection_parameter_value emif_cal_0.emif_calbus_0/emif_fm_0.emif_calbus startPortLSB {0}
	set_connection_parameter_value emif_cal_0.emif_calbus_0/emif_fm_0.emif_calbus width {0}
	add_connection emif_cal_0.emif_calbus_clk/emif_fm_0.emif_calbus_clk
	set_connection_parameter_value emif_cal_0.emif_calbus_clk/emif_fm_0.emif_calbus_clk clockDomainSysInfo {-1}
	set_connection_parameter_value emif_cal_0.emif_calbus_clk/emif_fm_0.emif_calbus_clk clockRateSysInfo {}
	set_connection_parameter_value emif_cal_0.emif_calbus_clk/emif_fm_0.emif_calbus_clk clockResetSysInfo {}
	set_connection_parameter_value emif_cal_0.emif_calbus_clk/emif_fm_0.emif_calbus_clk resetDomainSysInfo {-1}
	add_connection emif_fm_0.emif_usr_clk/axi_bridge_0.clk
	set_connection_parameter_value emif_fm_0.emif_usr_clk/axi_bridge_0.clk clockDomainSysInfo {-1}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/axi_bridge_0.clk clockRateSysInfo {300000000.0}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/axi_bridge_0.clk clockResetSysInfo {}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/axi_bridge_0.clk resetDomainSysInfo {-1}
	add_connection emif_fm_0.emif_usr_clk/axi_bridge_1.clk
	set_connection_parameter_value emif_fm_0.emif_usr_clk/axi_bridge_1.clk clockDomainSysInfo {-1}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/axi_bridge_1.clk clockRateSysInfo {300000000.0}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/axi_bridge_1.clk clockResetSysInfo {}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/axi_bridge_1.clk resetDomainSysInfo {-1}
	add_connection emif_fm_0.emif_usr_clk/jtag_uart_0.clk
	set_connection_parameter_value emif_fm_0.emif_usr_clk/jtag_uart_0.clk clockDomainSysInfo {-1}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/jtag_uart_0.clk clockRateSysInfo {300000000.0}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/jtag_uart_0.clk clockResetSysInfo {}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/jtag_uart_0.clk resetDomainSysInfo {-1}
	add_connection emif_fm_0.emif_usr_clk/reset_bridge_0.clk
	set_connection_parameter_value emif_fm_0.emif_usr_clk/reset_bridge_0.clk clockDomainSysInfo {-1}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/reset_bridge_0.clk clockRateSysInfo {300000000.0}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/reset_bridge_0.clk clockResetSysInfo {}
	set_connection_parameter_value emif_fm_0.emif_usr_clk/reset_bridge_0.clk resetDomainSysInfo {-1}
	add_connection reset_bridge_0.out_reset/axi_bridge_0.clk_reset
	set_connection_parameter_value reset_bridge_0.out_reset/axi_bridge_0.clk_reset clockDomainSysInfo {-1}
	set_connection_parameter_value reset_bridge_0.out_reset/axi_bridge_0.clk_reset clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/axi_bridge_0.clk_reset resetDomainSysInfo {-1}
	add_connection reset_bridge_0.out_reset/axi_bridge_1.clk_reset
	set_connection_parameter_value reset_bridge_0.out_reset/axi_bridge_1.clk_reset clockDomainSysInfo {-1}
	set_connection_parameter_value reset_bridge_0.out_reset/axi_bridge_1.clk_reset clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/axi_bridge_1.clk_reset resetDomainSysInfo {-1}
	add_connection reset_bridge_0.out_reset/jtag_uart_0.reset
	set_connection_parameter_value reset_bridge_0.out_reset/jtag_uart_0.reset clockDomainSysInfo {-1}
	set_connection_parameter_value reset_bridge_0.out_reset/jtag_uart_0.reset clockResetSysInfo {}
	set_connection_parameter_value reset_bridge_0.out_reset/jtag_uart_0.reset resetDomainSysInfo {-1}

	# add the exports
	set_interface_property axi_bridge_1_s0 EXPORT_OF axi_bridge_1.s0
	set_interface_property emif_fm_0_local_reset_req EXPORT_OF emif_fm_0.local_reset_req
	set_interface_property emif_fm_0_local_reset_status EXPORT_OF emif_fm_0.local_reset_status
	set_interface_property emif_fm_0_pll_ref_clk EXPORT_OF emif_fm_0.pll_ref_clk
	set_interface_property emif_fm_0_pll_locked EXPORT_OF emif_fm_0.pll_locked
	set_interface_property emif_fm_0_oct EXPORT_OF emif_fm_0.oct
	set_interface_property emif_fm_0_mem EXPORT_OF emif_fm_0.mem
	set_interface_property emif_fm_0_status EXPORT_OF emif_fm_0.status
	set_interface_property emif_fm_0_emif_usr_reset_n EXPORT_OF emif_fm_0.emif_usr_reset_n
	set_interface_property emif_fm_0_ctrl_ecc_user_interrupt_0 EXPORT_OF emif_fm_0.ctrl_ecc_user_interrupt_0
	set_interface_property jtag_uart_0_irq EXPORT_OF jtag_uart_0.irq
	set_interface_property reset_bridge_0_in_reset EXPORT_OF reset_bridge_0.in_reset

	# set values for exposed HDL parameters
	set_domain_assignment axi_bridge_0.m0 qsys_mm.burstAdapterImplementation GENERIC_CONVERTER
	set_domain_assignment axi_bridge_0.m0 qsys_mm.clockCrossingAdapter HANDSHAKE
	set_domain_assignment axi_bridge_0.m0 qsys_mm.enableAllPipelines FALSE
	set_domain_assignment axi_bridge_0.m0 qsys_mm.enableEccProtection FALSE
	set_domain_assignment axi_bridge_0.m0 qsys_mm.enableInstrumentation FALSE
	set_domain_assignment axi_bridge_0.m0 qsys_mm.enableOutOfOrderSupport FALSE
	set_domain_assignment axi_bridge_0.m0 qsys_mm.insertDefaultSlave FALSE
	set_domain_assignment axi_bridge_0.m0 qsys_mm.interconnectResetSource DEFAULT
	set_domain_assignment axi_bridge_0.m0 qsys_mm.interconnectType STANDARD
	set_domain_assignment axi_bridge_0.m0 qsys_mm.maxAdditionalLatency 1
	set_domain_assignment axi_bridge_0.m0 qsys_mm.optimizeRdFifoSize FALSE
	set_domain_assignment axi_bridge_0.m0 qsys_mm.piplineType PIPELINE_STAGE
	set_domain_assignment axi_bridge_0.m0 qsys_mm.responseFifoType REGISTER_BASED
	set_domain_assignment axi_bridge_0.m0 qsys_mm.syncResets TRUE
	set_domain_assignment axi_bridge_0.m0 qsys_mm.widthAdapterImplementation GENERIC_CONVERTER
	set_domain_assignment axi_bridge_1.m0 qsys_mm.burstAdapterImplementation GENERIC_CONVERTER
	set_domain_assignment axi_bridge_1.m0 qsys_mm.clockCrossingAdapter HANDSHAKE
	set_domain_assignment axi_bridge_1.m0 qsys_mm.enableAllPipelines FALSE
	set_domain_assignment axi_bridge_1.m0 qsys_mm.enableEccProtection FALSE
	set_domain_assignment axi_bridge_1.m0 qsys_mm.enableInstrumentation FALSE
	set_domain_assignment axi_bridge_1.m0 qsys_mm.enableOutOfOrderSupport FALSE
	set_domain_assignment axi_bridge_1.m0 qsys_mm.insertDefaultSlave FALSE
	set_domain_assignment axi_bridge_1.m0 qsys_mm.interconnectResetSource DEFAULT
	set_domain_assignment axi_bridge_1.m0 qsys_mm.interconnectType STANDARD
	set_domain_assignment axi_bridge_1.m0 qsys_mm.maxAdditionalLatency 1
	set_domain_assignment axi_bridge_1.m0 qsys_mm.optimizeRdFifoSize FALSE
	set_domain_assignment axi_bridge_1.m0 qsys_mm.piplineType PIPELINE_STAGE
	set_domain_assignment axi_bridge_1.m0 qsys_mm.responseFifoType REGISTER_BASED
	set_domain_assignment axi_bridge_1.m0 qsys_mm.syncResets TRUE
	set_domain_assignment axi_bridge_1.m0 qsys_mm.widthAdapterImplementation GENERIC_CONVERTER

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="axi_bridge_0">
  <datum __value="_sortIndex" value="2" type="int" />
 </element>
 <element __value="axi_bridge_1">
  <datum __value="_sortIndex" value="5" type="int" />
 </element>
 <element __value="emif_cal_0">
  <datum __value="_sortIndex" value="1" type="int" />
 </element>
 <element __value="emif_fm_0">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
 <element __value="jtag_uart_0">
  <datum __value="_sortIndex" value="4" type="int" />
 </element>
 <element __value="reset_bridge_0">
  <datum __value="_sortIndex" value="3" type="int" />
 </element>
 <element __value="sysA_0">
  <datum __value="_sortIndex" value="2" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {interconnect.qsys}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {interconnect}

	# save the system
	sync_sysinfo_parameters
	save_system interconnect
}

proc do_set_exported_interface_sysinfo_parameters {} {
}

# create all the systems, from bottom up
do_create_interconnect

# set system info parameters on exported interface, from bottom up
do_set_exported_interface_sysinfo_parameters
