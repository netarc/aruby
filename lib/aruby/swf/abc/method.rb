module ARuby
  class SWF
    class ABC
      class Method
        NeedArguments  = 0x01
        NeedActivation = 0x02
        NeedRest       = 0x04
        HasOptional    = 0x08
        SetDxns        = 0x40
        HasParamNames  = 0x80


        attr_accessor :return_type_index, :param_types
        attr_accessor :name_index

        attr_accessor :need_arguments, :need_activation, :need_rest
        attr_accessor :has_optional, :set_dxns, :has_param_names

        attr_accessor :options, :param_names

        attr_accessor :body_index
      
      
      #===============================================================================
      # Instantiation
      #===============================================================================


        def self.new_from_io(io, abc_file=nil)
          _self = Method.new(abc_file)
          _self.unserialize(io)
        end

        def initialize(abc_file=nil)
          @abc_file = abc_file
          clear_arrays

          @need_arguments   = false
          @need_activation  = false
          @need_rest        = false
          @has_optional     = false
          @set_dxns         = false
          @has_param_names  = false
        end


      #===============================================================================
      # IO
      #===============================================================================

        def unserialize(io)
          clear_arrays

          param_count = io.read_u30
          @return_type_index = io.read_u30
          1.upto(param_count) do
            @param_types << io.read_u30
          end
          @name_index = io.read_u30
          flags = io.read_ui8

          @need_arguments   = flags & NeedArguments  != 0
          @need_activation  = flags & NeedActivation != 0
          @need_rest        = flags & NeedRest       != 0
          @has_optional     = flags & HasOptional    != 0
          @set_dxns         = flags & SetDxns        != 0
          @has_param_names  = flags & HasParamNames  != 0

          if @has_optional
            option_count = io.read_u30
            1.upto(option_count) do
              @options << MethodOptionDetail.new(io, @abc_file)
            end
          end

          if @has_param_names
            1.upto(param_count) do
              @param_names << io.read_u30
            end
          end
        
          self
        end

        def serialize(io)
          io.write_u30 @param_types.length
          io.write_u30 @return_type_index

          @param_types.each { |v| io.write_u30 v }

          io.write_u30 @name_index
          flags = 0
          flags |= NeedArguments  if @need_arguments
          flags |= NeedActivation if @need_activation
          flags |= NeedRest       if @need_rest
          flags |= HasOptional    if @has_optional
          flags |= SetDxns        if @set_dxns
          flags |= HasParamNames  if @has_param_names
          io.write_ui8 flags

          if @has_optional
            io.write_u30 @options.length
            @options.each { |o| o.write_to_io(io) }
          end

          if @has_param_names
            @param_names.each { |n| io.write_u32 n }
          end

          self
        end


      #===============================================================================
      # Accessors
      #===============================================================================
      

        def body
          @abc_file.method_bodies[@body_index] if @abc_file
        end

        def return_type
          @abc_file.multinames[@return_type_index] if @abc_file and @return_type_index
        end

        def name
          @abc_file.strings[@name_index] if @abc_file and @name_index
        end




        def inspect
          "#<Method:0x#{object_id.to_s(16)} @name_index=#{@name_index} @name=#{name.inspect} @return_type_index=#{@return_type_index} @return_type=#{return_type.inspect} @param_types=#{@param_types} @param_names=#{@param_names} @options=#{@options} @need_arguments=#{@need_arguments} @need_activation=#{@need_activation} @need_rest=#{@need_rest} @has_optional=#{@has_optional} @set_dxns=#{@set_dxns} @has_param_names=#{@has_param_names}>"
        end

        def clear_arrays
          @param_types = []
          @options = []
          @param_names = []
        end



      end
    end
  end
end