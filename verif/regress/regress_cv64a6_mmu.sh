# Copyright 2021 Thales DIS design services SAS
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https://solderpad.org/licenses/
#
# Original Author: Jean-Roch COULON - Thales

# where are the tools
if ! [ -n "$RISCV" ]; then
  echo "Error: RISCV variable undefined"
  return
fi


# install the required tools
source ./verif/regress/install-verilator.sh
source ./verif/regress/install-spike.sh

# install the required test suites
source ./verif/regress/install-riscv-compliance.sh
source ./verif/regress/install-riscv-tests.sh
source ./verif/regress/install-riscv-arch-test.sh

# setup sim env
source ./verif/sim/setup-env.sh

echo "$SPIKE_INSTALL_DIR$"

if ! [ -n "$DV_SIMULATORS" ]; then
  DV_SIMULATORS=veri-testharness,spike
fi

if ! [ -n "$UVM_VERBOSITY" ]; then
    UVM_VERBOSITY=UVM_NONE
fi

export DV_OPTS="$DV_OPTS --issrun_opts=+debug_disable=1+UVM_VERBOSITY=$UVM_VERBOSITY"

cd ./verif/sim/
## ALL
#python3 cva6.py --testlist=../tests/testlist_riscv-arch-test-cv64a6_imafdc_sv39.yaml --test all --iss_yaml cva6.yaml --target cv64a6_mmu --iss=$DV_SIMULATORS $DV_OPTS
#python3 cva6.py --testlist=../tests/testlist_riscv-compliance-cv64a6_imafdc_sv39.yaml --test all --iss_yaml cva6.yaml --target cv64a6_mmu --iss=$DV_SIMULATORS $DV_OPTS

## KOs
python3 cva6.py --testlist=../tests/testlist_riscv-compliance-cv64a6_imafdc_sv39.yaml --test rv32mi-scall --iss_yaml cva6.yaml --target cv64a6_mmu --iss=$DV_SIMULATORS $DV_OPTS
python3 cva6.py --testlist=../tests/testlist_riscv-compliance-cv64a6_imafdc_sv39.yaml --test rv32mi-ma_addr --iss_yaml cva6.yaml --target cv64a6_mmu --iss=$DV_SIMULATORS $DV_OPTS
python3 cva6.py --testlist=../tests/testlist_riscv-compliance-cv64a6_imafdc_sv39.yaml --test rv32mi-csr --iss_yaml cva6.yaml --target cv64a6_mmu --iss=$DV_SIMULATORS $DV_OPTS


## TODO
#python3 cva6.py --testlist=../tests/testlist_riscv-tests-cv64a6_imafdc_sv39-v.yaml --test all --iss_yaml cva6.yaml --target cv64a6_mmu --iss=$DV_SIMULATORS $DV_OPTS
#python3 cva6.py --testlist=../tests/testlist_riscv-tests-cv64a6_imafdc_sv39-p.yaml --test all --iss_yaml cva6.yaml --target cv64a6_mmu --iss=$DV_SIMULATORS $DV_OPTS

cd -