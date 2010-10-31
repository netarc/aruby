module ARuby
  class Config
    class SWFConfig < Base
      Config.configures :swf, self

      attr_accessor :frame_size, :frame_rate, :frame_count, :version, :compressed
      attr_accessor :background_color

      attr_accessor :entry_class, :entry_file
    end
  end
end
