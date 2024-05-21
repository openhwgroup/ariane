# Copyright 2024 Thales DIS France SAS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Original Author: Oukalrazqou Abdessamii


import yaml
import io
import math
import os
import sys
import json
from mdutils.mdutils import MdUtils
from libs.csr_factorizer import*
import rstcloth
from rstcloth import RstCloth
import re
from libs.csr_updater import *
from libs.isa_updater import*
pattern_warl = r'\b(?:warl|wlrl|ro_constant|ro_variable)\b'
pattern_legal_dict = r'\[(0x[0-9A-Fa-f]+)(.*?(0x[0-9A-Fa-f]+))?\]'
pattern_legal_list = r'\[(0x[0-9A-Fa-f]+)(.*?(0x[0-9A-Fa-f]+))?\]'
Factorizer_pattern = r'.*(\d).*'
def sortRegisterAndFillHoles(regName,
                             fieldNameList,
                             bitmsblist,
                             bitlsblist,
                             bitWidthList,
                             fieldDescList,
                             bitlegalList,
                             size):
    # sort the lists, highest offset first
    #bitmsblist = [int(x) for x in bitmsblist]
    bitlsblist = [int(x) for x in bitlsblist]
    bitWidthList = [(x) for x in bitWidthList]
    matrix = list(zip(bitlsblist , bitmsblist,bitWidthList, fieldNameList, fieldDescList ,bitlegalList))
    matrix.sort(key = lambda x:x[0])  # , reverse=True)
    bitlsblist , bitmsblist,bitWidthList, fieldNameList, fieldDescList ,bitlegalList, = list(zip(*matrix))
    # zip return tuples not lists
    fieldNameList = list(fieldNameList)
    bitlsblist = list([int(x) for x in bitlsblist])
    bitmsblist = list([int(x) for x in bitmsblist])
    bitWidthList = list([(x) for x in bitWidthList])
    fieldDescList = list(fieldDescList)
    return regName, fieldNameList, bitmsblist,bitlsblist, bitWidthList, fieldDescList, bitlegalList


class documentClass():
    def __init__(self, name):
        self.name = name
        self.memoryMapList = []

    def addMemoryMap(self, memoryMap):
        self.memoryMapList.append(memoryMap)


class memoryMapClass():
    def __init__(self, name):
        self.name = name
        self.addressBlockList = []

    def addAddressBlock(self, addressBlock):
        self.addressBlockList.append(addressBlock)


class addressBlockClass():
    def __init__(self, name):
        self.name = name
        self.registerList = []
        self.suffix = ""

    def addRegister(self, reg):
        assert isinstance(reg, registerClass)
        self.registerList.append(reg)

    def setRegisterList(self, registerList):
        self.registerList = registerList

    def returnAsString(self):
        raise NotImplementedError("method returnAsString() is virutal and must be overridden.")

class registerClass():
    def __init__(self, name, address, resetValue, size, access, desc,RV32,RV64,field):
        self.name = name
        self.address = address
        self.resetValue = resetValue
        self.size = size
        self.access = access
        self.desc = desc
        self.RV32 = RV32
        self.RV64 = RV64
        self.field = field
class Field:
    def __init__(self, name,bitlegal, bitmask,bitmsb,bitlsb,bitWidth, fieldDesc , fieldaccess):
        self.name = name
        self.bitlegal = bitlegal
        self.bitmask = bitmask
        self.bitmsb = bitmsb
        self.bitlsb = bitlsb
        self.bitWidth = bitWidth
        self.fieldDesc = fieldDesc
        self.fieldaccess = fieldaccess
#--------------------------------------------------------------#
class ISAdocumentClass:
    def __init__(self, name):
        self.name = name
        self.instructions = []

    def addInstructionMapBlock(self, InstructionMap):
        self.instructions.append(InstructionMap)
