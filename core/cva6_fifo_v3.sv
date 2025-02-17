// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright 2024 - PlanV Technologies for additionnal contribution.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Additional contributions by:
//                 Angela Gonzalez - PlanV Technologies

module cva6_fifo_v3 #(
    parameter bit FALL_THROUGH = 1'b0,  // fifo is in fall-through mode
    parameter bit FPGA_ALTERA = 1'b0,  // FPGA Altera optimizations enabled
    parameter int unsigned DATA_WIDTH = 32,  // default data width if the fifo is of type logic
    parameter int unsigned DEPTH = 8,  // depth can be arbitrary from 0 to 2**32
    parameter type dtype = logic [DATA_WIDTH-1:0],
    parameter bit FPGA_EN = 1'b0,
    // DO NOT OVERWRITE THIS PARAMETER
    parameter int unsigned ADDR_DEPTH = (DEPTH > 1) ? $clog2(DEPTH) : 1
) (
    input  logic                  clk_i,       // Clock
    input  logic                  rst_ni,      // Asynchronous reset active low
    input  logic                  flush_i,     // flush the queue
    input  logic                  testmode_i,  // test_mode to bypass clock gating
    // status flags
    output logic                  full_o,      // queue is full
    output logic                  empty_o,     // queue is empty
    output logic [ADDR_DEPTH-1:0] usage_o,     // fill pointer
    // as long as the queue is not full we can push new data
    input  dtype                  data_i,      // data to push into the queue
    input  logic                  push_i,      // data is valid and can be pushed to the queue
    // as long as the queue is not empty we can pop new elements
    output dtype                  data_o,      // output data
    input  logic                  pop_i        // pop head from queue
);
  // local parameter
  // FIFO depth - handle the case of pass-through, synthesizer will do constant propagation
  localparam int unsigned FifoDepth = (DEPTH > 0) ? DEPTH : 1;
  // clock gating control
  logic gate_clock;
  // pointer to the read and write section of the queue
  logic [ADDR_DEPTH - 1:0] read_pointer_n, read_pointer_q, write_pointer_n, write_pointer_q;
  // keep a counter to keep track of the current queue status
  // this integer will be truncated by the synthesis tool
  logic [ADDR_DEPTH:0] status_cnt_n, status_cnt_q;
  // actual memory
  dtype [FifoDepth - 1:0] mem_n, mem_q;
  dtype data_ft_n, data_ft_q;
  logic first_word_n, first_word_q;

  // fifo ram signals for fpga target
  logic fifo_ram_we;
  logic [ADDR_DEPTH-1:0] fifo_ram_read_address;
  logic [ADDR_DEPTH-1:0] fifo_ram_write_address;
  logic [$bits(dtype)-1:0] fifo_ram_wdata;
  logic [$bits(dtype)-1:0] fifo_ram_rdata;

  assign usage_o = status_cnt_q[ADDR_DEPTH-1:0];

  if (DEPTH == 0) begin : gen_pass_through
    assign empty_o = ~push_i;
    assign full_o  = ~pop_i;
  end else begin : gen_fifo
    assign full_o  = (status_cnt_q == FifoDepth[ADDR_DEPTH:0]);
    assign empty_o = (status_cnt_q == 0) & ~(FALL_THROUGH & push_i);
  end
  // status flags

  // read and write queue logic
  always_comb begin : read_write_comb
    // default assignment
    read_pointer_n  = read_pointer_q;
    write_pointer_n = write_pointer_q;
    status_cnt_n    = status_cnt_q;
    if (FPGA_EN && FPGA_ALTERA) data_ft_n = data_ft_q;
    if (FPGA_EN && FPGA_ALTERA) first_word_n = first_word_q;
    if (FPGA_EN) begin
      fifo_ram_we            = '0;
      fifo_ram_write_address = '0;
      fifo_ram_wdata         = '0;
      if (DEPTH == 0) begin
        data_o = data_i;
      end else begin
        if (FPGA_ALTERA) data_o = first_word_q ? data_ft_q : fifo_ram_rdata;
        else data_o = fifo_ram_rdata;
      end
    end else begin
      data_o     = (DEPTH == 0) ? data_i : mem_q[read_pointer_q];
      mem_n      = mem_q;
      gate_clock = 1'b1;
    end

    // push a new element to the queue
    if (push_i && ~full_o) begin
      if (FPGA_EN) begin
        fifo_ram_we = 1'b1;
        fifo_ram_write_address = write_pointer_q;
        fifo_ram_wdata = data_i;
        if (FPGA_ALTERA) first_word_n = first_word_q && pop_i;
      end else begin
        // push the data onto the queue
        mem_n[write_pointer_q] = data_i;
        // un-gate the clock, we want to write something
        gate_clock = 1'b0;
      end

      // increment the write counter
      if (write_pointer_q == FifoDepth[ADDR_DEPTH-1:0] - 1) write_pointer_n = '0;
      else write_pointer_n = write_pointer_q + 1;
      // increment the overall counter
      status_cnt_n = status_cnt_q + 1;
    end

    if (pop_i && ~empty_o) begin
      data_ft_n = data_i;
      if (FPGA_EN && FPGA_ALTERA) first_word_n = first_word_q && push_i;
      // read from the queue is a default assignment
      // but increment the read pointer...
      if (read_pointer_n == FifoDepth[ADDR_DEPTH-1:0] - 1) read_pointer_n = '0;
      else read_pointer_n = read_pointer_q + 1;
      // ... and decrement the overall count
      status_cnt_n = status_cnt_q - 1;
    end

    // keep the count pointer stable if we push and pop at the same time
    if (push_i && pop_i && ~full_o && ~empty_o) status_cnt_n = status_cnt_q;

    // FIFO is in pass through mode -> do not change the pointers
    if ((FALL_THROUGH || (FPGA_EN && FPGA_ALTERA)) && (status_cnt_q == 0) && push_i) begin
      if (FALL_THROUGH) data_o = data_i;
      if (FPGA_EN && FPGA_ALTERA) begin
        data_ft_n = data_i;
        first_word_n = '1;
      end
      if (pop_i) begin
        first_word_n = '0;
        status_cnt_n = status_cnt_q;
        read_pointer_n = read_pointer_q;
        write_pointer_n = write_pointer_q;
      end
    end

    if (FPGA_EN) fifo_ram_read_address = (FPGA_ALTERA == 1) ? read_pointer_n : read_pointer_q;
    else fifo_ram_read_address = '0;

  end

  // sequential process
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      read_pointer_q  <= '0;
      write_pointer_q <= '0;
      status_cnt_q    <= '0;
      if (FPGA_ALTERA) first_word_q <= '0;
      if (FPGA_ALTERA) data_ft_q <= '0;
    end else begin
      if (flush_i) begin
        read_pointer_q  <= '0;
        write_pointer_q <= '0;
        status_cnt_q    <= '0;
        if (FPGA_ALTERA) first_word_q <= '0;
        if (FPGA_ALTERA) data_ft_q <= '0;
      end else begin
        read_pointer_q  <= read_pointer_n;
        write_pointer_q <= write_pointer_n;
        status_cnt_q    <= status_cnt_n;
        if (FPGA_ALTERA) data_ft_q <= data_ft_n;
        if (FPGA_ALTERA) first_word_q <= first_word_n;
      end
    end
  end

  if (FPGA_EN) begin : gen_fpga_queue
    if (FPGA_ALTERA) begin
      SyncDpRam_ind_r_w #(
          .ADDR_WIDTH(ADDR_DEPTH),
          .DATA_DEPTH(DEPTH),
          .DATA_WIDTH($bits(dtype))
      ) fifo_ram (
          .Clk_CI   (clk_i),
          .WrEn_SI  (fifo_ram_we),
          .RdAddr_DI(fifo_ram_read_address),
          .WrAddr_DI(fifo_ram_write_address),
          .WrData_DI(fifo_ram_wdata),
          .RdData_DO(fifo_ram_rdata)
      );
    end else begin
      AsyncDpRam #(
          .ADDR_WIDTH(ADDR_DEPTH),
          .DATA_DEPTH(DEPTH),
          .DATA_WIDTH($bits(dtype))
      ) fifo_ram (
          .Clk_CI   (clk_i),
          .WrEn_SI  (fifo_ram_we),
          .RdAddr_DI(fifo_ram_read_address),
          .WrAddr_DI(fifo_ram_write_address),
          .WrData_DI(fifo_ram_wdata),
          .RdData_DO(fifo_ram_rdata)
      );
    end
  end else begin : gen_asic_queue
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if (~rst_ni) begin
        mem_q <= '0;
      end else if (!gate_clock) begin
        mem_q <= mem_n;
      end
    end
  end

  // pragma translate_off
  initial begin
    assert (DEPTH > 0)
    else $error("DEPTH must be greater than 0.");
  end

  full_write :
  assert property (@(posedge clk_i) disable iff (~rst_ni) (full_o |-> ~push_i))
  else $fatal(1, "Trying to push new data although the FIFO is full.");

  empty_read :
  assert property (@(posedge clk_i) disable iff (~rst_ni) (empty_o |-> ~pop_i))
  else $fatal(1, "Trying to pop data although the FIFO is empty.");
  // pragma translate_on

endmodule  // fifo_v3
