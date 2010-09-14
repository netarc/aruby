module ARuby
  module Command
    class VersionCommand < Base

      register :version
      desc "", "Prints the ARuby version information", :alias => %w(-v --version)

      def execute
        env.ui.info("aruby.commands.version.output", :version => ARuby::VERSION)
      end
    end
  end
end
