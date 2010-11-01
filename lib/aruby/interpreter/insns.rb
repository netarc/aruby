module ARuby
  class Interpreter
    protected

    class ISEQ_DuplicateInstruction < StandardError
      def initialize(att)
        @att = att
      end
      def message
        "The instruction `#{@att.inspect}` already has a definition."
      end
    end

    class ISEQ_UnknownInstruction < StandardError
      def initialize(att)
        @att = att
      end
      def message
        "The instruction `#{@att.inspect}` has not been defined."
      end
    end

    @@iseq_insns = {}
    def self.iseq_define_ins id, operands, pop_values, &block
      raise ISEQ_DuplicateInstruction, id if @@iseq_insns[id]
      @@iseq_insns[id] = {:id => id, :operands => operands, :pop_values => pop_values, :block => block}
    end

    def iseq_process_ins iseq, scope_stack, scope_object
      unless iseq_def = @@iseq_insns[iseq[0]]
        raise ISEQ_UnknownInstruction, iseq[0]
      end

      data_hash = {:val => :deadbeef, :_sys => {:stack => scope_stack, :object => scope_object}, :vm => @vm}
      iseq_def[:operands].each_index do |i|
        data_hash[iseq_def[:operands][i]] = iseq[1 + i]
      end
      iseq_def[:pop_values].reverse_each do |v|
        data_hash[v] = scope_stack.pop
      end
      bi = Util::BlockBinding.new(data_hash, &iseq_def[:block])
      scope_stack.push bi.val unless bi.val == :deadbeef
    end


    iseq_define_ins :defineclass, [:flags], [] do

    end

  end
end

require 'aruby/interpreter/insns/settings'
