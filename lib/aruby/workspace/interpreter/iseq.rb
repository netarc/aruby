module ARuby
  class Workspace
    class Interpreter
      protected

      class ISEQ_NotImplemented < StandardError
        def message
          "Encountered a dead end in support."
        end
      end
    
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

      def iseq_process(iseq, file_path)
        iseq_is_yarv_simple_data! iseq

        case iseq[9]
        when :top
          iseq_process iseq, file_path
        when :class
          iseq_process iseq, file_path
        when :method
          raise ISEQ_NotImplemented
        else
          raise ISEQ_InvalidEntry, iseq[9]
        end
      end

      # Process a block/thread of ISEQ in it's own scope
      def iseq_process(iseq, file_path, scope_object=nil)
        iseq_is_yarv_simple_data! iseq

        scope = @scope_stack.last
        puts "\n--- processing iseq for scope: #{scope.module.inspect}"
      
        iseq_line = 0
        iseq_label = nil

        iseq_body = iseq[13]
        iseq_body.each do |iseq_cmd|        
          if iseq_cmd.is_a? Integer
            iseq_line = iseq_cmd
            @env.logger.debug "--[#{iseq_cmd}]--"
          elsif iseq_cmd.is_a? Symbol
            iseq_label = iseq_cmd
            @env.logger.debug "--[#{iseq_cmd}]--"
          elsif iseq_cmd.is_a? Array
            scope.iseq_cmd = iseq_cmd[0]
            scope.iseq_params = iseq_cmd[1..-1]

            puts "\n\r - ISEQ #{iseq_cmd.inspect}"
            @env.logger.debug " + start stack #{scope.stack.inspect}"
            iseq_process_ins iseq_cmd
            @env.logger.debug " + end stack #{scope.stack.inspect}"
          end
        end
      
        @scope_stack.pop
      end
    end
  end
end