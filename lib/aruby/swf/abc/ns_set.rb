module ARuby
  class SWF
    class ABC
      class NsSet
        attr_accessor :ns_indices

        def self.new_from_io(io=nil, constant_pool=nil)
          ns = NsSet.new(nil,constant_pool)
          ns.read_from_io(io)
        end

        def initialize(ns_indices=nil, constant_pool=nil)
          @ns_indices = ns_indices
          @constant_pool = constant_pool
        end

        def inspect
          "#<NsSet:0x#{object_id.to_s(16)} @ns_indices=#{@ns_indices}>"
        end

        def to_s
          "<NsSet ns_indices=#{@ns_indices}>"
        end

        def ==(o)
          @ns_indices == o.ns_indices
        end

        def ns
          ns_indices.map { |index| @constant_pool.namespaces[index] }
        end

        def read_from_io(io)
          count = io.read_u30
          @ns = []
          @ns_indices = []
          1.upto(count) do
            index = io.read_u30
            @ns_indices << index
            #@ns << constant_pool.namespaces[index]
          end

          self
        end

        def write_to_io(io)
          io.write_u30 @ns_indices.length
          @ns_indices.each { |i| io.write_u30 i }

          self
        end
      
        def add_namespace(ns_index)
          ns_indices << ns_index unless ns_indices.index(ns_index)
        end
      end
    end
  end
end