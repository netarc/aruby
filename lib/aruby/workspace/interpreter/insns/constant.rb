module ARuby
  class Workspace
    class Interpreter
      protected

      iseq_define_ins :getconstant do
        constant = current_scope.iseq_params.shift
        current_scope.stack.push [:getconstant, constant]
      end

    end
  end
end