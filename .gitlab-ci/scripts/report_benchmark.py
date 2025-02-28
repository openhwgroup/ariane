# Copyright 2022 Thales Silicon Security
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https://solderpad.org/licenses/
#
# Original Author: Côme Allart

import os
import sys
import re
import report_builder as rb

path = None
mode = None
iterations = None

# Keep it up-to-date with compiler version and core performance improvements
# Will fail if the number of cycles is different from this one
valid_cycles = {
    "dhrystone_dual": 18935,
    "dhrystone_single": 24127,
    "coremark_dual": 1001191,
    "coremark_single": 1300030,
    "dhrystone_cv32a65x": 30793,
    "dhrystone_cv32a60x": 38556,
}

for arg in sys.argv[1:]:
    if "--dhrystone" in arg or "--coremark" in arg:
        if "--dhrystone" in arg:
            iterations = 50
        else:
            if "--coremark" in arg:
                iterations = 4
        mode = arg.replace("-", "")
    else:
        path = arg

# We do not want to have a report without a check
assert mode is not None

with open(path, "r") as f:
    log = [l.strip() for l in f.readlines()]

stopwatch = []
for index, line in enumerate(log):
    if line.split()[-1] == "mcycle" or line.split()[-2] == "mcycle,":
        stopwatch.append(int(log[index + 1].split()[-1], 16))
# There might be > 2 matches, we use the two at the center
N = len(stopwatch)
assert N % 2 == 0
cycles = stopwatch[N // 2] - stopwatch[N // 2 - 1]

score_metric = rb.TableMetric("Performance results")
score_metric.add_value("cycles", cycles)

if iterations is not None:
    ipmhz = iterations * 1000000 / cycles
    if "dhrystone" in mode:
        score_metric.add_value("Dhrystone/MHz", ipmhz)
        score_metric.add_value("DMIPS/MHz", ipmhz / 1757)
    if "coremark" in mode:
        score_metric.add_value("CoreMark/MHz", ipmhz)

diff = cycles - valid_cycles[mode]
if diff != 0:
    score_metric.fail()
    score_metric.add_value("Cycles diff", diff)

report = rb.Report(f"{cycles//1000} kCycles")
report.add_metric(score_metric)
report.dump()

if report.failed:
    sys.exit(1)
