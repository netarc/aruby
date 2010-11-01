module ARuby
  class Interpreter
    class Stack
      attr_reader :max_stack_depth
      attr_accessor :line

      def initialize
        @stack = []
        @max_stack_depth = 0
      end

      def dump_to_s
        @stack.inspect
      end

      def _stack
        @stack
      end

      def stretch_stack
        size = @stack.size + 1
        @max_stack_depth = size if size > @max_stack_depth
      end

      def push(val)
        @stack << val
        @max_stack_depth = @stack.size if @stack.size > @max_stack_depth
      end

      def pop(size=1)
        raise Exception.new("invalid stack size: expected atleast #{size} was #{@stack.size}") if @stack.size < size
        if size <= 1
          @stack.pop
        else
          (@stack.slice!(-size, size) || []).reverse
        end
      end

      def pop_array(size=1)
        if size <= 0
          []
        else
          if size > 1
            pop_stack(size)
          else
            [pop_stack(size)]
          end
        end
      end

      def [](val)
        @stack[val]
      end

      def top
        @stack[-1]
      end

      def dup_top
        return if top_stack.nil?
        push_stack(Marshal.load(Marshal.dump(top_stack)))
      end
    end
  end
end
