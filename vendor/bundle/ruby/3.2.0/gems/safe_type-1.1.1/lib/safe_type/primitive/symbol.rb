module SafeType
  class Symbol < Rule
    def initialize(type: ::Symbol, min_length: nil, max_length: nil, **args)
      @min_length = min_length
      @max_length = max_length
      super
    end

    def is_valid?(input)
      return false unless @min_length.nil? || input.length >= @min_length
      return false unless @max_length.nil? || input.length <= @max_length
      super
    end

    def after(input)
      return nil if input.length == 0
      super
    end

    def self.default(value=nil, min_length: nil, max_length: nil)
      new(
        default: value,
        min_length: min_length,
        max_length: max_length
      )
    end

    def self.strict(min_length: nil, max_length: nil)
      new(
        required: true,
        min_length: min_length,
        max_length: max_length
      )
    end
  end
end
