module ARuby
  class SWF
    class ABC
      module OpCode

        # ID: 145 (0x91)
        # DESC: Increment a value
        # Pop value off of the stack. Convert value to a Number using the ToNumber algorithm
        # (ECMA-262 section 9.3) and then add 1 to the Number value. Push the result onto the
        # stack
        class Increment < Base
          define_opcode 145, "increment"
        end

        # ID: 146 (0x92)
        # DESC: Increment a local register value
        # index is a u30 that must be an index of a local register. The value of the local register at index
        # is converted to a Number using the ToNumber algorithm (ECMA-262 section 9.3) and
        # then 1 is added to the Number value. The local register at index is then set to the result
        class IncLocal < Base
          define_opcode 146, "increment_local"
          define_format do
            struct :index, :type => :u30
          end
        end



        # ID: 147 (0x93)
        # DESC: Decrement a value
        # Pop value off of the stack. Convert value to a Number using the ToNumber algorithm
        # (ECMA-262 section 9.3) and then subtract 1 from the Number value. Push the result onto
        # the stack
        class Decrement < Base
          define_opcode 147, "decrement"
        end

        # ID: 148 (0x94)
        # DESC: Decrement a local register value
        # index is a u30 that must be an index of a local register. The value of the local register at index
        # is converted to a Number using the ToNumber algorithm (ECMA-262 section 9.3) and
        # then 1 is subtracted from the Number value. The local register at index is then set to the
        # result
        class DecLocal < Base
          define_opcode 148, "decrement_local"
          define_format do
            struct :index, :type => :u30
          end
        end





        # ID: 160 (0xA0)
        # DESC: Add two values
        # Pop value1 and value2 off of the stack and add them together as specified in ECMA-262 section
        # 11.6 and as extended in ECMA-357 section 11.4. The algorithm is briefly described below.
        # 1. If value1 and value2 are both Numbers, then set value3 to the result of adding the two
        # number values. See ECMA-262 section 11.6.3 for a description of adding number values.
        # 2. If value1 or value2 is a String or a Date, convert both values to String using the ToString
        # algorithm described in ECMA-262 section 9.8. Concatenate the string value of value2 to the
        # string value of value1 and set value3 to the new concatenated String.
        # 3. If value1 and value2 are both of type XML or XMLList, construct a new XMLList object,
        # then call [[Append]](value1), and then [[Append]](value2). Set value3 to the new XMLList.
        # See ECMA-357 section 9.2.1.6 for a description of the [[Append]] method.
        # 4. If none of the above apply, convert value1 and value2 to primitives. This is done by calling
        # ToPrimitive with no hint. This results in value1_primitive and value2_primitive. If
        # value1_primitive or value2_primitive is a String then convert both to Strings using the
        # ToString algorithm (ECMA-262 section 9.8), concatenate the results, and set value3 to the
        # concatenated String. Otherwise convert both to Numbers using the ToNumber algorithm
        # (ECMA-262 section 9.3), add the results, and set value3 to the result of the addition
        class Add < Base
          define_opcode 160, "add"
        end

        # ID: 161 (0xA1)
        # DESC: subtract one value from another
        # Pop value1 and value2 off of the stack and convert value1 and value2 to Number to create
        # value1_number and value2_number. Subtract value2_number from value1_number. Push the
        # result onto the stack
        class Subtract < Base
          define_opcode 161, "subtract"
        end

        # ID: 162 (0xA2)
        # DESC: Multiply two values
        # Pop value1 and value2 off of the stack, convert value1 and value2 to Number to create
        # value1_number and value2_number. Multiply value1_number by value2_number and push
        # the result onto the stack
        class Multiply < Base
          define_opcode 162, "multiply"
        end

        # ID: 163 (0xA3)
        # DESC: Divide two values
        # Pop value1 and value2 off of the stack, convert value1 and value2 to Number to create
        # value1_number and value2_number. Divide value1_number by value2_number and push the
        # result onto the stack
        class Divide < Base
          define_opcode 163, "divide"
        end




        # ID: 194 (0xC2)
        # DESC: Increment a local register value
        # index is a u30 that must be an index of a local register. The value of the local register at index
        # is converted to an int using the ToInt32 algorithm (ECMA-262 section 9.5) and then 1 is
        # added to the int value. The local register at index is then set to the result.
        class IncLocalI < Base
          define_opcode 194, "increment_local_i"
          define_format do
            struct :index, :type => :u30
          end
        end
      end
    end
  end
end
