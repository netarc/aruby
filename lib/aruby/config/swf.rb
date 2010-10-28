module ARuby
  class Config
    class SWFConfig < Base
      Config.configures :swf, self

      attr_accessor :frame_size, :frame_rate, :frame_count, :version, :compressed
      attr_accessor :entry_class, :background_color
    end
  end
end
