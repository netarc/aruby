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
      # , [:klass_name, :iseq, :flags], [:klass_pkg, :super_pkg]
      # if klass_pkg.is_a?(::Symbol)
      #   klass_package = klass_name.to_s
      # else  
      #   klass_package = klass_pkg[1] + "." + klass_name.to_s
      # end
      # 
      # klass = workspace.create_or_extend_class(klass_package, super_pkg[1])
      # val = [:scope, klass, iseq]
    end
    
  end
end
