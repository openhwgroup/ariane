# Copyright 2024 Thales DIS design services SAS
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https://solderpad.org/licenses/
#
# Original Author: Jean-Roch COULON - Thales


# Where the tools are
if ! [ -n "$RISCV" ]; then
  echo "Error: RISCV variable undefined"
  return
fi

# Install the required tools
source ./verif/regress/install-verilator.sh
source ./verif/regress/install-spike.sh

# Install the required test suites
source ./verif/regress/install-riscv-compliance.sh
source ./verif/regress/install-riscv-tests.sh
source ./verif/regress/install-riscv-arch-test.sh

# Setup sim env
source ./verif/sim/setup-env.sh

echo "$SPIKE_INSTALL_DIR$"

if ! [ -n "$DV_SIMULATORS" ]; then
  # DV_SIMULATORS=vcs-testharness,spike
  # DV_SIMULATORS=vcs-uvm,spike
  # DV_SIMULATORS=xrun-uvm,spike
  # DV_SIMULATORS=vcs-testharness
  # DV_SIMULATORS=vcs-uvm
    DV_SIMULATORS=xrun-uvm
  # DV_SIMULATORS=spike
fi

if ! [ -n "$UVM_VERBOSITY" ]; then
    UVM_VERBOSITY=UVM_NONE
fi

SIMUENV_VCS_TESTHARNESS=`echo $DV_SIMULATORS | grep -c vcs-testharness`
SIMUENV_VCS_UVM=`echo $DV_SIMULATORS | grep -c vcs-uvm`
SIMUENV_XRUN_UVM=`echo $DV_SIMULATORS | grep -c xrun-uvm`
SIMULATOR_VCS=`echo $DV_SIMULATORS | grep -c vcs`
SIMULATOR_XRUN=`echo $DV_SIMULATORS | grep -c xrun`

export DV_OPTS="$DV_OPTS"
export DV_OPTS="$DV_OPTS --iss_timeout 0"
export DV_OPTS="$DV_OPTS --c_timeout 0 --asm_timeout 0 --elf_timeout 0"

if [ $SIMULATOR_VCS == 1 ]; then
    export ISSCOMP_OPTS="$ISSCOMP_OPTS -debug_access+r"
fi

export ISSRUN_OPTS="$ISSRUN_OPTS +debug_disable=1"
export ISSRUN_OPTS="$ISSRUN_OPTS +UVM_VERBOSITY=$UVM_VERBOSITY"

if [ $SIMULATOR_XRUN == 1 ]; then
    export ISSRUN_OPTS="$ISSRUN_OPTS -gui"
fi

export SPIKE_PARAMS="--help"

export DEBUG_FILE=""


# Select the test to run here:
  TEST_NUMBER="#1#"
# TEST_NUMBER="#2#"
# TEST_NUMBER="#3#"
# TEST_NUMBER="#4#"
# TEST_NUMBER="#5#"
# TEST_NUMBER="#6#"
# TEST_NUMBER="#7#"
# TEST_NUMBER="#8#"
# TEST_NUMBER="#9#"


TEST_TARGET="#cv32a65x#"

cd verif/sim/


# ------------------------------------------------------------------------------
#1# pmp_cv32a65x_granularity_test.S on cv32a65x

if [ $TEST_NUMBER == "#1#" ] ; then
    
    echo "running #1# pmp_cv32a65x_granularity_test.S on cv32a65x with $DV_SIMULATORS"
    
    python3 cva6.py \
            --target cv32a65x \
            --iss_yaml=cva6.yaml \
            --iss=$DV_SIMULATORS \
            --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_granularity_test.S \
            --uvm_test uvmt_cva6_pmp_test_c \
            --linker=../tests/custom/common/test.ld \
            --gcc_opts="-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
                        -g ../tests/custom/common/syscalls.c ../tests/custom/common/crt.S -lgcc \
                        -I../tests/custom/env -I../tests/custom/common" \
            $DV_OPTS \
            --debug="$DEBUG_FILE" \
            --spike_params="$SPIKE_PARAMS" \
            --issrun_opts="$ISSRUN_OPTS" \
            --isscomp_opts="$ISSCOMP_OPTS"

    make -C ../.. clean
    make clean_all
    
fi

# ------------------------------------------------------------------------------
#2# pmp_cv32a65x_exact_csrr_test.S on cv32a65x

