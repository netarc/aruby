module ARuby
  class SWF
    class ABC
      class Namespace < StructuredObject
        define_format do
          struct :kind,       :type => :ui8
          struct :name_index, :type => :u30
        end
      
        # attr_accessor :kind, :name_index

        NamespaceC         = 0x08
        PackageNamespace   = 0x16
        PackageInternalNs  = 0x17
        ProtectedNamespace = 0x18
        ExplicitNamespace  = 0x19
        StaticProtectedNs  = 0x1A
        PrivateNs          = 0x05

        def name
          @constant_pool.strings[name_index] if @constant_pool and name_index
        end
        def self.new_from_io(io=nil, constant_pool=nil)
          ns = Namespace.new(nil,nil,constant_pool)
          ns.read_from_io(io)
        end
        def self.kind_to_s(kind)
          case kind
          when Namespace::NamespaceC
            "Namespace"
          when Namespace::PackageNamespace
            "PackageNamespace"
          when Namespace::PackageInternalNs
            "PackageInternalNs"
          when Namespace::ProtectedNamespace
            "ProtectedNamespace"
          when Namespace::ExplicitNamespace
            "ExplicitNamespace"
          when Namespace::StaticProtectedNs
            "StaticProtectedNs"
          when Namespace::PrivateNs
            "PrivateNs"
          end
        end
        def initialize(kind=nil, name_index=nil, constant_pool=nil)
          super()
          self.kind = kind
          self.name_index = name_index
          @constant_pool = constant_pool
        end

        def inspect
          "#<Namespace:0x#{object_id.to_s(16)} @kind=#{Namespace.kind_to_s(kind)} @name=#{name_index}|#{name.inspect}>"
        end

        def read_from_io(io)
          kind = io.read_ui8
          name_index = io.read_ui30
          self
        end

        def write_to_io(io)
          io.write_ui8 kind
          io.write_u30 name_index
        end

        def to_s
          "(#{Namespace.kind_to_s(kind)})#{name}"
        end

        def ==(o)
          kind == o.kind and name_index == o.name_index
        end
      end
    end
  end
end