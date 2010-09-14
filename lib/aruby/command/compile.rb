module ARuby
  module Command
    class CompileCommand < Base

      register :compile
      desc "", "compile a given file or project"
      long_desc <<END
some really long desc
END

      method_option :force, :type => :boolean, :aliases => "-f", :desc => "do some forceful stuff!"
      argument :name, :type => :string, :optional => true

      def execute
        puts "test: #{name}"
        puts "executing compile command: #{options.inspect}"
      end
    end
  end
end
