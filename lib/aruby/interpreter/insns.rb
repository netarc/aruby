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
    def self.iseq_define_ins(id, &block)
      raise ISEQ_DuplicateInstruction, id if @@iseq_insns[id]
      @@iseq_insns[id] = {:id => id, :block => block}
    end
    def iseq_process_ins(iseq)
      unless iseq_def = @@iseq_insns[iseq[0]]
        raise ISEQ_UnknownInstruction, iseq[0]
      end
      
      instance_eval(&iseq_def[:block])
    end
  end
end

require 'aruby/interpreter/insns/constant'
require 'aruby/interpreter/insns/optimize'
require 'aruby/interpreter/insns/put'
require 'aruby/interpreter/insns/settings'
require 'aruby/interpreter/insns/method'
require 'aruby/interpreter/insns/stack'