if [ $TEST_NUMBER == "#2#" ] ; then
    
    echo "running #2# pmp_cv32a65x_exact_csrr_test.S on cv32a65x with $DV_SIMULATORS"
    
    python3 cva6.py \
            --target cv32a65x \
            --iss_yaml=cva6.yaml \
            --iss=$DV_SIMULATORS \
            --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_exact_csrr_test.S \
            --uvm_test uvmt_cva6_pmp_test_c \
            --linker=../tests/custom/common/test.ld \
            --gcc_opts="-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
                        -g ../tests/custom/common/syscalls.c ../tests/custom/common/crt.S -lgcc \
                        -I../tests/custom/env -I../tests/custom/common" \
            $DV_OPTS \
            --debug="$DEBUG_FILE" \
            --spike_params="$SPIKE_PARAMS" \
            --issrun_opts="$ISSRUN_OPTS" \
            --isscomp_opts="$ISSCOMP_OPTS"

    make -C ../.. clean
    make clean_all
    
fi

# ------------------------------------------------------------------------------
#3# pmp_cv32a65x_lsu_tor_test.S on cv32a65x

if [ $TEST_NUMBER == "#3#" ] ; then
    
    echo "running #3# pmp_cv32a65x_lsu_tor_test.S on cv32a65x with $DV_SIMULATORS"
    
    python3 cva6.py \
            --target cv32a65x \
            --iss_yaml=cva6.yaml \
            --iss=$DV_SIMULATORS \
            --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_lsu_tor_test.S \
            --uvm_test uvmt_cva6_pmp_test_c \
            --linker=../tests/custom/common/test.ld \
            --gcc_opts="-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
                        -g ../tests/custom/common/syscalls.c ../tests/custom/common/crt.S -lgcc \
                        -I../tests/custom/env -I../tests/custom/common" \
            $DV_OPTS \
            --debug="$DEBUG_FILE" \
            --spike_params="$SPIKE_PARAMS" \
            --issrun_opts="$ISSRUN_OPTS" \
            --isscomp_opts="$ISSCOMP_OPTS" 

    make -C ../.. clean
    make clean_all
    
fi

# ------------------------------------------------------------------------------
#4# pmp_cv32a65x_lsu_napot_test.S on cv32a65x

if [ $TEST_NUMBER == "#4#" ] ; then
    
    echo "running #4# pmp_cv32a65x_lsu_napot_test.S on cv32a65x with $DV_SIMULATORS"
    
    python3 cva6.py \
            --target cv32a65x \
            --iss_yaml=cva6.yaml \
            --iss=$DV_SIMULATORS \
            --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_lsu_napot_test.S \
            --uvm_test uvmt_cva6_pmp_test_c \
            --linker=../tests/custom/common/test.ld \
            --gcc_opts="-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
                        -g ../tests/custom/common/syscalls.c ../tests/custom/common/crt.S -lgcc \
                        -I../tests/custom/env -I../tests/custom/common" \
            $DV_OPTS \
            --debug="$DEBUG_FILE" \
            --spike_params="$SPIKE_PARAMS" \
            --issrun_opts="$ISSRUN_OPTS" \
            --isscomp_opts="$ISSCOMP_OPTS"

    make -C ../.. clean
    make clean_all
    
fi

# ------------------------------------------------------------------------------
#5# pmp_cv32a65x_decreasing_entries_test.S on cv32a65x

if [ $TEST_NUMBER == "#5#" ] ; then
    
    echo "running #5# pmp_cv32a65x_decreasing_entries_test.S on cv32a65x with $DV_SIMULATORS"
    
    python3 cva6.py \
            --target cv32a65x \
            --iss_yaml=cva6.yaml \
            --iss=$DV_SIMULATORS \
            --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_decreasing_entries_test.S \
            --uvm_test uvmt_cva6_pmp_test_c \
            --linker=../tests/custom/common/test.ld \
            --gcc_opts="-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
                        -g ../tests/custom/common/syscalls.c ../tests/custom/common/crt.S -lgcc \
                        -I../tests/custom/env -I../tests/custom/common" \
            $DV_OPTS \
            --debug="$DEBUG_FILE" \
            --spike_params="$SPIKE_PARAMS" \
            --issrun_opts="$ISSRUN_OPTS" \
            --isscomp_opts="$ISSCOMP_OPTS" 

    make -C ../.. clean
    make clean_all
    
fi

# ------------------------------------------------------------------------------
#6# pmp_cv32a65x_defined_matches_test.S on cv32a65x

