require 'thread'

module ARuby
  module Util
    class Logger
      @@singleton_logger = nil
      @@writer_lock = Mutex.new

      # The environment that this logger is part of
      attr_reader :env

      # The backing logger which actually handles the IO. This logger
      # should be a subclass of the standard library Logger, in general.
      # IMPORTANT: This logger must be thread-safe.
      attr_reader :logger

      class << self
        # Returns a singleton logger. If one has not yet be
        # instantiated, then the given environment will be used to
        # create a new logger.
        def singleton_logger(env=nil)
          @@singleton_logger ||= PlainLogger.new(env.config.aruby.log_output)
        end

        # Resets the singleton logger (only used for testing).
        def reset_singleton_logger!
          @@singleton_logger = nil
        end
      end

      def initialize(env)
        @env = env
        @logger = self.class.singleton_logger(env)
      end

      [:debug, :info, :error, :fatal].each do |method|
        define_method(method) do |message|
          @@writer_lock.synchronize do
            logger.send(method, message)
          end
        end
      end
    end
  end
end
