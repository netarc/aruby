require 'thor/group'
require 'thor/actions'

module ARuby
  module Command
    # A CLI command is the subclass for all commands which are single
    # commands, e.g. `aruby compile`.
    #
    # A {Base} is a subclass of `Thor::Group`, so view the documentation
    # there on how to add arguments, descriptions etc. The important note
    # about this is that when invoked, _all public methods_ will be called
    # in the order they are defined. If you don't want a method called when
    # the command is invoked, it must be made `protected` or `private`.
    #
    # The best way to get examples of how to create your own command is to
    # view the various ARuby commands, which are relatively simple.
    class Base < Thor::Group
      include Thor::Actions
      include Helpers

      attr_reader :env

      def initialize(*args)
        super
        initialize_environment(*args)
      end

      def self.register(name)
        @command_name = name
        CLI.desc "", ""
        CLI.send(:define_method, name, Proc.new{ |*args| invoke self, args })
      end

      def self.desc(usage, description, options={})
        options[:for] = @command_name
        CLI.desc "#{@command_name} #{usage}", description, options
      end

      def self.long_desc(description, options={})
        options[:for] = @command_name
        CLI.long_desc description, options
      end

      def self.method_option(name, options={})
        options[:for] = @command_name
        CLI.method_option name, options
      end

      # Extracts the name of the command from a usage string. Example:
      # `init [box_name] [box_url]` becomes just `init`.
      def self.extract_name_from_usage(usage)
        /^([-_a-zA-Z0-9]+)(\s+(.+?))?$/.match(usage).to_a[1]
      end
    end
  end
end
