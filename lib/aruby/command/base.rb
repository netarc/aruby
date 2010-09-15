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
    class Base < Thor::Group
      include Thor::Actions
      include Helpers

      def self.desc(usage, description, options={})
        klass = self
        @command_name = extract_name_from_usage(usage).to_sym
        CLI.desc "#{usage}", description, options
        CLI.send(:define_method, @command_name, Proc.new{ |*args| invoke klass, args })
      end

      def self.long_desc(description, options={})
        options[:for] = @command_name
        CLI.long_desc description, options
      end

      def self.map(mappings=nil)
        CLI.map(mappings)
      end

      def self.class_option(name, options={})
        options[:for] = @command_name
        CLI.method_option name, options
        super
      end

    end
  end
end
