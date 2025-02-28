# Module: PMP

## Feature: TRISTAN Restrictions

### Sub-feature: 000_general

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  the verif plan is written for 32bits architecture only
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S000_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 001_number of harts

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  there is only 1 hart in cv32a6
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 002_mxlen

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  MXLEN is always 32bits
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 003_xlen

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  XLEN=MXLEN=32, so the PMP address registers are XLEN bits long, so no zero-extension needed
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S003_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 004_granularity

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  PMP granularity is 8 bytes (G=1), but the verif plan is written to take G=0 into account (NA4)
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S004_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 005_number of pmp entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  there are 8 HW implemented PMP entries
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S005_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 006_hardwired regions

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  none of the 8 PMP entries is hardwired privileges
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S006_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 007_virtual memory

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  no virtual memory is implemented  
  as a consequence no page-based virtual memory is implemented
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S007_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 008_physical memory regions

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  the list of all physical memory regions  
   - system memory regions  
   - I-$  
   - D-$  
   - I-scratchpad (preload mode)  
   - I-scratchpad (functional mode)  
   - D-scratchpad  
   - ahb_periph
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S008_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 009_pmp entry disabling

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  we assume an already written PMP entry (i) can be disabled  
    - if L=0, by clearing pmpcfg(i)  
    - if L=1, only by hart reset
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S009_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 010_access-faults (violations)

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  The testbench/testcases architecture ensures that:  
   - any time there is an access-fault type, we check it matches the related access-type  
   - all violations are trapped at the processor  
    
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
  PMP violations are always trapped precisely at the processor
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S010_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 011_testcases modularity

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  The verif plan is written assuming there is a way (like SystemVerilog interaction):  
   - to factorize the testcases in code blocks (in particular configuration code block and access code block)  
   - to randomize the code blocks data and addresses  
   - to randomize the sequence of code blocks
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 012_access types

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  at the time of writing,  
  the verif plan makes no distinction between load and load-reserved instructions. they are gathered in the same access type, subtleties unknown  
  the verif plan makes no distinction between store, store-conditional, and AMO instructions. they are gathered in the same access type, subtleties unknown
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S012_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 013_multiple accesses instructions

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  we assume there is no added value to test multiple accesses instructions
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S013_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 014_misaligned instructions

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
    
  we assume that instructions are mandatorily aligned
* **Verification Goals**
  
  
* **Pass/Fail Criteria:** NDY (Not Defined Yet)
* **Test Type:** NDY (Not Defined Yet)
* **Coverage Method:** NDY (Not Defined Yet)
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F000_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
## Feature: PMP granularity

### Sub-feature: 000_granularity_check

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
     
  Software may determine the PMP granularity by writing zero to pmp0cfg, then writing all ones to pmpaddr0, then reading back pmpaddr0.  
  If G is the index of the least-signicant bit set, the PMP granularity is 2G+2 bytes.
* **Verification Goals**
  
  determine the PMP granularity 2^(G+2) bytes by writing zero to pmp(0)cfg, then writing all ones to pmpaddr(0), then reading back pmpaddr(0). G is the index G of the least-significant bit set
* **Pass/Fail Criteria:** Other
* **Test Type:** Directed Non-SelfChk
* **Coverage Method:** Testcase
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F001_S000_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR07-b  
  Software may determine the PMP granularity by writing zero to pmp0cfg, then writing all ones to pmpaddr0, then reading back pmpaddr0.  
   If G is the index of the least-signicant bit set, the PMP granularity is 2G+2 bytes.  
    
    
  TST01 (HIGH-PRIO) => FTR07-b  
  [determine the PMP granularity 2^(G+2) bytes by writing zero to pmp(0)cfg, then writing all ones to pmpaddr(0), then reading back pmpaddr(0). G is the index G of the least-significant bit set]
## Feature: CSRs M-mode only

### Sub-feature: 000_configure_1_pmp_entry

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Section 3.7.1 Page 57 Volume II: RISC-V Privileged Architectures V20211203}  
    
  PMP CSRs are only accessible to M-mode
* **Verification Goals**
  
  configure 1 PMP entry (i) (the 1st one),  
    - check for each PMP entry (i) reset value (read zero) by reading in M mode  
    - check for each PMP entry (i) that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes  
    - check for each PMP entry (i) that pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for each PMP entry (i) that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F002_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST02(group) => FTR02-d  
    [check that all 8 HW implemented PMP entries are writable/readable in M-mode (L=0)]  
    [check that no HW implemented PMP entry are writable/readable in S or U modes (L=0)]  
      - random values may be used  
      - before any configuration (after hart reset), check all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
    
  TST02-1 (HIGH-PRIO)  
  [configure 1 PMP entry ([FTR02-b1]: maybe mandatorily the first one): with L=0,  
    - if possible, the PMP entry number is a configurable parameter  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes]
### Sub-feature: 001_configure_2_pmp_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Section 3.7.1 Page 57 Volume II: RISC-V Privileged Architectures V20211203}  
    
  PMP CSRs are only accessible to M-mode
* **Verification Goals**
  
  configure 2 PMP entries (the 2 first ones in incrementing order),  
    - reuse of VP_PMP_F002_S001_I000 sequence
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F002_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST02(group) => FTR02-d  
    [check that all 8 HW implemented PMP entries are writable/readable in M-mode (L=0)]  
    [check that no HW implemented PMP entry are writable/readable in S or U modes (L=0)]  
      - random values may be used  
      - before any configuration (after hart reset), check all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
    
  TST02-2 (LOW-PRIO) = 2 times reuse/call of TST02-1  
  [configure 2 PMP entries ([FTR02-b1]: maybe mandatorily the 2 first ones): both with L=0,  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes]
### Sub-feature: 002_configure_N_pmp_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Section 3.7.1 Page 57 Volume II: RISC-V Privileged Architectures V20211203}  
    
  PMP CSRs are only accessible to M-mode
* **Verification Goals**
  
  configure N PMP entries (the N first ones in incrementing order),  
    - reuse of VP_PMP_F002_S001_I000 sequence
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F002_S003_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST02(group) => FTR02-d  
    [check that all 8 HW implemented PMP entries are writable/readable in M-mode (L=0)]  
    [check that no HW implemented PMP entry are writable/readable in S or U modes (L=0)]  
      - random values may be used  
      - before any configuration (after hart reset), check all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
    
  TST02-3 (LOW-PRIO) = N times reuse/call of TST02-1  
  [configure N PMP entries ([FTR02-b1]: maybe mandatorily the N first ones): all with L=0,  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes]
### Sub-feature: 003_configure_8_pmp_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Section 3.7.1 Page 57 Volume II: RISC-V Privileged Architectures V20211203}  
    
  PMP CSRs are only accessible to M-mode
* **Verification Goals**
  
  configure all 8 PMP entries (in incrementing order),  
    - reuse of VP_PMP_F002_S001_I000 sequence
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F002_S004_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST02(group) => FTR02-d  
    [check that all 8 HW implemented PMP entries are writable/readable in M-mode (L=0)]  
    [check that no HW implemented PMP entry are writable/readable in S or U modes (L=0)]  
      - random values may be used  
      - before any configuration (after hart reset), check all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
    
  TST02-4 (HIGH-PRIO) = 8 times reuse/call of TST02-1  
  [configure 8 PMP entries: all with L=0,  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes]
## Feature: CSRs locked access

### Sub-feature: 000_configure_1_pmp_entry

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
    
  The L bit indicates that the PMP entry is locked, i.e., writes to the configuration register and associated address registers are ignored  
  If PMP entry (i) is locked, writes to pmp(i)cfg and pmpaddr(i) are ignored  
  Locked PMP entries remain locked until the hart is reset  
    
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Setting the L bit locks the PMP entry even when the A field is set to OFF  
    
  Additionally, if PMP entry (i) is locked and pmp(i)cfg.A is set to TOR, writes to pmpaddr(i-1) are ignored
* **Verification Goals**
  
  configure 1 PMP entry (the 1st one) with L=1,  
    - write PMP entry (i) with L=1 in M-mode  
    - A is random, should also be tried with A=OFF when L=1 (to cover feature above)  
    - check PMP entry (i) written value in M-mode  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are effectively locked (M-mode check only)  
    - also check for PMP entry (i) where L=1 and pmp(i)cfg.A=TOR that pmpaddr(i-1) is effectively locked  
    - apply hart reset  
    - check for PMP entry (i) reset value (read zero) by reading in M mode  
    - write PMP entry (i) in M-mode  
    - check PMP entry (i) written value in M-mode  
    
  REUSABILITY  
    - if possible, the PMP entry number (i) is a configurable parameter  
    - if possible, (L) value is a configurable parameter  
    - so the same sub-functions are reused with varying (i) and (L) parameters
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F003_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST03(group) => FTR08-a and FTR08-b  
    [check that HW implemented PMP entries are not writable/readable in M-mode (L=1)]  
    [check that no HW implemented PMP entry are writable/readable in S or U modes (L=1)]  
      - before any configuration, check all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
      - configure PMP entry (i) with L=1 (or 0):  pmp(i)cfg and pmpaddr(i) maybe random values  
      - execute following tests specific checks  
      - check only hart reset unlocks all => FTR08-b  
      - check reset values: all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
    
  TST03-1 (HIGH-PRIO)  
  [configure 1 PMP entry ([FTR02-b1]: maybe mandatorily the first one): with L=1,  
    - if possible, the PMP entry number is a configurable parameter  
    - if possible, L value is a configurable parameter  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are effectively locked whatever the SW mode => FTR08-a  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes]
### Sub-feature: 001_configure_2_pmp_entries_L1

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
    
  The L bit indicates that the PMP entry is locked, i.e., writes to the configuration register and associated address registers are ignored  
  If PMP entry (i) is locked, writes to pmp(i)cfg and pmpaddr(i) are ignored  
  Locked PMP entries remain locked until the hart is reset  
    
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Setting the L bit locks the PMP entry even when the A field is set to OFF  
    
  Additionally, if PMP entry (i) is locked and pmp(i)cfg.A is set to TOR, writes to pmpaddr(i-1) are ignored
* **Verification Goals**
  
  configure 2 PMP entries (the 2 first ones in incrementing order) with L=1,  
    - reuse of VP_PMP_F003_S001_I000 sequence
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F003_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST03(group) => FTR08-a and FTR08-b  
    [check that HW implemented PMP entries are not writable/readable in M-mode (L=1)]  
    [check that no HW implemented PMP entry are writable/readable in S or U modes (L=1)]  
      - before any configuration, check all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
      - configure PMP entry (i) with L=1 (or 0):  pmp(i)cfg and pmpaddr(i) maybe random values  
      - execute following tests specific checks  
      - check only hart reset unlocks all => FTR08-b  
      - check reset values: all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
    
  TST03-2 (LOW-PRIO) = 2 times reuse/call of TST02-1  
  [configure 2 PMP entries ([FTR02-b1]: maybe mandatorily the 2 first ones): both with L=1,  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are effectively locked whatever the SW mode => FTR08-a  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes]
### Sub-feature: 002_configure_2_pmp_entries_L0_L1

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
    
  The L bit indicates that the PMP entry is locked, i.e., writes to the configuration register and associated address registers are ignored  
  If PMP entry (i) is locked, writes to pmp(i)cfg and pmpaddr(i) are ignored  
  Locked PMP entries remain locked until the hart is reset  
    
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Setting the L bit locks the PMP entry even when the A field is set to OFF  
    
  Additionally, if PMP entry (i) is locked and pmp(i)cfg.A is set to TOR, writes to pmpaddr(i-1) are ignored
* **Verification Goals**
  
  configure 2 PMP entries (the 2 first ones in incrementing order) at least one with L=1 and one with L=0,  
    - write PMP entry (i) with L=0/1 in M-mode  
    - A is random, should also be tried with A=OFF when L=1 (to cover feature above)  
    - check PMP entry (i) written value in M-mode  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are writable in M mode (read back the written value in M mode)  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are effectively locked (M-mode check only)  
    - also check for PMP entry (i) where L=1 and pmp(i)cfg.A=TOR that pmpaddr(i-1) is effectively locked  
    - apply hart reset  
    - check for PMP entry (i) reset value (read zero) by reading in M mode  
    - write PMP entry (i) in M-mode  
    - check PMP entry (i) written value in M-mode  
    
  REUSABILITY  
    - if possible, the PMP entry number (i) is a configurable parameter  
    - if possible, (L) value is a configurable parameter  
    - so the same sub-functions are reused with varying (i) and (L) parameters
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F003_S003_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST03(group) => FTR08-a and FTR08-b  
    [check that HW implemented PMP entries are not writable/readable in M-mode (L=1)]  
    [check that no HW implemented PMP entry are writable/readable in S or U modes (L=1)]  
      - before any configuration, check all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
      - configure PMP entry (i) with L=1 (or 0):  pmp(i)cfg and pmpaddr(i) maybe random values  
      - execute following tests specific checks  
      - check only hart reset unlocks all => FTR08-b  
      - check reset values: all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
    
  TST03-3 (HIGH-PRIO) = 2 times reuse/call of TST02-1  
  [configure 2 PMP entries ([FTR02-b1]: maybe mandatorily the 2 first ones): one with L=1 and one with L=0,  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are effectively locked whatever the SW mode => FTR08-a  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes  
    - check locked PMP entry (i) has no effect on unlocked PMP entry (j)  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes]
### Sub-feature: 003_configure_N_pmp_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
    
  The L bit indicates that the PMP entry is locked, i.e., writes to the configuration register and associated address registers are ignored  
  If PMP entry (i) is locked, writes to pmp(i)cfg and pmpaddr(i) are ignored  
  Locked PMP entries remain locked until the hart is reset  
    
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Setting the L bit locks the PMP entry even when the A field is set to OFF  
    
  Additionally, if PMP entry (i) is locked and pmp(i)cfg.A is set to TOR, writes to pmpaddr(i-1) are ignored
* **Verification Goals**
  
  configure N PMP entries (the N first ones in incrementing order) at least one with L=1 and one with L=0,  
    - reuse of VP_PMP_F003_S003_I000 sequence
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F003_S004_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST03(group) => FTR08-a and FTR08-b  
    [check that HW implemented PMP entries are not writable/readable in M-mode (L=1)]  
    [check that no HW implemented PMP entry are writable/readable in S or U modes (L=1)]  
      - before any configuration, check all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
      - configure PMP entry (i) with L=1 (or 0):  pmp(i)cfg and pmpaddr(i) maybe random values  
      - execute following tests specific checks  
      - check only hart reset unlocks all => FTR08-b  
      - check reset values: all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
    
  TST03-4 (LOW-PRIO) = N times reuse/call of TST02-1  
  [configure N PMP entries ([FTR02-b1]: maybe mandatorily the N first ones): at least one with L=1 and one with L=0,  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are effectively locked whatever the SW mode => FTR08-a  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes  
    - check locked PMP entry (i) has no effect on unlocked PMP entry (j)  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes]
### Sub-feature: 004_configure_8_pmp_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
    
  The L bit indicates that the PMP entry is locked, i.e., writes to the configuration register and associated address registers are ignored  
  If PMP entry (i) is locked, writes to pmp(i)cfg and pmpaddr(i) are ignored  
  Locked PMP entries remain locked until the hart is reset  
    
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Setting the L bit locks the PMP entry even when the A field is set to OFF  
    
  Additionally, if PMP entry (i) is locked and pmp(i)cfg.A is set to TOR, writes to pmpaddr(i-1) are ignored
* **Verification Goals**
  
  configure all 8 PMP entries (in incrementing order) at least one with L=1 and one with L=0,  
    - reuse of VP_PMP_F003_S003_I000 sequence
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F003_S005_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST03(group) => FTR08-a and FTR08-b  
    [check that HW implemented PMP entries are not writable/readable in M-mode (L=1)]  
    [check that no HW implemented PMP entry are writable/readable in S or U modes (L=1)]  
      - before any configuration, check all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
      - configure PMP entry (i) with L=1 (or 0):  pmp(i)cfg and pmpaddr(i) maybe random values  
      - execute following tests specific checks  
      - check only hart reset unlocks all => FTR08-b  
      - check reset values: all pmp(i)cfg and pmpaddr(i) are M-mode read zero  
    
  TST03-5 (HIGH-PRIO) = 8 times reuse/call of TST02-1  
  [configure 8 PMP entries: at least one with L=1 and one with L=0,  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are effectively locked whatever the SW mode => FTR08-a  
    - check for PMP entry (i) where L=1 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes  
    - check locked PMP entry (i) has no effect on unlocked PMP entry (j)  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for PMP entry (i) where L=0 that pmp(i)cfg and pmpaddr(i) are not writable/readable in S or U modes]
