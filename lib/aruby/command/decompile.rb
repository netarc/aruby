module ARuby
  module Command
    class DecompileCommand < Base

      desc "decompile SOURCE", "examine the conents of a given SWF file"
      long_desc <<END
decompile a given SWF file to examine the conents
END

      argument :source, :type => :string
      map "-d" => :decompile

      def execute
        source_path = File.expand_path(source, env.cwd)

        if !File.exists?(source_path)
          raise Errors::PathNotFound.new(:path => source_path)
        elsif File.directory?(source_path)
          raise Errors::PathNotFile.new(:path => source_path)
        end

        swf = ARuby::SWF.new(env)
        swf.read_from_file(source_path)

      end
    end
  end
end
