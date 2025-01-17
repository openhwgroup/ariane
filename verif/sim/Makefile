# Copyright 2021 Thales DIS design services SAS
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https://solderpad.org/licenses/
#
# Original Author: Jean-Roch COULON - Thales

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
root-dir    := $(dir $(mkfile_path))

ifndef CVA6_REPO_DIR
$(warning must set CVA6_REPO_DIR to point at the root of CVA6 sources and CVA6_TB_DIR to point here -- doing it for you...)
export CVA6_REPO_DIR = $(abspath $(root-dir)../..)
export CVA6_TB_DIR   = $(root-dir)/../tb/core
export CORE_V_VERIF  = $(root-dir)/../core-v-verif
endif
ifndef TARGET_CFG
export TARGET_CFG = $(target)
endif

HPDCACHE_DIR ?= $(CVA6_REPO_DIR)/core/cache_subsystem/hpdcache
export HPDCACHE_DIR
HPDCACHE_TARGET_CFG ?= ${CVA6_REPO_DIR}/core/include/cva6_hpdcache_default_config_pkg.sv
export HPDCACHE_TARGET_CFG

.DEFAULT_GOAL := help

FLIST_TB   := $(CVA6_TB_DIR)/Flist.cva6_tb

# target takes one of the following cva6 hardware configuration:
# cv64a6_imafdc_sv39, cv32a6_imac_sv0, cv32a6_imac_sv32, cv32a6_imafc_sv32
target     ?= cv64a6_imafdc_sv39
FLIST_CORE = $(if $(gate),$(CVA6_REPO_DIR)/core/Flist.cva6_gate,$(CVA6_REPO_DIR)/core/Flist.cva6)
th_top_level      := $(if $(gate),ariane_gate_tb,ariane_tb)
do_file           := $(if $(gate),init_gate,init_testharness)
TRACE_FAST      ?=
TRACE_COMPACT   ?=
VERDI           ?=
path-var        ?=
tool_path       ?=
isscomp_opts    ?=
issrun_opts     ?=
isspostrun_opts ?=
log             ?=
variant         ?=
priv            ?=

# Spike tandem mode: default to environment setting (DISABLED if envariable SPIKE_TANDEM is not set).
export spike-tandem ?= $(SPIKE_TANDEM)

# Set Spike step count limit if the caller provided a step count value in variable 'steps'.
ifneq ($(steps),)
  spike_stepout = --steps=$(steps)
endif

##############################################
# Set up Spike configuration files
##############################################

# Set default Spike parameter file.
spike_yaml ?= $(CVA6_REPO_DIR)/config/gen_from_riscv_config/$(target)/spike/spike.yaml

# Set up flags for Spike solo and tandem invocations, but only if parameter file exists.
spike_params_final = $(spike_params)
ifneq ($(wildcard $(spike_yaml)),)
  spike_params_final := $(spike_params_final) --param-file $(spike_yaml)
  spike-yaml-plusarg = +config_file=$(spike_yaml)
  spike-yaml-makearg = config_file=$(spike_yaml)
else
  spike_params_final := $(spike_params_final) --extension=cvxif
endif

##############################################
# Waveform configuration
##############################################

# TRACE_FAST, TRACE_COMPACT and VERDI are mutually exclusive and imply non-empty DEBUG.
ifneq ($(TRACE_FAST),)
ifneq ($(TRACE_COMPACT),)
$(error Variables TRACE_FAST and TRACE_COMPACT are mutually exclusive, please unset one of them)
endif
ifneq ($(VERDI),)
$(error Variables TRACE_FAST and VERDI are mutually exclusive, please unset one of them)
endif
DEBUG=1
endif

ifneq ($(TRACE_COMPACT),)
ifneq ($(TRACE_FAST),)
$(error Variables TRACE_COMPACT and TRACE_FAST are mutually exclusive, please unset one of them)
endif
ifneq ($(VERDI),)
$(error Variables TRACE_COMPACT and VERDI are mutually exclusive, please unset one of them)
endif
DEBUG=1
endif

