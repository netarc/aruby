module ARuby
  class SWF
    class ABC
      class Multiname
        attr_accessor :kind, :ns_index, :name_index, :ns_set_index

        MultinameQName = 0x07
        MultinameQNameA = 0x0D
        MultinameRTQName = 0x0F
        MultinameRTQNameA = 0x10
        MultinameRTQNameL = 0x11
        MultinameRTQNameLA = 0x12
        MultinameC = 0x09
        MultinameA = 0x0E
        MultinameL = 0x1B
        MultinameLA = 0x1C

        def self.new_from_io(io=nil, constant_pool=nil)
          m = Multiname.new(nil,nil,nil,nil,constant_pool)
          m.read_from_io(io)
        end
      
        def clone_to_pool(cpool)
          m = Multiname.new(@kind, 
                            cpool.add_string(name),
                            @ns_index,
                            @ns_set_index,
                            cpool)
          cpool.add_multiname m
        end
      
        def self.kind_to_s(kind)
          case kind
          when nil
            "Multiname-index-0"
          when Multiname::MultinameQName
            "MultinameQName"
          when Multiname::MultinameQNameA
            "MultinameQNameA"
          when Multiname::MultinameRTQName
            "MultinameRTQName"
          when Multiname::MultinameRTQNameA
            "MultinameRTQNameA"
          when Multiname::MultinameRTQNameL
            "MultinameRTQNameL"
          when Multiname::MultinameRTQNameLA
            "MultinameRTQNameLA"
          when Multiname::MultinameC
            "Multiname"
          when Multiname::MultinameA
            "MultinameA"
          when Multiname::MultinameL
            "MultinameL"
          when Multiname::MultinameLA
            "MultinameLA"
          end
        end

        def initialize(kind=nil, name_index=nil, ns_index=nil, ns_set_index=nil, constant_pool=nil)
          @kind = kind
          @name_index = name_index
          @ns_index = ns_index
          @ns_set_index = ns_set_index
          @constant_pool = constant_pool
        end

        def inspect
          content = ""
          case @kind
            when MultinameQName, MultinameQNameA
              content = "@name=#{@name_index}|#{name.inspect} @ns=#{@ns_index}|#{ns}"
            when MultinameRTQName, MultinameRTQNameA
              content = "@name=#{@name_index}|#{name.inspect}"
            when MultinameRTQNameL, MultinameRTQNameLA
              content = ""
            when MultinameC, MultinameA
              content = "@name=#{@name_index}|#{name.inspect} @ns_set=#{@ns_set_index}::#{ns_set}"
            when MultinameL, MultinameLA
              content = "@ns_set=#{@ns_set_index}::#{ns_set}"
          end
          "#<Multiname:0x#{object_id.to_s(16)} @kind=#{Multiname.kind_to_s(@kind)} #{content}>"
        end
      
        def ==(o)
          @kind == o.kind and
            @ns_index == o.ns_index and
            @name_index == o.name_index and
            @ns_set_index == o.ns_set_index
        end

        def ns
          @constant_pool.namespaces[@ns_index] if @constant_pool and @ns_index
        end
        def name
          @constant_pool.strings[@name_index] if @constant_pool and @name_index
        end
        def ns_set
          @constant_pool.ns_sets[@ns_set_index] if @constant_pool and @ns_set_index
        end

        def read_from_io(io)
          @kind = io.read_ui8
          case @kind
          when MultinameQName, MultinameQNameA
            @ns_index = io.read_u30
            @name_index = io.read_u30
          when MultinameRTQName, MultinameRTQNameA
            @name_index = io.read_u30
          when MultinameRTQNameL, MultinameRTQNameLA
            # no data
          when MultinameC, MultinameA
            @name_index = io.read_u30
            @ns_set_index = io.read_u30
          when MultinameL, MultinameLA
            @ns_set_index = io.read_u30
          end

          self
        end

        def write_to_io(io)
          io.write_ui8 @kind
          case @kind
          when MultinameQName, MultinameQNameA
            io.write_u30 @ns_index
            io.write_u30 @name_index
          when MultinameRTQName, MultinameRTQNameA
            io.write_u30 @name_index
          when MultinameRTQNameL, MultinameRTQNameLA
            # no data
          when MultinameC, MultinameA
            io.write_u30 @name_index
            io.write_u30 @ns_set_index
          when MultinameL, MultinameLA
            io.write_u30 @ns_set_index
          end

          self
        end

        def to_s
          case @kind
          when MultinameQName, MultinameQNameA
            "(#{Multiname.kind_to_s(@kind)})#{ns}::#{name}"
          when MultinameRTQName, MultinameRTQNameA
            "(#{Multiname.kind_to_s(@kind)})stack::#{name}"
          when MultinameRTQNameL, MultinameRTQNameLA
            # no data
            "(#{Multiname.kind_to_s(@kind)})stack::stack"
          when MultinameC, MultinameA
            "(#{Multiname.kind_to_s(@kind)})Set:#{@ns_set_index}::#{name}"
          when MultinameL, MultinameLA
            "(#{Multiname.kind_to_s(@kind)})Set:#{@ns_set_index}::stack}"
          end
        end
      end
    end
  end
end