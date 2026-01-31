module SafeType

  class CoercionError < StandardError 
    attr_reader :key
    attr_reader :value
    attr_reader :desired_type

    def initialize(value, desired_type, key=nil)
      super("Could not coerce " + (key.nil? ? '' : "key (#{key}) with ")  +
            "value (#{value.inspect}) of type (#{value.class}) to desired type (#{desired_type})")

      @key = key
      @value = value
      @desired_type = desired_type
    end
  end

  class ValidationError < StandardError
    attr_reader :key
    attr_reader :value
    attr_reader :desired_type

    def initialize(value, desired_type, key=nil)
      super("Validation for " + (key.nil? ? '' : "key (#{key}) with ")  +
            "value (#{value.inspect}) of " +
            "type (#{value.class}) to desired type (#{desired_type}) has failed")

      @key = key
      @value = value
      @desired_type = desired_type
    end
  end

  class EmptyValueError < StandardError
    attr_reader :key
    attr_reader :desired_type

    def initialize(desired_type, key=nil)
      super("Expected a " + (key.nil? ? '' : "key (#{key}) with ")  +
            "value of desired type (#{desired_type}), but received a nil value")

      @key = key
      @desired_type = desired_type
    end
  end

  class InvalidRuleError < ArgumentError
    def initialize()
      super("Coercion rule does not exist or is not valid")
    end
  end
end
