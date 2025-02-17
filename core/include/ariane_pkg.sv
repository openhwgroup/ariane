/* Copyright 2018 ETH Zurich and University of Bologna.
 * Copyright and related rights are licensed under the Solderpad Hardware
 * License, Version 0.51 (the “License”); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
 * or agreed to in writing, software, hardware and materials distributed under
 * this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 * File:   ariane_pkg.sv
 * Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
 * Date:   8.4.2017
 *
 * Description: Contains all the necessary defines for Ariane
 *              in one package.
 */

// this is needed to propagate the
// configuration in case Ariane is
// instantiated in OpenPiton
`ifdef PITON_ARIANE
`include "l15.tmp.h"
`endif

/// This package contains `functions` and global defines for CVA6.
/// *Note*: There are some parameters here as well which will eventually be
/// moved out to favour a fully parameterizable core.
package ariane_pkg;

  // TODO: Slowly move those parameters to the new system.
  localparam BITS_SATURATION_COUNTER = 2;

  // depth of store-buffers, this needs to be a power of two
  localparam logic [2:0] DEPTH_SPEC = 'd4;

  // if CVA6Cfg.DCacheType = cva6_config_pkg::WT
  // we can use a small commit queue since we have a write buffer in the dcache
  // we could in principle do without the commit queue in this case, but the timing degrades if we do that due
  // to longer paths into the commit stage
  // if CVA6Cfg.DCacheType = cva6_config_pkg::WB
  // allocate more space for the commit buffer to be on the save side, this needs to be a power of two
  localparam logic [2:0] DEPTH_COMMIT = 'd4;

  // Transprecision float unit
  localparam int unsigned LAT_COMP_FP32 = 'd2;
  localparam int unsigned LAT_COMP_FP64 = 'd3;
  localparam int unsigned LAT_COMP_FP16 = 'd1;
  localparam int unsigned LAT_COMP_FP16ALT = 'd1;
  localparam int unsigned LAT_COMP_FP8 = 'd1;
  localparam int unsigned LAT_DIVSQRT = 'd2;
  localparam int unsigned LAT_NONCOMP = 'd1;
  localparam int unsigned LAT_CONV = 'd2;

  localparam logic [31:0] OPENHWGROUP_MVENDORID = 32'h0602;
  localparam logic [31:0] ARIANE_MARCHID = 32'd3;

  // 32 registers
  localparam REG_ADDR_SIZE = 5;

  // Read ports for general purpose register files
  localparam NR_RGPR_PORTS = 2;

  // static debug hartinfo
  // debug causes
  localparam logic [2:0] CauseBreakpoint = 3'h1;
  localparam logic [2:0] CauseTrigger = 3'h2;
  localparam logic [2:0] CauseRequest = 3'h3;
  localparam logic [2:0] CauseSingleStep = 3'h4;
  // amount of data count registers implemented
  localparam logic [3:0] DataCount = 4'h2;

  // address where data0-15 is shadowed or if shadowed in a CSR
  // address of the first CSR used for shadowing the data
  localparam logic [11:0] DataAddr = 12'h380;  // we are aligned with Rocket here
  typedef struct packed {
    logic [31:24] zero1;
    logic [23:20] nscratch;
    logic [19:17] zero0;
    logic         dataaccess;
    logic [15:12] datasize;
    logic [11:0]  dataaddr;
  } hartinfo_t;

  localparam hartinfo_t DebugHartInfo = '{
      zero1: '0,
      nscratch: 2,  // Debug module needs at least two scratch regs
      zero0: '0,
      dataaccess: 1'b1,  // data registers are memory mapped in the debugger
      datasize: DataCount,
      dataaddr: DataAddr
  };

  // enables a commit log which matches spikes commit log format for easier trace comparison
  localparam bit ENABLE_SPIKE_COMMIT_LOG = 1'b1;

  // ------------- Dangerous -------------
  // if set to zero a flush will not invalidate the cache-lines, in a single core environment
  // where coherence is not necessary this can improve performance. This needs to be switched on
  // when more than one core is in a system
  localparam logic INVALIDATE_ON_FLUSH = 1'b1;

`ifdef SPIKE_TANDEM
  // Spike still places 0 in TVAL for ENV_CALL_* exceptions.
  // This may eventually go away when Spike starts to handle TVAL for *all* exceptions.
  localparam bit ZERO_TVAL = 1'b1;