class InstructionMapClass():
    def __init__(self, name):
        self.name = name
        self.InstructionBlockList = []

    def addInstructionBlock(self, InstructionBlock):
        self.InstructionBlockList.append(InstructionBlock)


class Instruction:
    def __init__(self, key, Extension_Name , descr, OperationName,
                            Name, Format, Description, pseudocode,invalid_values,exception_raised):
        self.key = key
        self.Extension_Name = Extension_Name
        self.descr = descr
        self.OperationName = OperationName
        self.Name = Name
        self.Format = Format
        self.Description = Description
        self.invalid_values = invalid_values
        self.pseudocode = pseudocode
        self.exception_raised = exception_raised

class InstructionBlockClass():
    def __init__(self, name):
        self.name = name
        self.Instructionlist = []
        self.suffix = ""

    def addInstruction(self, Inst):
        assert isinstance(Inst, Instruction)
        self.Instructionlist.append(Inst)

    def setInstructionList(self, Instructionlist):
        self.Instructionlist = Instructionlist

    def returnAsString(self):
        raise NotImplementedError("method returnAsString() is virutal and must be overridden.")


class rstAddressBlock(addressBlockClass):
    """Generates a ReStructuredText file from a IP-XACT register description"""

    def __init__(self, name):
        self.name = name
        self.registerList = []
        self.suffix = ".rst"

    def sort_address(self,address):
        for reg in self.registerList :
            if "-" in reg.address :
               start, end = reg.address.split("-")
               return int(start,16), int(end,16)
            else:
               return int(reg.address,16), int(reg.address,16)
    def returnAsString(self):
        registerlist = sorted(self.registerList, key = lambda reg : reg.address)
        r = RstCloth(io.StringIO())  # with default parameter, sys.stdout is used
        regNameList = [reg.name for reg in registerlist]
        regAddressList = [reg.address for reg in registerlist]
        regDescrList = [reg.desc for reg in registerlist]
        regRV32List = [reg.RV32 for reg in registerlist]
        regRV64List = [reg.RV64 for reg in registerlist]
        r.title(self.name)  # Use the name of the addressBlock as title
        r.newline()
        r.h2("Register Summary")
        summary_table = []
        for i in range(len(regNameList)):
          if regRV32List[i] | regRV64List[i] :
            summary_table.append([regAddressList[i], str(regNameList[i]), str(regDescrList[i])])
        r.table(header=['Address', 'Register Name', 'Description'],
                data=summary_table)

        r.h2("Register Description")
        for reg in registerlist:
          if reg.RV32| reg.RV64 :
            r.h2(reg.name)
            r.newline()
            #r.field("Name", reg.name)
            r.field("Address",(reg.address))
            if reg.resetValue:
        
                # display the resetvalue in hex notation in the full length of the register
                r.field("Reset Value",
                             "0x" + f"{reg.resetValue[2:].zfill(int(reg.size/4))}")
            r.field("priviliege mode", reg.access)
            r.field("Description", reg.desc)
            reg_table = []
                 
            for field in reg.field:
                if field.bitWidth == 1:  # only one bit -> no range needed
                    bits = f"{field.bitlsb}"
                else:
                    bits = f"[{field.bitmsb}:{field.bitlsb}]"
                _line = [bits,
                         field.name,field.bitlegal ,field.bitmask,field.fieldaccess]
                _line.append(field.fieldDesc)
                reg_table.append(_line)
              
            _headers = ['Bits', 'Field name' , 'Legalvalues' , 'Mask' ,'Access']
            _headers.append('Description')
            # table of the register
            r.table(header=_headers,
                    data=reg_table)
            
        return r.data
