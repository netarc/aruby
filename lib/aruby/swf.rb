require 'zlib'
require 'aruby/swf/abc'

module ARuby
  class SWF
    autoload :Tag,         'aruby/swf/tag'

    def initialize(env)
      @env = env
      reset!
    end

    # Load SWF data from a .swf file. This will clear any data currently in our SWF
    def read_from_file(file_path)
      reset!
      from_swf(file_path)
    end

    # Export our SWF data to a target file
    def write_to_file(file_path)
      output_file = File.new(file_path, "w")
      output_file.binmode
      output_file.write(to_swf)
      output_file.close
    end

    # Include a file for assembly into the SWF.
    #
    # @param path [String] Path to ruby source file or Gem.
    def include(path)
      @workspace.include(path)
    end

    private

    # General HeaderStruct
    class Header < StructuredObject
      struct do
        byte   :signature, :array => {:fixed_size => 3}
        ui8    :version
        ui32   :file_size
        string :body
      end
    end

    def reset!
      @entry_class = ""
      @workspace = ARuby::Workspace.new(@env)
    end

    def from_swf(file_path)
      buffer = nil
      File.open(file_path, "r") do |file|
        file.binmode
        buffer = ByteBuffer.new(file.read)
      end

      header = Header.new
      header.unserialize_struct(buffer)

      @compressed = header.signature.collect{|i| i.chr}.join == "CWS"

      body_io = ByteBuffer.new(@compressed ? Zlib::Inflate.inflate(header.body.to_s) : header.body.to_s)

      body_io.read_rect # frame_size
      body_io.read_fixed8 # frame_rate
      body_io.read_ui16 # frame_coutn

      while (tag = Tag::Base.new_from_io(body_io))
        @env.logger.info "loaded tag: #{tag.id}"

        if tag.is_a?(Tag::SymbolClass)
          # @entry_class = tag.symbols[0].name
        elsif tag.is_a?(Tag::SetBackgroundColor)
          # @background_color = tag.background_color
        elsif tag.is_a?(Tag::DoABC)
          abc = ARuby::SWF::ABC.new
          abc.unserialize(ByteBuffer.new(tag.bytecode.to_s))
          # @workspace.process_swf_bytecode tag.bytecode.to_s
        end
      end
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

      script_limits = Tag::ScriptLimits.new
      script_limits.max_recursion_depth = 1000
      script_limits.script_timeout_secs = 60
      tags << script_limits

      debug_id = Tag::DebugID.new
      debug_id.debug_id = 'so{?v?Zl?"6kK'.split('')
      tags << debug_id

      enable_debugger = Tag::EnableDebugger2.new
      enable_debugger.reserved = 6517
      enable_debugger.password = "$1$Xz$Sknz.DjgLWj/AvuUekVF0/"
      tags << enable_debugger

      bg_color = Tag::SetBackgroundColor.new
      bg_color.background_color = @env.config.swf.background_color
      tags << bg_color

      frame_label = Tag::FrameLabel.new
      frame_label.name = 'Frame1'
      tags << frame_label

      abc = Tag::DoABC.new
      abc.flags = 1
      abc.name = "aruby"
      abc.bytecode = @workspace.generate_byte_code
      tags << abc

      symbol_class = Tag::SymbolClass.new
      symbol = symbol_class.symbols.new
      symbol.tag = 0
      symbol.name = @env.config.swf.entry_class
      symbol_class.symbols << symbol
      tags << symbol_class

      show_frame = Tag::ShowFrame.new
      tags << show_frame

      end_tag = Tag::End.new
      tags << end_tag

      tags
    end
  end
end