ifneq ($(VERDI),)
ifneq ($(TRACE_COMPACT),)
$(error Variables VERDI and TRACE_COMPACT are mutually exclusive, please unset one of them)
endif
ifneq ($(TRACE_FAST),)
$(error Variables VERDI and TRACE_FAST are mutually exclusive, please unset one of them)
endif
DEBUG=1
endif

# Make these variables available to sub-Makefiles.
export DEBUG TRACE_FAST TRACE_COMPACT

TESTNAME := $(shell basename -s .o $(elf))

ifeq ($(isspostrun_opts), "")
grep_address:
	grep $(isspostrun_opts) ./trace_rvfi_hart_00.dasm
else
grep_address:
endif

#######################################################################################
#                   Code Coverage
#######################################################################################
#code coverage is deactivated by default
#To activate the code coverage: define the env variable cov with: (export cov=value) , to deactivate it: (unset cov) OR (export cov= )
cov-exclude-list ?= $(root-dir)/cov-exclude-mod.lst

ifdef cov
	cov-comp-opt = -cm line+cond+tgl -cm_hier $(cov-exclude-list)
	cov-run-opt  = -cm line+cond+tgl -cm_name $(TESTNAME)
else
	cov-comp-opt =
	cov-run-opt  =
endif

###############################################################################
# Spike specific commands, variables
###############################################################################
spike:
	LD_LIBRARY_PATH="$$(realpath ../../tools/spike/lib):$$LD_LIBRARY_PATH" \
		$(tool_path)/spike $(spike_stepout) $(spike_extension) --log-commits --isa=$(variant) --priv=$(priv) $(spike_params_final) -l $(elf)
	grep -v '^\([[]\|/top/\)' $(log).iss > $(log)

###############################################################################
# UVM specific commands, variables
###############################################################################
VCS_WORK_DIR            = $(CVA6_REPO_DIR)/verif/sim/vcs_results/default/vcs.d
VSIM_WORK_DIR           = $(CVA6_REPO_DIR)/verif/sim/vsim_results/default/vsim.d
XRUN_WORK_DIR           = $(CVA6_REPO_DIR)/verif/sim/xrun_results

export CVA6_UVMT_DIR          = $(CVA6_REPO_DIR)/verif/tb/uvmt
export CVA6_CORET_DIR          = $(CVA6_REPO_DIR)/verif/tb/core
export CVA6_UVMT_PATH         = $(CVA6_REPO_DIR)/verif/tb/uvmt
export CVA6_UVME_PATH         = $(CVA6_REPO_DIR)/verif/env/uvme
export CV_CORE_LC             = cva6
export CV_CORE_UC             = CVA6
export DV_UVMT_PATH           = $(CVA6_REPO_DIR)/verif/tb/uvmt
export DV_UVME_PATH           = $(CVA6_REPO_DIR)/verif/env/uvme
export DV_UVML_HRTBT_PATH     = $(CORE_V_VERIF)/lib/uvm_libs/uvml_hrtbt
export DV_UVMA_CORE_CNTRL_PATH = $(CORE_V_VERIF)/lib/uvm_agents/uvma_core_cntrl
export DV_UVMA_RVFI_PATH      = $(CORE_V_VERIF)/lib/uvm_agents/uvma_rvfi
export DV_UVMA_ISACOV_PATH    = $(CORE_V_VERIF)/lib/uvm_agents/uvma_isacov
export DV_UVMA_CLKNRST_PATH   = $(CORE_V_VERIF)/lib/uvm_agents/uvma_clknrst
export DV_UVMA_AXI_PATH       = $(CORE_V_VERIF)/lib/uvm_agents/uvma_axi5
export DV_UVMA_CVXIF_PATH     = $(CORE_V_VERIF)/lib/uvm_agents/uvma_cvxif
export DV_UVMA_INTERRUPT_PATH = $(DV_UVME_PATH)/uvma_interrupt
export DV_UVMA_DEBUG_PATH     = $(CORE_V_VERIF)/lib/uvm_agents/uvma_debug
export DV_UVMA_OBI_PATH       = $(CORE_V_VERIF)/lib/uvm_agents/uvma_obi
export DV_UVMC_RVFI_SCOREBOARD_PATH      = $(CORE_V_VERIF)/lib/uvm_components/uvmc_rvfi_scoreboard/
export DV_UVMC_RVFI_REFERENCE_MODEL_PATH = $(CORE_V_VERIF)/lib/uvm_components/uvmc_rvfi_reference_model/
export DV_UVML_TRN_PATH       = $(CORE_V_VERIF)/lib/uvm_libs/uvml_trn
export DV_UVML_MEM_PATH       = $(CORE_V_VERIF)/lib/uvm_libs/uvml_mem
export DV_UVML_LOGS_PATH      = $(CORE_V_VERIF)/lib/uvm_libs/uvml_logs
export DV_UVML_SB_PATH        = $(CORE_V_VERIF)/lib/uvm_libs/uvml_sb
export CV_CORE_PKG            = $(CORE_V_VERIF)/core-v-cores/$(CV_CORE_LC)
export DESIGN_RTL_DIR         = $(CV_CORE_PKG)/rtl