class InstrstBlock(InstructionBlockClass):
    """Generates a ISA ReStructuredText file from RISC V Config Yaml register description"""

    def __init__(self, name):
        self.name = name
        self.Instructionlist = []
        self.suffix = ".rst"

    def returnAsString(self):
        r = rstcloth.RstCloth(io.StringIO())  # with default parameter, sys.stdout is used
        InstrNameList = [reg.key for reg in self.Instructionlist]
        InstrDescrList = [reg.descr for reg in self.Instructionlist]
        InstrExtList = [reg.Extension_Name for reg in self.Instructionlist]
        r.title(self.name)  # Use the name of the addressBlock as title
        r.newline()
        r.h2("Instructions")

        summary_table = []
        for i in range(len(InstrNameList)):
            summary_table.append([str(InstrExtList[i]), str(InstrNameList[i]) + "_", str(InstrDescrList[i])])
        r.table(header=['Subset Name', 'Name ', 'Description'],
                data=summary_table)

        for reg in self.Instructionlist:
          if len(reg.Name)>0:
            r.h2(reg.key)
            r.newline()
            _headers = ['Name', 'Format','pseudocode','invalid_values','exception_raised','Description','Op Name']
            reg_table = []
            for fieldIndex in list(range(len(reg.Name))):
                 _line = [reg.Name[fieldIndex], reg.Format[fieldIndex], reg.pseudocode[fieldIndex], reg.invalid_values[fieldIndex],reg.exception_raised[fieldIndex], reg.Description[fieldIndex]]
                 _line.append(reg.OperationName[fieldIndex])
                 reg_table.append(_line)

                        # table of the register
            r.table(header=_headers,data=reg_table)
        return r.data

class InstmdBlock(InstructionBlockClass):
    """Generates a  ISA Markdown file from a RISC Config Yaml register description"""

    def __init__(self, name):
        self.name = name
        self.Instructionlist = []
        self.suffix = ".md"
        self.mdFile = MdUtils(file_name="none",
                              title="")
    def returnAsString(self):
        InstrNameList = [reg.key for reg in self.Instructionlist]
        InstrDescrList = [reg.descr for reg in self.Instructionlist]
        InstrExtList = [reg.Extension_Name for reg in self.Instructionlist]
        self.mdFile.new_header(level=1, title=self.name)  # Use the name of the addressBlock as title
        self.mdFile.new_paragraph()
        self.mdFile.new_header(level=2, title="Instructions")

        # summary
        header = ['Subset Name', 'Name ', 'Description']
        rows = []
        for i in range(len(InstrNameList)):
            InstrDescrList[i]= str(InstrDescrList[i]).replace("\n", " ")
            rows.extend([str(InstrExtList[i]),
                         f"[{InstrNameList[i]}](#{InstrNameList[i]})",
                         str(InstrDescrList[i])])
        self.mdFile.new_table(columns=len(header),
                              rows=len(InstrNameList) + 1,  # header + data
                              text=header + rows,
                              text_align='left')

        # all registers
        for reg in self.Instructionlist:
          if len(reg.Name)>0:
            headers = ['Name', 'Format','Pseudocode','Invalid_values','Exception_raised','Description','Op Name']
            self.returnMdRegDesc(reg.key)
            reg_table = []
            for fieldIndex in list(range(len(reg.Name))):
                reg_table.append(reg.Name[fieldIndex].ljust(15))
                reg.Format[fieldIndex]=  f"[{reg.Format[fieldIndex]}](#{reg.Format[fieldIndex]})"
                reg_table.append(reg.Format[fieldIndex])
                reg.pseudocode[fieldIndex]= str(reg.pseudocode[fieldIndex]).replace("\n", " ")
                reg_table.append(reg.pseudocode[fieldIndex])
                reg_table.append(reg.invalid_values[fieldIndex])
                reg.exception_raised[fieldIndex]= str(reg.exception_raised[fieldIndex]).replace("\n", " ")
                reg_table.append(reg.exception_raised[fieldIndex].ljust(40))
                reg.Description[fieldIndex]= str(reg.Description[fieldIndex]).replace("\n", " ")
                reg_table.append(reg.Description[fieldIndex])
                reg_table.append(reg.OperationName[fieldIndex])
                
                
            width_colomns = [15,20,15,20,25,15]
            self.mdFile.new_table(columns=len(headers),
                                  rows=len(reg.Description) + 1,
                                  text=headers + reg_table,
                                  text_align='left')
        return self.mdFile.file_data_text

    def returnMdRegDesc(self, name):
        self.mdFile.new_header(level=3, title=name)


