module ARuby
  module Command
    class CompileCommand < Base

      desc "compile SOURCE", "compile a given file or project"
      long_desc <<END
some really long desc
END

      class_option :force, :type => :boolean, :aliases => "-f", :desc => "do some forceful stuff!"
      argument :source, :type => :string
      map "-c" => :compile

      def execute
        puts "test: #{source}"
        puts "executing compile command: #{options.inspect}"
      end
    end
  end
end
