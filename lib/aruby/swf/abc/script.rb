module ARuby
  class SWF
    class ABC
      class Script
        attr_accessor :init_index, :traits

        def self.new_from_io(io, abc_file=nil)
          ns = Script.new(abc_file)
          ns.read_from_io(io)
        end

        def initialize(abc_file=nil)
          @abc_file = abc_file
          clear_arrays
        end

        def clear_arrays
          @traits = []
        end

        def init
          @abc_file.abc_methods[@init_index] if @abc_file and @init_index
        end
      
        def inspect
          "#<Script:0x#{object_id.to_s(16)} @method_index=#{@init_index}>\n" +
          "  | traits:" +
          @traits.ai + "\n"
        end

        def read_from_io(io)
          clear_arrays

          @init_index = io.read_u30

          trait_count = io.read_u30
          1.upto(trait_count) do
            @traits << Trait.new_from_io(io, @abc_file)
          end

          self
        end
        def write_to_io(io)
          io.write_u30 @init_index

          io.write_u30 @traits.length
          @traits.each do |t|
            t.write_to_io(io)
          end

          self
        end
      end
    end
  end
end