`else
  localparam bit ZERO_TVAL = 1'b0;
`endif

  // read mask for SSTATUS over MMSTATUS
  function automatic logic [63:0] smode_status_read_mask(config_pkg::cva6_cfg_t Cfg);
    return riscv::SSTATUS_UIE
    | riscv::SSTATUS_SIE
    | riscv::SSTATUS_SPIE
    | riscv::SSTATUS_SPP
    | riscv::SSTATUS_FS
    | riscv::SSTATUS_XS
    | riscv::SSTATUS_SUM
    | riscv::SSTATUS_MXR
    | riscv::SSTATUS_UPIE
    | riscv::SSTATUS_SPIE
    | riscv::SSTATUS_UXL
    | riscv::sstatus_sd(Cfg.IS_XLEN64);
  endfunction

  localparam logic [63:0] SMODE_STATUS_WRITE_MASK = riscv::SSTATUS_SIE
                                                    | riscv::SSTATUS_SPIE
                                                    | riscv::SSTATUS_SPP
                                                    | riscv::SSTATUS_FS
                                                    | riscv::SSTATUS_SUM
                                                    | riscv::SSTATUS_MXR;

  localparam logic [63:0] HSTATUS_WRITE_MASK      = riscv::HSTATUS_VSBE
                                                    | riscv::HSTATUS_GVA
                                                    | riscv::HSTATUS_SPV
                                                    | riscv::HSTATUS_SPVP
                                                    | riscv::HSTATUS_HU
                                                    | riscv::HSTATUS_VTVM
                                                    | riscv::HSTATUS_VTW
                                                    | riscv::HSTATUS_VTSR;

  // hypervisor delegable interrupts
  function automatic logic [31:0] hs_deleg_interrupts(config_pkg::cva6_cfg_t Cfg);
    return riscv::MIP_VSSIP | riscv::MIP_VSTIP | riscv::MIP_VSEIP;
  endfunction

  // virtual supervisor delegable interrupts
  function automatic logic [31:0] vs_deleg_interrupts(config_pkg::cva6_cfg_t Cfg);
    return riscv::MIP_VSSIP | riscv::MIP_VSTIP | riscv::MIP_VSEIP;
  endfunction

  // ---------------
  // AXI
  // ---------------

  typedef enum logic {
    SINGLE_REQ,
    CACHE_LINE_REQ
  } ad_req_t;

  // ---------------
  // Fetch Stage
  // ---------------

  // leave as is (fails with >8 entries and wider fetch width)
  localparam int unsigned FETCH_FIFO_DEPTH = 4;
  localparam int unsigned FETCH_ADDR_FIFO_DEPTH = 2;

  typedef enum logic [2:0] {
    NoCF,    // No control flow prediction
    Branch,  // Branch
    Jump,    // Jump to address from immediate
    JumpR,   // Jump to address from registers
    Return   // Return Address Prediction
  } cf_t;

  typedef struct packed {
    logic valid;
    logic taken;
  } bht_prediction_t;

  typedef struct packed {
    logic       valid;
    logic [1:0] saturation_counter;
  } bht_t;

  typedef enum logic [3:0] {
    NONE,       // 0
    LOAD,       // 1
    STORE,      // 2
    ALU,        // 3
    CTRL_FLOW,  // 4
    MULT,       // 5
    CSR,        // 6
    FPU,        // 7
    FPU_VEC,    // 8
    CVXIF,      // 9
    ACCEL       // 10
  } fu_t;

  // Index of writeback ports
  localparam FLU_WB = 0;
  localparam STORE_WB = 1;
  localparam LOAD_WB = 2;
  localparam FPU_WB = 3;
  localparam ACC_WB = 4;
  localparam X_WB = 4;

  localparam EXC_OFF_RST = 8'h80;

  localparam SupervisorIrq = 1;
  localparam MachineIrq = 0;

  // ---------------
  // Cache config
  // ---------------

  // for usage in OpenPiton we have to propagate the openpiton L15 configuration from l15.h
