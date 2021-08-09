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
// Description: miss controller for WT dcache. Note that the current assumption
// is that the port with the highest index issues writes instead of reads.


module wt_dcache_missunit import ariane_pkg::*; import wt_cache_pkg::*; #(
  parameter bit                         Axi64BitCompliant  = 1'b0, // set this to 1 when using in conjunction with 64bit AXI bus adapter
  parameter logic [CACHE_ID_WIDTH-1:0]  AmoTxId            = 1,    // TX id to be used for AMOs
  parameter int unsigned                NumPorts           = 3     // number of miss ports
) (
  input  logic                                       clk_i,       // Clock
  input  logic                                       rst_ni,      // Asynchronous reset active low
  // cache management, signals from/to core
  input  logic                                       enable_i,    // from CSR
  input  logic                                       flush_i,     // flush request, this waits for pending tx (write, read) to finish and will clear the cache
  output logic                                       flush_ack_o, // send a single cycle acknowledge signal when the cache is flushed
  output logic                                       miss_o,      // we missed on a ld/st
  // local cache management signals
  input  logic                                       wbuffer_empty_i,
  output logic                                       cache_en_o,  // local cache enable signal
  // AMO interface
  input  amo_req_t                                   amo_req_i,
  output amo_resp_t                                  amo_resp_o,
  // miss handling interface (ld, ptw, wbuffer)
  input  logic [NumPorts-1:0]                        miss_req_i,
  output logic [NumPorts-1:0]                        miss_ack_o,
  input  logic [NumPorts-1:0]                        miss_nc_i,
  input  logic [NumPorts-1:0]                        miss_we_i,
  input  logic [NumPorts-1:0][63:0]                  miss_wdata_i,
  input  logic [NumPorts-1:0][riscv::PLEN-1:0]       miss_paddr_i,
  input  logic [NumPorts-1:0][DCACHE_SET_ASSOC-1:0]  miss_vld_bits_i,
  input  logic [NumPorts-1:0][2:0]                   miss_size_i,
  input  logic [NumPorts-1:0][CACHE_ID_WIDTH-1:0]    miss_id_i,          // used as transaction ID
  // signals that the request collided with a pending read
  output logic [NumPorts-1:0]                        miss_replay_o,
  // signals response from memory
  output logic [NumPorts-1:0]                        miss_rtrn_vld_o,
  output logic [CACHE_ID_WIDTH-1:0]                  miss_rtrn_id_o,     // only used for writes, set to zero fro reads
  // from writebuffer
  input  logic [DCACHE_MAX_TX-1:0][riscv::PLEN-1:0]  tx_paddr_i,         // used to check for address collisions with read operations
  input  logic [DCACHE_MAX_TX-1:0]                   tx_vld_i,           // used to check for address collisions with read operations
  // write interface to cache memory
  output logic                                       wr_cl_vld_o,        // writes a full cacheline
  output logic                                       wr_cl_nc_o,         // writes a full cacheline
  output logic [DCACHE_SET_ASSOC-1:0]                wr_cl_we_o,         // writes a full cacheline
  output logic [DCACHE_TAG_WIDTH-1:0]                wr_cl_tag_o,
  output logic [DCACHE_CL_IDX_WIDTH-1:0]             wr_cl_idx_o,
  output logic [DCACHE_OFFSET_WIDTH-1:0]             wr_cl_off_o,
  output logic [DCACHE_LINE_WIDTH-1:0]               wr_cl_data_o,
  output logic [DCACHE_LINE_WIDTH/8-1:0]             wr_cl_data_be_o,
  output logic [DCACHE_SET_ASSOC-1:0]                wr_vld_bits_o,
  // memory interface
  input  logic                                       mem_rtrn_vld_i,
  input  dcache_rtrn_t                               mem_rtrn_i,
  output logic                                       mem_data_req_o,
  input  logic                                       mem_data_ack_i,
  output dcache_req_t                                mem_data_o
);

  // controller FSM
  typedef enum logic[2:0] {IDLE, DRAIN, AMO,  FLUSH, STORE_WAIT, LOAD_WAIT, AMO_WAIT} state_e;
  state_e state_d, state_q;

  // MSHR for reads
  typedef struct packed {
    logic [riscv::PLEN-1:0]              paddr   ;
    logic [2:0]                          size    ;
    logic [DCACHE_SET_ASSOC-1:0]         vld_bits;
    logic [CACHE_ID_WIDTH-1:0]          id      ;
    logic                                nc      ;
    logic [$clog2(DCACHE_SET_ASSOC)-1:0] repl_way;
    logic [$clog2(NumPorts)-1:0]        miss_port_idx;
  } mshr_t;

  mshr_t mshr_d, mshr_q;
  logic [$clog2(DCACHE_SET_ASSOC)-1:0] repl_way, inv_way, rnd_way;
  logic mshr_vld_d, mshr_vld_q, mshr_vld_q1;
  logic mshr_allocate;
  logic update_lfsr, all_ways_valid;

  logic enable_d, enable_q;
  logic flush_ack_d, flush_ack_q;
  logic flush_en, flush_done;
  logic mask_reads, lock_reqs;
  logic amo_sel, miss_is_write;
  logic amo_req_d, amo_req_q;
  logic [63:0] amo_data, amo_rtrn_mux;
  logic [riscv::PLEN-1:0] tmp_paddr;
  logic [$clog2(NumPorts)-1:0] miss_port_idx;
  logic [DCACHE_CL_IDX_WIDTH-1:0] cnt_d, cnt_q;
  logic [NumPorts-1:0] miss_req_masked_d, miss_req_masked_q;

  logic inv_vld, inv_vld_all, cl_write_en;
  logic load_ack, store_ack, amo_ack;

  logic [NumPorts-1:0] mshr_rdrd_collision_d, mshr_rdrd_collision_q;
  logic [NumPorts-1:0] mshr_rdrd_collision;
  logic tx_rdwr_collision, mshr_rdwr_collision;

