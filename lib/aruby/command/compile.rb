module ARuby
  module Command
    class CompileCommand < Base

      desc "compile SOURCE", "compile a given file or project"
      long_desc <<END
compile a given file or project file
END

      argument :source, :type => :string
      map "-c" => :compile

      def execute
        source_path = File.expand_path(source, env.cwd)

        if !File.exists?(source_path)
          raise Errors::PathNotFound.new(:path => source_path)
        elsif File.directory?(source_path)
          raise Errors::PathNotFile.new(:path => source_path)
        end

        env.project_file = source_path

        swf = ARuby::SWF.new(env)
      end
    end
  end
end
