module ARuby
  class SWF
    autoload :Tag,         'aruby/swf/tag'

    def initialize(env)
      @env = env
      reset!
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
        byte   :signature, :size => 3
        ui8    :version
        ui32   :file_size
        string :body
      end
    end

    def reset!
      @entry_class = ""
      @interpreter = ARuby::Interpreter.new(@env)
    end

    def to_swf
      # Create our body content
      body = ByteBuffer.new
      body.write_rect @env.config.swf.frame_size
      body.write_fixed8 @env.config.swf.frame_rate
      body.write_ui16 @env.config.swf.frame_count

      # Add all tags to our body
      generate_tags.each do |tag|
        body.write tag.serialize_struct.to_s
      end

      # Create our header
      header = Header.new
      header.signature = (!!@env.config.swf.compressed ? ['C'] : ['F']) + ['W','S']
      header.version = @env.config.swf.version
      header.file_size = body.size + 8
      header.body = !!@env.config.swf.compressed ? Zlib::Deflate.deflate(body.buffer, Zlib::BEST_COMPRESSION) : body.buffer

      header.serialize_struct.to_s
    end

    # Generate all tags needed to create our SWF Body Content
    def generate_tags
      tags = []

      file_attributes = Tag::FileAttributes.new
      file_attributes.actionscript3 = true
      file_attributes.use_network = true
      file_attributes.has_metadata = false
      tags << file_attributes

#       script_limits = Tag::ScriptLimits.new
#       script_limits.max_recursion_depth = 1000
#       script_limits.script_timeout_secs = 60
#       tags << script_limits

#       debug_id = Tag::DebugID.new
#       debug_id.debug_id = 'so{?v?Zl?"6kK'
#       tags << debug_id

#       enable_debugger = Tag::EnableDebugger2.new
#       enable_debugger.reserved = 6517
#       enable_debugger.password = "$1$Xz$Sknz.DjgLWj/AvuUekVF0/"
#       tags << enable_debugger

#       bg_color = Tag::SetBackgroundColor.new
#       bg_color.background_color = @background_color
#       tags << bg_color

#       frame_label = Tag::FrameLabel.new
#       frame_label.name = 'Frame1'
#       tags << frame_label

#       abc = Tag::DoABC.new
#       abc.flags = 1
#       abc.name = "aruby"
#       abc.bytecode = @interpreter.generate_byte_code(@entry_class)
#       tags << abc

#       symbol_class = Tag::SymbolClass.new
#       symbol_class.symbols << {:tag=>0, :name=> @entry_class}
#       tags << symbol_class

#       show_frame = Tag::ShowFrame.new
#       tags << show_frame

#       end_tag = Tag::End.new
#       tags << end_tag

      tags
    end
  end
end