///////////////////////////////////////////////////////
// input arbitration and general control sigs
///////////////////////////////////////////////////////

  assign cache_en_o      = enable_q;
  assign cnt_d           = (flush_en) ? cnt_q + 1 : '0;
  assign flush_done      = (cnt_q == wt_cache_pkg::DCACHE_NUM_WORDS-1);

  assign miss_req_masked_d = (lock_reqs)  ? miss_req_masked_q      :
                             (mask_reads) ? miss_we_i & miss_req_i : miss_req_i;
  assign miss_is_write     = miss_we_i[miss_port_idx];

  // read port arbiter
  lzc #(
    .WIDTH ( NumPorts )
  ) i_lzc_reqs (
    .in_i    ( miss_req_masked_d ),
    .cnt_o   ( miss_port_idx     ),
    .empty_o (                   )
  );

  always_comb begin : p_ack
    miss_ack_o = '0;
    if (!amo_sel) begin
      miss_ack_o[miss_port_idx] = mem_data_ack_i & mem_data_req_o;
    end
  end

///////////////////////////////////////////////////////
// MSHR and way replacement logic (only for read ops)
///////////////////////////////////////////////////////

  // find invalid cache line
  lzc #(
    .WIDTH ( ariane_pkg::DCACHE_SET_ASSOC )
  ) i_lzc_inv (
    .in_i    ( ~miss_vld_bits_i[miss_port_idx] ),
    .cnt_o   ( inv_way                         ),
    .empty_o ( all_ways_valid                  )
  );

  // generate random cacheline index
  lfsr #(
    .LfsrWidth  ( ariane_pkg::DCACHE_SET_ASSOC        ),
    .OutWidth   ( $clog2(ariane_pkg::DCACHE_SET_ASSOC))
  ) i_lfsr_inv (
    .clk_i          ( clk_i       ),
    .rst_ni         ( rst_ni      ),
    .en_i           ( update_lfsr ),
    .out_o          ( rnd_way     )
  );

  assign repl_way               = (all_ways_valid) ? rnd_way : inv_way;

  assign mshr_d.size            = (mshr_allocate)  ? miss_size_i    [miss_port_idx] : mshr_q.size;
  assign mshr_d.paddr           = (mshr_allocate)  ? miss_paddr_i   [miss_port_idx] : mshr_q.paddr;
  assign mshr_d.vld_bits        = (mshr_allocate)  ? miss_vld_bits_i[miss_port_idx] : mshr_q.vld_bits;
  assign mshr_d.id              = (mshr_allocate)  ? miss_id_i      [miss_port_idx] : mshr_q.id;
  assign mshr_d.nc              = (mshr_allocate)  ? miss_nc_i      [miss_port_idx] : mshr_q.nc;
  assign mshr_d.repl_way        = (mshr_allocate)  ? repl_way                       : mshr_q.repl_way;
  assign mshr_d.miss_port_idx   = (mshr_allocate)  ? miss_port_idx                  : mshr_q.miss_port_idx;

  // currently we only have one outstanding read TX, hence an incoming load clears the MSHR
  assign mshr_vld_d = (mshr_allocate) ? 1'b1 :
                      (load_ack)      ? 1'b0 :
                                        mshr_vld_q;

  assign miss_o     = (mshr_allocate) ? ~miss_nc_i[miss_port_idx] : 1'b0;


  for(genvar k=0; k<NumPorts; k++) begin : gen_rdrd_collision
    assign mshr_rdrd_collision[k]   = (mshr_q.paddr[riscv::PLEN-1:DCACHE_OFFSET_WIDTH] == miss_paddr_i[k][riscv::PLEN-1:DCACHE_OFFSET_WIDTH]) && (mshr_vld_q | mshr_vld_q1);
    assign mshr_rdrd_collision_d[k] = (!miss_req_i[k]) ? 1'b0 : mshr_rdrd_collision_q[k] | mshr_rdrd_collision[k];
  end

  // read/write collision, stalls the corresponding request
  // write port[NumPorts-1] collides with MSHR_Q
  assign mshr_rdwr_collision = (mshr_q.paddr[riscv::PLEN-1:DCACHE_OFFSET_WIDTH] == miss_paddr_i[NumPorts-1][riscv::PLEN-1:DCACHE_OFFSET_WIDTH]) && mshr_vld_q;

  // read collides with inflight TX
  always_comb begin : p_tx_coll
    tx_rdwr_collision = 1'b0;
    for(int k=0; k<DCACHE_MAX_TX; k++) begin
      tx_rdwr_collision |= (miss_paddr_i[miss_port_idx][riscv::PLEN-1:DCACHE_OFFSET_WIDTH] == tx_paddr_i[k][riscv::PLEN-1:DCACHE_OFFSET_WIDTH]) && tx_vld_i[k];
    end
  end

