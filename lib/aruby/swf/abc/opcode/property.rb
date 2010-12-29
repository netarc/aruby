module ARuby
  class SWF
    class ABC
      module OpCode
        # ID: 30 (0x1E)
        # DESC: Get the name of the next property when iterating over an object
        # STACK: ..., obj, index => ..., name
        # index and obj are popped off of the stack. index must be a value of type int. Gets the name of 
        # the property that is at position index + 1 on the object obj, and pushes it onto the stack. 
        class NextName < Base
          define_opcode 30, "next_name"
        end
        
        # ID: 35 (0x23)
        # DESC: Get the name of the next property when iterating over an object
        # STACK: ..., obj, index => ..., value
        # index and obj are popped off of the stack. index must be of type int. Get the value of the 
        # property that is at position index + 1 on the object obj, and pushes it onto the stack.
        class NextValue < Base
          define_opcode 35, "next_value"
        end
        
        # ID: 50 (0x32)
        # DESC: Determine if the given object has any more properties
        # STACK: ..., => ..., value
        # object_reg and index_reg are uints that must be indexes to a local register. The value of the 
        # register at position object_reg is the object that is being enumerated and is assigned to obj. 
        # The value of the register at position index_reg must be of type int, and that value is assigned 
        # to cur_index.  
        # Get the index of the next property after the property located at index cur_index on object 
        # obj. If there are no more properties on obj, then obj is set to the next object on the prototype 
        # chain of obj, and cur_index is set to the first index of that object. If there are no more objects 
        # on the prototype chain and there are no more properties on obj, then obj is set to null, and 
        # cur_index is set to 0. 
        # The register at position object_reg is set to the value of obj, and the register at position 
        # index_reg is set to the value of cur_index.  
        # If index is not 0, then push true. Otherwise push false.
        class HasNext2 < Base
          define_opcode 50, "has_next_2"
          struct do
            ui8 :object_reg
            ui8 :index_reg
          end
        end
        
        # ID: 70 (0x46)
        # DESC: Call a property
        # STACK: ..., obj, [ns], [name], arg1,...,argn  => ..., value
        # arg_count is a u30 that is the number of arguments present on the stack. The number of 
        # arguments specified by arg_count are popped off the stack and saved.  
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at 
        # that index is a runtime multiname the name and/or namespace will also appear on the stack 
        # so that the multiname can be constructed correctly at runtime. 
        # obj is the object to resolve and call the property on. 
        # The property specified by the multiname at index is resolved on the object obj. The [[Call]] 
        # property is invoked on the value of the resolved property with the arguments obj, arg1, ..., 
        # argn. The result of the call is pushed onto the stack.
        class CallProperty < Base
          define_opcode 70, "call_property"
          struct do
            u30 :index
            u30 :arg_count
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]} arg_count=#{arg_count}"
          end
        end
        
        # ID: 76 (0x4C)
        # DESC: Call a property
        # STACK: ..., obj, [ns], [name], arg1,...,argn  => ..., value
        # arg_count is a u30 that is the number of arguments present on the stack. The number of 
        # arguments specified by arg_count are popped off the stack and saved.  
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at 
        # that index is a runtime multiname the name and/or namespace will also appear on the stack 
        # so that the multiname can be constructed correctly at runtime. 
        # obj is the object to resolve and call the property on. 
        # The property specified by the multiname at index is resolved on the object obj. The [[Call]] 
        # property is invoked on the value of the resolved property with the arguments null, arg1, ..., 
        # argn. The result of the call is pushed onto the stack.
        class CallPropLex < Base
          define_opcode 76, "call_property_lex"
          struct do
            u30 :index
            u30 :arg_count
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]} arg_count=#{arg_count}"
          end
        end
        
        # ID: 79 (0x4F)
        # DESC: Call a property, discarding the return value
        # STACK: ..., obj, [ns], [name], arg1,...,argn  => ..., value
        # arg_count is a u30 that is the number of arguments present on the stack. The number of 
        # arguments specified by arg_count are popped off the stack and saved.  
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at 
        # that index is a runtime multiname the name and/or namespace will also appear on the stack 
        # so that the multiname can be constructed correctly at runtime. 
        # obj is the object to resolve and call the property on. 
        # The property specified by the multiname at index is resolved on the object obj. The [[Call]] 
        # property is invoked on the value of the resolved property with the arguments obj, arg1, ..., 
        # argn. The result of the call is discarded. 
        class CallPropVoid < Base
          define_opcode 79, "call_property_void"
          struct do
            u30 :index
            u30 :arg_count
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]} arg_count=#{arg_count}"
          end
        end
        
        # ID: 93 (0x5D)
        # DESC: Find a property
        # STACK: ..., [ns], [name]  => ..., obj 
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at 
        # that index is a runtime multiname the name and/or namespace will also appear on the stack 
        # so that the multiname can be constructed correctly at runtime. 
        # This searches the scope stack, and then the saved scope in the method closure, for a property 
        # with the name specified by the multiname at index.  
        # If any of the objects searched is a with scope, its declared and dynamic properties will be 
        # searched for a match. Otherwise only the declared traits of a scope will be searched. The 
        # global object will have its declared traits, dynamic properties, and prototype chain searched.  
        # If the property is resolved then the object it was resolved in is pushed onto the stack. If the 
        # property is unresolved in all objects on the scope stack then an exception is thrown. 
        class FindPropStrict < Base
          define_opcode 93, "find_property_strict"
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end
        
        # ID: 94 (0x5E)
        # DESC: Search the scope stack for a property
        # STACK: ..., [ns], [name]  => ..., obj
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
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end
        
        # ID: 97 (0x61)
        # DESC: Set a property
        # STACK: ..., obj, [ns], [name], value => ...
        # value is the value that the property will be set to. value is popped off the stack and saved.  
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at 
        # that index is a runtime multiname the name and/or namespace will also appear on the stack 
        # so that the multiname can be constructed correctly at runtime. 
        # The property with the name specified by the multiname will be resolved in obj, and will be 
        # set to value. If the property is not found in obj, and obj is dynamic then the property will be 
        # created and set to value.
        class SetProperty < Base
          define_opcode 97, "set_property"
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end
        
        # ID: 102 (0x66)
        # DESC: Get a property
        # STACK: ..., object, [ns], [name]  => ..., value
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at 
        # that index is a runtime multiname the name and/or namespace will also appear on the stack 
        # so that the multiname can be constructed correctly at runtime. 
        # The property with the name specified by the multiname will be resolved in object, and the 
        # value of that property will be pushed onto the stack. If the property is unresolved, 
        # undefined is pushed onto the stack.
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
        # DESC: Initialize a property
        # STACK: ..., object, [ns], [name], value => ...
        # value is the value that the property will be set to. value is popped off the stack and saved.  
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at 
        # that index is a runtime multiname the name and/or namespace will also appear on the stack 
        # so that the multiname can be constructed correctly at runtime. 
        # The property with the name specified by the multiname will be resolved in object, and will be 
        # set to value. This is used to initialize properties in the initializer method. When used in an 
        # initializer method it is able to set the value of const properties.
        class InitProperty < Base
          define_opcode 104, "init_property"
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end
        
        # ID: 106 (0x6A)
        # DESC: Delete a property
        # STACK: ..., object, [ns], [name] => ..., value
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at 
        # that index is a runtime multiname the name and/or namespace will also appear on the stack 
        # so that the multiname can be constructed correctly at runtime. 
        # This will invoke the [[Delete]] method on object with the name specified by the multiname. 
        # If object is not dynamic or the property is a fixed property then nothing happens, and false 
        # is pushed onto the stack. If object is dynamic and the property is not a fixed property, it is 
        # removed from object and true is pushed onto the stack.
        class DeleteProperty < Base
          define_opcode 106, "delete_property"
          struct do
            u30 :index
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]}"
          end
        end
      end
    end
  end
end