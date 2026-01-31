require 'date'
require 'time'

module SafeType
  class Converter
    @@TRUE_VALUES = %w[on On ON t true True TRUE T y yes Yes YES Y].freeze
    @@FALSE_VALUES = %w[off Off OFF f false False FALSE F n no No NO N].freeze

    def self.to_true(input)
      true if @@TRUE_VALUES.include?(input.to_s)
    end

    def self.to_false(input)
      false if @@FALSE_VALUES.include?(input.to_s)
    end

    def self.to_bool(input)
      return true unless self.to_true(input).nil?
      return false unless self.to_false(input).nil?
      raise TypeError
    end

    def self.to_int(input)
      Integer(Float(input))
    end

    def self.to_float(input)
      Float(input)
    end

    def self.to_date(input)
      ::Date.parse(input)
    end

    def self.to_date_time(input)
      ::DateTime.parse(input)
    end

    def self.to_time(input)
      ::Time.parse(input)
    end

    def self.to_type(input, type)
      return input if input.is_a?(type)
      return input.safe_type if input.respond_to?(:safe_type)
      return input.to_s if type == ::String
      return input.to_sym if type == ::Symbol
      return self.to_true(input) if type == ::TrueClass
      return self.to_false(input) if type == ::FalseClass
      return self.to_bool(input) if type == SafeType::BooleanMixin
      return self.to_int(input) if type == ::Integer
      return self.to_float(input) if type == ::Float
      return self.to_date(input) if type == ::Date
      return self.to_date_time(input) if type == ::DateTime
      return self.to_time(input) if type == ::Time
      return type.try_convert(input) if type.respond_to?(:try_convert)
      return type.new(input) if type.respond_to?(:new)
    end
  end
end
