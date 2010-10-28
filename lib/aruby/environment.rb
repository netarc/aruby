require 'pathname'
require 'fileutils'

module ARuby
  # Represents a single ARuby environment. This class is responsible
  # for loading respective *.aruby file for the given environment and
  # storing references to various instances.
  class Environment
    attr_reader :cwd
    attr_writer :ui
    attr_writer :project_file

    def initialize(opts=nil)
      opts = {
        :cwd => nil,
      }.merge(opts || {})

      opts[:cwd] ||= Dir.pwd
      opts[:cwd] = Pathname.new(opts[:cwd])

      opts.each do |key, value|
        instance_variable_set("@#{key}".to_sym, opts[key])
      end

      @loaded = false
      @logger = nil
    end


    # Accesses the logger for ARuby. This logger is a _detailed_
    # logger which should be used to log internals only.
    def logger
      @logger ||= Util::Logger.new(self)
    end

    def config
      load! if !loaded?
      @config
    end

    def loaded?
      !!@loaded
    end

    def load!
      unless loaded?
        @loaded = true
        load_config!
      end
      self
    end

    # Makes a call to the CLI with the given arguments as if they
    # came from the real command line (sometimes they do!)
    def cli(*args)
      CLI.start(args.flatten, :env => self)
    end

    # Returns the {Action} class for this environment which allows actions
    # to be executed in the context of this environment.
    def actions
      @actions ||= Action.new(self)
    end

    def ui
      @ui ||= ARuby::UI.new(self)
    end


    # NOTE: This seems more like an action then part of our environment, split this out somewhere?
    def compile_project

    end

    private

    def load_config!
      loader = Config.new(self)
      loader.queue << File.expand_path("config/default.rb", ARuby.source_root)
      loader.queue << File.expand_path(@project_file, ARuby.source_root) unless @project_file.nil?

      @config = loader.load!
      @logger = nil
    end
  end
end
