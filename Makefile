# Author: Florian Zaruba, ETH Zurich
# Date: 03/19/2017
# Description: Makefile for linting and testing Ariane.

# questa library
library        ?= work
# verilator lib
ver-library    ?= work-ver
# library for DPI
dpi-library    ?= work-dpi
# Top level module to compile
top_level      ?= ariane_tb
# Maximum amount of cycles for a successful simulation run
max_cycles     ?= 10000000
# Test case to run
test_case      ?= core_test
# QuestaSim Version
questa_version ?= ${QUESTASIM_VERSION}
# verilator version
verilator      ?= verilator
# traget option
target-options ?=
# additional definess
defines        ?= WT_DCACHE
# test name for torture runs (binary name)
test-location  ?= output/test
# set to either nothing or -log
torture-logs   :=
# custom elf bin to run with sim or sim-verilator
elf-bin        ?= tmp/riscv-tests/build/benchmarks/dhrystone.riscv
# board name for bitstream generation. Currently supported: kc705, genesys2
BOARD          ?= genesys2
# root path
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
root-dir := $(dir $(mkfile_path))

support_verilator_4 := $(shell ($(verilator) --version | grep '4\.') > /dev/null 2>&1 ; echo $$?)
ifeq ($(support_verilator_4), 0)
endif

ifndef RISCV
$(error RISCV not set - please point your RISCV variable to your RISCV installation)
endif

# By default assume spike resides at the RISCV prefix.
SPIKE_ROOT     ?= $(RISCV)

# setting additional xilinx board parameters for the selected board
ifeq ($(BOARD), genesys2)
	XILINX_PART              := xc7k325tffg900-2
	XILINX_BOARD             := digilentinc.com:genesys2:part0:1.1
	CLK_PERIOD_NS            := 20
else ifeq ($(BOARD), kc705)
	XILINX_PART              := xc7k325tffg900-2
	XILINX_BOARD             := xilinx.com:kc705:part0:1.5
	CLK_PERIOD_NS            := 20
else ifeq ($(BOARD), vc707)
	XILINX_PART              := xc7vx485tffg1761-2
	XILINX_BOARD             := xilinx.com:vc707:part0:1.3
	CLK_PERIOD_NS            := 20
else
$(error Unknown board - please specify a supported FPGA board)
endif

# spike tandem verification
ifdef spike-tandem
    compile_flag += -define SPIKE_TANDEM
    ifndef preload
        $(error Tandem verification requires preloading)
    endif
endif

# Sources
# Package files -> compile first
ariane_pkg := include/riscv_pkg.sv                          \
              src/riscv-dbg/src/dm_pkg.sv                   \
              include/ariane_pkg.sv                         \
              include/std_cache_pkg.sv                      \
              include/wt_cache_pkg.sv                       \
              src/axi/src/axi_pkg.sv                        \
              src/register_interface/src/reg_intf.sv        \
              src/register_interface/src/reg_intf_pkg.sv    \
              include/axi_intf.sv                           \
              tb/ariane_soc_pkg.sv                          \
              tb/ariane_axi_soc_pkg.sv                      \
              include/ariane_axi_pkg.sv                     \
              src/fpu/src/fpnew_pkg.sv                      \
              src/fpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv
ariane_pkg := $(addprefix $(root-dir), $(ariane_pkg))

# utility modules
util := include/instr_tracer_pkg.sv                         \
        src/util/instr_tracer_if.sv                         \
        src/util/instr_tracer.sv                            \
        src/tech_cells_generic/src/cluster_clock_gating.sv  \
        tb/common/mock_uart.sv                              \
        src/util/sram.sv

ifdef spike-tandem
    util += tb/common/spike.sv
endif

util := $(addprefix $(root-dir), $(util))
# Test packages
test_pkg := $(wildcard tb/test/*/*sequence_pkg.sv*) \
			$(wildcard tb/test/*/*_pkg.sv*)