`ifdef PITON_ARIANE

`ifndef CONFIG_L1I_CACHELINE_WIDTH
  `define CONFIG_L1I_CACHELINE_WIDTH 128
`endif

`ifndef CONFIG_L1I_ASSOCIATIVITY
  `define CONFIG_L1I_ASSOCIATIVITY 4
`endif

`ifndef CONFIG_L1I_SIZE
  `define CONFIG_L1I_SIZE 16*1024
`endif

`ifndef CONFIG_L1D_CACHELINE_WIDTH
  `define CONFIG_L1D_CACHELINE_WIDTH 128
`endif

`ifndef CONFIG_L1D_ASSOCIATIVITY
  `define CONFIG_L1D_ASSOCIATIVITY 8
`endif

`ifndef CONFIG_L1D_SIZE
  `define CONFIG_L1D_SIZE 32*1024
`endif

`ifndef L15_THREADID_WIDTH
  `define L15_THREADID_WIDTH 3
`endif

  // I$
  localparam int unsigned ICACHE_LINE_WIDTH = `CONFIG_L1I_CACHELINE_WIDTH;
  localparam int unsigned ICACHE_SET_ASSOC = `CONFIG_L1I_ASSOCIATIVITY;
  localparam int unsigned ICACHE_INDEX_WIDTH = $clog2(`CONFIG_L1I_SIZE / ICACHE_SET_ASSOC);
  localparam int unsigned ICACHE_TAG_WIDTH = riscv::PLEN - ICACHE_INDEX_WIDTH;
  localparam int unsigned ICACHE_USER_LINE_WIDTH = (AXI_USER_WIDTH == 1) ? 4 : 128;  // in bit
  // D$
  localparam int unsigned DCACHE_LINE_WIDTH = `CONFIG_L1D_CACHELINE_WIDTH;
  localparam int unsigned DCACHE_SET_ASSOC = `CONFIG_L1D_ASSOCIATIVITY;
  localparam int unsigned DCACHE_INDEX_WIDTH = $clog2(`CONFIG_L1D_SIZE / DCACHE_SET_ASSOC);
  localparam int unsigned DCACHE_TAG_WIDTH = riscv::PLEN - DCACHE_INDEX_WIDTH;
  localparam int unsigned DCACHE_USER_LINE_WIDTH = (AXI_USER_WIDTH == 1) ? 4 : 128;  // in bit
  localparam int unsigned DCACHE_USER_WIDTH = cva6_config_pkg::CVA6ConfigDataUserWidth;

  localparam int unsigned MEM_TID_WIDTH = `L15_THREADID_WIDTH;
`endif

  // ---------------
  // EX Stage
  // ---------------

  typedef enum logic [7:0] {  // basic ALU op
    ADD,
    SUB,
    ADDW,
    SUBW,
    // logic operations
    XORL,
    ORL,
    ANDL,
    // shifts
    SRA,
    SRL,
    SLL,
    SRLW,
    SLLW,
    SRAW,
    // comparisons
    LTS,
    LTU,
    GES,
    GEU,
    EQ,
    NE,
    // jumps
    JALR,
    BRANCH,
    // set lower than operations
    SLTS,
    SLTU,
    // CSR functions
    MRET,
    SRET,
    DRET,
    ECALL,
    WFI,
    FENCE,
    FENCE_I,
    SFENCE_VMA,
    HFENCE_VVMA,
    HFENCE_GVMA,
    CSR_WRITE,
    CSR_READ,
    CSR_SET,
    CSR_CLEAR,
    // LSU functions
    LD,
    SD,
    LW,
    LWU,
    SW,
    LH,
    LHU,
    SH,
    LB,
    SB,
    LBU,
    // Hypervisor Virtual-Machine Load and Store Instructions
    HLV_B,
    HLV_BU,
    HLV_H,
    HLV_HU,
    HLVX_HU,
    HLV_W,
    HLVX_WU,
    HSV_B,
    HSV_H,
    HSV_W,
    HLV_WU,
    HLV_D,
    HSV_D,
    // Atomic Memory Operations
    AMO_LRW,
    AMO_LRD,
    AMO_SCW,
    AMO_SCD,
    AMO_SWAPW,
    AMO_ADDW,
    AMO_ANDW,
    AMO_ORW,
    AMO_XORW,
    AMO_MAXW,
    AMO_MAXWU,
    AMO_MINW,
    AMO_MINWU,
    AMO_SWAPD,
    AMO_ADDD,
    AMO_ANDD,
    AMO_ORD,
    AMO_XORD,
    AMO_MAXD,
    AMO_MAXDU,
    AMO_MIND,
    AMO_MINDU,
    // Multiplications
    MUL,
    MULH,
    MULHU,
    MULHSU,
    MULW,
    // Divisions
    DIV,
    DIVU,
    DIVW,
    DIVUW,
    REM,
    REMU,
    REMW,
    REMUW,
    // Floating-Point Load and Store Instructions
    FLD,
    FLW,
    FLH,
    FLB,
    FSD,
    FSW,
    FSH,
    FSB,
    // Floating-Point Computational Instructions
    FADD,
    FSUB,
    FMUL,
    FDIV,
    FMIN_MAX,
    FSQRT,
    FMADD,
    FMSUB,
    FNMSUB,
    FNMADD,
    // Floating-Point Conversion and Move Instructions
    FCVT_F2I,
    FCVT_I2F,
    FCVT_F2F,
    FSGNJ,
    FMV_F2X,
    FMV_X2F,
    // Floating-Point Compare Instructions
    FCMP,
    // Floating-Point Classify Instruction
    FCLASS,
    // Vectorial Floating-Point Instructions that don't directly map onto the scalar ones
    VFMIN,
    VFMAX,
    VFSGNJ,
    VFSGNJN,
    VFSGNJX,
    VFEQ,
    VFNE,
    VFLT,
    VFGE,
    VFLE,
    VFGT,
    VFCPKAB_S,
    VFCPKCD_S,
    VFCPKAB_D,
    VFCPKCD_D,
    // Offload Instructions to be directed into cv_x_if
    OFFLOAD,
    // Or-Combine and REV8
    ORCB,
    REV8,
    // Bitwise Rotation
    ROL,
    ROLW,
    ROR,
    RORI,
    RORIW,
    RORW,
    // Sign and Zero Extend
    SEXTB,
    SEXTH,
    ZEXTH,
    // Count population
    CPOP,
    CPOPW,
    // Count Leading/Training Zeros
    CLZ,
    CLZW,
    CTZ,
    CTZW,
    // Carry less multiplication Op's
    CLMUL,
    CLMULH,
    CLMULR,
    // Single bit instructions Op's
    BCLR,
    BCLRI,
    BEXT,
    BEXTI,
    BINV,
    BINVI,
    BSET,
    BSETI,
    // Integer minimum/maximum
    MAX,
    MAXU,
    MIN,
    MINU,
    // Shift with Add Unsigned Word and Unsigned Word Op's (Bitmanip)
    SH1ADDUW,
    SH2ADDUW,
    SH3ADDUW,
    ADDUW,
    SLLIUW,
    // Shift with Add (Bitmanip)
    SH1ADD,
    SH2ADD,
    SH3ADD,
    // Bitmanip Logical with negate op (Bitmanip)
    ANDN,
    ORN,
    XNOR,
    // Accelerator operations
    ACCEL_OP,
    ACCEL_OP_FS1,
    ACCEL_OP_FD,
    ACCEL_OP_LOAD,
    ACCEL_OP_STORE,
    // Zicond instruction
    CZERO_EQZ,
    CZERO_NEZ,
    // Pack instructions
    PACK,
    PACK_H,
    PACK_W,
    // Brev8 instruction
    BREV8,
    // Zip instructions
    UNZIP,
    ZIP
  } fu_op;

  function automatic logic op_is_branch(input fu_op op);
    unique case (op) inside
      EQ, NE, LTS, GES, LTU, GEU: return 1'b1;
      default:                    return 1'b0;  // all other ops
    endcase
  endfunction

  // -------------------------------
  // Extract Src/Dst FP Reg from Op
  // -------------------------------
  // function used in instr_trace svh
  // is_rs1_fpr function is kept to allow cva6 compilation with instr_trace feature
  function automatic logic is_rs1_fpr(input fu_op op);
    unique case (op) inside
      [FMUL : FNMADD],  // Computational Operations (except ADD/SUB)
      FCVT_F2I,  // Float-Int Casts
      FCVT_F2F,  // Float-Float Casts
      FSGNJ,  // Sign Injections
      FMV_F2X,  // FPR-GPR Moves
      FCMP,  // Comparisons
      FCLASS,  // Classifications
      [VFMIN : VFCPKCD_D],  // Additional Vectorial FP ops
      ACCEL_OP_FS1:
      return 1'b1;  // Accelerator instructions
      default: return 1'b0;  // all other ops
    endcase
  endfunction

  // function used in instr_trace svh
  // is_rs2_fpr function is kept to allow cva6 compilation with instr_trace feature
  function automatic logic is_rs2_fpr(input fu_op op);
    unique case (op) inside
      [FSD : FSB],  // FP Stores
      [FADD : FMIN_MAX],  // Computational Operations (no sqrt)
      [FMADD : FNMADD],  // Fused Computational Operations
      FCVT_F2F,  // Vectorial F2F Conversions requrie target
      [FSGNJ : FMV_F2X],  // Sign Injections and moves mapped to SGNJ
      FCMP,  // Comparisons
      [VFMIN : VFCPKCD_D]:
      return 1'b1;  // Additional Vectorial FP ops
      default: return 1'b0;  // all other ops
    endcase
  endfunction

  // function used in instr_trace svh
  // is_imm_fpr function is kept to allow cva6 compilation with instr_trace feature
  // ternary operations encode the rs3 address in the imm field, also add/sub
  function automatic logic is_imm_fpr(input fu_op op);
    unique case (op) inside
      [FADD : FSUB],  // ADD/SUB need inputs as Operand B/C
      [FMADD : FNMADD],  // Fused Computational Operations
      [VFCPKAB_S : VFCPKCD_D]:
      return 1'b1;  // Vectorial FP cast and pack ops
      default: return 1'b0;  // all other ops
    endcase
  endfunction

  // function used in instr_trace svh
  // is_rd_fpr function is kept to allow cva6 compilation with instr_trace feature
  function automatic logic is_rd_fpr(input fu_op op);
    unique case (op) inside
      [FLD : FLB],  // FP Loads
      [FADD : FNMADD],  // Computational Operations
      FCVT_I2F,  // Int-Float Casts
      FCVT_F2F,  // Float-Float Casts
      FSGNJ,  // Sign Injections
      FMV_X2F,  // GPR-FPR Moves
      [VFMIN : VFSGNJX],  // Vectorial MIN/MAX and SGNJ
      [VFCPKAB_S : VFCPKCD_D],  // Vectorial FP cast and pack ops
      ACCEL_OP_FD:
      return 1'b1;  // Accelerator instructions
      default: return 1'b0;  // all other ops
    endcase
  endfunction

  function automatic logic is_amo(fu_op op);
    case (op) inside
      [AMO_LRW : AMO_MINDU]: begin
        return 1'b1;
      end
      default: return 1'b0;
    endcase
  endfunction

  // -------------------
  // Performance counter
  // -------------------
  localparam int unsigned MHPMCounterNum = 6;

  // --------------------
  // Atomics
  // --------------------
  typedef enum logic [3:0] {
    AMO_NONE = 4'b0000,
    AMO_LR   = 4'b0001,
    AMO_SC   = 4'b0010,
    AMO_SWAP = 4'b0011,
    AMO_ADD  = 4'b0100,
    AMO_AND  = 4'b0101,
    AMO_OR   = 4'b0110,
    AMO_XOR  = 4'b0111,
    AMO_MAX  = 4'b1000,
    AMO_MAXU = 4'b1001,
    AMO_MIN  = 4'b1010,
    AMO_MINU = 4'b1011,
    AMO_CAS1 = 4'b1100,  // unused, not part of riscv spec, but provided in OpenPiton
    AMO_CAS2 = 4'b1101   // unused, not part of riscv spec, but provided in OpenPiton
  } amo_t;

  // Bits required for representation of physical address space as 4K pages
  // (e.g. 27*4K == 39bit address space).
  localparam PPN4K_WIDTH = 38;

  typedef struct packed {
    logic             valid;    // valid flag
    logic             is_4M;    //
    logic [20-1:0]    vpn;      //VPN (32bits) = 20bits + 12bits offset
    logic [9-1:0]     asid;     //ASID length = 9 for Sv32 mmu
    riscv::pte_sv32_t content;
  } tlb_update_sv32_t;

  typedef enum logic [1:0] {
    FE_NONE,
    FE_INSTR_ACCESS_FAULT,
    FE_INSTR_PAGE_FAULT,
    FE_INSTR_GUEST_PAGE_FAULT
  } frontend_exception_t;

  // AMO request going to cache. this request is unconditionally valid as soon
  // as request goes high.
  // Furthermore, those signals are kept stable until the response indicates
  // completion by asserting ack.
  typedef struct packed {
    logic        req;        // this request is valid
    amo_t        amo_op;     // atomic memory operation to perform
    logic [1:0]  size;       // 2'b10 --> word operation, 2'b11 --> double word operation
    logic [63:0] operand_a;  // address
    logic [63:0] operand_b;  // data as layouted in the register
  } amo_req_t;

  // AMO response coming from cache.
  typedef struct packed {
    logic        ack;     // response is valid
    logic [63:0] result;  // sign-extended, result
  } amo_resp_t;

  localparam RVFI = cva6_config_pkg::CVA6ConfigRvfiTrace;

  // ----------------------
  // Arithmetic Functions
  // ----------------------
  function automatic logic [63:0] sext32to64(logic [31:0] operand);
    return {{32{operand[31]}}, operand[31:0]};
  endfunction

  // ----------------------
  // LSU Functions
  // ----------------------
  // generate byte enable mask
  function automatic logic [7:0] be_gen(logic [2:0] addr, logic [1:0] size);
    case (size)
      2'b11: begin
        return 8'b1111_1111;
      end
      2'b10: begin
        case (addr[2:0])
          3'b000:  return 8'b0000_1111;
          3'b001:  return 8'b0001_1110;
          3'b010:  return 8'b0011_1100;
          3'b011:  return 8'b0111_1000;
          3'b100:  return 8'b1111_0000;
          default: ;  // Do nothing
        endcase
      end
      2'b01: begin
        case (addr[2:0])
          3'b000:  return 8'b0000_0011;
          3'b001:  return 8'b0000_0110;
          3'b010:  return 8'b0000_1100;
          3'b011:  return 8'b0001_1000;
          3'b100:  return 8'b0011_0000;
          3'b101:  return 8'b0110_0000;
          3'b110:  return 8'b1100_0000;
          default: ;  // Do nothing
        endcase
      end
      2'b00: begin
        case (addr[2:0])
          3'b000: return 8'b0000_0001;
          3'b001: return 8'b0000_0010;
          3'b010: return 8'b0000_0100;
          3'b011: return 8'b0000_1000;
          3'b100: return 8'b0001_0000;
          3'b101: return 8'b0010_0000;
          3'b110: return 8'b0100_0000;
          3'b111: return 8'b1000_0000;
        endcase
      end
    endcase
    return 8'b0;
  endfunction

  function automatic logic [3:0] be_gen_32(logic [1:0] addr, logic [1:0] size);
    case (size)
      2'b10: begin
        return 4'b1111;
      end
      2'b01: begin
        case (addr[1:0])
          2'b00:   return 4'b0011;
          2'b01:   return 4'b0110;
          2'b10:   return 4'b1100;
          default: ;  // Do nothing
        endcase
      end
      2'b00: begin
        case (addr[1:0])
          2'b00: return 4'b0001;
          2'b01: return 4'b0010;
          2'b10: return 4'b0100;
          2'b11: return 4'b1000;
        endcase
      end
      default: return 4'b0;
    endcase
    return 4'b0;
  endfunction

  // ----------------------
  // Extract Bytes from Op
  // ----------------------
  function automatic logic [1:0] extract_transfer_size(fu_op op);
    case (op)
      LD, HLV_D, SD, HSV_D, FLD, FSD,
            AMO_LRD,   AMO_SCD,
            AMO_SWAPD, AMO_ADDD,
            AMO_ANDD,  AMO_ORD,
            AMO_XORD,  AMO_MAXD,
            AMO_MAXDU, AMO_MIND,
            AMO_MINDU: begin
        return 2'b11;
      end
      LW, LWU, HLV_W, HLV_WU, HLVX_WU,
            SW, HSV_W, FLW, FSW,
            AMO_LRW,   AMO_SCW,
            AMO_SWAPW, AMO_ADDW,
            AMO_ANDW,  AMO_ORW,
            AMO_XORW,  AMO_MAXW,
            AMO_MAXWU, AMO_MINW,
            AMO_MINWU: begin
        return 2'b10;
      end
      LH, LHU, HLV_H, HLV_HU, HLVX_HU, SH, HSV_H, FLH, FSH: return 2'b01;
      LB, LBU, HLV_B, HLV_BU, SB, HSV_B, FLB, FSB:          return 2'b00;
      default:                                              return 2'b11;
    endcase
  endfunction
  // ----------------------
  // MMU Functions
  // ----------------------

  // checks if final translation page size is 1G when H-extension is enabled
  function automatic logic is_trans_1G(input logic s_st_enbl, input logic g_st_enbl,
                                       input logic is_s_1G, input logic is_g_1G);
    return (((is_s_1G && s_st_enbl) || !s_st_enbl) && ((is_g_1G && g_st_enbl) || !g_st_enbl));
  endfunction : is_trans_1G

  // checks if final translation page size is 2M when H-extension is enabled
  function automatic logic is_trans_2M(input logic s_st_enbl, input logic g_st_enbl,
                                       input logic is_s_1G, input logic is_s_2M,
                                       input logic is_g_1G, input logic is_g_2M);
    return  (s_st_enbl && g_st_enbl) ?
                ((is_s_2M && (is_g_1G || is_g_2M)) || (is_g_2M && (is_s_1G || is_s_2M))) :
                ((is_s_2M && s_st_enbl) || (is_g_2M && g_st_enbl));
  endfunction : is_trans_2M

  // computes the paddr based on the page size, ppn and offset
  function automatic logic [40:0] make_gpaddr(input logic s_st_enbl, input logic is_1G,
                                              input logic is_2M, input logic [63:0] vaddr,
                                              input riscv::pte_t pte);
    logic [40:0] gpaddr;
    if (s_st_enbl) begin
      gpaddr = {pte.ppn[28:0], vaddr[11:0]};
      // Giga page
      if (is_1G) gpaddr[29:12] = vaddr[29:12];
      // Mega page
      if (is_2M) gpaddr[20:12] = vaddr[20:12];
    end else begin
      gpaddr = vaddr[40:0];
    end
    return gpaddr;
  endfunction : make_gpaddr

  // computes the final gppn based on the guest physical address
  function automatic logic [28:0] make_gppn(input logic s_st_enbl, input logic is_1G,
                                            input logic is_2M, input logic [28:0] vpn,
                                            input riscv::pte_t pte);
    logic [28:0] gppn;
    if (s_st_enbl) begin
      gppn = pte.ppn[28:0];
      if (is_2M) gppn[8:0] = vpn[8:0];
      if (is_1G) gppn[17:0] = vpn[17:0];
    end else begin
      gppn = vpn;
    end
    return gppn;
  endfunction : make_gppn

  // ----------------------
  // Helper functions
  // ----------------------
  // Avoid negative array slices when defining parametrized sizes
  function automatic int unsigned avoid_neg(int n);
    return (n < 0) ? 0 : n;
  endfunction : avoid_neg

endpackage
