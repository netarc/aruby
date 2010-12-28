module ARuby
  class SWF
    class ABC
      module OpCode

        class Base < StructuredObject
          struct do
            ui8 :id
          end

          attr_accessor :name

          CODES = {}
          CLASSES = {}
          SIZES = {}

          def initialize(*args)
            @abc_file = args[0]
            vals = args[1] || {}
            op_data = Base.find_opcode_data_by_class(self.class)
            # self.id = op_data[:id]
            self.name = op_data[:name]
            vals.each_pair do |k, v|
              self.send :"#{k}=", v
            end
          end

          def serialize io=nil
            # puts "serialize<#{@name}> #{super.buffer.size}"
            if io
              serialize_struct io
            else
              super.buffer
            end
          end

          def unserialize(io=nil)
            unserialize_struct io
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
          
          def inspect
            self.to_s
          end
        end


        # ID: 96 (0x60)
        # DESC: index is a u30 that must be an index into the multiname constant pool. The multiname at
        # index must not be a runtime multiname, so there are never any optional namespace or name
        # values on the stack
        class GetLex < Base
          define_opcode 96, "get_lex"
          struct do
            u30 :index
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
          struct do
            u30 :index
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
          struct do
            u30 :index
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
          struct do
            u30 :index
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
          struct do
            u30 :index
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
          struct do
            u30 :index
          end

          def to_s
            super " index=#{index}"
          end
        end


      end
    end
  end
end

require 'aruby/swf/abc/opcode/register'
require 'aruby/swf/abc/opcode/arithmetic'
require 'aruby/swf/abc/opcode/bitwise'
require 'aruby/swf/abc/opcode/type'
require 'aruby/swf/abc/opcode/object'
require 'aruby/swf/abc/opcode/stack'
require 'aruby/swf/abc/opcode/control'
require 'aruby/swf/abc/opcode/function'
require 'aruby/swf/abc/opcode/debugging'