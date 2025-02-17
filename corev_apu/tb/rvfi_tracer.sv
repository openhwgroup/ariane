// Copyright 2020 Thales DIS design services SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Jean-Roch COULON - Thales
//
`ifndef READ_SYMBOL_T
`define READ_SYMBOL_T
import "DPI-C" function byte read_symbol (input string symbol_name, inout longint unsigned address);
`endif

`ifndef READ_ELF_T
`define READ_ELF_T
import "DPI-C" function void read_elf(input string filename);
import "DPI-C" function byte get_section(output longint address, output longint len);
import "DPI-C" context function void read_section_sv(input longint address, inout byte buffer[]);
`endif


module rvfi_tracer #(
  parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
  parameter type rvfi_instr_t = logic,
  parameter type rvfi_csr_t = logic,
  //
  parameter logic [7:0] HART_ID      = '0,
  parameter int unsigned DEBUG_START = 0,
  parameter int unsigned DEBUG_STOP  = 0
)(
  input logic                           clk_i,
  input logic                           rst_ni,
  input rvfi_instr_t[CVA6Cfg.NrCommitPorts-1:0] rvfi_i,
  input rvfi_csr_t                      rvfi_csr_i,
  output logic[31:0]                    end_of_test_o
);

  longint unsigned TOHOST_ADDR;
  string binary;
  int f;
  int unsigned SIM_FINISH;
  initial begin
    TOHOST_ADDR = '0;
    f = $fopen($sformatf("trace_rvfi_hart_%h.dasm", HART_ID), "w");
    if (!$value$plusargs("time_out=%d", SIM_FINISH)) SIM_FINISH = 2000000;
    if (!$value$plusargs("tohost_addr=%h", TOHOST_ADDR)) TOHOST_ADDR = '0;
    if (TOHOST_ADDR == '0) begin
        if (!$value$plusargs("elf_file=%s", binary)) binary = "";
        if (binary != "") begin
            read_elf(binary);
            read_symbol("tohost", TOHOST_ADDR);
        end
        $display("*** [rvf_tracer] INFO: Loading binary : %s", binary);
        $display("*** [rvf_tracer] INFO: tohost_addr: %h", TOHOST_ADDR);
        if (TOHOST_ADDR == '0) begin
            $display("*** [rvf_tracer] WARNING: No valid address of 'tohost' (tohost == 0x%h), termination possible only by timeout or Ctrl-C!\n", TOHOST_ADDR);
            $fwrite(f, "*** [rvfi_tracer] WARNING No valid address of 'tohost' (tohost == 0x%h), termination possible only by timeout or Ctrl-C!\n", TOHOST_ADDR);
        end
    end
  end

  final $fclose(f);

  logic [31:0] cycles;
  // Generate the trace based on RVFI
  logic [63:0] pc64;
  string cause;
  logic[31:0] end_of_test_q;
  logic[31:0] end_of_test_d;

  assign end_of_test_o = end_of_test_d;

  always_ff @(posedge clk_i) begin
    end_of_test_q <= (rst_ni && (end_of_test_d[0] == 1'b1)) ? end_of_test_d : 0;
    for (int i = 0; i < CVA6Cfg.NrCommitPorts; i++) begin
      pc64 = {{CVA6Cfg.XLEN-CVA6Cfg.VLEN{rvfi_i[i].pc_rdata[CVA6Cfg.VLEN-1]}}, rvfi_i[i].pc_rdata};
      // print the instruction information if the instruction is valid or a trap is taken
      if (rvfi_i[i].valid) begin
        // Instruction information
        if (rvfi_i[i].intr[2]) begin
           $fwrite(f, "core   INTERRUPT 0: 0x%h (0x%h) DASM(%h)\n",
             pc64, rvfi_i[i].insn, rvfi_i[i].insn);
        end
        else begin
           $fwrite(f, "core   0: 0x%h (0x%h) DASM(%h)\n",
             pc64, rvfi_i[i].insn, rvfi_i[i].insn);
        end
        // Destination register information
        if (rvfi_i[i].insn[1:0] != 2'b11) begin
          $fwrite(f, "%h 0x%h (0x%h)",
            rvfi_i[i].mode, pc64, rvfi_i[i].insn[15:0]);
        end else begin
          $fwrite(f, "%h 0x%h (0x%h)",
            rvfi_i[i].mode, pc64, rvfi_i[i].insn);
        end
        // Decode instruction to know if destination register is FP register.
        // Handle both uncompressed and compressed instructions.
        if ( rvfi_i[i].insn[6:0] == 7'b1001111 ||
             rvfi_i[i].insn[6:0] == 7'b1001011 ||
             rvfi_i[i].insn[6:0] == 7'b1000111 ||
             rvfi_i[i].insn[6:0] == 7'b1000011 ||
             rvfi_i[i].insn[6:0] == 7'b0000111 ||
            (rvfi_i[i].insn[6:0] == 7'b1010011 && rvfi_i[i].insn[31:26] != 6'b111000
                                               && rvfi_i[i].insn[31:26] != 6'b101000
                                               && rvfi_i[i].insn[31:26] != 6'b110000) ||
            (rvfi_i[i].insn[0] == 1'b0 && ((rvfi_i[i].insn[15:13] == 3'b001 && CVA6Cfg.XLEN == 64) ||
                                           (rvfi_i[i].insn[15:13] == 3'b011 && CVA6Cfg.XLEN == 32) ))) begin
          $fwrite(f, " f%d 0x%h", rvfi_i[i].rd_addr, rvfi_i[i].rd_wdata);
        end else if (rvfi_i[i].rd_addr != 0) begin
          $fwrite(f, " x%d 0x%h", rvfi_i[i].rd_addr, rvfi_i[i].rd_wdata);
          if (rvfi_i[i].mem_rmask != 0) begin
            $fwrite(f, " mem 0x%h", rvfi_i[i].mem_addr);
          end
        end else begin
          if (rvfi_i[i].mem_wmask != 0) begin
            $fwrite(f, " mem 0x%h 0x%h", rvfi_i[i].mem_addr, rvfi_i[i].mem_wdata);
            if (TOHOST_ADDR != '0 &&
                rvfi_i[i].mem_paddr == TOHOST_ADDR &&
                rvfi_i[i].mem_wdata[0] == 1'b1) begin
              end_of_test_q <= rvfi_i[i].mem_wdata[31:0];
              $display("*** [rvfi_tracer] INFO: Simulation terminated after %d cycles!\n", cycles);
            end
          end
        end
        $fwrite(f, "\n");
      end else begin
        if (rvfi_i[i].trap) begin
          case (rvfi_i[i].cause)
            32'h0: cause = "INSTR_ADDR_MISALIGNED";
            32'h1: cause = "INSTR_ACCESS_FAULT";
            32'h2: cause = "ILLEGAL_INSTR";
            32'h3: cause = "BREAKPOINT";
            32'h4: cause = "LD_ADDR_MISALIGNED";
            32'h5: cause = "LD_ACCESS_FAULT";
            32'h6: cause = "ST_ADDR_MISALIGNED";
            32'h7: cause = "ST_ACCESS_FAULT";
            32'hb: cause = "ENV_CALL_MMODE";
          endcase;
          if (rvfi_i[i].insn[1:0] != 2'b11) begin
            $fwrite(f, "%s exception @ 0x%h (0x%h)\n", cause, pc64, rvfi_i[i].insn[15:0]);
          end else begin
            $fwrite(f, "%s exception @ 0x%h (0x%h)\n", cause, pc64, rvfi_i[i].insn);
          end
        end
      end
    end

    if (~rst_ni)
      cycles <= 0;
    else
      cycles <= cycles+1;
    if (cycles > SIM_FINISH)
      end_of_test_q <= 32'hffff_ffff;

    end_of_test_d <= end_of_test_q;
  end


  // Trace any custom signals
  // Define signals to be traced by adding them into debug and name arrays
  string name[0:10];
  logic[63:0] debug[0:10], debug_previous[0:10];

  always_ff @(posedge clk_i) begin
    if (cycles > DEBUG_START && cycles < DEBUG_STOP)
      for (int index = 0; index < 100; index++)
        if (debug_previous[index] != debug[index])
          $fwrite(f, "%d %s %x\n", cycles, name[index], debug[index]);
    debug_previous <= debug;
  end

endmodule // rvfi_tracer