export TBSRC_HOME             = $(CVA6_REPO_DIR)/verif/tb
export DV_OVPM_HOME           = $(CORE_V_VERIF)/$(CV_CORE_LC)/vendor_lib/imperas
export DV_OVPM_MODEL          = $(DV_OVPM_HOME)/riscv_$(CV_CORE_UC)_OVPsim
export DV_OVPM_DESIGN         = $(DV_OVPM_HOME)/design

export SPIKE_PATH = $(CORE_V_VERIF)/vendor/riscv/riscv-isa-sim/

COMMON_COMP_UVM_FLAGS = \
	  +incdir+$(CVA6_REPO_DIR)/verif/env/uvme +incdir+$(CVA6_REPO_DIR)/verif/tb/uvmt \
	  +core_name=$(target) \
	  $(if $(spike-tandem), +define+SPIKE_TANDEM=1)

COMMON_PLUS_ARGS = \
	++$(elf) \
	+elf_file=$(elf) \
	+core_name=$(target) \
        $(spike-yaml-plusarg) \
	+tohost_addr=$(shell $$RISCV/bin/$(CV_SW_PREFIX)nm -B $(elf) | grep -w tohost | cut -d' ' -f1) \
	+signature=$(elf).signature_output +UVM_TESTNAME=uvmt_cva6_firmware_test_c \
	+report_file=$(log).yaml +core_name=$(target)

ifneq ($(UVM_VERBOSITY),)
COMMON_PLUS_ARGS += +UVM_VERBOSITY=$(UVM_VERBOSITY)
endif

# Libraries that provide symbols for other libs must come first.
COMMON_RUN_ARGS = \
	$(COMMON_PLUS_ARGS) $(issrun_opts) \
	-sv_lib $(SPIKE_INSTALL_DIR)/lib/libcustomext \
	-sv_lib $(SPIKE_INSTALL_DIR)/lib/libyaml-cpp \
	-sv_lib $(SPIKE_INSTALL_DIR)/lib/libriscv \
	-sv_lib $(SPIKE_INSTALL_DIR)/lib/libfesvr \
	-sv_lib $(SPIKE_INSTALL_DIR)/lib/libdisasm

