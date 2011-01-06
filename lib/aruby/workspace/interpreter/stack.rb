module ARuby
  class Workspace
    class Interpreter
      def current_stack
        current_scope.stack
      end
    
      def stack_get_package
        parts = []
        while (part = current_stack.last) do
          if part == :nil
            parts << ""
            current_stack.pop
            break
          else
            case part[0]
            when :package
              if parts.empty?
                current_stack.pop
                return part[1] 
              end
              break
            when :getconstant
              parts << part[1].to_s
              current_stack.pop
            else
              break
            end
          end
        end
        parts.reverse.join('::')
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
    
      class Stack < Array
        attr_reader :max_stack_depth
        attr_accessor :line

        def initialize
          @max_stack_depth = 0
        end

        def stretch_stack
          len = size + 1
          @max_stack_depth = len if len > @max_stack_depth
        end

        def push(val)
          super
          @max_stack_depth = size if size > @max_stack_depth
        end

        def pop(*args)
          len = args.pop || 0
          raise Exception.new("invalid stack size: expected atleast #{len} was #{size}") if size < len
          if len <= 1
            super
          else
            (slice!(-len, len) || []).reverse
          end
        end

        def pop_array(len=1)
          if len <= 0
            []
          else
            if len > 1
              pop_stack(len)
            else
              [pop_stack(len)]
            end
          end
        end

        def dup_top
          return if top_stack.nil?
          push_stack(Marshal.load(Marshal.dump(top_stack)))
        end
      end
    end
  end
end