class mdAddressBlock(addressBlockClass):
    """Generates a CSR Markdown file from a RISC Config Yaml register description"""

    def __init__(self, name):
        self.name = name
        self.registerList = []
        self.suffix = ".md"
        self.mdFile = MdUtils(file_name="none",
                              title="")
    def returnAsString(self):
        registerlist = sorted(self.registerList, key = lambda reg : reg.address)
        regNameList = [reg.name for reg in registerlist if reg.RV32|reg.RV64]
        regAddressList = [reg.address for reg in registerlist if reg.RV32|reg.RV64]
        regDescrList = [reg.desc for reg in registerlist if reg.RV32|reg.RV64]
        regRV32List = [reg.RV32 for reg in registerlist if reg.RV32|reg.RV64]
        regRV64List = [reg.RV64 for reg in registerlist if reg.RV32|reg.RV64]

        self.mdFile.new_header(level=1, title=self.name)  # Use the name of the addressBlock as title
        self.mdFile.new_paragraph()
        self.mdFile.new_header(level=2, title="Registers Summary")
        # summary
        header = ['Address', 'Register Name', 'Description']
        rows = []
        for i in range(len(regNameList)):
          regDescrList[i]= str(regDescrList[i]).replace("\n", " ")
          rows.extend([regAddressList[i],
                         f"[{regNameList[i]}](#{regNameList[i]})",
                         str(regDescrList[i])])
            
        
        self.mdFile.new_table(columns=len(header),
                                 rows=len(regNameList) + 1,  # header + data
                                 text=header + rows,
                                 text_align='left')

        # all registers
        self.mdFile.new_header(level=3, title= "Registers Description")
        for reg in registerlist:
          if reg.RV64 | reg.RV32 :
            headers = ['Bits', 'Field name' ,'legal values','Mask','Access']
            headers.append('Description')

            self.returnMdRegDesc(reg.name, reg.address, reg.size, reg.resetValue, reg.desc, reg.access)
            reg_table = []
            for field in reg.field:
                if field.bitWidth == 1:  # only one bit -> no range needed
                    bits = f"{field.bitlsb}"
                else:
                    bits = f"[{field.bitmsb}:{field.bitlsb}]"
                reg_table.append(bits)
                reg_table.append(field.name)
                reg_table.append(field.bitlegal)
                reg_table.append(field.bitmask)
                reg_table.append(field.fieldaccess)
                reg_table.append(field.fieldDesc)   
            self.mdFile.new_table(columns=len(headers),
                                  rows=len(reg.field) + 1,
                                  text=headers + reg_table,
                                  text_align='left')

        return self.mdFile.file_data_text

    def returnMdRegDesc(self, name, address, size, resetValue, desc, access):
        self.mdFile.new_header(level=4, title=name)
        self.mdFile.new_line("---")
        #self.mdFile.new_line("**Name** " + str(name))
        self.mdFile.new_line("**Address** " + str(address))
        if resetValue:
            # display the resetvalue in hex notation in the full length of the register
            self.mdFile.new_line(
                "**Reset Value**" + resetValue)
        self.mdFile.new_line("**Priviliege mode** " + access)
        self.mdFile.new_line("**Description** " + desc)        
#-----------------------------------------------------------------------------------------------------------------------#
       
