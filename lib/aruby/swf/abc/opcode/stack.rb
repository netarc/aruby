module ARuby
  class SWF
    class ABC
      module OpCode
        # ID: 28 (0x1D)
        # DESC: Push a with scope onto the scope stack
        # STACK: ..., scope_obj => ...
        # scope_obj is popped off of the stack, and the object is pushed onto the scope stack. scope_obj can be of 
        # any type.
        class PushWith < Base
          define_opcode 28, "push_with"
        end
        
        # ID: 29 (0x1D)
        # DESC: Pop a scope off of the scope stack
        # STACK: ... => ...
        # Pop the top scope off of the scope stack and discards it
        class PopScope < Base
          define_opcode 29, "pop_scope"
        end
        
        # ID: 32 (0x20)
        # DESC: Push null
        # STACK: ... => ..., null
        # Push the null value onto the stack
        class PushNull < Base
          define_opcode 32, "push_null"
        end

        # ID: 33 (0x21)
        # DESC: Push undefined
        # STACK: ... => ..., undefined
        # Push the undefined value onto the stack
        class PushUndefined < Base
          define_opcode 33, "push_undefined"
        end
        
        # ID: 36 (0x24)
        # DESC: Push a byte value
        # STACK: ... => ..., value
        # byte_value is an unsigned byte. The byte_value is promoted to an int, and the result is pushed 
        # onto the stack.
        class PushByte < Base
          define_opcode 36, "push_byte"
          
          struct do
            si8 :value
          end
          
          def to_s
            super " value=#{value}"
          end
        end
        
        # ID: 37 (0x25)
        # DESC: Push a short value
        # STACK: ... => ..., value
        # value is a u30. The value is pushed onto the stack.value is a u30. The value is pushed onto the stack.
        class PushShort < Base
          define_opcode 37, "push_short"
          
          struct do
            u30 :value
          end
          
          def to_s
            super " value=#{value}"
          end
        end
        
        # ID: 38 (0x26)
        # DESC: Push true
        # STACK: ... => ..., true
        # Push the true value onto the stack
        class PushTrue < Base
          define_opcode 38, "push_true"
        end
        
        # ID: 39 (0x27)
        # DESC: Push false
        # STACK: ... => ..., false
        # Push the false value onto the stack
        class PushFalse < Base
          define_opcode 39, "push_false"
        end
        
        # ID: 40 (0x28)
        # DESC: Push NaN
        # STACK: ... => ..., NaN
        # Push the NaN value onto the stack
        class PushNaN < Base
          define_opcode 40, "push_nan"
        end
        
        # ID: 41 (0x29)
        # DESC: Pop the top value from the stack
        # STACK: ..., value => ...
        # Pops the top value from the stack and discards it.
        class Pop < Base
          define_opcode 41, "pop"
        end
        
        # ID: 42 (0x2A)
        # DESC: Duplicates the top value on the stack
        # STACK: ..., value => ..., value, value
        # Duplicates the top value of the stack, and then pushes the duplicated value onto the stack.
        class Dup < Base
          define_opcode 42, "dup"
        end
        
        # ID: 43 (0x2B)
        # DESC: Swap the top two operands on the stack
        # STACK: ..., value1, value2 => ..., value2, value1
        # Swap the top two values on the stack. Pop value2 and value1. Push value2, then push value1. 
        class Swap < Base
          define_opcode 43, "swap"
        end
        
        # ID: 44 (0x2C)
        # DESC: Push a string value
        # STACK: ... => ..., value
        # index is a u30 that must be an index into the string constant pool. The string value at index 
        # in the string constant pool is pushed onto the stack.
        class PushString < Base
          define_opcode 44, "push_string"
          
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.strings[index]}"
          end
        end
        
        # ID: 45 (0x2D)
        # DESC: Push a string value
        # STACK: ... => ..., value
        # index is a u30 that must be an index into the integer constant pool. The int value at index in 
        # the integer constant pool is pushed onto the stack.
        class PushInt < Base
          define_opcode 45, "push_int"
          
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.ints[index]}"
          end
        end
        
        # ID: 46 (0x2E)
        # DESC: Push an unsigned int value onto the stack
        # STACK: ... => ..., value
        # index is a u30 that must be an index into the unsigned integer constant pool. The value at 
        # index in the unsigned integer constant pool is pushed onto the stack.
        class PushUInt < Base
          define_opcode 46, "push_uint"
          
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.uints[index]}"
          end
        end
        
        # ID: 47 (0x2F)
        # DESC: Push a double value
        # STACK: ... => ..., value
        # index is a u30 that must be an index into the double constant pool. The double value at 
        # index in the double constant pool is pushed onto the stack.
        class PushDouble < Base
          define_opcode 47, "push_double"
          
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.doubles[index]}"
          end
        end
        
        # ID: 48 (0x30)
        # DESC: Push an object onto the scope stack
        # STACK: ..., value => ...
        # Pop value off of the stack. Push value onto the scope stack.
        class PushScope < Base
          define_opcode 48, "push_scope"
        end
        
        # ID: 49 (0x31)
        # DESC: Push a namespace
        # STACK: ... => ..., namespace
        # index is a u30 that must be an index into the namespace constant pool. The namespace value 
        # at index in the namespace constant pool is pushed onto the stack. 
        class PushNamespace < Base
          define_opcode 49, "push_namespace"
          
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.namespaces[index]}"
          end
        end
      end
    end
  end
end