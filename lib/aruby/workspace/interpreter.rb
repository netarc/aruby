module ARuby
  class Workspace
    class Interpreter
      def initialize(env, workspace)
        @env = env
        @files_included = []
        @workspace = workspace
        @scope_stack = [Scope.new]
      end

      def process_iseq(iseq, file_path)
        iseq_process iseq, file_path
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
end

require "aruby/workspace/interpreter/iseq"
require "aruby/workspace/interpreter/stack"
require "aruby/workspace/interpreter/insns"
require "aruby/workspace/interpreter/scope"
require "aruby/workspace/interpreter/util"
