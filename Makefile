# Author: Florian Zaruba, ETH Zurich
# Date: 03/19/2017
# Description: Makefile for linting and testing Ariane.

# questa library
library        ?= work
# verilator lib
ver-library    ?= work-ver
# vcs lib
vcs-library    ?= work-vcs
# library for DPI
dpi-library    ?= work-dpi
# Top level module to compile
top_level      ?= ariane_tb
# Top level path
top_level_path ?= corev_apu/tb/$(top_level).sv
# Maximum amount of cycles for a successful simulation run
max_cycles     ?= 10000000
# Test case to run
test_case      ?= core_test
# QuestaSim Version
questa_version ?= ${QUESTASIM_VERSION}
VLOG ?= vlog$(questa_version)
VSIM ?= vsim$(questa_version)
VOPT ?= vopt$(questa_version)
VCOM ?= vcom$(questa_version)
VLIB ?= vlib$(questa_version)
VMAP ?= vmap$(questa_version)
# verilator version
verilator             ?= verilator
# traget option
target-options ?=
# additional defines
defines        ?=
# test name for torture runs (binary name)
test-location  ?= output/test
# set to either nothing or -log
torture-logs   :=
# custom elf bin to run with sim or sim-verilator
elf_file        ?= tmp/riscv-tests/build/benchmarks/dhrystone.riscv
# board name for bitstream generation. Currently supported: kc705, genesys2, nexys_video
BOARD          ?= genesys2
ALTERA_BOARD		 ?= DK-DEV-AGF014E3ES
ALTERA_FAMILY	 ?= "AGILEX"
ALTERA_PART		 ?= AGFB014R24B2E2V
PLATFORM			 = "PLAT_XILINX"
# root path
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
root-dir := $(dir $(mkfile_path))

ifndef CVA6_REPO_DIR
$(warning must set CVA6_REPO_DIR to point at the root of CVA6 sources -- doing it for you...)
export CVA6_REPO_DIR = $(abspath $(root-dir))
endif

support_verilator_4 := $(shell ($(verilator) --version | grep '4\.') > /dev/null 2>&1 ; echo $$?)
ifeq ($(support_verilator_4), 0)
	verilator_threads := 1
endif
# Location of Verilator headers and optional source files
VL_INC_DIR := $(VERILATOR_INSTALL_DIR)/share/verilator/include

ifndef RISCV
$(error RISCV not set - please point your RISCV variable to your RISCV installation)
endif

# Spike tandem mode: default to environment setting (DISABLED if envariable SPIKE_TANDEM is not set).
spike-tandem ?= $(SPIKE_TANDEM)

SPIKE_INSTALL_DIR     ?= $(root-dir)/tools/spike

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
else ifeq ($(BOARD), nexys_video)
	XILINX_PART              := xc7a200tsbg484-1
	XILINX_BOARD             := digilentinc.com:nexys_video:part0:1.1
	CLK_PERIOD_NS            := 40
else
$(error Unknown board - please specify a supported FPGA board)
endif

# spike tandem verification
ifneq ($(spike-tandem),)
    compile_flag += -define SPIKE_TANDEM
    CFLAGS += -I. -I$(SPIKE_INSTALL_DIR)/include/riscv
    CFLAGS += -I. -I$(SPIKE_INSTALL_DIR)/include/disasm
    defines += +SPIKE_TANDEM=1
endif

# target takes one of the following cva6 hardware configuration:
# cv64a6_imafdc_sv39, cv32a6_imac_sv0, cv32a6_imac_sv32, cv32a6_imafc_sv32, cv32a6_ima_sv32_fpga
# Changing the default target to cv32a60x for Step1 verification
target     ?= cv64a6_imafdc_sv39
ifeq ($(target), cv64a6_imafdc_sv39)
	XLEN ?= 64
else
	XLEN ?= 32
endif
ifndef TARGET_CFG
	export TARGET_CFG = $(target)
endif

# HPDcache directory
HPDCACHE_DIR ?= $(CVA6_REPO_DIR)/core/cache_subsystem/hpdcache
export HPDCACHE_DIR

# Sources
# Package files -> compile first
ariane_pkg := \
              corev_apu/tb/ariane_axi_pkg.sv                         \
              corev_apu/tb/axi_intf.sv                               \
              corev_apu/register_interface/src/reg_intf.sv           \
              corev_apu/tb/ariane_soc_pkg.sv                         \
              corev_apu/riscv-dbg/src/dm_pkg.sv                      \
              corev_apu/tb/ariane_axi_soc_pkg.sv
ariane_pkg := $(addprefix $(root-dir), $(ariane_pkg))

# Test packages
test_pkg := $(wildcard tb/test/*/*sequence_pkg.sv*) \
			$(wildcard tb/test/*/*_pkg.sv*)