ALL_UVM_FLAGS   = -lca -sverilog +incdir+$(VCS_HOME)/etc/uvm/src \
	  $(VCS_HOME)/etc/uvm/src/uvm_pkg.sv -ntb_opts uvm-1.2 -timescale=1ns/1ps \
	  -assert svaext -race=all -ignore unique_checks -full64 -q +incdir+$(VCS_HOME)/etc/uvm/src \
	  $(if $(DEBUG), -debug_access+all $(if $(VERDI), -kdb) $(if $(TRACE_COMPACT),+vcs+fsdbon)) \
	  -cm_seqnoconst -diag noconst -cm_cond arith \

ALL_SIMV_UVM_FLAGS      = +vcs+lic+wait $(issrun_opts) \

ALL_XRUN_UVM_FLAGS      = -elaborate -messages -sv +incdir+$(XCELIUM_HOME)/tools.lnx86/methodology/UVM/CDNS-1.2/sv/src/ \
	  $(XCELIUM_HOME)/tools.lnx86/methodology/UVM/CDNS-1.2/sv/src/uvm_pkg.sv +UVM_VERBOSITY=UVM_LOW -uvm -uvmhome CDNS-1.2 \
	  -64 +incdir+$(XCELIUM_HOME)/tools.lnx86/methodology/UVM/CDNS-1.2/sv/src \
	  +incdir+$(CVA6_REPO_DIR)/verif/env/uvme +incdir+$(CVA6_REPO_DIR)/verif/tb/uvmt \
	  -xmerror CUNOTB -nowarn CUDEFB -nowarn CUSRCH -warn_multiple_driver -relax_svbtis -timescale 1ns/1ps -status -access +rwc -log   $(XRUN_WORK_DIR)/tb_compile.log

ALL_XRUN_SIMV_UVM_FLAGS      =  +sv_lib=$(CVA6_REPO_DIR)/tools/spike/lib/libdisasm +signature=I-ADD-01.signature_output

XRUN_RUN_FLAGS := -R -messages -status -64bit -licqueue -noupdate -log xrun.log -uvmhome CDNS-1.2  +UVM_VERBOSITY=UVM_LOW -svseed 1

XRUN_DISABLED_WARNINGS := BIGWIX 	\
                        ZROMCW 		\
			STRINT 		\
			ENUMERR 	\
			SPDUSD		\
			RNDXCELON

XRUN_DISABLED_WARNINGS 	:= $(patsubst %, -nowarn %, $(XRUN_DISABLED_WARNINGS))

XRUN_RUN = $(XRUN_RUN_FLAGS) 		\
	   $(ALL_XRUN_SIMV_UVM_FLAGS)	\
	   $(XRUN_DISABLED_WARNINGS)

ifneq ($(DEBUG),)               # If RTL DEBUG support requested
  ifneq ($(VERDI),)             #   If VERDI interactive mode requested, use GUI and do not run simulation
  ALL_SIMV_UVM_FLAGS       += \
                 -gui -do $(CVA6_REPO_DIR)/verif/sim/init_uvm.do
  else                          #   else: *not* VERDI, use CLI mode and appropriate batch dump controls
    ifneq ($(TRACE_FAST),)      #     TRACE_FAST: Generate waveform trace in VPD format
      ALL_SIMV_UVM_FLAGS   += \
                 -ucli -do $(CVA6_REPO_DIR)/verif/sim/init_run_uvm_vpd.do
      SIMV_TRACE_EXTN      = vpd
    endif
    ifneq ($(TRACE_COMPACT),)   #     TRACE_COMPACT: Generate waveform trace in FSDB format
      ALL_SIMV_UVM_FLAGS   += \
                 -ucli -do $(CVA6_REPO_DIR)/verif/sim/init_run_uvm_fsdb.do
      SIMV_TRACE_EXTN      = fsdb
    endif
  endif
endif

ifneq ($(SPIKE_TANDEM),)
ALL_SIMV_UVM_FLAGS += +tandem_enabled=1
ALL_XRUN_SIMV_UVM_FLAGS += +tandem_enabled=1
else
ALL_SIMV_UVM_FLAGS += +tandem_enabled=0
ALL_XRUN_SIMV_UVM_FLAGS += +tandem_enabled=0
endif

