"""
Copyright 2019 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Regression script for RISC-V random instruction generator
"""

import argparse
import os
import random
import re
import sys
import logging
import subprocess
import datetime
import yaml

from dv.scripts.lib import *
from verilator_log_to_trace_csv import *
from cva6_spike_log_to_trace_csv import *
from dv.scripts.ovpsim_log_to_trace_csv import *
from dv.scripts.whisper_log_trace_csv import *
from dv.scripts.sail_log_to_trace_csv import *
from dv.scripts.instr_trace_compare import *
from pathlib import Path
from types import SimpleNamespace

LOGGER = logging.getLogger()

class SeedGen:
  '''An object that will generate a pseudo-random seed for test iterations'''
  def __init__(self, start_seed, fixed_seed, seed_yaml):
    # These checks are performed with proper error messages at argument parsing
    # time, but it can't hurt to do a belt-and-braces check here too.
    assert fixed_seed is None or start_seed is None

    self.fixed_seed = fixed_seed
    self.start_seed = start_seed
    self.rerun_seed = {} if seed_yaml is None else read_yaml(seed_yaml)

  def get(self, test_id, test_iter):
    '''Get the seed to use for the given test and iteration'''

    if test_id in self.rerun_seed:
      # Note that test_id includes the iteration index (well, the batch index,
      # at any rate), so this makes sense even if test_iter > 0.
      return self.rerun_seed[test_id]

    if self.fixed_seed is not None:
      # Checked at argument parsing time
      assert test_iter == 0
      return self.fixed_seed

    if self.start_seed is not None:
      return self.start_seed + test_iter

    # If the user didn't specify seeds in some way, we generate a random seed
    # every time
    return random.getrandbits(31)


def get_generator_cmd(simulator, simulator_yaml, cov, exp, debug_cmd):
  """ Setup the compile and simulation command for the generator

  Args:
    simulator      : RTL simulator used to run instruction generator
    simulator_yaml : RTL simulator configuration file in YAML format
    cov            : Enable functional coverage
    exp            : Use experimental version
    debug_cmd      : Produce the debug cmd log without running

  Returns:
    compile_cmd    : RTL simulator command to compile the instruction generator
    sim_cmd        : RTL simulator command to run the instruction generator
  """
  logging.info("Processing simulator setup file: %s" % simulator_yaml)
  yaml_data = read_yaml(simulator_yaml)
  # Search for matched simulator
  for entry in yaml_data:
    if entry['tool'] == simulator:
      logging.info("Found matching simulator: %s" % entry['tool'])
      compile_spec = entry['compile']
      compile_cmd = compile_spec['cmd']
      for i in range(len(compile_cmd)):
        if ('cov_opts' in compile_spec) and cov:
          compile_cmd[i] = re.sub('<cov_opts>', compile_spec['cov_opts'].rstrip(), compile_cmd[i])
        else:
          compile_cmd[i] = re.sub('<cov_opts>', '', compile_cmd[i])
        if exp:
          compile_cmd[i] += " +define+EXPERIMENTAL "
      sim_cmd = entry['sim']['cmd']
      if ('cov_opts' in entry['sim']) and cov:
        sim_cmd = re.sub('<cov_opts>', entry['sim']['cov_opts'].rstrip(), sim_cmd)
      else:
        sim_cmd = re.sub('<cov_opts>', '', sim_cmd)
      if 'env_var' in entry:
        for env_var in entry['env_var'].split(','):
          for i in range(len(compile_cmd)):
            compile_cmd[i] = re.sub("<"+env_var+">", get_env_var(env_var, debug_cmd = debug_cmd),
                                    compile_cmd[i])
          sim_cmd = re.sub("<"+env_var+">", get_env_var(env_var, debug_cmd = debug_cmd), sim_cmd)
      return compile_cmd, sim_cmd
  logging.error("Cannot find RTL simulator %0s" % simulator)
  sys.exit(RET_FAIL)


def parse_iss_yaml(iss, iss_yaml, isa, target, setting_dir, debug_cmd, priv, spike_params):
  """Parse ISS YAML to get the simulation command

  Args:
    iss         : target ISS used to look up in ISS YAML
    iss_yaml    : ISS configuration file in YAML format
    isa         : ISA variant passed to the ISS
    setting_dir : Generator setting directory
    debug_cmd   : Produce the debug cmd log without running

  Returns:
    cmd         : ISS run command
  """
  logging.info("Processing ISS setup file: %s" % iss_yaml)
  yaml_data = read_yaml(iss_yaml)
  # Search for matched ISS
  for entry in yaml_data:
    if entry['iss'] == iss:
      logging.info("Found matching ISS: %s" % entry['iss'])
      m = re.search(r"rv(?P<xlen>[0-9]+?)(?P<variant>[a-z]+(_[szx]\w+)*)$", isa)
      logging.info("Target: " + target)
      if m: logging.info("ISA %0s" % isa)
      else: logging.error("Illegal ISA %0s" % isa)

      cmd = entry['cmd'].rstrip()
      cmd = re.sub(r"\<path_var\>", get_env_var(entry['path_var'], debug_cmd = debug_cmd), cmd)
      cmd = re.sub(r"\<tool_path\>", get_env_var(entry['tool_path'], debug_cmd = debug_cmd), cmd)
      cmd = re.sub(r"\<tb_path\>", get_env_var(entry['tb_path'], debug_cmd = debug_cmd), cmd)
      cmd = re.sub(r"\<isscomp_opts\>", isscomp_opts, cmd)
      cmd = re.sub(r"\<issrun_opts\>", issrun_opts, cmd)
      cmd = re.sub(r"\<isspostrun_opts\>", isspostrun_opts, cmd)
      cmd = re.sub(r"\<spike_params\>", spike_params, cmd)
      if m: cmd = re.sub(r"\<xlen\>", m.group('xlen'), cmd)
      if iss == "ovpsim":
        cmd = re.sub(r"\<cfg_path\>", setting_dir, cmd)
      elif iss == "whisper":
        if m:
          # TODO: Support u/s mode
          variant = re.sub('g', 'imafd',  m.group('variant'))
          cmd = re.sub(r"\<variant\>", variant, cmd)
      else:
        cmd = re.sub(r"\<variant\>", isa, cmd)
        cmd = re.sub(r"\<priv\>", priv, cmd)
        cmd = re.sub(r"\<target\>", target, cmd)
      return cmd
  logging.error("Cannot find ISS %0s" % iss)
  sys.exit(RET_FAIL)


def get_iss_cmd(base_cmd, elf, target, log):
  """Get the ISS simulation command

  Args:
    base_cmd : Original command template
    elf      : ELF file to run ISS simualtion
    log      : ISS simulation log name

  Returns:
    cmd      : Command for ISS simulation
  """
  cmd = re.sub(r"\<elf\>", elf, base_cmd)
  cmd = re.sub(r"\<target\>", target, cmd)
  cmd = re.sub(r"\<log\>", log, cmd)
  cmd += (" &> %s.iss" % log)
  return cmd


