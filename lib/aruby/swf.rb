module ARuby
  class SWF
    def initialize(env)
      @env = env
    end

    # Load SWF data from a .swf file, this will clear any data currently in our SWF
    def read_from_file(file_path)
      reset

      input_file = File.new(file_path, "r")
      input_file.binmode

      io_file = ByteBuffer.new(input_file.read)
      io_file.rewind

      input_file.close

      io_body = read_header(io_file)
      read_body io_body

      self
    end

  end
end
