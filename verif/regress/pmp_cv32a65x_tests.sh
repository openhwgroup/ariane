##-----------------------------------------------------------------------------
## Copyright 2024 Robert Bosch GmbH
##
## SPDX-License-Identifier: SHL-0.51
##
## Original Author: Konstantinos Leventos - Robert Bosch France SAS
##-----------------------------------------------------------------------------


# Where the tools are
if ! [ -n "$RISCV" ]; then
  echo "Error: RISCV variable undefined"
  return
fi

# Install the required tools
source ./verif/regress/install-verilator.sh
source ./verif/regress/install-spike.sh

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
export DV_OPTS="$DV_OPTS --iss_timeout 2000"

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

TEST_TARGET="#cv32a65x#"

cd verif/sim/


# ------------------------------------------------------------------------------
#1# pmp_cv32a65x_granularity_test.S on cv32a65x

echo "running #1# pmp_cv32a65x_granularity_test.S on cv32a65x with $DV_SIMULATORS"

python3 cva6.py \
        --target cv32a65x \
        --iss_yaml=cva6.yaml \
        --iss=$DV_SIMULATORS \
        --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_granularity_test.S \
        --uvm_test uvmt_cva6_pmp_test_c \
        --linker=../../config/gen_from_riscv_config/cv32a65x/linker/link.ld \
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
    

# ------------------------------------------------------------------------------
#2# pmp_cv32a65x_exact_csrr_test.S on cv32a65x

echo "running #2# pmp_cv32a65x_exact_csrr_test.S on cv32a65x with $DV_SIMULATORS"

python3 cva6.py \
        --target cv32a65x \
        --iss_yaml=cva6.yaml \
        --iss=$DV_SIMULATORS \
        --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_exact_csrr_test.S \
        --uvm_test uvmt_cva6_pmp_test_c \
        --linker=../../config/gen_from_riscv_config/cv32a65x/linker/link.ld \
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
    
# ------------------------------------------------------------------------------
#3# pmp_cv32a65x_lsu_tor_test.S on cv32a65x

echo "running #3# pmp_cv32a65x_lsu_tor_test.S on cv32a65x with $DV_SIMULATORS"

python3 cva6.py \
        --target cv32a65x \
        --iss_yaml=cva6.yaml \
        --iss=$DV_SIMULATORS \
        --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_lsu_tor_test.S \
        --uvm_test uvmt_cva6_pmp_test_c \
        --linker=../../config/gen_from_riscv_config/cv32a65x/linker/link.ld \
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



# ------------------------------------------------------------------------------
#4# pmp_cv32a65x_lsu_napot_test.S on cv32a65x

echo "running #4# pmp_cv32a65x_lsu_napot_test.S on cv32a65x with $DV_SIMULATORS"

python3 cva6.py \
        --target cv32a65x \
        --iss_yaml=cva6.yaml \
        --iss=$DV_SIMULATORS \
        --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_lsu_napot_test.S \
        --uvm_test uvmt_cva6_pmp_test_c \
        --linker=../../config/gen_from_riscv_config/cv32a65x/linker/link.ld \
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



# ------------------------------------------------------------------------------
#5# pmp_cv32a65x_decreasing_entries_test.S on cv32a65x

echo "running #5# pmp_cv32a65x_decreasing_entries_test.S on cv32a65x with $DV_SIMULATORS"

python3 cva6.py \
        --target cv32a65x \
        --iss_yaml=cva6.yaml \
        --iss=$DV_SIMULATORS \
        --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_decreasing_entries_test.S \
        --uvm_test uvmt_cva6_pmp_test_c \
        --linker=../../config/gen_from_riscv_config/cv32a65x/linker/link.ld \
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

# ------------------------------------------------------------------------------
#6# pmp_cv32a65x_defined_matches_test.S on cv32a65x

echo "running #6# pmp_cv32a65x_defined_matches_test.S on cv32a65x with $DV_SIMULATORS"

python3 cva6.py \
        --target cv32a65x \
        --iss_yaml=cva6.yaml \
        --iss=$DV_SIMULATORS \
        --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_defined_matches_test.S \
        --uvm_test uvmt_cva6_pmp_test_c \
        --linker=../../config/gen_from_riscv_config/cv32a65x/linker/link.ld \
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



# ------------------------------------------------------------------------------
#7# pmp_cv32a65x_double_entries_test.S on cv32a65x

echo "running #7# pmp_cv32a65x_double_entries_test.S on cv32a65x with $DV_SIMULATORS"

python3 cva6.py \
        --target cv32a65x \
        --iss_yaml=cva6.yaml \
        --iss=$DV_SIMULATORS \
        --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_double_entries_test.S \
        --uvm_test uvmt_cva6_pmp_test_c \
        --linker=../../config/gen_from_riscv_config/cv32a65x/linker/link.ld \
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



# ------------------------------------------------------------------------------
#8# pmp_cv32a65x_locked_outside_napot_test.S on cv32a65x

echo "running #8# pmp_cv32a65x_locked_outside_napot_test.S on cv32a65x with $DV_SIMULATORS"

python3 cva6.py \
        --target cv32a65x \
        --iss_yaml=cva6.yaml \
        --iss=$DV_SIMULATORS \
        --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_locked_outside_napot_test.S \
        --uvm_test uvmt_cva6_pmp_test_c \
        --linker=../../config/gen_from_riscv_config/cv32a65x/linker/link.ld \
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

# ------------------------------------------------------------------------------
#9# pmp_cv32a65x_locked_outside_tor_test.S on cv32a65x

echo "running #9# pmp_cv32a65x_locked_outside_tor_test.S on cv32a65x with $DV_SIMULATORS"

python3 cva6.py \
        --target cv32a65x \
        --iss_yaml=cva6.yaml \
        --iss=$DV_SIMULATORS \
        --asm_tests ../tests/custom/pmp_cv32a65x/pmp_cv32a65x_locked_outside_tor_test.S \
        --uvm_test uvmt_cva6_pmp_test_c \
        --linker=../../config/gen_from_riscv_config/cv32a65x/linker/link.ld \
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



cd -
