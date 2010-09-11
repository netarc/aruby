module ARuby
  class Config
    class ARubyConfig < Base
      Config.configures :aruby, self

      attr_accessor :log_output
      attr_accessor :debug_enabled
    end
  end
end
