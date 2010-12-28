module ARuby
  class SWF
    class ABC
      module OpCode
        # ID: 151 (0x97)
        # DESC: Bitwise not
        # STACK: ..., value => ..., ~value
        # Pop value off of the stack. Convert value to an integer, as per ECMA-262 section 11.4.8, 
        # and then apply the bitwise complement operator (~) to the integer. Push the result onto the stack
        class BitNOT < Base
          define_opcode 151, "bit_not"
        end

        # ID: 165 (0xA5)
        # DESC: Bitwise left shift
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack; convert value1 to an int to create value1_int ; and 
        # convert value2 to a uint to create value2_uint. Left shift value1_int by the result of 
        # value2_uint & 0x1F (leaving only the 5 least significant bits of value2_uint), and push the 
        # result onto the stack. See ECMA-262 section 11.7.1.
        class LShift < Base
          define_opcode 165, "lshift"
        end
        
        # ID: 166 (0xA6)
        # DESC: Bitwise right shift
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack, convert value1 to an int to create value1_int and 
        # convert value2 to a uint to create value2_uint. Right shift value1_int by the result of 
        # value2_uint & 0x1F (leaving only the 5 least significant bits of value2_uint), and push the 
        # result onto the stack. The right shift is sign extended, resulting in a signed 32-bit integer. See 
        # ECMA-262 section 11.7.2 
        class RShift < Base
          define_opcode 166, "rshift"
        end
        
        # ID: 167 (0xA7)
        # DESC: Unsigned bitwise right shift
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack, convert value1 to an int to create value1_int and 
        # convert value2 to a uint to create value2_uint. Right shift value1_int by the result of 
        # value2_uint & 0x1F (leaving only the 5 least significant bits of value2_uint), and push the 
        # result onto the stack. The right shift is unsigned and fills in missing bits with 0, resulting in 
        # an unsigned 32-bit integer. See ECMA-262 section 11.7.3
        class URShift < Base
          define_opcode 167, "urshift"
        end
        
        # ID: 168 (0xA8)
        # DESC: Bitwise and
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack. Convert value1 and value2 to integers, as per ECMA- 
        # 262 section 11.10, and perform a bitwise and (&) on the two resulting integer values. Push 
        # the result onto the stack. 
        class BitAND < Base
          define_opcode 168, "bit_and"
        end
        
        # ID: 169 (0xA9)
        # DESC: Bitwise or
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack. Convert value1 and value2 to integers, as per ECMA- 
        # 262 section 11.10, and perform a bitwise or (|) on the two resulting integer values. Push the 
        # result onto the stack.  
        class BitOR < Base
          define_opcode 169, "bit_or"
        end
        
        # ID: 170 (0xAA)
        # DESC: Bitwise exclusive or
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack. Convert value1 and value2 to integers, as per ECMA- 
        # 262 section 11.10, and perform a bitwise exclusive or (^) on the two resulting integer values. 
        # Push the result onto the stack.
        class BitXOR < Base
          define_opcode 170, "bit_xor"
        end
      end
    end
  end
end