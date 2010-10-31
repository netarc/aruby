module ARuby
  class Interpreter
    def initialize(env)
      @env = env
      @files_included = []
    end

    def evaluate_ruby_file(path)
      file_path = sys_find_path(path)

      return if @files_included.include?(file_path)
      @files_included << file_path

      puts "- interpreting: #{file_path}"

      file_contents = File.open(file_path) { |f| f.read }
      file_iseq = ::RubyVM::InstructionSequence.compile(file_contents)

      #iseq_process_top file_iseq.to_a, file_path
    end

    protected

    def sys_find_path(path)
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
        unless spec.nil?
          Gem.activate(spec.name, "= #{spec.version}")

          return full_file_path(path) unless psize == $:.size
        end
      end

      raise "LoadError: no such file to load -- #{path}"
    end
  end
end
