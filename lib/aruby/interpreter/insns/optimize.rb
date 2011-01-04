module ARuby
  class Interpreter
    protected

    iseq_define_ins :getinlinecache do
      # , [:dst, :ic], []
      current_scope.stack.push :nil
    end

    iseq_define_ins :setinlinecache do
      super_package = pop_parent_class
      current_scope.stack.push [:package, super_package]
    end

  end
end
