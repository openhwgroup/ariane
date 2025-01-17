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
// Author: Michael Schaffner <schaffner@iis.ee.ethz.ch>, ETH Zurich
// Date: 13.09.2018
// Description: coalescing write buffer for WT dcache
//
// A couple of notes:
//
// 1) the write buffer behaves as a fully-associative cache, and is therefore coalescing.
//    this cache is used by the cache readout logic to forward data to the load unit.
//
//    each byte can be in the following states (valid/dirty/txblock):
//
//    0/0/0:    invalid -> free entry in the buffer
//    1/1/0:    valid and dirty, Byte is hence not part of TX in-flight
//    1/0/1:    valid and not dirty, Byte is part of a TX in-flight
//    1/1/1:    valid and, part of tx and dirty. this means that the byte has been
//              overwritten while in TX and needs to be retransmitted once the write of that byte returns.
//    1/0/0:    this would represent a clean state, but is never reached in the wbuffer in the current implementation.
//              this is because when a TX returns, and the byte is in state [1/0/1], it is written to cache if needed and
//              its state is immediately cleared to 0/x/x.
//
//    this state is used to distinguish between bytes that have been written and not
//    yet sent to the memory subsystem, and bytes that are part of a transaction.
//
// 2) further, each word in the write buffer has a cache states (checked, hit_oh)
//
//    checked == 0: unknown cache state
//    checked == 1: cache state has been looked up, valid way is stored in "hit_oh"
//
//    cache invalidations/refills affecting a particular word will clear its word state to 0,
//    so another lookup has to be done. note that these lookups are triggered as soon as there is
//    a valid word with checked == 0 in the write buffer.
//
// 3) returning write ACKs trigger a cache update if the word is present in the cache, and evict that
//    word from the write buffer. if the word is not allocated to the cache, it is just evicted from the write buffer.
//    if the word cache state is VOID, the pipeline is stalled until it is clear whether that word is in the cache or not.
//
// 4) we handle NC writes using the writebuffer circuitry. upon an NC request, the writebuffer will first be drained.
//    then, only the NC word is written into the write buffer and no further write requests are acknowledged until that
//    word has been evicted from the write buffer.