# DPI
dpi := $(patsubst corev_apu/tb/dpi/%.cc, ${dpi-library}/%.o, $(wildcard corev_apu/tb/dpi/*.cc))

# filter spike stuff if tandem is not activated
ifeq ($(spike-tandem),)
    dpi := $(filter-out ${dpi-library}/spike.o ${dpi-library}/sim_spike.o, $(dpi))
endif

dpi_hdr := $(wildcard corev_apu/tb/dpi/*.h)
dpi_hdr := $(addprefix $(root-dir), $(dpi_hdr))
CFLAGS += -I$(QUESTASIM_HOME)/include         \
          -I$(VCS_HOME)/include               \
          -I$(VL_INC_DIR)/vltstd              \
          -I$(RISCV)/include                  \
          -I$(SPIKE_INSTALL_DIR)/include      \
          -std=c++17 -I$(CVA6_REPO_DIR)/corev_apu/tb/dpi -O3

ifdef XCELIUM_HOME
CFLAGS += -I$(XCELIUM_HOME)/tools/include
else
$(warning XCELIUM_HOME not set which is necessary for compiling DPIs when using XCELIUM)
endif

# this list contains the standalone components
src :=  $(if $(spike-tandem),verif/tb/core/uvma_core_cntrl_pkg.sv)                   \
        $(if $(spike-tandem),verif/tb/core/uvma_cva6pkg_utils_pkg.sv)                \
        $(if $(spike-tandem),verif/tb/core/uvma_rvfi_pkg.sv)                         \
        $(if $(spike-tandem),verif/tb/core/uvmc_rvfi_reference_model_pkg.sv)         \
        $(if $(spike-tandem),verif/tb/core/uvmc_rvfi_scoreboard_pkg.sv)              \
        $(if $(spike-tandem),corev_apu/tb/common/spike.sv)                           \
        core/cva6_rvfi.sv                                                            \
        corev_apu/src/ariane.sv                                                      \
        $(wildcard corev_apu/bootrom/*.sv)                                           \
        $(wildcard corev_apu/clint/*.sv)                                             \
        $(wildcard corev_apu/fpga/src/axi2apb/src/*.sv)                              \
        $(wildcard corev_apu/fpga/src/apb_timer/*.sv)                                \
        $(wildcard corev_apu/fpga/src/axi_slice/src/*.sv)                            \
        $(wildcard corev_apu/src/axi_riscv_atomics/src/*.sv)                         \
        $(wildcard corev_apu/axi_mem_if/src/*.sv)                                    \
				$(wildcard corev_apu/riscv-dbg/src/*.sv)                                   \
        corev_apu/rv_plic/rtl/rv_plic_target.sv                                      \
        corev_apu/rv_plic/rtl/rv_plic_gateway.sv                                     \
        corev_apu/rv_plic/rtl/plic_regmap.sv                                         \
        corev_apu/rv_plic/rtl/plic_top.sv                                            \
        corev_apu/riscv-dbg/debug_rom/debug_rom.sv                                   \
        corev_apu/register_interface/src/apb_to_reg.sv                               \
        vendor/pulp-platform/axi/src/axi_multicut.sv                                 \
        vendor/pulp-platform/common_cells/src/rstgen_bypass.sv                       \
        vendor/pulp-platform/common_cells/src/rstgen.sv                              \
        vendor/pulp-platform/common_cells/src/addr_decode.sv                         \
        vendor/pulp-platform/common_cells/src/stream_register.sv                     \
        vendor/pulp-platform/axi/src/axi_cut.sv                                      \
        vendor/pulp-platform/axi/src/axi_join.sv                                     \
        vendor/pulp-platform/axi/src/axi_delayer.sv                                  \
        vendor/pulp-platform/axi/src/axi_to_axi_lite.sv                              \
        vendor/pulp-platform/axi/src/axi_id_prepend.sv                               \
        vendor/pulp-platform/axi/src/axi_atop_filter.sv                              \
        vendor/pulp-platform/axi/src/axi_err_slv.sv                                  \
        vendor/pulp-platform/axi/src/axi_mux.sv                                      \
        vendor/pulp-platform/axi/src/axi_demux.sv                                    \
        vendor/pulp-platform/axi/src/axi_xbar.sv                                     \
        vendor/pulp-platform/common_cells/src/cdc_2phase.sv                          \
        vendor/pulp-platform/common_cells/src/spill_register_flushable.sv            \
        vendor/pulp-platform/common_cells/src/spill_register.sv                      \
        vendor/pulp-platform/common_cells/src/deprecated/fifo_v1.sv                  \
        vendor/pulp-platform/common_cells/src/deprecated/fifo_v2.sv                  \
        vendor/pulp-platform/common_cells/src/stream_delay.sv                        \
        vendor/pulp-platform/common_cells/src/lfsr_16bit.sv                          \
        vendor/pulp-platform/tech_cells_generic/src/deprecated/cluster_clk_cells.sv  \
        vendor/pulp-platform/tech_cells_generic/src/deprecated/pulp_clk_cells.sv     \
        vendor/pulp-platform/tech_cells_generic/src/rtl/tc_clk.sv                    \
        corev_apu/tb/ariane_testharness.sv                                           \
        corev_apu/tb/ariane_peripherals.sv                                           \
        corev_apu/tb/rvfi_tracer.sv                                                  \
        corev_apu/tb/common/uart.sv                                                  \
        corev_apu/tb/common/SimDTM.sv                                                \
        corev_apu/tb/common/SimJTAG.sv

src := $(addprefix $(root-dir), $(src))

copro_src := core/cvxif_example/include/cvxif_instr_pkg.sv \
             $(wildcard core/cvxif_example/*.sv)
copro_src := $(addprefix $(root-dir), $(copro_src))

uart_src := $(wildcard corev_apu/fpga/src/apb_uart/src/vhdl_orig/*.vhd)
uart_src := $(addprefix $(root-dir), $(uart_src))

uart_src_sv:= corev_apu/fpga/src/apb_uart/src/slib_clock_div.sv     \
              corev_apu/fpga/src/apb_uart/src/slib_counter.sv       \
              corev_apu/fpga/src/apb_uart/src/slib_edge_detect.sv   \
              corev_apu/fpga/src/apb_uart/src/slib_fifo.sv          \
              corev_apu/fpga/src/apb_uart/src/slib_input_filter.sv  \
              corev_apu/fpga/src/apb_uart/src/slib_input_sync.sv    \
              corev_apu/fpga/src/apb_uart/src/slib_mv_filter.sv     \
              corev_apu/fpga/src/apb_uart/src/uart_baudgen.sv       \
              corev_apu/fpga/src/apb_uart/src/uart_interrupt.sv     \
              corev_apu/fpga/src/apb_uart/src/uart_receiver.sv      \
              corev_apu/fpga/src/apb_uart/src/uart_transmitter.sv   \
              corev_apu/fpga/src/apb_uart/src/apb_uart.sv           \
              corev_apu/fpga/src/apb_uart/src/apb_uart_wrap.sv
uart_src_sv := $(addprefix $(root-dir), $(uart_src_sv))

fpga_src :=  $(wildcard corev_apu/fpga/src/*.sv) $(wildcard corev_apu/fpga/src/ariane-ethernet/*.sv) common/local/util/tc_sram_fpga_wrapper.sv common/local/util/hpdcache_sram_1rw.sv common/local/util/hpdcache_sram_wbyteenable_1rw.sv vendor/pulp-platform/fpga-support/rtl/SyncSpRamBeNx64.sv vendor/pulp-platform/fpga-support/rtl/SyncSpRamBeNx32.sv vendor/pulp-platform/fpga-support/rtl/SyncSpRam.sv

altera_src := $(shell find $(root-dir)/corev_apu/altera/src -type f \( -name "*.v" -o -name "*.sv" -o -name "*.svh" \) -print | sed 's|//|/|g')
altera_src += $(src)
altera_src += $(shell find $(root-dir)/corev_apu/fpga/src -type f \( -name "*.v" -o -name "*.sv" \) -print | sed 's|//|/|g')
altera_src += $(shell find $(root-dir)core/cvfpu/src/common_cells/src/ -maxdepth 1 -type f \( -name "*.v" -o -name "*.sv" -o -name "*.vhd" -o -name "*.svh" \) -print)
altera_axi_src := $(shell find $(root-dir)/vendor/pulp-platform/axi/src -type f \( -name "*.v" -o -name "*.sv" \) -print | sed 's|//|/|g')

altera_src += $(root-dir)corev_apu/rv_plic/rtl/top_pkg.sv \
							$(root-dir)corev_apu/rv_plic/rtl/tlul_pkg.sv \
							$(root-dir)corev_apu/rv_plic/rtl/rv_plic_reg_top.sv \
							$(root-dir)corev_apu/rv_plic/rtl/rv_plic_reg_pkg.sv \
							$(root-dir)corev_apu/rv_plic/rtl/rv_plic.sv \
							$(root-dir)corev_apu/rv_plic/rtl/prim_subreg_ext.sv \
							$(root-dir)corev_apu/rv_plic/rtl/prim_subreg.sv \
							$(root-dir)vendor/pulp-platform/common_cells/src/cdc_fifo_gray.sv \
							$(root-dir)riscv-dbg/src/dm_obi_top.sv \
							$(root-dir)core/include/instr_tracer_pkg.sv \
							$(root-dir)core/cvfpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_mvp_wrapper.sv \
							$(root-dir)core/cache_subsystem/amo_alu.sv

altera_filter := corev_apu/tb/ariane_testharness.sv \
								corev_apu/tb/ariane_peripherals.sv \
								corev_apu/tb/rvfi_tracer.sv \
								corev_apu/tb/common/uart.sv \
								corev_apu/tb/common/SimDTM.sv \
								corev_apu/tb/common/SimJTAG.sv \
								corev_apu/fpga/src/apb/src/apb_test.sv \
								corev_apu/fpga/src/ariane_xilinx.sv \
								corev_apu/fpga/ariane_peripherals_xilinx.sv \
								corev_apu/fpga/src/apb/test/tb_apb_cdc.sv \
								corev_apu/fpga/src/apb/test/tb_apb_regs.sv \
								corev_apu/fpga/src/apb/test/tb_apb_demux.sv \
								corev_apu/fpga/src/gpio/test/tb_gpio.sv \
								vendor/pulp-platform/axi/src/axi_test.sv \
								corev_apu/riscv-dbg/src/dm_pkg.sv \
								corev_apu/riscv-dbg/src/dmi_jtag_tap.sv \
								corev_apu/riscv-dbg/src/dmi_jtag.sv \
								corev_apu/fpga/src/apb_uart/src/reg_uart_wrap.sv
								
altera_filter := $(addprefix $(root-dir), $(altera_filter))
xil_debug_filter = $(addprefix $(root-dir), corev_apu/riscv-dbg/src/dm_obi_top.sv)
xil_debug_filter += $(addprefix $(root-dir), corev_apu/riscv-dbg/src/dm_pkg.sv)
xil_debug_filter += $(addprefix $(root-dir), corev_apu/riscv-dbg/src/dmi_vjtag_tap.sv)
xil_debug_filter += $(addprefix $(root-dir), corev_apu/riscv-dbg/src/dmi_vjtag.sv)						
src := $(filter-out $(xil_debug_filter), $(src))

fpga_src := $(addprefix $(root-dir), $(fpga_src)) src/bootrom/bootrom_$(XLEN).sv

# look for testbenches
tbs := $(top_level_path) corev_apu/tb/ariane_testharness.sv core/cva6_rvfi.sv

tbs := $(addprefix $(root-dir), $(tbs))

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
incdir := $(CVA6_REPO_DIR)/vendor/pulp-platform/common_cells/include/ $(CVA6_REPO_DIR)/vendor/pulp-platform/axi/include/ \
          $(CVA6_REPO_DIR)/corev_apu/register_interface/include/ $(CVA6_REPO_DIR)/corev_apu/tb/common/ \
          $(CVA6_REPO_DIR)/vendor/pulp-platform/axi/include/ \
          $(CVA6_REPO_DIR)/verif/core-v-verif/lib/uvm_agents/uvma_rvfi/ \
          $(CVA6_REPO_DIR)/verif/core-v-verif/lib/uvm_components/uvmc_rvfi_reference_model/ \
          $(CVA6_REPO_DIR)/verif/core-v-verif/lib/uvm_components/uvmc_rvfi_scoreboard/ \
          $(CVA6_REPO_DIR)/verif/core-v-verif/lib/uvm_agents/uvma_core_cntrl/ \
          $(CVA6_REPO_DIR)/verif/tb/core/ \
          $(CVA6_REPO_DIR)/core/include/ \
          $(SPIKE_INSTALL_DIR)/include/disasm/

# Compile and sim flags
compile_flag     += -incr -64 -nologo -quiet -suppress 13262 -suppress 8607 +permissive -svinputport=compat +define+$(defines) -suppress 8386 -suppress vlog-2577
vopt_flag += -suppress 2085 -suppress 7063 -suppress 2698 -suppress 13262

ifdef config-file
  spike-yaml-plusarg = +config_file=$(spike_yaml)
endif

uvm-flags        += +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_LOW
questa-flags     += -t 1ns -64 $(gui-sim) $(QUESTASIM_FLAGS) \
			+tohost_addr=$(shell ${RISCV}/bin/${CV_SW_PREFIX}nm -B $(elf) | grep -w tohost | cut -d' ' -f1) \
			+core_name=$(target) +define+QUESTA -suppress 3356 -suppress 3579 +report_file=$(report_file) \
			$(spike-yaml-plusarg)
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
        questa-cmd   += -do "run -all;"
endif
ifdef cov-mode
        compile_flags += +cover=bcfst+/dut
        questa-flags += -coverage
	questa-cmd   := -do "coverage save -onexit tmp/$@.ucdb; run -a; quit -code [coverage attribute -name TESTSTATUS -concise]"
endif
# we want to preload the memories
ifdef preload
	questa-cmd += +PRELOAD=$(preload)
	elf_file = none
endif

ifdef spike-tandem
    questa-cmd += -gblso $(SPIKE_INSTALL_DIR)/lib/libyaml-cpp.so -gblso $(SPIKE_INSTALL_DIR)/lib/libriscv.so
endif

# remote bitbang is enabled
ifdef rbb
	questa-cmd += +jtag_rbb_enable=1
else
	questa-cmd += +jtag_rbb_enable=0
endif

flist ?= core/Flist.cva6

vcs_build: $(dpi-library)/ariane_dpi.so
	mkdir -p $(vcs-library)
	cd $(vcs-library) &&\
	vlogan $(if $(VERDI), -kdb,) -full64 -nc -sverilog +define+$(defines) -assert svaext -f $(flist) $(list_incdir) ../corev_apu/tb/common/mock_uart.sv -timescale=1ns/1ns &&\
	vlogan $(if $(VERDI), -kdb,) -full64 -nc -sverilog +define+$(defines) $(filter %.sv,$(ariane_pkg)) +incdir+core/include/+$(VCS_HOME)/etc/uvm-1.2/dpi &&\
	vlogan $(if $(VERDI), -kdb,) -full64 -nc -sverilog $(uart_src_sv) &&\
	vlogan $(if $(VERDI), -kdb,) -full64 -nc -sverilog -assert svaext +define+$(defines) +incdir+$(VCS_HOME)/etc/uvm/src $(VCS_HOME)/etc/uvm/src/uvm_pkg.sv  $(filter %.sv,$(src)) $(list_incdir) &&\
	vlogan $(if $(VERDI), -kdb,) -full64 -nc -sverilog -ntb_opts uvm-1.2 &&\
	vlogan $(if $(VERDI), -kdb,) -full64 -nc -sverilog -ntb_opts uvm-1.2 $(tbs) +define+$(defines) $(list_incdir) &&\
	vcs -full64 $(if $(DEBUG), -debug_access+all $(if $(VERDI), -kdb),) $(if $(TRACE_COMPACT),+vcs+fsdbon) -ignore initializer_driver_checks -timescale=1ns/1ns -ntb_opts uvm-1.2 work.$(top_level) -error="IWNF" \
	$(if $(gate), -sdf Max:ariane_gate_tb.i_ariane.i_cva6:$(CVA6_REPO_DIR)/pd/synth/cva6_$(TARGET)_synth.sdf +neg_tchk, +notimingcheck)

vcs: vcs_build
	cd $(vcs-library) && \
	 ./simv +permissive $(if $(VERDI), -verdi -do $(root-dir)/init_testharness.do,) \
		+elf_file=$(elf_file) ++$(elf_file) $(if $(spike-tandem), -sv_lib $(SPIKE_INSTALL_DIR)/libyaml-cpp) -sv_lib $(SPIKE_INSTALL_DIR)/libriscv \
		-sv_lib ../work-dpi/ariane_dpi | tee vcs.log

# Build the TB and module using QuestaSim
build: $(library) $(library)/.build-srcs $(library)/.build-tb $(dpi-library)/ariane_dpi.so
	# Optimize top level
	$(VOPT) -64 -work $(library)  $(top_level) -o $(top_level)_optimized +acc -check_synthesis -dpilib $(SPIKE_INSTALL_DIR)/lib/libriscv -dpilib $(SPIKE_INSTALL_DIR)/lib/libfesvr -dpilib $(SPIKE_INSTALL_DIR)/lib/libyaml-cpp $(vopt_flag)

# src files
$(library)/.build-srcs: $(library)
	$(VLOG) $(compile_flag) -timescale "1ns / 1ns" -work $(library) -pedanticerrors -f core/Flist.cva6 $(list_incdir) -suppress 2583 +defines+$(defines)
	$(VLOG) $(compile_flag) -work $(library) $(filter %.sv,$(ariane_pkg)) $(list_incdir) -suppress 2583 +defines+$(defines)
	# Suppress message that always_latch may not be checked thoroughly by QuestaSim.
	$(VCOM) $(compile_flag_vhd) -work $(library) $(filter %.vhd,$(uart_src)) +defines+$(defines)
	$(VLOG) $(compile_flag) -timescale "1ns / 1ns" -work $(library) -pedanticerrors $(filter %.sv,$(src)) $(tbs) $(list_incdir) -suppress 2583 +defines+$(defines)
	touch $(library)/.build-srcs

# build TBs
$(library)/.build-tb: $(dpi)
	# Compile top level
	$(VLOG) $(compile_flag) -timescale "1ns / 1ns" -sv $(tbs) -work $(library) $(list_incdir)
	touch $(library)/.build-tb

$(library):
	$(VLIB) $(library)

# compile DPIs
$(dpi-library)/%.o: corev_apu/tb/dpi/%.cc $(dpi_hdr)
	mkdir -p $(dpi-library)
	$(CXX) -shared -fPIC -Bsymbolic $(CFLAGS) -c $< -o $@

$(dpi-library)/ariane_dpi.so: $(dpi)
	mkdir -p $(dpi-library)
	# Compile C-code and generate .so file
	$(CXX) -shared -m64 -o $(dpi-library)/ariane_dpi.so $? -L$(RISCV)/lib -L$(SPIKE_INSTALL_DIR)/lib -Wl,-rpath,$(RISCV)/lib -Wl,-rpath,$(SPIKE_INSTALL_DIR)/lib -lfesvr -lriscv -lyaml-cpp

$(dpi-library)/xrun_ariane_dpi.so: $(dpi)
	# Make Dir work-dpi
	mkdir -p $(dpi-library)
	# Compile C-code and generate .so file
	$(CXX) -shared -m64 -o $(dpi-library)/xrun_ariane_dpi.so $? -L$(RISCV)/lib -L$(SPIKE_INSTALL_DIR)/lib -Wl,-rpath,$(RISCV)/lib -Wl,-rpath,$(SPIKE_INSTALL_DIR)/lib -lfesvr -lriscv -lyaml-cpp

# single test runs on Questa can be started by calling make <testname>, e.g. make towers.riscv
# the test names are defined in ci/riscv-asm-tests.list, and in ci/riscv-benchmarks.list
# if you want to run in batch mode, use make <testname> batch-mode=1
# alternatively you can call make sim elf_file=<path/to/elf_file> in order to load an arbitrary binary
generate-trace-vsim:
	make sim preload=$(preload) elf_file= batch-mode=1
	make generate-trace

sim: build
	$(VSIM) +permissive $(questa-flags) $(questa-cmd) -lib $(library) +MAX_CYCLES=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-test-dir) $(uvm-flags) -sv_lib $(SPIKE_INSTALL_DIR)/lib/libyaml-cpp -sv_lib $(SPIKE_INSTALL_DIR)/lib/libriscv -sv_lib $(SPIKE_INSTALL_DIR)/lib/libfesvr \
	-sv_lib $(SPIKE_INSTALL_DIR)/lib/libdisasm \
	${top_level}_optimized +permissive-off +elf_file=$(elf_file) ++$(elf_file) ++$(target-options)

$(riscv-asm-tests): build
	$(VSIM) +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-test-dir) $(uvm-flags) +jtag_rbb_enable=0  -gblso $(SPIKE_INSTALL_DIR)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi        \
	${top_level}_optimized $(QUESTASIM_FLAGS) +permissive-off ++$(riscv-test-dir)/$@ ++$(target-options) | tee tmp/riscv-asm-tests-$@.log

$(riscv-amo-tests): build
	$(VSIM) +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-test-dir) $(uvm-flags) +jtag_rbb_enable=0  -gblso $(SPIKE_INSTALL_DIR)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi        \
	${top_level}_optimized $(QUESTASIM_FLAGS) +permissive-off ++$(riscv-test-dir)/$@ ++$(target-options) | tee tmp/riscv-amo-tests-$@.log

$(riscv-mul-tests): build
	$(VSIM) +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-test-dir) $(uvm-flags) +jtag_rbb_enable=0  -gblso $(SPIKE_INSTALL_DIR)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi        \
	${top_level}_optimized $(QUESTASIM_FLAGS) +permissive-off ++$(riscv-test-dir)/$@ ++$(target-options) | tee tmp/riscv-mul-tests-$@.log

$(riscv-fp-tests): build
	$(VSIM) +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-test-dir) $(uvm-flags) +jtag_rbb_enable=0  -gblso $(SPIKE_INSTALL_DIR)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi        \
	${top_level}_optimized $(QUESTASIM_FLAGS) +permissive-off ++$(riscv-test-dir)/$@ ++$(target-options) | tee tmp/riscv-fp-tests-$@.log

$(riscv-benchmarks): build
	$(VSIM) +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles) +UVM_TESTNAME=$(test_case) \
	+BASEDIR=$(riscv-benchmarks-dir) $(uvm-flags) +jtag_rbb_enable=0 -gblso $(SPIKE_INSTALL_DIR)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi   \
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
##XRUN_UVMHOME_ARG   ?= CDNS-1.2-ML
XRUN_UVMHOME_ARG   ?= CDNS-1.2
XRUN_COMPL_LOG     ?= xrun_compl.log
XRUN_RUN_LOG       ?= xrun_run.log
CVA6_HOME	   ?= $(realpath -s $(root-dir))

XRUN_INCDIR :=+incdir+$(CVA6_HOME)/core/include 			\
	+incdir+$(CVA6_HOME)/vendor/pulp-platform/axi/include/		\
	+incdir+$(CVA6_HOME)/corev_apu/register_interface/include

XRUN_TB := $(addprefix $(CVA6_HOME)/, corev_apu/tb/ariane_tb.sv)

XRUN_COMP_FLAGS  ?= -64bit -v200x -disable_sem2009 -access +rwc 			\
		    -sv -uvm -uvmhome $(XRUN_UVMHOME_ARG) 			\
		    -sv_lib $(CVA6_HOME)/$(dpi-library)/xrun_ariane_dpi.so		\
		    -smartorder -sv -top worklib.$(top_level)			\
		    -timescale 1ns/1ps

XRUN_RUN_FLAGS := -R -messages -status -64bit -licqueue -noupdate -uvmhome CDNS-1.2 -sv_lib $(CVA6_HOME)/$(dpi-library)/xrun_ariane_dpi.so +UVM_VERBOSITY=UVM_LOW

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
	-f ../core/Flist.cva6    	\
	$(filter %.sv, $(ariane_pkg)) 	\
	$(filter %.sv, $(src))	      	\
	$(filter %.vhd, $(uart_src))  	\
	$(filter %.sv, $(XRUN_TB))

XRUN_RUN = $(XRUN_RUN_FLAGS) 		\
	$(XRUN_DISABLED_WARNINGS)

xrun_clean:
	@echo "[XRUN] clean up"
	rm -rf $(XRUN_RESULTS_DIR)
	rm -rf $(dpi-library)

xrun_comp: $(dpi-library)/xrun_ariane_dpi.so
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
		+time_out=200000000000            \
		+tohost_addr=$(shell ${RISCV}/bin/${CV_SW_PREFIX}nm -B $(elf) | grep -w tohost | cut -d' ' -f1)          \
		-log $(XRUN_RUN_LOG)		\
		+gui				\
		+permissive-off			\
		+elf_file=$(elf)           \
		++$(elf)

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
verilate_command := $(verilator) --no-timing verilator_config.vlt                                                \
                    -f core/Flist.cva6                                                                           \
                    core/cva6_rvfi.sv                                                                            \
                    $(filter-out %.vhd, $(ariane_pkg))                                                           \
                    $(filter-out core/fpu_wrap.sv, $(filter-out %.vhd, $(filter-out %_config_pkg.sv, $(src))))   \
                    +define+$(defines)$(if $(TRACE_FAST),+VM_TRACE)$(if $(TRACE_COMPACT),+VM_TRACE+VM_TRACE_FST) \
                    corev_apu/tb/common/mock_uart.sv                                                             \
                    +incdir+corev_apu/axi_node                                                                   \
                    $(if $(verilator_threads), --threads $(verilator_threads))                                   \
                    --unroll-count 256                                                                           \
                    -Wall                                                                                        \
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
                    $(if ($(PRELOAD)!=""), -DPRELOAD=1,)                                                         \
                    $(if $(PROFILE),--stats --stats-vars --profile-cfuncs,)                                      \
                    $(if $(DEBUG), --trace-structs,)                                                             \
                    $(if $(TRACE_COMPACT), --trace-fst $(VL_INC_DIR)/verilated_fst_c.cpp)                        \
                    $(if $(TRACE_FAST), --trace $(VL_INC_DIR)/verilated_vcd_c.cpp)                               \
                    -LDFLAGS "-L$(RISCV)/lib -L$(SPIKE_INSTALL_DIR)/lib -Wl,-rpath,$(RISCV)/lib -Wl,-rpath,$(SPIKE_INSTALL_DIR)/lib -lfesvr -lriscv -ldisasm -lyaml-cpp $(if $(PROFILE), -g -pg,) -lpthread $(if $(TRACE_COMPACT), -lz,)" \
                    -CFLAGS "$(CFLAGS)$(if $(PROFILE), -g -pg,) -DVL_DEBUG -I$(SPIKE_INSTALL_DIR)"               \
                    $(if $(SPIKE_TANDEM), +define+SPIKE_TANDEM, )                                                \
                    --cc --vpi                                                                                   \
                    $(list_incdir) --top-module ariane_testharness                                               \
                    --threads-dpi none                                                                           \
                    --Mdir $(ver-library) -O3                                                                    \
                    --exe corev_apu/tb/ariane_tb.cpp corev_apu/tb/dpi/SimDTM.cc corev_apu/tb/dpi/SimJTAG.cc      \
                    corev_apu/tb/dpi/remote_bitbang.cc corev_apu/tb/dpi/msim_helper.cc

# User Verilator, at some point in the future this will be auto-generated
verilate:
	@echo "[Verilator] Building Model$(if $(PROFILE), for Profiling,)"
	$(verilate_command)
	cd $(ver-library) && $(MAKE) -j${NUM_JOBS} -f Variane_testharness.mk

sim-verilator: verilate
	$(ver-library)/Variane_testharness $(elf_file)

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
	$(VSIM) +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles)+UVM_TESTNAME=$(test_case)                                  \
	+BASEDIR=$(riscv-torture-dir) $(uvm-flags) +jtag_rbb_enable=0 -gblso $(SPIKE_INSTALL_DIR)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi                                      \
	${top_level}_optimized +permissive-off +signature=$(riscv-torture-dir)/$(test-location).rtlsim.sig ++$(riscv-torture-dir)/$(test-location) ++$(target-options)

run-torture-log: build
	$(VSIM) +permissive $(questa-flags) $(questa-cmd) -lib $(library) +max-cycles=$(max_cycles)+UVM_TESTNAME=$(test_case)                                  \
	+BASEDIR=$(riscv-torture-dir) $(uvm-flags) +jtag_rbb_enable=0 -gblso $(SPIKE_INSTALL_DIR)/lib/libfesvr.so -sv_lib $(dpi-library)/ariane_dpi                                      \
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

src_flist = $(shell \
	    CVA6_REPO_DIR=$(CVA6_REPO_DIR) \
	    TARGET_CFG=$(TARGET_CFG) \
	    HPDCACHE_DIR=$(HPDCACHE_DIR) \
	    python3 util/flist_flattener.py core/Flist.cva6)
fpga_filter := $(addprefix $(root-dir), corev_apu/bootrom/bootrom.sv)
fpga_filter += $(addprefix $(root-dir), core/include/instr_tracer_pkg.sv)
fpga_filter += $(addprefix $(root-dir), src/util/ex_trace_item.sv)
fpga_filter += $(addprefix $(root-dir), src/util/instr_trace_item.sv)
fpga_filter += $(addprefix $(root-dir), common/local/util/instr_tracer.sv)
fpga_filter += $(addprefix $(root-dir), vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv)
fpga_filter += $(addprefix $(root-dir), common/local/util/tc_sram_wrapper.sv)
fpga_filter += $(addprefix $(root-dir), corev_apu/tb/ariane_peripherals.sv)
fpga_filter += $(addprefix $(root-dir), corev_apu/tb/ariane_testharness.sv)
fpga_filter += $(addprefix $(root-dir), core/cache_subsystem/hpdcache/rtl/src/common/macros/behav/hpdcache_sram_1rw.sv)
fpga_filter += $(addprefix $(root-dir), core/cache_subsystem/hpdcache/rtl/src/common/macros/behav/hpdcache_sram_wbyteenable_1rw.sv)
fpga_filter += $(addprefix $(root-dir), core/cache_subsystem/hpdcache/rtl/src/common/macros/behav/hpdcache_sram_wmask_1rw.sv)

src/bootrom/bootrom_$(XLEN).sv:
	$(MAKE) -C corev_apu/fpga/src/bootrom BOARD=$(BOARD) XLEN=$(XLEN) PLATFORM=$(PLATFORM) bootrom_$(XLEN).sv

fpga: $(ariane_pkg) $(src) $(fpga_src) $(uart_src) $(src_flist)
	@echo "[FPGA] Generate sources"
	@echo read_vhdl        {$(uart_src)}    > corev_apu/fpga/scripts/add_sources.tcl
	@echo read_verilog -sv {$(ariane_pkg)} >> corev_apu/fpga/scripts/add_sources.tcl
	@echo read_verilog -sv {$(filter-out $(fpga_filter), $(src_flist))}		>> corev_apu/fpga/scripts/add_sources.tcl
	@echo read_verilog -sv {$(filter-out $(fpga_filter), $(src))} 	   >> corev_apu/fpga/scripts/add_sources.tcl
	@echo read_verilog -sv {$(fpga_src)}   >> corev_apu/fpga/scripts/add_sources.tcl
	@echo "[FPGA] Generate Bitstream"
	$(MAKE) -C corev_apu/fpga BOARD=$(BOARD) XILINX_PART=$(XILINX_PART) XILINX_BOARD=$(XILINX_BOARD) CLK_PERIOD_NS=$(CLK_PERIOD_NS)

altera: PLATFORM := "PLAT_AGILEX"

altera: $(ariane_pkg) $(src) $(fpga_src) $(src_flist)
	@echo "[FPGA] Generate sources"
	@echo $(ariane_pkg) > corev_apu/altera/sourcelist.txt
	@echo $(filter-out $(fpga_filter), $(src_flist))		>> corev_apu/altera/sourcelist.txt
	@echo $(filter-out $(fpga_filter) $(altera_filter), $(src)) 	   >> corev_apu/altera/sourcelist.txt
	@echo $(filter-out $(altera_filter), $(fpga_src))		 >> corev_apu/altera/sourcelist.txt
	@echo $(filter-out $(fpga_filter) $(altera_filter) $(uart_src_sv), $(altera_src))   >> corev_apu/altera/sourcelist.txt
	@echo $(filter-out $(fpga_filter) $(altera_filter), $(altera_axi_src))   >> corev_apu/altera/sourcelist.txt
	@echo "[FPGA] Generate Bitstream"
	$(MAKE) -C corev_apu/altera ALTERA_PART=$(ALTERA_PART) ALTERA_BOARD=$(ALTERA_BOARD) CLK_PERIOD_NS=$(CLK_PERIOD_NS)

.PHONY: fpga

build-spike:
	cd tb/riscv-isa-sim && mkdir -p build && cd build && ../configure --prefix=`pwd`/../install --with-fesvr=$(RISCV) --enable-commitlog && make -j8 install

clean:
	rm -rf $(riscv-torture-dir)/output/test*
	rm -rf $(library)/ $(dpi-library)/ $(ver-library)/ $(vcs-library)/
	rm -f tmp/*.ucdb tmp/*.log *.wlf *vstf wlft* *.ucdb
	$(MAKE) -C corev_apu/fpga clean
	$(MAKE) -C corev_apu/fpga/src/bootrom BOARD=$(BOARD) XLEN=$(XLEN) clean

clean-altera: clean
	$(MAKE) -C corev_apu/altera clean

.PHONY:
	build sim sim-verilate clean                                              \
	$(riscv-asm-tests) $(addsuffix _verilator,$(riscv-asm-tests))             \
	$(riscv-benchmarks) $(addsuffix _verilator,$(riscv-benchmarks))           \
	check-benchmarks check-asm-tests                                          \
	torture-gen torture-itest torture-rtest                                   \
	run-torture run-torture-verilator check-torture check-torture-verilator
