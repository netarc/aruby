module ARuby
  module Util
    class BlockBinding
      def initialize(defaults={}, &block)
        @binding = nil
        @default_vars = defaults
        @in_eval = false
        @in_has_eval = false
        count = 0
        set_trace_func proc { |event, file, line, id, binding, classname|
          if event == "line"
            count += 1
            # 2nd line of execution in we reach our inner block
            if count == 2
              set_trace_func nil
              @binding = binding
              # Check all default vars to see if they are used locally
              # If they are, we need to set them to their default value since the block will have
              # an inherit value off the start even before it reaches the line where they are defined
              @default_vars.each_pair do |k,v|
                next unless has_eval?(k)
                @binding.eval("#{k} = @default_vars[:#{k}]")
              end
            end
          end
        }
        self.instance_eval(&block)
        set_trace_func nil
      end

      def has_eval?(symbol)
        @in_has_eval = true
        result = @binding.eval(symbol.to_s)
        @in_has_eval = false
        return result != :method_missing
      end

      def method_missing(symbol, *args)
        return :method_missing if @in_has_eval
        if @in_eval
          return @default_vars[symbol]
        end
        @in_eval = true
        ret_val = @binding.eval(symbol.to_s)
        @in_eval = false
        ret_val
      end
    end
  end
end
