module ARuby
  module Command
    module Helpers
      def self.included(base)
        base.extend(ClassMethods)
      end

      attr_reader :env

      def initialize(*args)
        super
        initialize_environment(*args)
      end

      # Initializes the environment by pulling the environment out of
      # the configuration hash and sets up the UI if necessary.
      def initialize_environment(args, options, config)
        raise Errors::CLIMissingEnvironment.new if !config[:env]
        @env = config[:env]
        @env.ui = UI::Shell.new(@env, shell) if !@env.ui.is_a?(UI::Shell)
      end

      module ClassMethods
        # Extracts the name of the command from a usage string. Example:
        # `task param1 [param2]` becomes just `task`.
        def extract_name_from_usage(usage)
          /^([-_a-zA-Z0-9]+)(\s+(.+?))?$/.match(usage).to_a[1]
        end
      end
    end
  end
end
