module ARuby
  class SWF
    class ABC
      module OpCode
        # DESC: All IF operate the same
        # offset is an s24 that is the number of bytes to jump
        class OffsetBase < Base
          struct do
            s24 :offset
          end
        end
        
        # ID: 9 (0x0C)
        # DESC: Do nothing
        # STACK: ... => ...
        # Do nothing. Used to indicate that this location is the target of a branch.
        class Label < Base
          define_opcode 9, "label"
        end

        # ID: 12 (0x0C)
        # DESC: Branch if the first value is not less than the second value
        # STACK: ..., value1, value2 => ...
        # Compute value1 < value2 using the abstract relational comparison algorithm in ECMA-262 
        # section 11.8.5. If the result of the comparison is false, then jump the number of bytes 
        # indicated by offset. Otherwise continue executing code from this point. 
        class IFNLT < OffsetBase
          define_opcode 12, "if_not_less_than"
        end
        
        # ID: 13 (0x0D)
        # DESC: Branch if the first value is not less than or equal to the second value
        # STACK: ..., value1, value2 => ...
        # Compute value2 < value1 using the abstract relational comparison algorithm in ECMA-262 
        # section 11.8.5. If the result of the comparison is true, jump the number of bytes indicated 
        # by offset. Otherwise continue executing code from this point.
        class IFNLE < OffsetBase
          define_opcode 13, "if_not_less_equal"
        end
        
        # ID: 14 (0x0E)
        # DESC: Branch if the first value is not greater than the second value
        # STACK: ..., value1, value2 => ...
        # Compute value2 < value1 using the abstract relational comparison algorithm in ECMA-262 
        # section 11.8.5. If the result of the comparison is not true, jump the number of bytes 
        # indicated by offset. Otherwise continue executing code from this point.
        class IFNGT < OffsetBase
          define_opcode 14, "if_not_greater_than"
        end
        
        # ID: 15 (0x0F)
        # DESC: Branch if the first value is not greater than or equal to the second value
        # STACK: ..., value1, value2 => ...
        # Compute value1 < value2 using the abstract relational comparison algorithm in ECMA-262 
        # section 11.8.5. If the result of the comparison is not false, jump the number of bytes 
        # indicated by offset. Otherwise continue executing code from this point.
        class IFNGE < OffsetBase
          define_opcode 15, "if_not_greater_equal"
        end
        
        # ID: 16 (0x10)
        # DESC: Unconditional branch
        # STACK: ... => ...
        # Jump the number of bytes indicated by offset and resume execution there.
        class Jump < OffsetBase
          define_opcode 16, "jump"
        end
        
        # ID: 17 (0x11)
        # DESC: Branch if true
        # STACK: ..., value => ...
        # Pop value off the stack and convert it to a Boolean. If the converted value is true, jump the 
        # number of bytes indicated by offset. Otherwise continue executing code from this point.
        class IFTRUE < OffsetBase
          define_opcode 17, "if_true"
        end
        
        # ID: 18 (0x12)
        # DESC: Branch if false
        # STACK: ..., value => ...
        # Pop value off the stack and convert it to a Boolean. If the converted value is false, jump the 
        # number of bytes indicated by offset. Otherwise continue executing code from this point.
        class IFFALSE < OffsetBase
          define_opcode 18, "if_false"
        end
        
        # ID: 19 (0x13)
        # DESC: Branch if the first value is equal to the second value
        # STACK: ..., value1, value2 => ...
        # Compute value1 == value2 using the abstract equality comparison algorithm in ECMA-262 
        # section 11.9.3 and ECMA-347 section 11.5.1. If the result of the comparison is true, jump 
        # the number of bytes indicated by offset. Otherwise continue executing code from this point.
        class IFEQ < OffsetBase
          define_opcode 19, "if_equal"
        end
        
        # ID: 20 (0x14)
        # DESC: Branch if the first value is not equal to the second value
        # STACK: ..., value1, value2 => ...
        # Compute value1 != value2 using the abstract equality comparison algorithm in ECMA-262 
        # section 11.9.3 and ECMA-347 Section 11.5.1. If the result of the comparison is false, 
        # jump the number of bytes indicated by offset. Otherwise continue executing code from this 
        # point.
        class IFNE < OffsetBase
          define_opcode 20, "if_not_equal"
        end
        
        # ID: 21 (0x15)
        # DESC: Branch if the first value is less than the second value
        # STACK: ..., value1, value2 => ...
        # Compute value1 < value2 using the abstract relational comparison algorithm in ECMA-262 
        # section 11.8.5. If the result of the comparison is true, jump the number of bytes indicated 
        # by offset. Otherwise continue executing code from this point. 
        class IFLT < OffsetBase
          define_opcode 21, "if_less_than"
        end
        
        # ID: 22 (0x16)
        # DESC: Branch if the first value is less than or equal to the second value
        # STACK: ..., value1, value2 => ...
        # Compute value2 < value1 using the abstract relational comparison algorithm in ECMA-262 
        # section 11.8.5. If the result of the comparison is false, jump the number of bytes indicated 
        # by offset. Otherwise continue executing code from this point.
        class IFLE < OffsetBase
          define_opcode 22, "if_less_equal"
        end
        
        # ID: 23 (0x17)
        # DESC: Branch if the first value is greater than the second value
        # STACK: ..., value1, value2 => ...
        # Compute value2 < value1 using the abstract relational comparison algorithm in ECMA-262 
        # section 11.8.5. If the result of the comparison is true, jump the number of bytes indicated 
        # by offset. Otherwise continue executing code from this point.
        class IFGT < OffsetBase
          define_opcode 23, "if_greater_than"
        end
        
        # ID: 24 (0x18)
        # DESC: Branch if the first value is greater than or equal to the second value
        # STACK: ..., value1, value2 => ...
        # Compute value1 < value2 using the abstract relational comparison algorithm in ECMA-262 
        # section 11.8.5. If the result of the comparison is false, jump the number of bytes indicated 
        # by offset. Otherwise continue executing code from this point.
        class IFGE < OffsetBase
          define_opcode 24, "if_greater_equal"
        end

        # ID: 25 (0x19)
        # DESC: Branch if the first value is equal to the second value
        # STACK: ..., value1, value2 => ...
        # Compute value1 === value2 using the strict equality comparison algorithm in ECMA-262 
        # section 11.9.6. If the result of the comparison is true, jump the number of bytes indicated 
        # by offset. Otherwise continue executing code from this point.
        class IFSTRICTEQ < OffsetBase
          define_opcode 25, "if_strict_equal"
        end
        
        # ID: 26 (0x1A)
        # DESC: Branch if the first value is not equal to the second value
        # STACK: ..., value1, value2 => ...
        # Compute value1 !== value2 using the strict equality comparison algorithm in ECMA-262 
        # section 11.9.6. If the result of the comparison is true, jump the number of bytes indicated 
        # by offset. Otherwise continue executing code from this point.
        class IFSTRICTNE < OffsetBase
          define_opcode 26, "if_strict_not_equal"
        end
        
        # ID: 27 (0x1B)
        # DESC: Jump to different locations based on an index
        # STACK: ..., index => ...
        # default_offset is an s24 that is the offset to jump, in bytes, for the default case. case_offsets are 
        # each an s24 that is the offset to jump for a particular index. There are case_count+1 case 
        # offsets. case_count is a u30. 
        # index is popped off of the stack and must be of type int. If index is less than zero or greater 
        # than case_count, the target is calculated by adding default_offset to the base location. 
        # Otherwise the target is calculated by adding the case_offset at position index to the base 
        # location. Execution continues from the target location.  
        # The base location is the address of the lookupswitch instruction itself.
        class LookupSwitch < Base
          define_opcode 27, "lookup_switch"
          
          struct do
            s24 :default_offset
            s30 :case_count
            s24 :case_offsets, :size => lambda { case_count }
          end
        end
      end
    end
  end
end