module ARuby
  class Interpreter
    protected

    iseq_define_ins :getconstant, [:id], [:klass] do
      if klass == :nil
        # search current scope
        #val = vm.const_get klass, id
      elsif klass == :false
        # search top scope
        raise "TODO"
      else
        # search klass
        raise "TODO"
      end
    end

  end
end
