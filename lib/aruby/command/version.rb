module ARuby
  module Command
    class VersionCommand < Base

      desc "version", "Prints the ARuby version information"
      map ["-v", "--version"] => :version

      def execute
        env.ui.info("aruby.commands.version.output", :version => ARuby::VERSION)
      end
    end
  end
end
