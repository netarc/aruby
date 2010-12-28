module ARuby
  class SWF
    class ABC
      module OpCode
        # ID: 115 (0x73)
        # DESC: Convert a value to an integer
        # STACK: …, value => …, intvalue
        # value is popped off of the stack and converted to an integer. The result, intvalue, is pushed 
        # onto the stack. This uses the ToInt32 algorithm, as described in ECMA-262 section 9.5, to 
        # perform the conversion
        class ConvertI < Base
          define_opcode 115, "convert_i"
        end

        # ID: 116 (0x74)
        # DESC: Convert a value to an unsigned integer
        # STACK: …, value => …, uintvalue
        # value is popped off of the stack and converted to an unsigned integer. The result, uintvalue, 
        # is pushed onto the stack. This uses the ToUint32 algorithm, as described in ECMA-262 
        # section 9.6
        class ConvertU < Base
          define_opcode 116, "convert_u"
        end

        # ID: 117 (0x75)
        # DESC: Convert a value to a Double
        # STACK: …, value => …, doublevalue
        # value is popped off of the stack and converted to a double. The result, doublevalue, is pushed 
        # onto the stack. This uses the ToNumber algorithm, as described in ECMA-262 section 9.3, 
        # to perform the conversion
        class ConvertD < Base
          define_opcode 117, "convert_d"
        end
        
        # ID: 118 (0x76)
        # DESC: Convert a value to a Boolean
        # STACK: …, value => …, booleanvalue
        # value is popped off of the stack and converted to a Boolean. The result, booleanvalue, is 
        # pushed onto the stack. This uses the ToBoolean algorithm, as described in ECMA-262 
        # section 9.2, to perform the conversion
        class ConvertB < Base
          define_opcode 118, "convert_b"
        end
        
        # ID: 119 (0x77)
        # DESC: Convert a value to a Object
        # STACK: …, value => …, value
        # If value is an Object then nothing happens.  Otherwise an exception is thrown
        class ConvertO < Base
          define_opcode 119, "convert_o"
        end
        
        # ID: 128 (0x80)
        # DESC: Coerce a value to a specified type
        # STACK: …, value => …, coercedvalue…
        # index is a u30 that must be an index into the multiname constant pool. The multiname at 
        # index must not be a runtime multiname.  
        # The type specified by the multiname is resolved, and value is coerced to that type. The 
        # resulting value is pushed onto the stack. If any of value’s base classes, or implemented 
        # interfaces matches the type specified by the multiname, then the conversion succeeds and the 
        # result is pushed onto the stack. 
        class Coerce < Base
          define_opcode 128, "coerce"
          struct do
            u30 :index
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end

        # ID: 130 (0x82)
        # DESC: Coerce a value to the any type
        # STACK: …, value => …, value
        # Indicates to the verifier that the value on the stack is of the any type (*). Does nothing to value
        class CoerceA < Base
          define_opcode 130, "coerce_a"
        end
        
        # ID: 133 (0x85)
        # DESC: Coerce a value to a string
        # STACK: …, value => …, stringvalue
        # value is popped off of the stack and coerced to a String. If value is null or undefined, then 
        # stringvalue is set to null. Otherwise stringvalue is set to the result of the ToString algorithm, 
        # as specified in ECMA-262 section 9.8. stringvalue is pushed onto the stack.
        # This opcode is very similar to the convert_s opcode. The difference is that convert_s will 
        # convert a null or undefined value to the string "null" or "undefined" whereas coerce_s 
        # will convert those values to the null value. 
        class CoerceS < Base
          define_opcode 133, "coerce_s"
        end
      end
    end
  end
end