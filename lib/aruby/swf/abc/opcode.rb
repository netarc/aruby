module ARuby
  class SWF
    class ABC
      module OpCode

        class Base < StructuredObject
          define_format do
            struct :id, :type => :ui8
          end


          attr_accessor :name

          CODES = {}
          CLASSES = {}
          SIZES = {}

          def initialize(*args)
            abc_file = args[0]
            vals = args[1] || {}
            super nil
            @abc_file = abc_file
            op_data = Base.find_opcode_data_by_class(self.class)
            self.id = op_data[:id]
            self.name = op_data[:name]
            vals.each_pair do |k, v|
              self.send :"#{k}=", v
            end
          end

          def serialize io=nil
            # puts "serialize<#{@name}> #{super.buffer.size}"
            if io
              super io
            else
              super.buffer
            end
          end

          def unserialize io=nil
            super io, [:id]
          end

          def self.id
            CLASSES[self]
          end

          def self.define_opcode id, name
            CODES[id] = {:id => id, :name => name, :klass => self}
            CLASSES[self] = id
          end

          def self.find_class_by_id id
            return CODES[id] ? CODES[id][:klass] : nil
          end

          def self.find_opcode_data_by_class(klass)
            return CLASSES[klass] ? CODES[CLASSES[klass]] : nil
          end

          def size
            if SIZES[self.class]
              return SIZES[self.class]
            else
              SIZES[self.class] = self.serialize.size
            end
          end

          def to_s inner=""
            "<#{@name.upcase}#{inner}>"
          end
        end





        # ID: 8 (0x08)
        # DESC: Kills a local register
        # index is a u30 that must be an index of a local register. The local register at index is killed. It
        # is killed by setting its value to undefined
        class Kill < Base
          define_opcode 8, "kill"
          define_format do
            struct :index, :type => :u30
          end
        end



        # ID: 9 (0x09)
        # DESC: Do nothing. Used to indicate that this location is the target of a branch
        class Label < Base
          define_opcode 9, "label"
        end


        # ID: 16 (0x10)
        # DESC: offset is an s24 that is the number of bytes to jump. Jump the number of bytes indicated by
        # offset and resume execution there
        class Jump < Base
          define_opcode 16, "jump"
          define_format do
            struct :offset, :type => :si24
          end

          def to_s
            super " offset=#{offset}"
          end
        end


        # ID: 19 (0x13)
        # DESC: offset is an s24 that is the number of bytes to jump if value1 is equal to value2.
        # Compute value1 == value2 using the abstract equality comparison algorithm
        # If the result of the comparison is true, jump
        # the number of bytes indicated by offset. Otherwise continue executing code from this point
        class IFEQ < Base
          define_opcode 19, "if_equal"
          define_format do
            struct :offset, :type => :si24
          end

          def to_s
            super " offset=#{offset}"
          end
        end


        # ID: 20 (0x14)
        # DESC: offset is an s24 that is the number of bytes to jump if value1 is not equal to value2.
        # Compute value1 == value2 using the abstract equality comparison algorithm
        # If the result of the comparison is false, jump the number of bytes indicated by offset.
        # Otherwise continue executing code from this point
        class IFNE < Base
          define_opcode 20, "if_not_equal"
          define_format do
            struct :offset, :type => :si24
          end

          def to_s
            super " offset=#{offset}"
          end
        end

        # ID: 21 (0x15)
        # DESC: offset is an s24 that is the number of bytes to jump if value1 is less than value2.
        # Compute value1 < value2 using the abstract relational comparison algorithm.  If the result
        # of the comparison is true, jump the number of bytes indicated by offset. Otherwise continue
        # executing code from this point
        class IFLT < Base
          define_opcode 21, "if_less_than"
          define_format do
            struct :offset, :type => :si24
          end

          def to_s
            super " offset=#{offset}"
          end
        end

        # ID: 23 (0x17)
        # DESC: offset is an s24 that is the number of bytes to jump if value1 is greater than or equal to value2.
        # Compute value2 < value1 using the abstract relational comparison algorithm
        # If the result of the comparison is true, jump the number of bytes indicated
        # by offset. Otherwise continue executing code from this point
        class IFGT < Base
          define_opcode 23, "if_greater_than"
          define_format do
            struct :offset, :type => :si24
          end

          def to_s
            super " offset=#{offset}"
          end
        end



        # ID: 29 (0x1D)
        # DESC: Pop the top scope off of the scope stack and discards it
        class PopScope < Base
          define_opcode 29, "pop_scope"
        end

        # ID: 32 (0x20)
        # DESC: Push the null value onto the stack
        class PushNull < Base
          define_opcode 32, "push_null"
        end

        # ID: 36 (0x24)
        # DESC: Push the false value onto the stack
        class PushByte < Base
          define_opcode 36, "push_byte"
          define_format do
            struct :value, :type => :si8
          end

          def to_s
            super " value=#{value}"
          end
        end

        # ID: 37 (0x25)
        # DESC: Push the value onto the stack
        class PushShort < Base
          define_opcode 37, "push_short"
          define_format do
            struct :value, :type => :u30
          end

          def to_s
            super " value=#{value}"
          end
        end

        # ID: 38 (0x26)
        # DESC: Push the false value onto the stack
        class PushTrue < Base
          define_opcode 38, "push_true"
        end

        # ID: 39 (0x27)
        # DESC: Push the false value onto the stack
        class PushFalse < Base
          define_opcode 39, "push_false"
        end

        # ID: 42 (0x2A)
        # DESC: Duplicates the top value of the stack, and then pushes the duplicated value onto the stack
        class Dup < Base
          define_opcode 42, "dup"
        end


        # ID: 44 (0x2C)
        # DESC: Push the string onto the stack
        class PushString < Base
          define_opcode 44, "push_string"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.strings[index]}"
          end
        end

        # ID: 45 (0x2D)
        # DESC: Push an int value onto the stack
        # index is a u30 that must be an index into the integer constant pool. The int value at index in
        # the integer constant pool is pushed onto the stack.
        class PushInt < Base
          define_opcode 45, "push_int"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.ints[index]}"
          end
        end


        # ID: 48 (0x30)
        # DESC: Push an object onto the scope stack
        class PushScope < Base
          define_opcode 48, "push_scope"
        end


        # ID: 64 (0x40)
        # DESC: index is a u30 that must be an index of a method_info. A new function object is created
        # from that method_info and pushed onto the stack.
        # When creating the new function object the scope stack used is the current scope stack when
        # this instruction is executed, and the body is the method_body entry that references the
        # specified method_info entry
        class NewFunction < Base
          define_opcode 64, "new_function"
          define_format do
            struct :index, :type => :u30
          end
        end

        # ID: 67 (0x43)
        # DESC: Call a method identified by index in the object’s method table
        # index is a u30 that is the index of the method to invoke on receiver. arg_count is a u30 that is
        # the number of arguments present on the stack. receiver is the object to invoke the method on.
        # The method at position index on the object receiver, is invoked with the arguments receiver,
        # arg1, ..., argn. The result of the method call is pushed onto the stack
        class CallMethod < Base
          define_opcode 67, "call_method"
          define_format do
            struct :index, :type => :u30
            struct :arg_count, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]} arg_count=#{arg_count}"
          end
        end


        # ID: 70 (0x46)
        # DESC: Call a property
        # arg_count is a u30 that is the number of arguments present on the stack. The number of
        # arguments specified by arg_count are popped off the stack and saved.
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at
        # that index is a runtime multiname the name and/or namespace will also appear on the stack
        # so that the multiname can be constructed correctly at runtime.
        # obj is the object to resolve and call the property on.
        # The property specified by the multiname at index is resolved on the object obj. The [[Call]]
        # property is invoked on the value of the resolved property with the arguments obj, arg1, ...,
        # argn. The result of the call is pushed onto the stack
        class CallProperty < Base
          define_opcode 70, "call_property"
          define_format do
            struct :index, :type => :u30
            struct :arg_count, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]} arg_count=#{arg_count}"
          end
        end


        # ID: 71 (0x47)
        # DESC: Return from the currently executing method. This returns the value undefined. If the
        # method has a return type, then undefined is coerced to that type and then returned
        class ReturnVoid < Base
          define_opcode 71, "return_void"
        end

        # ID: 72 (0x48)
        # DESC: Return from the currently executing method. This returns the top value on the stack.
        # return_value is popped off of the stack, and coerced to the expected return type of the
        # method. The coerced value is what is actually returned from the method
        class ReturnValue < Base
          define_opcode 72, "return_value"
        end


        # ID: 73 (0x49)
        # DESC: arg_count is a u30 that is the number of arguments present on the stack. This will invoke the constructor on the base class of object with the given arguments
        class ConstructSuper < Base
          define_opcode 73, "construct_super"
          define_format do
            struct :arg_count, :type => :u30
          end

          def to_s
            super " arg_count=#{arg_count}"
          end
        end

        # ID: 74 (0x4A)
        # DESC: arg_count is a u30 that is the number of arguments present on the stack. The number of
        # arguments specified by arg_count are popped off the stack and saved.
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at
        # that index is a runtime multiname the name and/or namespace will also appear on the stack
        # so that the multiname can be constructed correctly at runtime
        class ConstructProp < Base
          define_opcode 74, "construct_prop"
          define_format do
            struct :index, :type => :u30
            struct :arg_count, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]} arg_count=#{arg_count}"
          end
        end


        # ID: 79 (0x4F)
        # DESC: Call a property, discarding the return value
        # arg_count is a u30 that is the number of arguments present on the stack. The number of
        # arguments specified by arg_count are popped off the stack and saved.
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at
        # that index is a runtime multiname the name and/or namespace will also appear on the stack
        # so that the multiname can be constructed correctly at runtime
        class CallPropVoid < Base
          define_opcode 79, "call_prop_void"
          define_format do
            struct :index, :type => :u30
            struct :arg_count, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]} arg_count=#{arg_count}"
          end
        end


        # ID: 86 (0x56)
        # DESC: arg_count is a u30 that is the number of entries that will be created in the new array. There
        # will be a total of arg_count values on the stack
        class NewArray < Base
          define_opcode 86, "new_array"
          define_format do
            struct :arg_count, :type => :u30
          end

          def to_s
            super " arg_count=#{arg_count}"
          end
        end


        # ID: 88 (0x58)
        # DESC: index is a u30 that is an index of the ClassInfo that is to be created. basetype must be the
        # base class of the class being created, or null if there is no base class.
        # The class that is represented by the ClassInfo at position index of the ClassInfo entries is
        # created with the given basetype as the base class. This will run the static initializer function
        # for the class. The new class object, newclass, will be pushed onto the stack.
        # When this instruction is executed, the scope stack must contain all the scopes of all base
        # classes, as the scope stack is saved by the created ClassClosure
        class NewClass < Base
          define_opcode 88, "new_class"
          define_format do
            struct :index, :type => :u30
          end
        end

        # ID: 93 (0x5D)
        # DESC: Find a property
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at
        # that index is a runtime multiname the name and/or namespace will also appear on the stack
        # so that the multiname can be constructed correctly at runtime.
        # This searches the scope stack, and then the saved scope in the method closure, for a property
        # with the name specified by the multiname at index.
        # If any of the objects searched is a with scope, its declared and dynamic properties will be
        # searched for a match. Otherwise only the declared traits of a scope will be searched. The
        # global object will have its declared traits, dynamic properties, and prototype chain searched.
        # If the property is resolved then the object it was resolved in is pushed onto the stack. If the
        # property is unresolved in all objects on the scope stack then an exception is thrown
        class FindPropStrict < Base
          define_opcode 93, "find_prop_strict"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end


        # ID: 94 (0x5E)
        # DESC: Search the scope stack for a property
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at
        # that index is a runtime multiname the name and/or namespace will also appear on the stack
        # so that the multiname can be constructed correctly at runtime.
        # This searches the scope stack, and then the saved scope in the current method closure, for a
        # property with the name specified by the multiname at index.
        # If any of the objects searched is a with scope, its declared and dynamic properties will be
        # searched for a match. Otherwise only the declared traits of a scope will be searched. The
        # global object will have its declared traits, dynamic properties, and prototype chain searched.
        # If the property is resolved then the object it was resolved in is pushed onto the stack. If the
        # property is unresolved in all objects on the scope stack then the global object is pushed onto
        # the stack.
        class FindProperty < Base
          define_opcode 94, "find_property"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end



        # ID: 96 (0x60)
        # DESC: index is a u30 that must be an index into the multiname constant pool. The multiname at
        # index must not be a runtime multiname, so there are never any optional namespace or name
        # values on the stack
        class GetLex < Base
          define_opcode 96, "get_lex"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end

        # ID: 97 (0x61)
        # DESC: value is popped off the stack and saved.
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at
        # that index is a runtime multiname the name and/or namespace will also appear on the stack
        # so that the multiname can be constructed correctly at runtime
        class SetProperty < Base
          define_opcode 97, "set_property"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end



        # ID: 100 (0x64)
        # DESC: Gets the global scope
        # Gets the global scope object from the scope stack, and pushes it onto the stack. The global
        # scope object is the object at the bottom of the scope stack
        class GetGlobalScope < Base
          define_opcode 100, "get_global_scope"
        end




        # ID: 101 (0x65)
        # DESC: index is an unsigned byte that specifies the index of the scope object to retrieve from the local
        # scope stack. index must be less than the current depth of the scope stack. The scope at that
        # index is retrieved and pushed onto the stack. The scope at the top of the stack is at index
        # scope_depth-1, and the scope at the bottom of the stack is index 0
        class GetScopeObject < Base
          define_opcode 101, "get_scope_object"
          define_format do
            struct :index, :type => :u30
          end
        end

        # ID: 102 (0x66)
        # DESC: index is a u30 that must be an index into the multiname constant pool. If the multiname at
        # that index is a runtime multiname the name and/or namespace will also appear on the stack
        # so that the multiname can be constructed correctly at runtime.
        # The property with the name specified by the multiname will be resolved in object, and the
        # value of that property will be pushed onto the stack. If the property is unresolved,
        # undefined is pushed onto the stack
        class GetProperty < Base
          define_opcode 102, "get_property"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end


        # ID: 104 (0x68)
        # DESC: value is the value that the property will be set to. value is popped off the stack and saved.
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at
        # that index is a runtime multiname the name and/or namespace will also appear on the stack
        # so that the multiname can be constructed correctly at runtime.
        # The property with the name specified by the multiname will be resolved in object, and will be
        # set to value. This is used to initialize properties in the initializer method. When used in an
        # initializer method it is able to set the value of const properties
        class InitProperty < Base
          define_opcode 104, "init_property"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end

        # ID: 108 (0x6C)
        # DESC: Get the value of a slot
        # slotindex is a u30 that must be an index of a slot on obj. slotindex must be less than the total
        # number of slots obj has.
        # This will retrieve the value stored in the slot at slotindex on obj. This value is pushed onto the
        # stack
        class GetSlot < Base
          define_opcode 108, "get_slot"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}"
          end
        end



        # ID: 115 (0x73)
        # DESC: value is popped off of the stack and converted to an integer. The result, intvalue,
        # is pushed onto the stack
        class ConvertI < Base
          define_opcode 115, "convert_i"
        end

        # ID: 116 (0x74)
        # DESC: value is popped off of the stack and converted to an unsigned integer. The result, uintvalue,
        # is pushed onto the stack
        class ConvertU < Base
          define_opcode 116, "convert_u"
        end

        # ID: 117 (0x75)
        # DESC: value is popped off of the stack and converted to a double. The result, doublevalue, is pushed
        # onto the stack
        class ConvertD < Base
          define_opcode 117, "convert_d"
        end


        # ID: 128 (0x80)
        # DESC: index is a u30 that must be an index into the multiname constant pool. The multiname at
        # index must not be a runtime multiname.
        # The type specified by the multiname is resolved, and value is coerced to that type. The
        # resulting value is pushed onto the stack. If any of value’s base classes, or implemented
        # interfaces matches the type specified by the multiname, then the conversion succeeds and the
        # result is pushed onto the stack
        class Coerce < Base
          define_opcode 128, "coerce"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end

        # ID: 130 (0x82)
        # DESC: Indicates to the verifier that the value on the stack is of the any type (*). Does nothing to value
        class CoerceA < Base
          define_opcode 130, "coerce_a"
        end







        # ID: 239 (0xEF)
        # DESC: debug_type is an unsigned byte. If the value of debug_type is DI_LOCAL (1), then this is
        # debugging information for a local register.
        # index is a u30 that must be an index into the string constant pool. The string at index is the
        # name to use for this register.
        # reg is an unsigned byte and is the index of the register that this is debugging information for.
        # extra is a u30 that is currently unused
        # When debug_type has a value of 1, this tells the debugger the name to display for the register
        # specified by reg. If the debugger is not running, then this instruction does nothing
        class Debug < Base
          define_opcode 239, "debug"
          define_format do
            struct :type, :type => :ui8
            struct :index, :type => :u30
            struct :reg, :type => :ui8
            struct :extra, :type => :u30
          end

          def to_s
            super " type=#{type} index=#{index}||#{@abc_file.strings[index]}"
          end
        end

        # ID: 240 (0xF0)
        # DESC: value is a u30 that indicates the current line number the debugger should be using for the
        # code currently executing.
        # If the debugger is running, then this instruction sets the current line number in the
        # debugger. This lets the debugger know which instructions are associated with each line in a
        # source file. The debugger will treat all instructions as occurring on the same line until a new
        # debugline opcode is encountered
        class DebugLine < Base
          define_opcode 240, "debug_line"
          define_format do
            struct :value, :type => :u30
          end

          def to_s
            super " value=#{value}"
          end
        end

        # ID: 241 (0xF1)
        # DESC: index is a u30 that must be an index into the string constant pool
        # If the debugger is running, then this instruction sets the current file name in the debugger to
        # the string at position index of the string constant pool. This lets the debugger know which
        # instructions are associated with each source file. The debugger will treat all instructions as
        # occurring in the same file until a new debugfile opcode is encountered.
        # This instruction must occur before any debugline opcodes
        class DebugFile < Base
          define_opcode 241, "debug_file"
          define_format do
            struct :index, :type => :u30
          end

          def to_s
            super " index=#{index}||#{@abc_file.strings[index]}"
          end
        end
      end
    end
  end
end

require 'aruby/swf/abc/opcode/load_store'
require 'aruby/swf/abc/opcode/arithmetic'
