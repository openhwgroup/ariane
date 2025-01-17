# // Copyright (c) 2024 PlanV Technologies
# // SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
# // Copyright and related rights are licensed under the Solderpad Hardware
# // License, Version 0.51 (the "License"); you may not use this file except in
# // compliance with the License.  You may obtain a copy of the License at
# // http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# // or agreed to in writing, software, hardware and materials distributed under
# // this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# // CONDITIONS OF ANY KIND, either express or implied. See the License for the
# // specific language governing permissions and limitations under the License.

# // Description: Makefile for Altera project
# // Author: Mustafa Karadayi, PlanV Technology
###################################################################
# Project Configuration: 
# 
# Specify the name of the design (project) and the Quartus II
# Settings File (.qsf)
###################################################################

PROJECT =Example-Project##mkdigitals ask for project name
TOP_LEVEL_ENTITY = ####mkdigitals ask for the top level entity
ASSIGNMENT_FILES = $(PROJECT).qpf $(PROJECT).qsf
SOURCES_FILE = ./sourcelist.txt
# Define the output bitstream file
BITSTREAM := $(PROJECT).sof
###################################################################
# Part, Family, Boardfile DE1 or DE2
## FAMILY COMES FROM THE CALLING MAKEFILE
## PART COMES FROM THE CALLING MAKEFILE
## BOARDFILE COMES FROM THE CALLING MAKEFILE ## mkdigitals ask if there is a board file
###################################################################

###################################################################
# Setup your sources here
SRCS = $(shell cat $(SOURCES_FILE))

###################################################################
# Main Targets
#
# all: build everything
# clean: remove output files and database
# program: program your device with the compiled design
###################################################################

all: create_project \
	write_settings \
	write_loc_constraints \
	write_io_standard_constraints \
	write_ip_files \
	write_search_paths \
	write_source_files \
	write_timing_constraints \
	generate_ips \
	sta

clean:
	$(RM) -rf *.rpt *.chg smart.log *.htm *.eqn *.pin *.sof *.pof db incremental_db *.summary *.smsg *.jdi $(ASSIGNMENT_FILES)
