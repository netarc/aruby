module ARuby
  module Command
    class CompileCommand < Base
      desc "Compile a given environment"
      register "compile"
      argument :name, :type => :string, :optional => true
      class_option :execute, :type => :string, :default => false, :aliases => "-e"

      def execute
        puts "test: #{name}"
        puts "executing compile command: #{options.inspect}"
      end
    end
  end
end
