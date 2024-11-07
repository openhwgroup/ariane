# ------------------------------------------------------------------------------
#   Copyright 2024 Robert Bosch GmbH
#
#   SPDX-License-Identifier: SHL-0.51
#
#   Original Author: Konstantinos LEVENTOS - Robert Bosch France SAS
# ------------------------------------------------------------------------------
#   pmp_cv32a65x_read_me_first.txt
# ------------------------------------------------------------------------------

Steps to run the pmp_cv32a65x tests:
    Optional Step 0. If there is still a problem with $data/FE/cva6_lib/cva6/verif/env/uvme/cov/uvme_exception_covg.sv
                     comment out line 112 of that same file. This step is a hotfix and should be deleted from this file
                     as soon as the problem with the coverage is resolved.
    1. Go to the main cva6 project folder, usually with cd $data/FE/cva6_lib/cva6
    2. Export the following values, this is mandatory, and may be different with your local environment:
        export PATH=$PATH:/tools/vtec/tools/devicetree/1.4.6/rh7/usr/bin
        export VERILATOR_INSTALL_DIR=/tools/vtec/tools/veripool/verilator/5.008/rh7/
        export RISCV=/tools/vtec/tools/embecosm/riscv32-embecosm-centos7-gcc13.1.0
        export CV_SW_PREFIX=riscv32-unknown-elf-
        export RISCV_PREFIX=${RISCV}/bin/${CV_SW_PREFIX}
        export RISCV_GCC=${RISCV_PREFIX}gcc
        export XCELIUM_HOME=/tools/cds/xceliummain_23.09.005_Linux/
    3. Run the setup environment script as well in ./verif/sim/setup-env.sh
    4. Edit the file in $data/FE/cva6_lib/cva6/verif/regress/pmp_cv32a65x_tests.sh to select which test to run:
        For example, with TEST_NUMBER="#1#" uncommented, the (currently failing) test "granularity" will run.
    Optional Step 4,5. It is good to check / force the versions of some modules used, specifically:
        module load std/gcc/9.2.0 -f
        module std/python/3.11.4 -f
    5. Run that very same file from the cva6 folder specifically, usually with sh ./verif/regress/pmp_cv32a65x_tests.sh
