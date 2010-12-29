module ARuby
  class Interpreter
    protected

    iseq_define_ins :pop, [], [:val] do
      val = val
    end
  end
end
