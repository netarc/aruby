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
          
          def initialize(*args)
            super
            @abc_file = args[0]
            vals = args[1] || {}
            op_data = Base.find_opcode_data_by_class(self.class)
            self.id = op_data[:id]
            self.name = op_data[:name]
            vals.each_pair do |k, v|
              self.send :"#{k}=", v
            end
          end

          def size
            if SIZES[self.class]
              return SIZES[self.class]
            else
              SIZES[self.class] = self.serialize_struct.size
            end
          end

          def to_s inner=""
            "<#{@name.upcase}#{inner}>"
          end
          
          def inspect
            self.to_s
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
require 'aruby/swf/abc/opcode/property'
require 'aruby/swf/abc/opcode/debugging'