module ARuby
  class SWF
    class ABC
      module OpCode
        # ID: 8 (0x08)
        # DESC: Kills a local register.
        # STACK: ... => ...
        # index is a u30 that must be an index of a local register. The local register at index is killed. It 
        # is killed by setting its value to undefined
        class Kill < Base
          define_opcode 8, "kill"
          struct do
            u30 :index
          end
        end
        
        # ID: 98 (0x62)
        # DESC: Get a local register
        # STACK: ... => ..., value
        # index is a u30 that must be an index of a local register. The value of that register is pushed 
        # onto the stack
        class GetLocal < Base
          define_opcode 98, "get_local"
          struct do
            u30 :index
          end
        end
      
        # ID: 99 (0x63)
        # DESC: Set a local register
        # STACK: ..., value => ...
        # index is a u30 that must be an index of a local register. The register at index is set to value, 
        # and value is popped off the stack
        class SetLocal < Base
          define_opcode 99, "set_local"
          struct do
            u30 :index
          end
        end
      
        # ID: 208 (0xD0)
        # DESC: The value at register index 0 is pushed onto the stack
        # STACK: ... => ..., value
        class GetLocal0 < Base
          define_opcode 208, "get_local_0"
        end

        # ID: 209 (0xD1)
        # DESC: The value at register index 1 is pushed onto the stack
        # STACK: ... => ..., value
        class GetLocal1 < Base
          define_opcode 209, "get_local_1"
        end

        # ID: 210 (0xD2)
        # DESC: The value at register index 2 is pushed onto the stack
        # STACK: ... => ..., value
        class GetLocal2 < Base
          define_opcode 210, "get_local_2"
        end

        # ID: 211 (0xD3)
        # DESC: The value at register index 3 is pushed onto the stack
        # STACK: ... => ..., value
        class GetLocal3 < Base
          define_opcode 211, "get_local_3"
        end
      
        # ID: 212 (0xD4)
        # DESC: Value is popped off the stack and set at register index 0
        # STACK: ..., value => ...
        class SetLocal0 < Base
          define_opcode 212, "set_local_0"
        end

        # ID: 213 (0xD5)
        # DESC: Value is popped off the stack and set at register index 1
        # STACK: ..., value => ...
        class SetLocal1 < Base
          define_opcode 213, "set_local_1"
        end

        # ID: 214 (0xD6)
        # DESC: Value is popped off the stack and set at register index 2
        # STACK: ..., value => ...
        class SetLocal2 < Base
          define_opcode 214, "set_local_2"
        end

        # ID: 215 (0xD7)
        # DESC: Value is popped off the stack and set at register index 3
        # STACK: ..., value => ...
        class SetLocal3 < Base
          define_opcode 215, "set_local_3"
        end
      
        LOCAL_SETS = [SetLocal.id, SetLocal0.id, SetLocal1.id, SetLocal2.id, SetLocal3.id].freeze
        LOCAL_GETS = [GetLocal.id, GetLocal0.id, GetLocal1.id, GetLocal2.id, GetLocal3.id].freeze
      end
    end
  end
end