///////////////////////////////////////////////////////
// to memory
///////////////////////////////////////////////////////

  // if size = 32bit word, select appropriate offset, replicate for openpiton...
  assign amo_data = (amo_req_i.size==2'b10) ? {amo_req_i.operand_b[0 +: 32],
                                               amo_req_i.operand_b[0 +: 32]} :
                                               amo_req_i.operand_b;

  // note: openpiton returns a full cacheline!
  if (Axi64BitCompliant) begin : gen_axi_rtrn_mux
    assign amo_rtrn_mux = mem_rtrn_i.data[0 +: 64];
  end else begin : gen_piton_rtrn_mux
    assign amo_rtrn_mux = mem_rtrn_i.data[amo_req_i.operand_a[DCACHE_OFFSET_WIDTH-1:3]*64 +: 64];
  end

  // always sign extend 32bit values
  assign amo_resp_o.result = (amo_req_i.size==2'b10) ? {{32{amo_rtrn_mux[amo_req_i.operand_a[2]*32 + 31]}},
                                                            amo_rtrn_mux[amo_req_i.operand_a[2]*32 +: 32]} :
                                                       amo_rtrn_mux;

  assign amo_req_d = amo_req_i.req;

  // outgoing memory requests (AMOs are always uncached)
  assign mem_data_o.tid    = (amo_sel) ? AmoTxId             : miss_id_i[miss_port_idx];
  assign mem_data_o.nc     = (amo_sel) ? 1'b1                : miss_nc_i[miss_port_idx];
  assign mem_data_o.way    = (amo_sel) ? '0                  : repl_way;
  assign mem_data_o.data   = (amo_sel) ? amo_data            : miss_wdata_i[miss_port_idx];
  assign mem_data_o.size   = (amo_sel) ? amo_req_i.size      : miss_size_i [miss_port_idx];
  assign mem_data_o.amo_op = (amo_sel) ? amo_req_i.amo_op    : AMO_NONE;

  assign tmp_paddr         = (amo_sel) ? amo_req_i.operand_a[riscv::PLEN-1:0] : miss_paddr_i[miss_port_idx];
  assign mem_data_o.paddr  = wt_cache_pkg::paddrSizeAlign(tmp_paddr, mem_data_o.size);

