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
 * File:   ariane_pkg.svh
 * Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
 * Date:   8.4.2017
 *
 * Description: Contains all the necessary defines for Ariane
 *              in one package.
 */


package ariane_pkg;
    timeunit      1ns;
    timeprecision 1ps;

    // ---------------
    // Global Config
    // ---------------
    localparam NR_SB_ENTRIES = 8; // number of scoreboard entries
    localparam TRANS_ID_BITS = $clog2(NR_SB_ENTRIES); // depending on the number of scoreboard entries we need that many bits
                                                      // to uniquely identify the entry in the scoreboard
    localparam NR_WB_PORTS   = 5;
    localparam ASID_WIDTH    = 1;
    localparam BTB_ENTRIES   = 8;
    localparam BITS_SATURATION_COUNTER = 2;

    localparam logic [63:0] ISA_CODE = (1 <<  2)  // C - Compressed extension
                                     | (1 <<  8)  // I - RV32I/64I/128I base ISA
                                     | (1 << 12)  // M - Integer Multiply/Divide extension
                                     | (0 << 13)  // N - User level interrupts supported
                                     | (1 << 18)  // S - Supervisor mode implemented
                                     | (1 << 20)  // U - User mode implemented
                                     | (0 << 23)  // X - Non-standard extensions present
                                     | (1 << 63); // RV64

    // ---------------
    // Fetch Stage
    // ---------------
    // Only use struct when signals have same direction
    // exception
    typedef struct packed {
         logic [63:0] cause; // cause of exception
         logic [63:0] tval;  // additional information of causing exception (e.g.: instruction causing it),
                             // address of LD/ST fault
         logic        valid;
    } exception_t;

    // branch-predict
    // this is the struct we get back from ex stage and we will use it to update
    // all the necessary data structures
    typedef struct packed {
        logic [63:0] pc;              // pc of predict or mis-predict
        logic [63:0] target_address;  // target address at which to jump, or not
        logic        is_mispredict;   // set if this was a mis-predict
        logic        is_taken;        // branch is taken
        logic        is_lower_16;     // branch instruction is compressed and resides
                                      // in the lower 16 bit of the word
        logic        valid;           // prediction with all its values is valid
        logic        clear;           // invalidate this entry
    } branchpredict_t;

    // branchpredict scoreboard entry
    // this is the struct which we will inject into the pipeline to guide the various
    // units towards the correct branch decision and resolve
    typedef struct packed {
        logic [63:0] predict_address; // target address at which to jump, or not
        logic        predict_taken;   // branch is taken
        logic        is_lower_16;     // branch instruction is compressed and resides
                                      // in the lower 16 bit of the word
        logic        valid;           // this is a valid hint
    } branchpredict_sbe_t;

    typedef enum logic[3:0] {
        NONE, LOAD, STORE, ALU, CTRL_FLOW, MULT, CSR
    } fu_t;

    localparam EXC_OFF_RST      = 8'h80;

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
                               MRET, SRET, ECALL, WFI, FENCE, FENCE_I, SFENCE_VMA, CSR_WRITE, CSR_READ, CSR_SET, CSR_CLEAR,
                               // LSU functions
                               LD, SD, LW, LWU, SW, LH, LHU, SH, LB, SB, LBU,
                               // Atomic Memory Operations
                               AMO_LRW, AMO_LRD, AMO_SCW, AMO_SCD,
                               AMO_SWAPW, AMO_ADDW, AMO_ANDW, AMO_ORW, AMO_XORW, AMO_MAXW, AMO_MAXWU, AMO_MINW, AMO_MINWU,
                               AMO_SWAPD, AMO_ADDD, AMO_ANDD, AMO_ORD, AMO_XORD, AMO_MAXD, AMO_MAXDU, AMO_MIND, AMO_MINDU,
                               // Multiplications
                               MUL, MULH, MULHU, MULHSU, MULW,
                               // Divisions
                               DIV, DIVU, DIVW, DIVUW, REM, REMU, REMW, REMUW
                             } fu_op;

    // ----------------------
    // Extract Bytes from Op
    // ----------------------
    // TODO: Add atomics
    function automatic logic [1:0] extract_transfer_size (fu_op op);
        case (op)
            LD, SD:      return 2'b11;
            LW, LWU, SW: return 2'b10;
            LH, LHU, SH: return 2'b01;
            LB, SB, LBU: return 2'b00;
            default:     return 2'b11;
        endcase
    endfunction

    typedef struct packed {
        logic                     valid;
        logic [63:0]              vaddr;
        logic [63:0]              data;
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
        logic [63:0]        address;              // the address of the instructions from below
        logic [31:0]        instruction;          // instruction word
        branchpredict_sbe_t branch_predict;       // this field contains branch prediction information regarding the forward branch path
        exception_t         ex;                   // this field contains exceptions which might have happened earlier, e.g.: fetch exceptions
    } fetch_entry_t;

    // ---------------
    // ID/EX/WB Stage
    // ---------------
    typedef struct packed {
        logic [63:0]              pc;            // PC of instruction
        logic [TRANS_ID_BITS-1:0] trans_id;      // this can potentially be simplified, we could index the scoreboard entry
                                                 // with the transaction id in any case make the width more generic
        fu_t                      fu;            // functional unit to use
        fu_op                     op;            // operation to perform in each functional unit
        logic [4:0]               rs1;           // register source address 1
        logic [4:0]               rs2;           // register source address 2
        logic [4:0]               rd;            // register destination address
        logic [63:0]              result;        // for unfinished instructions this field also holds the immediate
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
    // Instruction Types
    // --------------------
    typedef struct packed {
        logic [31:25] funct7;
        logic [24:20] rs2;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:7]  rd;
        logic [6:0]   opcode;
    } rtype_t;

    typedef struct packed {
        logic [31:20] imm;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:7]  rd;
        logic [6:0]   opcode;
    } itype_t;

    typedef struct packed {
        logic [31:25] imm;
        logic [24:20] rs2;
        logic [19:15] rs1;
        logic [14:12] funct3;
        logic [11:7]  imm0;
        logic [6:0]   opcode;
    } stype_t;

    typedef struct packed {
        logic [31:12] funct3;
        logic [11:7]  rd;
        logic [6:0]   opcode;
    } utype_t;

    typedef union packed {
        logic [31:0]   instr;
        rtype_t        rtype;
        itype_t        itype;
        stype_t        stype;
        utype_t        utype;
    } instruction_t;

    // --------------------
    // Opcodes
    // --------------------
    localparam OPCODE_SYSTEM    = 7'h73;
    localparam OPCODE_FENCE     = 7'h0f;
    localparam OPCODE_OP        = 7'h33;
    localparam OPCODE_OP32      = 7'h3B;
    localparam OPCODE_OPIMM     = 7'h13;
    localparam OPCODE_OPIMM32   = 7'h1B;
    localparam OPCODE_STORE     = 7'h23;
    localparam OPCODE_LOAD      = 7'h03;
    localparam OPCODE_BRANCH    = 7'h63;
    localparam OPCODE_JALR      = 7'h67;
    localparam OPCODE_JAL       = 7'h6f;
    localparam OPCODE_AUIPC     = 7'h17;
    localparam OPCODE_LUI       = 7'h37;
    localparam OPCODE_AMO       = 7'h2F;
    // --------------------
    // Atomics
    // --------------------

    typedef enum logic [3:0] {
        AMO_NONE, AMO_LR, AMO_SC, AMO_SWAP, AMO_ADD, AMO_AND, AMO_OR, AMO_XOR, AMO_MAX, AMO_MAXU, AMO_MIN, AMO_MINU
    } amo_t;

    // --------------------
    // Privilege Spec
    // --------------------
    typedef enum logic[1:0] {
      PRIV_LVL_M = 2'b11,
      PRIV_LVL_S = 2'b01,
      PRIV_LVL_U = 2'b00
    } priv_lvl_t;

    // memory management, pte
    typedef struct packed {
        logic [9:0]  reserved;
        logic [43:0] ppn;
        logic [1:0]  rsw;
        logic d;
        logic a;
        logic g;
        logic u;
        logic x;
        logic w;
        logic r;
        logic v;
    } pte_t;

    // Bits required for representation of physical address space as 4K pages
    // (e.g. 27*4K == 39bit address space).
    localparam PPN4K_WIDTH = 38;

    // ----------------------
    // Exception Cause Codes
    // ----------------------
    localparam logic [63:0] INSTR_ADDR_MISALIGNED = 0;
    localparam logic [63:0] INSTR_ACCESS_FAULT    = 1;
    localparam logic [63:0] ILLEGAL_INSTR         = 2;
    localparam logic [63:0] BREAKPOINT            = 3;
    localparam logic [63:0] LD_ADDR_MISALIGNED    = 4;
    localparam logic [63:0] LD_ACCESS_FAULT       = 5;
    localparam logic [63:0] ST_ADDR_MISALIGNED    = 6;
    localparam logic [63:0] ST_ACCESS_FAULT       = 7;
    localparam logic [63:0] ENV_CALL_UMODE        = 8;  // environment call from user mode
    localparam logic [63:0] ENV_CALL_SMODE        = 9;  // environment call from supervisor mode
    localparam logic [63:0] ENV_CALL_MMODE        = 11; // environment call from machine mode
    localparam logic [63:0] INSTR_PAGE_FAULT      = 12; // Instruction page fault
    localparam logic [63:0] LOAD_PAGE_FAULT       = 13; // Load page fault
    localparam logic [63:0] STORE_PAGE_FAULT      = 15; // Store page fault

    localparam logic [63:0] S_SW_INTERRUPT        = (1 << 63) | 1;
    localparam logic [63:0] M_SW_INTERRUPT        = (1 << 63) | 3;
    localparam logic [63:0] S_TIMER_INTERRUPT     = (1 << 63) | 5;
    localparam logic [63:0] M_TIMER_INTERRUPT     = (1 << 63) | 7;
    localparam logic [63:0] S_EXT_INTERRUPT       = (1 << 63) | 9;
    localparam logic [63:0] M_EXT_INTERRUPT       = (1 << 63) | 11;

    // ----------------------
    // Performance Counters
    // ----------------------
    localparam logic [11:0] PERF_L1_ICACHE_MISS = 12'h0;     // L1 Instr Cache Miss
    localparam logic [11:0] PERF_L1_DCACHE_MISS = 12'h1;     // L1 Data Cache Miss
    localparam logic [11:0] PERF_ITLB_MISS      = 12'h2;     // ITLB Miss
    localparam logic [11:0] PERF_DTLB_MISS      = 12'h3;     // DTLB Miss
    localparam logic [11:0] PERF_LOAD           = 12'h4;     // Loads
    localparam logic [11:0] PERF_STORE          = 12'h5;     // Stores
    localparam logic [11:0] PERF_EXCEPTION      = 12'h6;     // Taken exceptions
    localparam logic [11:0] PERF_EXCEPTION_RET  = 12'h7;     // Exception return
    localparam logic [11:0] PERF_BRANCH_JUMP    = 12'h8;     // Software change of PC
    localparam logic [11:0] PERF_CALL           = 12'h9;     // Procedure call
    localparam logic [11:0] PERF_RET            = 12'hA;     // Procedure Return
    localparam logic [11:0] PERF_MIS_PREDICT    = 12'hB;     // Branch mis-predicted

    // -----
    // CSRs
    // -----
    typedef enum logic [11:0] {
        // Supervisor Mode CSRs
        CSR_SSTATUS        = 12'h100,
        CSR_SIE            = 12'h104,
        CSR_STVEC          = 12'h105,
        CSR_SCOUNTEREN     = 12'h106,
        CSR_SSCRATCH       = 12'h140,
        CSR_SEPC           = 12'h141,
        CSR_SCAUSE         = 12'h142,
        CSR_STVAL          = 12'h143,
        CSR_SIP            = 12'h144,
        CSR_SATP           = 12'h180,
        // Machine Mode CSRs
        CSR_MSTATUS        = 12'h300,
        CSR_MISA           = 12'h301,
        CSR_MEDELEG        = 12'h302,
        CSR_MIDELEG        = 12'h303,
        CSR_MIE            = 12'h304,
        CSR_MTVEC          = 12'h305,
        CSR_MCOUNTEREN     = 12'h306,
        CSR_MSCRATCH       = 12'h340,
        CSR_MEPC           = 12'h341,
        CSR_MCAUSE         = 12'h342,
        CSR_MTVAL          = 12'h343,
        CSR_MIP            = 12'h344,
        CSR_PMPCFG0        = 12'h3A0,
        CSR_PMPADDR0       = 12'h3B0,
        CSR_MVENDORID      = 12'hF11,
        CSR_MARCHID        = 12'hF12,
        CSR_MIMPID         = 12'hF13,
        CSR_MHARTID        = 12'hF14,
        CSR_MCYCLE         = 12'hB00,
        CSR_MINSTRET       = 12'hB02,
        CSR_DCACHE         = 12'h701,
        CSR_ICACHE         = 12'h700,
        // Counters and Timers
        CSR_CYCLE          = 12'hC00,
        CSR_TIME           = 12'hC01,
        CSR_INSTRET        = 12'hC02,
        // Performance counters
        CSR_L1_ICACHE_MISS = PERF_L1_ICACHE_MISS + 12'hC03,
        CSR_L1_DCACHE_MISS = PERF_L1_DCACHE_MISS + 12'hC03,
        CSR_ITLB_MISS      = PERF_ITLB_MISS      + 12'hC03,
        CSR_DTLB_MISS      = PERF_DTLB_MISS      + 12'hC03,
        CSR_LOAD           = PERF_LOAD           + 12'hC03,
        CSR_STORE          = PERF_STORE          + 12'hC03,
        CSR_EXCEPTION      = PERF_EXCEPTION      + 12'hC03,
        CSR_EXCEPTION_RET  = PERF_EXCEPTION_RET  + 12'hC03,
        CSR_BRANCH_JUMP    = PERF_BRANCH_JUMP    + 12'hC03,
        CSR_CALL           = PERF_CALL           + 12'hC03,
        CSR_RET            = PERF_RET            + 12'hC03,
        CSR_MIS_PREDICT    = PERF_MIS_PREDICT    + 12'hC03
    } csr_reg_t;

    // decoded CSR address
    typedef struct packed {
        logic [1:0]  rw;
        priv_lvl_t   priv_lvl;
        logic  [7:0] address;
    } csr_addr_t;

    typedef union packed {
        csr_reg_t   address;
        csr_addr_t  csr_decode;
    } csr_t;

    // ----------------------
    // Debug Unit
    // ----------------------
    typedef enum logic [15:0] {
        DBG_CTRL     = 16'h0,
        DBG_HIT      = 16'h8,
        DBG_IE       = 16'h10,
        DBG_CAUSE    = 16'h18,

        BP_CTRL0     = 16'h80,
        BP_DATA0     = 16'h88,
        BP_CTRL1     = 16'h90,
        BP_DATA1     = 16'h98,
        BP_CTRL2     = 16'hA0,
        BP_DATA2     = 16'hA8,
        BP_CTRL3     = 16'hB0,
        BP_DATA3     = 16'hB8,
        BP_CTRL4     = 16'hC0,
        BP_DATA4     = 16'hC8,
        BP_CTRL5     = 16'hD0,
        BP_DATA5     = 16'hD8,
        BP_CTRL6     = 16'hE0,
        BP_DATA6     = 16'hE8,
        BP_CTRL7     = 16'hF0,
        BP_DATA7     = 16'hF8,

        DBG_NPC      = 16'h2000,
        DBG_PPC      = 16'h2008,
        DBG_GPR      = 16'h4??,

        // CSRs 0x4000-0xBFFF
        DBG_CSR_U0   = 16'h8???,
        DBG_CSR_U1   = 16'h9???,
        DBG_CSR_S0   = 16'hA???,
        DBG_CSR_S1   = 16'hB???,
        DBG_CSR_H0   = 16'hC???,
        DBG_CSR_H1   = 16'hD???,
        DBG_CSR_M0   = 16'hE???,
        DBG_CSR_M1   = 16'hF???
    } debug_reg_t;

    // ----------------------
    // Arithmetic Functions
    // ----------------------
    function automatic logic [63:0] sext32 (logic [31:0] operand);
        return {{32{operand[31]}}, operand[31:0]};
    endfunction
endpackage
