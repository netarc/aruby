module ARuby
  class Interpreter

    class Scope
      attr_accessor :stack, :max_local_count

      def initialize(object)
        @stack = ARuby::Interpreter::Stack.new
        @max_local_count = 1
      end

      def access_local(idx)
        @max_local_count = idx if idx > @max_local_count
      end
    end
  end
end
