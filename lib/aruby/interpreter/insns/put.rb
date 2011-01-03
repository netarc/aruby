module ARuby
  class Interpreter
    protected

    VM_SPECIAL_OBJECT_VMCORE = 1
    VM_SPECIAL_OBJECT_CBASE = 2
    VM_SPECIAL_OBJECT_CONST_BASE = 3

    iseq_define_ins :putspecialobject do
      # , [:value_type], []
      # case value_type
      # when VM_SPECIAL_OBJECT_VMCORE
      #   val = :frozencore
      # when VM_SPECIAL_OBJECT_CBASE
      #   val = :cbase
      # when VM_SPECIAL_OBJECT_CONST_BASE
      #   val = :const_base
      # else
      #   # TODO: Log/Abort?
      #   raise "putspecialobject insn: unknown value_type"
      # end
    end

    iseq_define_ins :putnil do
      # val = :nil
    end

    iseq_define_ins :putstring do
      # , [:str], [] 
      # val = str
    end

    iseq_define_ins :putobject do
      # , [:val], [] 
    end

  end
end