### VCS UVM rules
vcs_uvm_comp:
	@echo "[VCS] Building Model"
	mkdir -p $(VCS_WORK_DIR)
	cd $(VCS_WORK_DIR) && vcs $(COMMON_COMP_UVM_FLAGS) $(ALL_UVM_FLAGS) \
	  -f $(FLIST_CORE) -f $(FLIST_TB) \
	  -f $(CVA6_UVMT_DIR)/uvmt_cva6.flist \
	  $(cov-comp-opt) $(isscomp_opts)\
	  -ignore initializer_driver_checks \
	  -top uvmt_cva6_tb \
	  $(if $(gate), -sdf Max:uvmt_cva6_tb.cva6_dut_wrap.cva6_tb_wrapper_i.i_cva6:$(CVA6_REPO_DIR)/pd/synth/cva6_$(TARGET_CFG)_synth.sdf +neg_tchk, +notimingcheck)

vcs_uvm_run: vcs_uvm_comp
	$(if $(TRACE_FAST), unset VERDI_HOME ;) \
	cd $(VCS_WORK_DIR)/ && \
	$(VCS_WORK_DIR)/simv \
	    $(COMMON_RUN_ARGS) \
	    $(ALL_SIMV_UVM_FLAGS) \
	    $(cov-run-opt) $(issrun_opts)

vcs-uvm: vcs_uvm_comp vcs_uvm_run
	# If present, move default waveform files to log directory.
	# Keep track of target in waveform file name.
	[ ! -f $(VCS_WORK_DIR)/novas.vpd  ] || \
	  mv $(VCS_WORK_DIR)/novas.vpd  `dirname $(log)`/`basename $(log) .log`.vpd
	[ ! -f $(VCS_WORK_DIR)/novas.fsdb ] || \
	  mv $(VCS_WORK_DIR)/novas.fsdb `dirname $(log)`/`basename $(log) .log`.fsdb
	# Generate disassembled log.
	$(tool_path)/spike-dasm --isa=$(variant) < ./vcs_results/default/vcs.d/trace_rvfi_hart_00.dasm > $(log)


### XRUN UVM rules
xrun_uvm_comp:
	@echo "[XRUN] Building Model"
	mkdir -p $(XRUN_WORK_DIR)
	cd $(XRUN_WORK_DIR) && \
          xrun $(ALL_XRUN_UVM_FLAGS) \
          -f $(FLIST_CORE) \
          -f $(FLIST_TB) \
          -f $(CVA6_UVMT_PATH)/uvmt_cva6.flist \
          $(cov-comp-opt) $(isscomp_opts)\
	  -top uvmt_cva6_tb

# Libraries that provide symbols for other libs must come first.
xrun_uvm_run:
	@echo "[XRUN] Running"
	cd $(XRUN_WORK_DIR) && 	\
	  xrun 			\
	  $(XRUN_RUN)			\
	  +sv_lib=$(SPIKE_INSTALL_DIR)/lib/libyaml-cpp \
	  +sv_lib=$(SPIKE_INSTALL_DIR)/lib/libriscv \
	  +sv_lib=$(SPIKE_INSTALL_DIR)/lib/libfesvr \
	  +sv_lib=$(SPIKE_INSTALL_DIR)/lib/libdisasm \
	  ++$(elf) \
	  +elf_file=$(elf) \
          +define+UVM_NO_DEPRECATED  \
	  +UVM_TESTNAME=uvmt_cva6_firmware_test_c	\
	  +tohost_addr=$(shell ${RISCV}/bin/${CV_SW_PREFIX}nm -B $(elf) | grep -w tohost | cut -d' ' -f1)          \
	  $(cov-comp-opt) $(issrun_opts)


