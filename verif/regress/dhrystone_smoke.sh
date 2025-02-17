# Copyright 2022 Thales DIS design services SAS
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https://solderpad.org/licenses/
#
# Original Author: Zbigniew CHAMSKI (zbigniew.chamski@thalesgroup.fr)

# where are the tools
if ! [ -n "$RISCV" ]; then
  echo "Error: RISCV variable undefined"
  return
fi

if ! [ -n "$DV_SIMULATORS" ]; then
  DV_SIMULATORS=vcs-uvm
fi

if ! [ -n "$DV_TARGET" ]; then
  DV_TARGET=cv32a65x
fi

# install the required tools
if [[ "$DV_SIMULATORS" == *"veri-testharness"* ]]; then
  source ./verif/regress/install-verilator.sh
fi
source ./verif/regress/install-spike.sh

source ./verif/sim/setup-env.sh

make clean
make -C verif/sim clean_all

cd verif/sim

src0=../tests/custom/dhrystone/dhrystone_main.c
srcA=(
        ../tests/custom/dhrystone/dhrystone.c
        ../tests/custom/common/syscalls.c
        ../tests/custom/common/crt.S
)
cflags=(
        -fno-tree-loop-distribute-patterns
        -static
        -mcmodel=medany
        -fvisibility=hidden
        -nostdlib
        -nostartfiles
        -lgcc
        -Os --no-inline
        -Wno-implicit-function-declaration
        -Wno-implicit-int
        -I../tests/custom/env
        -I../tests/custom/common
        -I../tests/custom/dhrystone/
        -DNOPRINT
)

python3 cva6.py \
        --target $DV_TARGET \
        --iss="$DV_SIMULATORS" \
        --iss_yaml=cva6.yaml \
        --c_tests "$src0" \
        --sv_seed 1 \
        --gcc_opts "${srcA[*]} ${cflags[*]}"