class CSRParser():
    def __init__(self, srcFile,target,modiFile = None):
       self.srcFile = srcFile
       self.modiFile = modiFile
       self.target = target
    def returnRegister(self, regName, registerElem, regAddress, resetValue, size, access, regDesc, fields,RV32, RV64):
               
     fieldList = fields
     field = []
     if len(fieldList)> 0 :
        for item in fieldList:
         if not isinstance(item, list) :
            fieldDesc = registerElem.get('rv32','')[item].get('description','')
            bitWidth = int(registerElem.get('rv32','')[item].get('msb','')) - int(registerElem.get('rv32','')[item].get('lsb',''))+1
            bitmsb = int(registerElem.get('rv32','')[item].get('msb',''))
            bitlsb = int(registerElem.get('rv32','')[item].get('lsb',''))
            fieldaccess = registerElem.get('rv32','')[item].get('shadow_type','').upper()
            legal = registerElem.get('rv32','')[item].get('type', None)
            if legal is None:
                bitlegal = ""
                bitmask = ""
            else:
               warl = re.findall(pattern_warl , str(legal.keys()))
               if warl: 	
                legal_2 = registerElem.get('rv32','')[item].get('type', None).get(warl[0], None)
           
                if legal_2 is None:
                   bitlegal = "No Legal values"
                else :	 
                 if isinstance(legal_2 ,dict) :
               
                   pattern = r'([\w\[\]:]+\s*\w+\s*)(\[\s*((?:0x)?[0-9A-Fa-f]+)\s*\D+\s*(?:((?:0x)?[0-9A-Fa-f]+))?\s*])'
          
                   matches = re.search(pattern, str(legal_2['legal'][0]))
                   if matches :
                      legal_value = matches.group(3)
                      mask = matches.group(4)
                      bitmask = mask
                      bitlegal = legal_value
                      
                 elif isinstance(legal_2 ,list) :
               
                   pattern = r'\s*((?:0x)?[0-9A-Fa-f]+)\s*(.)\s*((?:0x)?[0-9A-Fa-f]+)\s*'
                   matches = re.search(pattern, legal_2[0])
                   if matches :
                      
                      legal_value = matches.group(1)
                      mask = matches.group(3)
                      bitmask = mask
                      bitlegal = legal_value
                 else:
                      mask = 0
                      legal_value= hex(legal_2)
                      bitmask = mask
                      bitlegal = legal_value
            pattern = r"((\D+)\d+(.*))-\d+"
            match = re.match(pattern, regName)
            if match :
                for item in fieldList:
                    match_field = re.search(Factorizer_pattern,str(item))
                    if match_field :
                         Name = re.sub(match_field.group(1),"[i*4 + {}]".format(match_field.group(1)),item)
                         fieldName = Name
            else:
                fieldName = item
                
         elif  isinstance(item, list):
          for item_ in item :
            fieldName = f"Reserved_{item_[0]}"
            bitlsb  = (item_[0])
            bitmsb = item_[len(item_)-1]
            
            legal =  ""
            fieldaccess = "Reserved"
            bitWidth = (int(item_[len(item_)-1])-int(item_[0])+1)
            fieldDesc = "Reserved"
            bitlegal = legal 
            bitmask =""
         f = Field(fieldName ,bitlegal, bitmask,bitmsb,bitlsb,bitWidth, fieldDesc , fieldaccess) 
         field.append(f)  
     elif len(fieldList) == 0:
           pattern = r"(\D+)\[(\d+)\-\d+\](.*)"
           match = re.match(pattern, regName)
           if match :
              if len(match.group(3))> 0 :
                 name = "{}[i]{}".format(match.group(1),match.group(3))
                 regDesc = re.sub(match.group(1)+match.group(2)+match.group(3) ,match.group(1)+ match.group(3),regDesc)
              else:
                 name = "{}[i]".format(match.group(1))
                 regDesc = re.sub(match.group(1)+match.group(2) ,match.group(1),regDesc)
              fieldName = name
              fieldDesc = regDesc
           else:
              fieldName = regName
          
           bitmsb =registerElem.get('rv32',None).get('msb',None)
           bitlsb =registerElem.get('rv32',None).get('lsb',None)
           legal =  registerElem.get('rv32','').get('type', None)
           if legal is None:
                bitlegal= ""
                bitmask = ""
           else:
               warl = re.findall(pattern_warl , str(legal.keys()))
               if warl: 	
                legal_2 = registerElem.get('rv32','').get('type', None).get(warl[0], None)
                
                if legal_2 is None:
                   bitlegal = "No Legal values"
                else :	 
                 if isinstance(legal_2 ,dict) :
                   pattern = r'([\w\[\]:]+\s*\w+\s*)(\[\s*((?:0x)?[0-9A-Fa-f]+)\s*\D+\s*(?:((?:0x)?[0-9A-Fa-f]+))?\s*])'
                   matches = re.search(pattern, str(legal_2['legal'][0]))
                   if matches :
                      legal_value = matches.group(3)
                      mask = matches.group(4)
                      bitmask = mask
                      bitlegal = legal_value
                 elif isinstance(legal_2 ,list) :
                   
                   pattern = r'([0-9A-Fa-f]+).*([0-9A-Fa-f]+)'
                   matches = re.search(pattern, legal_2[0])
                   if matches :
                       legal_value = matches.group(1)
                       mask = matches.group(2)
                       bitmask = mask
                       bitlegal = hex(legal_value)
                 else:
                       bitmask = 0
                       bitlegal = hex(legal_2)
                
           fieldaccess = registerElem.get('rv32','').get('shadow_type','').upper()
           fieldDesc = regDesc

           if bitlsb is None:
                bitlsb = 0
           if bitmsb is None:
                bitmsb = 31
                bitWidth = ""
           else:
                bitWidth = int(bitmsb)+1
         
           f = Field(fieldName ,bitlegal, bitmask,bitmsb,bitlsb,bitWidth, fieldDesc , fieldaccess) 
           field.append(f)     
    
           
     reg = registerClass(regName, regAddress, resetValue, size, access, regDesc, RV32, RV64, field)
     return reg
    def returnDocument(self):
        with open(self.srcFile , 'r') as f :
          data = yaml.safe_load(f)
        data = csr_Formatter(self.srcFile , self.modiFile)
        Registers = Factorizer(data)
        docName = data['hart0']
        d = documentClass(docName)
       
        m = memoryMapClass(docName)
        a = addressBlockClass('csr')
        for register in Registers:
            if isinstance(Registers.get(register, {}),dict) :
             RegElement = Registers.get(register, {})
             regName = register
             regAddress = (RegElement.get("address", None))  if isinstance(RegElement.get("address", None),str) else hex(RegElement.get("address", None))
             reset = hex(RegElement.get('reset-val', ''))
             size = int(data['hart0'].get('supported_xlen', '')[0] )
             access = RegElement.get('priv_mode', '')
             if Registers.get(register, {}).get("description", '') != None:
                   desc = Registers.get(register, {}).get("description", '')
             else:
                   desc = ""
             RV32 =   RegElement.get('rv32','').get('accessible', [])
             RV64 =   RegElement.get('rv64','').get('accessible', [])
             if RV32:
               fields = RegElement.get('rv32','').get('fields', [])
             else :
               fields = []
             r = self.returnRegister(regName, RegElement, regAddress,reset,
                                        size, access, desc ,fields,RV32, RV64) 
             a.addRegister(r)
        m.addAddressBlock(a)
        d.addMemoryMap(m)

        return d


