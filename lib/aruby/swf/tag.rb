module ARuby
  class SWF
    module Tag
      class Base < StructuredObject
        TAG_BY_CLASS = {}
        TAG_BY_ID = {}

        attr_reader :id

        def self.define_tag id
          TAG_BY_CLASS[self] = id
          TAG_BY_ID[id] = self
        end

        def self.new_from_io(io)
          tag_header = io.read_ui16
          return nil unless tag_header

          tag_id = tag_header >> 6
          tag_length = tag_header & 0b111111
          tag_length = io.read_ui32 if tag_length == 0x3F
          tag_contents = io.read(tag_length).to_s

          klass = TAG_BY_ID[tag_id]
          return nil if klass.nil?

          klass.new.unserialize(ByteBuffer.new(tag_contents))
        end


        def initialize
          super
          @id = TAG_BY_CLASS[self.class]
        end

        # Override serialization
        def serialize_struct
          contents = super
          content_size = contents.length
          io = ByteBuffer.new
          if content_size < 0x3F
            io.write_ui16 @id << 6 | content_size
          else
            io.write_ui16 @id << 6 | 0x3F
            io.write_ui32 content_size
          end
          io.write contents
          io.buffer
        end
      end


      # End
      # ID: 0
      # DESC: Last tag in our file
      class End < Base
        define_tag 0
      end

      # ShowFrame
      # ID: 1
      # DESC:
      class ShowFrame < Base
        define_tag 1
      end

      # SetBackgroundColor
      # ID: 9
      # DESC: This tag describes information about the tool that compiled the swf as well as date/time/version of the file
      class SetBackgroundColor < Base
        define_tag 9
        struct do
          rgb :background_color
        end
      end


      # ProductInfo
      # ID: 41
      # DESC: This tag describes information about the tool that compiled the swf as well as date/time/version of the file
      class ProductInfo < Base
        define_tag 41
        struct do
          ui32 :product_id
            # 0: Unknown
            # 1: Macromedia Flex for J2EE
            # 2: Macromedia Flex for .NET
            # 3: Adobe Flex
          ui32 :edition_type
            # 0: Developer Edition
            # 1: Full Commercial Edition
            # 2: Non Commercial Edition
            # 3: Educational Edition
            # 4: Not For Resale (NFR) Edition
            # 5: Trial Edition
            # 6: None
          ui8  :version_major
          ui8  :version_minor
          ui32 :build_low
          ui32 :build_high
          ui64 :compile_timestamp
        end
      end


      # FrameLabel
      # ID: 43
      # DESC: This tag describes our default frame anchor
      class FrameLabel < Base
        define_tag 43
        struct do
          null_string :name
        end
      end


      # DebugID
      # ID: 63
      # DESC: This tag marks a unique debug id to link our swf to our file
      class DebugID < Base
        define_tag 63
        struct do
          byte :debug_id, :size => 16
        end
      end

      # EnableDebugger2
      # ID: 64
      # DESC: This tag marks a unique debug id to link our swf to our file
      class EnableDebugger2 < Base
        define_tag 64
        struct do
          ui16 :reserved
          null_string :password
        end
      end


      # FileAttributes
      # ID: 65
      # DESC: This tag marks script settings for our file
      class ScriptLimits < Base
        define_tag 65
        struct do
          ui16 :max_recursion_depth
          ui16 :script_timeout_secs
        end
      end

      # FileAttributes
      # ID: 69
      # DESC: This tag marks several true/false valeus for our swf
      class FileAttributes < Base
        define_tag 69
        struct do
          bit :reserved1
          # These 2 flags are only valid in Stand Alone players with Version 10+
          bit :use_direct_blit
          bit :use_gpu
          #
          bit :has_metadata
          bit :actionscript3
          bit :reserved2, :size => 2
          bit :use_network
          bit :reserved3, :size => 24
        end
      end

      # SymbolClass
      # ID: 76
      # DESC: This tag denotes symbol links to as3 classes
      class SymbolClass < Base
        define_tag 76
        struct do
          struct :symbols, :length => 0, :storage => :ui16 do
            ui16 :tag
            null_string :name
          end
        end
      end

      # MetaData
      # ID: 77
      # DESC: This tag marks several true/false valeus for our swf
      class MetaData < Base
        define_tag 77
        struct do
          string :metadata
        end
      end

      # DoABC
      # ID: 82
      # DESC: This tag denotes our files bytecodes for execution
      class DoABC < Base
        define_tag 82
        struct do
          ui32 :flags
          null_string :name
          string :bytecode
        end
      end
    end
  end
end
