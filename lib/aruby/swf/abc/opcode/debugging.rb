module ARuby
  class SWF
    class ABC
      module OpCode
        # ID: 239 (0xEF)
        # DESC: Debugging info
        # STACK: ... => ...
        # debug_type is an unsigned byte. If the value of debug_type is DI_LOCAL (1), then this is 
        # debugging information for a local register.  
        # index is a u30 that must be an index into the string constant pool. The string at index is the 
        # name to use for this register.  
        # reg is an unsigned byte and is the index of the register that this is debugging information for.  
        # extra is a u30 that is currently unused. 
        # When debug_type has a value of 1, this tells the debugger the name to display for the register 
        # specified by reg. If the debugger is not running, then this instruction does nothing.
        class Debug < Base
          define_opcode 239, "debug"
          struct do
            ui8 :type
            u30 :index
            ui8 :reg
            u30 :extra
          end
          
          def to_s
            super " type=#{type} index=#{index}||#{@abc_file.strings[index]}"
          end
        end
     
        # ID: 240 (0xF0)
        # DESC: Debugging line number info
        # STACK: ... => ...
        # linenum is a u30 that indicates the current line number the debugger should be using for the 
        # code currently executing.
        # If the debugger is running, then this instruction sets the current line number in the 
        # debugger. This lets the debugger know which instructions are associated with each line in a 
        # source file. The debugger will treat all instructions as occurring on the same line until a new 
        # debugline opcode is encountered.
        class DebugLine < Base
          define_opcode 240, "debug_line"
          struct do
            u30 :linenum
          end
          
          def to_s
            super " linenum=#{linenum}"
          end
        end
        
        # ID: 241 (0xF1)
        # DESC: Debugging file info
        # STACK: ... => ...
        # index is a u30 that must be an index into the string constant pool 
        # If the debugger is running, then this instruction sets the current file name in the debugger to 
        # the string at position index of the string constant pool. This lets the debugger know which 
        # instructions are associated with each source file. The debugger will treat all instructions as 
        # occurring in the same file until a new debugfile opcode is encountered.  
        # This instruction must occur before any debugline opcodes.
        class DebugFile < Base
          define_opcode 241, "debug_file"
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.strings[index]}"
          end
        end
      end
    end
  end
end