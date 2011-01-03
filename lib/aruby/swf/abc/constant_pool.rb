module ARuby
  class SWF
    class ABC
      class ConstantPool < StructuredObject
        # struct do
        #   s32 :ints,    :array => {:storage => :u30, :allow_nil => true}
        #   u32 :uints,   :array => {:storage => :u30, :allow_nil => true}
        #   d64 :doubles, :array => {:storage => :u30, :allow_nil => true}
        #   len_string :strings, :array => {:storage => :u30, :allow_nil => true}
        # end
          
        attr_accessor :ints
        attr_accessor :uints
        attr_accessor :doubles
        attr_accessor :strings
        attr_accessor :namespaces
        attr_accessor :ns_sets
        attr_accessor :multinames

        def initialize
          super
          clear_arrays
        end

        def clear_arrays
          @ints = [nil]
          @uints = [nil]
          @doubles = [nil]
          @strings = [nil]
          @namespaces = [nil]
          @ns_sets = [nil]
          @multinames = [Multiname.new(nil,nil,nil,nil,self)]
        end



        def write_to_io(io)

          # ints.unshift nil
          # puts "+ Writing ints(#{ints.size-1}):".yellowish
          # ARuby.print_multiline ints.to_a
          # puts "+ Writing uints(#{uints.size-1}):".yellowish
          # ARuby.print_multiline uints.to_a
          # puts "+ Writing doubles(#{doubles.size-1}):".yellowish
          # ARuby.print_multiline doubles.to_a
          # puts "+ Writing strings(#{strings.size-1}):".yellowish
          # ARuby.print_multiline strings.to_a
          # ints.shift
          # uints.shift
          # doubles.shift
          # strings.shift
          # serialize_struct(io)
          
          write_skip_first("ints", io, @ints      ){ |v| io.write_s32(v) }
          write_skip_first("uints", io, @uints     ){ |v| io.write_u32(v) }
          write_skip_first("doubles", io, @doubles   ){ |v| io.write_d64(v) }
          write_skip_first("strings", io, @strings   ){ |v| io.write_len_string(v.to_s) }
          write_skip_first("namespaces", io, @namespaces){ |v| io.write v.serialize_struct }
          write_skip_first("ns_sets", io, @ns_sets   ){ |v| v.write_to_io(io) }
          write_skip_first("multinames", io, @multinames){ |v| v.write_to_io(io) }

          self
        end

        def write_skip_first name, io, arr

          arr_size = arr.length
          puts "+ Writing #{name}(#{arr_size-1}):".yellowish
          if arr_size > 1
            io.write_u30 arr_size
            1.upto(arr_size-1) do |i|
              yield arr[i]
            end
            ARuby.print_multiline arr
          else
            io.write_u30 0
          end
        end


        def read_from_io(io)

          read_skip_first("ints", io, @ints      ){ io.read_s32 }
          read_skip_first("uints", io, @uints     ){ io.read_u32 }
          read_skip_first("doubles", io, @doubles   ){ io.read_d64 }
          read_skip_first("strings", io, @strings   ){ io.read_len_string }
          read_skip_first("namespaces", io, @namespaces){ ns = Namespace.new(nil, nil, self); ns.unserialize_struct(io); ns }
          read_skip_first("ns_sets", io, @ns_sets   ){ NsSet.new_from_io(io, self) }
          read_skip_first("multinames", io, @multinames){ Multiname.new_from_io(io, self) }

          self
        end

        def read_skip_first name, io, arr
          size = io.read_u30
          size-=1 if size > 0
          puts "+ Reading #{name}(#{size}):".yellowish

          return if size < 1

          1.upto(size) do |i|
            arr << yield
          end
          ARuby.print_multiline arr

        end



        def find_arr(value, arr)
          arr.index(value)
        end

        def find_int(value)       find_arr(value, @ints)       end
        def find_uint(value)      find_arr(value, @uints)      end
        def find_double(value)    find_arr(value, @doubles)    end
        def find_string(value)    find_arr(value, @strings)    end
        def find_namespace(value) find_arr(value, @namespaces) end
        def find_ns_set(value)    find_arr(value, @ns_sets)    end
        def find_multiname(value) find_arr(value, @multinames) end




        def add_arr(value, arr)
          loc = arr.index(value)
          if not loc
            loc = arr.length
            arr.push(value)
          end
          loc
        end

        def add_int(value)       add_arr(value, ints)       end
        def add_uint(value)      add_arr(value, uints)      end
        def add_double(value)    add_arr(value, doubles)    end
        def add_string(value)    add_arr(value, strings)    end
        def add_namespace(value) add_arr(value, @namespaces) end
        def add_ns_set(value)    add_arr(value, @ns_sets)    end
        def add_multiname(value) add_arr(value, @multinames) end

      end
    end
  end
end
