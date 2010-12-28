module ARuby
  class SWF
    class ABC
      class MetaData
        def initialize(abc_file=nil)
          @abc_file = abc_file
          @items = []
        end
        
        def inspect
          "#<MetaData:0x#{object_id.to_s(16)} @name_index=#{@name_index} @item_count=#{@item_count}>\n"+
          "  | items:" +
          @items.ai + "\n"
        end

        def read_from_io(io)
          @name_index = io.read_u30
          @item_count = io.read_u30
          
          1.upto(@item_count) do |i|
            @items << ARuby::SWF::ABC::MetaData_Item.new(@abc_file).read_from_io(io)
          end
          
          self
        end
      end
    end
  end
end
