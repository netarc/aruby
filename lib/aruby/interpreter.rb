module ARuby
  class Interpreter
    def initialize(env)
      @env = env
      @files_included = []
    end

    def process_iseq(iseq, file_path)
      iseq_process_top iseq, file_path
    end

    def generate_byte_code
      #abc = ARuby::ABC.new
      #abc.serialize.to_s
      ""
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

require "aruby/interpreter/iseq"
require "aruby/interpreter/stack"
require "aruby/interpreter/insns"
