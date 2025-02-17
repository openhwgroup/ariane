# Copyright 2022 Thales DIS design services SAS
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https://solderpad.org/licenses/
#
# Original Author: Guillaume Chauvon (guillaume.chauvon@thalesgroup.com)

# where are the tools
if [ -z "$RISCV" ]; then
  echo "Error: RISCV variable undefined"
  return
fi

if [ -z "$DV_SIMULATORS" ]; then
  DV_SIMULATORS=veri-testharness,spike
fi

# install the required tools
if [[ "$DV_SIMULATORS" == *"veri-testharness"* ]]; then
  source ./verif/regress/install-verilator.sh
fi
source ./verif/regress/install-spike.sh

source ./verif/sim/setup-env.sh

if [ -z "$DV_TARGET" ]; then
  DV_TARGET=cv64a6_imafdc_sv39
fi

cd verif/sim/

BDIR=../tests/riscv-tests/benchmarks/
CVA6_FLAGS="--target $DV_TARGET --iss=$DV_SIMULATORS --iss_yaml cva6.yaml --linker ../../config/gen_from_riscv_config/linker/link.ld"

GCC_COMMON_SRC=(
        ../tests/custom/common/syscalls.c
        ../tests/custom/common/crt.S
)

GCC_CFLAGS=(
        -fno-tree-loop-distribute-patterns
        -static
        -mcmodel=medany
        -fvisibility=hidden
        -nostdlib
        -nostartfiles
        -lgcc
        -O3 --no-inline
        -I../tests/custom/env
        -I../tests/custom/common
        -DNOPRINT
)

GCC_OPTS="${GCC_COMMON_SRC[*]} ${GCC_CFLAGS[*]}"

python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/dhrystone/dhrystone_main.c --sv_seed 1 --gcc_opts "$BDIR/dhrystone/dhrystone.c $GCC_OPTS -I$BDIR/dhrystone/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/median/median_main.c       --sv_seed 1 --gcc_opts "$BDIR/median/median.c       $GCC_OPTS -I$BDIR/median/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/mm/mm.c                    --sv_seed 1 --gcc_opts "$BDIR/mm/mm_main.c          $GCC_OPTS -I$BDIR/mm/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/mt-matmul/mt-matmul.c      --sv_seed 1 --gcc_opts "$BDIR/mt-matmul/matmul.c    $GCC_OPTS -I$BDIR/mt-matmul/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/mt-vvadd/mt-vvadd.c        --sv_seed 1 --gcc_opts "$BDIR/mt-vvadd/vvadd.c      $GCC_OPTS -I$BDIR/mt-vvadd/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/multiply/multiply_main.c   --sv_seed 1 --gcc_opts "$BDIR/multiply/multiply.c   $GCC_OPTS -I$BDIR/multiply/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/pmp/pmp.c                  --sv_seed 1 --gcc_opts "                            $GCC_OPTS -I$BDIR/pmp/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/qsort/qsort_main.c         --sv_seed 1 --gcc_opts "                            $GCC_OPTS -I$BDIR/qsort/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/rsort/rsort.c              --sv_seed 1 --gcc_opts "                            $GCC_OPTS -I$BDIR/rsort/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/spmv/spmv_main.c           --sv_seed 1 --gcc_opts "                            $GCC_OPTS -I$BDIR/spmv/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/towers/towers_main.c       --sv_seed 1 --gcc_opts "                            $GCC_OPTS -I$BDIR/towers/"
python3 cva6.py $CVA6_FLAGS --c_tests $BDIR/vvadd/vvadd_main.c         --sv_seed 1 --gcc_opts "                            $GCC_OPTS -I$BDIR/vvadd/"

make clean
make -C verif/sim clean_all

cd -