///////////////////////////////////////////////////////
// back-off mechanism for LR/SC completion guarantee
///////////////////////////////////////////////////////

  logic sc_fail, sc_pass, sc_backoff_over;
  exp_backoff #(
    .Seed(3),
    .MaxExp(16)
  ) i_exp_backoff (
    .clk_i,
    .rst_ni,
    .set_i     ( sc_fail         ),
    .clr_i     ( sc_pass         ),
    .is_zero_o ( sc_backoff_over )
  );

///////////////////////////////////////////////////////
// responses from memory
///////////////////////////////////////////////////////

  // keep track of pending stores
  logic store_sent;
  logic [$clog2(wt_cache_pkg::DCACHE_MAX_TX + 1)-1:0] stores_inflight_d, stores_inflight_q;
  assign store_sent = mem_data_req_o   & mem_data_ack_i & (mem_data_o.rtype == DCACHE_STORE_REQ);

  assign stores_inflight_d = (store_ack && store_sent) ? stores_inflight_q     :
                             (store_ack)               ? stores_inflight_q - 1 :
                             (store_sent)              ? stores_inflight_q + 1 :
                                                         stores_inflight_q;

  // incoming responses
  always_comb begin : p_rtrn_logic
    load_ack        = 1'b0;
    store_ack       = 1'b0;
    amo_ack         = 1'b0;
    inv_vld         = 1'b0;
    inv_vld_all     = 1'b0;
    sc_fail         = 1'b0;
    sc_pass         = 1'b0;
    miss_rtrn_vld_o ='0;
    if (mem_rtrn_vld_i) begin
      unique case (mem_rtrn_i.rtype)
        DCACHE_LOAD_ACK: begin
          if (mshr_vld_q) begin
            load_ack = 1'b1;
            miss_rtrn_vld_o[mshr_q.miss_port_idx] = 1'b1;
          end
        end
        DCACHE_STORE_ACK: begin
          if (stores_inflight_q) begin
            store_ack = 1'b1;
            miss_rtrn_vld_o[NumPorts-1] = 1'b1;
          end
        end
        DCACHE_ATOMIC_ACK: begin
          if (amo_req_q) begin
            amo_ack = 1'b1;
            // need to set SC backoff counter if
            // this op failed
            if (amo_req_i.amo_op == AMO_SC) begin
              if (amo_resp_o.result) begin
                sc_fail = 1'b1;
              end else begin
                sc_pass = 1'b1;
              end
            end
          end
        end
        DCACHE_INV_REQ: begin
          inv_vld     = mem_rtrn_i.inv.vld | mem_rtrn_i.inv.all;
          inv_vld_all = mem_rtrn_i.inv.all;
        end
        // TODO:
        // DCACHE_INT_REQ: begin
        // end
        default : begin
        end
      endcase
    end
  end

  // to write buffer
  assign miss_rtrn_id_o           = mem_rtrn_i.tid;

///////////////////////////////////////////////////////
// writes to cache memory
///////////////////////////////////////////////////////

  // cacheline write port
  assign wr_cl_nc_o      = mshr_q.nc;
  assign wr_cl_vld_o     = load_ack | (| wr_cl_we_o);

  assign wr_cl_we_o      = (flush_en   )  ? '1                                    :
                           (inv_vld_all)   ? '1                                    :
                           (inv_vld    )   ? dcache_way_bin2oh(mem_rtrn_i.inv.way) :
                           (cl_write_en)   ? dcache_way_bin2oh(mshr_q.repl_way)    :
                                             '0;

  assign wr_vld_bits_o   = (flush_en   )   ? '0                                    :
                           (inv_vld    )   ? '0                                    :
                           (cl_write_en)   ? dcache_way_bin2oh(mshr_q.repl_way)    :
                                              '0;

  assign wr_cl_idx_o     = (flush_en) ? cnt_q                                                        :
                           (inv_vld)  ? mem_rtrn_i.inv.idx[DCACHE_INDEX_WIDTH-1:DCACHE_OFFSET_WIDTH] :
                                        mshr_q.paddr[DCACHE_INDEX_WIDTH-1:DCACHE_OFFSET_WIDTH];

  assign wr_cl_tag_o     = mshr_q.paddr[DCACHE_TAG_WIDTH+DCACHE_INDEX_WIDTH-1:DCACHE_INDEX_WIDTH];
  assign wr_cl_off_o     = mshr_q.paddr[DCACHE_OFFSET_WIDTH-1:0];
  assign wr_cl_data_o    = mem_rtrn_i.data;
  assign wr_cl_data_be_o = (cl_write_en) ? '1 : '0;// we only write complete cachelines into the memory

  // only non-NC responses write to the cache
  assign cl_write_en     = load_ack & ~mshr_q.nc;

