module ARuby
  class Interpreter
    protected

    iseq_define_ins :getinlinecache do
      # current_scope.stack.push :nil
    end

    iseq_define_ins :setinlinecache do
      super_package = stack_get_package
      current_scope.stack.push [:package, super_package]
    end

  end
end
