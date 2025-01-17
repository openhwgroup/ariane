// Copyright 2018 - 2019 ETH Zurich and University of Bologna.
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
// Date: 26.10.2018sim:/ariane_tb/dut/i_ariane/i_frontend/icache_ex_valid_q

// Description: Instruction Queue, separates instruction front-end from processor
//              back-end.
//
// This is an optimized instruction queue which supports the handling of
// compressed instructions (16 bit instructions). Internally it is organized as
// FETCH_ENTRY x 32 bit queues which are filled in a consecutive manner. Two pointers
// point into (`idx_is_q` and `idx_ds_q`) the fill port and the read port. The read port
// is designed so that it will easily allow for multiple issue implementation.
// The input supports arbitrary power of two instruction fetch widths.
//
// The queue supports handling of branch prediction and will take care of
// only saving a valid instruction stream.
//
// Furthermore it contains a replay interface in case the instruction queue
// is already full. As instructions are in general easily replayed this should
// increase the efficiency as I$ misses are potentially hidden. This stands in
// contrast to pessimistic actions (early stalling) or credit based approaches.
// Credit based systems might be difficult to implement with the current system
// as we do not exactly know how much space we are going to need in the fifos
// as each instruction can take either one or two slots.
//
// So the consumed/valid interface degenerates to a `information` interface. If the
// upstream circuits keeps pushing the queue will discard the information
// and start replaying from the point were it could last manage to accept instructions.
//
// The instruction front-end will stop issuing instructions as soon as the
// fifo is full. This will gate the logic if the processor is e.g.: halted
//
// TODO(zarubaf): The instruction queues can be reduced to 16 bit. Potentially
// the replay mechanism gets more complicated as it can be that a 32 bit instruction
// can not be pushed at once.

