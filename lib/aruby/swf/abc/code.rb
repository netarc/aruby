module ARuby
  class SWF
    class ABC
      class Code
        attr_accessor :codes
        def self.new_from_io(io, abc_file=nil)
          n = Code.new(abc_file)
          n.read(io)
        end
        def initialize(abc_file=nil)
          @codes = []
          @abc_file = abc_file
        end
        def read(io)
          start = io.pos
          1.upto(io.size) do |i|
            offset = io.pos
            op = parse_command(io)
            next if not op
            # op.op_offset = offset-start
            # puts " * #{op.to_s}"
            @codes << op
          end

          self
        end
        def to_s
          io = ByteBuffer.new
          write(io)
          # io.rewind
          # io.read
          io.buffer
        end
        def write(io)
          @codes.each do |code|
            # puts " * #{code.to_s} - #{code.serialize_struct.inspect}"
            code.serialize_struct(io)
          end
          self
        end
        def parse_command(io)
          begin
            byte = io.read_ui8
          rescue ByteBuffer::Errors::BufferUnderflow
            return false
          end

          op_class = OpCode::Base.find_class_by_id(byte)
          raise "No opcode defined for #{byte} at #{io.pos}." if not op_class

          io.step -1
          op = op_class.new(@abc_file)
          op.unserialize_struct(io)
          op
        end

      end
    end
  end
end