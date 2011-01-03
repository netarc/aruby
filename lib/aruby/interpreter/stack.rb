module ARuby
  class Interpreter
    def pop_parent_class(stack)
      parts = []
      stack._stack.reverse.each do |line|
        case line[0]
        when :getconstant
          parts << line[1].to_s
          stack.pop()
        else
          stack.pop()
          break
        end
      end
      parts.reverse.join('.')
    end
    
    # Given a package string, split it into [class,package].
    #
    # flash.dislay:Sprite => ["Sprite", "flash.display"]
    # Flash.Dislay.Sprite => ["Sprite", "flash.display"]
    def split_name_package(fullname)
      fixing = fullname.gsub(/:/, ".")
      split = fixing.match(/^(?:((?:\w+\.?)*)\.)?(\w+)$/) || []
      name = split[2] || ""
      package = split[1] || ""
      # downcase the first letter of each package name
      package = package.split(".").map {|s| s[0].downcase+s[1..-1]}.join(".")
      [name, package]
    end
    
    
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
