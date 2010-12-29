module ARuby
  module Command
    class CompileCommand < Base

      desc "compile SOURCE DEST", "compile a given file or project"
      long_desc <<END
compile a given file or project file
END

      argument :source, :type => :string
      argument :dest, :type => :string, :default => ""
      map "-c" => :compile

      def execute
        source_path = File.expand_path(source, env.cwd)

        if !File.exists?(source_path)
          raise Errors::PathNotFound.new(:path => source_path)
        elsif File.directory?(source_path)
          raise Errors::PathNotFile.new(:path => source_path)
        end

        # Given a .aruby project file make sure we include it in our environment
        if File.extname(source_path) == ".aruby"
          env.project_file = source_path
        else
          env.config.swf.entry_file = source_path
        end

        workspace = ARuby::Workspace.new(env)
        
        swf = ARuby::SWF.new(env)
        swf.process_script_from_file(env.config.swf.entry_file)

        # Use destination given or from our project/file name given
        # TODO: Maybe add a destination to our config file?
        dest = File.basename(source_path, File.extname(source_path)) if dest.nil? || dest.empty?
        dest = dest + ".swf" if File.extname(dest) != ".swf"
        swf.write_to_file(dest)
      end
    end
  end
end