def do_compile(compile_cmd, test_list, core_setting_dir, cwd, ext_dir,
               cmp_opts, output_dir, debug_cmd, lsf_cmd):
  """Compile the instruction generator

  Args:
    compile_cmd         : Compile command for the generator
    test_list           : List of assembly programs to be compiled
    core_setting_dir    : Path for riscv_core_setting.sv
    cwd                 : Filesystem path to RISCV-DV repo
    ext_dir             : User extension directory
    cmd_opts            : Compile options for the generator
    output_dir          : Output directory of the ELF files
    debug_cmd           : Produce the debug cmd log without running
    lsf_cmd             : LSF command used to run the instruction generator
  """
  if (not((len(test_list) == 1) and (test_list[0]['test'] == 'riscv_csr_test'))):
    logging.info("Building RISC-V instruction generator")
    for cmd in compile_cmd:
      cmd = re.sub("<out>", os.path.abspath(output_dir), cmd)
      cmd = re.sub("<setting>", core_setting_dir, cmd)
      if ext_dir == "":
        cmd = re.sub("<user_extension>", "<cwd>/dv/user_extension", cmd)
      else:
        cmd = re.sub("<user_extension>", ext_dir, cmd)
      cmd = re.sub("<cwd>", cwd, cmd)
      cmd = re.sub("<cmp_opts>", cmp_opts, cmd)
      if lsf_cmd:
        cmd = lsf_cmd + " " + cmd
        run_parallel_cmd([cmd], debug_cmd = debug_cmd)
      else:
        logging.debug("Compile command: %s" % cmd)
        run_cmd(cmd, debug_cmd = debug_cmd)


def run_csr_test(cmd_list, cwd, csr_file, isa, iterations, lsf_cmd,
                 end_signature_addr, timeout_s, output_dir, debug_cmd):
  """Run CSR test
     It calls a separate python script to generate directed CSR test code,
     located at scripts/gen_csr_test.py.
  """
  cmd = "python3 " + cwd + "/scripts/gen_csr_test.py" + \
        (" --csr_file %s" % csr_file) + \
        (" --xlen %s" % re.search(r"(?P<xlen>[0-9]+)", isa).group("xlen")) + \
        (" --iterations %i" % iterations) + \
        (" --out %s/asm_tests" % output_dir) + \
        (" --end_signature_addr %s" % end_signature_addr)
  if lsf_cmd:
    cmd_list.append(cmd)
  else:
    run_cmd(cmd, timeout_s, debug_cmd = debug_cmd)


def do_simulate(sim_cmd, test_list, cwd, sim_opts, seed_gen, csr_file,
                isa, end_signature_addr, lsf_cmd, timeout_s, log_suffix,
                batch_size, output_dir, verbose, check_return_code, debug_cmd):
  """Run  the instruction generator

  Args:
    sim_cmd               : Simulate command for the generator
    test_list             : List of assembly programs to be compiled
    cwd                   : Filesystem path to RISCV-DV repo
    sim_opts              : Simulation options for the generator
    seed_gen              : A SeedGen seed generator
    csr_file              : YAML file containing description of all CSRs
    isa                   : Processor supported ISA subset
    end_signature_addr    : Address that tests will write pass/fail signature to at end of test
    lsf_cmd               : LSF command used to run the instruction generator
    timeout_s             : Timeout limit in seconds
    log_suffix            : Simulation log file name suffix
    batch_size            : Number of tests to generate per run
    output_dir            : Output directory of the ELF files
    check_return_code     : Check return code of the command
    debug_cmd             : Produce the debug cmd log without running
  """
  cmd_list = []
  sim_cmd = re.sub("<out>", os.path.abspath(output_dir), sim_cmd)
  sim_cmd = re.sub("<cwd>", cwd, sim_cmd)
  sim_cmd = re.sub("<sim_opts>", sim_opts, sim_cmd)

  logging.info("Running RISC-V instruction generator")
  sim_seed = {}
  for test in test_list:
    iterations = test['iterations']
    logging.info("Generating %d %s" % (iterations, test['test']))
    if iterations > 0:
      # Running a CSR test
      if test['test'] == 'riscv_csr_test':
        run_csr_test(cmd_list, cwd, csr_file, isa, iterations, lsf_cmd,
                     end_signature_addr, timeout_s, output_dir, debug_cmd)
      else:
        batch_cnt = 1
        if batch_size > 0:
          batch_cnt = int((iterations + batch_size - 1)  / batch_size);
        logging.info("Running %s with %0d batches" % (test['test'], batch_cnt))
        for i in range(0, batch_cnt):
          test_id = '%0s_%0d' % (test['test'], i)
          rand_seed = seed_gen.get(test_id, i * batch_cnt)
          if i < batch_cnt - 1:
            test_cnt = batch_size
          else:
            test_cnt = iterations - i * batch_size;
          cmd = lsf_cmd + " " + sim_cmd.rstrip() + \
                (" +UVM_TESTNAME=%s " % test['gen_test']) + \
                (" +num_of_tests=%i " % test_cnt) + \
                (" +start_idx=%d " % (i*batch_size)) + \
                (" +asm_file_name=%s/asm_tests/%s " % (output_dir, test['test'])) + \
                (" -l %s/sim_%s_%d_%s.log " % (output_dir, test['test'], i, log_suffix))
          if verbose:
            cmd += "+UVM_VERBOSITY=UVM_HIGH "
          cmd = re.sub("<seed>", str(rand_seed), cmd)
          cmd = re.sub("<test_id>", test_id, cmd)
          sim_seed[test_id] = str(rand_seed)
          if "gen_opts" in test:
            cmd += test['gen_opts']
          if not re.search("c", isa):
            cmd += "+disable_compressed_instr=1 ";
          if lsf_cmd:
            cmd_list.append(cmd)
          else:
            logging.info("Running %s, batch %0d/%0d, test_cnt:%0d" %
                         (test['test'], i+1, batch_cnt, test_cnt))
            run_cmd(cmd, timeout_s, check_return_code = check_return_code, debug_cmd = debug_cmd)
  if sim_seed:
    with open(('%s/seed.yaml' % os.path.abspath(output_dir)) , 'w') as outfile:
      yaml.dump(sim_seed, outfile, default_flow_style=False)
    with open(('seedlist.yaml') , 'a') as seedlist:
      yaml.dump(sim_seed, seedlist, default_flow_style=False)
  if lsf_cmd:
    run_parallel_cmd(cmd_list, timeout_s, check_return_code = check_return_code,
                     debug_cmd = debug_cmd)


