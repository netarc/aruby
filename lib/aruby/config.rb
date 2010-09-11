require 'aruby/config/base'
require 'aruby/config/error_recorder'

module ARuby
  # The config class is responsible for loading ARuby configurations
  # (usually through *.aruby files).
  class Config
    @@config = nil

    attr_reader :queue

    def self.proc_stack
      @_proc_stack ||= []
    end

    def self.reset!(env=nil)
      @@config = nil
      proc_stack.clear

      config(env)
    end

    def self.configures(key, klass)
      config.class.configures(key, klass)
    end

    def self.config(env=nil)
      @@config ||= Config::Top.new(env)
    end

    def self.run(&block)
      proc_stack << block
    end

    def self.execute!(config_object=nil)
      config_object ||= config

      run_procs!(config_object)
      config_object.validate!
      config_object
    end

    def self.run_procs!(*args)
      proc_stack.each do |proc|
        proc.call(*args)
      end
    end

    def initialize(env)
      @env = env
      @queue = []
    end

    def load!
      self.class.reset!(@env)

      queue.flatten.each do |item|
        if item.is_a?(String) && File.exist?(item)
          begin
            load item
          rescue SyntaxError => e
            raise Errors::ConfigFileSyntaxError.new(:file => e.message)
          end
        elsif item.is_a?(Proc)
          self.class.run(&item)
        end
      end

      return self.class.execute!
    end
  end

  class Config
    class Top < Base
      @@configures = []

      def self.configures_list
        @@configures ||= []
      end

      def self.configures(key, klass)
        configures_list << [key, klass]
        attr_reader key.to_sym
      end

      def initialize(env=nil)
        self.class.configures_list.each do |key, klass|
          config = klass.new
          config.env = env
          instance_variable_set("@#{key}".to_sym, config)
        end

        @env = env
      end

      def validate!
        # Validate each of the configured classes and store the results into a hash.
        errors = self.class.configures_list.inject({}) do |container, data|
          key, _ = data
          recorder = ErrorRecorder.new
          send(key.to_sym).validate(recorder)
          container[key.to_sym] = recorder if !recorder.errors.empty?
          container
        end

        return if errors.empty?
        raise Errors::ConfigValidationFailed.new(:messages => Util::TemplateRenderer.render("config/validation_failed", :errors => errors))
      end
    end
  end
end

# The built-in configuration classes
require 'aruby/config/aruby'