///////////////////////////////////////////////////////
// main control logic for generating tx
///////////////////////////////////////////////////////

  always_comb begin : p_fsm
    // default assignment
    state_d          = state_q;

    flush_ack_o      = 1'b0;
    mem_data_o.rtype = DCACHE_LOAD_REQ;
    mem_data_req_o   = 1'b0;
    amo_resp_o.ack   = 1'b0;
    miss_replay_o    = '0;

    // disabling cache is possible anytime, enabling goes via flush
    enable_d         = enable_q & enable_i;
    flush_ack_d      = flush_ack_q;
    flush_en         = 1'b0;
    amo_sel          = 1'b0;
    update_lfsr      = 1'b0;
    mshr_allocate    = 1'b0;
    lock_reqs        = 1'b0;
    mask_reads       = mshr_vld_q;

    // interfaces
    unique case (state_q)
      //////////////////////////////////
      // wait for misses / amo ops
      IDLE: begin
        if (flush_i || (enable_i && !enable_q)) begin
          if (wbuffer_empty_i && !mshr_vld_q) begin
            flush_ack_d = flush_i;
            state_d     = FLUSH;
          end else begin
            state_d     = DRAIN;
          end
        end else if (amo_req_i.req) begin
          if (wbuffer_empty_i && !mshr_vld_q) begin
            state_d     = AMO;
          end else begin
            state_d     = DRAIN;
          end
        // we've got a miss to handle
        end else if (|miss_req_masked_d) begin
          // this is a write miss, just pass through (but check whether write collides with MSHR)
          if (miss_is_write) begin
            // stall in case this write collides with the MSHR address
            if (!mshr_rdwr_collision) begin
              mem_data_req_o            = 1'b1;
              mem_data_o.rtype          = DCACHE_STORE_REQ;
              if (!mem_data_ack_i) begin
                state_d = STORE_WAIT;
              end
            end
          // this is a read miss, can only allocate 1 MSHR
          // in case of a load_ack we can accept a new miss, since the MSHR is being cleared
          end else if (!mshr_vld_q || load_ack) begin
            // replay the read request in case the address has collided with MSHR during the time the request was pending
            // i.e., the cache state may have been updated in the mean time due to a refill at the same CL address
            if (mshr_rdrd_collision_d[miss_port_idx]) begin
              miss_replay_o[miss_port_idx] = 1'b1;
            // stall in case this CL address overlaps with a write TX that is in flight
            end else if (!tx_rdwr_collision) begin
              mem_data_req_o            = 1'b1;
              mem_data_o.rtype          = DCACHE_LOAD_REQ;
              update_lfsr               = all_ways_valid & mem_data_ack_i;// need to evict a random way
              mshr_allocate             = mem_data_ack_i;
              if (!mem_data_ack_i) begin
                state_d = LOAD_WAIT;
              end
            end
          end
        end
      end
      //////////////////////////////////
      // wait until this request is acked
      STORE_WAIT: begin
        lock_reqs                 = 1'b1;
        mem_data_req_o            = 1'b1;
        mem_data_o.rtype          = DCACHE_STORE_REQ;
        if (mem_data_ack_i) begin
          state_d = IDLE;
        end
      end
      //////////////////////////////////
      // wait until this request is acked
      LOAD_WAIT: begin
        lock_reqs                 = 1'b1;
        mem_data_req_o            = 1'b1;
        mem_data_o.rtype          = DCACHE_LOAD_REQ;
        if (mem_data_ack_i) begin
          update_lfsr   = all_ways_valid;// need to evict a random way
          mshr_allocate = 1'b1;
          state_d       = IDLE;
        end
      end
      //////////////////////////////////
      // only handle stores, do not accept new read requests
      // wait until MSHR is cleared and wbuffer is empty
      DRAIN: begin
        mask_reads = 1'b1;
        // these are writes, check whether they collide with MSHR
        if (|miss_req_masked_d && !mshr_rdwr_collision) begin
          mem_data_req_o            = 1'b1;
          mem_data_o.rtype          = DCACHE_STORE_REQ;
        end

        if (wbuffer_empty_i && !mshr_vld_q) begin
          state_d = IDLE;
        end
      end
      //////////////////////////////////
      // flush the cache
      FLUSH: begin
        // internal flush signal
        flush_en   = 1'b1;
        if (flush_done) begin
          state_d     = IDLE;
          flush_ack_o = flush_ack_q;
          flush_ack_d = 1'b0;
          enable_d    = enable_i;
        end
      end
      //////////////////////////////////
      // send out amo op request
      AMO: begin
        mem_data_o.rtype = DCACHE_ATOMIC_REQ;
        amo_sel          = 1'b1;
        // if this is an LR, we need to consult the backoff counter
        if ((amo_req_i.amo_op != AMO_LR) || sc_backoff_over) begin
          mem_data_req_o   = 1'b1;
          if (mem_data_ack_i) begin
            state_d = AMO_WAIT;
          end
        end
      end
      //////////////////////////////////
      // block and wait until AMO OP returns
      AMO_WAIT: begin
        amo_sel = 1'b1;
        if (amo_ack) begin
          amo_resp_o.ack = 1'b1;
          state_d        = IDLE;
        end
      end
      //////////////////////////////////
      default: begin
        // we should never get here
        state_d = IDLE;
      end
    endcase // state_q
  end