def gen(test_list, argv, output_dir, cwd):
  """Run the instruction generator

  Args:
    test_list             : List of assembly programs to be compiled
    argv                  : Configuration arguments
    output_dir            : Output directory of the ELF files
    cwd                   : Filesystem path to RISCV-DV repo
  """

  check_return_code = True
  if argv.simulator == "ius":
    # Incisive return non-zero return code even test passes
    check_return_code = False
    logging.debug("Disable return_code checking for %s" % argv.simulator)
  # Mutually exclusive options between compile_only and sim_only
  if argv.co and argv.so:
    logging.error("argument -co is not allowed with argument -so")
    return
  if ((argv.co == 0) and (len(test_list) == 0)):
    return
  # Setup the compile and simulation command for the generator
  compile_cmd = []
  sim_cmd = ""
  compile_cmd, sim_cmd = get_generator_cmd(argv.simulator, argv.simulator_yaml, argv.cov,
                                           argv.exp, argv.debug);
  # Compile the instruction generator
  if not argv.so:
    do_compile(compile_cmd, test_list, argv.core_setting_dir, cwd, argv.user_extension_dir,
               argv.cmp_opts, output_dir, argv.debug, argv.lsf_cmd)
  # Run the instruction generator
  if not argv.co:
    seed_gen = SeedGen(argv.start_seed, argv.seed, argv.seed_yaml)
    do_simulate(sim_cmd, test_list, cwd, argv.sim_opts, seed_gen, argv.csr_yaml,
                argv.isa, argv.end_signature_addr, argv.lsf_cmd, argv.gen_timeout, argv.log_suffix,
                argv.batch_size, output_dir, argv.verbose, check_return_code, argv.debug)


# Convert the ELF to plain binary, used in RTL sim
def elf2bin(elf, binary, debug_cmd):
  logging.info("Converting to %s" % binary)
  cmd = ("%s -O binary %s %s" % (get_env_var("RISCV_OBJCOPY", debug_cmd = debug_cmd), elf, binary))
  run_cmd_output(cmd.split(), debug_cmd = debug_cmd)


def gcc_compile(test_list, output_dir, isa, mabi, opts, debug_cmd, linker):
  """Use riscv gcc toolchain to compile the assembly program

  Args:
    test_list  : List of assembly programs to be compiled
    output_dir : Output directory of the ELF files
    isa        : ISA variant passed to GCC
    mabi       : MABI variant passed to GCC
    debug_cmd  : Produce the debug cmd log without running
    linker     : Path to the linker
  """
  cwd = os.path.dirname(os.path.realpath(__file__))
  for test in test_list:
    for i in range(0, test['iterations']):
      if 'no_gcc' in test and test['no_gcc'] == 1:
        continue
      prefix = ("%s/asm_tests/%s_%d" % (output_dir, test['test'], i))
      asm = prefix + ".S"
      elf = prefix + ".o"
      binary = prefix + ".bin"
      test_isa=re.match("[a-z0-9A-Z]+", isa)
      test_isa=test_isa.group()
      isa_ext=isa
      if not os.path.isfile(asm) and not debug_cmd:
        logging.error("Cannot find assembly test: %s\n", asm)
        sys.exit(RET_FAIL)
      # gcc comilation
      cmd = ("%s %s \
             -I%s/../env/corev-dv/user_extension \
             -T%s %s -o %s " % \
             (get_env_var("RISCV_CC", debug_cmd = debug_cmd), asm, cwd, linker, opts, elf))
      if 'gcc_opts' in test:
        cmd += test['gcc_opts']
      if 'gen_opts' in test:
        # Disable compressed instruction
        if re.search('disable_compressed_instr=1', test['gen_opts']):
          test_isa = re.sub("c",  "", test_isa)
          #add z,s,x extensions to the isa if there are some
          if isa_extension_list !=['none']:
            for i in isa_extension_list:
              test_isa += (f"_{i}")
          isa_ext=test_isa
      # If march/mabi is not defined in the test gcc_opts, use the default
      # setting from the command line.
      if not re.search('march', cmd):
        cmd += (" -march=%s" % isa_ext)
      if not re.search('mabi', cmd):
        cmd += (" -mabi=%s" % mabi)
      logging.info("Compiling test: %s" % asm)
      run_cmd_output(cmd.split(), debug_cmd = debug_cmd)
      elf2bin(elf, binary, debug_cmd)



def tandem_postprocess(tandem_report, target, isa, test_name, log, testlist, iss, iterations = None):
  analyze_tandem_report(tandem_report)
  process_verilator_sim_log(log, log + ".csv")
  generate_yaml_report(tandem_report, target, isa, test_name, testlist, iss, False , iterations)

def analyze_tandem_report(yaml_path):
  with open(yaml_path, 'r') as f:
      data = yaml.safe_load(f)
  try:
    mismatches_count =  (data["mismatches_count"])
    instr_count = (data["instr_count"])
    exit_code = (data["exit_code"])
    matches_count =  instr_count - mismatches_count
    logging.info("TANDEM Result : %s (exit code %s) with %s mismatches and %s matches"
        % (data["exit_cause"], exit_code, mismatches_count, matches_count))
  except KeyError:
    logging.info("Incomplete TANDEM YAML report")

def log_uvm_seed(sv_seed , filename="uvm_seed.log"):
  try:
      with open(filename, 'a') as file:
          timestamp = datetime.datetime.now().strftime('%Y-%m-%d  %H:%M:%S')
          file.write(f"{timestamp} - UVM Seed: {sv_seed}\n")
  except IOError as error:
      print(f"Failed to log UVM seed: {error}")

def generate_yaml_report(yaml_path, target, isa, test, testlist, iss, initial_creation , iteration = None):
  if not initial_creation:
    with open(yaml_path, 'r') as f:
      report = yaml.safe_load(f)
  else:
    report = {"exit_cause": "UNKNOWN"}
  report["target"] = target
  report["isa"] = isa
  report["test"] = test
  report["testlist"] = testlist
  report["simulator"] = iss
  if iteration != None:
    report["iteration"] = iteration

  with open(yaml_path, "w") as f:
    yaml.dump(report, f)