module wt_dcache_wbuffer
  import ariane_pkg::*;
  import wt_cache_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter DCACHE_CL_IDX_WIDTH = 0,
    parameter type dcache_req_i_t = logic,
    parameter type dcache_req_o_t = logic,
    parameter type wbuffer_t = logic
) (
    input logic clk_i,  // Clock
    input logic rst_ni, // Asynchronous reset active low

    input logic cache_en_i,  // writes are treated as NC if disabled
    output logic empty_o,  // asserted if no data is present in write buffer
    output logic not_ni_o,  // asserted if no ni data is present in write buffer
    // core request ports
    input dcache_req_i_t req_port_i,
    output dcache_req_o_t req_port_o,
    // interface to miss handler
    input logic miss_ack_i,
    output logic [CVA6Cfg.PLEN-1:0] miss_paddr_o,
    output logic miss_req_o,
    output logic miss_we_o,  // always 1 here
    output logic [CVA6Cfg.XLEN-1:0] miss_wdata_o,
    output logic [CVA6Cfg.DCACHE_USER_WIDTH-1:0] miss_wuser_o,
    output logic [CVA6Cfg.DCACHE_SET_ASSOC-1:0] miss_vld_bits_o,  // unused here (set to 0)
    output logic miss_nc_o,  // request to I/O space
    output logic [2:0] miss_size_o,  //
    output logic [CVA6Cfg.MEM_TID_WIDTH-1:0]          miss_id_o,       // ID of this transaction (wbuffer uses all IDs from 0 to DCACHE_MAX_TX-1)
    // write responses from memory
    input logic miss_rtrn_vld_i,
    input logic [CVA6Cfg.MEM_TID_WIDTH-1:0] miss_rtrn_id_i,  // transaction ID to clear
    // cache read interface
    output logic [CVA6Cfg.DCACHE_TAG_WIDTH-1:0] rd_tag_o,  // tag in - comes one cycle later
    output logic [DCACHE_CL_IDX_WIDTH-1:0] rd_idx_o,
    output logic [CVA6Cfg.DCACHE_OFFSET_WIDTH-1:0] rd_off_o,
    output logic rd_req_o,  // read the word at offset off_i[:3] in all ways
    output logic rd_tag_only_o,  // set to 1 here as we do not have to read the data arrays
    input logic rd_ack_i,
    input logic [CVA6Cfg.XLEN-1:0] rd_data_i,  // unused
    input logic [CVA6Cfg.DCACHE_SET_ASSOC-1:0] rd_vld_bits_i,  // unused
    input logic [CVA6Cfg.DCACHE_SET_ASSOC-1:0] rd_hit_oh_i,
    // cacheline writes
    input logic wr_cl_vld_i,
    input logic [DCACHE_CL_IDX_WIDTH-1:0] wr_cl_idx_i,
    // cache word write interface
    output logic [CVA6Cfg.DCACHE_SET_ASSOC-1:0] wr_req_o,
    input logic wr_ack_i,
    output logic [DCACHE_CL_IDX_WIDTH-1:0] wr_idx_o,
    output logic [CVA6Cfg.DCACHE_OFFSET_WIDTH-1:0] wr_off_o,
    output logic [CVA6Cfg.XLEN-1:0] wr_data_o,
    output logic [(CVA6Cfg.XLEN/8)-1:0] wr_data_be_o,
    output logic [CVA6Cfg.DCACHE_USER_WIDTH-1:0] wr_user_o,
    // to forwarding logic and miss unit
    output wbuffer_t [CVA6Cfg.WtDcacheWbufDepth-1:0] wbuffer_data_o,
    output logic [CVA6Cfg.DCACHE_MAX_TX-1:0][CVA6Cfg.PLEN-1:0]     tx_paddr_o,      // used to check for address collisions with read operations
    output logic [CVA6Cfg.DCACHE_MAX_TX-1:0] tx_vld_o
);

  function automatic logic [(CVA6Cfg.XLEN/8)-1:0] to_byte_enable8(
      input logic [CVA6Cfg.XLEN_ALIGN_BYTES-1:0] offset, input logic [1:0] size);
    logic [(CVA6Cfg.XLEN/8)-1:0] be;
    be = '0;
    unique case (size)
      2'b00:   be[offset] = '1;  // byte
      2'b01:   be[offset+:2] = '1;  // hword
      2'b10:   be[offset+:4] = '1;  // word
      default: be = '1;  // dword
    endcase  // size
    return be;
  endfunction : to_byte_enable8

  function automatic logic [(CVA6Cfg.XLEN/8)-1:0] to_byte_enable4(
      input logic [CVA6Cfg.XLEN_ALIGN_BYTES-1:0] offset, input logic [1:0] size);
    logic [3:0] be;
    be = '0;
    unique case (size)
      2'b00:   be[offset] = '1;  // byte
      2'b01:   be[offset+:2] = '1;  // hword
      default: be = '1;  // word
    endcase  // size
    return be;
  endfunction : to_byte_enable4

  // openpiton requires the data to be replicated in case of smaller sizes than dwords
  function automatic logic [CVA6Cfg.XLEN-1:0] repData64(
      input logic [CVA6Cfg.XLEN-1:0] data, input logic [CVA6Cfg.XLEN_ALIGN_BYTES-1:0] offset,
      input logic [1:0] size);
    logic [CVA6Cfg.XLEN-1:0] out;
    unique case (size)
      2'b00:   for (int k = 0; k < 8; k++) out[k*8+:8] = data[offset*8+:8];  // byte
      2'b01:   for (int k = 0; k < 4; k++) out[k*16+:16] = data[offset*8+:16];  // hword
      2'b10:   for (int k = 0; k < 2; k++) out[k*32+:32] = data[offset*8+:32];  // word
      default: out = data;  // dword
    endcase  // size
    return out;
  endfunction : repData64

  function automatic logic [CVA6Cfg.XLEN-1:0] repData32(
      input logic [CVA6Cfg.XLEN-1:0] data, input logic [CVA6Cfg.XLEN_ALIGN_BYTES-1:0] offset,
      input logic [1:0] size);
    logic [CVA6Cfg.XLEN-1:0] out;
    unique case (size)
      2'b00:   for (int k = 0; k < 4; k++) out[k*8+:8] = data[offset*8+:8];  // byte
      2'b01:   for (int k = 0; k < 2; k++) out[k*16+:16] = data[offset*8+:16];  // hword
      default: out = data;  // word
    endcase  // size
    return out;
  endfunction : repData32

  typedef struct packed {
    logic                                         vld;
    logic [(CVA6Cfg.XLEN/8)-1:0]                  be;
    logic [$clog2(CVA6Cfg.WtDcacheWbufDepth)-1:0] ptr;
  } tx_stat_t;

  tx_stat_t [CVA6Cfg.DCACHE_MAX_TX-1:0] tx_stat_d, tx_stat_q;
  wbuffer_t [CVA6Cfg.WtDcacheWbufDepth-1:0] wbuffer_d, wbuffer_q;
  logic [CVA6Cfg.WtDcacheWbufDepth-1:0] valid;
  logic [CVA6Cfg.WtDcacheWbufDepth-1:0] dirty;
  logic [CVA6Cfg.WtDcacheWbufDepth-1:0] tocheck;
  logic [CVA6Cfg.WtDcacheWbufDepth-1:0] wbuffer_hit_oh, inval_hit;
  //logic     [CVA6Cfg.WtDcacheWbufDepth-1:0][7:0]    bdirty;
  logic [CVA6Cfg.WtDcacheWbufDepth-1:0][(CVA6Cfg.XLEN/8)-1:0] bdirty;

  logic [$clog2(CVA6Cfg.WtDcacheWbufDepth)-1:0]
      next_ptr, dirty_ptr, hit_ptr, wr_ptr, check_ptr_d, check_ptr_q, check_ptr_q1, rtrn_ptr;
  logic [CVA6Cfg.MEM_TID_WIDTH-1:0] tx_id, rtrn_id;

  logic [CVA6Cfg.XLEN_ALIGN_BYTES-1:0] bdirty_off;
  logic [(CVA6Cfg.XLEN/8)-1:0] tx_be;
  logic [CVA6Cfg.PLEN-1:0] wr_paddr, rd_paddr, extract_tag;
  logic [CVA6Cfg.DCACHE_TAG_WIDTH-1:0] rd_tag_d, rd_tag_q;
  logic [CVA6Cfg.DCACHE_SET_ASSOC-1:0] rd_hit_oh_d, rd_hit_oh_q;
  logic check_en_d, check_en_q, check_en_q1;
  logic full, dirty_rd_en, rdy;
  logic rtrn_empty, evict;
  logic [CVA6Cfg.WtDcacheWbufDepth-1:0] ni_pending_d, ni_pending_q;
  logic wbuffer_wren;
  logic free_tx_slots;

  logic wr_cl_vld_q, wr_cl_vld_d;
  logic [DCACHE_CL_IDX_WIDTH-1:0] wr_cl_idx_q, wr_cl_idx_d;

  logic [CVA6Cfg.PLEN-1:0] debug_paddr[CVA6Cfg.WtDcacheWbufDepth-1:0];

  wbuffer_t wbuffer_check_mux, wbuffer_dirty_mux;

  ///////////////////////////////////////////////////////
  // misc
  ///////////////////////////////////////////////////////
  logic [CVA6Cfg.DCACHE_TAG_WIDTH-1:0] miss_tag;
  logic is_nc_miss;
  logic is_ni;
  assign miss_tag = miss_paddr_o[CVA6Cfg.DCACHE_INDEX_WIDTH+:CVA6Cfg.DCACHE_TAG_WIDTH];
  assign is_nc_miss = !config_pkg::is_inside_cacheable_regions(
      CVA6Cfg,
      {
        {64 - CVA6Cfg.DCACHE_TAG_WIDTH - CVA6Cfg.DCACHE_INDEX_WIDTH{1'b0}},
        miss_tag,
        {CVA6Cfg.DCACHE_INDEX_WIDTH{1'b0}}
      }
  );
  assign miss_nc_o = !cache_en_i || is_nc_miss;
  // Non-idempotent if request goes to NI region
  assign is_ni = config_pkg::is_inside_nonidempotent_regions(
      CVA6Cfg,
      {
        {64 - CVA6Cfg.DCACHE_TAG_WIDTH - CVA6Cfg.DCACHE_INDEX_WIDTH{1'b0}},
        req_port_i.address_tag,
        {CVA6Cfg.DCACHE_INDEX_WIDTH{1'b0}}
      }
  );

  assign miss_we_o = 1'b1;
  assign miss_vld_bits_o = '0;
  assign wbuffer_data_o = wbuffer_q;

  for (genvar k = 0; k < CVA6Cfg.DCACHE_MAX_TX; k++) begin : gen_tx_vld
    assign tx_vld_o[k] = tx_stat_q[k].vld;
    assign tx_paddr_o[k] = {
      {CVA6Cfg.XLEN_ALIGN_BYTES{1'b0}}, wbuffer_q[tx_stat_q[k].ptr].wtag << CVA6Cfg.XLEN_ALIGN_BYTES
    };
  end

  ///////////////////////////////////////////////////////
  // openpiton does not understand byte enable sigs
  // need to convert to the four cases:
  // 00: byte
  // 01: halfword
  // 10: word
  // 11: dword
  // non-contiguous writes need to be serialized!
  // e.g. merged dwords with BE like this: 8'b01001100
  ///////////////////////////////////////////////////////

  // get byte offset
  lzc #(
      .WIDTH(CVA6Cfg.XLEN / 8)
  ) i_vld_bdirty (
      .in_i   (bdirty[dirty_ptr]),
      .cnt_o  (bdirty_off),
      .empty_o()
  );

  // add the offset to the physical base address of this buffer entry
  assign miss_paddr_o = {wbuffer_dirty_mux.wtag, bdirty_off};
  assign miss_id_o = tx_id;

  // is there any dirty word to be transmitted, and is there a free TX slot?
  assign miss_req_o = (|dirty) && free_tx_slots;

  // get size of aligned words, and the corresponding byte enables
  // note: openpiton can only handle aligned offsets + size, and hence
  // we have to split unaligned data into multiple transfers (see toSize64)
  // e.g. if we have the following valid bytes: 0011_1001 -> TX0: 0000_0001, TX1: 0000_1000, TX2: 0011_0000
  if (CVA6Cfg.IS_XLEN64) begin : gen_size_64b
    assign miss_size_o = {1'b0, toSize64(bdirty[dirty_ptr])};
  end else begin : gen_size_32b
    assign miss_size_o = {1'b0, toSize32(bdirty[dirty_ptr])};
  end

  // replicate transfers shorter than a dword
  assign miss_wdata_o = CVA6Cfg.IS_XLEN64 ? repData64(
      wbuffer_dirty_mux.data, bdirty_off, miss_size_o[1:0]
  ) : repData32(
      wbuffer_dirty_mux.data, bdirty_off, miss_size_o[1:0]
  );
  if (CVA6Cfg.DATA_USER_EN) begin
    assign miss_wuser_o = CVA6Cfg.IS_XLEN64 ? repData64(
        wbuffer_dirty_mux.user, bdirty_off, miss_size_o[1:0]
    ) : repData32(
        wbuffer_dirty_mux.user, bdirty_off, miss_size_o[1:0]
    );
  end else begin
    assign miss_wuser_o = '0;
  end

  assign tx_be = CVA6Cfg.IS_XLEN64 ? to_byte_enable8(
      bdirty_off, miss_size_o[1:0]
  ) : to_byte_enable4(
      bdirty_off, miss_size_o[1:0]
  );

  ///////////////////////////////////////////////////////
  // TX status registers and ID counters
  ///////////////////////////////////////////////////////

  // TODO: todo: make this fall through if timing permits it
  cva6_fifo_v3 #(
      .FALL_THROUGH(1'b0),
      .DATA_WIDTH  ($clog2(CVA6Cfg.DCACHE_MAX_TX)),
      .DEPTH       (CVA6Cfg.DCACHE_MAX_TX),
      .FPGA_EN     (CVA6Cfg.FpgaEn)
  ) i_rtrn_id_fifo (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .flush_i   (1'b0),
      .testmode_i(1'b0),
      .full_o    (),
      .empty_o   (rtrn_empty),
      .usage_o   (),
      .data_i    (miss_rtrn_id_i),
      .push_i    (miss_rtrn_vld_i),
      .data_o    (rtrn_id),
      .pop_i     (evict)
  );

  always_comb begin : p_tx_stat
    tx_stat_d = tx_stat_q;
    evict     = 1'b0;
    wr_req_o  = '0;

    // clear entry if it is clear whether it can be pushed to the cache or not
    if ((!rtrn_empty) && wbuffer_q[rtrn_ptr].checked) begin
      // check if data is clean and can be written, otherwise skip
      // check if CL is present, otherwise skip
      if ((|wr_data_be_o) && (|wbuffer_q[rtrn_ptr].hit_oh)) begin
        wr_req_o = wbuffer_q[rtrn_ptr].hit_oh;
        if (wr_ack_i) begin
          evict    = 1'b1;
          tx_stat_d[rtrn_id].vld = 1'b0;
        end
      end else begin
        evict = 1'b1;
        tx_stat_d[rtrn_id].vld = 1'b0;
      end
    end

    // allocate a new entry
    if (dirty_rd_en) begin
      tx_stat_d[tx_id].vld = 1'b1;
      tx_stat_d[tx_id].ptr = dirty_ptr;
      tx_stat_d[tx_id].be  = tx_be;
    end
  end

  assign free_tx_slots = |(~tx_vld_o);

  // next word to lookup in the cache
  rr_arb_tree #(
      .NumIn    (CVA6Cfg.DCACHE_MAX_TX),
      .LockIn   (1'b1),
      .DataWidth(1)
  ) i_tx_id_rr (
      .clk_i  (clk_i),
      .rst_ni (rst_ni),
      .flush_i('0),
      .rr_i   ('0),
      .req_i  (~tx_vld_o),
      .gnt_o  (),
      .data_i ('0),
      .gnt_i  (dirty_rd_en),
      .req_o  (),
      .data_o (),
      .idx_o  (tx_id)
  );

  ///////////////////////////////////////////////////////
  // cache readout & update
  ///////////////////////////////////////////////////////

  assign extract_tag = rd_paddr >> CVA6Cfg.DCACHE_INDEX_WIDTH;
  assign rd_tag_d = extract_tag[CVA6Cfg.DCACHE_TAG_WIDTH-1:0];

  // trigger TAG readout in cache
  assign rd_tag_only_o = 1'b1;
  assign rd_paddr = {
    {CVA6Cfg.XLEN_ALIGN_BYTES{1'b0}}, wbuffer_check_mux.wtag << CVA6Cfg.XLEN_ALIGN_BYTES
  };
  assign rd_req_o = |tocheck;
  assign rd_tag_o = rd_tag_q;  //delay by one cycle
  assign rd_idx_o = rd_paddr[CVA6Cfg.DCACHE_INDEX_WIDTH-1:CVA6Cfg.DCACHE_OFFSET_WIDTH];
  assign rd_off_o = rd_paddr[CVA6Cfg.DCACHE_OFFSET_WIDTH-1:0];
  assign check_en_d = rd_req_o & rd_ack_i;

  // cache update port
  assign rtrn_ptr = tx_stat_q[rtrn_id].ptr;
  // if we wrote into a word while it was in-flight, we cannot write the dirty bytes to the cache
  // when the TX returns
  assign wr_data_be_o = tx_stat_q[rtrn_id].be & (~wbuffer_q[rtrn_ptr].dirty);
  assign wr_paddr = {
    {CVA6Cfg.XLEN_ALIGN_BYTES{1'b0}}, wbuffer_q[rtrn_ptr].wtag << CVA6Cfg.XLEN_ALIGN_BYTES
  };
  assign wr_idx_o = wr_paddr[CVA6Cfg.DCACHE_INDEX_WIDTH-1:CVA6Cfg.DCACHE_OFFSET_WIDTH];
  assign wr_off_o = wr_paddr[CVA6Cfg.DCACHE_OFFSET_WIDTH-1:0];
  assign wr_data_o = wbuffer_q[rtrn_ptr].data;
  assign wr_user_o = wbuffer_q[rtrn_ptr].user;


  ///////////////////////////////////////////////////////
  // readout of status bits, index calculation
  ///////////////////////////////////////////////////////

  logic [CVA6Cfg.WtDcacheWbufDepth-1:0][DCACHE_CL_IDX_WIDTH-1:0] wtag_comp;

  assign wr_cl_vld_d = wr_cl_vld_i;
  assign wr_cl_idx_d = wr_cl_idx_i;

  for (genvar k = 0; k < CVA6Cfg.WtDcacheWbufDepth; k++) begin : gen_flags
    // only for debug, will be pruned
    if (CVA6Cfg.DebugEn) begin
      assign debug_paddr[k] = {
        {CVA6Cfg.XLEN_ALIGN_BYTES{1'b0}}, wbuffer_q[k].wtag << CVA6Cfg.XLEN_ALIGN_BYTES
      };
    end

    // dirty bytes that are ready for transmission.
    // note that we cannot retransmit a word that is already in-flight
    // since the multiple transactions might overtake each other in the memory system!
    assign bdirty[k] = (|wbuffer_q[k].txblock) ? '0 : wbuffer_q[k].dirty & wbuffer_q[k].valid;


    assign dirty[k] = |bdirty[k];
    assign valid[k] = |wbuffer_q[k].valid;
    assign wbuffer_hit_oh[k] = valid[k] & (wbuffer_q[k].wtag == {req_port_i.address_tag, req_port_i.address_index[CVA6Cfg.DCACHE_INDEX_WIDTH-1:CVA6Cfg.XLEN_ALIGN_BYTES]});

    // checks if an invalidation/cache refill hits a particular word
    // note: an invalidation can hit multiple words!
    // need to respect previous cycle, too, since we add a cycle of latency to the rd_hit_oh_i signal...
    assign wtag_comp[k] = wbuffer_q[k].wtag[CVA6Cfg.DCACHE_INDEX_WIDTH-CVA6Cfg.XLEN_ALIGN_BYTES-1:CVA6Cfg.DCACHE_OFFSET_WIDTH-CVA6Cfg.XLEN_ALIGN_BYTES];
    assign inval_hit[k]  = (wr_cl_vld_d & valid[k] & (wtag_comp[k] == wr_cl_idx_d)) |
                           (wr_cl_vld_q & valid[k] & (wtag_comp[k] == wr_cl_idx_q));

    // these word have to be looked up in the cache
    assign tocheck[k] = (~wbuffer_q[k].checked) & valid[k];
  end

  assign wr_ptr = (|wbuffer_hit_oh) ? hit_ptr : next_ptr;
  assign rdy    = (|wbuffer_hit_oh) | (~full);

  // next free entry in the buffer
  lzc #(
      .WIDTH(CVA6Cfg.WtDcacheWbufDepth)
  ) i_vld_lzc (
      .in_i   (~valid),
      .cnt_o  (next_ptr),
      .empty_o(full)
  );

  // get index of hit
  lzc #(
      .WIDTH(CVA6Cfg.WtDcacheWbufDepth)
  ) i_hit_lzc (
      .in_i   (wbuffer_hit_oh),
      .cnt_o  (hit_ptr),
      .empty_o()
  );

  // next dirty word to serve
  rr_arb_tree #(
      .NumIn   (CVA6Cfg.WtDcacheWbufDepth),
      .LockIn  (1'b1),
      .DataType(wbuffer_t)
  ) i_dirty_rr (
      .clk_i  (clk_i),
      .rst_ni (rst_ni),
      .flush_i('0),
      .rr_i   ('0),
      .req_i  (dirty),
      .gnt_o  (),
      .data_i (wbuffer_q),
      .gnt_i  (dirty_rd_en),
      .req_o  (),
      .data_o (wbuffer_dirty_mux),
      .idx_o  (dirty_ptr)
  );

  // next word to lookup in the cache
  rr_arb_tree #(
      .NumIn   (CVA6Cfg.WtDcacheWbufDepth),
      .DataType(wbuffer_t)
  ) i_clean_rr (
      .clk_i  (clk_i),
      .rst_ni (rst_ni),
      .flush_i('0),
      .rr_i   ('0),
      .req_i  (tocheck),
      .gnt_o  (),
      .data_i (wbuffer_q),
      .gnt_i  (check_en_d),
      .req_o  (),
      .data_o (wbuffer_check_mux),
      .idx_o  (check_ptr_d)
  );

  ///////////////////////////////////////////////////////
  // update logic
  ///////////////////////////////////////////////////////

  assign req_port_o.data_rvalid = '0;
  assign req_port_o.data_rdata  = '0;
  assign req_port_o.data_ruser  = '0;
  assign req_port_o.data_rid    = '0;

  assign rd_hit_oh_d = rd_hit_oh_i;

  logic ni_inside, ni_conflict;
  assign ni_inside = |ni_pending_q;
  assign ni_conflict = CVA6Cfg.NonIdemPotenceEn && is_ni && ni_inside;
  assign not_ni_o = !ni_inside;
  assign empty_o    = !(|valid);

  // TODO: rewrite and separate into MUXES and write strobe logic
  always_comb begin : p_buffer
    wbuffer_d           = wbuffer_q;
    ni_pending_d        = ni_pending_q;
    dirty_rd_en         = 1'b0;
    req_port_o.data_gnt = 1'b0;
    wbuffer_wren        = 1'b0;

    // TAG lookup returns, mark corresponding word
    if (check_en_q1) begin
      if (|wbuffer_q[check_ptr_q1].valid) begin
        wbuffer_d[check_ptr_q1].checked = 1'b1;
        wbuffer_d[check_ptr_q1].hit_oh  = rd_hit_oh_q;
      end
    end

    // if an invalidation or cache line refill comes in and hits on the write buffer,
    // we have to discard our knowledge of the corresponding cacheline state
    for (int k = 0; k < CVA6Cfg.WtDcacheWbufDepth; k++) begin
      if (inval_hit[k]) begin
        wbuffer_d[k].checked = 1'b0;
      end
    end

    // once TX write response came back, we can clear the TX block. if it was not dirty, we
    // can completely evict it - otherwise we have to leave it there for retransmission
    if (evict) begin
      for (int k = 0; k < (CVA6Cfg.XLEN / 8); k++) begin
        if (tx_stat_q[rtrn_id].be[k]) begin
          wbuffer_d[rtrn_ptr].txblock[k] = 1'b0;
          if (!wbuffer_q[rtrn_ptr].dirty[k]) begin
            wbuffer_d[rtrn_ptr].valid[k] = 1'b0;

            // NOTE: this is not strictly needed, but makes it much
            // easier to debug, since no invalid data remains in the buffer
            // wbuffer_d[rtrn_ptr].data[k*8 +:8] = '0;
          end
        end
      end
      // if all bytes are evicted, clear the cache status flag
      if (wbuffer_d[rtrn_ptr].valid == 0) begin
        wbuffer_d[rtrn_ptr].checked = 1'b0;
        ni_pending_d[rtrn_ptr] = 1'b0;
      end
    end

    // mark bytes sent out to the memory system
    if (miss_req_o && miss_ack_i) begin
      dirty_rd_en = 1'b1;
      for (int k = 0; k < (CVA6Cfg.XLEN / 8); k++) begin
        if (tx_be[k]) begin
          wbuffer_d[dirty_ptr].dirty[k]   = 1'b0;
          wbuffer_d[dirty_ptr].txblock[k] = 1'b1;
        end
      end
    end

    // write new word into the buffer
    if (req_port_i.data_req && rdy) begin
      // in case we have an NI address, need to drain the buffer first
      // in case we are serving an NI address,  we block until it is written to memory
      if (!ni_conflict) begin  //empty of NI operations
        wbuffer_wren = 1'b1;

        req_port_o.data_gnt = 1'b1;
        ni_pending_d[wr_ptr] = is_ni;

        wbuffer_d[wr_ptr].checked = 1'b0;
        wbuffer_d[wr_ptr].wtag = {
          req_port_i.address_tag,
          req_port_i.address_index[CVA6Cfg.DCACHE_INDEX_WIDTH-1:CVA6Cfg.XLEN_ALIGN_BYTES]
        };

        // mark bytes as dirty
        for (int k = 0; k < (CVA6Cfg.XLEN / 8); k++) begin
          if (req_port_i.data_be[k]) begin
            wbuffer_d[wr_ptr].valid[k]     = 1'b1;
            wbuffer_d[wr_ptr].dirty[k]     = 1'b1;
            wbuffer_d[wr_ptr].data[k*8+:8] = req_port_i.data_wdata[k*8+:8];
            if (CVA6Cfg.DATA_USER_EN) begin
              wbuffer_d[wr_ptr].user[k*8+:8] = req_port_i.data_wuser[k*8+:8];
            end
          end
        end
      end
    end
  end


  ///////////////////////////////////////////////////////
  // ff's
  ///////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_regs
    if (!rst_ni) begin
      wbuffer_q    <= '{default: '0};
      tx_stat_q    <= '{default: '0};
      ni_pending_q <= '0;
      check_ptr_q  <= '0;
      check_ptr_q1 <= '0;
      check_en_q   <= '0;
      check_en_q1  <= '0;
      rd_tag_q     <= '0;
      rd_hit_oh_q  <= '0;
      wr_cl_vld_q  <= '0;
      wr_cl_idx_q  <= '0;
    end else begin
      wbuffer_q    <= wbuffer_d;
      tx_stat_q    <= tx_stat_d;
      ni_pending_q <= ni_pending_d;
      check_ptr_q  <= check_ptr_d;
      check_ptr_q1 <= check_ptr_q;
      check_en_q   <= check_en_d;
      check_en_q1  <= check_en_q;
      rd_tag_q     <= rd_tag_d;
      rd_hit_oh_q  <= rd_hit_oh_d;
      wr_cl_vld_q  <= wr_cl_vld_d;
      wr_cl_idx_q  <= wr_cl_idx_d;
    end
  end


  ///////////////////////////////////////////////////////
  // assertions
  ///////////////////////////////////////////////////////

  //pragma translate_off
`ifndef VERILATOR

  hot1 :
  assert property (@(posedge clk_i) disable iff (!rst_ni) req_port_i.data_req |-> $onehot0(
      wbuffer_hit_oh
  ))
  else $fatal(1, "[l1 dcache wbuffer] wbuffer_hit_oh signal must be hot1");

  tx_status :
  assert property (
    @(posedge clk_i) disable iff (!rst_ni) evict && miss_ack_i && miss_req_o |-> (tx_id != rtrn_id))
  else $fatal(1, "[l1 dcache wbuffer] cannot allocate and clear same tx slot id in the same cycle");

  tx_valid0 :
  assert property (@(posedge clk_i) disable iff (!rst_ni) evict |-> tx_stat_q[rtrn_id].vld)
  else $fatal(1, "[l1 dcache wbuffer] evicting invalid transaction slot");

  tx_valid1 :
  assert property (@(posedge clk_i) disable iff (!rst_ni) evict |-> |wbuffer_q[rtrn_ptr].valid)
  else $fatal(1, "[l1 dcache wbuffer] wbuffer entry corresponding to this transaction is invalid");

  write_full :
  assert property (
    @(posedge clk_i) disable iff (!rst_ni) req_port_i.data_req |-> req_port_o.data_gnt |-> ((!full) || (|wbuffer_hit_oh)))
  else $fatal(1, "[l1 dcache wbuffer] cannot write if full or no hit");

  unused0 :
  assert property (@(posedge clk_i) disable iff (!rst_ni) !req_port_i.tag_valid)
  else $fatal(1, "[l1 dcache wbuffer] req_port_i.tag_valid should not be asserted");

  unused1 :
  assert property (@(posedge clk_i) disable iff (!rst_ni) !req_port_i.kill_req)
  else $fatal(1, "[l1 dcache wbuffer] req_port_i.kill_req should not be asserted");

  for (genvar k = 0; k < CVA6Cfg.WtDcacheWbufDepth; k++) begin : gen_assert1
    for (genvar j = 0; j < (CVA6Cfg.XLEN / 8); j++) begin : gen_assert2
      byteStates :
      assert property (
        @(posedge clk_i) disable iff (!rst_ni) {wbuffer_q[k].valid[j], wbuffer_q[k].dirty[j], wbuffer_q[k].txblock[j]} inside {3'b000, 3'b110, 3'b101, 3'b111} )
      else
        $fatal(
            1,
            "[l1 dcache wbuffer] byte %02d of wbuffer entry %02d has invalid state: valid=%01b, dirty=%01b, txblock=%01b",
            j,
            k,
            wbuffer_q[k].valid[j],
            wbuffer_q[k].dirty[j],
            wbuffer_q[k].txblock[j]
        );
    end
  end
`endif
  //pragma translate_on

endmodule  // wt_dcache_wbuffer