if [ $TEST_NUMBER == "#6#" ] ; then
    
    echo "running #6# pmp_cv32a65x_defined_matches_test.S on cv32a65x with $DV_SIMULATORS"
    
    python3 cva6.py \
            --target cv32a65x \
            --iss_yaml=cva6.yaml \
            --iss=$DV_SIMULATORS \
            --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_defined_matches_test.S \
            --uvm_test uvmt_cva6_pmp_test_c \
            --linker=../tests/custom/common/test.ld \
            --gcc_opts="-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
                        -g ../tests/custom/common/syscalls.c ../tests/custom/common/crt.S -lgcc \
                        -I../tests/custom/env -I../tests/custom/common" \
            $DV_OPTS \
            --debug="$DEBUG_FILE" \
            --spike_params="$SPIKE_PARAMS" \
            --issrun_opts="$ISSRUN_OPTS" \
            --isscomp_opts="$ISSCOMP_OPTS" 

    make -C ../.. clean
    make clean_all
    
fi

# ------------------------------------------------------------------------------
#7# pmp_cv32a65x_double_entries_test.S on cv32a65x

if [ $TEST_NUMBER == "#7#" ] ; then
    
    echo "running #7# pmp_cv32a65x_double_entries_test.S on cv32a65x with $DV_SIMULATORS"
    
    python3 cva6.py \
            --target cv32a65x \
            --iss_yaml=cva6.yaml \
            --iss=$DV_SIMULATORS \
            --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_double_entries_test.S \
            --uvm_test uvmt_cva6_pmp_test_c \
            --linker=../tests/custom/common/test.ld \
            --gcc_opts="-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
                        -g ../tests/custom/common/syscalls.c ../tests/custom/common/crt.S -lgcc \
                        -I../tests/custom/env -I../tests/custom/common" \
            $DV_OPTS \
            --debug="$DEBUG_FILE" \
            --spike_params="$SPIKE_PARAMS" \
            --issrun_opts="$ISSRUN_OPTS" \
            --isscomp_opts="$ISSCOMP_OPTS" 

    make -C ../.. clean
    make clean_all
    
fi

# ------------------------------------------------------------------------------
#8# pmp_cv32a65x_locked_outside_napot_test.S on cv32a65x

if [ $TEST_NUMBER == "#8#" ] ; then
    
    echo "running #8# pmp_cv32a65x_locked_outside_napot_test.S on cv32a65x with $DV_SIMULATORS"
    
    python3 cva6.py \
            --target cv32a65x \
            --iss_yaml=cva6.yaml \
            --iss=$DV_SIMULATORS \
            --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_locked_outside_napot_test.S \
            --uvm_test uvmt_cva6_pmp_test_c \
            --linker=../tests/custom/common/test.ld \
            --gcc_opts="-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
                        -g ../tests/custom/common/syscalls.c ../tests/custom/common/crt.S -lgcc \
                        -I../tests/custom/env -I../tests/custom/common" \
            $DV_OPTS \
            --debug="$DEBUG_FILE" \
            --spike_params="$SPIKE_PARAMS" \
            --issrun_opts="$ISSRUN_OPTS" \
            --isscomp_opts="$ISSCOMP_OPTS" 

    make -C ../.. clean
    make clean_all
    
fi

# ------------------------------------------------------------------------------
#9# pmp_cv32a65x_locked_outside_tor_test.S on cv32a65x

if [ $TEST_NUMBER == "#9#" ] ; then
    
    echo "running #9# pmp_cv32a65x_locked_outside_tor_test.S on cv32a65x with $DV_SIMULATORS"
    
    python3 cva6.py \
            --target cv32a65x \
            --iss_yaml=cva6.yaml \
            --iss=$DV_SIMULATORS \
            --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_locked_outside_tor_test.S \
            --uvm_test uvmt_cva6_pmp_test_c \
            --linker=../tests/custom/common/test.ld \
            --gcc_opts="-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
                        -g ../tests/custom/common/syscalls.c ../tests/custom/common/crt.S -lgcc \
                        -I../tests/custom/env -I../tests/custom/common" \
            $DV_OPTS \
            --debug="$DEBUG_FILE" \
            --spike_params="$SPIKE_PARAMS" \
            --issrun_opts="$ISSRUN_OPTS" \
            --isscomp_opts="$ISSCOMP_OPTS" 

    make -C ../.. clean
    make clean_all
    
fi

cd -