xrun-uvm: xrun_uvm_comp xrun_uvm_run
	$(tool_path)/spike-dasm --isa=$(variant) < ./xrun_results/trace_rvfi_hart_00.dasm > $(log)


### QUESTA UVM rules
questa_uvm_comp:
	@echo "[QUESTA] Building Model"
	mkdir -p $(VSIM_WORK_DIR)
	vlib $(VSIM_WORK_DIR)
	vlog -sv -sv17compat -64 $(COMMON_COMP_UVM_FLAGS) \
	  +incdir+$(QUESTASIM_HOME)/verilog_src/uvm-1.2/src/ \
	  $(QUESTASIM_HOME)/verilog_src/uvm-1.2/src/uvm_pkg.sv \
	  -timescale "1ns / 1ns" +acc=+rb \
	   -incr -64 -nologo -quiet -permissive -svinputport=compat -pedanticerror \
	   -compat \
	  +jtag_rbb_enable=0 \
	  -work $(VSIM_WORK_DIR) \
	  -f $(FLIST_CORE) -f $(FLIST_TB) \
	  -f $(CVA6_UVMT_DIR)/uvmt_cva6.flist \
	  -suppress vlog-2745 -suppress vlog-8386 \
	  -suppress vlog-8607 \
	  +define+UNSUPPORTED_WITH+ \
	  +define+QUESTA+ \
	  $(cov-comp-opt) $(isscomp_opts)
	vopt -work $(VSIM_WORK_DIR) \
	    -64 +acc uvmt_cva6_tb -o uvmt_cva6_tb_opt

questa_uvm_run:
	@echo "[QUESTA] Running Model"
	vsim -64  \
	  $(COMMON_RUN_UVM_FLAGS) \
	  -sv_lib $(QUESTASIM_HOME)/uvm-1.2/linux_x86_64/uvm_dpi \
	  -c -do "run -all; " \
	  -work $(VSIM_WORK_DIR) -t 1ns \
	  -suppress vsim-8451 \
	  -suppress 3829 -suppress vsim-8386\
	  +permissive \
	  -sv_seed 0 \
	  $(cov-run-opt) $(issrun_opts) \
	  +define+UNSUPPORTED_WITH+ \
	  uvmt_cva6_tb_opt

	# TODO: Add support for waveform collection.
	#$(tool_path)/spike-dasm --isa=$(variant) < $(path_var)/trace_rvfi_hart_00.dasm > $(log)
	#grep $(isspostrun_opts) $(path_var)/trace_rvfi_hart_00.dasm

questa-uvm:
	make questa_uvm_comp
	make questa_uvm_run


generate_cov_dash:
	urg -warn none -hvp_proj cva6_embedded -format both -group instcov_for_score -hvp_attributes weight+description+Comment -dir vcs_results/default/vcs.d/simv.vdb -plan cva6.hvp -tgl portsonly

vcs_clean_all:
	@echo "[VCS] Cleanup (entire vcs_work dir)"
	rm -rf $(CVA6_REPO_DIR)/verif/sim/vcs_results/ verdiLog/ simv* *.daidir *.vpd *.fsdb *.db csrc ucli.key vc_hdrs.h novas* inter.fsdb uart

xrun_clean_all:
	@echo "[XRUN] Cleanup (entire xrun_work dir)"
	rm -rf $(CVA6_REPO_DIR)/verif/sim/xrun_results/


###############################################################################
# testharness specific commands, variables
###############################################################################
vcs-testharness:
	make -C $(path_var) vcs_build target=$(target) gate=$(gate) top_level=$(th_top_level) flist=$(FLIST_CORE) defines=$(subst +define+,,$(isscomp_opts))$(if $(spike-tandem),SPIKE_TANDEM=1)
	$(path_var)/work-vcs/simv $(if $(VERDI), -verdi -do $(path_var)/util/$(do_file).do,) +permissive \
	    +permissive-off $(COMMON_RUN_ARGS)
	# If present, move default waveform files to log directory.
	# Keep track of target in waveform file name.
	[ ! -f novas.vpd  ] || \
	  mv novas.vpd  `dirname $(log)`/`basename $(log) .log`.vpd
	[ ! -f novas.fsdb ] || \
	  mv novas.fsdb `dirname $(log)`/`basename $(log) .log`.fsdb
	# Generate disassembled log.
	$(tool_path)/spike-dasm --isa=$(variant) < ./trace_rvfi_hart_00.dasm > $(log)
	grep $(isspostrun_opts) ./trace_rvfi_hart_00.dasm

