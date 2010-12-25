module ARuby
  class SWF
    class ABC
      module OpCode
              
        # ID: 98 (0x62)
        # DESC: Get a local register
        # index is a u30 that must be an index of a local register. The value of that register is pushed 
        # onto the stack
        class GetLocal < Base
          define_opcode 98, "get_local"
          define_format do
            struct :index, :type => :u30
          end
        end
      
        # ID: 99 (0x63)
        # DESC: Set a local register
        # index is a u30 that must be an index of a local register. The register at index is set to value, 
        # and value is popped off the stack
        class SetLocal < Base
          define_opcode 99, "set_local"
          define_format do
            struct :index, :type => :u30
          end
        end
      
      
        # ID: 208 (0xD0)
        # DESC: The value at register index 0 is pushed onto the stack
        class GetLocal0 < Base
          define_opcode 208, "get_local_0"
        end

        # ID: 209 (0xD1)
        # DESC: The value at register index 1 is pushed onto the stack
        class GetLocal1 < Base
          define_opcode 209, "get_local_1"
        end

        # ID: 210 (0xD2)
        # DESC: The value at register index 2 is pushed onto the stack
        class GetLocal2 < Base
          define_opcode 210, "get_local_2"
        end

        # ID: 211 (0xD3)
        # DESC: The value at register index 3 is pushed onto the stack
        class GetLocal3 < Base
          define_opcode 211, "get_local_3"
        end
      
        # ID: 212 (0xD4)
        # DESC: Value is popped off the stack and set at register index 0
        class SetLocal0 < Base
          define_opcode 212, "set_local_0"
        end

        # ID: 213 (0xD5)
        # DESC: Value is popped off the stack and set at register index 1
        class SetLocal1 < Base
          define_opcode 213, "set_local_1"
        end

        # ID: 214 (0xD6)
        # DESC: Value is popped off the stack and set at register index 2
        class SetLocal2 < Base
          define_opcode 214, "set_local_2"
        end

        # ID: 215 (0xD7)
        # DESC: Value is popped off the stack and set at register index 3
        class SetLocal3 < Base
          define_opcode 215, "set_local_3"
        end
      
      
        LOCAL_SETS = [SetLocal.id, SetLocal0.id, SetLocal1.id, SetLocal2.id, SetLocal3.id].freeze
        LOCAL_GETS = [GetLocal.id, GetLocal0.id, GetLocal1.id, GetLocal2.id, GetLocal3.id].freeze
      end
    end
  end
end