module ARuby
  class Workspace
    class Interpreter
      protected
    
      def current_scope
        @scope_stack.last
      end

      class Scope
        attr_accessor :module
        attr_accessor :object
        attr_accessor :stack, :max_local_count
        attr_accessor :iseq_cmd, :iseq_params

        def initialize
          @stack = ARuby::Workspace::Interpreter::Stack.new
          @max_local_count = 1
          @iseq_cmd = []
          @module = ""
          @object = nil
        end

        def access_local(idx)
          @max_local_count = idx if idx > @max_local_count
        end
      end
    end
  end
end