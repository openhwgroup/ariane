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
// Date: 08.08.2018
// Description: adapter module to connect the L1D$ and L1I$ to a 64bit AXI bus.
//


module wt_axi_adapter
  import ariane_pkg::*;
  import wt_cache_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter int unsigned ReqFifoDepth = 2,
    parameter int unsigned MetaFifoDepth = CVA6Cfg.DCACHE_MAX_TX,
    parameter type axi_req_t = logic,
    parameter type axi_rsp_t = logic,
    parameter type dcache_req_t = logic,
    parameter type dcache_rtrn_t = logic,
    parameter type dcache_inval_t = logic,
    parameter type icache_req_t = logic,
    parameter type icache_rtrn_t = logic
) (
    input logic clk_i,
    input logic rst_ni,

    // icache
    input  logic         icache_data_req_i,
    output logic         icache_data_ack_o,
    input  icache_req_t  icache_data_i,
    // returning packets must be consumed immediately
    output logic         icache_rtrn_vld_o,
    output icache_rtrn_t icache_rtrn_o,

    // dcache
    input  logic         dcache_data_req_i,
    output logic         dcache_data_ack_o,
    input  dcache_req_t  dcache_data_i,
    // returning packets must be consumed immediately
    output logic         dcache_rtrn_vld_o,
    output dcache_rtrn_t dcache_rtrn_o,

    // AXI port
    output axi_req_t axi_req_o,
    input  axi_rsp_t axi_resp_i,

    // Invalidations
    input  logic [63:0] inval_addr_i,
    input  logic        inval_valid_i,
    output logic        inval_ready_o
);

  // support up to 512bit cache lines
  localparam AxiNumWords = (CVA6Cfg.ICACHE_LINE_WIDTH/CVA6Cfg.AxiDataWidth) * (CVA6Cfg.ICACHE_LINE_WIDTH > CVA6Cfg.DCACHE_LINE_WIDTH)  +
                           (CVA6Cfg.DCACHE_LINE_WIDTH/CVA6Cfg.AxiDataWidth) * (CVA6Cfg.ICACHE_LINE_WIDTH <= CVA6Cfg.DCACHE_LINE_WIDTH) ;
  localparam MaxNumWords = $clog2(CVA6Cfg.AxiDataWidth / 8);
  localparam AxiRdBlenIcache = CVA6Cfg.ICACHE_LINE_WIDTH / CVA6Cfg.AxiDataWidth - 1;
  localparam AxiRdBlenDcache = CVA6Cfg.DCACHE_LINE_WIDTH / CVA6Cfg.AxiDataWidth - 1;
  localparam AxiBlenWidth = AxiNumWords > 1 ? $clog2(AxiNumWords) : AxiNumWords;

  ///////////////////////////////////////////////////////
  // request path
  ///////////////////////////////////////////////////////

  icache_req_t icache_data;
  logic icache_data_full, icache_data_empty;
  dcache_req_t dcache_data;
  logic dcache_data_full, dcache_data_empty;

  logic [1:0] arb_req, arb_ack;
  logic arb_idx, arb_gnt;

  logic axi_rd_req, axi_rd_gnt;
  logic axi_wr_req, axi_wr_gnt;
  logic axi_wr_valid, axi_rd_valid, axi_rd_rdy, axi_wr_rdy;
  logic axi_rd_lock, axi_wr_lock, axi_rd_exokay, axi_wr_exokay, wr_exokay;
  logic [CVA6Cfg.AxiAddrWidth-1:0] axi_rd_addr, axi_wr_addr;
  logic [AxiBlenWidth-1:0] axi_rd_blen, axi_wr_blen;
  logic [2:0] axi_rd_size, axi_wr_size;
  logic [CVA6Cfg.AxiIdWidth-1:0]
      axi_rd_id_in, axi_wr_id_in, axi_rd_id_out, axi_wr_id_out, wr_id_out;
  logic [AxiNumWords-1:0][CVA6Cfg.AxiDataWidth-1:0] axi_wr_data;
  logic [AxiNumWords-1:0][CVA6Cfg.AxiUserWidth-1:0] axi_wr_user;
  logic [CVA6Cfg.AxiDataWidth-1:0] axi_rd_data;
  logic [CVA6Cfg.AxiUserWidth-1:0] axi_rd_user;
  logic [AxiNumWords-1:0][(CVA6Cfg.AxiDataWidth/8)-1:0] axi_wr_be;
  logic [5:0] axi_wr_atop;
  logic invalidate;
  logic [$clog2(CVA6Cfg.AxiDataWidth/8)-1:0] amo_off_d, amo_off_q;
  // AMO generates r beat
  logic amo_gen_r_d, amo_gen_r_q;

  logic [CVA6Cfg.MEM_TID_WIDTH-1:0] icache_rtrn_tid_d, icache_rtrn_tid_q;
  logic [CVA6Cfg.MEM_TID_WIDTH-1:0] dcache_rtrn_tid_d, dcache_rtrn_tid_q;
  logic [CVA6Cfg.MEM_TID_WIDTH-1:0] dcache_rtrn_rd_tid, dcache_rtrn_wr_tid;
  logic dcache_rd_pop, dcache_wr_pop;
  logic icache_rd_full, icache_rd_empty;
  logic dcache_rd_full, dcache_rd_empty;
  logic dcache_wr_full, dcache_wr_empty;

  assign icache_data_ack_o = icache_data_req_i & ~icache_data_full;
  assign dcache_data_ack_o = dcache_data_req_i & ~dcache_data_full;

  // arbiter
  assign arb_req = {
    ~(dcache_data_empty | dcache_wr_full | dcache_rd_full), ~(icache_data_empty | icache_rd_full)
  };

  assign arb_gnt = axi_rd_gnt | axi_wr_gnt;

  rr_arb_tree #(
      .NumIn    (2),
      .DataWidth(1),
      .AxiVldRdy(1'b1),
      .LockIn   (1'b1)
  ) i_rr_arb_tree (
      .clk_i  (clk_i),
      .rst_ni (rst_ni),
      .flush_i('0),
      .rr_i   ('0),
      .req_i  (arb_req),
      .gnt_o  (arb_ack),
      .data_i ('0),
      .gnt_i  (arb_gnt),
      .req_o  (),
      .data_o (),
      .idx_o  (arb_idx)
  );

  // request side
  always_comb begin : p_axi_req
    // write channel
    axi_wr_id_in = {{CVA6Cfg.AxiIdWidth-1{1'b0}}, arb_idx};
    axi_wr_data[0]  = {(CVA6Cfg.AxiDataWidth/CVA6Cfg.XLEN){dcache_data.data}};
    axi_wr_user[0]  = dcache_data.user;
    // Cast to AXI address width
    axi_wr_addr  = CVA6Cfg.AxiAddrWidth'(dcache_data.paddr);
    axi_wr_size  = dcache_data.size;
    axi_wr_req   = 1'b0;
    axi_wr_blen  = '0;// single word writes
    axi_wr_be    = '0;
    axi_wr_lock  = '0;
    axi_wr_atop  = '0;
    amo_off_d    = amo_off_q;
    amo_gen_r_d  = amo_gen_r_q;

    // read channel
    axi_rd_id_in = {{CVA6Cfg.AxiIdWidth-1{1'b0}}, arb_idx};
    axi_rd_req   = 1'b0;
    axi_rd_lock  = '0;
    axi_rd_blen  = '0;

    if (dcache_data.paddr[2] == 1'b0) begin
      axi_wr_user = {{64 - CVA6Cfg.AxiUserWidth{1'b0}}, dcache_data.user};
    end else begin
      axi_wr_user = {dcache_data.user, {64 - CVA6Cfg.AxiUserWidth{1'b0}}};
    end

    // arbiter mux
    if (arb_idx) begin
      // Cast to AXI address width
      axi_rd_addr = CVA6Cfg.AxiAddrWidth'(dcache_data.paddr);
      // If dcache_data.size MSB is set, we want to read as much as possible
      axi_rd_size = dcache_data.size[2] ? MaxNumWords[2:0] : dcache_data.size;
      if (dcache_data.size[2]) begin
        axi_rd_blen = AxiRdBlenDcache[AxiBlenWidth-1:0];
      end
    end else begin
      // Cast to AXI address width
      axi_rd_addr = CVA6Cfg.AxiAddrWidth'(icache_data.paddr);
      axi_rd_size = MaxNumWords[2:0];  // always request max number of words in case of ifill
      if (!icache_data.nc) begin
        axi_rd_blen = AxiRdBlenIcache[AxiBlenWidth-1:0];
      end
    end

    // signal that an invalidation message
    // needs to be generated
    invalidate = 1'b0;

    // decode message type
    if (|arb_req) begin
      if (arb_idx == 0) begin
        //////////////////////////////////////
        // IMISS
        axi_rd_req = 1'b1;
        //////////////////////////////////////
      end else begin
        unique case (dcache_data.rtype)
          //////////////////////////////////////
          wt_cache_pkg::DCACHE_LOAD_REQ: begin
            axi_rd_req = 1'b1;
          end
          //////////////////////////////////////
          wt_cache_pkg::DCACHE_STORE_REQ: begin
            axi_wr_req = 1'b1;
            axi_wr_be  = '0;
            unique case (dcache_data.size[1:0])
              2'b00:
              axi_wr_be[0][dcache_data.paddr[$clog2(CVA6Cfg.AxiDataWidth/8)-1:0]] = '1;  // byte
              2'b01:
              axi_wr_be[0][dcache_data.paddr[$clog2(CVA6Cfg.AxiDataWidth/8)-1:0]+:2] = '1;  // hword
              2'b10:
              axi_wr_be[0][dcache_data.paddr[$clog2(CVA6Cfg.AxiDataWidth/8)-1:0]+:4] = '1;  // word
              default:
              if (CVA6Cfg.IS_XLEN64)
                axi_wr_be[0][dcache_data.paddr[$clog2(
                    CVA6Cfg.AxiDataWidth/8
                )-1:0]+:8] = '1;  // dword
            endcase
          end
          //////////////////////////////////////
          wt_cache_pkg::DCACHE_ATOMIC_REQ: begin
            if (CVA6Cfg.RVA) begin
              // default
              // push back an invalidation here.
              // since we only keep one read tx in flight, and since
              // the dcache drains all writes/reads before executing
              // an atomic, this is safe.
              invalidate = arb_gnt;
              axi_wr_req = 1'b1;
              axi_wr_be  = '0;
              unique case (dcache_data.size[1:0])
                2'b00:
                axi_wr_be[0][dcache_data.paddr[$clog2(CVA6Cfg.AxiDataWidth/8)-1:0]] = '1;  // byte
                2'b01:
                axi_wr_be[0][dcache_data.paddr[$clog2(CVA6Cfg.AxiDataWidth/8)-1:0]+:2] =
                    '1;  // hword
                2'b10:
                axi_wr_be[0][dcache_data.paddr[$clog2(CVA6Cfg.AxiDataWidth/8)-1:0]+:4] =
                    '1;  // word
                default:
                axi_wr_be[0][dcache_data.paddr[$clog2(CVA6Cfg.AxiDataWidth/8)-1:0]+:8] =
                    '1;  // dword
              endcase
              amo_gen_r_d = 1'b1;
              // need to use a separate ID here, so concat an additional bit
              axi_wr_id_in[1] = 1'b1;

              unique case (dcache_data.amo_op)
                AMO_LR: begin
                  axi_rd_lock     = 1'b1;
                  axi_rd_req      = 1'b1;
                  axi_rd_id_in[1] = 1'b1;
                  // tie to zero in this special case
                  axi_wr_req      = 1'b0;
                  axi_wr_be       = '0;
                end
                AMO_SC: begin
                  axi_wr_lock = 1'b1;
                  amo_gen_r_d = 1'b0;
                  // needed to properly encode success. store the result at offset within the returned
                  // AXI data word aligned with the requested word size.
                  amo_off_d = dcache_data.paddr[$clog2(CVA6Cfg.AxiDataWidth/8)-
                                                1:0] & ~((1 << dcache_data.size[1:0]) - 1);
                end
                // RISC-V atops have a load semantic
                AMO_SWAP: axi_wr_atop = axi_pkg::ATOP_ATOMICSWAP;
                AMO_ADD:
                axi_wr_atop = {
                  axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_ADD
                };
                AMO_AND: begin
                  // in this case we need to invert the data to get a "CLR"
                  axi_wr_data[0] = ~{(CVA6Cfg.AxiDataWidth / CVA6Cfg.XLEN) {dcache_data.data}};
                  axi_wr_user = ~{(CVA6Cfg.AxiDataWidth / CVA6Cfg.XLEN) {dcache_data.user}};
                  axi_wr_atop = {
                    axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_CLR
                  };
                end
                AMO_OR:
                axi_wr_atop = {
                  axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SET
                };
                AMO_XOR:
                axi_wr_atop = {
                  axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_EOR
                };
                AMO_MAX:
                axi_wr_atop = {
                  axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SMAX
                };
                AMO_MAXU:
                axi_wr_atop = {
                  axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_UMAX
                };
                AMO_MIN:
                axi_wr_atop = {
                  axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SMIN
                };
                AMO_MINU:
                axi_wr_atop = {
                  axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_UMIN
                };
                default: ;  // Do nothing
              endcase
            end
          end
          default: ;  // Do nothing
          //////////////////////////////////////
        endcase
      end
    end
  end

  cva6_fifo_v3 #(
      .FPGA_ALTERA(CVA6Cfg.FpgaAlteraEn),
      .dtype(icache_req_t),
      .DEPTH(ReqFifoDepth),
      .FPGA_EN(CVA6Cfg.FpgaEn)
  ) i_icache_data_fifo (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .flush_i   (1'b0),
      .testmode_i(1'b0),
      .full_o    (icache_data_full),
      .empty_o   (icache_data_empty),
      .usage_o   (),
      .data_i    (icache_data_i),
      .push_i    (icache_data_ack_o),
      .data_o    (icache_data),
      .pop_i     (arb_ack[0])
  );

  cva6_fifo_v3 #(
      .FPGA_ALTERA(CVA6Cfg.FpgaAlteraEn),
      .dtype(dcache_req_t),
      .DEPTH(ReqFifoDepth),
      .FPGA_EN(CVA6Cfg.FpgaEn)
  ) i_dcache_data_fifo (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .flush_i   (1'b0),
      .testmode_i(1'b0),
      .full_o    (dcache_data_full),
      .empty_o   (dcache_data_empty),
      .usage_o   (),
      .data_i    (dcache_data_i),
      .push_i    (dcache_data_ack_o),
      .data_o    (dcache_data),
      .pop_i     (arb_ack[1])
  );

  ///////////////////////////////////////////////////////
  // meta info feedback fifos
  ///////////////////////////////////////////////////////

  logic icache_rtrn_rd_en, dcache_rtrn_rd_en;
  logic icache_rtrn_vld_d, icache_rtrn_vld_q, dcache_rtrn_vld_d, dcache_rtrn_vld_q;

  cva6_fifo_v3 #(
      .DATA_WIDTH(CVA6Cfg.MEM_TID_WIDTH),
      .DEPTH     (MetaFifoDepth),
      .FPGA_EN   (CVA6Cfg.FpgaEn)
  ) i_rd_icache_id (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .flush_i   (1'b0),
      .testmode_i(1'b0),
      .full_o    (icache_rd_full),
      .empty_o   (icache_rd_empty),
      .usage_o   (),
      .data_i    (icache_data.tid),
      .push_i    (arb_ack[0] & axi_rd_gnt),
      .data_o    (icache_rtrn_tid_d),
      .pop_i     (icache_rtrn_vld_d)
  );

  cva6_fifo_v3 #(
      .DATA_WIDTH(CVA6Cfg.MEM_TID_WIDTH),
      .DEPTH     (MetaFifoDepth),
      .FPGA_EN   (CVA6Cfg.FpgaEn)
  ) i_rd_dcache_id (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .flush_i   (1'b0),
      .testmode_i(1'b0),
      .full_o    (dcache_rd_full),
      .empty_o   (dcache_rd_empty),
      .usage_o   (),
      .data_i    (dcache_data.tid),
      .push_i    (arb_ack[1] & axi_rd_gnt),
      .data_o    (dcache_rtrn_rd_tid),
      .pop_i     (dcache_rd_pop)
  );

  cva6_fifo_v3 #(
      .DATA_WIDTH(CVA6Cfg.MEM_TID_WIDTH),
      .DEPTH     (MetaFifoDepth),
      .FPGA_EN   (CVA6Cfg.FpgaEn)
  ) i_wr_dcache_id (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .flush_i   (1'b0),
      .testmode_i(1'b0),
      .full_o    (dcache_wr_full),
      .empty_o   (dcache_wr_empty),
      .usage_o   (),
      .data_i    (dcache_data.tid),
      .push_i    (arb_ack[1] & axi_wr_gnt),
      .data_o    (dcache_rtrn_wr_tid),
      .pop_i     (dcache_wr_pop)
  );

  // select correct tid to return
  assign dcache_rtrn_tid_d = (dcache_wr_pop) ? dcache_rtrn_wr_tid : dcache_rtrn_rd_tid;

  ///////////////////////////////////////////////////////
  // return path
  ///////////////////////////////////////////////////////

  // buffer write responses
  logic b_full, b_empty, b_push, b_pop;
  assign axi_wr_rdy = ~b_full;
  assign b_push     = axi_wr_valid & axi_wr_rdy;

  cva6_fifo_v3 #(
      .DATA_WIDTH  (CVA6Cfg.AxiIdWidth + 1),
      .DEPTH       (MetaFifoDepth),
      .FALL_THROUGH(1'b1),
      .FPGA_EN     (CVA6Cfg.FpgaEn)
  ) i_b_fifo (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .flush_i   (1'b0),
      .testmode_i(1'b0),
      .full_o    (b_full),
      .empty_o   (b_empty),
      .usage_o   (),
      .data_i    ({axi_wr_exokay, axi_wr_id_out}),
      .push_i    (b_push),
      .data_o    ({wr_exokay, wr_id_out}),
      .pop_i     (b_pop)
  );

  // buffer read responses in shift regs
  logic icache_first_d, icache_first_q, dcache_first_d, dcache_first_q;
  logic [CVA6Cfg.ICACHE_USER_LINE_WIDTH/CVA6Cfg.AxiUserWidth-1:0][CVA6Cfg.AxiUserWidth-1:0]
      icache_rd_shift_user_d, icache_rd_shift_user_q;
  logic [CVA6Cfg.DCACHE_USER_LINE_WIDTH/CVA6Cfg.AxiUserWidth-1:0][CVA6Cfg.AxiUserWidth-1:0]
      dcache_rd_shift_user_d, dcache_rd_shift_user_q;
  logic [CVA6Cfg.ICACHE_LINE_WIDTH/CVA6Cfg.AxiDataWidth-1:0][CVA6Cfg.AxiDataWidth-1:0]
      icache_rd_shift_d, icache_rd_shift_q;
  logic [CVA6Cfg.DCACHE_LINE_WIDTH/CVA6Cfg.AxiDataWidth-1:0][CVA6Cfg.AxiDataWidth-1:0]
      dcache_rd_shift_d, dcache_rd_shift_q;
  wt_cache_pkg::dcache_in_t dcache_rtrn_type_d, dcache_rtrn_type_q;
  dcache_inval_t dcache_rtrn_inv_d, dcache_rtrn_inv_q;
  logic dcache_sc_rtrn, axi_rd_last;

  always_comb begin : p_axi_rtrn_shift
    // output directly from regs
    icache_rtrn_o          = '0;
    icache_rtrn_o.rtype    = wt_cache_pkg::ICACHE_IFILL_ACK;
    icache_rtrn_o.tid      = icache_rtrn_tid_q;
    icache_rtrn_o.data     = icache_rd_shift_q;
    icache_rtrn_o.user     = icache_rd_shift_user_q;
    icache_rtrn_vld_o      = icache_rtrn_vld_q;

    dcache_rtrn_o          = '0;
    dcache_rtrn_o.rtype    = dcache_rtrn_type_q;
    dcache_rtrn_o.inv      = dcache_rtrn_inv_q;
    dcache_rtrn_o.tid      = dcache_rtrn_tid_q;
    dcache_rtrn_o.data     = dcache_rd_shift_q;
    dcache_rtrn_o.user     = dcache_rd_shift_user_q;
    dcache_rtrn_vld_o      = dcache_rtrn_vld_q;

    // read shift registers
    icache_rd_shift_d      = icache_rd_shift_q;
    icache_rd_shift_user_d = icache_rd_shift_user_q;
    dcache_rd_shift_d      = dcache_rd_shift_q;
    dcache_rd_shift_user_d = dcache_rd_shift_user_q;
    icache_first_d         = icache_first_q;
    dcache_first_d         = dcache_first_q;

    if (icache_rtrn_rd_en) begin
      icache_first_d = axi_rd_last;
      if (CVA6Cfg.ICACHE_LINE_WIDTH == CVA6Cfg.AxiDataWidth) begin
        icache_rd_shift_d[0] = axi_rd_data;
      end else begin
        icache_rd_shift_d = {
          axi_rd_data, icache_rd_shift_q[CVA6Cfg.ICACHE_LINE_WIDTH/CVA6Cfg.AxiDataWidth-1:1]
        };
      end
      icache_rd_shift_user_d = {
        axi_rd_user, icache_rd_shift_user_q[CVA6Cfg.ICACHE_USER_LINE_WIDTH/CVA6Cfg.AxiUserWidth-1:1]
      };
      // if this is a single word transaction, we need to make sure that word is placed at offset 0
      if (icache_first_q) begin
        icache_rd_shift_d[0] = axi_rd_data;
        icache_rd_shift_user_d[0] = axi_rd_user;
      end
    end

    if (dcache_rtrn_rd_en) begin
      dcache_first_d = axi_rd_last;
      if (CVA6Cfg.DCACHE_LINE_WIDTH == CVA6Cfg.AxiDataWidth) begin
        dcache_rd_shift_d[0] = axi_rd_data;
      end else begin
        dcache_rd_shift_d = {
          axi_rd_data, dcache_rd_shift_q[CVA6Cfg.DCACHE_LINE_WIDTH/CVA6Cfg.AxiDataWidth-1:1]
        };
      end
      dcache_rd_shift_user_d = {
        axi_rd_user, dcache_rd_shift_user_q[CVA6Cfg.DCACHE_USER_LINE_WIDTH/CVA6Cfg.AxiUserWidth-1:1]
      };
      // if this is a single word transaction, we need to make sure that word is placed at offset 0
      if (dcache_first_q) begin
        dcache_rd_shift_d[0] = axi_rd_data;
        dcache_rd_shift_user_d[0] = axi_rd_user;
      end
    end else if (CVA6Cfg.RVA && dcache_sc_rtrn) begin
      // encode lr/sc success
      dcache_rd_shift_d[0] = '0;
      dcache_rd_shift_user_d[0] = '0;
      dcache_rd_shift_d[0][amo_off_q*8] = (wr_exokay) ? '0 : 1'b1;
      dcache_rd_shift_user_d[0][amo_off_q*8] = (wr_exokay) ? '0 : 1'b1;
    end
  end

  // decode virtual read channels of icache
  always_comb begin : p_axi_rtrn_decode
    // we are not ready when invalidating
    // note: b's are buffered separately
    axi_rd_rdy        = ~invalidate;

    icache_rtrn_rd_en = 1'b0;
    icache_rtrn_vld_d = 1'b0;

    // decode virtual icache channel,
    // this is independent on dcache decoding below
    if (axi_rd_valid && axi_rd_id_out == 0 && axi_rd_rdy) begin
      icache_rtrn_rd_en = 1'b1;
      icache_rtrn_vld_d = axi_rd_last;
    end

    dcache_rtrn_rd_en  = 1'b0;
    dcache_rtrn_vld_d  = 1'b0;
    dcache_rd_pop      = 1'b0;
    dcache_wr_pop      = 1'b0;
    dcache_rtrn_inv_d  = '0;
    dcache_rtrn_type_d = wt_cache_pkg::DCACHE_LOAD_ACK;
    b_pop              = 1'b0;
    dcache_sc_rtrn     = 1'b0;

    // External invalidation requests (from coprocessor). This is safe as
    // there are no other transactions when a coprocessor has pending stores.
    inval_ready_o      = 1'b0;
    if (inval_valid_i) begin
      inval_ready_o         = 1'b1;
      dcache_rtrn_type_d    = wt_cache_pkg::DCACHE_INV_REQ;
      dcache_rtrn_vld_d     = 1'b1;
      dcache_rtrn_inv_d.all = 1'b1;
      dcache_rtrn_inv_d.idx = inval_addr_i[CVA6Cfg.DCACHE_INDEX_WIDTH-1:0];
      //////////////////////////////////////
      // dcache needs some special treatment
      // for arbitration and decoding of atomics
      //////////////////////////////////////
      // this is safe, there is no other read tx in flight than this atomic.
      // note that this self invalidation is handled in this way due to the
      // write-through cache architecture, which is aligned with the openpiton
      // cache subsystem.
    end else if (CVA6Cfg.RVA && invalidate) begin
      dcache_rtrn_type_d = wt_cache_pkg::DCACHE_INV_REQ;
      dcache_rtrn_vld_d = 1'b1;

      dcache_rtrn_inv_d.all = 1'b1;
      dcache_rtrn_inv_d.idx = dcache_data.paddr[CVA6Cfg.DCACHE_INDEX_WIDTH-1:0];
      //////////////////////////////////////
      // read responses
      // note that in case of atomics, the dcache sequentializes requests and
      // guarantees that there are no other pending transactions in flight
    end else if (axi_rd_valid && axi_rd_id_out[0] && axi_rd_rdy) begin
      dcache_rtrn_rd_en = 1'b1;
      dcache_rtrn_vld_d = axi_rd_last;

      // if this was an atomic op
      if (CVA6Cfg.RVA && axi_rd_id_out[1]) begin
        dcache_rtrn_type_d = wt_cache_pkg::DCACHE_ATOMIC_ACK;

        // check if transaction was issued over write channel and pop that ID
        if (!dcache_wr_empty) begin
          dcache_wr_pop = axi_rd_last;
          // if this is not the case, there MUST be an id in the read channel (LR)
        end else begin
          dcache_rd_pop = axi_rd_last;
        end
      end else begin
        dcache_rd_pop = axi_rd_last;
      end
      //////////////////////////////////////
      // write responses, check b fifo
    end else if (!b_empty) begin
      b_pop = 1'b1;

      // this was an atomic
      if (CVA6Cfg.RVA && wr_id_out[1]) begin
        dcache_rtrn_type_d = wt_cache_pkg::DCACHE_ATOMIC_ACK;

        // silently discard b response if we already popped the fifo
        // with a R beat (iff the amo transaction generated an R beat)
        if (!amo_gen_r_q) begin
          dcache_rtrn_vld_d = 1'b1;
          dcache_wr_pop     = 1'b1;
          dcache_sc_rtrn    = 1'b1;
        end
      end else begin
        // regular response
        dcache_rtrn_type_d = wt_cache_pkg::DCACHE_STORE_ACK;
        dcache_rtrn_vld_d  = 1'b1;
        dcache_wr_pop      = 1'b1;
      end
    end
    //////////////////////////////////////
  end

  // remote invalidations are not supported yet (this needs a cache coherence protocol)
  // note that the atomic transactions would also need a "master exclusive monitor" in that case
  // assign icache_rtrn_o.inv.idx  = '0;
  // assign icache_rtrn_o.inv.way  = '0;
  // assign icache_rtrn_o.inv.vld  = '0;
  // assign icache_rtrn_o.inv.all  = '0;

  // assign dcache_rtrn_o.inv.idx  = '0;
  // assign dcache_rtrn_o.inv.way  = '0;
  // assign dcache_rtrn_o.inv.vld  = '0;
  // assign dcache_rtrn_o.inv.all  = '0;

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_rd_buf
    if (!rst_ni) begin
      icache_first_q         <= 1'b1;
      dcache_first_q         <= 1'b1;
      icache_rd_shift_q      <= '0;
      icache_rd_shift_user_q <= '0;
      dcache_rd_shift_q      <= '0;
      dcache_rd_shift_user_q <= '0;
      icache_rtrn_vld_q      <= '0;
      dcache_rtrn_vld_q      <= '0;
      icache_rtrn_tid_q      <= '0;
      dcache_rtrn_tid_q      <= '0;
      dcache_rtrn_type_q     <= wt_cache_pkg::DCACHE_LOAD_ACK;
      dcache_rtrn_inv_q      <= '0;
      amo_off_q              <= '0;
      amo_gen_r_q            <= 1'b0;
    end else begin
      icache_first_q         <= icache_first_d;
      dcache_first_q         <= dcache_first_d;
      icache_rd_shift_q      <= icache_rd_shift_d;
      icache_rd_shift_user_q <= icache_rd_shift_user_d;
      dcache_rd_shift_q      <= dcache_rd_shift_d;
      dcache_rd_shift_user_q <= dcache_rd_shift_user_d;
      icache_rtrn_vld_q      <= icache_rtrn_vld_d;
      dcache_rtrn_vld_q      <= dcache_rtrn_vld_d;
      icache_rtrn_tid_q      <= icache_rtrn_tid_d;
      dcache_rtrn_tid_q      <= dcache_rtrn_tid_d;
      dcache_rtrn_type_q     <= dcache_rtrn_type_d;
      dcache_rtrn_inv_q      <= dcache_rtrn_inv_d;
      amo_off_q              <= amo_off_d;
      amo_gen_r_q            <= amo_gen_r_d;
    end
  end


  ///////////////////////////////////////////////////////
  // axi protocol shim
  ///////////////////////////////////////////////////////

  axi_shim #(
      .CVA6Cfg    (CVA6Cfg),
      .AxiNumWords(AxiNumWords),
      .axi_req_t  (axi_req_t),
      .axi_rsp_t  (axi_rsp_t)
  ) i_axi_shim (
      .clk_i      (clk_i),
      .rst_ni     (rst_ni),
      .rd_req_i   (axi_rd_req),
      .rd_gnt_o   (axi_rd_gnt),
      .rd_addr_i  (axi_rd_addr),
      .rd_blen_i  (axi_rd_blen),
      .rd_size_i  (axi_rd_size),
      .rd_id_i    (axi_rd_id_in),
      .rd_rdy_i   (axi_rd_rdy),
      .rd_lock_i  (axi_rd_lock),
      .rd_last_o  (axi_rd_last),
      .rd_valid_o (axi_rd_valid),
      .rd_data_o  (axi_rd_data),
      .rd_user_o  (axi_rd_user),
      .rd_id_o    (axi_rd_id_out),
      .rd_exokay_o(axi_rd_exokay),
      .wr_req_i   (axi_wr_req),
      .wr_gnt_o   (axi_wr_gnt),
      .wr_addr_i  (axi_wr_addr),
      .wr_data_i  (axi_wr_data),
      .wr_user_i  (axi_wr_user),
      .wr_be_i    (axi_wr_be),
      .wr_blen_i  (axi_wr_blen),
      .wr_size_i  (axi_wr_size),
      .wr_id_i    (axi_wr_id_in),
      .wr_lock_i  (axi_wr_lock),
      .wr_atop_i  (axi_wr_atop),
      .wr_rdy_i   (axi_wr_rdy),
      .wr_valid_o (axi_wr_valid),
      .wr_id_o    (axi_wr_id_out),
      .wr_exokay_o(axi_wr_exokay),
      .axi_req_o  (axi_req_o),
      .axi_resp_i (axi_resp_i)
  );

  ///////////////////////////////////////////////////////
  // assertions
  ///////////////////////////////////////////////////////

  //pragma translate_off
`ifndef VERILATOR

`endif
  //pragma translate_on

endmodule  // wt_l15_adapter