# Capture the Quartus version
QUARTUS_VERSION := $(shell quartus_sh --version | grep -oP 'Version \K[0-9]+\.[0-9]+')
CURRENT_DATETIME := $(shell date +"%H:%M:%S  %B %d, %Y")
create_project:	
	@echo "Creating or regenerating $(PROJECT).qpf"
	@rm -f "$(PROJECT).qpf"
	@touch "$(PROJECT).qpf"
	@echo "QUARTUS_VERSION = \"$(QUARTUS_VERSION)\"" >> "$(PROJECT).qpf"
	@echo "DATE = \"$(CURRENT_DATETIME)\"" >> "$(PROJECT).qpf"
	@echo "PROJECT_REVISION = \"$(PROJECT)\"" >> "$(PROJECT).qpf"

	@echo "Creating or regenerating $(PROJECT).qsf"
	@rm -f "$(PROJECT).qsf"
	@touch "$(PROJECT).qsf"
	$(QSYS_PATH)qsys-script --script=ip/interconnect.tcl
	$(QSYS_PATH)qsys-generate interconnect.qsys --quartus_project=ip/interconnect --synthesis
	rm -f interconnect/*.v
	rm -f interconnect/*.vhd
	rm -f interconnect/synth/*.v

write_settings:
	@echo "Reading from settings.csv and writing to $(PROJECT).qsf with modifications"
	@while IFS= read -r line; do \
  	echo "set_global_assignment -name $$line" >> "$(PROJECT).qsf"; \
	done < settings.csv

write_loc_constraints:
	@echo "Reading from loc_constraints.csv and writing to $(PROJECT).qsf with modifications"
	@while IFS= read -r line; do \
  	echo "set_location_assignment $$line" >> "$(PROJECT).qsf"; \
	done < loc_constraints.csv

write_io_standard_constraints:
	@echo "Reading from io_standard_constraints.csv and writing to $(PROJECT).qsf with modifications"
	@while IFS= read -r line; do \
		echo "set_instance_assignment -name  $$line" >> "$(PROJECT).qsf"; \
	done < io_standard_constraints.csv

write_ip_files:
	@echo "Reading from ip_files.csv and writing to $(PROJECT).qsf with modifications"
	@while IFS= read -r line; do \
		echo "set_global_assignment -name IP_FILE $$line" >> "$(PROJECT).qsf"; \
	done < ip_files.csv

write_search_paths:
	@echo "Reading from search_paths.csv and writing to $(PROJECT).qsf with modifications"
	@while IFS= read -r line; do \
		echo "set_global_assignment -name SEARCH_PATH $$line" >> "$(PROJECT).qsf"; \
	done < search_paths.csv

write_source_files:
	@find ./interconnect -type f -name "*.v" -o -name "*.sv" -o -name "*.svh" >> $(SOURCES_FILE)
	@echo $(var)
	@echo >> $(SOURCES_FILE)
	@echo "Reading from $(SOURCES_FILE) and writing to $(PROJECT).qsf with modifications"
	@while IFS= read -r line; do \
		for word in $$line; do \
			if echo "$$word" | grep -q "\.vhd$$"; then \
				echo "set_global_assignment -name VHDL_FILE $$word" >> "$(PROJECT).qsf"; \
			elif echo "$$word" | grep -q "\.v$$"; then \
				echo "set_global_assignment -name VERILOG_FILE $$word" >> "$(PROJECT).qsf"; \
			elif echo "$$word" | grep -q "\.sv$$"; then \
				echo "set_global_assignment -name SYSTEMVERILOG_FILE $$word" >> "$(PROJECT).qsf"; \
			elif echo "$$word" | grep -q "\.svh$$"; then \
				echo "set_global_assignment -name SYSTEMVERILOG_FILE $$word" >> "$(PROJECT).qsf"; \
			else \
				echo "set_global_assignment -name SOURCE_FILE $$word" >> "$(PROJECT).qsf"; \
			fi; \
		done; \
	done < $(SOURCES_FILE)

write_timing_constraints:
	@echo "Generating constraints file list"
	find ./constraints -type f -name "*.sdc" -exec realpath {} \; | sed 's|^|set_global_assignment -name SDC_FILE |' >> "$(PROJECT).qsf" 

generate_ips:
	$(QSYS_PATH)qsys-script --script=ip/test_mm_ccb_0.tcl
	$(QSYS_PATH)qsys-script --script=ip/cva6_intel_jtag_uart_0.tcl
	$(QSYS_PATH)qsys-script --script=ip/ed_synth_emif_fm_0.tcl
	$(QSYS_PATH)qsys-script --script=ip/emif_cal.tcl
	$(QSYS_PATH)qsys-script --script=ip/iddr_intel.tcl
	$(QSYS_PATH)qsys-script --script=ip/io_pll.tcl
	$(QSYS_PATH)qsys-script --script=ip/iobuf.tcl
	$(QSYS_PATH)qsys-script --script=ip/oddr_intel.tcl
	$(QSYS_PATH)qsys-script --script=ip/vJTAG.tcl
	$(QUARTUS_PATH)quartus_ipgenerate --generate_project_ip_files $(PROJECT) 

map:
	@echo "Running Quartus Map"
	$(QUARTUS_PATH)quartus_syn $(PROJECT)

fit: map
	@echo "Running Quartus Fit"
	$(QUARTUS_PATH)quartus_fit $(PROJECT)

asm: fit
	@echo "Running Quartus Assembly"
	$(QUARTUS_PATH)quartus_asm $(PROJECT)

sta: asm
	@echo "Running Quartus Timing Analysis"
	$(QUARTUS_PATH)quartus_sta $(PROJECT) --do_report_timing

clean:
	@echo "Cleaning project files"
	rm -f $(PROJECT).qsf $(PROJECT).qpf $(PROJECT).map.rpt $(PROJECT).fit.rpt $(PROJECT).asm.rpt $(PROJECT).sta.rpt
	rm -f interconnect.qsys*
	rm -f *.backup
	rm -f *.hex
	rm -f *.txt
	rm -f *.ip
	rm -f ip/board.info
	rm -f ip/*.qpf
	rm -f ip/*.qsf
	rm -rf ip/dni
	rm -rf ip/.qsys_edit
	rm -rf ip/qdb
	rm -rf output_files
	rm -rf db incremental_db
	rm -rf qdb
	rm -rf tmp-clearbox
	rm -rf intel
	rm -rf dni
	rm -rf interconnect
	rm -rf ip/interconnect
	rm -rf cva6_intel_jtag_uart_0
	rm -rf ed_synth_emif_fm_0
	rm -rf emif_cal
	rm -rf iddr_intel
	rm -rf oddr_intel
	rm -rf test_mm_ccb_0
	rm -rf vJTAG
	rm -rf interconnect
	rm -rf io_pll
	rm -rf iobuf

	$(QUARTUS_PATH)quartus_ipgenerate --clean $(PROJECT) 

.PHONY: all write_search_paths write_source_files map fit asm sta clean