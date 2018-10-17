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

package ariane_pkg;

    // ---------------
    // Global Config
    // ---------------
    localparam XLEN          = 64;
    localparam NR_SB_ENTRIES = 8; // number of scoreboard entries
    localparam TRANS_ID_BITS = $clog2(NR_SB_ENTRIES); // depending on the number of scoreboard entries we need that many bits
                                                      // to uniquely identify the entry in the scoreboard
    localparam NR_WB_PORTS   = 4;
    localparam ASID_WIDTH    = 1;
    localparam BTB_ENTRIES   = 8;
    localparam BHT_ENTRIES   = 32;
    localparam RAS_DEPTH     = 2;
    localparam BITS_SATURATION_COUNTER = 2;
    localparam NR_COMMIT_PORTS = 2;

    localparam ENABLE_RENAME = 1'b1;

    // Floating-point extensions configuration
    localparam bit RVF = 1'b0; // Is F extension enabled
    localparam bit RVD = 1'b0; // Is D extension enabled
    localparam bit RVA = 1'b1; // Is A extension enabled

    // Transprecision floating-point extensions configuration
    localparam bit XF16    = 1'b0; // Is half-precision float extension (Xf16) enabled
    localparam bit XF16ALT = 1'b0; // Is alternative half-precision float extension (Xf16alt) enabled
    localparam bit XF8     = 1'b0; // Is quarter-precision float extension (Xf8) enabled
    localparam bit XFVEC   = 1'b0; // Is vectorial float extension (Xfvec) enabled

    // Transprecision float unit
    localparam logic [30:0] LAT_COMP_FP32    = 'd3;
    localparam logic [30:0] LAT_COMP_FP64    = 'd4;
    localparam logic [30:0] LAT_COMP_FP16    = 'd3;
    localparam logic [30:0] LAT_COMP_FP16ALT = 'd3;
    localparam logic [30:0] LAT_COMP_FP8     = 'd2;
    localparam logic [30:0] LAT_DIVSQRT      = 'd2;
    localparam logic [30:0] LAT_NONCOMP      = 'd1;
    localparam logic [30:0] LAT_CONV         = 'd2;

    // --------------------------------------
    // vvvv Don't change these by hand! vvvv
    localparam bit FP_PRESENT = RVF | RVD | XF16 | XF16ALT | XF8;

    // Length of widest floating-point format
    localparam FLEN    = RVD     ? 64 : // D ext.
                         RVF     ? 32 : // F ext.
                         XF16    ? 16 : // Xf16 ext.
                         XF16ALT ? 16 : // Xf16alt ext.
                         XF8     ? 8 :  // Xf8 ext.
                         0;             // Unused in case of no FP

    localparam bit NSX = XF16 | XF16ALT | XF8 | XFVEC; // Are non-standard extensions present?

    localparam bit RVFVEC     = RVF     & XFVEC & FLEN>32; // FP32 vectors available if vectors and larger fmt enabled
    localparam bit XF16VEC    = XF16    & XFVEC & FLEN>16; // FP16 vectors available if vectors and larger fmt enabled
    localparam bit XF16ALTVEC = XF16ALT & XFVEC & FLEN>16; // FP16ALT vectors available if vectors and larger fmt enabled
    localparam bit XF8VEC     = XF8     & XFVEC & FLEN>8;  // FP8 vectors available if vectors and larger fmt enabled
    // ^^^^ until here ^^^^
    // ---------------------

    localparam logic [XLEN-1:0] ARIANE_MARCHID = 64'd3;

    localparam logic [XLEN-1:0] ISA_CODE = (RVA <<  0)  // A - Atomic Instructions extension
                                         | (1   <<  2)  // C - Compressed extension
                                         | (RVD <<  3)  // D - Double precsision floating-point extension
                                         | (RVF <<  5)  // F - Single precsision floating-point extension
                                         | (1   <<  8)  // I - RV32I/64I/128I base ISA
                                         | (1   << 12)  // M - Integer Multiply/Divide extension
                                         | (0   << 13)  // N - User level interrupts supported
                                         | (1   << 18)  // S - Supervisor mode implemented
                                         | (1   << 20)  // U - User mode implemented
                                         | (NSX << 23)  // X - Non-standard extensions present
                                         | ((XLEN == 32) << 31)  // RV32
                                         | ((XLEN == 64) << 63); // RV64

    // 32 registers + 1 bit for re-naming = 6
    localparam REG_ADDR_SIZE = 6;

    // static debug hartinfo
    localparam dm::hartinfo_t DebugHartInfo = '{
                                                zero1:        '0,
                                                nscratch:      1, // DTM currently needs at least one scratch register
                                                zero0:        '0,
                                                dataaccess: 1'b1, // data registers are memory mapped in the debugger
                                                datasize: dm::DataCount,
                                                dataaddr: dm::DataAddr
                                              };

    // enables a commit log which matches spikes commit log format for easier trace comparison
    localparam bit ENABLE_SPIKE_COMMIT_LOG = 1'b1;

    // ------------- Dangerouse -------------
    // if set to zero a flush will not invalidate the cache-lines, in a single core environment
    // where coherence is not necessary this can improve performance. This needs to be switched on
    // when more than one core is in a system
    localparam logic INVALIDATE_ON_FLUSH = 1'b1;

    // ---------------
    // Fetch Stage
    // ---------------

    // leave as is (fails with >8 entries and wider fetch width)
    localparam int unsigned FETCH_FIFO_DEPTH  = 8;
    localparam int unsigned FETCH_WIDTH       = 32;

    // Only use struct when signals have same direction
    // exception
    typedef struct packed {
         logic [XLEN-1:0] cause; // cause of exception
         logic [XLEN-1:0] tval;  // additional information of causing exception (e.g.: instruction causing it),
                             // address of LD/ST fault
         logic            valid;
    } exception_t;

    typedef enum logic [1:0] { BHT, BTB, RAS } cf_t;

    // branch-predict
    // this is the struct we get back from ex stage and we will use it to update
    // all the necessary data structures
    typedef struct packed {
        logic [XLEN-1:0] pc;              // pc of predict or mis-predict
        logic [XLEN-1:0] target_address;  // target address at which to jump, or not
        logic            is_mispredict;   // set if this was a mis-predict
        logic            is_taken;        // branch is taken
        logic            is_lower_16;     // branch instruction is compressed and resides
                                      // in the lower 16 bit of the word
        logic            valid;           // prediction with all its values is valid
        logic            clear;           // invalidate this entry
        cf_t             cf_type;         // Type of control flow change
    } branchpredict_t;

    // branchpredict scoreboard entry
    // this is the struct which we will inject into the pipeline to guide the various
    // units towards the correct branch decision and resolve
    typedef struct packed {
        logic            valid;           // this is a valid hint
        logic [XLEN-1:0] predict_address; // target address at which to jump, or not
        logic            predict_taken;   // branch is taken
        logic            is_lower_16;     // branch instruction is compressed and resides
                                      // in the lower 16 bit of the word
        cf_t             cf_type;         // Type of control flow change
    } branchpredict_sbe_t;

    typedef struct packed {
        logic            valid;
        logic [XLEN-1:0] pc;             // update at PC
        logic [XLEN-1:0] target_address;
        logic            is_lower_16;
        logic            clear;
    } btb_update_t;

    typedef struct packed {
        logic            valid;
        logic [XLEN-1:0] target_address;
        logic            is_lower_16;
    } btb_prediction_t;

    typedef struct packed {
        logic            valid;
        logic [XLEN-1:0] ra;
    } ras_t;

    typedef struct packed {
        logic            valid;
        logic [XLEN-1:0] pc;          // update at PC
        logic            mispredict;
        logic            taken;
    } bht_update_t;

    typedef struct packed {
        logic       valid;
        logic       taken;
        logic       strongly_taken;
    } bht_prediction_t;

    typedef enum logic[3:0] {
        NONE,      // 0
        LOAD,      // 1
        STORE,     // 2
        ALU,       // 3
        CTRL_FLOW, // 4
        MULT,      // 5
        CSR,       // 6
        FPU,       // 7
        FPU_VEC    // 8
    } fu_t;

    localparam EXC_OFF_RST      = 8'h80;

    // ---------------
    // Cache config
    // ---------------

    // I$
    localparam int unsigned  ICACHE_INDEX_WIDTH       = 12; // in bit
    localparam int unsigned  ICACHE_TAG_WIDTH         = 44; // in bit
    localparam int unsigned  ICACHE_SET_ASSOC         = 4;
    localparam int unsigned  ICACHE_LINE_WIDTH        = 128; // in bit

    // D$
    localparam int unsigned DCACHE_INDEX_WIDTH       = 12;
    localparam int unsigned DCACHE_TAG_WIDTH         = 44;
    localparam int unsigned DCACHE_LINE_WIDTH        = 128;
    localparam int unsigned DCACHE_SET_ASSOC         = 8;

    // ---------------
    // EX Stage
    // ---------------
    typedef enum logic [6:0] { // basic ALU op
                               ADD, SUB, ADDW, SUBW,
                               // logic operations
                               XORL, ORL, ANDL,
                               // shifts
                               SRA, SRL, SLL, SRLW, SLLW, SRAW,
                               // comparisons
                               LTS, LTU, GES, GEU, EQ, NE,
                               // jumps
                               JALR,
                               // set lower than operations
                               SLTS, SLTU,
                               // CSR functions
                               MRET, SRET, DRET, ECALL, WFI, FENCE, FENCE_I, SFENCE_VMA, CSR_WRITE, CSR_READ, CSR_SET, CSR_CLEAR,
                               // LSU functions
                               LD, SD, LW, LWU, SW, LH, LHU, SH, LB, SB, LBU,
                               // Atomic Memory Operations
                               AMO_LRW, AMO_LRD, AMO_SCW, AMO_SCD,
                               AMO_SWAPW, AMO_ADDW, AMO_ANDW, AMO_ORW, AMO_XORW, AMO_MAXW, AMO_MAXWU, AMO_MINW, AMO_MINWU,
                               AMO_SWAPD, AMO_ADDD, AMO_ANDD, AMO_ORD, AMO_XORD, AMO_MAXD, AMO_MAXDU, AMO_MIND, AMO_MINDU,
                               // Multiplications
                               MUL, MULH, MULHU, MULHSU, MULW,
                               // Divisions
                               DIV, DIVU, DIVW, DIVUW, REM, REMU, REMW, REMUW,
                               // Floating-Point Load and Store Instructions
                               FLD, FLW, FLH, FLB, FSD, FSW, FSH, FSB,
                               // Floating-Point Computational Instructions
                               FADD, FSUB, FMUL, FDIV, FMIN_MAX, FSQRT, FMADD, FMSUB, FNMSUB, FNMADD,
                               // Floating-Point Conversion and Move Instructions
                               FCVT_F2I, FCVT_I2F, FCVT_F2F, FSGNJ, FMV_F2X, FMV_X2F,
                               // Floating-Point Compare Instructions
                               FCMP,
                               // Floating-Point Classify Instruction
                               FCLASS,
                               // Vectorial Floating-Point Instructions that don't directly map onto the scalar ones
                               VFMIN, VFMAX, VFSGNJ, VFSGNJN, VFSGNJX, VFEQ, VFNE, VFLT, VFGE, VFLE, VFGT, VFCPKAB_S, VFCPKCD_S, VFCPKAB_D, VFCPKCD_D
                             } fu_op;

    typedef struct packed {
      fu_op            operator;
      logic [XLEN-1:0] operand_a;
      logic [XLEN-1:0] operand_b;
      logic [XLEN-1:0] imm;
    } fu_data_t;

    // -------------------------------
    // Extract Src/Dst FP Reg from Op
    // -------------------------------
    function automatic logic is_rs1_fpr (input fu_op op);
        if (FP_PRESENT) begin // makes function static for non-fp case
            unique case (op) inside
                [FMUL:FNMADD],                   // Computational Operations (except ADD/SUB)
                FCVT_F2I,                        // Float-Int Casts
                FCVT_F2F,                        // Float-Float Casts
                FSGNJ,                           // Sign Injections
                FMV_F2X,                         // FPR-GPR Moves
                FCMP,                            // Comparisons
                FCLASS,                          // Classifications
                [VFMIN:VFCPKCD_D] : return 1'b1; // Additional Vectorial FP ops
                default           : return 1'b0; // all other ops
            endcase
        end else
            return 1'b0;
    endfunction;

    function automatic logic is_rs2_fpr (input fu_op op);
        if (FP_PRESENT) begin // makes function static for non-fp case
            unique case (op) inside
                [FSD:FSB],                       // FP Stores
                [FADD:FMIN_MAX],                 // Computational Operations (no sqrt)
                [FMADD:FNMADD],                  // Fused Computational Operations
                FCVT_F2F,                        // Vectorial F2F Conversions requrie target
                [FSGNJ:FMV_F2X],                 // Sign Injections and moves mapped to SGNJ
                FCMP,                            // Comparisons
                [VFMIN:VFCPKCD_D] : return 1'b1; // Additional Vectorial FP ops
                default           : return 1'b0; // all other ops
            endcase
        end else
            return 1'b0;
    endfunction;

    // ternary operations encode the rs3 address in the imm field, also add/sub
    function automatic logic is_imm_fpr (input fu_op op);
        if (FP_PRESENT) begin // makes function static for non-fp case
            unique case (op) inside
                [FADD:FSUB],                         // ADD/SUB need inputs as Operand B/C
                [FMADD:FNMADD],                      // Fused Computational Operations
                [VFCPKAB_S:VFCPKCD_D] : return 1'b1; // Vectorial FP cast and pack ops
                default               : return 1'b0; // all other ops
            endcase
        end else
            return 1'b0;
    endfunction;

    function automatic logic is_rd_fpr (input fu_op op);
        if (FP_PRESENT) begin // makes function static for non-fp case
            unique case (op) inside
                [FLD:FLB],                           // FP Loads
                [FADD:FNMADD],                       // Computational Operations
                FCVT_I2F,                            // Int-Float Casts
                FCVT_F2F,                            // Float-Float Casts
                FSGNJ,                               // Sign Injections
                FMV_X2F,                             // GPR-FPR Moves
                [VFMIN:VFSGNJX],                     // Vectorial MIN/MAX and SGNJ
                [VFCPKAB_S:VFCPKCD_D] : return 1'b1; // Vectorial FP cast and pack ops
                default               : return 1'b0; // all other ops
            endcase
        end else
            return 1'b0;
    endfunction;

    function automatic logic is_amo (fu_op op);
        case (op) inside
            [AMO_LRW:AMO_MINDU]: begin
                return 1'b1;
            end
            default: return 1'b0;
        endcase
    endfunction

    typedef struct packed {
        logic                     valid;
        logic [XLEN-1:0]          vaddr;
        logic [XLEN-1:0]          data;
        logic [7:0]               be;
        fu_t                      fu;
        fu_op                     operator;
        logic [TRANS_ID_BITS-1:0] trans_id;
    } lsu_ctrl_t;

    // ---------------
    // IF/ID Stage
    // ---------------
    // store the decompressed instruction
    typedef struct packed {
        logic [XLEN-1:0]    address;              // the address of the instructions from below
        logic [31:0]        instruction;          // instruction word
        branchpredict_sbe_t branch_predict;       // this field contains branch prediction information regarding the forward branch path
        exception_t         ex;                   // this field contains exceptions which might have happened earlier, e.g.: fetch exceptions
    } fetch_entry_t;

    // ---------------
    // ID/EX/WB Stage
    // ---------------
    typedef struct packed {
        logic [XLEN-1:0]          pc;            // PC of instruction
        logic [TRANS_ID_BITS-1:0] trans_id;      // this can potentially be simplified, we could index the scoreboard entry
                                                 // with the transaction id in any case make the width more generic
        fu_t                      fu;            // functional unit to use
        fu_op                     op;            // operation to perform in each functional unit
        logic [REG_ADDR_SIZE-1:0] rs1;           // register source address 1
        logic [REG_ADDR_SIZE-1:0] rs2;           // register source address 2
        logic [REG_ADDR_SIZE-1:0] rd;            // register destination address
        logic [XLEN-1:0]          result;        // for unfinished instructions this field also holds the immediate,
                                                 // for unfinished floating-point that are partly encoded in rs2, this field also holds rs2
                                                 // for unfinished floating-point fused operations (FMADD, FMSUB, FNMADD, FNMSUB)
                                                 // this field holds the address of the third operand from the floating-point register file
        logic                     valid;         // is the result valid
        logic                     use_imm;       // should we use the immediate as operand b?
        logic                     use_zimm;      // use zimm as operand a
        logic                     use_pc;        // set if we need to use the PC as operand a, PC from exception
        exception_t               ex;            // exception has occurred
        branchpredict_sbe_t       bp;            // branch predict scoreboard data structure
        logic                     is_compressed; // signals a compressed instructions, we need this information at the commit stage if
                                                 // we want jump accordingly e.g.: +4, +2
    } scoreboard_entry_t;

    // --------------------
    // Atomics
    // --------------------
    typedef enum logic [3:0] {
        AMO_NONE, AMO_LR, AMO_SC, AMO_SWAP, AMO_ADD, AMO_AND,
        AMO_OR, AMO_XOR, AMO_MAX, AMO_MAXU, AMO_MIN, AMO_MINU
    } amo_t;

    typedef struct packed {
        logic                  valid;      // valid flag
        logic                  is_2M;      //
        logic                  is_1G;      //
        logic [26:0]           vpn;
        logic [ASID_WIDTH-1:0] asid;
        riscv::pte_t           content;
    } tlb_update_t;

    // Bits required for representation of physical address space as 4K pages
    // (e.g. 27*4K == 39bit address space).
    localparam PPN4K_WIDTH = 38;

    // ----------------------
    // cache request ports
    // ----------------------
    // I$ address translation requests
    typedef struct packed {
        logic                     fetch_valid;     // address translation valid
        logic [XLEN-1:0]          fetch_paddr;     // physical address in
        exception_t               fetch_exception; // exception occurred during fetch
    } icache_areq_i_t;

    typedef struct packed {
        logic                     fetch_req;       // address translation request
        logic [XLEN-1:0]          fetch_vaddr;     // virtual address out
    } icache_areq_o_t;

    // I$ data requests
    typedef struct packed {
        logic                     req;                    // we request a new word
        logic                     kill_s1;                // kill the current request
        logic                     kill_s2;                // kill the last request
        logic [XLEN-1:0]          vaddr;                  // 1st cycle: 12 bit index is taken for lookup
    } icache_dreq_i_t;

    typedef struct packed {
        logic                     ready;                  // icache is ready
        logic                     valid;                  // signals a valid read
        logic [FETCH_WIDTH-1:0]   data;                   // 2+ cycle out: tag
        logic [XLEN-1:0]          vaddr;                  // virtual address out
        exception_t               ex;                     // we've encountered an exception
    } icache_dreq_o_t;

    // AMO request going to cache. this request is unconditionally valid as soon
    // as request goes high.
    // Furthermore, those signals are kept stable until the response indicates
    // completion by asserting ack.
    typedef struct packed {
        logic        req;       // this request is valid
        amo_t        amo_op;    // atomic memory operation to perform
        logic [1:0]  size;      // 2'b10 --> word operation, 2'b11 --> double word operation
        logic [XLEN-1:0] operand_a; // address
        logic [XLEN-1:0] operand_b; // data as layuoted in the register
    } amo_req_t;

    // AMO response coming from cache.
    typedef struct packed {
        logic            ack;    // response is valid
        logic [XLEN-1:0] result; // sign-extended, result
    } amo_resp_t;

    // D$ data requests
    typedef struct packed {
        logic [DCACHE_INDEX_WIDTH-1:0] address_index;
        logic [DCACHE_TAG_WIDTH-1:0]   address_tag;
        logic [XLEN-1:0]               data_wdata;
        logic                          data_req;
        logic                          data_we;
        logic [7:0]                    data_be;
        logic [1:0]                    data_size;
        logic                          kill_req;
        logic                          tag_valid;
    } dcache_req_i_t;

    typedef struct packed {
        logic            data_gnt;
        logic            data_rvalid;
        logic [XLEN-1:0] data_rdata;
    } dcache_req_o_t;

    // ----------------------
    // Arithmetic Functions
    // ----------------------
    function automatic logic [63:0] sext32 (logic [31:0] operand);
        return {{32{operand[31]}}, operand[31:0]};
    endfunction

    // ----------------------
    // Immediate functions
    // ----------------------
    function automatic logic [XLEN-1:0] uj_imm (logic [31:0] instruction_i);
        return { {{XLEN-20}{instruction_i[31]}}, instruction_i[19:12], instruction_i[20], instruction_i[30:21], 1'b0 };
    endfunction

    function automatic logic [XLEN-1:0] i_imm (logic [31:0] instruction_i);
        return { {{XLEN-12}{instruction_i[31]}}, instruction_i[31:20] };
    endfunction

    function automatic logic [XLEN-1:0] sb_imm (logic [31:0] instruction_i);
        return { {{XLEN-13}{instruction_i[31]}}, instruction_i[31], instruction_i[7], instruction_i[30:25], instruction_i[11:8], 1'b0 };
    endfunction

    // ----------------------
    // LSU Functions
    // ----------------------
    // align data to address e.g.: shift data to be naturally 64
    function automatic logic [XLEN-1:0] data_align (logic [2:0] addr, logic [XLEN-1:0] data);

        if (XLEN == 32) case (addr[1:0])
            3'b00: return data;
            3'b01: return {data[23:0], data[31:24]};
            3'b10: return {data[15:0], data[31:16]};
            3'b11: return {data[7:0],  data[31:8]};
        endcase

        if (XLEN == 64) case (addr)
            3'b000: return data;
            3'b001: return {data[55:0], data[63:56]};
            3'b010: return {data[47:0], data[63:48]};
            3'b011: return {data[39:0], data[63:40]};
            3'b100: return {data[31:0], data[63:32]};
            3'b101: return {data[23:0], data[63:24]};
            3'b110: return {data[15:0], data[63:16]};
            3'b111: return {data[7:0],  data[63:8]};
        endcase
        return data;
    endfunction

    // generate byte enable mask
    function automatic logic [7:0] be_gen(logic [2:0] addr, logic [1:0] size);
        automatic logic [2:0] addr_zeroed;
        if (XLEN == 32) addr_zeroed = 3'b011 & addr;
        if (XLEN == 64) addr_zeroed = addr;

        case (size)
            2'b11: begin
                return 8'b1111_1111;
            end
            2'b10: begin
                case (addr)
                    3'b000: return 8'b0000_1111;
                    3'b001: return 8'b0001_1110;
                    3'b010: return 8'b0011_1100;
                    3'b011: return 8'b0111_1000;
                    3'b100: return 8'b1111_0000;
                endcase
            end
            2'b01: begin
                case (addr)
                    3'b000: return 8'b0000_0011;
                    3'b001: return 8'b0000_0110;
                    3'b010: return 8'b0000_1100;
                    3'b011: return 8'b0001_1000;
                    3'b100: return 8'b0011_0000;
                    3'b101: return 8'b0110_0000;
                    3'b110: return 8'b1100_0000;
                endcase
            end
            2'b00: begin
                case (addr)
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

    // ----------------------
    // Extract Bytes from Op
    // ----------------------
    function automatic logic [1:0] extract_transfer_size(fu_op op);
        case (op)
            LD, SD, FLD, FSD,
            AMO_LRD,   AMO_SCD,
            AMO_SWAPD, AMO_ADDD,
            AMO_ANDD,  AMO_ORD,
            AMO_XORD,  AMO_MAXD,
            AMO_MAXDU, AMO_MIND,
            AMO_MINDU: begin
                return 2'b11;
            end
            LW, LWU, SW, FLW, FSW,
            AMO_LRW,   AMO_SCW,
            AMO_SWAPW, AMO_ADDW,
            AMO_ANDW,  AMO_ORW,
            AMO_XORW,  AMO_MAXW,
            AMO_MAXWU, AMO_MINW,
            AMO_MINWU: begin
                return 2'b10;
            end
            LH, LHU, SH, FLH, FSH: return 2'b01;
            LB, LBU, SB, FLB, FSB: return 2'b00;
            default:     return 2'b11;
        endcase
    endfunction
endpackage
