// Licensed under the Solderpad Hardware License v 2.1 (the “License”); you may not use this file 
// except in compliance with the License, or, at your option, the Apache License version 2.0. You 
// may obtain a copy of the License at

// https://solderpad.org/licenses/SHL-2.1/

// Unless required by applicable law or agreed to in writing, any work distributed under the 
// License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
// either express or implied. See the License for the specific language governing permissions and 
// limitations under the License.

// Author:  Umberto Laghi
// Contact: umberto.laghi@studio.unibo.it
// Github:  @ubolakes

/* ITYPE DETECTOR */
/*
it produces the type of the instruction
*/

module itype_detector (
    input logic                valid_i,
    input logic                exception_i,
    input logic                interrupt_i,
    input connector_pkg::fu_op op_i,
    input logic                branch_taken_i,

    output logic [connector_pkg::ITYPE_LEN-1:0] itype_o
);

  // internal signals
  logic exception;
  logic interrupt;
  logic eret;
  logic nontaken_branch;
  logic taken_branch;
  logic updiscon;

  // assignments
  assign exception = exception_i;
  assign interrupt = interrupt_i;  // no need to have an inst committed
  assign eret = ( op_i == connector_pkg::MRET || 
                    op_i == connector_pkg::SRET ||
                    op_i == connector_pkg::DRET );
  assign nontaken_branch = (  op_i == connector_pkg::EQ ||
                                op_i == connector_pkg::NE ||
                                op_i == connector_pkg::LTS ||
                                op_i == connector_pkg::GES ||
                                op_i == connector_pkg::LTU ||
                                op_i == connector_pkg::GEU) && 
                                ~branch_taken_i;
  assign taken_branch = ( op_i == connector_pkg::EQ ||
                            op_i == connector_pkg::NE ||
                            op_i == connector_pkg::LTS ||
                            op_i == connector_pkg::GES ||
                            op_i == connector_pkg::LTU ||
                            op_i == connector_pkg::GEU) &&
                            branch_taken_i;
  assign updiscon = op_i == connector_pkg::JALR;

  // assigning the itype
  always_comb begin
    // initialization
    itype_o = '0;

    if (exception) begin  // exception
      itype_o = 1;
    end else if (interrupt) begin  // interrupt
      itype_o = 2;
    end else if (eret && valid_i) begin  // exception or interrupt return
      itype_o = 3;
    end else if (nontaken_branch && valid_i) begin  // nontaken branch
      itype_o = 4;
    end else if (taken_branch && valid_i) begin  // taken branch
      itype_o = 5;
    end else if (connector_pkg::ITYPE_LEN == 3 && updiscon && valid_i) begin // uninferable discontinuity
      itype_o = 6;
    end
  end

endmodule