# DPI
dpi := $(patsubst tb/dpi/%.cc, ${dpi-library}/%.o, $(wildcard tb/dpi/*.cc))

# filter spike stuff if tandem is not activated
ifndef spike-tandem
    dpi := $(filter-out ${dpi-library}/spike.o ${dpi-library}/sim_spike.o, $(dpi))
endif

# filter dromajo stuff if dromajo is not activated
ifndef DROMAJO
    dpi := $(filter-out ${dpi-library}/dromajo_cosim_dpi.o, $(dpi))
endif

dpi_hdr := $(wildcard tb/dpi/*.h)
dpi_hdr := $(addprefix $(root-dir), $(dpi_hdr))
CFLAGS := -I$(QUESTASIM_HOME)/include         \
          -I$(RISCV)/include                  \
          -I$(SPIKE_ROOT)/include             \
          $(if $(DROMAJO), -I../tb/dromajo/src,) \
          -std=c++11 -I../tb/dpi -O3

ifdef XCELIUM_HOME
CFLAGS += -I$(XCELIUM_HOME)/tools/include
else
$(warning XCELIUM_HOME not set which is necessary for compiling DPIs when using XCELIUM)
endif

ifdef spike-tandem
    CFLAGS += -Itb/riscv-isa-sim/install/include/spike
endif

# this list contains the standalone components
src :=  $(filter-out src/ariane_regfile.sv, $(wildcard src/*.sv))              \
        $(filter-out src/fpu/src/fpnew_pkg.sv, $(wildcard src/fpu/src/*.sv))   \
        $(filter-out src/fpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv,    \
        $(wildcard src/fpu/src/fpu_div_sqrt_mvp/hdl/*.sv))                     \
        $(wildcard src/frontend/*.sv)                                          \
        $(filter-out src/cache_subsystem/std_no_dcache.sv,                     \
        $(wildcard src/cache_subsystem/*.sv))                                  \
        $(wildcard bootrom/*.sv)                                               \
        $(wildcard src/clint/*.sv)                                             \
        $(wildcard fpga/src/axi2apb/src/*.sv)                                  \
        $(wildcard fpga/src/apb_timer/*.sv)                                    \
        $(wildcard fpga/src/axi_slice/src/*.sv)                                \
        $(wildcard src/axi_node/src/*.sv)                                      \
        $(wildcard src/axi_riscv_atomics/src/*.sv)                             \
        $(wildcard src/axi_mem_if/src/*.sv)                                    \
        $(wildcard src/pmp/src/*.sv)                                           \
        $(wildcard src/mmu_sv32/*.sv)                                          \
        $(wildcard src/mmu_sv39/*.sv)                                          \
        src/rv_plic/rtl/rv_plic_target.sv                                      \
        src/rv_plic/rtl/rv_plic_gateway.sv                                     \
        src/rv_plic/rtl/plic_regmap.sv                                         \
        src/rv_plic/rtl/plic_top.sv                                            \
        src/riscv-dbg/src/dmi_cdc.sv                                           \
        src/riscv-dbg/src/dmi_jtag.sv                                          \
        src/riscv-dbg/src/dmi_jtag_tap.sv                                      \
        src/riscv-dbg/src/dm_csrs.sv                                           \
        src/riscv-dbg/src/dm_mem.sv                                            \
        src/riscv-dbg/src/dm_sba.sv                                            \
        src/riscv-dbg/src/dm_top.sv                                            \
        src/riscv-dbg/debug_rom/debug_rom.sv                                   \
        src/register_interface/src/apb_to_reg.sv                               \
        src/axi/src/axi_multicut.sv                                            \
        src/common_cells/src/deprecated/generic_fifo.sv                        \
        src/common_cells/src/deprecated/pulp_sync.sv                           \
        src/common_cells/src/deprecated/find_first_one.sv                      \
        src/common_cells/src/rstgen_bypass.sv                                  \
        src/common_cells/src/rstgen.sv                                         \
        src/common_cells/src/stream_mux.sv                                     \
        src/common_cells/src/stream_demux.sv                                   \
        src/common_cells/src/exp_backoff.sv                                    \
        src/util/axi_master_connect.sv                                         \
        src/util/axi_slave_connect.sv                                          \
        src/util/axi_master_connect_rev.sv                                     \
        src/util/axi_slave_connect_rev.sv                                      \
        src/axi/src/axi_cut.sv                                                 \
        src/axi/src/axi_join.sv                                                \
        src/axi/src/axi_delayer.sv                                             \
        src/axi/src/axi_to_axi_lite.sv                                         \
        src/fpga-support/rtl/SyncSpRamBeNx64.sv                                \
        src/common_cells/src/unread.sv                                         \
        src/common_cells/src/sync.sv                                           \
        src/common_cells/src/cdc_2phase.sv                                     \
        src/common_cells/src/spill_register.sv                                 \
        src/common_cells/src/sync_wedge.sv                                     \
        src/common_cells/src/edge_detect.sv                                    \
        src/common_cells/src/stream_arbiter.sv                                 \
        src/common_cells/src/stream_arbiter_flushable.sv                       \
        src/common_cells/src/deprecated/fifo_v1.sv                             \
        src/common_cells/src/deprecated/fifo_v2.sv                             \
        src/common_cells/src/fifo_v3.sv                                        \
        src/common_cells/src/lzc.sv                                            \
        src/common_cells/src/popcount.sv                                       \
        src/common_cells/src/rr_arb_tree.sv                                    \
        src/common_cells/src/deprecated/rrarbiter.sv                           \
        src/common_cells/src/stream_delay.sv                                   \
        src/common_cells/src/lfsr.sv                                           \
        src/common_cells/src/lfsr_8bit.sv                                      \
        src/common_cells/src/lfsr_16bit.sv                                     \
        src/common_cells/src/delta_counter.sv                                  \
        src/common_cells/src/counter.sv                                        \
        src/common_cells/src/shift_reg.sv                                      \
        src/tech_cells_generic/src/pulp_clock_gating.sv                        \
        src/tech_cells_generic/src/cluster_clock_inverter.sv                   \
        src/tech_cells_generic/src/pulp_clock_mux2.sv                          \
        tb/ariane_testharness.sv                                               \
        tb/ariane_peripherals.sv                                               \
        tb/common/uart.sv                                                      \
        tb/common/SimDTM.sv                                                    \
        tb/common/SimJTAG.sv

# filter dromajo stuff if dromajo is not activated
ifndef DROMAJO
	src :=  $(filter-out src/dromajo_ram.sv, $(src))
	src :=  $(filter-out bootrom/dromajo_bootrom.sv, $(src))
endif

src := $(addprefix $(root-dir), $(src))

uart_src := $(wildcard fpga/src/apb_uart/src/*.vhd)
uart_src := $(addprefix $(root-dir), $(uart_src))

fpga_src :=  $(wildcard fpga/src/*.sv) $(wildcard fpga/src/bootrom/*.sv) $(wildcard fpga/src/ariane-ethernet/*.sv)
fpga_src := $(addprefix $(root-dir), $(fpga_src))

# look for testbenches
tbs := tb/ariane_tb.sv tb/ariane_testharness.sv
# RISCV asm tests and benchmark setup (used for CI)
# there is a definesd test-list with selected CI tests
riscv-test-dir            := tmp/riscv-tests/build/isa/
riscv-benchmarks-dir      := tmp/riscv-tests/build/benchmarks/
riscv-asm-tests-list      := ci/riscv-asm-tests.list
riscv-amo-tests-list      := ci/riscv-amo-tests.list
riscv-mul-tests-list      := ci/riscv-mul-tests.list
riscv-fp-tests-list       := ci/riscv-fp-tests.list
riscv-benchmarks-list     := ci/riscv-benchmarks.list
riscv-asm-tests           := $(shell xargs printf '\n%s' < $(riscv-asm-tests-list)  | cut -b 1-)
riscv-amo-tests           := $(shell xargs printf '\n%s' < $(riscv-amo-tests-list)  | cut -b 1-)
riscv-mul-tests           := $(shell xargs printf '\n%s' < $(riscv-mul-tests-list)  | cut -b 1-)
riscv-fp-tests            := $(shell xargs printf '\n%s' < $(riscv-fp-tests-list)   | cut -b 1-)
riscv-benchmarks          := $(shell xargs printf '\n%s' < $(riscv-benchmarks-list) | cut -b 1-)

# Search here for include files (e.g.: non-standalone components)
incdir := src/common_cells/include/
# Compile and sim flags
compile_flag     += +cover=bcfst+/dut -incr -64 -nologo -quiet -suppress 13262 -permissive +define+$(defines)
uvm-flags        += +UVM_NO_RELNOTES +UVM_VERBOSITY=LOW
questa-flags     += -t 1ns -64 -coverage -classdebug $(gui-sim) $(QUESTASIM_FLAGS)
compile_flag_vhd += -64 -nologo -quiet -2008

# Iterate over all include directories and write them with +incdir+ prefixed
# +incdir+ works for Verilator and QuestaSim
list_incdir := $(foreach dir, ${incdir}, +incdir+$(dir))

# RISCV torture setup
riscv-torture-dir    := tmp/riscv-torture
# old java flags  -Xmx1G -Xss8M -XX:MaxPermSize=128M
# -XshowSettings -Xdiag
riscv-torture-bin    := java -jar sbt-launch.jar

# if defined, calls the questa targets in batch mode
ifdef batch-mode
	questa-flags += -c
	questa-cmd   := -do "coverage save -onexit tmp/$@.ucdb; run -a; quit -code [coverage attribute -name TESTSTATUS -concise]"
	questa-cmd   += -do " log -r /*; run -all;"
else
	questa-cmd   := -do " log -r /*; run -all;"
endif
# we want to preload the memories
ifdef preload
	questa-cmd += +PRELOAD=$(preload)
	elf-bin = none
endif

ifdef spike-tandem
    questa-cmd += -gblso tb/riscv-isa-sim/install/lib/libriscv.so
endif

# remote bitbang is enabled
ifdef rbb
	questa-cmd += +jtag_rbb_enable=1
else
	questa-cmd += +jtag_rbb_enable=0
endif

# Build the TB and module using QuestaSim
build: $(library) $(library)/.build-srcs $(library)/.build-tb $(dpi-library)/ariane_dpi.so
	# Optimize top level
	vopt$(questa_version) $(compile_flag) -work $(library)  $(top_level) -o $(top_level)_optimized +acc -check_synthesis

# src files
$(library)/.build-srcs: $(util) $(library)
	vlog$(questa_version) $(compile_flag) -work $(library) $(filter %.sv,$(ariane_pkg)) $(list_incdir) -suppress 2583
	# vcom$(questa_version) $(compile_flag_vhd) -work $(library) -pedanticerrors $(filter %.vhd,$(ariane_pkg))
	vlog$(questa_version) $(compile_flag) -work $(library) $(filter %.sv,$(util)) $(list_incdir) -suppress 2583
	# Suppress message that always_latch may not be checked thoroughly by QuestaSim.
	vcom$(questa_version) $(compile_flag_vhd) -work $(library) -pedanticerrors $(filter %.vhd,$(uart_src))
	# vcom$(questa_version) $(compile_flag_vhd) -work $(library) -pedanticerrors $(filter %.vhd,$(src))
	vlog$(questa_version) $(compile_flag) -work $(library) -pedanticerrors $(filter %.sv,$(src)) $(list_incdir) -suppress 2583
	touch $(library)/.build-srcs

# build TBs
$(library)/.build-tb: $(dpi)
	# Compile top level
	vlog$(questa_version) $(compile_flag) -sv $(tbs) -work $(library)
	touch $(library)/.build-tb

$(library):
	vlib${questa_version} $(library)

# compile DPIs
$(dpi-library)/%.o: tb/dpi/%.cc $(dpi_hdr)
	mkdir -p $(dpi-library)
	$(CXX) -shared -fPIC -std=c++0x -Bsymbolic $(CFLAGS) -c $< -o $@

$(dpi-library)/ariane_dpi.so: $(dpi)
	mkdir -p $(dpi-library)
	# Compile C-code and generate .so file
	$(CXX) -shared -m64 -o $(dpi-library)/ariane_dpi.so $? -L$(RISCV)/lib -L$(SPIKE_ROOT)/lib -Wl,-rpath,$(RISCV)/lib -Wl,-rpath,$(SPIKE_ROOT)/lib -lfesvr

# single test runs on Questa can be started by calling make <testname>, e.g. make towers.riscv
# the test names are defined in ci/riscv-asm-tests.list, and in ci/riscv-benchmarks.list
# if you want to run in batch mode, use make <testname> batch-mode=1
# alternatively you can call make sim elf-bin=<path/to/elf-bin> in order to load an arbitrary binary

generate-trace-vsim:
	make sim preload=$(preload) elf-bin= batch-mode=1
	make generate-trace

sim: build
	vsim${questa_version} +permissive $(questa-flags) $(questa-cmd) -lib $(library) +MAX_CYCLES=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-test-dir) $(uvm-flags) $(QUESTASIM_FLAGS) -gblso $(SPIKE_ROOT)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi  \
	${top_level}_optimized +permissive-off ++$(elf-bin) ++$(target-options) | tee sim.log

$(riscv-asm-tests): build
	vsim${questa_version} +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-test-dir) $(uvm-flags) +jtag_rbb_enable=0  -gblso $(SPIKE_ROOT)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi        \
	${top_level}_optimized $(QUESTASIM_FLAGS) +permissive-off ++$(riscv-test-dir)/$@ ++$(target-options) | tee tmp/riscv-asm-tests-$@.log

$(riscv-amo-tests): build
	vsim${questa_version} +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-test-dir) $(uvm-flags) +jtag_rbb_enable=0  -gblso $(SPIKE_ROOT)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi        \
	${top_level}_optimized $(QUESTASIM_FLAGS) +permissive-off ++$(riscv-test-dir)/$@ ++$(target-options) | tee tmp/riscv-amo-tests-$@.log

$(riscv-mul-tests): build
	vsim${questa_version} +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-test-dir) $(uvm-flags) +jtag_rbb_enable=0  -gblso $(SPIKE_ROOT)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi        \
	${top_level}_optimized $(QUESTASIM_FLAGS) +permissive-off ++$(riscv-test-dir)/$@ ++$(target-options) | tee tmp/riscv-mul-tests-$@.log

$(riscv-fp-tests): build
	vsim${questa_version} +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-test-dir) $(uvm-flags) +jtag_rbb_enable=0  -gblso $(SPIKE_ROOT)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi        \
	${top_level}_optimized $(QUESTASIM_FLAGS) +permissive-off ++$(riscv-test-dir)/$@ ++$(target-options) | tee tmp/riscv-fp-tests-$@.log

$(riscv-benchmarks): build
	vsim${questa_version} +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-benchmarks-dir) $(uvm-flags) +jtag_rbb_enable=0 -gblso $(SPIKE_ROOT)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi   \
	${top_level}_optimized $(QUESTASIM_FLAGS) +permissive-off ++$(riscv-benchmarks-dir)/$@ ++$(target-options) | tee tmp/riscv-benchmarks-$@.log

# can use -jX to run ci tests in parallel using X processes
run-asm-tests: $(riscv-asm-tests)
	$(MAKE) check-asm-tests

run-amo-tests: $(riscv-amo-tests)
	$(MAKE) check-amo-tests

run-mul-tests: $(riscv-mul-tests)
	$(MAKE) check-mul-tests

run-fp-tests: $(riscv-fp-tests)
	$(MAKE) check-fp-tests

check-asm-tests:
	ci/check-tests.sh tmp/riscv-asm-tests- $(shell wc -l $(riscv-asm-tests-list) | awk -F " " '{ print $1 }')

check-amo-tests:
	ci/check-tests.sh tmp/riscv-amo-tests- $(shell wc -l $(riscv-amo-tests-list) | awk -F " " '{ print $1 }')

check-mul-tests:
	ci/check-tests.sh tmp/riscv-mul-tests- $(shell wc -l $(riscv-mul-tests-list) | awk -F " " '{ print $1 }')

check-fp-tests:
	ci/check-tests.sh tmp/riscv-fp-tests- $(shell wc -l $(riscv-fp-tests-list) | awk -F " " '{ print $1 }')

# can use -jX to run ci tests in parallel using X processes
run-benchmarks: $(riscv-benchmarks)
	$(MAKE) check-benchmarks

check-benchmarks:
	ci/check-tests.sh tmp/riscv-benchmarks- $(shell wc -l $(riscv-benchmarks-list) | awk -F " " '{ print $1 }')
#####################################
# xrun-specific commands, variables
#####################################
XRUN               ?= xrun
XRUN_WORK_DIR      ?= xrun_work
XRUN_RESULTS_DIR   ?= xrun_results
XRUN_UVMHOME_ARG   ?= CDNS-1.2-ML
XRUN_COMPL_LOG     ?= xrun_compl.log
XRUN_RUN_LOG       ?= xrun_run.log
CVA6_HOME	   ?= $(realpath -s $(root-dir))

XRUN_INCDIR :=+incdir+$(CVA6_HOME)/src/axi_node 	\
	+incdir+$(CVA6_HOME)/src/common_cells/include 	\
	+incdir+$(CVA6_HOME)/src/util
XRUN_TB := $(addprefix $(CVA6_HOME)/, tb/ariane_tb.sv)

XRUN_COMP_FLAGS  ?= -64bit -disable_sem2009 -access +rwc 			\
		    -sv -v93 -uvm -uvmhome $(XRUN_UVMHOME_ARG) 			\
		    -sv_lib $(CVA6_HOME)/$(dpi-library)/ariane_dpi.so		\
		    -smartorder -sv -top worklib.$(top_level)			\
		    -xceligen on=1903 +define+$(defines) -timescale 1ns/1ps	\

XRUN_RUN_FLAGS := -R -64bit -disable_sem2009 -access +rwc -timescale 1ns/1ps		\
		-sv_lib	$(CVA6_HOME)/$(dpi-library)/ariane_dpi.so -xceligen on=1903	\

XRUN_DISABLED_WARNINGS := BIGWIX 	\
			ZROMCW 		\
			STRINT 		\
			ENUMERR 	\
			SPDUSD		\
			RNDXCELON

XRUN_DISABLED_WARNINGS 	:= $(patsubst %, -nowarn %, $(XRUN_DISABLED_WARNINGS))

XRUN_COMP = $(XRUN_COMP_FLAGS)		\
	$(XRUN_DISABLED_WARNINGS) 	\
	$(XRUN_INCDIR)		      	\
	$(filter %.sv, $(ariane_pkg)) 	\
	$(filter %.sv, $(util))		\
	$(filter %.vhd, $(uart_src))  	\
	$(filter %.sv, $(src))	      	\
	$(filter %.sv, $(XRUN_TB))	\

XRUN_RUN = $(XRUN_RUN_FLAGS) 		\
	$(XRUN_DISABLED_WARNINGS)	\

xrun_clean:
	@echo "[XRUN] clean up"
	rm -rf $(XRUN_RESULTS_DIR)
	rm -rf $(dpi-library)

xrun_comp: $(dpi-library)/ariane_dpi.so
	@echo "[XRUN] Building Model"
	mkdir -p $(XRUN_RESULTS_DIR)
	cd $(XRUN_RESULTS_DIR) && $(XRUN)   \
		+permissive		    \
		$(XRUN_COMP)                \
		-l $(XRUN_COMPL_LOG)        \
		+permissive-off		    \
		-elaborate

xrun_sim: xrun_comp
	@echo "[XRUN] Simulating selected binary"
	cd $(XRUN_RESULTS_DIR) && $(XRUN)	\
		+permissive			\
		$(XRUN_RUN)			\
		+MAX_CYCLES=$(max_cycles)	\
		+UVM_TESTNAME=$(test_case)	\
		-l $(XRUN_RUN_LOG)		\
		+permissive-off			\
		++$(elf-bin)

#-e "set_severity_pack_assert_off {warning}; set_pack_assert_off {numeric_std}" TODO: This will remove assertion warning at the beginning of the simulation.

xrun_all: xrun_clean xrun_comp xrun_sim

$(addprefix xrun_, $(riscv-asm-tests)): xrun_comp
	cd $(XRUN_RESULTS_DIR); 								\
	mkdir -p isa/asm/;									\
	$(XRUN)	+permissive $(XRUN_RUN) +MAX_CYCLES=$(max_cycles) +UVM_TESTNAME=$(test_case) 	\
	-l isa/asm/$(notdir $@).log +permissive-off ++$(CVA6_HOME)/$(riscv-test-dir)/$(patsubst xrun_%,%,$@)

$(addprefix xrun_, $(riscv-amo-tests)): xrun_comp
	cd $(XRUN_RESULTS_DIR); 								\
	mkdir -p isa/amo/;									\
	$(XRUN)	+permissive $(XRUN_RUN) +MAX_CYCLES=$(max_cycles) +UVM_TESTNAME=$(test_case) 	\
	-l isa/amo/$(notdir $@).log +permissive-off ++$(CVA6_HOME)/$(riscv-test-dir)/$(patsubst xrun_%,%,$@)

$(addprefix xrun_, $(riscv-mul-tests)): xrun_comp
	cd $(XRUN_RESULTS_DIR); 								\
	mkdir -p isa/mul/;									\
	$(XRUN)	+permissive $(XRUN_RUN) +MAX_CYCLES=$(max_cycles) +UVM_TESTNAME=$(test_case) 	\
	-l isa/mul/$(notdir $@).log +permissive-off ++$(CVA6_HOME)/$(riscv-test-dir)/$(patsubst xrun_%,%,$@)

$(addprefix xrun_, $(riscv-fp-tests)): xrun_comp
	cd $(XRUN_RESULTS_DIR); 								\
	mkdir -p isa/fp/;									\
	$(XRUN)	+permissive $(XRUN_RUN) +MAX_CYCLES=$(max_cycles) +UVM_TESTNAME=$(test_case) 	\
	-l isa/fp/$(notdir $@).log +permissive-off ++$(CVA6_HOME)/$(riscv-test-dir)/$(patsubst xrun_%,%,$@)

$(addprefix xrun_, $(riscv-benchmarks)): xrun_comp
	cd $(XRUN_RESULTS_DIR);									\
	mkdir -p benchmarks/;									\
	$(XRUN)	+permissive $(XRUN_RUN) +MAX_CYCLES=$(max_cycles) +UVM_TESTNAME=$(test_case) 	\
	-l benchmarks/$(notdir $@).log +permissive-off ++$(CVA6_HOME)/$(riscv-benchmarks-dir)/$(patsubst xrun_%,%,$@)

# can use -jX to run ci tests in parallel using X processes
xrun-asm-tests: $(addprefix xrun_, $(riscv-asm-tests))
	$(MAKE) xrun-check-asm-tests

xrun-amo-tests: $(addprefix xrun_, $(riscv-amo-tests))
	$(MAKE) xrun-check-amo-tests

xrun-mul-tests: $(addprefix xrun_, $(riscv-mul-tests))
	$(MAKE) xrun-check-mul-tests

xrun-fp-tests: $(addprefix xrun_, $(riscv-fp-tests))
	$(MAKE) xrun-check-fp-tests

xrun-check-asm-tests:
	ci/check-tests.sh $(XRUN_RESULTS_DIR)/isa/asm/ $(shell wc -l $(riscv-asm-tests-list) | awk -F " " '{ print $1 }')

xrun-check-amo-tests:
	ci/check-tests.sh $(XRUN_RESULTS_DIR)/isa/amo/ $(shell wc -l $(riscv-amo-tests-list) | awk -F " " '{ print $1 }')

xrun-check-mul-tests:
	ci/check-tests.sh $(XRUN_RESULTS_DIR)/isa/mul/ $(shell wc -l $(riscv-mul-tests-list) | awk -F " " '{ print $1 }')

xrun-check-fp-tests:
	ci/check-tests.sh $(XRUN_RESULTS_DIR)/isa/fp/ $(shell wc -l $(riscv-fp-tests-list) | awk -F " " '{ print $1 }')


# can use -jX to run ci tests in parallel using X processes
xrun-benchmarks: $(addprefix xrun_, $(riscv-benchmarks))
	$(MAKE) check-benchmarks


xrun-check-benchmarks:
	ci/check-tests.sh $(XRUN_RESULTS_DIR)/benchmarks/ $(shell wc -l $(riscv-benchmarks-list) | awk -F " " '{ print $1 }')

xrun-ci: xrun-asm-tests xrun-amo-tests xrun-mul-tests xrun-fp-tests xrun-benchmarks

# verilator-specific
verilate_command := $(verilator)                                                                                 \
                    $(filter-out %.vhd, $(ariane_pkg))                                                           \
                    $(filter-out src/fpu_wrap.sv, $(filter-out %.vhd, $(src)))                                   \
                    +define+$(defines)                                                                           \
                    src/util/sram.sv                                                                             \
                    tb/common/mock_uart.sv                                                                       \
                    +incdir+src/axi_node                                                                         \
                    $(if $(verilator_threads), --threads $(verilator_threads))                                   \
                    --unroll-count 256                                                                           \
                    -Werror-PINMISSING                                                                           \
                    -Werror-IMPLICIT                                                                             \
                    -Wno-fatal                                                                                   \
                    -Wno-PINCONNECTEMPTY                                                                         \
                    -Wno-ASSIGNDLY                                                                               \
                    -Wno-DECLFILENAME                                                                            \
                    -Wno-UNUSED                                                                                  \
                    -Wno-UNOPTFLAT                                                                               \
                    -Wno-BLKANDNBLK                                                                              \
                    -Wno-style                                                                                   \
                    $(if $(DROMAJO), -DDROMAJO=1,)                                                               \
                    $(if $(PROFILE),--stats --stats-vars --profile-cfuncs,)                                      \
                    $(if $(DEBUG),--trace --trace-structs,)                                                      \
                    -LDFLAGS "-L$(RISCV)/lib -L$(SPIKE_ROOT)/lib -Wl,-rpath,$(RISCV)/lib -Wl,-rpath,$(SPIKE_ROOT)/lib -lfesvr$(if $(PROFILE), -g -pg,) $(if $(DROMAJO), -L../tb/dromajo/src -ldromajo_cosim,) -lpthread" \
                    -CFLAGS "$(CFLAGS)$(if $(PROFILE), -g -pg,) $(if $(DROMAJO), -DDROMAJO=1,) -DVL_DEBUG"       \
                    -Wall --cc  --vpi                                                                            \
                    $(list_incdir) --top-module ariane_testharness                                               \
					--threads-dpi none 																			 \
                    --Mdir $(ver-library) -O3                                                                    \
                    --exe tb/ariane_tb.cpp tb/dpi/SimDTM.cc tb/dpi/SimJTAG.cc                                    \
					tb/dpi/remote_bitbang.cc tb/dpi/msim_helper.cc $(if $(DROMAJO), tb/dpi/dromajo_cosim_dpi.cc,)

dromajo:
	cd ./tb/dromajo/src && make

run-dromajo-verilator:
	$(if $(BIN), $(MAKE) checkpoint_dromajo, $(error "Please provide absolute path to the binary. Usage: make run_dromajo BIN=/absolute/path/to/binary"))

checkpoint_dromajo:
	cd ./tb/dromajo/run/checkpoints/ && \
	rm -rf $(notdir $(BIN)) && mkdir $(notdir $(BIN)) && cd $(notdir $(BIN)) && \
  cp $(BIN) . && \
	echo -e "\
	{\n\
    \"version\":1,\n\
    \"machine\":\"riscv64\",\n\
    \"memory_size\":256,\n\
    \"bios\":\"$(shell pwd)/tb/dromajo/run/checkpoints/$(notdir $(BIN))/$(notdir $(BIN))\",\n\
    \"memory_base_addr\":0x80000000,\n\
    \"missing_csrs\": [0x323, 0x324, 0x325, 0x326, //mhpmevent csrs\n\
                     0x327, 0x328, 0x329, 0x32a,\n\
                     0x32b, 0x32c, 0x32d, 0x32e,\n\
                     0x32f, 0x330, 0x331, 0x332,\n\
                     0x333, 0x334, 0x335, 0x336,\n\
                     0x337, 0x338, 0x339, 0x33a,\n\
                     0x33b, 0x33c, 0x33d, 0x33e,\n\
                     0x33f,\n\
                     0x3a0, 0x3a1, 0x3a2, 0x3a3, //pmp csrs\n\
                     0x3b0, 0x3b1, 0x3b2, 0x3b3,\n\
                     0x3b4, 0x3b5, 0x3b6, 0x3b7,\n\
                     0x3b8, 0x3b9, 0x3ba, 0x3bb,\n\
                     0x3bc, 0x3bd, 0x3be, 0x3bf,\n\
                     0x320], //mcountinhibit\n\
    \"maxinsns\": 100,\n\
		\"clint_base_addr\": 0x02000000,\n\
	  \"clint_size\": 0xC0000,\n\
	  \"plic_base_addr\": 0x0C000000,\n\
	  \"plic_size\": 0x3FFFFFF,\n\
	  \"uart_base_addr\": 0x10000000,\n\
	  \"uart_size\": 0x1000\n\
  }" > "$(notdir $(BIN))_boot.cfg" && \
	echo -e "\
	{\n\
    \"version\":1,\n\
    \"machine\":\"riscv64\",\n\
    \"memory_size\":256,\n\
    \"bios\":\"$(shell pwd)/tb/dromajo/run/checkpoints/$(notdir $(BIN))/$(notdir $(BIN))\",\n\
    \"load\":\"$(shell pwd)/tb/dromajo/run/checkpoints/$(notdir $(BIN))/$(notdir $(BIN))\",\n\
    \"skip_commit\": [0x73, 0x9002, 0x100073],\n\
    \"memory_base_addr\":0x80000000,\n\
		\"clint_base_addr\": 0x02000000,\n\
	  \"clint_size\": 0xC0000,\n\
	  \"plic_base_addr\": 0x0C000000,\n\
	  \"plic_size\": 0x3FFFFFF,\n\
	  \"uart_base_addr\": 0x10000000,\n\
	  \"uart_size\": 0x1000\n\
  }" > "$(notdir $(BIN)).cfg" && \
  ../../../src/dromajo --save=$(notdir $(BIN)) --save_format=1 ./$(notdir $(BIN))_boot.cfg && \
  cd ../../../../../ && \
	./work-ver/Variane_testharness +checkpoint=$(shell pwd)/tb/dromajo/run/checkpoints/$(notdir $(BIN))/$(notdir $(BIN))


# User Verilator, at some point in the future this will be auto-generated
verilate: $(if $(DROMAJO), dromajo,)
	@echo "[Verilator] Building Model$(if $(PROFILE), for Profiling,)"
	$(verilate_command)
	cd $(ver-library) && $(MAKE) -j${NUM_JOBS} -f Variane_testharness.mk

sim-verilator: verilate
	$(ver-library)/Variane_testharness $(elf-bin)

$(addsuffix -verilator,$(riscv-asm-tests)): verilate
	$(ver-library)/Variane_testharness $(riscv-test-dir)/$(subst -verilator,,$@)

$(addsuffix -verilator,$(riscv-amo-tests)): verilate
	$(ver-library)/Variane_testharness $(riscv-test-dir)/$(subst -verilator,,$@)

$(addsuffix -verilator,$(riscv-mul-tests)): verilate
	$(ver-library)/Variane_testharness $(riscv-test-dir)/$(subst -verilator,,$@)

$(addsuffix -verilator,$(riscv-fp-tests)): verilate
	$(ver-library)/Variane_testharness $(riscv-test-dir)/$(subst -verilator,,$@)

$(addsuffix -verilator,$(riscv-benchmarks)): verilate
	$(ver-library)/Variane_testharness $(riscv-benchmarks-dir)/$(subst -verilator,,$@)

run-all-tests-verilator: $(addsuffix -verilator, $(riscv-asm-tests)) $(addsuffix -verilator, $(riscv-amo-tests)) $(addsuffix -verilator, $(run-mul-verilator)) $(addsuffix -verilator, $(riscv-fp-tests))

run-asm-tests-verilator: $(addsuffix -verilator, $(riscv-asm-tests))

run-amo-verilator: $(addsuffix -verilator, $(riscv-amo-tests))

run-mul-verilator: $(addsuffix -verilator, $(riscv-mul-tests))

run-fp-verilator: $(addsuffix -verilator, $(riscv-fp-tests))

run-fp-d-verilator: $(addsuffix -verilator, $(filter rv64ud%, $(riscv-fp-tests)))

run-fp-f-verilator: $(addsuffix -verilator, $(filter rv64uf%, $(riscv-fp-tests)))

run-benchmarks-verilator: $(addsuffix -verilator,$(riscv-benchmarks))

# torture-specific
torture-gen:
	cd $(riscv-torture-dir) && $(riscv-torture-bin) 'generator/run'

torture-itest:
	cd $(riscv-torture-dir) && $(riscv-torture-bin) 'testrun/run -a output/test.S'

torture-rtest: build
	cd $(riscv-torture-dir) && printf "#!/bin/sh\ncd $(root-dir) && $(MAKE) run-torture$(torture-logs) batch-mode=1 defines=$(defines) test-location=$(test-location)" > call.sh && chmod +x call.sh
	cd $(riscv-torture-dir) && $(riscv-torture-bin) 'testrun/run -r ./call.sh -a $(test-location).S' | tee $(test-location).log
	make check-torture test-location=$(test-location)

torture-dummy: build
	cd $(riscv-torture-dir) && printf "#!/bin/sh\ncd $(root-dir) && $(MAKE) run-torture batch-mode=1 defines=$(defines) test-location=\$${@: -1}" > call.sh

torture-rnight: build
	cd $(riscv-torture-dir) && printf "#!/bin/sh\ncd $(root-dir) && $(MAKE) run-torture$(torture-logs) batch-mode=1 defines=$(defines) test-location=\$${@: -1}" > call.sh && chmod +x call.sh
	cd $(riscv-torture-dir) && $(riscv-torture-bin) 'overnight/run -r ./call.sh -g none' | tee output/overnight.log
	$(MAKE) check-torture

torture-rtest-verilator: verilate
	cd $(riscv-torture-dir) && printf "#!/bin/sh\ncd $(root-dir) && $(MAKE) run-torture-verilator batch-mode=1 defines=$(defines)" > call.sh && chmod +x call.sh
	cd $(riscv-torture-dir) && $(riscv-torture-bin) 'testrun/run -r ./call.sh -a output/test.S' | tee output/test.log
	$(MAKE) check-torture

run-torture: build
	vsim${questa_version} +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles)+UVM_TESTNAME=$(test_case)                                  \
	+BASEDIR=$(riscv-torture-dir) $(uvm-flags) +jtag_rbb_enable=0 -gblso $(SPIKE_ROOT)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi                                      \
	${top_level}_optimized +permissive-off +signature=$(riscv-torture-dir)/$(test-location).rtlsim.sig ++$(riscv-torture-dir)/$(test-location) ++$(target-options)

run-torture-log: build
	vsim${questa_version} +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles)+UVM_TESTNAME=$(test_case)                                  \
	+BASEDIR=$(riscv-torture-dir) $(uvm-flags) +jtag_rbb_enable=0 -gblso $(SPIKE_ROOT)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi                                      \
	${top_level}_optimized +permissive-off +signature=$(riscv-torture-dir)/$(test-location).rtlsim.sig ++$(riscv-torture-dir)/$(test-location) ++$(target-options)
	cp vsim.wlf $(riscv-torture-dir)/$(test-location).wlf
	cp trace_hart_0000.log $(riscv-torture-dir)/$(test-location).trace
	cp trace_hart_0000_commit.log $(riscv-torture-dir)/$(test-location).commit
	cp transcript $(riscv-torture-dir)/$(test-location).transcript

run-torture-verilator: verilate
	$(ver-library)/Variane_testharness +max-cycles=$(max_cycles) +signature=$(riscv-torture-dir)/output/test.rtlsim.sig $(riscv-torture-dir)/output/test

check-torture:
	grep 'All signatures match for $(test-location)' $(riscv-torture-dir)/$(test-location).log
	diff -s $(riscv-torture-dir)/$(test-location).spike.sig $(riscv-torture-dir)/$(test-location).rtlsim.sig

fpga_filter := $(addprefix $(root-dir), bootrom/bootrom.sv)
fpga_filter += $(addprefix $(root-dir), include/instr_tracer_pkg.sv)
fpga_filter += $(addprefix $(root-dir), src/util/ex_trace_item.sv)
fpga_filter += $(addprefix $(root-dir), src/util/instr_trace_item.sv)
fpga_filter += $(addprefix $(root-dir), src/util/instr_tracer_if.sv)
fpga_filter += $(addprefix $(root-dir), src/util/instr_tracer.sv)

fpga: $(ariane_pkg) $(util) $(src) $(fpga_src) $(uart_src)
	@echo "[FPGA] Generate sources"
	@echo read_vhdl        {$(uart_src)}    > fpga/scripts/add_sources.tcl
	@echo read_verilog -sv {$(ariane_pkg)} >> fpga/scripts/add_sources.tcl
	@echo read_verilog -sv {$(filter-out $(fpga_filter), $(util))}     >> fpga/scripts/add_sources.tcl
	@echo read_verilog -sv {$(filter-out $(fpga_filter), $(src))} 	   >> fpga/scripts/add_sources.tcl
	@echo read_verilog -sv {$(fpga_src)}   >> fpga/scripts/add_sources.tcl
	@echo "[FPGA] Generate Bitstream"
	cd fpga && make BOARD=$(BOARD) XILINX_PART=$(XILINX_PART) XILINX_BOARD=$(XILINX_BOARD) CLK_PERIOD_NS=$(CLK_PERIOD_NS)

.PHONY: fpga

build-spike:
	cd tb/riscv-isa-sim && mkdir -p build && cd build && ../configure --prefix=`pwd`/../install --with-fesvr=$(RISCV) --enable-commitlog && make -j8 install

clean:
	rm -rf $(riscv-torture-dir)/output/test*
	rm -rf $(library)/ $(dpi-library)/ $(ver-library)/
	rm -f tmp/*.ucdb tmp/*.log *.wlf *vstf wlft* *.ucdb

.PHONY:
	build sim sim-verilate clean                                              \
	$(riscv-asm-tests) $(addsuffix _verilator,$(riscv-asm-tests))             \
	$(riscv-benchmarks) $(addsuffix _verilator,$(riscv-benchmarks))           \
	check-benchmarks check-asm-tests                                          \
	torture-gen torture-itest torture-rtest                                   \
	run-torture run-torture-verilator check-torture check-torture-verilator
