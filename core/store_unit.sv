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
// Date: 22.05.2017
// Description: Store Unit, takes care of all store requests and atomic memory operations (AMOs)


module store_unit
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type dcache_req_i_t = logic,
    parameter type dcache_req_o_t = logic,
    parameter type exception_t = logic,
    parameter type lsu_ctrl_t = logic
) (
    // Subsystem Clock - SUBSYSTEM
    input logic clk_i,
    // Asynchronous reset active low - SUBSYSTEM
    input logic rst_ni,
    // Flush - CONTROLLER
    input logic flush_i,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    input logic stall_st_pending_i,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    output logic no_st_pending_o,
    // Store buffer is empty - TO_BE_COMPLETED
    output logic store_buffer_empty_o,
    // Store instruction is valid - ISSUE_STAGE
    input logic valid_i,
    // Data input - ISSUE_STAGE
    input lsu_ctrl_t lsu_ctrl_i,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    output logic pop_st_o,
    // Instruction commit - TO_BE_COMPLETED
    input logic commit_i,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    output logic commit_ready_o,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    input logic amo_valid_commit_i,
    // Store result is valid - ISSUE_STAGE
    output logic valid_o,
    // Transaction ID - ISSUE_STAGE
    output logic [CVA6Cfg.TRANS_ID_BITS-1:0] trans_id_o,
    // Store result - ISSUE_STAGE
    output logic [CVA6Cfg.XLEN-1:0] result_o,
    // Store exception output - TO_BE_COMPLETED
    output exception_t ex_o,
    // Address translation request - TO_BE_COMPLETED
    output logic translation_req_o,
    // Virtual address - TO_BE_COMPLETED
    output logic [CVA6Cfg.VLEN-1:0] vaddr_o,
    // RVFI information - RVFI
    output logic [CVA6Cfg.PLEN-1:0] rvfi_mem_paddr_o,
    // Transformed trap instruction out - TO_BE_COMPLETED
    output logic [31:0] tinst_o,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    output logic hs_ld_st_inst_o,
    // TO_BE_COMPLETED - TO_BE_COMPLETED
    output logic hlvx_inst_o,
    // Physical address - TO_BE_COMPLETED
    input logic [CVA6Cfg.PLEN-1:0] paddr_i,
    // Exception raised before store - TO_BE_COMPLETED
    input exception_t ex_i,
    // Data TLB hit - lsu
    input logic dtlb_hit_i,
    // Address to be checked - load_unit
    input logic [11:0] page_offset_i,
    // Address check result - load_unit
    output logic page_offset_matches_o,
    // AMO request - CACHES
    output amo_req_t amo_req_o,
    // AMO response - CACHES
    input amo_resp_t amo_resp_i,
    // Data cache request - CACHES
    input dcache_req_o_t req_port_i,
    // Data cache response - CACHES
    output dcache_req_i_t req_port_o
);

  // align data to address e.g.: shift data to be naturally 64
  function automatic [CVA6Cfg.XLEN-1:0] data_align(logic [2:0] addr, logic [63:0] data);
    // Set addr[2] to 1'b0 when 32bits
    logic [ 2:0] addr_tmp = {(addr[2] && CVA6Cfg.IS_XLEN64), addr[1:0]};
    logic [63:0] data_tmp = {64{1'b0}};
    case (addr_tmp)
      3'b000: data_tmp[CVA6Cfg.XLEN-1:0] = {data[CVA6Cfg.XLEN-1:0]};
      3'b001:
      data_tmp[CVA6Cfg.XLEN-1:0] = {data[CVA6Cfg.XLEN-9:0], data[CVA6Cfg.XLEN-1:CVA6Cfg.XLEN-8]};
      3'b010:
      data_tmp[CVA6Cfg.XLEN-1:0] = {data[CVA6Cfg.XLEN-17:0], data[CVA6Cfg.XLEN-1:CVA6Cfg.XLEN-16]};
      3'b011:
      data_tmp[CVA6Cfg.XLEN-1:0] = {data[CVA6Cfg.XLEN-25:0], data[CVA6Cfg.XLEN-1:CVA6Cfg.XLEN-24]};
      default:
      if (CVA6Cfg.IS_XLEN64) begin
        case (addr_tmp)
          3'b100:  data_tmp = {data[31:0], data[63:32]};
          3'b101:  data_tmp = {data[23:0], data[63:24]};
          3'b110:  data_tmp = {data[15:0], data[63:16]};
          3'b111:  data_tmp = {data[7:0], data[63:8]};
          default: data_tmp = {data[63:0]};
        endcase
      end
    endcase
    return data_tmp[CVA6Cfg.XLEN-1:0];
  endfunction

  // it doesn't matter what we are writing back as stores don't return anything
  assign result_o = lsu_ctrl_i.data;

  enum logic [1:0] {
    IDLE,
    VALID_STORE,
    WAIT_TRANSLATION,
    WAIT_STORE_READY
  }
      state_d, state_q;

  // store buffer control signals
  logic st_ready;
  logic st_valid;
  logic st_valid_without_flush;
  logic instr_is_amo;
  assign instr_is_amo = is_amo(lsu_ctrl_i.operation);
  // keep the data and the byte enable for the second cycle (after address translation)
  logic [CVA6Cfg.XLEN-1:0] st_data_n, st_data_q;
  logic [(CVA6Cfg.XLEN/8)-1:0] st_be_n, st_be_q;
  logic [1:0] st_data_size_n, st_data_size_q;
  amo_t amo_op_d, amo_op_q;

  logic [CVA6Cfg.TRANS_ID_BITS-1:0] trans_id_n, trans_id_q;

  // output assignments
  assign vaddr_o         = lsu_ctrl_i.vaddr;  // virtual address
  assign hs_ld_st_inst_o = CVA6Cfg.RVH ? lsu_ctrl_i.hs_ld_st_inst : 1'b0;
  assign hlvx_inst_o     = CVA6Cfg.RVH ? lsu_ctrl_i.hlvx_inst : 1'b0;
  assign tinst_o         = CVA6Cfg.RVH ? lsu_ctrl_i.tinst : '0;  // transformed instruction
  assign trans_id_o      = trans_id_q;  // transaction id from previous cycle

  always_comb begin : store_control
    translation_req_o      = 1'b0;
    valid_o                = 1'b0;
    st_valid               = 1'b0;
    st_valid_without_flush = 1'b0;
    pop_st_o               = 1'b0;
    ex_o                   = ex_i;
    trans_id_n             = lsu_ctrl_i.trans_id;
    state_d                = state_q;

    case (state_q)
      // we got a valid store
      IDLE: begin
        if (valid_i) begin
          state_d = VALID_STORE;
          translation_req_o = 1'b1;
          pop_st_o = 1'b1;
          // check if translation was valid and we have space in the store buffer
          // otherwise simply stall
          if (CVA6Cfg.MmuPresent && !dtlb_hit_i) begin
            state_d  = WAIT_TRANSLATION;
            pop_st_o = 1'b0;
          end

          if (!st_ready) begin
            state_d  = WAIT_STORE_READY;
            pop_st_o = 1'b0;
          end
        end
      end

      VALID_STORE: begin
        valid_o = 1'b1;
        // post this store to the store buffer if we are not flushing
        if (!flush_i) st_valid = 1'b1;

        st_valid_without_flush = 1'b1;

        // we have another request and its not an AMO (the AMO buffer only has depth 1)
        if ((valid_i && CVA6Cfg.RVA && !instr_is_amo) || (valid_i && !CVA6Cfg.RVA)) begin

          translation_req_o = 1'b1;
          state_d = VALID_STORE;
          pop_st_o = 1'b1;

          if (CVA6Cfg.MmuPresent && !dtlb_hit_i) begin
            state_d  = WAIT_TRANSLATION;
            pop_st_o = 1'b0;
          end

          if (!st_ready) begin
            state_d  = WAIT_STORE_READY;
            pop_st_o = 1'b0;
          end
          // if we do not have another request go back to idle
        end else begin
          state_d = IDLE;
        end
      end

      // the store queue is currently full
      WAIT_STORE_READY: begin
        // keep the translation request high
        translation_req_o = 1'b1;

        if (st_ready && dtlb_hit_i) begin
          state_d = IDLE;
        end
      end

      default: begin
        // we didn't receive a valid translation, wait for one
        // but we know that the store queue is not full as we could only have landed here if
        // it wasn't full
        if (state_q == WAIT_TRANSLATION && CVA6Cfg.MmuPresent) begin
          translation_req_o = 1'b1;

          if (dtlb_hit_i) begin
            state_d = IDLE;
          end
        end
      end
    endcase

    // -----------------
    // Access Exception
    // -----------------
    // we got an address translation exception (access rights, misaligned or page fault)
    if (ex_i.valid && (state_q != IDLE)) begin
      // the only difference is that we do not want to store this request
      pop_st_o = 1'b1;
      st_valid = 1'b0;
      state_d  = IDLE;
      valid_o  = 1'b1;
    end

    if (flush_i) state_d = IDLE;
  end

  // -----------
  // Re-aligner
  // -----------
  // re-align the write data to comply with the address offset
  always_comb begin
    st_be_n = lsu_ctrl_i.be;
    // don't shift the data if we are going to perform an AMO as we still need to operate on this data
    st_data_n = (CVA6Cfg.RVA && instr_is_amo) ? lsu_ctrl_i.data[CVA6Cfg.XLEN-1:0] :
        data_align(lsu_ctrl_i.vaddr[2:0], {{64 - CVA6Cfg.XLEN{1'b0}}, lsu_ctrl_i.data});
    st_data_size_n = extract_transfer_size(lsu_ctrl_i.operation);
    // save AMO op for next cycle
    if (CVA6Cfg.RVA) begin
      case (lsu_ctrl_i.operation)
        AMO_LRW, AMO_LRD:     amo_op_d = AMO_LR;
        AMO_SCW, AMO_SCD:     amo_op_d = AMO_SC;
        AMO_SWAPW, AMO_SWAPD: amo_op_d = AMO_SWAP;
        AMO_ADDW, AMO_ADDD:   amo_op_d = AMO_ADD;
        AMO_ANDW, AMO_ANDD:   amo_op_d = AMO_AND;
        AMO_ORW, AMO_ORD:     amo_op_d = AMO_OR;
        AMO_XORW, AMO_XORD:   amo_op_d = AMO_XOR;
        AMO_MAXW, AMO_MAXD:   amo_op_d = AMO_MAX;
        AMO_MAXWU, AMO_MAXDU: amo_op_d = AMO_MAXU;
        AMO_MINW, AMO_MIND:   amo_op_d = AMO_MIN;
        AMO_MINWU, AMO_MINDU: amo_op_d = AMO_MINU;
        default:              amo_op_d = AMO_NONE;
      endcase
    end else begin
      amo_op_d = AMO_NONE;
    end
  end

  logic store_buffer_valid, amo_buffer_valid;
  logic store_buffer_ready, amo_buffer_ready;

  // multiplex between store unit and amo buffer
  assign store_buffer_valid = st_valid & (!CVA6Cfg.RVA || (amo_op_q == AMO_NONE));
  assign amo_buffer_valid = st_valid & (CVA6Cfg.RVA && (amo_op_q != AMO_NONE));

  assign st_ready = store_buffer_ready & amo_buffer_ready;

  // ---------------
  // Store Queue
  // ---------------
  store_buffer #(
      .CVA6Cfg(CVA6Cfg),
      .dcache_req_i_t(dcache_req_i_t),
      .dcache_req_o_t(dcache_req_o_t)
  ) store_buffer_i (
      .clk_i,
      .rst_ni,
      .flush_i,
      .stall_st_pending_i,
      .no_st_pending_o,
      .store_buffer_empty_o,
      .page_offset_i,
      .page_offset_matches_o,
      .commit_i,
      .commit_ready_o,
      .ready_o              (store_buffer_ready),
      .valid_i              (store_buffer_valid),
      // the flush signal can be critical and we need this valid
      // signal to check whether the page_offset matches or not,
      // functionaly it doesn't make a difference whether we use
      // the correct valid signal or not as we are flushing
      // the whole pipeline anyway
      .valid_without_flush_i(st_valid_without_flush),
      .paddr_i,
      .rvfi_mem_paddr_o     (rvfi_mem_paddr_o),
      .data_i               (st_data_q),
      .be_i                 (st_be_q),
      .data_size_i          (st_data_size_q),
      .req_port_i           (req_port_i),
      .req_port_o           (req_port_o)
  );

  if (CVA6Cfg.RVA) begin
    amo_buffer #(
        .CVA6Cfg(CVA6Cfg)
    ) i_amo_buffer (
        .clk_i,
        .rst_ni,
        .flush_i,
        .valid_i           (amo_buffer_valid),
        .ready_o           (amo_buffer_ready),
        .paddr_i           (paddr_i),
        .amo_op_i          (amo_op_q),
        .data_i            (st_data_q),
        .data_size_i       (st_data_size_q),
        .amo_req_o         (amo_req_o),
        .amo_resp_i        (amo_resp_i),
        .amo_valid_commit_i(amo_valid_commit_i),
        .no_st_pending_i   (no_st_pending_o)
    );
  end else begin
    assign amo_buffer_ready = '1;
    assign amo_req_o        = '0;
  end

  // ---------------
  // Registers
  // ---------------
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      state_q        <= IDLE;
      st_be_q        <= '0;
      st_data_q      <= '0;
      st_data_size_q <= '0;
      trans_id_q     <= '0;
      amo_op_q       <= AMO_NONE;
    end else begin
      state_q        <= state_d;
      st_be_q        <= st_be_n;
      st_data_q      <= st_data_n;
      trans_id_q     <= trans_id_n;
      st_data_size_q <= st_data_size_n;
      amo_op_q       <= amo_op_d;
    end
  end

endmodule
