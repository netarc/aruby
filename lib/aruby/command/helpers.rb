module ARuby
  module Command
    module Helpers
      # Initializes the environment by pulling the environment out of
      # the configuration hash and sets up the UI if necessary.
      def initialize_environment(args, options, config)
        raise Errors::CLIMissingEnvironment.new if !config[:env]
        @env = config[:env]
        @env.ui = UI::Shell.new(@env, shell) if !@env.ui.is_a?(UI::Shell)
      end
    end
  end
end
