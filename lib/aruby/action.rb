module ARuby
  class Action
    attr_reader :env

    def self.actions
      @actions ||= {}
    end

    def self.register(key, callable)
      actions[key] = callable
    end

    def self.[](key)
      actions[key]
    end

    def initialize(env)
      @env = env
    end

    def run(callable, options=nil)
      puts "Running: #{callable.inspect}"
      callable = self.class.actions[callable] if callable.kind_of?(Symbol)
      raise ArgumentError.new("Argument to run must be a callable object or registered action.") if !callable

      callable.call(@env)
    end
  end
end
