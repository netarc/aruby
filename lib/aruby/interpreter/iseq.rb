module ARuby
  class Interpreter
    protected

    class ISEQ_InvalidFormat < StandardError
      def message
        "The instruction sequence generated from the Ruby VM was not in the correct format."
      end
    end

    class ISEQ_InvalidEntry < StandardError
      def initialize(att)
        @att = att
      end

      def message
        "unknown ISEQ entry point `#{@att.inspect}`"
      end
    end

    def iseq_is_yarv_simple_data!(iseq)
      raise ISEQ_InvalidFormat unless iseq[0] == "YARVInstructionSequence/SimpleDataFormat"
      raise ISEQ_InvalidFormat unless iseq[13].is_a?(Array)
    end

    def iseq_process_top iseq, file_path
      iseq_is_yarv_simple_data! iseq

      case iseq[9]
      when :top
        iseq_process iseq, file_path
      when :class
        raise NotImplemented
      when :method
        raise NotImplemented
      else
        raise ISEQ_InvalidEntry, iseq[9]
      end
    end

    # Process a block/thread of ISEQ in it's own scope
    def iseq_process iseq, file_path
      iseq_is_yarv_simple_data! iseq

      # TODO: CLEANUP
      scope_stack = Stack.new
      scope_object = nil

      iseq_line = 0
      iseq_label = nil

      iseq_body = iseq[13]
      iseq_body.each do |iseq_cmd|
        if iseq_cmd.is_a? Integer
          iseq_line = iseq_cmd
          puts "--[#{iseq_cmd}]--"
        elsif iseq_cmd.is_a? Symbol
          iseq_label = iseq_cmd
          puts "--[#{iseq_cmd}]--"
        elsif iseq_cmd.is_a? Array

          #ARuby.print_obj iseq_cmd
          #iseq_process_ins iseq_cmd, scope_stack, scope_object

          puts " +stack #{scope_stack.dump_to_s}"
        end
      end
    end

  end
end
