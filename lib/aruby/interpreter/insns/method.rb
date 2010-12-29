module ARuby
  class Interpreter
    protected

    iseq_define_ins :leave, [], [] do
    end

    iseq_define_ins :send, [:op_id, :op_argc, :blockiseq, :op_flag, :ic], [] do
    end

  end
end