class ISAParser():
    def __init__(self, srcFile,templatefile,target,modiFile = None):
        self.srcFile = srcFile
        self.modiFile = modiFile
        self.templatefile = templatefile
        self.target = target
    def returnDocument(self):
      with open(self.srcFile, 'r', encoding = 'utf-8') as file:
            yaml_data = yaml.safe_load(file)
      d = ISAdocumentClass('MAP')
      m = InstructionMapClass('ISA_B')
      a = InstructionBlockClass('isa')
      yaml_data = Check_filter(yaml_data, self.modiFile ,self.templatefile)
      for key in yaml_data :
        Extension_Name = yaml_data[key].get('Subset_Name', None )
        Descr  = yaml_data[key].get('Description', None)
        instructions_data =  yaml_data[key].get('Instructions', None)
        instruction = self.returnRegister(key, Extension_Name , Descr, instructions_data)
        a.addInstruction(instruction)
      m.addInstructionBlock(a)
      d.addInstructionMapBlock(m)

      return d
    
    def returnRegister(self,key, Extension_Name , Descr, instructions_data):
        OperationName = []
        Name  =[]
        Format = []
        Description =[]
        pseudocode = []
        invalid_values =[]
        exception_raised =[]
        if instructions_data:
         for instruction_name, instruction_data in instructions_data.items():
           for instruction , data in instruction_data.items():
             OperationName.append(instruction_name)
             if instruction is not None:
                Name.append(instruction)
             else:
                Name.append("")
             description = data.get('Description', '')
            # handle no or an empty description
             if description is not None:
                Description.append(description)
             else:
                Description.append("")
            
             format_str = data.get('Format', '')
             if format_str is not None:
                Format.append(format_str)
             else:
                Format.append("")
             pseudocode_str = data.get('Pseudocode', '')
             if pseudocode_str is not None:
                pseudocode.append(pseudocode_str)
             else:
                pseudocode.append("")
             exception_raised_str = data.get('Exception_Raised', '')
             if exception_raised_str is not None:
                exception_raised.append(exception_raised_str)
             else:
                exception_raised.append("")
             invalid_values_str = data.get('Invalid_Values', '')
             if invalid_values_str is not None:
                invalid_values.append(invalid_values_str)
             else:
                invalid_values.append("")
        Inst = Instruction(key, Extension_Name , Descr, OperationName,
                            Name, Format, Description, pseudocode,invalid_values,exception_raised)
        
        return Inst
            

