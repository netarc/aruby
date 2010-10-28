module ARuby
  class SWF
    def initialize(env)
      @env = env

      reset!
      # puts "created new swf class: #{@env.config.swf.frame_size}"
    end

    # Load SWF data from a .swf file, this will clear any data currently in our SWF
    def read_from_file(file_path)
      reset!

      input_file = File.new(file_path, "r")
      input_file.binmode

      io_file = ByteBuffer.new(input_file.read)
      io_file.rewind

      input_file.close

      io_body = read_header(io_file)
      read_body io_body

      self
    end

    # Export our SWF data to a target file
    def write_to_file(file_path)
      output_file = File.new(file_path, "w")
      output_file.binmode
      output_file.write(to_swf)
      output_file.close
    end

    # Process a given ruby script as Ruby Byte Code and convert it to Actionscript Byte Code
    def process_script_from_file(file_path)
      @interpreter.evaluate_ruby_file file_path
    end

    private

    # General HeaderStruct
    class Header < StructuredObject
      struct do
        byte   :signature, :length => 3
        ui8    :version
        ui32   :file_size
        string :body
      end
    end

    def reset!
      @entry_class = ""
      # @interpreter = ARuby::Interpreter.new
    end

  end
end