veri-testharness:
	make -C $(path_var) verilate verilator="verilator --no-timing" target=$(target) defines=$(subst +define+,,$(isscomp_opts))
	$(path_var)/work-ver/Variane_testharness $(if $(TRACE_COMPACT), -f verilator.fst) $(if $(TRACE_FAST), -v verilator.vcd) $(elf) $(issrun_opts) \
	  $(COMMON_PLUS_ARGS)
	# If present, move default waveform files to log directory.
	# Keep track of target in waveform file name.
	[ ! -f verilator.fst ] || mv verilator.fst `dirname $(log)`/`basename $(log) .log`.fst
	[ ! -f verilator.vcd ] || mv verilator.vcd `dirname $(log)`/`basename $(log) .log`.vcd
	# Generate disassembled log.
	$(tool_path)/spike-dasm --isa=$(variant) < ./trace_rvfi_hart_00.dasm > $(log)
	grep $(isspostrun_opts) ./trace_rvfi_hart_00.dasm

xrun-testharness:
	@echo "[XRUN-TESTHARNESS] Running"
	@echo "[XRUN-TESTHARNESS] $(path_var)"
	@echo "[XRUN-TESTHARNESS] $(XRUN_WORK_DIR)"
	@echo "[XRUN-TESTHARNESS] $(elf)"
	mkdir -p $(XRUN_WORK_DIR)
	make -C $(path_var) work-dpi/xrun_ariane_dpi.so
	@echo "[XRUN-TESTHARNESS] $(elf)"
	make -C $(path_var) xrun_sim target=$(target) defines=$(subst +define+,,$(isscomp_opts))$(if $(spike-tandem),SPIKE_TANDEM=1)
	@echo "[XRUN-TESTHARNESS1] $(elf)"
	$(CVA6_REPO_DIR)/tools/spike/spike-dasm --isa=$(variant) < ./xrun_results/xcelium.d/trace_rvfi_hart_00.dasm > $(log)

questa-testharness:
	mkdir -p $(path_var)/tmp
	make -C $(path_var) sim target=$(target) defines=$(subst +define+,,$(isscomp_opts)+core_name=$(target)) batch-mode=1 elf_file=$(elf) \
	    report_file=$(log).yaml $(spike-yaml-makearg)
	# TODO: Add support for waveform collection.
	$(tool_path)/spike-dasm --isa=$(variant) < $(path_var)/trace_rvfi_hart_00.dasm > $(log)
	grep $(isspostrun_opts) $(path_var)/trace_rvfi_hart_00.dasm

###############################################################################
# Common targets and rules
###############################################################################

clean_all: vcs_clean_all
	rm -f *.txt
	rm -f trace*.log
	rm -f trace*.dasm
	rm -f *.vpd *.fsdb *.vcd *.fst

help:
	@echo "Shell environment:"
	@echo "   CVA6_REPO_DIR    : $(CVA6_REPO_DIR)"
	@echo "   CVA6_TB_DIR      : $(CVA6_TB_DIR)"
	@echo "VCS targets:"
	@echo "   make vcs_uvm_comp    : Compiles with VCS"
	@echo "   make vcs_uvm_run     : Runs with VCS"
	@echo "Clean-up targets:"
	@echo "   make clean_all   : Deletes ALL generated files"
	@echo "Support for other simulators on the ToDo list..."
