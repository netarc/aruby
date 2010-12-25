module ARuby
  class SWF
    class ABC
      class Instance
      
        attr_accessor :name_index, :super_name_index
        attr_accessor :abc_class
        attr_accessor :flags
        attr_accessor :protected_namespace_index
        attr_accessor :interface_indices
        attr_accessor :iinit_index
        attr_accessor :traits

        Sealed = 0x01
        Final = 0x02
        Interface = 0x03
        ProtectedNamespace = 0x08


        def initialize(abc_file=nil)
          clear_arrays
          @abc_file = abc_file
        end
      
      
        def inspect
          "#<Instance:0x#{object_id.to_s(16)} @name=#{@name_index}|#{name.inspect} @super=#{@super_name_index}|#{super_name} @protected_namespace=#{protected_namespace} @flags=#{@flags} @traits=#{@traits.ai({})}>"
        end
      
      
        def write_to_io(io)
          io.write_u30 @name_index
          io.write_u30 @super_name_index
          io.write_ui8 @flags

          if @flags & ProtectedNamespace != 0
            io.write_u30 @protected_namespace_index
          end

          io.write_u30 @interface_indices.length
          @interface_indices.each { |v| io.write_u30(v) }

          io.write_u30 @iinit_index


          io.write_u30 @traits.length
          @traits.each do |t|
            # puts "   * writing trait: #{t.to_s}"
            t.write_to_io(io)
          end


          self
        end
      
        def read_from_io(io)
          @name_index = io.read_u30
          @super_name_index = io.read_u30
          @flags = io.read_ui8

          if @flags & ProtectedNamespace != 0
            @protected_namespace_index = io.read_u30 
          end

          size = io.read_u30 
          1.upto(size) do |i|
            @interface_indices << io.read_u30
          end

          @iinit_index = io.read_u30 

          size = io.read_u30 
          1.upto(size) do |i|
            t = Trait.new_from_io(io, @abc_file)
            # puts "   * reading trait: #{t.to_s}"
            @traits << t
          end

        
          self
        end
      
      
        def clear_arrays
          @interface_indices = []
          @traits = []
          @protected_namespace_index = nil
        end
      
        def protected_namespace
          @abc_file.namespaces[@protected_namespace_index] if @abc_file and @protected_namespace_index
        end
      
        def name
          @abc_file.multinames[@name_index] if @abc_file and @name_index
        end
      
        def super_name
          @abc_file.multinames[@super_name_index] if @abc_file and @super_name_index
        end
      end
    end
  end
end