def run_test(test, iss_yaml, isa, target, mabi, gcc_opts, iss_opts, output_dir,
             setting_dir, debug_cmd, linker, priv, spike_params, test_name=None, iss_timeout=500, testlist="custom"):
  """Run a directed test with ISS

  Args:
    test        : C test file
    iss_yaml    : ISS configuration file in YAML format
    isa         : ISA variant passed to the ISS
    target      : Target simulator name
    mabi        : MABI variant passed to GCC
    gcc_opts    : User-defined options for GCC compilation
    iss_opts    : Options for the instruction set simulators
    output_dir  : Output directory of compiled test files
    setting_dir : Generator setting directory
    debug_cmd   : Produce the debug command log without running
    linker      : Path to the linker
    priv        : Privilege mode of the test
    spike_params: Parameters for the Spike ISS
    test_name   : (Optional) Name of the test
    iss_timeout : Timeout for ISS simulation (default: 500)
    testlist    : Test list identifier (default: "custom")
  """
  if testlist != None:
    testlist = testlist.split('/')[-1].strip("testlist_").split('.')[0]

  if test.endswith(".c"):
    test_type = "c"
  elif test.endswith(".S"):
    test_type = "S"
  elif test.endswith(".o"):
    test_type = "o"
  else:
    sys.exit("Unknown test extension!")

  cwd = os.path.dirname(os.path.realpath(__file__))
  test_path = os.path.expanduser(test)
  report = ("%s/iss_regr.log" % output_dir).rstrip()
  test = re.sub(r"^.*\/", "", test_path)
  test = re.sub(rf"\.{test_type}$", "", test)
  prefix = (f"{output_dir}/directed_tests/{test}")
  if test_type == "o":
    elf = test_path
  else:
    elf = prefix + ".o"

  iss_list = iss_opts.split(",")
  run_cmd("mkdir -p %s/directed_tests" % output_dir)

  if test_type != "o":
    # gcc compilation
    logging.info("Compiling test: %s" % test_path)
    cmd = ("%s %s \
          -I%s/dv/user_extension \
            -T%s %s -o %s " % \
          (get_env_var("RISCV_CC", debug_cmd = debug_cmd), test_path, cwd,
              linker, gcc_opts, elf))
    cmd += (" -march=%s" % isa)
    cmd += (" -mabi=%s" % mabi)
    run_cmd(cmd, debug_cmd = debug_cmd)
  log_list = []
  # ISS simulation
  test_log_name = test_name or test
  for iss in iss_list:
    tandem_sim = iss != "spike" and os.environ.get('SPIKE_TANDEM') != None
    run_cmd("mkdir -p %s/%s_sim" % (output_dir, iss))
    if log_format == 1:
      log = ("%s/%s_sim/%s_%d.%s.log" % (output_dir, iss, test_log_name, test_iteration, target))
    else:
      log = ("%s/%s_sim/%s.%s.log" % (output_dir, iss, test_log_name, target))
    yaml = ("%s/%s_sim/%s.%s.log.yaml" % (output_dir, iss, test_log_name, target))
    log_list.append(log)
    base_cmd = parse_iss_yaml(iss, iss_yaml, isa, target, setting_dir, debug_cmd, priv, spike_params)
    print(elf)
    cmd = get_iss_cmd(base_cmd, elf, target, log)
    logging.info("[%0s] Running ISS simulation: %s" % (iss, cmd))
    if "spike" in iss: ratio = 10
    else: ratio = 1
    if tandem_sim:
      generate_yaml_report(yaml, target, isa, test_log_name, testlist, iss, True)
    run_cmd(cmd, iss_timeout//ratio, debug_cmd = debug_cmd)
    logging.info("[%0s] Running ISS simulation: %s ...done" % (iss, elf))

    if tandem_sim:
      tandem_postprocess(yaml, target, isa, test_log_name, log, testlist, iss)

  if len(iss_list) == 2:
    compare_iss_log(iss_list, log_list, report)


def iss_sim(test_list, output_dir, iss_list, iss_yaml, iss_opts,
            isa, target, setting_dir, timeout_s, debug_cmd, priv, spike_params):
  """Run ISS simulation with the generated test program

  Args:
    test_list   : List of assembly programs to be compiled
    output_dir  : Output directory of the ELF files
    iss_list    : List of instruction set simulators
    iss_yaml    : ISS configuration file in YAML format
    iss_opts    : ISS command line options
    isa         : ISA variant passed to the ISS
    setting_dir : Generator setting directory
    timeout_s   : Timeout limit in seconds
    debug_cmd   : Produce the debug cmd log without running
  """
  for iss in iss_list.split(","):
    log_dir = ("%s/%s_sim" % (output_dir, iss))
    base_cmd = parse_iss_yaml(iss, iss_yaml, isa, target, setting_dir, debug_cmd, priv, spike_params)
    logging.info("%s sim log dir: %s" % (iss, log_dir))
    run_cmd_output(["mkdir", "-p", log_dir])
    tandem_sim = iss != "spike" and os.environ.get('SPIKE_TANDEM') != None
    for test in test_list:
      if 'no_iss' in test and test['no_iss'] == 1:
        continue
      else:
        for i in range(0, test['iterations']):
          prefix = ("%s/asm_tests/%s_%d" % (output_dir, test['test'], i))
          elf = prefix + ".o"
          log = ("%s/%s_%d.%s.log" % (log_dir, test['test'], i, target))
          cmd = get_iss_cmd(base_cmd, elf, target, log)
          yaml = ("%s/%s_%s.%s.log.yaml" % (log_dir, test['test'], i, target))
          if 'iss_opts' in test:
            cmd += ' '
            cmd += test['iss_opts']
          logging.info("Running %s sim: %s" % (iss, elf))
          if tandem_sim:
            generate_yaml_report(yaml, target, isa, test['test'], "generated tests", iss, True, i)
          if iss == "ovpsim":
            run_cmd(cmd, timeout_s, check_return_code=False, debug_cmd = debug_cmd)
          else:
            run_cmd(cmd, timeout_s, debug_cmd = debug_cmd)
          logging.debug(cmd)
          if tandem_sim:
            tandem_postprocess(yaml, target, isa, test['test'], log, "generated tests", iss, i)


def iss_cmp(test_list, iss, target, output_dir, stop_on_first_error, exp, debug_cmd):
  """Compare ISS simulation reult

  Args:
    test_list      : List of assembly programs to be compiled
    iss            : List of instruction set simulators
    output_dir     : Output directory of the ELF files
    stop_on_first_error : will end run on first error detected
    exp            : Use experimental version
    debug_cmd      : Produce the debug cmd log without running
  """
  if debug_cmd:
    return
  iss_list = iss.split(",")
  if len(iss_list) != 2:
    return
  report = ("%s/iss_regr.log" % output_dir).rstrip()
  for test in test_list:
    for i in range(0, test['iterations']):
      elf = ("%s/asm_tests/%s_%d.o" % (output_dir, test['test'], i))
      logging.info("Comparing ISS sim result %s/%s: %s" %
                  (iss_list[0], iss_list[1], elf))
      log_list = []
      run_cmd(("echo 'Test binary: %s' >> %s" % (elf, report)))
      for iss in iss_list:
        log_list.append("%s/%s_sim/%s_%d.%s.log" % (output_dir, iss, test['test'], i, target))
      compare_iss_log(iss_list, log_list, report, stop_on_first_error, exp)
  save_regr_report(report)


def compare_iss_log(iss_list, log_list, report, stop_on_first_error=0, exp=False):
  if (len(iss_list) != 2 or len(log_list) != 2):
    logging.error("Only support comparing two ISS logs")
    logging.info("len(iss_list) = %s len(log_list) = %s" % (len(iss_list), len(log_list)))
  else:
    csv_list = []
    for i in range(2):
      log = log_list[i]
      csv = log.replace(".log", ".csv");
      iss = iss_list[i]
      csv_list.append(csv)
      if iss == "spike":
        process_spike_sim_log(log, csv)
      elif "veri" in iss or "vsim" in iss or "vcs" in iss or "questa" in iss:
        process_verilator_sim_log(log, csv)
      elif iss == "ovpsim":
        process_ovpsim_sim_log(log, csv, stop_on_first_error)
      elif iss == "sail":
        process_sail_sim_log(log, csv)
      elif iss == "whisper":
        process_whisper_sim_log(log, csv)
      else:
        logging.error("Unsupported ISS" % iss)
        sys.exit(RET_FAIL)
    result = compare_trace_csv(csv_list[0], csv_list[1], iss_list[0], iss_list[1], report)
    logging.info(result)


def save_regr_report(report):
  passed_cnt = run_cmd(r"grep '\[PASSED\]' %s | wc -l" % report).strip()
  failed_cnt = run_cmd(r"grep '\[FAILED\]' %s | wc -l" % report).strip()
  summary = ("%s PASSED, %s FAILED" % (passed_cnt, failed_cnt))
  logging.info(summary)
  run_cmd(("echo %s >> %s" % (summary, report)))
  if failed_cnt != "0":
    failed_details = run_cmd(r"sed -e 's,.*_sim/,,' %s | grep '\(csv\|matched\)' | uniq | sed -e 'N;s/\\n/ /g' | grep '\[FAILED\]'" % report).strip()
    logging.info(failed_details)
    run_cmd(("echo %s >> %s" % (failed_details, report)))
    #sys.exit(RET_FAIL) #Do not return error code in case of test fail.
  logging.info("ISS regression report is saved to %s" % report)


def read_seed(arg):
    '''Read --seed or --seed_start'''
    try:
        seed = int(arg)
        if seed < 0:
            raise ValueError('bad seed')
        return seed

    except ValueError:
        raise argparse.ArgumentTypeError('Bad seed ({}): '
                                         'must be a non-negative integer.'
                                         .format(arg))


def parse_args(cwd):
  """Create a command line parser.

  Returns: The created parser.
  """
  # Parse input arguments
  parser = argparse.ArgumentParser()

  parser.add_argument("--target", type=str, default="rv32imc",
                      help="Run the generator with pre-defined targets: \
                            rv32imc, rv32i, rv32ima, rv64imc, rv64gc, rv64imac")
  parser.add_argument("-o", "--output", type=str,
                      help="Output directory name", dest="o")
  parser.add_argument("-tl", "--testlist", type=str, default="",
                      help="Regression testlist", dest="testlist")
  parser.add_argument("-tn", "--test", type=str, default="all",
                      help="Test name, 'all' means all tests in the list", dest="test")
  parser.add_argument("-i", "--iterations", type=int, default=0,
                      help="Override the iteration count in the test list", dest="iterations")
  parser.add_argument("-si", "--simulator", type=str, default="vcs",
                      help="Simulator used to run the generator, default VCS", dest="simulator")
  parser.add_argument("--iss", type=str, default="spike",
                      help="RISC-V instruction set simulator: spike,ovpsim,sail")
  parser.add_argument("-v", "--verbose", dest="verbose", action="store_true", default=False,
                      help="Verbose logging")
  parser.add_argument("--co", dest="co", action="store_true", default=False,
                      help="Compile the generator only")
  parser.add_argument("--cov", dest="cov", action="store_true", default=False,
                      help="Enable functional coverage")
  parser.add_argument("--so", dest="so", action="store_true", default=False,
                      help="Simulate the generator only")
  parser.add_argument("--cmp_opts", type=str, default="",
                      help="Compile options for the generator")
  parser.add_argument("--sim_opts", type=str, default="",
                      help="Simulation options for the generator")
  parser.add_argument("--gcc_opts", type=str, default="",
                      help="GCC compile options")
  parser.add_argument("--issrun_opts", type=str, default="+debug_disable=1",
                      help="simulation run options")
  parser.add_argument("--isscomp_opts", type=str, default="",
                      help="simulation comp options")
  parser.add_argument("--isspostrun_opts", type=str, default="0x0000000080000000",
                      help="simulation post run options")
  parser.add_argument("-s", "--steps", type=str, default="all",
                      help="Run steps: gen,gcc_compile,iss_sim,iss_cmp", dest="steps")
  parser.add_argument("--lsf_cmd", type=str, default="",
                      help="LSF command. Run in local sequentially if lsf \
                            command is not specified")
  parser.add_argument("--isa", type=str, default="",
                      help="RISC-V ISA subset")
  parser.add_argument("--priv", type=str, default="msu",
                      help="RISC-V ISA privilege models")
  parser.add_argument("-m", "--mabi", type=str, default="",
                      help="mabi used for compilation", dest="mabi")
  parser.add_argument("--gen_timeout", type=int, default=360,
                      help="Generator timeout limit in seconds")
  parser.add_argument("--end_signature_addr", type=str, default="0",
                      help="Address that privileged CSR test writes to at EOT")
  parser.add_argument("--iss_opts", type=str, default="",
                      help="Any ISS command line arguments")
  parser.add_argument("--iss_timeout", type=int, default=500,
                      help="ISS sim timeout limit in seconds")
  parser.add_argument("--iss_yaml", type=str, default="",
                      help="ISS setting YAML")
  parser.add_argument("--simulator_yaml", type=str, default="",
                      help="RTL simulator setting YAML")
  parser.add_argument("--csr_yaml", type=str, default="",
                      help="CSR description file")
  parser.add_argument("-ct", "--custom_target", type=str, default="",
                      help="Directory name of the custom target")
  parser.add_argument("-cs", "--core_setting_dir", type=str, default="",
                      help="Path for the riscv_core_setting.sv")
  parser.add_argument("-ext", "--user_extension_dir", type=str, default="",
                      help="Path for the user extension directory")
  parser.add_argument("--asm_tests", type=str, default="",
                      help="Directed assembly tests")
  parser.add_argument("--c_tests", type=str, default="",
                      help="Directed c tests")
  parser.add_argument("--elf_tests", type=str, default="",
                      help="Directed elf tests")
  parser.add_argument("--log_suffix", type=str, default="",
                      help="Simulation log name suffix")
  parser.add_argument("--exp", action="store_true", default=False,
                      help="Run generator with experimental features")
  parser.add_argument("-bz", "--batch_size", type=int, default=0,
                      help="Number of tests to generate per run. You can split a big"
                           " job to small batches with this option")
  parser.add_argument("--stop_on_first_error", dest="stop_on_first_error",
                      action="store_true", default=False,
                      help="Stop on detecting first error")
  parser.add_argument("--noclean", action="store_true", default=True,
                      help="Do not clean the output of the previous runs")
  parser.add_argument("--verilog_style_check", action="store_true", default=False,
                      help="Run verilog style check")
  parser.add_argument("-d", "--debug", type=str, default="",
                      help="Generate debug command log file")
  parser.add_argument("--hwconfig_opts", type=str, default="",
                      help="custom configuration options for util/user_config.py")
  parser.add_argument("-l", "--linker", type=str, default="",
                      help="Path for the link.ld")
  parser.add_argument("--axi_active", type=str, default="",
                      help="switch AXI agent mode: yes for Active, no for Passive")
  parser.add_argument("--gen_sv_seed", type=int, default=0,
                      help="Run test N times with random seed")
  parser.add_argument("--sv_seed", type=str, default=str(random.getrandbits(31)),
                      help="Run test with a specific seed")
  parser.add_argument("--isa_extension", type=str, default="",
                      help="Choose additional z, s, x extensions")
  parser.add_argument("--spike_params", type=str, default="",
                      help="Spike command line parameters, run spike --help and spike --print-params to see more")
  rsg = parser.add_argument_group('Random seeds',
                                  'To control random seeds, use at most one '
                                  'of the --start_seed, --seed or --seed_yaml '
                                  'arguments. Since the latter two only give '
                                  'a single seed for each test, they imply '
                                  '--iterations=1.')

  rsg.add_argument("--start_seed", type=read_seed,
                   help=("Randomization seed to use for first iteration of "
                         "each test. Subsequent iterations use seeds "
                         "counting up from there. Cannot be used with "
                         "--seed or --seed_yaml."))
  rsg.add_argument("--seed", type=read_seed,
                   help=("Randomization seed to use for each test. "
                         "Implies --iterations=1. Cannot be used with "
                         "--start_seed or --seed_yaml."))
  rsg.add_argument("--seed_yaml", type=str,
                   help=("Rerun the generator with the seed specification "
                         "from a prior regression. Implies --iterations=1. "
                         "Cannot be used with --start_seed or --seed."))

  args = parser.parse_args()

  if args.seed is not None and args.start_seed is not None:
    logging.error('--start_seed and --seed are mutually exclusive.')
    sys.exit(RET_FAIL)

  if args.seed is not None:
    if args.iterations == 0:
      args.iterations = 1
    elif args.iterations > 1:
      logging.error('--seed is incompatible with setting --iterations '
                    'greater than 1.')
      sys.exit(RET_FAIL)

  return args


def get_full_spike_param_args(spike_params: list[str]):
  return ' '.join(list(map(lambda s: "--param=" + s, spike_params.split(','))))


def load_config(args, cwd):
  """
  Load configuration from the command line and the configuration file.
  Args:
      args:   Parsed command-line configuration
  Returns:
      Loaded configuration dictionary.
  """

  if args.debug:
    args.debug = open(args.debug, "w")
  if not args.csr_yaml:
    args.csr_yaml = cwd + "/yaml/csr_template.yaml"

  if not args.iss_yaml:
    args.iss_yaml = cwd + "/yaml/iss.yaml"

  if not args.simulator_yaml:
    args.simulator_yaml = cwd + "/cva6-simulator.yaml"

  if not args.linker:
    my_link = Path(cwd + f"/../../config/gen_from_riscv_config/{args.target}/linker/link.ld")
    if my_link.is_file():
      args.linker = cwd + f"/../../config/gen_from_riscv_config/{args.target}/linker/link.ld"
    else:
      args.linker = cwd + f"/../../config/gen_from_riscv_config/linker/link.ld"

  # Keep the core_setting_dir option to be backward compatible, suggest to use
  # --custom_target
  if args.core_setting_dir:
    if not args.custom_target:
      args.custom_target = args.core_setting_dir
  else:
    args.core_setting_dir = args.custom_target

  base = ""
  if not args.custom_target:
    if not args.testlist:
      args.testlist = cwd + "/target/"+ args.target +"/testlist.yaml"
    if args.target == "hwconfig":
      base, changes = user_config.parse_derive_args(args.hwconfig_opts.split())
      input_file = f"../../core/include/{base}_config_pkg.sv"
      output_file = "../../core/include/hwconfig_config_pkg.sv"
      user_config.derive_config(input_file, output_file, changes)
      args.hwconfig_opts = user_config.get_config(output_file)
      os.system("mkdir -p ../../config/gen_from_riscv_config/hwconfig/spike")
      os.system("mkdir -p ../../config/gen_from_riscv_config/hwconfig/linker")
      os.system("cp ../../config/gen_from_riscv_config/%s/spike/spike.yaml ../../config/gen_from_riscv_config/hwconfig/spike/" % (base))
      os.system("cp ../../config/gen_from_riscv_config/%s/linker/*.ld ../../config/gen_from_riscv_config/hwconfig/linker/" % (base))
    else:
      base = args.target
    if base in ("cv64a6_imafdch_sv39", "cv64a6_imafdch_sv39_wb"):
      args.mabi = "lp64d"
      args.isa  = "rv64gch_zba_zbb_zbs_zbc"
    elif base in ("cv64a6_imafdc_sv39_wb"):
      args.mabi = "lp64d"
      args.isa  = "rv64gc_zba_zbb_zbs_zbc"
    elif base in ("cv64a6_imafdc_sv39", "cv64a6_imafdc_sv39_hpdcache", "cv64a6_imafdc_sv39_hpdcache_wb"):
      args.mabi = "lp64d"
      args.isa  = "rv64gc_zba_zbb_zbs_zbc_zbkb"
    elif base == "cv32a60x":
      args.mabi = "ilp32"
      args.isa  = "rv32imc_zba_zbb_zbs_zbc"
      args.priv  = "m"
    elif base == "cv32a65x":
      args.mabi = "ilp32"
      args.isa  = "rv32imc_zba_zbb_zbs_zbc"
      args.priv  = "m"
    elif base == "cv64a6_mmu":
      args.mabi = "lp64"
      args.isa  = "rv64imac_zba_zbb_zbs_zbc"
    elif base == "cv32a6_imac_sv0":
      args.mabi = "ilp32"
      args.isa  = "rv32imac"
    elif base == "cv32a6_imac_sv32":
      args.mabi = "ilp32"
      args.isa  = "rv32imac_zbkb"
    elif base == "cv32a6_imafc_sv32":
      args.mabi = "ilp32f"
      args.isa  = "rv32imafc"
    elif base == "rv32imc":
      args.mabi = "ilp32"
      args.isa  = "rv32imc"
    elif base == "rv32imac":
      args.mabi = "ilp32"
      args.isa  = "rv32imac"
    elif base == "rv32ima":
      args.mabi = "ilp32"
      args.isa  = "rv32ima"
    elif base == "rv32gc":
      args.mabi = "ilp32f"
      args.isa  = "rv32gc"
    elif base == "multi_harts":
      args.mabi = "ilp32f"
      args.isa  = "rv32gc"
    elif base == "rv32imcb":
      args.mabi = "ilp32"
      args.isa  = "rv32imcb"
    elif base == "rv32i":
      args.mabi = "ilp32"
      args.isa  = "rv32i"
    elif base == "rv64imc":
      args.mabi = "lp64"
      args.isa  = "rv64imc"
    elif base == "rv64gc":
      args.mabi = "lp64d"
      args.isa  = "rv64gc"
    elif base == "rv64imac":
      args.mabi = "lp64"
      args.isa = "rv64imac"
    elif base == "rv64gcv":
      args.mabi = "lp64d"
      args.isa  = "rv64gcv"
    elif base == "ml":
      args.mabi = "lp64"
      args.isa  = "rv64imc"
    else:
      sys.exit("Unsupported pre-defined target: %0s" % args.target)
    args.core_setting_dir = cwd + "/dv" + "/target/"+ args.isa
  else:
    if re.match(".*gcc_compile.*", args.steps) or re.match(".*iss_sim.*", args.steps):
      if (not args.mabi) or (not args.isa):
        sys.exit("mabi and isa must be specified for custom target %0s" % args.custom_target)
    if not args.testlist:
      args.testlist = args.custom_target + "/testlist.yaml"

  global isa_extension_list
  isa_extension_list = args.isa_extension.split(",")
  if not "g" in args.isa: # LLVM complains if we add zicsr and zifencei when g is set.
    isa_extension_list.append("zicsr")
    isa_extension_list.append("zifencei")

  args.spike_params = get_full_spike_param_args(args.spike_params) if args.spike_params else ""

def incorrect_version_exit(tool, tool_version, required_version):
  if tool == "Spike":
    logging.error(f"Please clean up Spike by executing: rm -r tools/spike verif/core-v-verif/vendor/riscv/riscv-isa-sim/build")
  logging.error(f"You are currently using version {tool_version} of {tool}, should be: {required_version}. Please install or reinstall it with the installation script." )
  sys.exit(RET_FAIL)


def check_cc_version():
  REQUIRED_GCC_VERSION = 11

  cc_path = get_env_var("RISCV_CC")
  cc_version = run_cmd(f"{cc_path} --version")
  cc_version_string = cc_version.split("\n")[0].split(" ")[2]
  cc_version_number = re.split(r'\D+', cc_version_string)

  logging.info(f"GCC Version: {cc_version_string}")

  if int(cc_version_number[0]) < REQUIRED_GCC_VERSION:
    incorrect_version_exit("GCC", cc_version_string, f">={REQUIRED_GCC_VERSION}")


def check_spike_version():
  # Get Spike hash from core-v-verif submodule
  spike_hash = subprocess.run('git log -1 --pretty=tformat:%h', capture_output=True, text=True, shell=True, cwd=os.environ.get("SPIKE_SRC_DIR"))
  spike_version = "1.1.1-dev " + spike_hash.stdout.strip()

  # Get Spike User version
  get_env_var("SPIKE_PATH")
  user_spike_version = subprocess.run("$SPIKE_PATH/spike -v", capture_output=True, text=True, shell=True)
  user_spike_stdout_string = user_spike_version.stdout.strip()
  user_spike_stderr_string = user_spike_version.stderr.strip()

  if user_spike_version.returncode != 0:
    # Re-run 'spike -v' and print contents of stdout and stderr.
    logging.info("Spike version check ('$SPIKE_PATH/spike -v')")
    logging.info(f"- stdout:\n\n{user_spike_stdout_string}\n")
    logging.info(f"- stderr:\n\n{user_spike_stderr_string}")
    # Run 'ldd' on Spike binary and print contents of stdout and stderr.
    spike_ldd = subprocess.run(
        "/bin/ldd $SPIKE_PATH/spike", capture_output=True, text=True, shell=True
    )
    spike_ldd_stdout = spike_ldd.stdout.strip()
    spike_ldd_stderr = spike_ldd.stderr.strip()
    logging.info("Spike LDD check ('ldd $SPIKE_PATH/spike')")
    logging.info(f"- stdout:\n\n{spike_ldd_stdout}\n")
    logging.info(f"- stderr:\n\n{spike_ldd_stderr}")
    # Run 'ls -l' on Spike lib directory and print contents of stdout and stderr.
    spike_lib_ls = subprocess.run(
        "ls -l $SPIKE_PATH/../lib", capture_output=True, text=True, shell=True
    )
    spike_lib_stdout = spike_lib_ls.stdout.strip()
    spike_lib_stderr = spike_lib_ls.stderr.strip()
    logging.info("Stdout of Spike library check ('ls -l $SPIKE_PATH/../lib')")
    logging.info(f"- stdout:\n\n{spike_lib_stdout}\n")
    logging.info(f"- stderr:\n\n{spike_lib_stderr}")

    incorrect_version_exit("Spike", "- unknown -", spike_version)

  logging.info(f"Spike Version: {user_spike_stderr_string}")

  if user_spike_stderr_string != spike_version:
    incorrect_version_exit("Spike", user_spike_stderr_string, spike_version)


def check_verilator_version():
  REQUIRED_VERILATOR_VERSION = "5.008"

  verilator_version_string = run_cmd("verilator --version")
  logging.info(f"Verilator Version: {verilator_version_string.strip()}")
  verilator_version = verilator_version_string.split(" ")[1]

  if REQUIRED_VERILATOR_VERSION != verilator_version:
    incorrect_version_exit("Verilator", verilator_version, REQUIRED_VERILATOR_VERSION)


def check_tools_version():
  check_cc_version()
  check_spike_version()
  check_verilator_version()


def openhw_process_regression_list(testlist, test, iterations, matched_list,
                            riscv_dv_root):
    """ Get the matched tests from the regression test list

    Args:
      testlist      : Regression test list
      test          : Test to run, "all" means all tests in the list
      iterations    : Number of iterations for each test
      riscv_dv_root : Root directory of RISCV-DV

    Returns:
      matched_list : A list of matched tests
    """
    logging.info(
        "Processing regression test list : {}, test: {}".format(testlist, test))
    yaml_data = read_yaml(testlist)
    mult_test = test.split(',')
    if 'testlist' in yaml_data and isinstance(yaml_data['testlist'], list):
        yaml_testlist = yaml_data['testlist']
    else:
        yaml_testlist = yaml_data
    for entry in yaml_testlist:
        if 'import' in entry:
            sub_list = re.sub('<riscv_dv_root>', riscv_dv_root, entry['import'])
            openhw_process_regression_list(sub_list, test, iterations, matched_list,
                                    riscv_dv_root)
        else:
            if (entry['test'] in mult_test) or (test == "all"):
                if iterations > 0 and entry['iterations'] > 0:
                    entry['iterations'] = iterations
                if entry['iterations'] > 0:
                    logging.info("Found matched tests: {}, iterations:{}".format(
                      entry['test'], entry['iterations']))
                    matched_list.append(entry)


def main():
  """This is the main entry point."""
  try:
    global issrun_opts
    global test_iteration
    global log_format
    cwd = os.path.dirname(os.path.realpath(__file__))
    args = parse_args(cwd)
    # We've parsed all the arguments from the command line; default values
    # can be set in the config file. Read that here.
    load_config(args, cwd)

    if args.axi_active == "yes":
      args.issrun_opts = args.issrun_opts + " +uvm_set_config_int=*uvm_test_top,force_axi_mode,1"
    elif args.axi_active == "no":
      args.issrun_opts = args.issrun_opts + " +uvm_set_config_int=uvm_test_top,force_axi_mode,0"

    if args.gen_sv_seed > 0 and args.sv_seed != "1":
      logging.error('You cannot use gen_sv_seed and sv_seed options at the same time')

    if args.gen_sv_seed > 0:
      args.issrun_opts = args.issrun_opts + " +ntb_random_seed_automatic"
      log_format = 1
    elif args.gen_sv_seed == 0:
      args.issrun_opts = args.issrun_opts + " +ntb_random_seed=" + args.sv_seed
      args.gen_sv_seed = 1
      log_format = 0
    else:
      logging.error('gen_sv_seed can not take a negative value')

    log_uvm_seed(args.sv_seed)

    issrun_opts = "\""+args.issrun_opts+"\""

    global isspostrun_opts
    isspostrun_opts = "\""+args.isspostrun_opts+"\""
    global isscomp_opts
    isscomp_opts = "\""+args.isscomp_opts+"\""
    setup_logging(args.verbose)
    logg = logging.getLogger()

    # Check if --iss argument is provided
    if args.iss:
        # Split the string into a list
        args_list = args.iss.split(',')

        # If 'spike' is in the list, move it to the beginning
        if 'spike' in args_list:
            args_list.remove('spike')  # Remove 'spike' from the list
            args_list.insert(0, 'spike')  # Insert 'spike' at the beginning of the list

        # Join the list back into a string
        args.iss = ','.join(args_list)

    check_tools_version()

    # create file handler which logs even debug messages13.1.1
    fh = logging.FileHandler('logfile.log')
    fh.setLevel(logging.DEBUG)
    # create formatter and add it to the handlers
    formatter = logging.Formatter('%(asctime)s %(levelname)-8s %(message)s',datefmt='%a, %d %b %Y %H:%M:%S')
    fh.setFormatter(formatter)
    logg.addHandler(fh)

    # Create output directory
    output_dir = create_output(args.o, args.noclean, cwd+"/out_")

    #add z,s,x extensions to the isa if there are some
    if isa_extension_list !=['']:
      for i in isa_extension_list:
        if i!= "":
          args.isa += (f"_{i}")

    if args.verilog_style_check:
      logging.debug("Run style check")
      style_err = run_cmd("verilog_style/run.sh")
      if style_err: logging.info("Found style error: \nERROR: " + style_err)

    for i in range(args.gen_sv_seed):
      test_executed = 0
      test_iteration = i
      print("")
      logging.info("Iteration number: %s" % (i+1))

      # Run any handcoded/directed tests specified by args
      tests = ""
      if args.c_tests != "":
        tests = args.c_tests.split(',')
      elif args.elf_tests != "":
        tests = args.elf_tests.split(',')
      elif args.asm_tests != "":
        tests = args.asm_tests.split(',')
      if tests !=  "":
        for path_test in tests:
          full_path = os.path.expanduser(path_test)
          # path_c_test is a c file
          if os.path.isfile(full_path) or args.debug:
            run_test(full_path, args.iss_yaml, args.isa, args.target, args.mabi, args.gcc_opts,
                  args.iss, output_dir, args.core_setting_dir, args.debug, args.linker,
                  args.priv, args.spike_params, iss_timeout=args.iss_timeout)
          else:
            logging.error('%s does not exist or is not a file' % full_path)
            sys.exit(RET_FAIL)
          test_executed = 1

      run_cmd_output(["mkdir", "-p", ("%s/asm_tests" % output_dir)])
      # Process regression test list
      matched_list = []
      # Any tests in the YAML test list that specify a directed assembly test
      asm_directed_list = []
      # Any tests in the YAML test list that specify a directed c test
      c_directed_list = []

      if test_executed ==0:
        if not args.co:
          openhw_process_regression_list(args.testlist, args.test, args.iterations, matched_list, cwd)
          logging.info('CVA6 Configuration is %s and target is %s'% (args.hwconfig_opts, args.target))
          for entry in list(matched_list):
            yaml_needs = entry["needs"] if "needs" in entry else []
            if yaml_needs:
              needs = dict()
              for i in range(len(yaml_needs)):
                needs.update(yaml_needs[i])
              for keys in needs.keys():
                if args.hwconfig_opts[keys] != needs[keys]:
                  logging.info('Removing test %s CVA6 configuration can not run it' % entry['test'])
                  matched_list.remove(entry)
                  break
          for t in list(matched_list):
            try:
              t['gcc_opts'] = re.sub(r"\<path_var\>", get_env_var(t['path_var']), t['gcc_opts'])
            except KeyError:
              continue

            # Check mutual exclusive between gen_test, asm_tests, and c_tests
            if 'asm_tests' in t:
              if 'gen_test' in t or 'c_tests' in t:
                logging.error('asm_tests must not be defined in the testlist '
                              'together with the gen_test or c_tests field')
                sys.exit(RET_FATAL)
              t['asm_tests'] = re.sub(r"\<path_var\>", get_env_var(t['path_var']), t['asm_tests'])
              asm_directed_list.append(t)
              matched_list.remove(t)

            if 'c_tests' in t:
              if 'gen_test' in t or 'asm_tests' in t:
                logging.error('c_tests must not be defined in the testlist '
                              'together with the gen_test or asm_tests field')
                sys.exit(RET_FATAL)
              t['c_tests'] = re.sub(r"\<path_var\>", get_env_var(t['path_var']), t['c_tests'])
              c_directed_list.append(t)
              matched_list.remove(t)

          if len(matched_list) == 0 and len(asm_directed_list) == 0 and len(c_directed_list) == 0:
            sys.exit("Cannot find %s in %s" % (args.test, args.testlist))

          for t in c_directed_list:
            copy = re.sub(r'(.*)\/(.*).c$', r'cp \1/\2.c \1/', t['c_tests'])+t['test']+'.c'
            run_cmd("%s" % copy)
            t['c_tests'] = re.sub(r'(.*)\/(.*).c$', r'\1/', t['c_tests'])+t['test']+'.c'

      directed_tests_list = asm_directed_list + c_directed_list
      # Run instruction generator
      if args.steps == "all" or re.match(".*gen.*", args.steps):
        # Run any handcoded/directed tests specified in YAML format
        if len(directed_tests_list) != 0:
          for test_entry in asm_directed_list:
            gcc_opts = args.gcc_opts
            gcc_opts += test_entry.get('gcc_opts', '')
            path_test = os.path.expanduser(test_entry.get('asm_tests'))
            if path_test:
              # path_test is an assembly file
              if os.path.isfile(path_test):
                run_test(path_test, args.iss_yaml, args.isa, args.target, args.mabi, gcc_opts,
                             args.iss, output_dir, args.core_setting_dir, args.debug, args.linker,
                             args.priv, args.spike_params, test_entry['test'], iss_timeout=args.iss_timeout, testlist=args.testlist)
              else:
                if not args.debug:
                  logging.error('%s does not exist' % path_test)
                  sys.exit(RET_FAIL)

        # Run remaining tests using the instruction generator
        gen(matched_list, args, output_dir, cwd)

      if not args.co:
        # Compile the assembly program to ELF, convert to plain binary
        if args.steps == "all" or re.match(".*gcc_compile.*", args.steps):
          gcc_compile(matched_list, output_dir, args.isa, args.mabi,
                      args.gcc_opts, args.debug, args.linker)

        # Run ISS simulation
        if args.steps == "all" or re.match(".*iss_sim.*", args.steps):
          iss_sim(matched_list, output_dir, args.iss, args.iss_yaml, args.iss_opts,
                  args.isa, args.target, args.core_setting_dir, args.iss_timeout, args.debug,
                  args.priv, args.spike_params)

        # Compare ISS simulation result
        if args.steps == "all" or re.match(".*iss_cmp.*", args.steps):
          iss_cmp(matched_list, args.iss, args.target, output_dir, args.stop_on_first_error,
                  args.exp, args.debug)

    sys.exit(RET_SUCCESS)
  except KeyboardInterrupt:
    logging.info("\nExited Ctrl-C from user request.")
    sys.exit(130)

if __name__ == "__main__":
  sys.path.append(os.getcwd()+"/../../util")
  import user_config
  main()