## Feature: CSRs programming order

### Sub-feature: 000_configure_1_pmp_entry

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Section 3.7.1 Page 57 Volume II: RISC-V Privileged Architectures V20211203}  
    
  the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)  
  All PMP CSR fields are WARL and may be read-only zero (QUESTION: does read-only zero mean not implemented?)
* **Verification Goals**
  
  configure any PMP entry (i), but the first one  
    - reuse of VP_PMP_F003_S003_I000 sequence (Feature: "CSRs locked access")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F004_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST04 => FTR02-b1 and FTR02-b2  
    [check if the lowest-numbered PMP CSRs must be programmed first before programming higher-numbered ones]  
     
  TST04-1 (LOW-PRIO) extends TST02-1  
  [configure any PMP entry, but the first one  
    - check for configured PMP entry (i), pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for not configured PMP entry (i), pmp(i)cfg and pmpaddr(i) are M-mode read zero]
### Sub-feature: 001_configure_2_pmp_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Section 3.7.1 Page 57 Volume II: RISC-V Privileged Architectures V20211203}  
    
  the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)  
  All PMP CSR fields are WARL and may be read-only zero (QUESTION: does read-only zero mean not implemented?)
* **Verification Goals**
  
  configure 2 non-adjacent PMP entries (highest-numbered ones first) (avoid the first PMP entry)  
    - reuse of VP_PMP_F003_S003_I000 sequence (Feature: "CSRs locked access")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F004_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST04 => FTR02-b1 and FTR02-b2  
    [check if the lowest-numbered PMP CSRs must be programmed first before programming higher-numbered ones]  
     
  TST04-2 (HIGH-PRIO) extends TST02-2  
  [configure 2 non-adjacent PMP entries (highest-numbered ones first) (avoid the first PMP entry)  
    - check for configured PMP entry (i), pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for not configured PMP entry (i), pmp(i)cfg and pmpaddr(i) are M-mode read zero]
### Sub-feature: 002_configure_N_pmp_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Section 3.7.1 Page 57 Volume II: RISC-V Privileged Architectures V20211203}  
    
  the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)  
  All PMP CSR fields are WARL and may be read-only zero (QUESTION: does read-only zero mean not implemented?)
* **Verification Goals**
  
  configure N PMP entries (highest-numbered ones first) (as non-adjacent as possible, and avoid the first PMP entry)  
    - reuse of VP_PMP_F003_S003_I000 sequence (Feature: "CSRs locked access")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F004_S003_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST04 => FTR02-b1 and FTR02-b2  
    [check if the lowest-numbered PMP CSRs must be programmed first before programming higher-numbered ones]  
     
  TST04-3 (LOW-PRIO) extends TST02-3  
  [configure N PMP entries (highest-numbered ones first) (as non-adjacent as possible, and avoid the first PMP entry)  
    - check for configured PMP entry (i), pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only  
    - check for not configured PMP entry (i), pmp(i)cfg and pmpaddr(i) are M-mode read zero]
### Sub-feature: 003_configure_8_pmp_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Section 3.7.1 Page 57 Volume II: RISC-V Privileged Architectures V20211203}  
    
  the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)  
  All PMP CSR fields are WARL and may be read-only zero (QUESTION: does read-only zero mean not implemented?)
* **Verification Goals**
  
  configure all 8 PMP entries (highest-numbered ones first)  
    - reuse of VP_PMP_F003_S003_I000 sequence (Feature: "CSRs locked access")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F004_S004_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST04 => FTR02-b1 and FTR02-b2  
    [check if the lowest-numbered PMP CSRs must be programmed first before programming higher-numbered ones]  
     
  TST04-4 (HIGH-PRIO) extends TST02-4  
  [configure 8 PMP entries (highest-numbered ones first)  
    - check for configured PMP entry (i), pmp(i)cfg and pmpaddr(i) are writable/readable in M-mode only]
## Feature: CSRs Hardwired regions

