module ARuby
  class SWF
    class ABC
      class Exception
        def initialize(io=nil, abc_file=nil)
          read_from_io(io, abc_file) if io
        end

        def read_from_io(io, abc_file)
          @from = io.read_u30
          @to = io.read_u30
          @target = io.read_u30
          @exc_type = io.read_u30
          @var_name = io.read_u30

          self
        end
        def write_to_io(io)
          io.write_u30(@from)
          io.write_u30(@to)
          io.write_u30(@target)
          io.write_u30(@exc_type)
          io.write_u30(@var_name)

          self
        end
      end
    end 
  end
end