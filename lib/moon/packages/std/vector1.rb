module Moon
  class Vector1
    include Comparable
    include Serializable
    include Serializable::Properties

    property :x

    def property_set(key, value)
      send "#{key}=", value
    end

    def property_get(key)
      send key
    end

    # @return [Float]
    def sum
      x
    end

    # @return [Boolean]
    def zero?
      x == 0
    end

    # @return [Integer]
    def <=>(other)
      [x] <=> Vector1.extract(other)
    end

    # @return [Hash<Symbol, Float>]
    def to_h
      { x: x }
    end

    # @return [Integer]
    def to_i
      x.to_i
    end

    # @return [Float]
    def to_f
      x.to_f
    end

    # @return [String]
    def to_s
      "#{x}"
    end

    # @param [Integer] index
    # @return [Float]
    def [](index)
      case index
      when :x, 'x', 0 then x
      end
    end

    # @param [Integer] index
    # @param [Float] value
    def []=(index, value)
      case index
      when :x, 'x', 0 then self.x = value
      end
    end

    def property_get(key)
      send key
    end

    def property_set(key, value)
      send "#{key}=", value
    end
  end
end