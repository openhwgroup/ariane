// Copyright 2021 Thales DIS design services SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Jean-Roch COULON - Thales


package cva6_config_pkg;

  localparam CVA6ConfigXlen = 64;

  localparam CVA6ConfigRVF = 1;
  localparam CVA6ConfigF16En = 0;
  localparam CVA6ConfigF16AltEn = 0;
  localparam CVA6ConfigF8En = 0;
  localparam CVA6ConfigFVecEn = 0;

  localparam CVA6ConfigCvxifEn = 1;
  localparam CVA6ConfigCExtEn = 1;
  localparam CVA6ConfigZcbExtEn = 1;
  localparam CVA6ConfigZcmpExtEn = 0;
  localparam CVA6ConfigAExtEn = 1;
  localparam CVA6ConfigHExtEn = 1;
  localparam CVA6ConfigBExtEn = 1;
  localparam CVA6ConfigVExtEn = 0;
  localparam CVA6ConfigRVZiCond = 1;

  localparam CVA6ConfigAxiIdWidth = 4;
  localparam CVA6ConfigAxiAddrWidth = 64;
  localparam CVA6ConfigAxiDataWidth = 64;
  localparam CVA6ConfigFetchUserEn = 0;
  localparam CVA6ConfigFetchUserWidth = CVA6ConfigXlen;
  localparam CVA6ConfigDataUserEn = 0;
  localparam CVA6ConfigDataUserWidth = CVA6ConfigXlen;

  localparam CVA6ConfigIcacheByteSize = 16384;
  localparam CVA6ConfigIcacheSetAssoc = 4;
  localparam CVA6ConfigIcacheLineWidth = 128;
  localparam CVA6ConfigDcacheByteSize = 32768;
  localparam CVA6ConfigDcacheSetAssoc = 8;
  localparam CVA6ConfigDcacheLineWidth = 128;

  localparam CVA6ConfigDcacheFlushOnFence = 1'b0;
  localparam CVA6ConfigDcacheInvalidateOnFlush = 1'b0;

  localparam CVA6ConfigDcacheIdWidth = 1;
  localparam CVA6ConfigMemTidWidth = 2;

  localparam CVA6ConfigWtDcacheWbufDepth = 8;

  localparam CVA6ConfigNrScoreboardEntries = 8;

  localparam CVA6ConfigNrLoadPipeRegs = 1;
  localparam CVA6ConfigNrStorePipeRegs = 0;
  localparam CVA6ConfigNrLoadBufEntries = 2;

  localparam CVA6ConfigRASDepth = 2;
  localparam CVA6ConfigBTBEntries = 32;
  localparam CVA6ConfigBHTEntries = 128;

  localparam CVA6ConfigTvalEn = 1;

  localparam CVA6ConfigNrPMPEntries = 8;

  localparam CVA6ConfigPerfCounterEn = 1;

  localparam config_pkg::cache_type_t CVA6ConfigDcacheType = config_pkg::WT;

  localparam CVA6ConfigMmuPresent = 1;

  localparam CVA6ConfigRvfiTrace = 1;

  localparam config_pkg::cva6_user_cfg_t cva6_cfg = '{
      XLEN: unsigned'(CVA6ConfigXlen),
      VLEN: unsigned'(64),
      FpgaEn: bit'(0),  // for Xilinx and Altera
      FpgaAlteraEn: bit'(0),  // for Altera (only)
      TechnoCut: bit'(0),
      SuperscalarEn: bit'(0),
      NrCommitPorts: unsigned'(2),
      AxiAddrWidth: unsigned'(CVA6ConfigAxiAddrWidth),
      AxiDataWidth: unsigned'(CVA6ConfigAxiDataWidth),
      AxiIdWidth: unsigned'(CVA6ConfigAxiIdWidth),
      AxiUserWidth: unsigned'(CVA6ConfigDataUserWidth),
      MemTidWidth: unsigned'(CVA6ConfigMemTidWidth),
      NrLoadBufEntries: unsigned'(CVA6ConfigNrLoadBufEntries),
      RVF: bit'(CVA6ConfigRVF),
      RVD: bit'(CVA6ConfigRVF),
      XF16: bit'(CVA6ConfigF16En),
      XF16ALT: bit'(CVA6ConfigF16AltEn),
      XF8: bit'(CVA6ConfigF8En),
      RVA: bit'(CVA6ConfigAExtEn),
      RVB: bit'(CVA6ConfigBExtEn),
      ZKN: bit'(0),
      RVV: bit'(CVA6ConfigVExtEn),
      RVC: bit'(CVA6ConfigCExtEn),
      RVH: bit'(CVA6ConfigHExtEn),
      RVZCB: bit'(CVA6ConfigZcbExtEn),
      RVZCMP: bit'(CVA6ConfigZcmpExtEn),
      XFVec: bit'(CVA6ConfigFVecEn),
      CvxifEn: bit'(CVA6ConfigCvxifEn),
      RVZiCond: bit'(CVA6ConfigRVZiCond),
      RVZicntr: bit'(1),
      RVZihpm: bit'(1),
      NrScoreboardEntries: unsigned'(CVA6ConfigNrScoreboardEntries),
      PerfCounterEn: bit'(CVA6ConfigPerfCounterEn),
      MmuPresent: bit'(CVA6ConfigMmuPresent),
      RVS: bit'(1),
      RVU: bit'(1),
      SoftwareInterruptEn: bit'(1),
      HaltAddress: 64'h800,
      ExceptionAddress: 64'h808,
      RASDepth: unsigned'(CVA6ConfigRASDepth),
      BTBEntries: unsigned'(CVA6ConfigBTBEntries),
      BHTEntries: unsigned'(CVA6ConfigBHTEntries),
      DmBaseAddress: 64'h0,
      TvalEn: bit'(CVA6ConfigTvalEn),
      DirectVecOnly: bit'(0),
      NrPMPEntries: unsigned'(CVA6ConfigNrPMPEntries),
      PMPCfgRstVal: {64{64'h0}},
      PMPAddrRstVal: {64{64'h0}},
      PMPEntryReadOnly: 64'd0,
      PMPNapotEn: bit'(1),
      NOCType: config_pkg::NOC_TYPE_AXI4_ATOP,
      NrNonIdempotentRules: unsigned'(2),
      NonIdempotentAddrBase: 1024'({64'b0, 64'b0}),
      NonIdempotentLength: 1024'({64'b0, 64'b0}),
      NrExecuteRegionRules: unsigned'(3),
      ExecuteRegionAddrBase: 1024'({64'h8000_0000, 64'h1_0000, 64'h0}),
      ExecuteRegionLength: 1024'({64'h40000000, 64'h10000, 64'h1000}),
      NrCachedRegionRules: unsigned'(1),
      CachedRegionAddrBase: 1024'({64'h8000_0000}),
      CachedRegionLength: 1024'({64'h40000000}),
      MaxOutstandingStores: unsigned'(7),
      DebugEn: bit'(1),
      AxiBurstWriteEn: bit'(0),
      IcacheByteSize: unsigned'(CVA6ConfigIcacheByteSize),
      IcacheSetAssoc: unsigned'(CVA6ConfigIcacheSetAssoc),
      IcacheLineWidth: unsigned'(CVA6ConfigIcacheLineWidth),
      DCacheType: CVA6ConfigDcacheType,
      DcacheByteSize: unsigned'(CVA6ConfigDcacheByteSize),
      DcacheSetAssoc: unsigned'(CVA6ConfigDcacheSetAssoc),
      DcacheLineWidth: unsigned'(CVA6ConfigDcacheLineWidth),
      DcacheFlushOnFence: unsigned'(CVA6ConfigDcacheFlushOnFence),
      DcacheInvalidateOnFlush: unsigned'(CVA6ConfigDcacheInvalidateOnFlush),
      DataUserEn: unsigned'(CVA6ConfigDataUserEn),
      WtDcacheWbufDepth: int'(CVA6ConfigWtDcacheWbufDepth),
      FetchUserWidth: unsigned'(CVA6ConfigFetchUserWidth),
      FetchUserEn: unsigned'(CVA6ConfigFetchUserEn),
      InstrTlbEntries: int'(16),
      DataTlbEntries: int'(16),
      UseSharedTlb: bit'(0),
      SharedTlbDepth: int'(64),
      NrLoadPipeRegs: int'(CVA6ConfigNrLoadPipeRegs),
      NrStorePipeRegs: int'(CVA6ConfigNrStorePipeRegs),
      DcacheIdWidth: int'(CVA6ConfigDcacheIdWidth)
  };

endpackage
