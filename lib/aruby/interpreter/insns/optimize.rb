module ARuby
  class Interpreter
    protected

    iseq_define_ins :getinlinecache, [:dst, :ic], [] do
      val = :nil
    end

    iseq_define_ins :setinlinecache, [:dst], [:val] do
    end

  end
end
