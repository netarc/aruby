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
      byte_buffer.write [data.to_i].pack('L')[0..-2]
    end
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
      byte_buffer.write_u32 data.to_i & 0x3fffffff
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
      bits = value > 0 ? (Math.log(value.abs)/Math.log(2)).floor + 1 : 1
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


  define_type :s32 do |type|
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
      bits = value > 0 ? (Math.log(value.abs)/Math.log(2)).floor + 1 : 1
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

  define_type :len_string do |type|
    type.conversion = :to_s
    type.read = Proc.new do |byte_buffer, args|
      size = byte_buffer.read_u30
      size > 0 ? byte_buffer.read(size) : ""
    end
    type.write = Proc.new do |byte_buffer, data|
      data = data.to_s
      byte_buffer.write_u30 data.length
      byte_buffer.write data if data.length > 0
    end
  end
  
  define_type :rgb do |type|
    type.read = Proc.new do |byte_buffer, args|
      rgb = byte_buffer.read_byte << 16
      rgb |= byte_buffer.read_byte << 8
      rgb |= byte_buffer.read_byte
    end
    type.write = Proc.new do |byte_buffer, data|
      byte_buffer.write_byte (data >> 16) & 0xFF
      byte_buffer.write_byte (data >> 8) & 0xFF
      byte_buffer.write_byte data & 0xFF
    end
  end

  define_type :fixed8 do |type|
    type.conversion = nil
    type.read = Proc.new do |byte_buffer, args|
      ui16 = byte_buffer.read_ui16
      {:whole => (ui16>>8), :fraction => (ui16 & 0xFF)}
    end
    type.write = Proc.new do |byte_buffer, data|
      ui16 = (data[:whole] << 8) | (data[:fraction] & 0xFF)
      byte_buffer.write_ui16(ui16)
    end
  end

  define_type :rect do |type|
    type.conversion = nil
    type.read = Proc.new do |byte_buffer, args|
      bits = byte_buffer.read_bits(5)
      {
        :xmin => byte_buffer.read_bits(bits),
        :xmax => byte_buffer.read_bits(bits),
        :ymin => byte_buffer.read_bits(bits),
        :ymax => byte_buffer.read_bits(bits)
      }
    end
    type.write = Proc.new do |byte_buffer, data|
      largest = 0
      actual_value = 0
      data.each_value {|v|
        if v.abs > largest
          largest = v.abs
          actual_value = v
        end
      }
      bits = (Math.log(largest.abs)/Math.log(2)).floor + 2
      byte_buffer.write_bits 5, bits
      byte_buffer.write_bits bits, data[:xmin]
      byte_buffer.write_bits bits, data[:xmax]
      byte_buffer.write_bits bits, data[:ymin]
      byte_buffer.write_bits bits, data[:ymax]
    end
  end
end