### Sub-feature: 000_access with L=0

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   Certain regions’ privileges can be hardwired: so only ever be visible in machine mode but in no lower-privilege layers.  
    
  {Section 3.7.1 Page 57 Volume II: RISC-V Privileged Architectures V20211203}  
  Implementations may implement zero, 16, or 64 PMP CSRs  
    
  {https://docs.openhwgroup.org/projects/cva6-user-manual/01_cva6_user/PMP.html}  
   A maximum of 16 PMP entries are supported.  
  All PMP CSRs are always implemented, but CSRs (or bitfields of CSRs) related to PMP entries with number CVA6Cfg.NrPMPEntries and above are hardwired to zero.  
    
  TRISTAN  
  8 PMP entries are implemented
* **Verification Goals**
  
  configure the first 8 PMP entries with L=0  
    - for each PMP entry (i), check several times that pmp(i)cfg and pmpaddr(i) can be written and can be read back exactly the same (in M-mode)  
    
  for the last 8 PMP entries, check that pmp(i)cfg and pmpaddr(i) always read zero after being written (in M-mode with L=0)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F005_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST05 => FTR01-c and FTR01-c-extended  
    [check all regions are configurable in M-mode to make sure none is hardwired]  
    [regions hardwired privileges might only ever be visible in M-mode]  
    
  TST05-1 (HIGH-PRIO) extends TST02-4  
    - check the written pmp(i)cfg and pmpaddr(i) values can be read exactly the same as written
### Sub-feature: 001_access with L=1

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   Certain regions’ privileges can be hardwired: so only ever be visible in machine mode but in no lower-privilege layers.  
    
  {Section 3.7.1 Page 57 Volume II: RISC-V Privileged Architectures V20211203}  
  Implementations may implement zero, 16, or 64 PMP CSRs  
    
  {https://docs.openhwgroup.org/projects/cva6-user-manual/01_cva6_user/PMP.html}  
   A maximum of 16 PMP entries are supported.  
  All PMP CSRs are always implemented, but CSRs (or bitfields of CSRs) related to PMP entries with number CVA6Cfg.NrPMPEntries and above are hardwired to zero.  
    
  TRISTAN  
  8 PMP entries are implemented
* **Verification Goals**
  
  configure the first 8 PMP entries with L=1  
    - for each PMP entry (i), check once that pmp(i)cfg and pmpaddr(i) can be written and can be read back exactly the same (in M-mode)  
    - apply hart reset  
    - for each PMP entry (i), check once that pmp(i)cfg and pmpaddr(i) can be written and can be read back exactly the same (in M-mode)  
    
  for the last 8 PMP entries, check that pmp(i)cfg and pmpaddr(i) always read zero after being written (in M-mode with L=1)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F005_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST05 => FTR01-c and FTR01-c-extended  
    [check all regions are configurable in M-mode to make sure none is hardwired]  
    [regions hardwired privileges might only ever be visible in M-mode]  
    
  TST05-2 (LOW-PRIO) extends TST03-5  
    - check the written pmp(i)cfg and pmpaddr(i) values can be read exactly the same as written (before hart reset)
## Feature: CSRs reserved values

### Sub-feature: 000_access with L=0

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
     
  The R, W, and X fields form a collective WARL field for which the combinations with R=0 and W=1 are reserved.
* **Verification Goals**
  
  repeat following sequence several times on some PMP entries  
    - write totally random values to pmp(i)cfg and pmpaddr(i), but with L=0  
    - check all pmp(i)cfg and pmpaddr(i) can be read back exactly the same as written except:  
        - except with the reserved combinations [R=0 and W=1]  
        - except with A=NA4 which must not be selectable as G>0
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F006_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST06 => FTR04-a  
  [PMP CSR fields are WARL: PMP entry combinations with R=0 and W=1 are reserved/can’t be read]  
  [permissions fields could be randomly written; should we try randomization ?]  
    
  TST06-1 (HIGH-PRIO) extends TST02-4  
    - write totally random values to pmp(i)cfg and pmpaddr(i)  
    - check all pmp(i)cfg and pmpaddr(i) can be read exactly the same as written except for the reserved combinations with R=0 and W=1
### Sub-feature: 001_access with L=1

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
     
  The R, W, and X fields form a collective WARL field for which the combinations with R=0 and W=1 are reserved.
* **Verification Goals**
  
  repeat following sequence several times on some PMP entries  
    - write totally random values to pmp(i)cfg and pmpaddr(i), but with L=1  
    - check all pmp(i)cfg and pmpaddr(i) can be read back exactly the same as written:  
        - except with the reserved combinations [R=0 and W=1]  
        - except with A=NA4 which must not be selectable as G>0  
    - apply hart reset
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F006_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST06 => FTR04-a  
  [PMP CSR fields are WARL: PMP entry combinations with R=0 and W=1 are reserved/can’t be read]  
  [permissions fields could be randomly written; should we try randomization ?]  
    
  TST06-2 (LOW-PRIO) extends TST03-5  
    - write totally random values to pmp(i)cfg and pmpaddr(i)  
    - check all pmp(i)cfg and pmpaddr(i) can be read exactly the same as written except for the reserved combinations with R=0 and W=1 (before hart reset)
## Feature: no cfg matching/defined

### Sub-feature: 000_no matching entry - M mode access

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
    
  If no PMP entry matches an M-mode access, the access succeeds
* **Verification Goals**
  
  check M-mode access succeeds if no PMP entry matches
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F010_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR09-e  
  [If no PMP entry matches an M-mode access, the access succeeds]  
     
  TST10-1 (HIGH-PRIO) => FTR09-e  
  [check M-mode access succeeds if no PMP entry matches]
### Sub-feature: 001_no defined entry - M mode access

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
    
  If no PMP entry matches an M-mode access, the access succeeds  
  QUESTION: what happens if no PMP entry is implemented ?  
  ASSUMPTION: access succeeds
* **Verification Goals**
  
  check M-mode access succeeds if no PMP entry defined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F010_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR09-e-question  
  [what happens if no PMP entry is implemented ?]  
     
  TST10-2 (HIGH-PRIO) => FTR09-e-question  
  [check M-mode access succeeds if no PMP entry defined]
### Sub-feature: 002_no matching entry - S/U mode access

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
    
  If no PMP entry matches an S-mode or U-mode access, but at least one PMP entry is implemented, the access fails
* **Verification Goals**
  
  check S or U mode access fails when no PMP entry matching and at least one PMP entry implemented
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F010_S003_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR09-f  
  [If no PMP entry matches an S-mode or U-mode access, but at least one PMP entry is implemented, the access fails]  
    
   TST10-3 (HIGH-PRIO) => FTR09-f  
  [check S or U mode access fails when no PMP entry matching and at least one PMP entry implemented]
### Sub-feature: 003_no defined entry - S/U mode access

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
    
  If no PMP entry matches an S-mode or U-mode access, but at least one PMP entry is implemented, the access fails  
  QUESTION: what happens if no PMP entry is implemented ?  
   ASSUMPTION: access fails
* **Verification Goals**
  
  check S or U mode access fails when no PMP entry implemented
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F010_S004_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR09-f-question  
  [what happens if no PMP entry is implemented ?]  
     
  TST10-4 (HIGH-PRIO) => FTR09-f-question  
  [check S or U mode access fails when no PMP entry implemented]
## Feature: cfg NA4 access S/U (G=0)

### Sub-feature: 000_fetch_L0_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  S or U mode single access instruction fetch inside defined NA4 address range with execute permissions and with L=0  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=1, L=0, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  TST11-1x(group) => FTR01-d  
    [PMP check on instruction fetch where effective privilege mode is S or U:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in S and U mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-11 (HIGH-PRIO)  
   [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry with execute permissions for the PMP region  
    - fetch an instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 001_fetch_L0_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
   Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception
* **Verification Goals**
  
  S or U mode single access instruction fetch inside defined NA4 address range without execute permissions and with L=0  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=0, L=0, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from that region (with exact address-matching)  
    
  CHECK  
      - check instruction fetch access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S012_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-b  
   [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
     
  TST11-1x(group) => FTR01-d  
    [PMP check on instruction fetch where effective privilege mode is S or U:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in S and U mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-12 (MEDIUM-PRIO)  
  [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry without execute permissions for the PMP region  
    - fetch an instruction from that region (with exact address-matching)  
    - check instruction fetch access-fault exception raised => FTR04-b]
### Sub-feature: 002_fetch_L0_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  S or U mode single access instruction fetch from outside defined NA4 address range with execute permissions and with L=0  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=1, L=0, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from outside all PMP defined regions  
    
  CHECK  
      - check instruction fetch access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S013_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  TST11-1x(group) => FTR01-d  
    [PMP check on instruction fetch where effective privilege mode is S or U:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in S and U mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-13 (MEDIUM-PRIO)  
   [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry with execute permissions for the PMP region  
    - fetch an instruction from outside all PMP defined regions  
    - check instruction fetch access-fault exception raised]
### Sub-feature: 003_fetch_L1_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset
* **Verification Goals**
  
  S or U mode single access instruction fetch inside defined NA4 address range with execute permissions and with L=1  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=1, L=1, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
    
  TST11-1x(group) => FTR01-d  
    [PMP check on instruction fetch where effective privilege mode is S or U:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in S and U mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-14 (LOW-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with execute permissions for the PMP region  
    - fetch an instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 004_fetch_L1_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
  Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception
* **Verification Goals**
  
  S or U mode single access instruction fetch inside defined NA4 address range without execute permissions and with L=1  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=0, L=1, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from that region (with exact address-matching)  
    
  CHECK  
      - check instruction fetch access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S015_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  FTR04-b  
   [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
    
  TST11-1x(group) => FTR01-d  
    [PMP check on instruction fetch where effective privilege mode is S or U:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in S and U mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-15 (LOW-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry without execute permissions for the PMP region  
    - fetch an instruction from that region (with exact address-matching)  
    - check instruction fetch access-fault exception raised => FTR04-b]
### Sub-feature: 005_fetch_L1_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset
* **Verification Goals**
  
  S or U mode single access instruction fetch from outside defined NA4 address range with execute permissions and with L=1  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=1, L=1, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from outside all PMP defined regions  
    
  CHECK  
      - check instruction fetch access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S016_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  TST11-1x(group) => FTR01-d  
    [PMP check on instruction fetch where effective privilege mode is S or U:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in S and U mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-16 (LOW-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with execute permissions for the PMP region  
    - fetch an instruction from outside all PMP defined regions  
    - check instruction fetch access-fault exception raised]
### Sub-feature: 006_load_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction inside defined NA4 address range with read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S021_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  TST11-2x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-21 (HIGH-PRIO)  
  [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 007_load_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
   Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction inside defined NA4 address range without read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=0, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check load access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S022_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
   [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
  TST11-2x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-22 (MEDIUM-PRIO)  
  [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry without read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check load access-fault exception raised => FTR04-c]
### Sub-feature: 008_load_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction from outside defined NA4 address range with read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from outside all PMP defined regions  
    
  CHECK  
      - check load access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S023_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  TST11-2x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-23 (MEDIUM-PRIO)  
  [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from outside all PMP defined regions  
    - check load access-fault exception raised]
### Sub-feature: 009_load_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction inside defined NA4 address range with read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S024_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  TST11-2x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-24 (LOW-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 010_load_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
  Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction inside defined NA4 address range without read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=0, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check load access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S025_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  FTR04-c  
   [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
     
  TST11-2x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-25 (LOW-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry without read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check load access-fault exception raised => FTR04-c]
### Sub-feature: 011_load_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction from outside defined NA4 address range with read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from outside all PMP defined regions  
    
  CHECK  
      - check load access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S026_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  TST11-2x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-26 (LOW-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from outside all PMP defined regions  
    - check load access-fault exception raised]
### Sub-feature: 012_store_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction inside defined NA4 address range with write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S031_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  TST11-3x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-31 (HIGH-PRIO)  
   [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 013_store_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
   Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction inside defined NA4 address range without write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=0, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check store access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S032_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
   [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  TST11-3x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-32 (MEDIUM-PRIO)  
   [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry without write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check store access-fault exception raised => FTR04-d]
### Sub-feature: 014_store_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction from outside defined NA4 address range with write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    
  CHECK  
      - check store access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S033_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  TST11-3x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-33 (MEDIUM-PRIO)  
   [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    - check store access-fault exception raised]
### Sub-feature: 015_store_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction inside defined NA4 address range with write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S034_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  TST11-3x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-34 (LOW-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 016_store_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
  Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction inside defined NA4 address range without write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=0, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check store access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S035_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  FTR04-d  
   [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  TST11-3x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-35 (LOW-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry without write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check store access-fault exception raised => FTR04-d]
### Sub-feature: 017_store_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction from outside defined NA4 address range with write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    
  CHECK  
      - check store access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S036_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  TST11-3x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in S and U mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-36 (LOW-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    - check store access-fault exception raised]
### Sub-feature: 018_load_MPP_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction inside defined NA4 address range with read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S041_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  TST11-4x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-41 (LOWEST-PRIO)  
   [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 019_load_MPP_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
   Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction inside defined NA4 address range without read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=0, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check load access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S042_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
   [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
  TST11-4x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-42 (LOWEST-PRIO)  
   [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry without read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check load access-fault exception raised => FTR04-c]
### Sub-feature: 020_load_MPP_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction from outside defined NA4 address range with read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a load or load-reserved instruction from outside all PMP defined regions  
    
  CHECK  
      - check load access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S043_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  TST11-4x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-43 (LOWEST-PRIO)  
   [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from outside all PMP defined regions  
    - check load access-fault exception raised]
### Sub-feature: 021_load_MPP_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction inside defined NA4 address range with read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S044_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  TST11-4x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-44 (LOWEST-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 022_load_MPP_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
  Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction inside defined NA4 address range without read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=0, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check load access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S045_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  FTR04-c  
   [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
     
  TST11-4x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-45 (LOWEST-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry without read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check load access-fault exception raised => FTR04-c]
### Sub-feature: 023_load_MPP_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset
* **Verification Goals**
  
  S or U mode single access load or load-reserved instruction from outside defined NA4 address range with read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a load or load-reserved instruction from outside all PMP defined regions  
    
  CHECK  
      - check load access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S046_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  TST11-4x(group) => FTR01-d  
    [PMP check on load or load-reserved instruction where effective privilege mode is S or U:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST11-46 (LOWEST-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from outside all PMP defined regions  
    - check load access-fault exception raised]
### Sub-feature: 024_store_MPP_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction inside defined NA4 address range with write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S051_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  TST11-5x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-51 (LOWEST-PRIO)  
  [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 025_store_MPP_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
   Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction inside defined NA4 address range without write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=0, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check store access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S052_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
   [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  TST11-5x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-52 (LOWEST-PRIO)  
   [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry without write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check store access-fault exception raised => FTR04-d]
### Sub-feature: 026_store_MPP_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, the R/W/X permissions apply only to S and U modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction from outside defined NA4 address range with write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    
  CHECK  
      - check store access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S053_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e2-2 (refers to FTR09-d2-2)  
   [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
   FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
  [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  TST11-5x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-53 (LOWEST-PRIO)  
  [with L=0 => FTR08-e2-2 (refers to FTR09-d2-2),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    - check store access-fault exception raised]
### Sub-feature: 027_store_MPP_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction inside defined NA4 address range with write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S054_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  TST11-5x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-54 (LOWEST-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 028_store_MPP_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
  Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction inside defined NA4 address range without write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=0, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check store access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S055_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  FTR04-d  
   [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  TST11-5x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-55 (LOWEST-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry without write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check store access-fault exception raised => FTR04-d]
### Sub-feature: 029_store_MPP_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks are applied to all accesses whose effective privilege mode is S or U  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
   if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
   Locked PMP entries remain locked until the hart is reset
* **Verification Goals**
  
  S or U mode single access store, store-conditional, or AMO instruction from outside defined NA4 address range with write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains S or U  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    
  CHECK  
      - check store access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F011_S056_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
   [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
  FTR08-b  
   [Locked PMP entries remain locked until the hart is reset]  
    
  TST11-5x(group) => FTR01-d  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is S or U:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains S or U]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST11-56 (LOWEST-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    - check store access-fault exception raised]
## Feature: cfg NA4 access M (G=0)

### Sub-feature: 000_fetch_L0_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access instruction fetch inside defined NA4 address range with execute permissions and with L=0  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=1, L=0, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-1x(group) => FTR01-f  
    [PMP check on instruction fetch where effective privilege mode is M:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in M mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-11 (LOW-PRIO)  
   [with L=0 => FTR08-e2-1 (refers to  FTR09-d1),  
    - configure the PMP entry with execute permissions for the PMP region  
    - fetch an instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 001_fetch_L0_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access instruction fetch inside defined NA4 address range without execute permissions and with L=0  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=0, L=0, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S012_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-1x(group) => FTR01-f  
    [PMP check on instruction fetch where effective privilege mode is M:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in M mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-12 (LOW-PRIO)  
   [with L=0 => FTR08-e2-1 (refers to  FTR09-d1),  
    - configure the PMP entry without execute permissions for the PMP region  
    - fetch an instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 002_fetch_L0_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access instruction fetch from outside defined NA4 address range with execute permissions and with L=0  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=1, L=0, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from outside all PMP defined regions  
    
  CHECK  
      - check no access-fault exception (Feature: "no cfg matching")  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S013_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-1x(group) => FTR01-f  
    [PMP check on instruction fetch where effective privilege mode is M:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in M mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-13 (LOW-PRIO)  
   [with L=0 => FTR08-e2-1 (refers to  FTR09-d1),  
    - configure the PMP entry with execute permissions for the PMP region  
    - fetch an instruction from outside all PMP defined regions  
    - check no access-fault exception] //TODO: CHECK IF M-MODE ALLOWED
### Sub-feature: 003_fetch_L1_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  M mode single access instruction fetch inside defined NA4 address range with execute permissions and with L=1  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=1, L=1, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-1x(group) => FTR01-f  
    [PMP check on instruction fetch where effective privilege mode is M:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in M mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-14 (HIGH-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with execute permissions for the PMP region  
    - fetch an instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 004_fetch_L1_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
  Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception
* **Verification Goals**
  
  M mode single access instruction fetch inside defined NA4 address range without execute permissions and with L=1  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=0, L=1, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from that region (with exact address-matching)  
    
  CHECK  
      - check instruction fetch access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S015_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR04-b  
  [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  TST12-1x(group) => FTR01-f  
    [PMP check on instruction fetch where effective privilege mode is M:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in M mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-15 (MEDIUM-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry without execute permissions for the PMP region  
    - fetch an instruction from that region (with exact address-matching)  
    - check instruction fetch access-fault exception raised => FTR04-b]
### Sub-feature: 005_fetch_L1_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  M mode single access instruction fetch from outside defined NA4 address range with execute permissions and with L=1  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, X=1, L=1, R/W:random, with reserve on R=0 & W=1  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - fetch an instruction from outside all PMP defined regions  
    
  CHECK  
      - check no access-fault exception (Feature: "no cfg matching")  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S016_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-1x(group) => FTR01-f  
    [PMP check on instruction fetch where effective privilege mode is M:  
      - choose an executable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access instruction fetch in M mode]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-16 (HIGH-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with execute permissions for the PMP region  
    - fetch an instruction from outside all PMP defined regions  
    - check no access-fault exception] //TODO: CHECK IF M-MODE ALLOWED
### Sub-feature: 006_load_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access load or load-reserved instruction inside defined NA4 address range with read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S021_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-2x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-21 (LOW-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 007_load_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access load or load-reserved instruction inside defined NA4 address range without read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=0, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S022_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-2x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-22 (LOW-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry without read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 008_load_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access load or load-reserved instruction from outside defined NA4 address range with read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from outside all PMP defined regions  
    
  CHECK  
      - check no access-fault exception (Feature: "no cfg matching")  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S023_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-2x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-23 (LOW-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from outside all PMP defined regions  
    - check no access-fault exception] //TODO: CHECK IF M-MODE ALLOWED
### Sub-feature: 009_load_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  M mode single access load or load-reserved instruction inside defined NA4 address range with read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S024_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-2x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-24 (HIGH-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 010_load_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
  Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception
* **Verification Goals**
  
  M mode single access load or load-reserved instruction inside defined NA4 address range without read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=0, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check load access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S025_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  TST12-2x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-25 (MEDIUM-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry without read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check load access-fault exception raised => FTR04-c]
### Sub-feature: 011_load_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  M mode single access load or load-reserved instruction from outside defined NA4 address range with read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a load or load-reserved instruction from outside all PMP defined regions  
    
  CHECK  
      - check no access-fault exception (Feature: "no cfg matching")  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S026_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-2x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-26 (HIGH-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from outside all PMP defined regions  
    - check no access-fault exception] //TODO: CHECK IF M-MODE ALLOWED
### Sub-feature: 012_store_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction inside defined NA4 address range with write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S031_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-3x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-31 (LOW-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 013_store_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction inside defined NA4 address range without write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=0, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S032_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-3x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-32 (LOW-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry without write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 014_store_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction from outside defined NA4 address range with write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    
  CHECK  
      - check no access-fault exception (Feature: "no cfg matching")  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S033_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-3x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-33 (LOW-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    - check no access-fault exception] //TODO: CHECK IF M-MODE ALLOWED
### Sub-feature: 015_store_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction inside defined NA4 address range with write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S034_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-3x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-34 (HIGH-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 016_store_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
  Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction inside defined NA4 address range without write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=0, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check store access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S035_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
   TST12-3x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-35 (MEDIUM-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry without write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check store access-fault exception raised => FTR04-d]
### Sub-feature: 017_store_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction from outside defined NA4 address range with write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=0  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    
  CHECK  
      - check no access-fault exception (Feature: "no cfg matching")  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S036_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-3x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in M mode when the bit mstatus.MPRV=0]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-36 (HIGH-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    - check no access-fault exception] //TODO: CHECK IF M-MODE ALLOWED
### Sub-feature: 018_load_MPP_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access load or load-reserved instruction inside defined NA4 address range with read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S041_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-4x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST12-41 (LOWEST-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 019_load_MPP_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access load or load-reserved instruction inside defined NA4 address range without read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=0, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S042_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-4x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST12-42 (LOWEST-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry without read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 020_load_MPP_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access load or load-reserved instruction from outside defined NA4 address range with read permissions and with L=0  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=0, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a load or load-reserved instruction from outside all PMP defined regions  
    
  CHECK  
      - check no access-fault exception (Feature: "no cfg matching")  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S043_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-4x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST12-43 (LOWEST-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from outside all PMP defined regions  
    - check no access-fault exception] //TODO: CHECK IF M-MODE ALLOWED
### Sub-feature: 021_load_MPP_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  M mode single access load or load-reserved instruction inside defined NA4 address range with read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S044_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-4x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST12-44 (LOWEST-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 022_load_MPP_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
  Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception
* **Verification Goals**
  
  M mode single access load or load-reserved instruction inside defined NA4 address range without read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=0, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a load or load-reserved instruction from that region (with exact address-matching)  
    
  CHECK  
      - check load access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S045_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  TST12-4x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-45 (LOWEST-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry without read permissions for the PMP region  
    - execute a load or load-reserved instruction from that region (with exact address-matching)  
    - check load access-fault exception raised => FTR04-c]
### Sub-feature: 023_load_MPP_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  M mode single access load or load-reserved instruction from outside defined NA4 address range with read permissions and with L=1  
      - choose a readable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, R=1, L=1, X/W:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a load or load-reserved instruction from outside all PMP defined regions  
    
  CHECK  
      - check no access-fault exception (Feature: "no cfg matching")  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S046_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-4x(group) => FTR01-f  
    [PMP check on load or load-reserved instruction where effective privilege mode is M:  
      - choose a data readable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data load in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST12-46 (LOWEST-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with read permissions for the PMP region  
    - execute a load or load-reserved instruction from outside all PMP defined regions  
    - check no access-fault exception] //TODO: CHECK IF M-MODE ALLOWED
### Sub-feature: 024_store_MPP_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction inside defined NA4 address range with write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S051_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-5x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-51 (LOWEST-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 025_store_MPP_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction inside defined NA4 address range without write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=0, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S052_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-5x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-52 (LOWEST-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry without write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 026_store_MPP_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is clear, any M-mode access matching the PMP entry will succeed  
    
   {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  If the L bit is clear and the privilege mode of the access is M, the access succeeds
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction from outside defined NA4 address range with write permissions and with L=0  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=0, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    
  CHECK  
      - check no access-fault exception (Feature: "no cfg matching")  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S053_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
     
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-5x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST12-53 (LOWEST-PRIO)  
  [with L=0 => FTR08-e2-1 (refers to  FTR09-d1)  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    - check no access-fault exception] //TODO: CHECK IF M-MODE ALLOWED
### Sub-feature: 027_store_MPP_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction inside defined NA4 address range with write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check no access-fault exception  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S054_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-5x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST12-54 (LOWEST-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check no access-fault exception]
### Sub-feature: 028_store_MPP_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set  
    
  {Page 58 Volume II: RISC-V Privileged Architectures V20211203}  
  Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction inside defined NA4 address range without write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=0, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    
  CHECK  
      - check store access-fault exception raised  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S055_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
   TST12-5x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST12-55 (LOWEST-PRIO)  
   [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry without write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to that region (with exact address-matching)  
    - check store access-fault exception raised => FTR04-d]
### Sub-feature: 029_store_MPP_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 56 Volume II: RISC-V Privileged Architectures V20211203}  
   PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset  
    
  {Page 60 Section "Locking and Privilege Mode" Volume II: RISC-V Privileged Architectures V20211203}  
  When the L bit is set, these permissions are enforced for all privilege modes  
    
  {Page 60 Section "Priority and Matching Logic" Volume II: RISC-V Privileged Architectures V20211203}  
  if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set
* **Verification Goals**
  
  M mode single access store, store-conditional, or AMO instruction from outside defined NA4 address range with write permissions and with L=1  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i)  
    
  CONFIGURATION  
      - pmpcfg(i): A=NA4, W=1, L=1, X/R:random  
      - pmpaddr(i): NA4 address range  
      - mstatus.MPRV=1 and mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)  
    
  ACCESS  
      - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    
  CHECK  
      - check no access-fault exception (Feature: "no cfg matching")  
    
  REUSABILITY  
      - if possible, the PMP entry number (i) is a configurable parameter  
      - if possible, the PMP entry lock (L) is a configurable parameter  
      - if possible, the PMP entry permissions (R,W,X) are configurable parameters  
      - if possible, the PMP entry adress-matching mode (A) is a configurable parameter  
      - if possible, the PMP entry address range (pmpaddr) is a configurable parameter  
      - if possible, the PMP entry associated access address is a configurable parameter  
      - so a single CONFIGURATION function and a single ACCESS function can be reused and combined
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F012_S056_I000
* **Link to Coverage:** 
* **Comments**
  
  <<Since G=1 the NA4 mode is not selectable>>  
    
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
     
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
   FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
  TST12-5x(group) => FTR01-f  
    [PMP check on store, store-conditional, or AMO instruction where effective privilege mode is M:  
      - choose a data writable pmp region and address range  
      - choose only one PMP entry (i) ([FTR02-b1]: maybe mandatorily the 1st one)  
      - if possible, the PMP entry number is a configurable parameter  
      - choose pmpcfg(i).A=NA4  
      - single access data store in any mode when the bit mstatus.MPRV=1 and the mstatus.MPP contains M (TODO: CHECK IF MAKING SENSE)]  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
   TST12-56 (LOWEST-PRIO)  
  [with L=1 => FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1),  
    - configure the PMP entry with write permissions for the PMP region  
    - execute a store, store-conditional, or AMO instruction to outside all PMP defined regions  
    - check no access-fault exception] //TODO: CHECK IF M-MODE ALLOWED
## Feature: cfg NAPOT access S/U

### Sub-feature: 000_fetch_L0_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S011_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S011_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-11 (HIGH-PRIO)  
    [same as TST11-11(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 001_fetch_L0_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S012_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S012_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S012_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-b  
   [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
     
    
  TST13-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-12 (MEDIUM-PRIO)  
    [same as TST11-12(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 002_fetch_L0_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S013_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S013_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S013_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-13 (MEDIUM-PRIO)  
    [same as TST11-13(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 003_fetch_L1_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S014_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S014_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-14 (LOW-PRIO)  
    [same as TST11-14(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 004_fetch_L1_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S015_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S015_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S015_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-b  
  [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
    
    
  TST13-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-15 (LOW-PRIO)  
    [same as TST11-15(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 005_fetch_L1_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S016_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S016_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S016_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-16 (LOW-PRIO)  
    [same as TST11-16(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 006_load_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S021_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S021_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S021_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-21 (HIGH-PRIO)  
    [same as TST11-21(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 007_load_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S022_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S022_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S022_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
   [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST13-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=NAPOT]  
  TST13-22 (MEDIUM-PRIO)  
    [same as TST11-22(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 008_load_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S023_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S023_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S023_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-23 (MEDIUM-PRIO)  
    [same as TST11-23(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 009_load_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S024_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S024_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S024_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-24 (LOW-PRIO)  
    [same as TST11-24(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 010_load_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S025_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S025_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S025_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST13-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-25 (LOW-PRIO)  
    [same as TST11-25(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 011_load_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S026_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S026_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S026_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-26 (LOW-PRIO)  
    [same as TST11-26(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 012_store_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S031_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S031_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S031_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-31 (HIGH-PRIO)  
    [same as TST11-31(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 013_store_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S032_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S032_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S032_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
   [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST13-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=NAPOT]  
  TST13-32 (MEDIUM-PRIO)  
    [same as TST11-32(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 014_store_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S033_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S033_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S033_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-33 (MEDIUM-PRIO)  
    [same as TST11-33(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 015_store_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S034_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S034_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S034_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-34 (LOW-PRIO)  
    [same as TST11-34(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 016_store_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S035_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S035_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S035_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST13-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=NAPOT]  
  TST13-35 (LOW-PRIO)  
    [same as TST11-35(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 017_store_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S036_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S036_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S036_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-36 (LOW-PRIO)  
    [same as TST11-36(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 018_load_MPP_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S041_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S041_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S041_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-41 (LOWEST-PRIO)  
    [same as TST11-41(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 019_load_MPP_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S042_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S042_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S042_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
   [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST13-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=NAPOT]  
  TST13-42 (LOWEST-PRIO)  
    [same as TST11-42(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 020_load_MPP_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S043_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S043_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S043_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-43 (LOWEST-PRIO)  
    [same as TST11-43(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 021_load_MPP_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S044_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S044_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S044_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-44 (LOWEST-PRIO)  
    [same as TST11-44(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 022_load_MPP_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S045_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S045_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S045_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST13-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-45 (LOWEST-PRIO)  
    [same as TST11-45(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 023_load_MPP_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S046_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S046_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S046_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-46 (LOWEST-PRIO)  
    [same as TST11-46(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 024_store_MPP_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S051_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S051_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S051_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-51 (LOWEST-PRIO)  
    [same as TST11-51(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 025_store_MPP_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S052_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S052_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S052_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
   [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST13-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=NAPOT]  
  TST13-52 (LOWEST-PRIO)  
    [same as TST11-52(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 026_store_MPP_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S053_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S053_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S053_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-53 (LOWEST-PRIO)  
    [same as TST11-53(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 027_store_MPP_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S054_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S054_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S054_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-54 (LOWEST-PRIO)  
    [same as TST11-54(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 028_store_MPP_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S055_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S055_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S055_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST13-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=NAPOT]  
  TST13-55 (LOWEST-PRIO)  
    [same as TST11-55(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 029_store_MPP_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S056_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S056_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F013_S056_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST13-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=NAPOT]  
   TST13-56 (LOWEST-PRIO)  
    [same as TST11-56(group), but with pmpcfg(i).A=NAPOT]
## Feature: cfg NAPOT access M

### Sub-feature: 000_fetch_L0_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S011_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S011_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-11 (LOW-PRIO)  
    [same as TST12-11(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 001_fetch_L0_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S012_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S012_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S012_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-12 (LOW-PRIO)  
    [same as TST12-12(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 002_fetch_L0_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S013_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S013_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S013_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-13 (LOW-PRIO)  
    [same as TST12-13(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 003_fetch_L1_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S014_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S014_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-14 (HIGH-PRIO)  
    [same as TST12-14(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 004_fetch_L1_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S015_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S015_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S015_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-b  
  [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-15 (MEDIUM-PRIO)  
    [same as TST12-15(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 005_fetch_L1_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S016_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S016_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S016_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-16 (HIGH-PRIO)  
    [same as TST12-16(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 006_load_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S021_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S021_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S021_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-21 (LOW-PRIO)  
    [same as TST12-21(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 007_load_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S022_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S022_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S022_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-22 (LOW-PRIO)  
    [same as TST12-22(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 008_load_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S023_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S023_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S023_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-23 (LOW-PRIO)  
    [same as TST12-23(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 009_load_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S024_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S024_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S024_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-24 (HIGH-PRIO)  
    [same as TST12-24(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 010_load_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S025_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S025_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S025_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
    
  TST14-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=NAPOT]  
   TST14-25 (MEDIUM-PRIO)  
    [same as TST12-25(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 011_load_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S026_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S026_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S026_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-26 (HIGH-PRIO)  
    [same as TST12-26(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 012_store_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S031_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S031_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S031_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-31 (LOW-PRIO)  
    [same as TST12-31(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 013_store_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S032_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S032_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S032_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-32 (LOW-PRIO)  
    [same as TST12-32(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 014_store_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S033_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S033_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S033_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-33 (LOW-PRIO)  
    [same as TST12-33(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 015_store_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S034_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S034_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S034_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-34 (HIGH-PRIO)  
    [same as TST12-34(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 016_store_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S035_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S035_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S035_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  FTR02-b1  
   [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-35 (MEDIUM-PRIO)  
    [same as TST12-35(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 017_store_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S036_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S036_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S036_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-36 (HIGH-PRIO)  
    [same as TST12-36(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 018_load_MPP_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S041_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S041_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S041_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-41 (LOWEST-PRIO)  
    [same as TST12-41(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 019_load_MPP_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S042_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S042_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S042_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-42 (LOWEST-PRIO)  
    [same as TST12-42(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 020_load_MPP_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S043_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S043_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S043_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-43 (LOWEST-PRIO)  
    [same as TST12-43(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 021_load_MPP_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S044_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S044_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S044_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-44 (LOWEST-PRIO)  
    [same as TST12-44(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 022_load_MPP_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S045_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S045_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S045_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
    
  TST14-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=NAPOT]  
   TST14-45 (LOWEST-PRIO)  
    [same as TST12-45(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 023_load_MPP_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S046_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S046_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S046_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-46 (LOWEST-PRIO)  
    [same as TST12-46(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 024_store_MPP_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S051_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S051_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S051_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-51 (LOWEST-PRIO)  
    [same as TST12-51(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 025_store_MPP_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S052_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S052_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S052_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-52 (LOWEST-PRIO)  
    [same as TST12-52(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 026_store_MPP_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S053_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S053_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S053_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-53 (LOWEST-PRIO)  
    [same as TST12-53(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 027_store_MPP_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S054_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S054_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S054_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-54 (LOWEST-PRIO)  
    [same as TST12-54(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 028_store_MPP_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S055_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S055_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S055_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  FTR02-b1  
   [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-55 (LOWEST-PRIO)  
    [same as TST12-55(group), but with pmpcfg(i).A=NAPOT]
### Sub-feature: 029_store_MPP_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S056_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S056_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=NAPOT  
      - pmpaddr(i): any NAPOT address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F014_S056_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST14-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=NAPOT]  
  TST14-56 (LOWEST-PRIO)  
    [same as TST12-56(group), but with pmpcfg(i).A=NAPOT]
## Feature: cfg TOR access S/U

### Sub-feature: 000_fetch_L0_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S011_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S011_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=TOR]  
   TST15-11 (HIGH-PRIO)  
    [same as TST11-11(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 001_fetch_L0_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S012_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S012_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S012_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-b  
   [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
     
    
  TST15-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=TOR]  
   TST15-12 (MEDIUM-PRIO)  
    [same as TST11-12(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 002_fetch_L0_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S013_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S013_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S013_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=TOR]  
   TST15-13 (MEDIUM-PRIO)  
    [same as TST11-13(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 003_fetch_L1_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S014_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S014_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=TOR]  
   TST15-14 (LOW-PRIO)  
    [same as TST11-14(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 004_fetch_L1_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S015_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S015_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S015_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-b  
  [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
    
    
  TST15-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=TOR]  
   TST15-15 (LOW-PRIO)  
    [same as TST11-15(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 005_fetch_L1_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S016_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S016_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S016_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=TOR]  
   TST15-16 (LOW-PRIO)  
    [same as TST11-16(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 006_load_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S021_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S021_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S021_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=TOR]  
   TST15-21 (HIGH-PRIO)  
    [same as TST11-21(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 007_load_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S022_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S022_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S022_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
   [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST15-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=TOR]  
  TST15-22 (MEDIUM-PRIO)  
    [same as TST11-22(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 008_load_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S023_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S023_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S023_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=TOR]  
   TST15-23 (MEDIUM-PRIO)  
    [same as TST11-23(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 009_load_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S024_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S024_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S024_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=TOR]  
   TST15-24 (LOW-PRIO)  
    [same as TST11-24(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 010_load_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S025_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S025_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S025_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST15-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=TOR]  
   TST15-25 (LOW-PRIO)  
    [same as TST11-25(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 011_load_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S026_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S026_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S026_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=TOR]  
   TST15-26 (LOW-PRIO)  
    [same as TST11-26(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 012_store_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S031_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S031_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S031_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=TOR]  
   TST15-31 (HIGH-PRIO)  
    [same as TST11-31(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 013_store_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S032_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S032_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S032_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
   [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST15-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=TOR]  
  TST15-32 (MEDIUM-PRIO)  
    [same as TST11-32(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 014_store_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S033_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S033_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S033_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=TOR]  
   TST15-33 (MEDIUM-PRIO)  
    [same as TST11-33(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 015_store_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S034_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S034_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S034_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=TOR]  
   TST15-34 (LOW-PRIO)  
    [same as TST11-34(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 016_store_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S035_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S035_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S035_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST15-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=TOR]  
  TST15-35 (LOW-PRIO)  
    [same as TST11-35(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 017_store_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S036_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S036_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S036_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=TOR]  
   TST15-36 (LOW-PRIO)  
    [same as TST11-36(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 018_load_MPP_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S041_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S041_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S041_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=TOR]  
   TST15-41 (LOWEST-PRIO)  
    [same as TST11-41(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 019_load_MPP_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S042_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S042_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S042_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
   [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST15-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=TOR]  
  TST15-42 (LOWEST-PRIO)  
    [same as TST11-42(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 020_load_MPP_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S043_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S043_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S043_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=TOR]  
   TST15-43 (LOWEST-PRIO)  
    [same as TST11-43(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 021_load_MPP_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S044_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S044_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S044_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=TOR]  
   TST15-44 (LOWEST-PRIO)  
    [same as TST11-44(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 022_load_MPP_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S045_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S045_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S045_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST15-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=TOR]  
   TST15-45 (LOWEST-PRIO)  
    [same as TST11-45(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 023_load_MPP_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S046_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S046_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S046_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=TOR]  
   TST15-46 (LOWEST-PRIO)  
    [same as TST11-46(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 024_store_MPP_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S051_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S051_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S051_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=TOR]  
   TST15-51 (LOWEST-PRIO)  
    [same as TST11-51(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 025_store_MPP_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S052_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S052_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S052_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
   [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST15-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=TOR]  
  TST15-52 (LOWEST-PRIO)  
    [same as TST11-52(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 026_store_MPP_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S053_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S053_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S053_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=TOR]  
   TST15-53 (LOWEST-PRIO)  
    [same as TST11-53(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 027_store_MPP_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S054_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S054_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S054_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=TOR]  
   TST15-54 (LOWEST-PRIO)  
    [same as TST11-54(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 028_store_MPP_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S055_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S055_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S055_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST15-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=TOR]  
  TST15-55 (LOWEST-PRIO)  
    [same as TST11-55(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 029_store_MPP_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S056_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S056_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S056_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=TOR]  
   TST15-56 (LOWEST-PRIO)  
    [same as TST11-56(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 030_fetch_L0_X1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S011_I000 feature description (Cf. Feature: "cfg NA4 access S/U")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F011_S011_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)  
    
  CHECK UPDATE  
      - check instruction fetch access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S061_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=TOR]  
   TST15-11 (LOW-PRIO)  
    [same as TST11-11(group), but with pmpcfg(i).A=TOR]  
     
    
  //TO COMPLETE => FTR06-b  
  TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
### Sub-feature: 031_fetch_L1_X1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S014_I000 feature description (Cf. Feature: "cfg NA4 access S/U")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F011_S014_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)  
    
  CHECK UPDATE  
      - check instruction fetch access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S062_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=TOR]  
   TST15-14 (LOW-PRIO)  
    [same as TST11-14(group), but with pmpcfg(i).A=TOR]  
     
    
  //TO COMPLETE => FTR06-b  
  TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
### Sub-feature: 032_load_L0_R1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S021_I000 feature description (Cf. Feature: "cfg NA4 access S/U")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F011_S021_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)  
    
  CHECK UPDATE  
      - check load access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S063_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=TOR]  
   TST15-21 (HIGH-PRIO)  
    [same as TST11-21(group), but with pmpcfg(i).A=TOR]  
     
    
  //TO COMPLETE => FTR06-b  
  TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
### Sub-feature: 033_load_L1_R1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S024_I000 feature description (Cf. Feature: "cfg NA4 access S/U")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F011_S024_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)  
    
  CHECK UPDATE  
      - check load access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S064_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=TOR]  
   TST15-24 (LOW-PRIO)  
    [same as TST11-24(group), but with pmpcfg(i).A=TOR]  
     
    
  //TO COMPLETE => FTR06-b  
  TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
### Sub-feature: 034_store_L0_W1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S031_I000 feature description (Cf. Feature: "cfg NA4 access S/U")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F011_S031_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)  
    
  CHECK UPDATE  
      - check store access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S065_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=TOR]  
   TST15-31 (HIGH-PRIO)  
    [same as TST11-31(group), but with pmpcfg(i).A=TOR]  
     
    
  //TO COMPLETE => FTR06-b  
  TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
### Sub-feature: 035_store_L1_W1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S034_I000 feature description (Cf. Feature: "cfg NA4 access S/U")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F011_S034_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)  
    
  CHECK UPDATE  
      - check store access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F015_S066_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST15-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=TOR]  
   TST15-34 (LOW-PRIO)  
    [same as TST11-34(group), but with pmpcfg(i).A=TOR]  
     
    
  //TO COMPLETE => FTR06-b  
  TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
## Feature: cfg TOR access M

### Sub-feature: 000_fetch_L0_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S011_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S011_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=TOR]  
  TST16-11 (LOW-PRIO)  
    [same as TST12-11(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 001_fetch_L0_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S012_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S012_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S012_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=TOR]  
  TST16-12 (LOW-PRIO)  
    [same as TST12-12(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 002_fetch_L0_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S013_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S013_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S013_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=TOR]  
  TST16-13 (LOW-PRIO)  
    [same as TST12-13(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 003_fetch_L1_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S014_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S014_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=TOR]  
  TST16-14 (HIGH-PRIO)  
    [same as TST12-14(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 004_fetch_L1_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S015_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S015_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S015_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-b  
  [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=TOR]  
  TST16-15 (MEDIUM-PRIO)  
    [same as TST12-15(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 005_fetch_L1_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S016_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S016_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S016_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=TOR]  
  TST16-16 (HIGH-PRIO)  
    [same as TST12-16(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 006_load_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S021_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S021_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S021_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=TOR]  
  TST16-21 (LOW-PRIO)  
    [same as TST12-21(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 007_load_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S022_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S022_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S022_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=TOR]  
  TST16-22 (LOW-PRIO)  
    [same as TST12-22(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 008_load_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S023_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S023_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S023_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=TOR]  
  TST16-23 (LOW-PRIO)  
    [same as TST12-23(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 009_load_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S024_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S024_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S024_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=TOR]  
  TST16-24 (HIGH-PRIO)  
    [same as TST12-24(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 010_load_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S025_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S025_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S025_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
    
  TST16-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=TOR]  
   TST16-25 (MEDIUM-PRIO)  
    [same as TST12-25(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 011_load_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S026_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S026_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S026_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=TOR]  
  TST16-26 (HIGH-PRIO)  
    [same as TST12-26(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 012_store_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S031_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S031_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S031_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=TOR]  
  TST16-31 (LOW-PRIO)  
    [same as TST12-31(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 013_store_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S032_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S032_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S032_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=TOR]  
  TST16-32 (LOW-PRIO)  
    [same as TST12-32(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 014_store_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S033_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S033_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S033_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=TOR]  
  TST16-33 (LOW-PRIO)  
    [same as TST12-33(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 015_store_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S034_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S034_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S034_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=TOR]  
  TST16-34 (HIGH-PRIO)  
    [same as TST12-34(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 016_store_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S035_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S035_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S035_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  FTR02-b1  
   [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=TOR]  
  TST16-35 (MEDIUM-PRIO)  
    [same as TST12-35(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 017_store_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S036_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S036_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S036_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=TOR]  
  TST16-36 (HIGH-PRIO)  
    [same as TST12-36(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 018_load_MPP_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S041_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S041_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S041_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=TOR]  
  TST16-41 (LOWEST-PRIO)  
    [same as TST12-41(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 019_load_MPP_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S042_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S042_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S042_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=TOR]  
  TST16-42 (LOWEST-PRIO)  
    [same as TST12-42(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 020_load_MPP_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S043_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S043_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S043_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=TOR]  
  TST16-43 (LOWEST-PRIO)  
    [same as TST12-43(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 021_load_MPP_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S044_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S044_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S044_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=TOR]  
  TST16-44 (LOWEST-PRIO)  
    [same as TST12-44(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 022_load_MPP_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S045_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S045_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S045_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
    
  TST16-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=TOR]  
   TST16-45 (LOWEST-PRIO)  
    [same as TST12-45(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 023_load_MPP_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S046_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S046_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S046_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=TOR]  
  TST16-46 (LOWEST-PRIO)  
    [same as TST12-46(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 024_store_MPP_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S051_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S051_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S051_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=TOR]  
  TST16-51 (LOWEST-PRIO)  
    [same as TST12-51(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 025_store_MPP_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S052_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S052_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S052_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=TOR]  
  TST16-52 (LOWEST-PRIO)  
    [same as TST12-52(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 026_store_MPP_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S053_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S053_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S053_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=TOR]  
  TST16-53 (LOWEST-PRIO)  
    [same as TST12-53(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 027_store_MPP_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S054_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S054_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S054_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=TOR]  
  TST16-54 (LOWEST-PRIO)  
    [same as TST12-54(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 028_store_MPP_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S055_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S055_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S055_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  FTR02-b1  
   [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=TOR]  
  TST16-55 (LOWEST-PRIO)  
    [same as TST12-55(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 029_store_MPP_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S056_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S056_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i) > pmpaddr(i-1): any TOR address range  
      - [for i=0] pmpaddr(0) > 0: any TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S056_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=TOR]  
  TST16-56 (LOWEST-PRIO)  
    [same as TST12-56(group), but with pmpcfg(i).A=TOR]
### Sub-feature: 030_fetch_L0_X1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S011_I000 feature description (Cf. Feature: "cfg NA4 access M")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F012_S011_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S061_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=TOR]  
   TST16-11 (LOW-PRIO)  
    [same as TST12-11(group), but with pmpcfg(i).A=TOR]  
     
    
  //TO COMPLETE => FTR06-b  
  TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
### Sub-feature: 031_fetch_L1_X1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S014_I000 feature description (Cf. Feature: "cfg NA4 access M")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F012_S014_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S062_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=TOR]  
  TST16-14 (LOW-PRIO)  
    [same as TST12-14(group), but with pmpcfg(i).A=TOR]  
    
    
  //TO COMPLETE => FTR06-b  
   TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
### Sub-feature: 032_load_L0_R1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S021_I000 feature description (Cf. Feature: "cfg NA4 access M")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F012_S021_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S063_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=TOR]  
   TST16-21 (HIGH-PRIO)  
    [same as TST12-21(group), but with pmpcfg(i).A=TOR]  
     
    
  //TO COMPLETE => FTR06-b  
  TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
### Sub-feature: 033_load_L1_R1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S024_I000 feature description (Cf. Feature: "cfg NA4 access M")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F012_S024_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S064_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=TOR]  
  TST16-24 (LOW-PRIO)  
    [same as TST12-24(group), but with pmpcfg(i).A=TOR]  
    
    
  //TO COMPLETE => FTR06-b  
   TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
### Sub-feature: 034_store_L0_W1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S031_I000 feature description (Cf. Feature: "cfg NA4 access M")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F012_S031_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S065_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=TOR]  
   TST16-31 (HIGH-PRIO)  
    [same as TST12-31(group), but with pmpcfg(i).A=TOR]  
     
    
  //TO COMPLETE => FTR06-b  
  TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
### Sub-feature: 035_store_L1_W1_addr_forbidden

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S034_I000 feature description (Cf. Feature: "cfg NA4 access M")  
    
  {Page 59 Volume II: RISC-V Privileged Architectures V20211203}  
  If pmpaddri−1 ≥ pmpaddri and pmpcfgi.A=TOR, then PMP entry i matches no addresses  
  If PMP entry 0’s A field is set to TOR, zero is used for the lower bound, and so it matches any address y < pmpaddr(0)
* **Verification Goals**
  
  reuse of VP_PMP_F012_S034_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=TOR  
      - [for i>0] pmpaddr(i-1) > pmpaddr(i): invalid TOR address range  
      - [for i=0] pmpaddr(0) = 0: invalid TOR address range  
      - [for j=unused] pmpaddr(j)=random: only in single entry configuration case (not in reuse case)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F016_S066_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST16-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=TOR]  
  TST16-34 (LOW-PRIO)  
    [same as TST12-34(group), but with pmpcfg(i).A=TOR]  
    
    
  //TO COMPLETE => FTR06-b  
   TST25 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) > 0  
  TST26 = same as TST15+TST16 (groups) with PMP entry (0) with pmpaddr(0) = 0  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) > 0  
      - pmpaddr(0) = 0]  
    
  //TO COMPLETE => FTR06-c  
   TST27 = same as TST23-2 but with pmpaddr(i) ≤ pmpaddr(i-1) and with pmpcfg(i) and pmpcfg(i-1) correct  
    [create scenario where PMP entry pmpcfg(i) with TOR:  
      - pmpaddr(i) ≤ pmpaddr(i-1) and PMP entry pmpcfg(i-1) correct]  
    [create scenario where PMP entry pmpcfg(0) with TOR:  
      - pmpaddr(0) >= pmpaddr(1/2/3/…)]
## Feature: cfg OFF access S/U

### Sub-feature: 000_fetch_L0_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S011_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S011_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check instruction fetch access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=OFF]  
   TST17-11 (HIGH-PRIO)  
    [same as TST11-11(group), but with pmpcfg(i).A=OFF  
    - check instruction fetch access-fault exception raised]
### Sub-feature: 001_fetch_L0_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S012_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S012_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S012_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-b  
   [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
     
    
  TST17-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=OFF]  
   TST17-12 (MEDIUM-PRIO)  
    [same as TST11-12(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 002_fetch_L0_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S013_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S013_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S013_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=OFF]  
   TST17-13 (MEDIUM-PRIO)  
    [same as TST11-13(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 003_fetch_L1_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S014_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S014_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check instruction fetch access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=OFF]  
   TST17-14 (LOW-PRIO)  
    [same as TST11-14(group), but with pmpcfg(i).A=OFF  
    - check instruction fetch access-fault exception raised]
### Sub-feature: 004_fetch_L1_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S015_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S015_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S015_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-b  
  [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
    
    
  TST17-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=OFF]  
   TST17-15 (LOW-PRIO)  
    [same as TST11-15(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 005_fetch_L1_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S016_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S016_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S016_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-1x(group)  
    [same as TST11-1x(group), but with pmpcfg(i).A=OFF]  
   TST17-16 (LOW-PRIO)  
    [same as TST11-16(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 006_load_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S021_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S021_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check load access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S021_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=OFF]  
   TST17-21 (HIGH-PRIO)  
    [same as TST11-21(group), but with pmpcfg(i).A=OFF  
    - check load access-fault exception raised]
### Sub-feature: 007_load_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S022_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S022_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S022_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
   [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST17-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=OFF]  
  TST17-22 (MEDIUM-PRIO)  
    [same as TST11-22(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 008_load_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S023_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S023_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S023_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=OFF]  
   TST17-23 (MEDIUM-PRIO)  
    [same as TST11-23(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 009_load_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S024_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S024_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check load access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S024_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=OFF]  
   TST17-24 (LOW-PRIO)  
    [same as TST11-24(group), but with pmpcfg(i).A=OFF  
    - check load access-fault exception raised]
### Sub-feature: 010_load_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S025_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S025_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S025_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST17-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=OFF]  
   TST17-25 (LOW-PRIO)  
    [same as TST11-25(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 011_load_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S026_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S026_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S026_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-2x(group)  
    [same as TST11-2x(group), but with pmpcfg(i).A=OFF]  
   TST17-26 (LOW-PRIO)  
    [same as TST11-26(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 012_store_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S031_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S031_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check store access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S031_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=OFF]  
   TST17-31 (HIGH-PRIO)  
    [same as TST11-31(group), but with pmpcfg(i).A=OFF  
    - check store access-fault exception raised]
### Sub-feature: 013_store_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S032_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S032_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S032_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
   [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST17-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=OFF]  
  TST17-32 (MEDIUM-PRIO)  
    [same as TST11-32(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 014_store_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S033_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S033_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S033_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=OFF]  
   TST17-33 (MEDIUM-PRIO)  
    [same as TST11-33(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 015_store_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S034_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S034_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check store access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S034_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=OFF]  
   TST17-34 (LOW-PRIO)  
    [same as TST11-34(group), but with pmpcfg(i).A=OFF  
    - check store access-fault exception raised]
### Sub-feature: 016_store_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S035_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S035_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S035_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST17-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=OFF]  
  TST17-35 (LOW-PRIO)  
    [same as TST11-35(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 017_store_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S036_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S036_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S036_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-3x(group)  
    [same as TST11-3x(group), but with pmpcfg(i).A=OFF]  
   TST17-36 (LOW-PRIO)  
    [same as TST11-36(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 018_load_MPP_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S041_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S041_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check load access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S041_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=OFF]  
   TST17-41 (LOWEST-PRIO)  
    [same as TST11-41(group), but with pmpcfg(i).A=OFF  
    - check load access-fault exception raised]
### Sub-feature: 019_load_MPP_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S042_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S042_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S042_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
   [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST17-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=OFF]  
  TST17-42 (LOWEST-PRIO)  
    [same as TST11-42(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 020_load_MPP_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S043_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S043_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S043_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=OFF]  
   TST17-43 (LOWEST-PRIO)  
    [same as TST11-43(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 021_load_MPP_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S044_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S044_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check load access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S044_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=OFF]  
   TST17-44 (LOWEST-PRIO)  
    [same as TST11-44(group), but with pmpcfg(i).A=OFF  
    - check load access-fault exception raised]
### Sub-feature: 022_load_MPP_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S045_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S045_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S045_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
    
  TST17-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=OFF]  
   TST17-45 (LOWEST-PRIO)  
    [same as TST11-45(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 023_load_MPP_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S046_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S046_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S046_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-4x(group)  
    [same as TST11-4x(group), but with pmpcfg(i).A=OFF]  
   TST17-46 (LOWEST-PRIO)  
    [same as TST11-46(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 024_store_MPP_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S051_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S051_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check store access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S051_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=OFF]  
   TST17-51 (LOWEST-PRIO)  
    [same as TST11-51(group), but with pmpcfg(i).A=OFF  
    - check store access-fault exception raised]
### Sub-feature: 025_store_MPP_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S052_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S052_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S052_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
   [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST17-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=OFF]  
  TST17-52 (LOWEST-PRIO)  
    [same as TST11-52(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 026_store_MPP_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S053_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S053_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S053_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e2-2 (refers to FTR09-d2-2)  
  [When the L bit is clear, the R/W/X permissions apply only to S and U modes]  
  FTR09-d2-2 (L=0 refers to FTR08-e2-2)  
   [if the privilege mode of the access is S or U (whatever L), then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=OFF]  
   TST17-53 (LOWEST-PRIO)  
    [same as TST11-53(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 027_store_MPP_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S054_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S054_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check store access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S054_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=OFF]  
   TST17-54 (LOWEST-PRIO)  
    [same as TST11-54(group), but with pmpcfg(i).A=OFF  
    - check store access-fault exception raised]
### Sub-feature: 028_store_MPP_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S055_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S055_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S055_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
    
  TST17-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=OFF]  
  TST17-55 (LOWEST-PRIO)  
    [same as TST11-55(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 029_store_MPP_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F011_S056_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F011_S056_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F017_S056_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-d  
  [PMP checks are applied to all accesses whose effective privilege mode is S or U]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
   [When the L bit is set, these permissions are enforced for all privilege modes]  
  FTR01-f (refers to FTR08-e1)  
   [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
    
  TST17-5x(group)  
    [same as TST11-5x(group), but with pmpcfg(i).A=OFF]  
   TST17-56 (LOWEST-PRIO)  
    [same as TST11-56(group), but with pmpcfg(i).A=OFF]
## Feature: cfg OFF access M

### Sub-feature: 000_fetch_L0_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S011_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S011_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=OFF]  
  TST18-11 (LOW-PRIO)  
    [same as TST12-11(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 001_fetch_L0_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S012_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S012_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S012_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=OFF]  
  TST18-12 (LOW-PRIO)  
    [same as TST12-12(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 002_fetch_L0_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S013_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S013_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S013_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=OFF]  
  TST18-13 (LOW-PRIO)  
    [same as TST12-13(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 003_fetch_L1_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S014_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S014_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check store access-fault exception raised (TODO: is M mode access prevented by A=OFF)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=OFF]  
  TST18-14 (HIGH-PRIO)  
    [same as TST12-14(group), but with pmpcfg(i).A=OFF  
    - check instruction fetch access-fault exception raised]
### Sub-feature: 004_fetch_L1_X0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S015_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S015_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S015_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-b  
  [Attempting to fetch an instruction from a PMP region that does not have execute permissions raises an instruction access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=OFF]  
  TST18-15 (MEDIUM-PRIO)  
    [same as TST12-15(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 005_fetch_L1_X1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S016_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S016_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S016_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-1x(group)  
    [same as TST12-1x(group), but with pmpcfg(i).A=OFF]  
  TST18-16 (HIGH-PRIO)  
    [same as TST12-16(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 006_load_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S021_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S021_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S021_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=OFF]  
  TST18-21 (LOW-PRIO)  
    [same as TST12-21(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 007_load_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S022_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S022_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S022_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=OFF]  
  TST18-22 (LOW-PRIO)  
    [same as TST12-22(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 008_load_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S023_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S023_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S023_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=OFF]  
  TST18-23 (LOW-PRIO)  
    [same as TST12-23(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 009_load_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S024_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S024_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check store access-fault exception raised (TODO: is M mode access prevented by A=OFF)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S024_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=OFF]  
  TST18-24 (HIGH-PRIO)  
    [same as TST12-24(group), but with pmpcfg(i).A=OFF  
    - check instruction fetch access-fault exception raised]
### Sub-feature: 010_load_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S025_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S025_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S025_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
    
  TST18-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=OFF]  
   TST18-25 (MEDIUM-PRIO)  
    [same as TST12-25(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 011_load_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S026_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S026_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S026_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-2x(group)  
    [same as TST12-2x(group), but with pmpcfg(i).A=OFF]  
  TST18-26 (HIGH-PRIO)  
    [same as TST12-26(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 012_store_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S031_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S031_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S031_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=OFF]  
  TST18-31 (LOW-PRIO)  
    [same as TST12-31(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 013_store_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S032_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S032_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S032_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=OFF]  
  TST18-32 (LOW-PRIO)  
    [same as TST12-32(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 014_store_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S033_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S033_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S033_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=OFF]  
  TST18-33 (LOW-PRIO)  
    [same as TST12-33(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 015_store_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S034_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S034_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check store access-fault exception raised (TODO: is M mode access prevented by A=OFF)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S034_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=OFF]  
  TST18-34 (HIGH-PRIO)  
    [same as TST12-34(group), but with pmpcfg(i).A=OFF  
    - check instruction fetch access-fault exception raised]
### Sub-feature: 016_store_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S035_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S035_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S035_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  FTR02-b1  
   [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=OFF]  
  TST18-35 (MEDIUM-PRIO)  
    [same as TST12-35(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 017_store_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S036_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S036_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S036_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-3x(group)  
    [same as TST12-3x(group), but with pmpcfg(i).A=OFF]  
  TST18-36 (HIGH-PRIO)  
    [same as TST12-36(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 018_load_MPP_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S041_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S041_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S041_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=OFF]  
  TST18-41 (LOWEST-PRIO)  
    [same as TST12-41(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 019_load_MPP_L0_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S042_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S042_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S042_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=OFF]  
  TST18-42 (LOWEST-PRIO)  
    [same as TST12-42(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 020_load_MPP_L0_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S043_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S043_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S043_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=OFF]  
  TST18-43 (LOWEST-PRIO)  
    [same as TST12-43(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 021_load_MPP_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S044_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S044_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check store access-fault exception raised (TODO: is M mode access prevented by A=OFF)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S044_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=OFF]  
  TST18-44 (LOWEST-PRIO)  
    [same as TST12-44(group), but with pmpcfg(i).A=OFF  
    - check instruction fetch access-fault exception raised]
### Sub-feature: 022_load_MPP_L1_R0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S045_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S045_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S045_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-c  
  [Attempting to execute a load or load-reserved instruction which accesses a physical address within a PMP region without read permissions raises a load access-fault exception]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
     
    
  TST18-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=OFF]  
   TST18-45 (LOWEST-PRIO)  
    [same as TST12-45(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 023_load_MPP_L1_R1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S046_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S046_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S046_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-4x(group)  
    [same as TST12-4x(group), but with pmpcfg(i).A=OFF]  
  TST18-46 (LOWEST-PRIO)  
    [same as TST12-46(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 024_store_MPP_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S051_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S051_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S051_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=OFF]  
  TST18-51 (LOWEST-PRIO)  
    [same as TST12-51(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 025_store_MPP_L0_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S052_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S052_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S052_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=OFF]  
  TST18-52 (LOWEST-PRIO)  
    [same as TST12-52(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 026_store_MPP_L0_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S053_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S053_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S053_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e2-1 (refers to  FTR09-d1)  
  [When the L bit is clear, any M-mode access matching the PMP entry will succeed]  
  FTR09-d1 (refers to FTR08-e2-1)  
   [If the L bit is clear and the privilege mode of the access is M, the access succeeds]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=OFF]  
  TST18-53 (LOWEST-PRIO)  
    [same as TST12-53(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 027_store_MPP_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S054_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S054_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range  
    
  CHECK UPDATE  
    - check store access-fault exception raised (TODO: is M mode access prevented by A=OFF)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S054_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=OFF]  
  TST18-54 (LOWEST-PRIO)  
    [same as TST12-54(group), but with pmpcfg(i).A=OFF  
    - check instruction fetch access-fault exception raised]
### Sub-feature: 028_store_MPP_L1_W0_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S055_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S055_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S055_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR04-d  
  [Attempting to execute a store, store-conditional, or AMO instruction which accesses a physical address within a PMP region without write permissions raises a store access-fault exception]  
    
  FTR02-b1  
   [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=OFF]  
  TST18-55 (LOWEST-PRIO)  
    [same as TST12-55(group), but with pmpcfg(i).A=OFF]
### Sub-feature: 029_store_MPP_L1_W1_addr_miss

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F012_S056_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F012_S056_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - pmpcfg(i): A=OFF  
      - pmpaddr(i): NA4 address range
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F018_S056_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  FTR01-f (refers to FTR08-e1)  
  [PMP checks may additionally apply to M-mode accesses, in which case the PMP registers themselves are locked, so that even M-mode software cannot change them until the hart is reset]  
     
  FTR08-e1 (refers to FTR01-f) (refers to FTR09-d2-1)  
  [When the L bit is set, these permissions are enforced for all privilege modes]  
   FTR09-d2-1 (refers to FTR08-e1) (refers to FTR01-f)  
  [if the L bit is set, then the access succeeds only if the R, W, or X bit corresponding to the access type is set]  
    
  FTR02-b1  
  [the lowest-numbered PMP CSRs must be implemented first (QUESTION: does it mean programmed first)]  
    
    
  TST18-5x(group)  
    [same as TST12-5x(group), but with pmpcfg(i).A=OFF]  
  TST18-56 (LOWEST-PRIO)  
    [same as TST12-56(group), but with pmpcfg(i).A=OFF]
## Feature: cfg NA4 not selectable

### Sub-feature: 000_fetch_L0_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S011_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S011_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check instruction fetch access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 001_fetch_L1_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S014_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S014_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check instruction fetch access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 002_load_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S021_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S021_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check load access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S021_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 003_load_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S024_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S024_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check load access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S024_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 004_store_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S031_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S031_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check store access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S031_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 005_store_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S034_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S034_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check store access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S034_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 006_load_MPP_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S041_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S041_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check load access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S041_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 007_load_MPP_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S044_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S044_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check load access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S044_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 008_store_MPP_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S051_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S051_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check store access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S051_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 009_store_MPP_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S054_I000 feature description (Cf. Feature: "cfg NA4 access S/U")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S054_I000 verification goals (Cf. Feature: "cfg NA4 access S/U")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check store access-fault exception raised
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S054_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 010_fetch_L0_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S011_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S011_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S011_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 011_fetch_L1_X1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S014_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S014_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check store access-fault exception raised (TODO: is M mode access prevented by A=OFF)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S014_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 012_load_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S021_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S021_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S021_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 013_load_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S024_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S024_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check store access-fault exception raised (TODO: is M mode access prevented by A=OFF)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S024_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 014_store_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S031_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S031_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S031_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 015_store_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S034_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S034_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check store access-fault exception raised (TODO: is M mode access prevented by A=OFF)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S034_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 016_load_MPP_L0_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S041_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S041_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S041_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 017_load_MPP_L1_R1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S044_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S044_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check store access-fault exception raised (TODO: is M mode access prevented by A=OFF)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S044_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 018_store_MPP_L0_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S051_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S051_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S051_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 019_store_MPP_L1_W1_addr_hit

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of VP_PMP_F019_S054_I000 feature description (Cf. Feature: "cfg NA4 access M")
* **Verification Goals**
  
  reuse of VP_PMP_F019_S054_I000 verification goals (Cf. Feature: "cfg NA4 access M")  
    
  CONFIGURATION  
      - check that pmpcfg(i).A=OFF (by reading back)  
    
  CHECK UPDATE  
    - check store access-fault exception raised (TODO: is M mode access prevented by A=OFF)
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F019_S054_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
## Feature: multi entries NA4

### Sub-feature: 000_1_entry

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose a single PMP entry  
    
  CONFIGURATION and ACCESS  
      - for each pmp entry, apply any CONFIGURATION+ACCESS scenario above (Cf. Feature: "cfg NA4 access S/U/M")  
      - make sure the pmp entries address ranges are not overlapping/intersecting  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, we should obtain the expected CHECK result  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F021_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST21(group)  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST21-1 = extension of (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          TST11-13, TST11-23, TST11-33, TST11-43, TST11-53,  
                          TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          TST11-16, TST11-26, TST11-36, TST11-46, TST11-56,  
                          TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          TST12-13, TST12-23, TST12-33, TST12-43, TST12-53,  
                          TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                          TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                          TST12-16, TST12-26, TST12-36, TST12-46, TST12-56)  
  [configure only one (any, but the first one) PMP entry  
    - use A=NA4 for the PMP entry configuration  
    - execute the chosen kind of access  
    - should be same result]
### Sub-feature: 001_2_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  reuse of VP_PMP_F021_S001_I000 feature description (Cf. Feature: "multi entries NA4")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** ENV Capability
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F021_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST21(group)  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST21-2 = extension of compatible pair of (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          									 TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          									 TST11-13, TST11-23, TST11-33, TST11-43, TST11-53,  
                          									 TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          				 					 TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          				 					 TST11-16, TST11-26, TST11-36, TST11-46, TST11-56,  
                          									 TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          									 TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          									 TST12-13, TST12-23, TST12-33, TST12-43, TST12-53,  
                          									 TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                          									 TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                          				 					 TST12-16, TST12-26, TST12-36, TST12-46, TST12-56)  
  [configure 2 non-adjacent PMP entries (highest-numbered ones first) (avoid the first PMP entry)  
    - use A=NA4 for each PMP entry configuration  
    - execute the 2 kinds of accesses (if possible to chain due to potential access-fault exception)  
    - should be same 2 results]
### Sub-feature: 002_N_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any N PMP entries (2<N<8)  
    
  reuse of VP_PMP_F021_S001_I000 feature description (Cf. Feature: "multi entries NA4")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F021_S003_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST21(group)  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST21-3 = extension of compatible group(N) of (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          				 							 TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          											 TST11-13, TST11-23, TST11-33, TST11-43, TST11-53,  
                          									 		 TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          				 							 TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          											 TST11-16, TST11-26, TST11-36, TST11-46, TST11-56,  
                          									 		 TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          				 							 TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          											 TST12-13, TST12-23, TST12-33, TST12-43, TST12-53,  
                          									 		 TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                          				 							 TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                          											 TST12-16, TST12-26, TST12-36, TST12-46, TST12-56)  
  [configure N PMP entries (highest-numbered ones first) (as non-adjacent as possible, and avoid the first PMP entry)  
    - use A=NA4 for each PMP entry configuration  
    - execute the N kinds of accesses (if possible to chain due to potential access-fault exception)  
    - should be same N results]
### Sub-feature: 003_8_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose all 8 PMP entries  
    
  reuse of VP_PMP_F021_S001_I000 feature description (Cf. Feature: "multi entries NA4")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F021_S004_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST21(group)  
    [create scenarios where PMP entries with A=2 (NA4) and with/without matching permissions  
      - check only NA4 defined addresses are matching]  
  TST21-4 = extension of compatible group(8) of (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          				 							 TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          											 TST11-13, TST11-23, TST11-33, TST11-43, TST11-53,  
                          									 		 TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          				 							 TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          											 TST11-16, TST11-26, TST11-36, TST11-46, TST11-56,  
                          									 		 TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          				 							 TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          											 TST12-13, TST12-23, TST12-33, TST12-43, TST12-53,  
                          									 		 TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                          				 							 TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                          											 TST12-16, TST12-26, TST12-36, TST12-46, TST12-56)  
  [configure 8 PMP entries (highest-numbered ones first)  
    - use A=NA4 for each PMP entry configuration  
    - execute the 8 kinds of accesses (if possible to chain due to potential access-fault exception)  
    - should be same 8 results]
### Sub-feature: 004_2_intersecting_entries_fail

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  CONFIGURATION and ACCESS (Cf. Feature: "cfg NA4 access S/U/M")  
      - for the least-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario with access-fault  
      - for the highest-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario without access-fault  
      - make sure the pmp entries address ranges are overlapping/intersecting (at least at 4 consecutive bytes)  
      - for each pmp entry, execute one access in its associated pmp address region but outside the overlapping/intersecting address range  
      - execute one additional access inside the overlapping/intersecting address range  
      - NB: obviously, pmp entry configurations with different access-modes (S/U vs. M) cannot be easily mixed in same test  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, access outside the overlapping/intersecting address range should give the expected CHECK result  
      - access inside the overlapping/intersecting address range should generate the access-type related access-fault  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** ENV Capability
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F021_S005_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST51(group) => FTR09-a, FTR09-b and FTR09-c  
    [create scenarios where 2 PMP entries with same pmpaddr  
      - one without matching permissions or with A=OFF  
      - one with matching permissions and A=NA4/NAPOT/TOR  
      - any of them can be the lowest-numbered PMP entry]  
  TST51-1  
  [configure 2 PMP entries  
    - configure the lowest-numbered PMP entry with  (TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          				 					 				 TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          									 				 TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          									 				 TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                                                     TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          									 				 TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          				 					 				 TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          									 				 TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                                                     TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          									 				 TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          									 				 TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          									 				 TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                                                     TST17-12, TST17-22, TST17-32, TST17-42, TST17-52,  
                          				 					 				 TST17-15, TST17-25, TST17-35, TST17-45, TST17-55,  
                          									 				 TST18-12, TST18-22, TST18-32, TST18-42, TST18-52,  
                          									 				 TST18-15, TST18-25, TST18-35, TST18-45, TST18-55)  
    - configure the highest-numbered PMP entry with  (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          									 				  TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          				 					 				  TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          									 				  TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                                                      TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          									 					TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          									 				 	TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          									 					TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                                                      TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          				 					 				  TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          									 				  TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          									 				  TST16-14, TST16-24, TST16-34, TST16-44, TST16-54)  
    - execute the associated access  
    - check associated access-fault exception raised]
### Sub-feature: 005_2_intersecting_entries_succeed

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  CONFIGURATION and ACCESS (Cf. Feature: "cfg NA4 access S/U/M")  
      - for the least-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario without access-fault  
      - for the highest-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario with access-fault  
      - make sure the pmp entries address ranges are overlapping/intersecting (at least at 4 consecutive bytes)  
      - for each pmp entry, execute one access in its associated pmp address region but outside the overlapping/intersecting address range  
      - execute one additional access inside the overlapping/intersecting address range  
      - NB: obviously, pmp entry configurations with different access-modes (S/U vs. M) cannot be easily mixed in same test  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, access outside the overlapping/intersecting address range should give the expected CHECK result  
      - access inside the overlapping/intersecting address range should not generate any access-fault  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** ENV Capability
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F021_S006_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST51(group) => FTR09-a, FTR09-b and FTR09-c  
    [create scenarios where 2 PMP entries with same pmpaddr  
      - one without matching permissions or with A=OFF  
      - one with matching permissions and A=NA4/NAPOT/TOR  
      - any of them can be the lowest-numbered PMP entry]  
  TST51-2  
  [configure 2 PMP entries  
    - configure the lowest-numbered PMP entry with  (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          				 					 				 TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          									 				 TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          									 				 TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                                                     TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          									 				 TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          				 					 				 TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          									 				 TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                                                     TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          									 				 TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          									 				 TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          									 				 TST16-14, TST16-24, TST16-34, TST16-44, TST16-54)  
    - configure the highest-numbered PMP entry with  (TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          				 					 				  TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          									 				  TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          									 				  TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                                                      TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          									 				  TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          									 				  TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          									 				  TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                                                      TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          									 				  TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          									 				  TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          									 				  TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                                                      TST17-12, TST17-22, TST17-32, TST17-42, TST17-52,  
                          									 				  TST17-15, TST17-25, TST17-35, TST17-45, TST17-55,  
                          									 				  TST18-12, TST18-22, TST18-32, TST18-42, TST18-52,  
                          				 					 				  TST18-15, TST18-25, TST18-35, TST18-45, TST18-55)  
    - execute the associated access  
    - check no access-fault exception]
## Feature: multi entries NAPOT

### Sub-feature: 000_1_entry

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose a single PMP entry  
    
  CONFIGURATION and ACCESS  
      - for each pmp entry, apply any CONFIGURATION+ACCESS scenario above (Cf. Feature: "cfg NAPOT access S/U/M")  
      - make sure the pmp entries address ranges are not overlapping/intersecting  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, we should obtain the expected CHECK result  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F022_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST22(group)  
    [create scenarios where PMP entries with A=3 (NAPOT) and with/without matching permissions  
      - check only NAPOT defined addresses are matching]  
  TST22-1 = extension of (TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          TST13-13, TST13-23, TST13-33, TST13-43, TST13-53,  
                          TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          TST13-16, TST13-26, TST13-36, TST13-46, TST13-56,  
                          TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          TST14-13, TST14-23, TST14-33, TST14-43, TST14-53,  
                          TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                          TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                          TST14-16, TST14-26, TST14-36, TST14-46, TST14-56)  
  [configure only one (any, but the first one) PMP entry  
    - use A=NAPOT for the PMP entry configuration  
    - execute the chosen kind of access  
    - should be same result]
### Sub-feature: 001_2_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  reuse of VP_PMP_F022_S001_I000 feature description (Cf. Feature: "multi entries NAPOT")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F022_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST22(group)  
    [create scenarios where PMP entries with A=3 (NAPOT) and with/without matching permissions  
      - check only NAPOT defined addresses are matching]  
  TST22-2 = extension of compatible pair of (TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          									 TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          									 TST13-13, TST13-23, TST13-33, TST13-43, TST13-53,  
                          									 TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          									 TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          				 					 TST13-16, TST13-26, TST13-36, TST13-46, TST13-56,  
                          									 TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          				 					 TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          									 TST14-13, TST14-23, TST14-33, TST14-43, TST14-53,  
                          									 TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                          									 TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                          									 TST14-16, TST14-26, TST14-36, TST14-46, TST14-56)  
   [configure 2 non-adjacent PMP entries (highest-numbered ones first) (avoid the first PMP entry)  
    - use A=NAPOT for each PMP entry configuration  
    - execute the 2 kinds of accesses (if possible to chain due to potential access-fault exception)  
    - should be same 2 results]
### Sub-feature: 002_N_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any N PMP entries (2<N<8)  
    
  reuse of VP_PMP_F022_S001_I000 feature description (Cf. Feature: "multi entries NAPOT")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F022_S003_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST22(group)  
    [create scenarios where PMP entries with A=3 (NAPOT) and with/without matching permissions  
      - check only NAPOT defined addresses are matching]  
  TST22-3 = extension of compatible group(N) of (TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          				 							 TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          											 TST13-13, TST13-23, TST13-33, TST13-43, TST13-53,  
                          				 							 TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          				 							 TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          											 TST13-16, TST13-26, TST13-36, TST13-46, TST13-56,  
                          				 							 TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          				 							 TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          											 TST14-13, TST14-23, TST14-33, TST14-43, TST14-53,  
                          				 							 TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                          				 							 TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                          											 TST14-16, TST14-26, TST14-36, TST14-46, TST14-56)  
  [configure N PMP entries (highest-numbered ones first) (as non-adjacent as possible, and avoid the first PMP entry)  
    - use A=NAPOT for each PMP entry configuration  
    - execute the N kinds of accesses (if possible to chain due to potential access-fault exception)  
    - should be same N results]
### Sub-feature: 003_8_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose all 8 PMP entries  
    
  reuse of VP_PMP_F022_S001_I000 feature description (Cf. Feature: "multi entries NAPOT")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Testcase
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F022_S004_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST22(group)  
    [create scenarios where PMP entries with A=3 (NAPOT) and with/without matching permissions  
      - check only NAPOT defined addresses are matching]  
  TST22-4 = extension of compatible group(8) of (TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          				 							 TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          											 TST13-13, TST13-23, TST13-33, TST13-43, TST13-53,  
                          				 							 TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          				 							 TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          											 TST13-16, TST13-26, TST13-36, TST13-46, TST13-56,  
                          				 							 TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          				 							 TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          											 TST14-13, TST14-23, TST14-33, TST14-43, TST14-53,  
                          				 							 TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                          				 							 TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                          											 TST14-16, TST14-26, TST14-36, TST14-46, TST14-56)  
  [configure 8 PMP entries (highest-numbered ones first)  
    - use A=NAPOT for each PMP entry configuration  
    - execute the 8 kinds of accesses (if possible to chain due to potential access-fault exception)  
    - should be same 8 results]
### Sub-feature: 004_2_intersecting_entries_fail

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  CONFIGURATION and ACCESS (Cf. Feature: "cfg NAPOT access S/U/M")  
      - for the least-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario with access-fault  
      - for the highest-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario without access-fault  
      - make sure the pmp entries address ranges are overlapping/intersecting (at least at 4 consecutive bytes)  
      - for each pmp entry, execute one access in its associated pmp address region but outside the overlapping/intersecting address range  
      - execute one additional access inside the overlapping/intersecting address range  
      - NB: obviously, pmp entry configurations with different access-modes (S/U vs. M) cannot be easily mixed in same test  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, access outside the overlapping/intersecting address range should give the expected CHECK result  
      - access inside the overlapping/intersecting address range should generate the access-type related access-fault  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** ENV Capability
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F022_S005_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST51(group) => FTR09-a, FTR09-b and FTR09-c  
    [create scenarios where 2 PMP entries with same pmpaddr  
      - one without matching permissions or with A=OFF  
      - one with matching permissions and A=NA4/NAPOT/TOR  
      - any of them can be the lowest-numbered PMP entry]  
  TST51-1  
  [configure 2 PMP entries  
    - configure the lowest-numbered PMP entry with  (TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          				 					 				 TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          									 				 TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          									 				 TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                                                     TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          									 				 TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          				 					 				 TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          									 				 TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                                                     TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          									 				 TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          									 				 TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          									 				 TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                                                     TST17-12, TST17-22, TST17-32, TST17-42, TST17-52,  
                          				 					 				 TST17-15, TST17-25, TST17-35, TST17-45, TST17-55,  
                          									 				 TST18-12, TST18-22, TST18-32, TST18-42, TST18-52,  
                          									 				 TST18-15, TST18-25, TST18-35, TST18-45, TST18-55)  
    - configure the highest-numbered PMP entry with  (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          									 				  TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          				 					 				  TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          									 				  TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                                                      TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          									 					TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          									 				 	TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          									 					TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                                                      TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          				 					 				  TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          									 				  TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          									 				  TST16-14, TST16-24, TST16-34, TST16-44, TST16-54)  
    - execute the associated access  
    - check associated access-fault exception raised]
### Sub-feature: 005_2_intersecting_entries_succeed

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  CONFIGURATION and ACCESS (Cf. Feature: "cfg NAPOT access S/U/M")  
      - for the least-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario without access-fault  
      - for the highest-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario with access-fault  
      - make sure the pmp entries address ranges are overlapping/intersecting (at least at 4 consecutive bytes)  
      - for each pmp entry, execute one access in its associated pmp address region but outside the overlapping/intersecting address range  
      - execute one additional access inside the overlapping/intersecting address range  
      - NB: obviously, pmp entry configurations with different access-modes (S/U vs. M) cannot be easily mixed in same test  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, access outside the overlapping/intersecting address range should give the expected CHECK result  
      - access inside the overlapping/intersecting address range should not generate any access-fault  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** ENV Capability
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F022_S006_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST51(group) => FTR09-a, FTR09-b and FTR09-c  
    [create scenarios where 2 PMP entries with same pmpaddr  
      - one without matching permissions or with A=OFF  
      - one with matching permissions and A=NA4/NAPOT/TOR  
      - any of them can be the lowest-numbered PMP entry]  
  TST51-2  
  [configure 2 PMP entries  
    - configure the lowest-numbered PMP entry with  (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          				 					 				 TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          									 				 TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          									 				 TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                                                     TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          									 				 TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          				 					 				 TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          									 				 TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                                                     TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          									 				 TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          									 				 TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          									 				 TST16-14, TST16-24, TST16-34, TST16-44, TST16-54)  
    - configure the highest-numbered PMP entry with  (TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          				 					 				  TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          									 				  TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          									 				  TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                                                      TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          									 				  TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          									 				  TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          									 				  TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                                                      TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          									 				  TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          									 				  TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          									 				  TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                                                      TST17-12, TST17-22, TST17-32, TST17-42, TST17-52,  
                          									 				  TST17-15, TST17-25, TST17-35, TST17-45, TST17-55,  
                          									 				  TST18-12, TST18-22, TST18-32, TST18-42, TST18-52,  
                          				 					 				  TST18-15, TST18-25, TST18-35, TST18-45, TST18-55)  
    - execute the associated access  
    - check no access-fault exception]
## Feature: multi entries TOR

### Sub-feature: 000_1_entry

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose a single PMP entry  
    
  CONFIGURATION and ACCESS  
      - for each pmp entry, apply any CONFIGURATION+ACCESS scenario above (Cf. Feature: "cfg TOR access S/U/M")  
      - make sure the pmp entries address ranges are not overlapping/intersecting  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, we should obtain the expected CHECK result  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F023_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST23(group) =>   
    [create scenarios where PMP entries with A=1 (TOR) and with/without matching permissions  
      - pmpaddr(i−1) < pmpaddr(i), pmpcfg(i).A=TOR and pmpcfg(i-1) with/without matching permissions  
      - check only TOR defined addresses are matching]  
  TST23-1 = extension of (TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          TST15-13, TST15-23, TST15-33, TST15-43, TST15-53,  
                          TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          TST15-16, TST15-26, TST15-36, TST15-46, TST15-56,  
                          TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          TST16-13, TST16-23, TST16-33, TST16-43, TST16-53,  
                          TST16-14, TST16-24, TST16-34, TST16-44, TST16-54,  
                          TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                          TST16-16, TST16-26, TST16-36, TST16-46, TST16-56)  
   [configure only one (any, but the first one) PMP entry  
    - execute the chosen kind of access  
    - should be same result]
### Sub-feature: 001_2_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  reuse of VP_PMP_F023_S001_I000 feature description (Cf. Feature: "multi entries TOR")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F023_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST23(group) =>   
    [create scenarios where PMP entries with A=1 (TOR) and with/without matching permissions  
      - pmpaddr(i−1) < pmpaddr(i), pmpcfg(i).A=TOR and pmpcfg(i-1) with/without matching permissions  
      - check only TOR defined addresses are matching]  
  TST23-2 = extension of compatible pair of (TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          									 TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          									 TST15-13, TST15-23, TST15-33, TST15-43, TST15-53,  
                          				 					 TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          									 TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          									 TST15-16, TST15-26, TST15-36, TST15-46, TST15-56,  
                          									 TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          				 					 TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          									 TST16-13, TST16-23, TST16-33, TST16-43, TST16-53,  
                          									 TST16-14, TST16-24, TST16-34, TST16-44, TST16-54,  
                          				 					 TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                          									 TST16-16, TST16-26, TST16-36, TST16-46, TST16-56)  
   [configure 2 non-adjacent PMP entries (highest-numbered ones first) (avoid the first PMP entry)  
    - execute the 2 kinds of accesses (if possible to chain due to potential access-fault exception)  
    - should be same 2 results]
### Sub-feature: 002_N_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any N PMP entries (2<N<8)  
    
  reuse of VP_PMP_F023_S001_I000 feature description (Cf. Feature: "multi entries TOR")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F023_S003_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST23(group) =>   
    [create scenarios where PMP entries with A=1 (TOR) and with/without matching permissions  
      - pmpaddr(i−1) < pmpaddr(i), pmpcfg(i).A=TOR and pmpcfg(i-1) with/without matching permissions  
      - check only TOR defined addresses are matching]  
  TST23-3 = extension of compatible group(N) of (TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          											 TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          											 TST15-13, TST15-23, TST15-33, TST15-43, TST15-53,  
                          				 					 		 TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          											 TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          											 TST15-16, TST15-26, TST15-36, TST15-46, TST15-56,  
                          				 					 		 TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          											 TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          											 TST16-13, TST16-23, TST16-33, TST16-43, TST16-53,  
                          				 					 		 TST16-14, TST16-24, TST16-34, TST16-44, TST16-54,  
                          											 TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                          											 TST16-16, TST16-26, TST16-36, TST16-46, TST16-56)  
  [configure N PMP entries (highest-numbered ones first) (as non-adjacent as possible, and avoid the first PMP entry)  
    - execute the N kinds of accesses (if possible to chain due to potential access-fault exception)  
    - should be same N results]
### Sub-feature: 003_8_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose all 8 PMP entries  
    
  reuse of VP_PMP_F023_S001_I000 feature description (Cf. Feature: "multi entries TOR")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F023_S004_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST23(group) =>   
    [create scenarios where PMP entries with A=1 (TOR) and with/without matching permissions  
      - pmpaddr(i−1) < pmpaddr(i), pmpcfg(i).A=TOR and pmpcfg(i-1) with/without matching permissions  
      - check only TOR defined addresses are matching]  
  TST23-4 = extension of compatible group(8) of (TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          											 TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          											 TST15-13, TST15-23, TST15-33, TST15-43, TST15-53,  
                          				 					 		 TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          											 TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          											 TST15-16, TST15-26, TST15-36, TST15-46, TST15-56,  
                          				 					 		 TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          											 TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          											 TST16-13, TST16-23, TST16-33, TST16-43, TST16-53,  
                          				 					 		 TST16-14, TST16-24, TST16-34, TST16-44, TST16-54,  
                          											 TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                          											 TST16-16, TST16-26, TST16-36, TST16-46, TST16-56)  
  [configure 8 PMP entries (highest-numbered ones first)  
    - execute the 8 kinds of accesses (if possible to chain due to potential access-fault exception)  
    - should be same 8 results]
### Sub-feature: 004_2_intersecting_entries_fail

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  CONFIGURATION and ACCESS (Cf. Feature: "cfg TOR access S/U/M")  
      - for the least-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario with access-fault  
      - for the highest-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario without access-fault  
      - make sure the pmp entries address ranges are overlapping/intersecting (at least at 4 consecutive bytes)  
      - for each pmp entry, execute one access in its associated pmp address region but outside the overlapping/intersecting address range  
      - execute one additional access inside the overlapping/intersecting address range  
      - NB: obviously, pmp entry configurations with different access-modes (S/U vs. M) cannot be easily mixed in same test  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, access outside the overlapping/intersecting address range should give the expected CHECK result  
      - access inside the overlapping/intersecting address range should generate the access-type related access-fault  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** ENV Capability
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F023_S005_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST51(group) => FTR09-a, FTR09-b and FTR09-c  
    [create scenarios where 2 PMP entries with same pmpaddr  
      - one without matching permissions or with A=OFF  
      - one with matching permissions and A=NA4/NAPOT/TOR  
      - any of them can be the lowest-numbered PMP entry]  
  TST51-1  
  [configure 2 PMP entries  
    - configure the lowest-numbered PMP entry with  (TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          				 					 				 TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          									 				 TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          									 				 TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                                                     TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          									 				 TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          				 					 				 TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          									 				 TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                                                     TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          									 				 TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          									 				 TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          									 				 TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                                                     TST17-12, TST17-22, TST17-32, TST17-42, TST17-52,  
                          				 					 				 TST17-15, TST17-25, TST17-35, TST17-45, TST17-55,  
                          									 				 TST18-12, TST18-22, TST18-32, TST18-42, TST18-52,  
                          									 				 TST18-15, TST18-25, TST18-35, TST18-45, TST18-55)  
    - configure the highest-numbered PMP entry with  (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          									 				  TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          				 					 				  TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          									 				  TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                                                      TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          									 					TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          									 				 	TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          									 					TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                                                      TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          				 					 				  TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          									 				  TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          									 				  TST16-14, TST16-24, TST16-34, TST16-44, TST16-54)  
    - execute the associated access  
    - check associated access-fault exception raised]
### Sub-feature: 005_2_intersecting_entries_succeed

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  CONFIGURATION and ACCESS (Cf. Feature: "cfg TOR access S/U/M")  
      - for the least-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario without access-fault  
      - for the highest-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario with access-fault  
      - make sure the pmp entries address ranges are overlapping/intersecting (at least at 4 consecutive bytes)  
      - for each pmp entry, execute one access in its associated pmp address region but outside the overlapping/intersecting address range  
      - execute one additional access inside the overlapping/intersecting address range  
      - NB: obviously, pmp entry configurations with different access-modes (S/U vs. M) cannot be easily mixed in same test  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, access outside the overlapping/intersecting address range should give the expected CHECK result  
      - access inside the overlapping/intersecting address range should not generate any access-fault  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** ENV Capability
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F023_S006_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST51(group) => FTR09-a, FTR09-b and FTR09-c  
    [create scenarios where 2 PMP entries with same pmpaddr  
      - one without matching permissions or with A=OFF  
      - one with matching permissions and A=NA4/NAPOT/TOR  
      - any of them can be the lowest-numbered PMP entry]  
  TST51-2  
  [configure 2 PMP entries  
    - configure the lowest-numbered PMP entry with  (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          				 					 				 TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          									 				 TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          									 				 TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                                                     TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          									 				 TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          				 					 				 TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          									 				 TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                                                     TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          									 				 TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          									 				 TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          									 				 TST16-14, TST16-24, TST16-34, TST16-44, TST16-54)  
    - configure the highest-numbered PMP entry with  (TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          				 					 				  TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          									 				  TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          									 				  TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                                                      TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          									 				  TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          									 				  TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          									 				  TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                                                      TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          									 				  TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          									 				  TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          									 				  TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                                                      TST17-12, TST17-22, TST17-32, TST17-42, TST17-52,  
                          									 				  TST17-15, TST17-25, TST17-35, TST17-45, TST17-55,  
                          									 				  TST18-12, TST18-22, TST18-32, TST18-42, TST18-52,  
                          				 					 				  TST18-15, TST18-25, TST18-35, TST18-45, TST18-55)  
    - execute the associated access  
    - check no access-fault exception]
## Feature: multi entries OFF

### Sub-feature: 000_1_entry

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose a single PMP entry  
    
  CONFIGURATION and ACCESS  
      - for each pmp entry, apply any CONFIGURATION+ACCESS scenario above (Cf. Feature: "cfg OFF access S/U/M")  
      - make sure the pmp entries address ranges are not overlapping/intersecting  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, we should obtain the expected CHECK result  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F024_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST24(group) => FTR09-g  
    [create scenarios where PMP entries with A=0 (OFF) and with matching permissions  
      - check no address matching for those PMP entries]  
    [create scenarios where all PMP entries with A=0 (OFF) and with matching permissions  
      - check no address matching for all PMP entries]  
    [check S or U mode access fails when all A=OFF with at least one PMP entry implemented] => FTR09-g  
  TST24-1 = extension of (TST17-11, TST17-21, TST17-31, TST17-41, TST17-51,  
                          TST17-13, TST17-23, TST17-33, TST17-43, TST17-53,  
                          TST17-14, TST17-24, TST17-34, TST17-44, TST17-54,  
                          TST17-16, TST17-26, TST17-36, TST17-46, TST17-56,  
                          TST18-14, TST18-24, TST18-34, TST18-44, TST18-54, //TODO: M-mode may not raise an exception  
                          TST18-16, TST18-26, TST18-36, TST18-46, TST18-56) //TODO: M-mode may not raise an exception  
                          //TODO: SHOULD WE ADD (TST18-11, TST18-21, TST18-31, TST18-41, TST18-51,  
                                                 TST18-13, TST18-23, TST18-33, TST18-43, TST18-53) ?  
  [configure only one (any, but the first one) PMP entry  
    - execute the chosen kind of access  
    - check appropriate access-fault exception raised]
### Sub-feature: 001_2_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  reuse of VP_PMP_F024_S001_I000 feature description (Cf. Feature: "multi entries OFF")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F024_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST24(group) => FTR09-g  
    [create scenarios where PMP entries with A=0 (OFF) and with matching permissions  
      - check no address matching for those PMP entries]  
    [create scenarios where all PMP entries with A=0 (OFF) and with matching permissions  
      - check no address matching for all PMP entries]  
    [check S or U mode access fails when all A=OFF with at least one PMP entry implemented] => FTR09-g  
  TST24-2 = extension of compatible pair of (TST17-11, TST17-21, TST17-31, TST17-41, TST17-51,  
                           									 TST17-13, TST17-23, TST17-33, TST17-43, TST17-53,  
                           									 TST17-14, TST17-24, TST17-34, TST17-44, TST17-54,  
                           								 	 TST17-16, TST17-26, TST17-36, TST17-46, TST17-56,  
                           									 TST18-14, TST18-24, TST18-34, TST18-44, TST18-54, //TODO: M-mode may not raise an exception  
                           		 							 TST18-16, TST18-26, TST18-36, TST18-46, TST18-56) //TODO: M-mode may not raise an exception  
                          //TODO: SHOULD WE ADD (TST18-11, TST18-21, TST18-31, TST18-41, TST18-51,  
                                                 TST18-13, TST18-23, TST18-33, TST18-43, TST18-53) ?  
  [configure 2 non-adjacent PMP entries (highest-numbered ones first) (avoid the first PMP entry)  
    - execute the 2 kinds of accesses (if possible to chain due to access-fault)  
    - check 2 appropriate access-fault exceptions raised]
### Sub-feature: 002_N_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any N PMP entries (2<N<8)  
    
  reuse of VP_PMP_F024_S001_I000 feature description (Cf. Feature: "multi entries OFF")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F024_S003_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST24(group) => FTR09-g  
    [create scenarios where PMP entries with A=0 (OFF) and with matching permissions  
      - check no address matching for those PMP entries]  
    [create scenarios where all PMP entries with A=0 (OFF) and with matching permissions  
      - check no address matching for all PMP entries]  
    [check S or U mode access fails when all A=OFF with at least one PMP entry implemented] => FTR09-g  
  TST24-3 = extension of compatible group(N) of (TST17-11, TST17-21, TST17-31, TST17-41, TST17-51,  
                            										 TST17-13, TST17-23, TST17-33, TST17-43, TST17-53,  
                            										 TST17-14, TST17-24, TST17-34, TST17-44, TST17-54,  
                            								 		 TST17-16, TST17-26, TST17-36, TST17-46, TST17-56,  
                            										 TST18-14, TST18-24, TST18-34, TST18-44, TST18-54, //TODO: M-mode may not raise an exception  
                            										 TST18-16, TST18-26, TST18-36, TST18-46, TST18-56) //TODO: M-mode may not raise an exception  
                          //TODO: SHOULD WE ADD (TST18-11, TST18-21, TST18-31, TST18-41, TST18-51,  
                                                 TST18-13, TST18-23, TST18-33, TST18-43, TST18-53) ?  
  [configure N PMP entries (highest-numbered ones first) (as non-adjacent as possible, and avoid the first PMP entry)  
    - execute the N kinds of accesses (if possible to chain due to access-fault)  
    - check N appropriate access-fault exceptions raised]
### Sub-feature: 003_8_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose all 8 PMP entries  
    
  reuse of VP_PMP_F024_S001_I000 feature description (Cf. Feature: "multi entries OFF")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F024_S004_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST24(group) => FTR09-g  
    [create scenarios where PMP entries with A=0 (OFF) and with matching permissions  
      - check no address matching for those PMP entries]  
    [create scenarios where all PMP entries with A=0 (OFF) and with matching permissions  
      - check no address matching for all PMP entries]  
    [check S or U mode access fails when all A=OFF with at least one PMP entry implemented] => FTR09-g  
  TST24-4 = extension of compatible group(8) of (TST17-11, TST17-21, TST17-31, TST17-41, TST17-51,  
                          											 TST17-13, TST17-23, TST17-33, TST17-43, TST17-53,  
                          											 TST17-14, TST17-24, TST17-34, TST17-44, TST17-54,  
                          									 		 TST17-16, TST17-26, TST17-36, TST17-46, TST17-56,  
                          											 TST18-14, TST18-24, TST18-34, TST18-44, TST18-54, //TODO: M-mode may not raise an exception  
                          											 TST18-16, TST18-26, TST18-36, TST18-46, TST18-56) //TODO: M-mode may not raise an exception  
                          //TODO: SHOULD WE ADD (TST18-11, TST18-21, TST18-31, TST18-41, TST18-51,  
                                                 TST18-13, TST18-23, TST18-33, TST18-43, TST18-53) ?  
  [configure 8 PMP entries (highest-numbered ones first)  
    - execute the 8 kinds of accesses (if possible to chain due to access-fault)  
    - check 8 appropriate access-fault exceptions raised]
## Feature: multi entries ALL

### Sub-feature: 000_1_entry

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose a single PMP entry  
    
  CONFIGURATION and ACCESS  
      - for each pmp entry, apply any CONFIGURATION+ACCESS scenario above (Cf. Feature: "cfg NA4/NAPOT/TOR/OFF access S/U/M")  
      - make sure the pmp entries address ranges are not overlapping/intersecting  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, we should obtain the expected CHECK result  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F025_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 001_2_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  reuse of VP_PMP_F025_S001_I000 feature description (Cf. Feature: "multi entries ALL")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F025_S002_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 002_N_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any N PMP entries (2<N<8)  
    
  reuse of VP_PMP_F025_S001_I000 feature description (Cf. Feature: "multi entries ALL")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F025_S003_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 003_8_isolated_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose all 8 PMP entries  
    
  reuse of VP_PMP_F025_S001_I000 feature description (Cf. Feature: "multi entries ALL")
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F025_S004_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
### Sub-feature: 004_2_intersecting_entries_fail

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  CONFIGURATION and ACCESS (Cf. Feature: "cfg NA4/NAPOT/TOR/OFF access S/U/M")  
      - for the least-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario with access-fault  
      - for the highest-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario without access-fault  
      - make sure the pmp entries address ranges are overlapping/intersecting (at least at 4 consecutive bytes)  
      - for each pmp entry, execute one access in its associated pmp address region but outside the overlapping/intersecting address range  
      - execute one additional access inside the overlapping/intersecting address range  
      - NB: obviously, pmp entry configurations with different access-modes (S/U vs. M) cannot be easily mixed in same test  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, access outside the overlapping/intersecting address range should give the expected CHECK result  
      - access inside the overlapping/intersecting address range should generate the access-type related access-fault  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** ENV Capability
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F025_S005_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST51(group) => FTR09-a, FTR09-b and FTR09-c  
    [create scenarios where 2 PMP entries with same pmpaddr  
      - one without matching permissions or with A=OFF  
      - one with matching permissions and A=NA4/NAPOT/TOR  
      - any of them can be the lowest-numbered PMP entry]  
  TST51-1  
  [configure 2 PMP entries  
    - configure the lowest-numbered PMP entry with  (TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          				 					 				 TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          									 				 TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          									 				 TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                                                     TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          									 				 TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          				 					 				 TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          									 				 TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                                                     TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          									 				 TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          									 				 TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          									 				 TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                                                     TST17-12, TST17-22, TST17-32, TST17-42, TST17-52,  
                          				 					 				 TST17-15, TST17-25, TST17-35, TST17-45, TST17-55,  
                          									 				 TST18-12, TST18-22, TST18-32, TST18-42, TST18-52,  
                          									 				 TST18-15, TST18-25, TST18-35, TST18-45, TST18-55)  
    - configure the highest-numbered PMP entry with  (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          									 				  TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          				 					 				  TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          									 				  TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                                                      TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          									 					TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          									 				 	TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          									 					TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                                                      TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          				 					 				  TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          									 				  TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          									 				  TST16-14, TST16-24, TST16-34, TST16-44, TST16-54)  
    - execute the associated access  
    - check associated access-fault exception raised]
### Sub-feature: 005_2_intersecting_entries_succeed

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  {Page 57 Section "3.7.1 Physical Memory Protection CSRs" Volume II: RISC-V Privileged Architectures V20211203}  
    
  Up to 64 PMP entries are supported
* **Verification Goals**
  
  choose any 2 PMP entries  
    
  CONFIGURATION and ACCESS (Cf. Feature: "cfg NA4/NAPOT/TOR/OFF access S/U/M")  
      - for the least-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario without access-fault  
      - for the highest-numbered pmp entry, apply any CONFIGURATION+ACCESS scenario with access-fault  
      - make sure the pmp entries address ranges are overlapping/intersecting (at least at 4 consecutive bytes)  
      - for each pmp entry, execute one access in its associated pmp address region but outside the overlapping/intersecting address range  
      - execute one additional access inside the overlapping/intersecting address range  
      - NB: obviously, pmp entry configurations with different access-modes (S/U vs. M) cannot be easily mixed in same test  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  CHECK  
      - for each pmp entry, access outside the overlapping/intersecting address range should give the expected CHECK result  
      - access inside the overlapping/intersecting address range should not generate any access-fault  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** ENV Capability
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F025_S006_I000
* **Link to Coverage:** 
* **Comments**
  
  << link to the old pmp_verif_plan.txt and pmp_verif_plan_features.txt files (not up-to-date) : reading below not mandatory but may help for better understanding >>  
    
  TST51(group) => FTR09-a, FTR09-b and FTR09-c  
    [create scenarios where 2 PMP entries with same pmpaddr  
      - one without matching permissions or with A=OFF  
      - one with matching permissions and A=NA4/NAPOT/TOR  
      - any of them can be the lowest-numbered PMP entry]  
  TST51-2  
  [configure 2 PMP entries  
    - configure the lowest-numbered PMP entry with  (TST11-11, TST11-21, TST11-31, TST11-41, TST11-51,  
                          				 					 				 TST11-14, TST11-24, TST11-34, TST11-44, TST11-54,  
                          									 				 TST12-11, TST12-21, TST12-31, TST12-41, TST12-51,  
                          									 				 TST12-14, TST12-24, TST12-34, TST12-44, TST12-54,  
                                                     TST13-11, TST13-21, TST13-31, TST13-41, TST13-51,  
                          									 				 TST13-14, TST13-24, TST13-34, TST13-44, TST13-54,  
                          				 					 				 TST14-11, TST14-21, TST14-31, TST14-41, TST14-51,  
                          									 				 TST14-14, TST14-24, TST14-34, TST14-44, TST14-54,  
                                                     TST15-11, TST15-21, TST15-31, TST15-41, TST15-51,  
                          									 				 TST15-14, TST15-24, TST15-34, TST15-44, TST15-54,  
                          									 				 TST16-11, TST16-21, TST16-31, TST16-41, TST16-51,  
                          									 				 TST16-14, TST16-24, TST16-34, TST16-44, TST16-54)  
    - configure the highest-numbered PMP entry with  (TST11-12, TST11-22, TST11-32, TST11-42, TST11-52,  
                          				 					 				  TST11-15, TST11-25, TST11-35, TST11-45, TST11-55,  
                          									 				  TST12-12, TST12-22, TST12-32, TST12-42, TST12-52,  
                          									 				  TST12-15, TST12-25, TST12-35, TST12-45, TST12-55,  
                                                      TST13-12, TST13-22, TST13-32, TST13-42, TST13-52,  
                          									 				  TST13-15, TST13-25, TST13-35, TST13-45, TST13-55,  
                          									 				  TST14-12, TST14-22, TST14-32, TST14-42, TST14-52,  
                          									 				  TST14-15, TST14-25, TST14-35, TST14-45, TST14-55,  
                                                      TST15-12, TST15-22, TST15-32, TST15-42, TST15-52,  
                          									 				  TST15-15, TST15-25, TST15-35, TST15-45, TST15-55,  
                          									 				  TST16-12, TST16-22, TST16-32, TST16-42, TST16-52,  
                          									 				  TST16-15, TST16-25, TST16-35, TST16-45, TST16-55,  
                                                      TST17-12, TST17-22, TST17-32, TST17-42, TST17-52,  
                          									 				  TST17-15, TST17-25, TST17-35, TST17-45, TST17-55,  
                          									 				  TST18-12, TST18-22, TST18-32, TST18-42, TST18-52,  
                          				 					 				  TST18-15, TST18-25, TST18-35, TST18-45, TST18-55)  
    - execute the associated access  
    - check no access-fault exception]
## Feature: entry reconfiguration

### Sub-feature: 000_reconfigure_N_pmp_entries

#### Item: 000

* **Requirement location:** 
* **Feature Description**
  
  reuse of feature descriptions (Cf. Feature: "cfg NA4/NAPOT/TOR/OFF access S/U/M")  
  reuse of feature descriptions (Cf. Feature: "CSRs M-mode only")  
  reuse of feature descriptions (Cf. Feature: "CSRs locked access")  
  reuse of feature descriptions (Cf. Feature: "multi entries NA4/NAPOT/TOR/OFF")
* **Verification Goals**
  
  configure any N PMP entries, possibly some with L=1  
    
  CONFIGURATION and ACCESS  
      - for each pmp entry, apply any CONFIGURATION+ACCESS scenario above (Cf. Feature: "cfg NA4/NAPOT/TOR/OFF access S/U/M")  
      - make sure the pmp entries address ranges are not overlapping/intersecting  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  RECONFIGURATION and ACCESS  
      - for each pmp entry with L=0, apply any other CONFIGURATION+ACCESS scenario above (Cf. Feature: "cfg NA4/NAPOT/TOR/OFF access S/U/M")  
      - make sure the pmp entries address ranges are not overlapping/intersecting  
      - NB: obviously, pmp entry configurations with different mstatus.MPRV/MPP values cannot be mixed in same test  
    
  RESET  
      - if there is any pmp entry with L=1, apply hart reset (or only PMP reset if possible)  
      - and restart with CONFIGURATION and RESET  
    
  CHECK  
      - for each pmp entry, we should obtain the expected CHECK result  
    
  REUSABILITY  
      - if possible, the number of PMP entries (N) is a configurable parameter  
      - so a single test function can be reused
* **Pass/Fail Criteria:** Check RM
* **Test Type:** Constrained Random
* **Coverage Method:** Functional Coverage
* **Applicable Cores:** CV32E40P, CV32E40S, CV32E40X, CV32A6_v0.1.0, CV32A6-step2, CV64A6-step3
* **Unique verification tag:** VP_PMP_F031_S001_I000
* **Link to Coverage:** 
* **Comments**
  
  *(none)*  
  