///////////////////////////////////////////////////////
// ff's
///////////////////////////////////////////////////////

always_ff @(posedge clk_i or negedge rst_ni) begin : p_regs
  if (!rst_ni) begin
    state_q               <= FLUSH;
    cnt_q                 <= '0;
    enable_q              <= '0;
    flush_ack_q           <= '0;
    mshr_vld_q            <= '0;
    mshr_vld_q1           <= '0;
    mshr_q                <= '0;
    mshr_rdrd_collision_q <= '0;
    miss_req_masked_q     <= '0;
    amo_req_q             <= '0;
    stores_inflight_q     <= '0;
  end else begin
    state_q               <= state_d;
    cnt_q                 <= cnt_d;
    enable_q              <= enable_d;
    flush_ack_q           <= flush_ack_d;
    mshr_vld_q            <= mshr_vld_d;
    mshr_vld_q1           <= mshr_vld_q;
    mshr_q                <= mshr_d;
    mshr_rdrd_collision_q <= mshr_rdrd_collision_d;
    miss_req_masked_q     <= miss_req_masked_d;
    amo_req_q             <= amo_req_d;
    stores_inflight_q     <= stores_inflight_d;
  end
end

///////////////////////////////////////////////////////
// assertions
///////////////////////////////////////////////////////

//pragma translate_off
`ifndef VERILATOR

  read_tid : assert property (
    @(posedge clk_i) disable iff (!rst_ni) mshr_vld_q |-> mem_rtrn_vld_i |-> load_ack |-> mem_rtrn_i.tid == mshr_q.id)
      else $fatal(1,"[l1 dcache missunit] TID of load response doesn't match");

  read_ports : assert property (
    @(posedge clk_i) disable iff (!rst_ni) |miss_req_i[NumPorts-2:0] |-> miss_we_i[NumPorts-2:0] == 0)
      else $fatal(1,"[l1 dcache missunit] only last port can issue write requests");

  write_port : assert property (
    @(posedge clk_i) disable iff (!rst_ni) miss_req_i[NumPorts-1] |-> miss_we_i[NumPorts-1])
      else $fatal(1,"[l1 dcache missunit] last port can only issue write requests");

 initial begin
    // assert wrong parameterizations
    assert (NumPorts>=2)
      else $fatal(1,"[l1 dcache missunit] at least two ports are required (one read port, one write port)");
 end
`endif
//pragma translate_on

endmodule // wt_dcache_missunit
