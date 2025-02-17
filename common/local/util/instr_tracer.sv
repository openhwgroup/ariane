// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: Florian Zaruba, ETH Zurich
// Date: 16.05.2017
// Description: Instruction Tracer Main Class

`ifndef VERILATOR
//pragma translate_off
`include "ex_trace_item.svh"
`include "instr_trace_item.svh"

module instr_tracer #(
  parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
  parameter type bp_resolve_t = logic,
  parameter type scoreboard_entry_t = logic[303:0], // Fix for xcelium bug at runtime: does not have enough memory space reserved for scoreboard_entry
  parameter type interrupts_t = logic,
  parameter type exception_t = logic,
  parameter interrupts_t INTERRUPTS = '0
)(
  input logic                                          pck,
  input logic                                          rstn,
  input logic                                          flush_unissued,
  input logic                                          flush_all,
  input logic [31:0]                                   instruction,
  input logic                                          fetch_valid,
  input logic                                          fetch_ack,
  input logic                                          issue_ack, // issue acknowledged
  input scoreboard_entry_t                             issue_sbe, // issue scoreboard entry
  input logic [CVA6Cfg.NrCommitPorts-1:0][4:0]         waddr, // WB stage
  input logic [CVA6Cfg.NrCommitPorts-1:0][63:0]        wdata,
  input logic [CVA6Cfg.NrCommitPorts-1:0]              we_gpr,
  input logic [CVA6Cfg.NrCommitPorts-1:0]              we_fpr,
  input scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr, // commit instruction
  input logic [CVA6Cfg.NrCommitPorts-1:0]              commit_ack,
  input logic                                          st_valid,   // stores - address translation
  input logic [CVA6Cfg.PLEN-1:0]                       st_paddr,
  input logic                                          ld_valid, // loads
  input logic                                          ld_kill,
  input logic [CVA6Cfg.PLEN-1:0]                       ld_paddr,
  input bp_resolve_t                                   resolve_branch, // misprediction
  input exception_t                                    commit_exception,
  input riscv::priv_lvl_t                              priv_lvl, // current privilege level
  input logic                                          debug_mode,

  input logic[CVA6Cfg.XLEN-1:0]                        hart_id_i
);

  // keep the decoded instructions in a queue
  logic [31:0] decode_queue [$];
  // keep the issued instructions in a queue
  logic [31:0] issue_queue [$];
  // issue scoreboard entries
  scoreboard_entry_t issue_sbe_queue [$];
  scoreboard_entry_t issue_sbe_item;
  // store resolved branches, get (mis-)predictions
  bp_resolve_t bp [$];
  // shadow copy of the register files
  logic [63:0] gp_reg_file [32];
  logic [63:0] fp_reg_file [32];
  // 64 bit clock tick count
  longint unsigned clk_ticks;
  int f, commit_log;
  // address mapping
  // contains mappings of the form vaddr <-> paddr
  logic [63:0] store_mapping[$], load_mapping[$], address_mapping;

  // static uvm_cmdline_processor uvcl = uvm_cmdline_processor::get_inst();

  function void create_file(logic [63:0] hart_id);
    string fn, fn_commit_log;
    $sformat(fn, "trace_hart_%0.0f.log", hart_id);
    $sformat(fn_commit_log, "trace_hart_%0.0f_commit.log", hart_id);
    $display("[TRACER] Output filename is: %s", fn);

    f = $fopen(fn,"w");
    if (ariane_pkg::ENABLE_SPIKE_COMMIT_LOG) commit_log = $fopen(fn_commit_log, "w");
  endfunction : create_file

  task trace();
    automatic logic [31:0] decode_instruction, issue_instruction, issue_commit_instruction;
    automatic scoreboard_entry_t commit_instruction;
    // initialize register 0
    gp_reg_file  = '{default:0};
    fp_reg_file  = '{default:0};

    forever begin
      automatic bp_resolve_t bp_instruction = '0;
      // new cycle, we are only interested if reset is de-asserted
      @(pck) if (rstn !== 1'b1) begin
        flush();
        continue;
      end

      // increment clock tick
      clk_ticks++;

      // -------------------
      // Instruction Decode
      // -------------------
      // we are decoding an instruction
      if (fetch_valid && fetch_ack) begin
        decode_instruction = instruction;
        decode_queue.push_back(decode_instruction);
      end
      // -------------------
      // Instruction Issue
      // -------------------
      // we got a new issue ack, so put the element from the decode queue to
      // the issue queue
      if (issue_ack && !flush_unissued) begin
        issue_instruction = decode_queue.pop_front();
        issue_queue.push_back(issue_instruction);
        // also save the scoreboard entry to a separate issue queue
        issue_sbe_queue.push_back(scoreboard_entry_t'(issue_sbe));
      end

      // --------------------
      // Address Translation
      // --------------------
      if (st_valid) begin
        store_mapping.push_back(st_paddr);
      end

      if (ld_valid && !ld_kill) begin
        load_mapping.push_back(ld_paddr);
      end
      // ----------------------
      // Store predictions
      // ----------------------
      if (resolve_branch.valid) begin
        bp.push_back(resolve_branch);
      end
      // --------------
      //  Commit
      // --------------
      // we are committing an instruction
      for (int i = 0; i < 2; i++) begin
        if (commit_ack[i]) begin
          commit_instruction = scoreboard_entry_t'(commit_instr[i]);
          issue_commit_instruction = issue_queue.pop_front();
          issue_sbe_item = issue_sbe_queue.pop_front();
          // check if the instruction retiring is a load or store, get the physical address accordingly
          if (commit_instr[i].fu == ariane_pkg::LOAD)
            address_mapping = load_mapping.pop_front();
          else if (commit_instr[i].fu == ariane_pkg::STORE)
            address_mapping = store_mapping.pop_front();

          if (commit_instr[i].fu == ariane_pkg::CTRL_FLOW)
            bp_instruction = bp.pop_front();
          // the scoreboards issue entry still contains the immediate value as a result
          // check if the write back is valid, if not we need to source the result from the register file
          // as the most recent version of this register will be there.
          if (we_gpr[i] || we_fpr[i]) begin
            printInstr(issue_sbe_item, issue_commit_instruction, wdata[i], address_mapping, priv_lvl, debug_mode, bp_instruction);
          end else if (ariane_pkg::is_rd_fpr(commit_instruction.op)) begin
            printInstr(issue_sbe_item, issue_commit_instruction, fp_reg_file[commit_instruction.rd], address_mapping, priv_lvl, debug_mode, bp_instruction);
          end else begin
            printInstr(issue_sbe_item, issue_commit_instruction, gp_reg_file[commit_instruction.rd], address_mapping, priv_lvl, debug_mode, bp_instruction);
          end
        end
      end
      // --------------
      // Exceptions
      // --------------
      if (commit_exception.valid && !(debug_mode && commit_exception.cause == riscv::BREAKPOINT)) begin
        // print exception
        printException(commit_instr[0].pc, commit_exception.cause, commit_exception.tval);
      end
      // ----------------------
      // Commit Registers
      // ----------------------
      // update shadow reg files here
      for (int i = 0; i < 2; i++) begin
        if (we_gpr[i] && waddr[i] != 5'b0) begin
          gp_reg_file[waddr[i]] = wdata[i];
        end else if (we_fpr[i]) begin
          fp_reg_file[waddr[i]] = wdata[i];
        end
      end
      // --------------
      // Flush Signals
      // --------------
      // flush un-issued instructions
      if (flush_unissued) begin
        flushDecode();
      end
      // flush whole pipeline
      if (flush_all) begin
        flush();
      end
    end

  endtask

  // flush all decoded instructions
  function void flushDecode ();
    decode_queue = {};
  endfunction

  // flush everything, we took an exception/interrupt
  function void flush ();
    flushDecode();
    // clear all elements in the queue
    issue_queue     = {};
    issue_sbe_queue = {};
    // also clear mappings
    store_mapping   = {};
    load_mapping    = {};
    bp              = {};
  endfunction

  function void printInstr(scoreboard_entry_t sbe, logic [31:0] instr, logic [63:0] result, logic [CVA6Cfg.PLEN-1:0] paddr, riscv::priv_lvl_t priv_lvl, logic debug_mode, bp_resolve_t bp);
    automatic instr_trace_item #(
      .CVA6Cfg(CVA6Cfg),
      .bp_resolve_t(bp_resolve_t),
      .scoreboard_entry_t(scoreboard_entry_t)
    ) iti = new ($time, clk_ticks, sbe, instr, gp_reg_file, fp_reg_file, result, paddr, priv_lvl, debug_mode, bp);
    // print instruction to console
    automatic string print_instr = iti.printInstr();
    if (ariane_pkg::ENABLE_SPIKE_COMMIT_LOG && !debug_mode) begin
      $fwrite(commit_log, riscv::spikeCommitLog(sbe.pc, priv_lvl, instr, sbe.rd, result, ariane_pkg::is_rd_fpr(sbe.op)));
    end
    $fwrite(f, {print_instr, "\n"});
  endfunction

  function void printException(logic [CVA6Cfg.VLEN-1:0] pc, logic [63:0] cause, logic [63:0] tval);
    automatic ex_trace_item #(
      .CVA6Cfg(CVA6Cfg),
      .interrupts_t(interrupts_t),
      .INTERRUPTS(INTERRUPTS)
    ) eti = new (pc, cause, tval);
    automatic string print_ex = eti.printException();
    $fwrite(f, {print_ex, "\n"});
  endfunction

  function void close();
    if (f) $fclose(f);
    if (ariane_pkg::ENABLE_SPIKE_COMMIT_LOG && commit_log) $fclose(commit_log);
  endfunction


  initial begin
    #15ns;
    create_file(hart_id_i);
    trace();
  end

  final begin
    close();
  end

endmodule : instr_tracer
//pragma translate_on
`endif