class ISAGenerator():
    def __init__(self,target):
        self.target = target
    def write(self, fileName, string):
 
        path = f'./{self.target}/isa/'
        if not os.path.exists(path):
            os.makedirs(path)
        _dest = os.path.join(path, fileName)
        print("writing file " + _dest)

        if not os.path.exists(os.path.dirname(_dest)):
            os.makedirs(os.path.dirname(_dest))

        with open(_dest, "w") as f:
            f.write(string)

    def generateISA(self, generatorClass, document):
        self.document = document
        docName = document.name
        for InstructionMap  in document.instructions:
            mapName = InstructionMap.name
            for InstructionBlock in InstructionMap.InstructionBlockList:
                blockName = InstructionBlock.name

                block = generatorClass(InstructionBlock.name)

                block.setInstructionList(InstructionBlock.Instructionlist)
                s = block.returnAsString()
                fileName = blockName + block.suffix
                self.write(fileName, s)
class CSRGenerator():
    def __init__(self,target):
        self.target = target
    def write(self, fileName, string):
 
        path = f'./{self.target}/csr/'
        print(path)
        if not os.path.exists(path):
            os.makedirs(path)
        _dest = os.path.join(path, fileName)
        print("writing file " + _dest)

        if not os.path.exists(os.path.dirname(_dest)):
            os.makedirs(os.path.dirname(_dest))

        with open(_dest, "w") as f:
            f.write(string)
    def generateCSR(self, generatorClass, document):
        self.document = document
        docName = document.name
        for memoryMap in document.memoryMapList:
            mapName = memoryMap.name
            for addressBlock in memoryMap.addressBlockList:
                blockName = addressBlock.name
                block = generatorClass(addressBlock.name)

                block.setRegisterList(addressBlock.registerList)
                s = block.returnAsString()
                fileName = blockName + block.suffix
                self.write(fileName, s)

              
