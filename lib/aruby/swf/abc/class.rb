module ARuby
  class SWF
    class ABC

      # Defines characteristics of an AS3 Class
      class Class
        attr_accessor :cinit_index, :traits


      #===============================================================================
      # Instantiation
      #===============================================================================
    
        def self.new_from_io(io, abc_file=nil)
          klass = Class.new(abc_file)
          klass.unserialize(io)
        end

        def initialize(abc_file=nil)
          clear_arrays
          @abc_file = abc_file
        end

      #===============================================================================
      # Inspect
      #===============================================================================

        def inspect
          "#<Class:0x#{object_id.to_s(16)} @cinit_index=#{@cinit_index} @traits=#{@traits.ai({})}>"
        end
      
        def to_s
          inspect
        end
      

      #===============================================================================
      # IO
      #===============================================================================

        def unserialize(io)
          clear_arrays

          @cinit_index = io.read_u30

          trait_count = io.read_u30      
          1.upto(trait_count) do
            @traits << Trait.new_from_io(io, @abc_file)
          end
        
          self
        end
      
        def serialize(io)
          io.write_u30 @cinit_index

          io.write_u30 @traits.length
          @traits.each do |t|
            t.write_to_io(io)
          end

          self
        end
    
    
      #===============================================================================
      # IO
      #===============================================================================
        def clear_arrays
          @traits = []
        end


        def cinit
          @abc_file.abc_methods[@cinit_index] if @abc_file and @cinit_index
        end


      end
    end
  end
end