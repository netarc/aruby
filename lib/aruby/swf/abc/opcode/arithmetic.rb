module ARuby
  class SWF
    class ABC
      module OpCode
        # ID: 144 (0x90)
        # DESC: Negate an integer value
        # STACK: ..., value => ..., -value 
        # Pop value off of the stack. Convert value to a Number using the ToNumber algorithm 
        # (ECMA-262 section 9.3) and then negate the Number value. Push the result onto the stack.  
        class Negate < Base
          define_opcode 144, "negate"
        end
        
        # ID: 145 (0x91)
        # DESC: Increment a value
        # STACK: ..., value => ..., incrementedvalue
        # Pop value off of the stack. Convert value to a Number using the ToNumber algorithm
        # (ECMA-262 section 9.3) and then add 1 to the Number value. Push the result onto the
        # stack
        class Increment < Base
          define_opcode 145, "increment"
        end

        # ID: 146 (0x92)
        # DESC: Increment a local register value
        # STACK: ... => ...
        # index is a u30 that must be an index of a local register. The value of the local register at index
        # is converted to a Number using the ToNumber algorithm (ECMA-262 section 9.3) and
        # then 1 is added to the Number value. The local register at index is then set to the result
        class IncLocal < Base
          define_opcode 146, "increment_local"
          struct do
            u30 :index
          end
        end

        # ID: 147 (0x93)
        # DESC: Decrement a value
        # STACK: ..., value => ..., decrementedvalue
        # Pop value off of the stack. Convert value to a Number using the ToNumber algorithm
        # (ECMA-262 section 9.3) and then subtract 1 from the Number value. Push the result onto
        # the stack
        class Decrement < Base
          define_opcode 147, "decrement"
        end

        # ID: 148 (0x94)
        # DESC: Decrement a local register value
        # STACK: ... => ...
        # index is a u30 that must be an index of a local register. The value of the local register at index
        # is converted to a Number using the ToNumber algorithm (ECMA-262 section 9.3) and
        # then 1 is subtracted from the Number value. The local register at index is then set to the
        # result
        class DecLocal < Base
          define_opcode 148, "decrement_local"
          struct do
            u30 :index
          end
        end

        # ID: 160 (0xA0)
        # DESC: Add two values
        # STACK: ..., value1, value2 => ..., value3
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
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack and convert value1 and value2 to Number to create
        # value1_number and value2_number. Subtract value2_number from value1_number. Push the
        # result onto the stack
        class Subtract < Base
          define_opcode 161, "subtract"
        end

        # ID: 162 (0xA2)
        # DESC: Multiply two values
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack, convert value1 and value2 to Number to create
        # value1_number and value2_number. Multiply value1_number by value2_number and push
        # the result onto the stack
        class Multiply < Base
          define_opcode 162, "multiply"
        end

        # ID: 163 (0xA3)
        # DESC: Divide two values
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack, convert value1 and value2 to Number to create
        # value1_number and value2_number. Divide value1_number by value2_number and push the
        # result onto the stack
        class Divide < Base
          define_opcode 163, "divide"
        end
        
        # ID: 164 (0xA4)
        # DESC: Perform modulo division on two values
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack, convert value1 and value2 to Number to create 
        # value1_number and value2_number. Perform value1_number mod value2_number and push 
        # the result onto the stack.  
        class Modulo < Base
          define_opcode 164, "modulo"
        end

        # ID: 171 (0xAB)
        # DESC: Compare two values
        # STACK: ..., value1, value2 => ..., result
        # Pop value1 and value2 off of the stack. Compare the two values using the abstract equality 
        # comparison algorithm, as described in ECMA-262 section 11.9.3 and extended in ECMA- 
        # 347 section 11.5.1. Push the resulting Boolean value onto the stack.  
        class Equals < Base
          define_opcode 171, "equals"
        end

        # ID: 172 (0xAC)
        # DESC: Compare two values strictly
        # STACK: ..., value1, value2 => ..., result
        # Pop value1 and value2 off of the stack. Compare the two values using the Strict Equality 
        # Comparison Algorithm as described in ECMA-262 section 11.9.6. Push the resulting 
        # Boolean value onto the stack. 
        class StrictEquals < Base
          define_opcode 172, "strict_equals"
        end
        
        # ID: 173 (0xAD)
        # DESC: Determine if one value is less than another
        # STACK: ..., value1, value2 => ..., result
        # Pop value1 and value2 off of the stack. Compute value1 < value2 using the Abstract 
        # Relational Comparison Algorithm as described in ECMA-262 section 11.8.5. If the result of 
        # the comparison is true, then push true onto the stack. Otherwise push false onto the stack. 
        class LessThan < Base
          define_opcode 173, "less_than"
        end
        
        # ID: 174 (0xAE)
        # DESC: Determine if one value is less than or equal to another
        # STACK: ..., value1, value2 => ..., result
        # Pop value1 and value2 off of the stack. Compute value2 <= value1 using the Abstract 
        # Relational Comparison Algorithm as described in ECMA-262 section 11.8.5. If the result of 
        # the comparison is false, push true onto the stack. Otherwise push false onto the stack.
        class LessEquals < Base
          define_opcode 174, "less_equals"
        end
        
        # ID: 175 (0xAF)
        # DESC: Determine if one value is greater than another
        # STACK: ..., value1, value2 => ..., result
        # Pop value1 and value2 off of the stack. Compute value2 > value1 using the Abstract 
        # Relational Comparison Algorithm as described in ECMA-262 section 11.8.5. If the result of 
        # the comparison is true, push true onto the stack. Otherwise push false onto the stack.
        class GreaterThan < Base
          define_opcode 175, "greater_than"
        end
        
        # ID: 176 (0xB0)
        # DESC: Determine if one value is greater than or equal to another
        # STACK: ..., value1, value2 => ..., result
        # Pop value1 and value2 off of the stack. Compute value2 >= value1 using the Abstract 
        # Relational Comparison Algorithm as described in ECMA-262 section 11.8.5. If the result of 
        # the comparison is true, push true onto the stack. Otherwise push false onto the stack.
        class GreaterEquals < Base
          define_opcode 176, "greater_equals"
        end
        
        # ID: 178 (0xB2)
        # DESC: Check whether an Object is of a certain type
        # STACK: ..., value => ..., result
        # index is a u30 that must be an index into the multiname constant pool. The multiname at 
        # index must not be a runtime multiname.  
        # Resolve the type specified by the multiname. Let indexType refer to that type. Compute the 
        # type of value, and let valueType refer to that type. If valueType is the same as indexType, result 
        # is true. If indexType is a base type of valueType, or an implemented interface of valueType, 
        # then result is true. Otherwise result is set to false. Push result onto the stack.
        class IsType < Base
          define_opcode 178, "is_type"
          struct do
            u30 :index
          end
        end
        
        # ID: 179 (0xB3)
        # DESC: Check whether an Object is of a certain type
        # STACK: ..., value, type => ..., result
        # Compute the type of value, and let valueType refer to that type. If valueType is the same as 
        # type, result is true. If type is a base type of valueType, or an implemented interface of 
        # valueType, then result is true. Otherwise result is set to false. Push result onto the stack.  
        class IsTypeLate < Base
          define_opcode 179, "is_type_late"
        end
        
        # ID: 180 (0xB4)
        # DESC: Determine whether an object has a named property
        # STACK: ..., name, obj => ..., result
        # name is converted to a String, and is looked up in obj. If no property is found, then the 
        # prototype chain is searched by calling [[HasProperty]] on the prototype of obj. If the 
        # property is found result is true. Otherwise result is false. Push result onto the stack.  
        class In < Base
          define_opcode 180, "in"
        end
        
        # ID: 192 (0xC0)
        # DESC: Increment an integer value
        # STACK: ..., value => ..., incrementedvalue
        # Pop value off of the stack. Convert value to an int using the ToInt32 algorithm (ECMA-262 
        # section 9.5) and then add 1 to the int value. Push the result onto the stack.  
        class IncrementI < Base
          define_opcode 192, "increment_i"
        end

        # ID: 193 (0xC1)
        # DESC: Decrement an integer value
        # STACK: ..., value => ..., dencrementedvalue
        # Pop value off of the stack. Convert value to an int using the ToInt32 algorithm (ECMA-262 
        # section 9.5) and then subtract 1 from the int value. Push the result onto the stack. 
        class DecrementI < Base
          define_opcode 193, "decrement_i"
        end
        
        # ID: 194 (0xC2)
        # DESC: Increment a local register value
        # STACK: ... => ...
        # index is a u30 that must be an index of a local register. The value of the local register at index
        # is converted to an int using the ToInt32 algorithm (ECMA-262 section 9.5) and then 1 is
        # added to the int value. The local register at index is then set to the result.
        class IncLocalI < Base
          define_opcode 194, "increment_local_i"
          struct do
            u30 :index
          end
        end
        
        # ID: 195 (0xC3)
        # DESC: Decrement a local register value
        # STACK: ... => ...
        # index is a u30 that must be an index of a local register. The value of the local register at index 
        # is converted to an int using the ToInt32 algorithm (ECMA-262 section 9.5) and then 1 is 
        # subtracted the int value. The local register at index is then set to the result.
        class DecLocalI < Base
          define_opcode 195, "decrement_local_i"
          struct do
            u30 :index
          end
        end
        
        # ID: 196 (0xC4)
        # DESC: Negate an integer value
        # STACK: ..., value => ..., -value
        # Pop value off of the stack. Convert value to an int using the ToInt32 algorithm (ECMA-262 
        # section 9.5) and then negate the int value. Push the result onto the stack.  
        class NegateI < Base
          define_opcode 196, "negate_i"
        end
        
        # ID: 197 (0xC5)
        # DESC: Add two integer values
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack and convert them to int values using the ToInt32 
        # algorithm (ECMA-262 section 9.5). Add the two int values and push the result onto the stack.
        class AddI < Base
          define_opcode 197, "add_i"
        end
        
        # ID: 198 (0xC6)
        # DESC: Subtract an integer value from another integer value
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack and convert value1 and value2 to int to create 
        # value1_int and value2_int. Subtract value2_int from value1_int. Push the result onto the stack.
        class SubtractI < Base
          define_opcode 198, "subtract_i"
        end
        
        # ID: 199 (0xC7)
        # DESC: Multiply two integer values
        # STACK: ..., value1, value2 => ..., value3
        # Pop value1 and value2 off of the stack, convert value1 and value2 to int to create value1_int 
        # and value2_int. Multiply value1_int by value2_int and push the result onto the stack.
        class MultiplyI < Base
          define_opcode 199, "multiply_i"
        end
      end
    end
  end
end
