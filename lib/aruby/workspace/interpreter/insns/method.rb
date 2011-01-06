module ARuby
  class Interpreter
    protected

    VM_CALL_ARGS_SPLAT_BIT     = 2
    VM_CALL_ARGS_BLOCKARG_BIT  = 4
    VM_CALL_FCALL_BIT          = 8
    VM_CALL_VCALL_BIT          = 16
    VM_CALL_TAILCALL_BIT       = 32
    VM_CALL_TAILRECURSION_BIT  = 64
    VM_CALL_SUPER_BIT          = 128
    VM_CALL_SEND_BIT           = 256
    
    iseq_define_ins :leave do
    end

    iseq_define_ins :send do
      # , [:op_id, :op_argc, :blockiseq, :op_flag, :ic], []
      # logger.info "send: #{op_id.inspect} | #{op_argc}"
    end

    iseq_define_ins :defineclass do
      class_name = current_scope.iseq_params.shift
      class_iseq = current_scope.iseq_params.shift
      define_type = current_scope.iseq_params.shift

      super_class = stack_get_package
      package_scope = stack_get_package + "::#{class_name}"

      puts "super_class: #{super_class.inspect}"
      puts "package_scope: #{package_scope.inspect}"
      puts "define_type: #{define_type.inspect}"

      klass = @workspace.create_or_extend_class(package_scope, super_class)

      @scope_stack << (scope = Scope.new)
      scope.module = package_scope
      scope.object = klass
      iseq_process class_iseq, "file"
    end
  end
end
