class ByteBuffer

  # 1-Byte Numbers
  alias_type :ui8, :uint8
  alias_type :si8, :int8
  # 2-Byte Numbers
  alias_type :ui16, :uint16
  alias_type :si16, :int16
  # 3-Byte Numbers
  define_type :ui24 do |type|
    type.read = Proc.new do |byte_buffer, args|
      v = byte_buffer.read(3, :signed => true).to_i
      v = (v-0x1000000) if v & 0x800000 != 0
      v
    end
    type.write = Proc.new do |byte_buffer, data|
      byte_buffer.write [data.to_i].pack('l')[0..-2]
    end
  end

  define_type :si24 do |type|
    type.read = Proc.new do |byte_buffer, args|
      v = byte_buffer.read(3).to_i
      v = (v-0x1000000) if v & 0x800000 != 0
      v
    end
    type.write = Proc.new do |byte_buffer, data|
      byte_buffer.write [data.to_i].pack('L')[0..-2] }
  end

  # 4-Byte Numbers
  alias_type :ui32, :uint32
  alias_type :si32, :int32
  # 8-Byte Numbers
  alias_type :ui64, :uint64
  alias_type :si64, :int64


  alias_type :d64, :double


  define_type :u30 do |type|
    type.read = Proc.new do |byte_buffer, args|
      byte_buffer.read_u32 & 0x3fffffff
    end
    type.write = Proc.new do |byte_buffer, data|
      byte_buffer.write_u32 (value & 0x3fffffff)
    end
  end

  define_type :u32 do |type|
    type.read = Proc.new do |byte_buffer, args|
      shift = 0
      value = 0
      while true
        byte = byte_buffer.read_byte.to_i
        if byte & 0x80 == 0
          value |= (byte << shift)
          break
        else
          value |= ((byte & 0x7F) << shift)
        end
        shift += 7
      end
      value
    end
    type.write = Proc.new do |byte_buffer, data|
      value = data.to_i
      bits = (Math.log(value.abs)/Math.log(2)).floor + 1
      shift = 0
      while bits > 0
        vv = (value >> shift) & 0x7F
        vv |= 0x80 if (bits > 7)
        byte_buffer.write_byte vv
        shift+= 7
        bits -= 7
      end
    end
  end


  define_type :u32 do |type|
    type.read = Proc.new do |byte_buffer, args|
      shift = 0
      value = 0
      while true
        byte = byte_buffer.read_byte.to_i
        if byte & 0x80 == 0
          byte = (byte-128) if byte & 0x40 != 0
          value |= (byte << shift)
          break
        else
          value |= ((byte & 0x7F) << shift)
        end
        shift += 7
      end
      value
    end
    type.write = Proc.new do |byte_buffer, data|
      value = data.to_i
      bits = (Math.log(value.abs)/Math.log(2)).floor + 1
      shift = 0
      while bits > 0
        vv = (value >> shift) & 0x7F
        vv |= 0x80 if (bits > 7)
        byte_buffer.write_byte vv
        shift+= 7
        bits -= 7
      end
    end
  end


#   define_type :len_string,
#                 :default => "",
#                 :read => Proc.new { size = read_u30
#                                   size > 0 ? read(size).to_s : ""
#                                 },
#                 :write => Proc.new { write_u30 value.length
#                                    write value if value.length > 0
#                                  }

#   define_type :rgb,
#                 :default => 0,
#                 :read => Proc.new { rgb = read_byte_val(false) << 16
#                                   rgb |= read_byte_val(false) << 8
#                                   rgb |= read_byte_val(false)
#                                 },
#                 :write => Proc.new { write_ui8 (value >> 16) & 0xFF
#                                    write_ui8 (value >> 8) & 0xFF
#                                    write_ui8 value & 0xFF
#                                  }

#   define_type :fixed8,
#                 :default => {},
#                 :read => Proc.new { ui16 = read_ui16
#                                   {:whole=>(ui16>>8), :fraction=>(ui16&0xFF)}
#                                 },
#                 :write => Proc.new { ui16 = (value[:whole] << 8) | (value[:fraction]&0xFF)
#                                    write_ui16 ui16
#                                  }

#   define_type :rect,
#                 :default => {},
#                 :read => Proc.new { bits = read_bits 5;
#                                   xmin = read_bits bits
#                                   xmax= read_bits bits
#                                   ymin = read_bits bits
#                                   ymax = read_bits bits
#                                   {:xmin=>xmin, :xmax=>xmax, :ymin=>ymin, :ymax=>ymax}
#                                 },
#                 :write => Proc.new {
#                                     largest = 0
#                                     actual_value = 0
#                                     value.each_value {|v|
#                                       if v.abs > largest
#                                         largest = v.abs
#                                         actual_value = v
#                                       end
#                                     }
#                                     bits = largest.sbits
#                                     write_bits 5, bits
#                                     write_bits bits, value[:xmin]
#                                     write_bits bits, value[:xmax]
#                                     write_bits bits, value[:ymin]
#                                     write_bits bits, value[:ymax]
#                                 }

end
