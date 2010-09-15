require 'thor'
require 'thor/actions'

module ARuby
  module Command
    # A {GroupBase} is the subclass which should be used if you're
    # creating a CLI command which has subcommands such as `aruby compile`,
    # which has subcommands such as `add`, `remove`, `list`. If you're
    # creating a simple command which has no subcommands, such as `vagrant up`,
    # then use {Base} instead.
    class GroupBase < Thor
      include Thor::Actions
      include Helpers

      def self.subcommand(usage, description, klass)
        CLI.desc usage, description
        CLI.subcommand usage, klass
      end
    end
  end
end
