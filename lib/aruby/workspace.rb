module ARuby
  class Workspace
    def initialize(env)
      @env = env
      @files_included = []
      @interpreter = ARuby::Interpreter.new(@env)
    end

    # Include a file for assembly into the Workspace.
    #
    # @param path [String] Path to ruby file or gem.
    def include(path)
      path = resolve_path(path)

      return if @files_included.include?(path)
      @files_included << path

      @env.logger.info "- interpreting: #{path}"

      file_contents = File.open(path) { |f| f.read }
      file_iseq = ::RubyVM::InstructionSequence.compile(file_contents)

      @interpreter.process_iseq(file_iseq.to_a, path)
    end

    # Take what has been included and assembled into the Workspace and generate it's appropriate byte code.
    def generate_byte_code
      @interpreter.generate_byte_code
    end

    private

    def resolve_path(path)
      if path =~ /^\//
        return File.file?(path) ? File.expand_path(path) : nil
      end

      tmp_path = path =~ /\.rb$/ ? path : "#{path}.rb"
      return File.expand_path(tmp_path) if File.file?(tmp_path)
      $:.each do |dir|
        full_path = "#{dir}/#{tmp_path}"
        return File.expand_path(tmp_path) if File.file?(full_path)
      end

      unless path =~ /\.rb$/
        psize = $:.size

        spec = Gem.searcher.find(path)
        Gem.activate(spec.name, "= #{spec.version}")

        return full_file_path(path) unless psize == $:.size
      end

      raise "LoadError: no such file to load -- #{path}"
    end
  end
end
