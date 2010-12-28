module ARuby
  class SWF
    class ABC
      class MethodBody
        attr_accessor :method_index
        attr_accessor :max_stack, :local_count
        attr_accessor :init_scope_depth, :max_scope_depth
        attr_accessor :code
        attr_accessor :exceptions
        attr_accessor :traits

        def self.new_from_io(io, abc_file=nil)
          ns = MethodBody.new(abc_file)
          ns.read_from_io(io)
        end

        def initialize(abc_file=nil)
          @abc_file = abc_file
          clear_arrays
        end

        def clear_arrays
          @exceptions = []
          @traits = []
          @code = Code.new(@abc_file)
        end

        def method
          @abc_file.abc_methods[@method_index] if @abc_file and @method_index
        end

        def inspect
          "#<MethodBody:0x#{object_id.to_s(16)} @method_index=#{@method_index} @max_stack=#{@max_stack} @local_count=#{@local_count} @init_scope_depth=#{@init_scope_depth} @max_scope_depth=#{@max_scope_depth} @exceptions=#{@exceptions} @traits=#{@traits} @code=\"#{@code.codes.length} opcodes\">\n" +
          "  | codes:" +
          @code.codes.ai + "\n" + 
          "  | exceptions:" +
          @exceptions.ai + "\n" +
          "  | traits:" +
          @traits.ai + "\n"
        end

        def read_from_io(io)
          clear_arrays

          @method_index = io.read_u30
        
          @max_stack = io.read_u30
          @local_count = io.read_u30
          @init_scope_depth = io.read_u30
          @max_scope_depth = io.read_u30

          code_length = io.read_u30
          code_data = io.read code_length

          # parse abc code
          @code = Code.new_from_io(ByteBuffer.new(code_data.to_s), @abc_file)

          exception_count = io.read_u30
          1.upto(exception_count) do
            e = Exception.new(io, @abc_file)
            @exceptions << e
          end

          trait_count = io.read_u30
          1.upto(trait_count) do
            t = Trait.new_from_io(io, @abc_file)
            @traits << t
          end

          self
        end
        def write_to_io(io)
        
          io.write_u30 @method_index

          io.write_u30 @max_stack
          io.write_u30 @local_count
          io.write_u30 @init_scope_depth
          io.write_u30 @max_scope_depth

          code_data = @code.to_s
          io.write_u30(code_data.length)
          io.write(code_data)

          io.write_u30(@exceptions.length)
          @exceptions.each do |e|
            e.write_to_io io
          end

          io.write_u30(@traits.length)
          @traits.each do |t|
            t.write_to_io io
          end

          self
        end
      end
    end
  end
end