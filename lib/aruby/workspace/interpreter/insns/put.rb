module ARuby
  class Workspace
    class Interpreter
      protected

      VM_SPECIAL_OBJECT_VMCORE = 1
      VM_SPECIAL_OBJECT_CBASE = 2
      VM_SPECIAL_OBJECT_CONST_BASE = 3

      iseq_define_ins :putspecialobject do
        value_type = current_scope.iseq_params.shift
      
        case value_type
        when VM_SPECIAL_OBJECT_VMCORE
          current_scope.stack.push :frozencore
        when VM_SPECIAL_OBJECT_CBASE
          current_scope.stack.push :cbase
        when VM_SPECIAL_OBJECT_CONST_BASE
          current_scope.stack.push [:package, current_scope.module]
        else
          # TODO: Log/Abort?
          raise "putspecialobject insn: unknown value_type"
        end
      end

      iseq_define_ins :putnil do
        current_scope.stack.push :nil
      end

      iseq_define_ins :putstring do
        # , [:str], [] 
        # val = str
      end

      iseq_define_ins :putobject do
        val = current_scope.iseq_params.shift
      
        if val === Object
          current_scope.stack.push :nil
        end
      end
    
      iseq_define_ins :putiseq do
      end


    end
  end
end