module instr_queue
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type fetch_entry_t = logic
) (
    // Subsystem Clock - SUBSYSTEM
    input logic clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input logic rst_ni,
    // Fetch flush request - CONTROLLER
    input logic flush_i,
    // Instruction - instr_realign
    input logic [CVA6Cfg.INSTR_PER_FETCH-1:0][31:0] instr_i,
    // Instruction address - instr_realign
    input logic [CVA6Cfg.INSTR_PER_FETCH-1:0][CVA6Cfg.VLEN-1:0] addr_i,
    // Instruction is valid - instr_realign
    input logic [CVA6Cfg.INSTR_PER_FETCH-1:0] valid_i,
    // Handshake’s ready with CACHE - CACHE
    output logic ready_o,
    // Indicates instructions consummed, or popped by ID_STAGE - FRONTEND
    output logic [CVA6Cfg.INSTR_PER_FETCH-1:0] consumed_o,
    // Exception (which is page-table fault) - CACHE
    input ariane_pkg::frontend_exception_t exception_i,
    // Exception address - CACHE
    input logic [CVA6Cfg.VLEN-1:0] exception_addr_i,
    input logic [CVA6Cfg.GPLEN-1:0] exception_gpaddr_i,
    input logic [31:0] exception_tinst_i,
    input logic exception_gva_i,
    // Branch predict - FRONTEND
    input logic [CVA6Cfg.VLEN-1:0] predict_address_i,
    // Instruction predict address - FRONTEND
    input ariane_pkg::cf_t [CVA6Cfg.INSTR_PER_FETCH-1:0] cf_type_i,
    // Replay instruction because one of the FIFO was  full - FRONTEND
    output logic replay_o,
    // Address at which to replay the fetch - FRONTEND
    output logic [CVA6Cfg.VLEN-1:0] replay_addr_o,
    // Handshake’s data with ID_STAGE - ID_STAGE
    output fetch_entry_t [CVA6Cfg.NrIssuePorts-1:0] fetch_entry_o,
    // Handshake’s valid with ID_STAGE - ID_STAGE
    output logic [CVA6Cfg.NrIssuePorts-1:0] fetch_entry_valid_o,
    // Handshake’s ready with ID_STAGE - ID_STAGE
    input logic [CVA6Cfg.NrIssuePorts-1:0] fetch_entry_ready_i
);

  // Calculate next index based on whether superscalar is enabled or not.
  localparam NID = CVA6Cfg.SuperscalarEn ? 1 : 0;

  typedef struct packed {
    logic [31:0]                     instr;      // instruction word
    ariane_pkg::cf_t                 cf;         // branch was taken
    ariane_pkg::frontend_exception_t ex;         // exception happened
    logic [CVA6Cfg.VLEN-1:0]         ex_vaddr;   // lower VLEN bits of tval for exception
    logic [CVA6Cfg.GPLEN-1:0]        ex_gpaddr;  // lower GPLEN bits of tval2 for exception
    logic [31:0]                     ex_tinst;   // tinst of exception
    logic                            ex_gva;
  } instr_data_t;

  logic [CVA6Cfg.LOG2_INSTR_PER_FETCH-1:0] branch_index;
  // instruction queues
  instr_data_t [CVA6Cfg.INSTR_PER_FETCH-1:0] instr_data_in, instr_data_out;
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0] push_instr, push_instr_fifo;
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0] pop_instr;
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0] instr_queue_full;
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0] instr_queue_empty;
  logic                               instr_overflow;
  // address queue
  logic [           CVA6Cfg.VLEN-1:0] address_out;
  logic                               pop_address;
  logic                               push_address;
  logic                               full_address;
  logic                               address_overflow;
  // input stream counter
  logic [CVA6Cfg.LOG2_INSTR_PER_FETCH-1:0] idx_is_d, idx_is_q;

  // Registers
  // output FIFO select, one-hot
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0] idx_ds_d, idx_ds_q;
  // rotated by N
  logic [CVA6Cfg.NrIssuePorts:0][CVA6Cfg.INSTR_PER_FETCH-1:0] idx_ds;

  logic [CVA6Cfg.VLEN-1:0] pc_d, pc_q;  // current PC
  logic [CVA6Cfg.NrIssuePorts:0][CVA6Cfg.VLEN-1:0] pc_j;
  logic reset_address_d, reset_address_q;  // we need to re-set the address because of a flush

  logic [CVA6Cfg.NrIssuePorts-1:0] fetch_entry_is_cf, fetch_entry_fire;

  logic [CVA6Cfg.INSTR_PER_FETCH*2-2:0] branch_mask_extended;
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0] branch_mask;
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0] taken;
  // shift amount, e.g.: instructions we want to retire
  logic [CVA6Cfg.LOG2_INSTR_PER_FETCH:0] popcount;
  logic [CVA6Cfg.LOG2_INSTR_PER_FETCH-1:0] shamt;
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0] valid;
  logic [CVA6Cfg.INSTR_PER_FETCH*2-1:0] consumed_extended;
  // FIFO mask
  logic [CVA6Cfg.INSTR_PER_FETCH*2-1:0] fifo_pos_extended;
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0] fifo_pos;
  logic [CVA6Cfg.INSTR_PER_FETCH*2-1:0][31:0] instr;
  ariane_pkg::cf_t [CVA6Cfg.INSTR_PER_FETCH*2-1:0] cf;
  // replay interface
  logic [CVA6Cfg.INSTR_PER_FETCH-1:0] instr_overflow_fifo;

  assign ready_o = ~(|instr_queue_full) & ~full_address;

  if (CVA6Cfg.RVC) begin : gen_multiple_instr_per_fetch_with_C

    for (genvar i = 0; i < CVA6Cfg.INSTR_PER_FETCH; i++) begin : gen_unpack_taken
      assign taken[i] = cf_type_i[i] != ariane_pkg::NoCF;
    end

    // calculate a branch mask, e.g.: get the first taken branch
    lzc #(
        .WIDTH(CVA6Cfg.INSTR_PER_FETCH),
        .MODE (0)                         // count trailing zeros
    ) i_lzc_branch_index (
        .in_i   (taken),         // we want to count trailing zeros
        .cnt_o  (branch_index),  // first branch on branch_index
        .empty_o()
    );


    // the first index is for sure valid
    // for example (64 bit fetch):
    // taken mask: 0 1 1 0
    // leading zero count = 1
    // 0 0 0 1, 1 1 1 << 1 = 0 0 1 1, 1 1 0
    // take the upper 4 bits: 0 0 1 1
    assign branch_mask_extended = {{{CVA6Cfg.INSTR_PER_FETCH-1}{1'b0}}, {{CVA6Cfg.INSTR_PER_FETCH}{1'b1}}} << branch_index;
    assign branch_mask = branch_mask_extended[CVA6Cfg.INSTR_PER_FETCH * 2 - 2:CVA6Cfg.INSTR_PER_FETCH - 1];

    // mask with taken branches to get the actual amount of instructions we want to push
    assign valid = valid_i & branch_mask;
    // rotate right again
    assign consumed_extended = {push_instr_fifo, push_instr_fifo} >> idx_is_q;
    assign consumed_o = consumed_extended[CVA6Cfg.INSTR_PER_FETCH-1:0];
    // count the numbers of valid instructions we've pushed from this package
    popcount #(
        .INPUT_WIDTH(CVA6Cfg.INSTR_PER_FETCH)
    ) i_popcount (
        .data_i    (push_instr_fifo),
        .popcount_o(popcount)
    );
    assign shamt = popcount[$bits(shamt)-1:0];

    // save the shift amount for next cycle
    assign idx_is_d = idx_is_q + shamt;

    // ----------------------
    // Input interface
    // ----------------------
    // rotate left by the current position
    assign fifo_pos_extended = {valid, valid} << idx_is_q;
    // we just care about the upper bits
    assign fifo_pos = fifo_pos_extended[CVA6Cfg.INSTR_PER_FETCH*2-1:CVA6Cfg.INSTR_PER_FETCH];
    // the fifo_position signal can directly be used to guide the push signal of each FIFO
    // make sure it is not full
    assign push_instr = fifo_pos & ~instr_queue_full;

    // duplicate the entries for easier selection e.g.: 3 2 1 0 3 2 1 0
    for (genvar i = 0; i < CVA6Cfg.INSTR_PER_FETCH; i++) begin : gen_duplicate_instr_input
      assign instr[i] = instr_i[i];
      assign instr[i+CVA6Cfg.INSTR_PER_FETCH] = instr_i[i];
      assign cf[i] = cf_type_i[i];
      assign cf[i+CVA6Cfg.INSTR_PER_FETCH] = cf_type_i[i];
    end

    // shift the inputs
    for (genvar i = 0; i < CVA6Cfg.INSTR_PER_FETCH; i++) begin : gen_fifo_input_select
      /* verilator lint_off WIDTH */
      assign instr_data_in[i].instr = instr[CVA6Cfg.INSTR_PER_FETCH+i-idx_is_q];
      assign instr_data_in[i].cf = cf[CVA6Cfg.INSTR_PER_FETCH+i-idx_is_q];
      assign instr_data_in[i].ex = exception_i;  // exceptions hold for the whole fetch packet
      assign instr_data_in[i].ex_vaddr = exception_addr_i;
      if (CVA6Cfg.RVH) begin : gen_hyp_ex_with_C
        assign instr_data_in[i].ex_gpaddr = exception_gpaddr_i;
        assign instr_data_in[i].ex_tinst = exception_tinst_i;
        assign instr_data_in[i].ex_gva = exception_gva_i;
      end else begin : gen_no_hyp_ex_with_C
        assign instr_data_in[i].ex_gpaddr = '0;
        assign instr_data_in[i].ex_tinst = '0;
        assign instr_data_in[i].ex_gva = 1'b0;
      end
      /* verilator lint_on WIDTH */
    end
  end else begin : gen_multiple_instr_per_fetch_without_C

    assign taken = '0;
    assign branch_index = '0;
    assign branch_mask_extended = '0;
    assign branch_mask = '0;
    assign consumed_extended = '0;
    assign fifo_pos_extended = '0;
    assign fifo_pos = '0;
    assign instr = '0;
    assign popcount = '0;
    assign shamt = '0;
    assign valid = '0;


    assign consumed_o = push_instr_fifo[0];
    // ----------------------
    // Input interface
    // ----------------------
    assign push_instr = valid_i & ~instr_queue_full;

    /* verilator lint_off WIDTH */
    assign instr_data_in[0].instr = instr_i[0];
    assign instr_data_in[0].cf = cf_type_i[0];
    assign instr_data_in[0].ex = exception_i;  // exceptions hold for the whole fetch packet
    assign instr_data_in[0].ex_vaddr = exception_addr_i;
    if (CVA6Cfg.RVH) begin : gen_hyp_ex_without_C
      assign instr_data_in[0].ex_gpaddr = exception_gpaddr_i;
      assign instr_data_in[0].ex_tinst = exception_tinst_i;
      assign instr_data_in[0].ex_gva = exception_gva_i;
    end else begin : gen_no_hyp_ex_without_C
      assign instr_data_in[0].ex_gpaddr = '0;
      assign instr_data_in[0].ex_tinst = '0;
      assign instr_data_in[0].ex_gva = 1'b0;
    end
    /* verilator lint_on WIDTH */
  end

  // ----------------------
  // Replay Logic
  // ----------------------
  // We need to replay a instruction fetch iff:
  // 1. One of the instruction data FIFOs was full and we needed it
  // (e.g.: we pushed and it was full)
  // 2. The address/branch predict FIFO was full
  // if one of the FIFOs was full we need to replay the faulting instruction
  if (CVA6Cfg.RVC == 1'b1) begin : gen_instr_overflow_fifo_with_C
    assign instr_overflow_fifo = instr_queue_full & fifo_pos;
  end else begin : gen_instr_overflow_fifo_without_C
    assign instr_overflow_fifo = instr_queue_full & valid_i;
  end
  assign instr_overflow = |instr_overflow_fifo;  // at least one instruction overflowed
  assign address_overflow = full_address & push_address;
  assign replay_o = instr_overflow | address_overflow;

  if (CVA6Cfg.RVC) begin : gen_replay_addr_o_with_c
    // select the address, in the case of an address fifo overflow just
    // use the base of this package
    // if we successfully pushed some instructions we can output the next instruction
    // which we didn't manage to push
    assign replay_addr_o = (address_overflow) ? addr_i[0] : addr_i[shamt];
  end else begin : gen_replay_addr_o_without_C
    assign replay_addr_o = addr_i[0];
  end

  // ----------------------
  // Downstream interface
  // ----------------------
  // as long as there is at least one queue which can take the value we have a valid instruction
  assign fetch_entry_valid_o[0] = ~(&instr_queue_empty);
  if (CVA6Cfg.SuperscalarEn) begin : gen_fetch_entry_valid_1
    // TODO Maybe this additional fetch_entry_is_cf check is useless as issue-stage already performs it?
    assign fetch_entry_valid_o[NID] = ~|(instr_queue_empty & idx_ds[1]) & ~(&fetch_entry_is_cf);
  end

  assign idx_ds[0] = idx_ds_q;
  for (genvar i = 0; i < CVA6Cfg.NrIssuePorts; i++) begin
    if (CVA6Cfg.INSTR_PER_FETCH > 1) begin
      assign idx_ds[i+1] = {
        idx_ds[i][CVA6Cfg.INSTR_PER_FETCH-2:0], idx_ds[i][CVA6Cfg.INSTR_PER_FETCH-1]
      };
    end else begin
      assign idx_ds[i+1] = idx_ds[i];
    end
  end

  if (CVA6Cfg.RVC) begin : gen_downstream_itf_with_c
    always_comb begin
      idx_ds_d  = idx_ds_q;

      pop_instr = '0;
      // assemble fetch entry
      for (int unsigned i = 0; i < CVA6Cfg.NrIssuePorts; i++) begin
        fetch_entry_o[i].instruction = '0;
        fetch_entry_o[i].address = pc_j[i];
        fetch_entry_o[i].ex.valid = 1'b0;
        fetch_entry_o[i].ex.cause = '0;

        fetch_entry_o[i].ex.tval = '0;
        fetch_entry_o[i].ex.tval2 = '0;
        fetch_entry_o[i].ex.gva = 1'b0;
        fetch_entry_o[i].ex.tinst = '0;
        fetch_entry_o[i].branch_predict.predict_address = address_out;
        fetch_entry_o[i].branch_predict.cf = ariane_pkg::NoCF;
      end

      // output mux select
      for (int unsigned i = 0; i < CVA6Cfg.INSTR_PER_FETCH; i++) begin
        // TODO handle fetch_entry_o[1] if superscalar
        if (idx_ds[0][i]) begin
          if (instr_data_out[i].ex == ariane_pkg::FE_INSTR_ACCESS_FAULT) begin
            fetch_entry_o[0].ex.cause = riscv::INSTR_ACCESS_FAULT;
          end else if (CVA6Cfg.RVH && instr_data_out[i].ex == ariane_pkg::FE_INSTR_GUEST_PAGE_FAULT) begin
            fetch_entry_o[0].ex.cause = riscv::INSTR_GUEST_PAGE_FAULT;
          end else begin
            fetch_entry_o[0].ex.cause = riscv::INSTR_PAGE_FAULT;
          end
          fetch_entry_o[0].instruction = instr_data_out[i].instr;
          fetch_entry_o[0].ex.valid = instr_data_out[i].ex != ariane_pkg::FE_NONE;
          if (CVA6Cfg.TvalEn)
            fetch_entry_o[0].ex.tval = {
              {(CVA6Cfg.XLEN - CVA6Cfg.VLEN) {1'b0}}, instr_data_out[i].ex_vaddr
            };
          if (CVA6Cfg.RVH) begin
            fetch_entry_o[0].ex.tval2 = instr_data_out[i].ex_gpaddr;
            fetch_entry_o[0].ex.tinst = instr_data_out[i].ex_tinst;
            fetch_entry_o[0].ex.gva   = instr_data_out[i].ex_gva;
          end
          fetch_entry_o[0].branch_predict.cf = instr_data_out[i].cf;
          pop_instr[i] = fetch_entry_fire[0];
        end

        if (CVA6Cfg.SuperscalarEn) begin
          if (idx_ds[1][i]) begin
            if (instr_data_out[i].ex == ariane_pkg::FE_INSTR_ACCESS_FAULT) begin
              fetch_entry_o[NID].ex.cause = riscv::INSTR_ACCESS_FAULT;
            end else begin
              fetch_entry_o[NID].ex.cause = riscv::INSTR_PAGE_FAULT;
            end
            fetch_entry_o[NID].instruction = instr_data_out[i].instr;
            fetch_entry_o[NID].ex.valid = instr_data_out[i].ex != ariane_pkg::FE_NONE;
            fetch_entry_o[NID].ex.tval = {{64 - CVA6Cfg.VLEN{1'b0}}, instr_data_out[i].ex_vaddr};
            fetch_entry_o[NID].branch_predict.cf = instr_data_out[i].cf;
            // Cannot output two CF the same cycle.
            pop_instr[i] = fetch_entry_fire[NID];
          end
        end
      end
      // rotate the pointer left
      if (fetch_entry_fire[0]) begin
        if (CVA6Cfg.SuperscalarEn) begin
          idx_ds_d = fetch_entry_fire[NID] ? idx_ds[2] : idx_ds[1];
        end else begin
          idx_ds_d = idx_ds[1];
        end
      end
    end
  end else begin : gen_downstream_itf_without_c
    always_comb begin
      idx_ds_d = '0;
      idx_is_d = '0;
      fetch_entry_o[0].instruction = instr_data_out[0].instr;
      fetch_entry_o[0].address = pc_q;

      fetch_entry_o[0].ex.valid = instr_data_out[0].ex != ariane_pkg::FE_NONE;
      if (instr_data_out[0].ex == ariane_pkg::FE_INSTR_ACCESS_FAULT) begin
        fetch_entry_o[0].ex.cause = riscv::INSTR_ACCESS_FAULT;
      end else begin
        fetch_entry_o[0].ex.cause = riscv::INSTR_PAGE_FAULT;
      end
      if (CVA6Cfg.TvalEn)
        fetch_entry_o[0].ex.tval = {{64 - CVA6Cfg.VLEN{1'b0}}, instr_data_out[0].ex_vaddr};
      else fetch_entry_o[0].ex.tval = '0;
      if (CVA6Cfg.RVH) begin
        fetch_entry_o[0].ex.tval2 = instr_data_out[0].ex_gpaddr;
        fetch_entry_o[0].ex.tinst = instr_data_out[0].ex_tinst;
        fetch_entry_o[0].ex.gva   = instr_data_out[0].ex_gva;
      end else begin
        fetch_entry_o[0].ex.tval2 = '0;
        fetch_entry_o[0].ex.tinst = '0;
        fetch_entry_o[0].ex.gva   = 1'b0;
      end

      fetch_entry_o[0].branch_predict.predict_address = address_out;
      fetch_entry_o[0].branch_predict.cf = instr_data_out[0].cf;

      pop_instr[0] = fetch_entry_valid_o[0] & fetch_entry_ready_i[0];
    end
  end

  for (genvar i = 0; i < CVA6Cfg.NrIssuePorts; i++) begin
    assign fetch_entry_is_cf[i] = fetch_entry_o[i].branch_predict.cf != ariane_pkg::NoCF;
    assign fetch_entry_fire[i]  = fetch_entry_valid_o[i] & fetch_entry_ready_i[i];
  end

  assign pop_address = |(fetch_entry_is_cf & fetch_entry_fire);

  // ----------------------
  // Calculate (Next) PC
  // ----------------------
  assign pc_j[0] = pc_q;
  for (genvar i = 0; i < CVA6Cfg.NrIssuePorts; i++) begin
    assign pc_j[i+1] = fetch_entry_is_cf[i] ? address_out : (
      pc_j[i] + ((fetch_entry_o[i].instruction[1:0] != 2'b11) ? 'd2 : 'd4)
    );
  end

  always_comb begin
    pc_d = pc_q;
    reset_address_d = flush_i ? 1'b1 : reset_address_q;

    if (fetch_entry_fire[0]) begin
      pc_d = pc_j[1];
      if (CVA6Cfg.SuperscalarEn) begin
        if (fetch_entry_fire[NID]) begin
          pc_d = pc_j[2];
        end
      end
    end

    // we previously flushed so we need to reset the address
    if (valid_i[0] && reset_address_q) begin
      // this is the base of the first instruction
      pc_d = addr_i[0];
      reset_address_d = 1'b0;
    end
  end

  // FIFOs
  for (genvar i = 0; i < CVA6Cfg.INSTR_PER_FETCH; i++) begin : gen_instr_fifo
    // Make sure we don't save any instructions if we couldn't save the address
    assign push_instr_fifo[i] = push_instr[i] & ~address_overflow;
    cva6_fifo_v3 #(
        .FPGA_ALTERA(CVA6Cfg.FpgaAlteraEn),
        .DEPTH(ariane_pkg::FETCH_FIFO_DEPTH),
        .dtype(instr_data_t),
        .FPGA_EN(CVA6Cfg.FpgaEn)
    ) i_fifo_instr_data (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .flush_i   (flush_i),
        .testmode_i(1'b0),
        .full_o    (instr_queue_full[i]),
        .empty_o   (instr_queue_empty[i]),
        .usage_o   (),
        .data_i    (instr_data_in[i]),
        .push_i    (push_instr_fifo[i]),
        .data_o    (instr_data_out[i]),
        .pop_i     (pop_instr[i])
    );
  end
  // or reduce and check whether we are retiring a taken branch (might be that the corresponding)
  // fifo is full.
  always_comb begin
    push_address = 1'b0;
    // check if we are pushing a ctrl flow change, if so save the address
    for (int i = 0; i < CVA6Cfg.INSTR_PER_FETCH; i++) begin
      push_address |= push_instr[i] & (instr_data_in[i].cf != ariane_pkg::NoCF);
    end
  end

  cva6_fifo_v3 #(
      .FPGA_ALTERA(CVA6Cfg.FpgaAlteraEn),
      .DEPTH      (ariane_pkg::FETCH_ADDR_FIFO_DEPTH),
      .DATA_WIDTH (CVA6Cfg.VLEN),
      .FPGA_EN    (CVA6Cfg.FpgaEn)
  ) i_fifo_address (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .flush_i   (flush_i),
      .testmode_i(1'b0),
      .full_o    (full_address),
      .empty_o   (),
      .usage_o   (),
      .data_i    (predict_address_i),
      .push_i    (push_address & ~full_address),
      .data_o    (address_out),
      .pop_i     (pop_address)
  );

  unread i_unread_branch_mask (.d_i(|branch_mask_extended));
  unread i_unread_fifo_pos (.d_i(|fifo_pos_extended));  // we don't care about the lower signals

  if (CVA6Cfg.RVC) begin : gen_pc_q_with_c
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        idx_ds_q        <= 'b1;
        idx_is_q        <= '0;
        pc_q            <= '0;
        reset_address_q <= 1'b1;
      end else begin
        pc_q            <= pc_d;
        reset_address_q <= reset_address_d;
        if (flush_i) begin
          // one-hot encoded
          idx_ds_q        <= 'b1;
          // binary encoded
          idx_is_q        <= '0;
          reset_address_q <= 1'b1;
        end else begin
          idx_ds_q <= idx_ds_d;
          idx_is_q <= idx_is_d;
        end
      end
    end
  end else begin : gen_pc_q_without_C
    assign idx_ds_q = '0;
    assign idx_is_q = '0;
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        pc_q            <= '0;
        reset_address_q <= 1'b1;
      end else begin
        pc_q            <= pc_d;
        reset_address_q <= reset_address_d;
        if (flush_i) begin
          reset_address_q <= 1'b1;
        end
      end
    end
  end

  // pragma translate_off
  replay_address_fifo :
  assert property (@(posedge clk_i) disable iff (!rst_ni) replay_o |-> !i_fifo_address.push_i)
  else $fatal(1, "[instr_queue] Pushing address although replay asserted");

  output_select_onehot :
  assert property (@(posedge clk_i) $onehot0(idx_ds_q))
  else begin
    $error("Output select should be one-hot encoded");
    $stop();
  end
  // pragma translate_on
endmodule
