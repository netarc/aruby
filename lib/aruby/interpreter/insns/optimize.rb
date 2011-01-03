module ARuby
  class Interpreter
    protected

    iseq_define_ins :getinlinecache do
      # , [:dst, :ic], []
      # val = :nil
    end

    iseq_define_ins :setinlinecache do
      # , [:dst], []
      # super_package = ARuby::Interpreter.pop_parent_class(_sys[:stack])
      # val = [:constant, super_package]
    end

  end
end
