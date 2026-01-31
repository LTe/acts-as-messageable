module SafeType
  class Float < Rule
    def initialize(type: ::Float, min: nil, max: nil, **args)
      @min = min
      @max = max
      super
    end

    def is_valid?(input)
      return false unless @min.nil? || input >= @min
      return false unless @max.nil? || input <= @max
      super
    end

    def self.default(value=0.0, min: nil, max: nil)
      new(
        default: value,
        min: min,
        max: max
      )
    end

    def self.strict(min: nil, max: nil)
      new(
        required: true,
        min: min,
        max: max
      )
    end
  end
end
