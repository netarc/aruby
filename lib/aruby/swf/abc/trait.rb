module ARuby
  class SWF
    class ABC
      class Trait
        attr_accessor :name_index, :type, :data
        attr_accessor :has_metadata, :final, :override
        attr_accessor :metadatas
        SlotId = 0
        MethodId = 1
        GetterId = 2
        SetterId = 3
        ClassId = 4
        FunctionId = 5
        ConstId = 6

        Final    = 0x01
        Override = 0x02
        Metadata = 0x04


        def to_s
          "#<Trait:0x#{object_id.to_s(16)} @type=#{@type} @name=#{@name_index}|#{name} @data=#{@data.to_s}>"
        end
      
        def self.new_from_io(io, abc_file=nil)
          ns = Trait.new(abc_file)
          ns.read_from_io(io)
        end

        def initialize(abc_file=nil)
          @abc_file = abc_file
          clear_arrays

          @has_metadata = false
          @final = false
          @override = false
        end

        def clear_arrays
          @metadatas = []
        end

        def name
          @abc_file.constant_pool.multinames[@name_index] if @abc_file and @name_index
        end

        def read_from_io(io)
          clear_arrays

          @name_index = io.read_u30
          kind = io.read_ui8
          @type = kind & 0x0F
          attributes = (kind & 0xF0) >> 4

          @has_metadata = attributes & Metadata != 0
          @final        = attributes & Final    != 0
          @override     = attributes & Override != 0


          case @type
          when SlotId, ConstId
            @data = TraitSlot.new_from_io(io, @abc_file)
          when ClassId
            @data = TraitClass.new_from_io(io, @abc_file)
          when FunctionId
            @data = TraitFunction.new_from_io(io, @abc_file)
          when MethodId, GetterId, SetterId
            @data = TraitMethod.new_from_io(io, @abc_file)
          else
            raise "bad trait value #{kind}."
          end

          if @has_metadata
            metadata_count = io.read_u30
            1.upto(metadata_count) do
              @metadatas << io.read_u30
            end
          end

          self
        end
        def write_to_io(io)
          io.write_u30(@name_index)

          attributes = 0
          attributes |= Metadata if @has_metadata
          attributes |= Final    if @final
          attributes |= Override if @override

          io.write_ui8((attributes << 4) | @type)

          case @type
          when SlotId, ConstId
            @data.write_to_io(io)
          when ClassId
            @data.write_to_io(io)
          when FunctionId
            @data.write_to_io(io)
          when MethodId, GetterId, SetterId
            @data.write_to_io(io)
          end

          if @has_metadata
            io.write_u30(@metadatas.length)
            @metadatas.each { |m| io.write_u30(m) }
          end

          self
        end
      end
    
    
      class TraitData
        def self.new_from_io(io, abc_file=nil)
          ns = self.new(abc_file)
          ns.read_from_io(io)
        end

        def initialize(abc_file=nil)
          @abc_file = abc_file
        end
        def read_from_io(io)
          self
        end
        def write_to_io(io)
          self
        end
      end
    
      class TraitSlot < TraitData
        attr_accessor :slot_id, :type_name_index
        attr_accessor :vindex, :vkind
        def type_name
          @abc_file.multinames[@type_name_index] if @abc_file and @type_name_index
        end
        def read_from_io(io)
          @slot_id = io.read_u30
          @type_name_index = io.read_u30
          @vindex = io.read_u30
          @vkind = io.read_ui8 unless @vindex == 0

          self
        end
        def write_to_io(io)
          io.write_u30 @slot_id
          io.write_u30 @type_name_index
          io.write_u30 @vindex
          io.write_ui8 @vkind unless @vindex == 0

          self
        end
      
        def to_s
          "@slot_id=#{@slot_id} @type_name_index=#{@type_name_index} @vindex=#{@vindex} @vkind=#{@vkind}"
        end
      
      end
    
      class TraitClass < TraitData
        attr_accessor :slot_id, :class_index
        def clazz
          @abc_file.classes[@class_index] if @abc_file and @class_index
        end
        def read_from_io(io)
          @slot_id = io.read_u30
          @class_index = io.read_u30

          self
        end
        def write_to_io(io)
          io.write_u30 @slot_id
          io.write_u30 @class_index

          self
        end
      end
    
      class TraitFunction < TraitData
        attr_accessor :slot_id, :function_index
        def function
          @abc_file.abc_methods[@function_index] if @abc_file and @function_index
        end
        def read_from_io(io)
          @slot_id = io.read_u30
          @function_index = io.read_u30

          self
        end
        def write_to_io(io)
          io.write_u30 @slot_id
          io.write_u30 @function_index

          self
        end
      end
    
      class TraitMethod < TraitData
        attr_accessor :disp_id, :method_index
        def method
          @abc_file.abc_methods[@method_index] if @abc_file and @method_index
        end
        def read_from_io(io)
          @disp_id = io.read_u30
          @method_index = io.read_u30

          self
        end
        def write_to_io(io)
          io.write_u30 @disp_id
          io.write_u30 @method_index

          self
        end
      
        def to_s
          "@disp_id=#{@disp_id} @method_index=#{@method_index}"
        end
      end
    end
  end
end