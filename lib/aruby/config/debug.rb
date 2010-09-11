module ARuby
  class Config
    class DebugConfig < Base
      Config.configures :debug, self

      attr_accessor :enabled
    end
  end
end
