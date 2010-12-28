module ARuby
  class SWF
    class ABC
      module OpCode
        # ID: 65 (0x41)
        # DESC: Call a closure
        # STACK: ..., function, receiver, arg1, arg2, ..., argn => ..., value
        # arg_count is a u30 that is the number of arguments present on the stack for the call. function 
        # is the closure that is being called. receiver is the object to use for the "this" value. This will 
        # invoke the [[Call]] property on function with the arguments receiver, arg1, ..., argn. The 
        # result of invoking the [[Call]] property will be pushed onto the stack.
        class Call < Base
          define_opcode 65, "call"
          struct do
            u30 :arg_count
          end
        end

        # ID: 67 (0x43)
        # DESC: Call a method identified by index in the object’s method table
        # STACK: ..., receiver, arg1, arg2, ..., argn => ..., value 
        # index is a u30 that is the index of the method to invoke on receiver. arg_count is a u30 that is 
        # the number of arguments present on the stack. receiver is the object to invoke the method on. 
        # The method at position index on the object receiver, is invoked with the arguments receiver, 
        # arg1, ..., argn. The result of the method call is pushed onto the stack.
        class CallMethod < Base
          define_opcode 67, "call_method"
          struct do
            u30 :index
            u30 :arg_count
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]} arg_count=#{arg_count}"
          end
        end
        
        # ID: 68 (0x44)
        # DESC: Call a method identified by index in the abcFile method table
        # STACK: ..., receiver, arg1, arg2, ..., argn => ..., value 
        # index is a u30 that is the index of the method_info of the method to invoke. arg_count is a 
        # u30 that is the number of arguments present on the stack. receiver is the object to invoke the 
        # method on. 
        # The method at position index is invoked with the arguments receiver, arg1, ..., argn. The 
        # receiver will be used as the “this” value for the method. The result of the method is pushed 
        # onto the stack.
        class CallStatic < Base
          define_opcode 68, "call_static"
          struct do
            u30 :index
            u30 :arg_count
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]} arg_count=#{arg_count}"
          end
        end
        
        # ID: 69 (0x45)
        # DESC: Call a method on a base class
        # STACK: ..., receiver, [ns], [name], arg1,...,argn  => ..., value
        # arg_count is a u30 that is the number of arguments present on the stack. The number of 
        # arguments specified by arg_count are popped off the stack and saved.  
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at 
        # that index is a runtime multiname the name and/or namespace will also appear on the stack 
        # so that the multiname can be constructed correctly at runtime. 
        # receiver is the object to invoke the method on. 
        # The base class of receiver is determined and the method indicated by the multiname is 
        # resolved in the declared traits of the base class. The method is invoked with the arguments 
        # receiver, arg1, ..., argn. The receiver will be used as the “this” value for the method. The result 
        # of the method call is pushed onto the stack.
        class CallSuper < Base
          define_opcode 69, "call_super"
          struct do
            u30 :index
            u30 :arg_count
          end
          
          def to_s
            super " index=#{index}||#{@abc_file.multinames[index]} arg_count=#{arg_count}"
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
        
        # ID: 71 (0x47)
        # DESC: Return from a method
        # STACK: ... => ...
        # Return from the currently executing method. This returns the value undefined. If the 
        # method has a return type, then undefined is coerced to that type and then returned.
        class ReturnVoid < Base
          define_opcode 71, "return_void"
        end
        
        # ID: 72 (0x48)
        # DESC: Return a value from a method
        # STACK: ..., return_value => ...
        # Return from the currently executing method. This returns the top value on the stack. 
        # return_value is popped off of the stack, and coerced to the expected return type of the 
        # method. The coerced value is what is actually returned from the method.
        class ReturnValue < Base
          define_opcode 72, "return_value"
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
        
        # ID: 78 (0x4E)
        # DESC: Call a method on a base class, discarding the return value
        # STACK: ..., receiver, [ns], [name], arg1, ..., argn  => ...
        # arg_count is a u30 that is the number of arguments present on the stack. The number of 
        # arguments specified by arg_count are popped off the stack and saved.  
        # index is a u30 that must be an index into the multiname constant pool. If the multiname at 
        # that index is a runtime multiname the name and/or namespace will also appear on the stack 
        # so that the multiname can be constructed correctly at runtime. 
        # receiver is the object to invoke the method on. 
        # The base class of receiver is determined and the method indicated by the multiname is 
        # resolved in the declared traits of the base class. The method is invoked with the arguments 
        # receiver, arg1, ..., argn. The first argument will be used as the “this” value for the method. 
        # The result of the method is discarded.
        class CallSuperVoid < Base
          define_opcode 78, "call_super_void"
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
        
      end
    end
  end
end