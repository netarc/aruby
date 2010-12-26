module ARuby
  class SWF
    class ABC
      class MetaData
        def initialize(abc_file=nil)
          @abc_file = abc_file
        end
        
        def inspect
          "#<Script:0x#{object_id.to_s(16)} @name_index=#{@name_index}>"
        end

        def read_from_io(io)
          io.write_u30 @name_index
          io.write_u30 @item_count
          self
        end
      end
    end
  end
end
