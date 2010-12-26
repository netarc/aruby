module ARuby
  class SWF
    class ABC
      class MetaData_Item
        def initialize(abc_file=nil)
          @abc_file = abc_file
        end
        
        def inspect
          "#<MetaData_Item:0x#{object_id.to_s(16)} @key=#{@key_index}|#{key} @value=#{@value_index}|#{value}>"
        end

        def read_from_io(io)
          @key_index = io.read_u30
          @value_index = io.read_u30
          
          self
        end
        
        def key
          @abc_file.strings[@key_index] if @abc_file and @key_index
        end
        
        def value
          @abc_file.strings[@value_index] if @abc_file and @value_index
        end
      end
    end
  end
end
