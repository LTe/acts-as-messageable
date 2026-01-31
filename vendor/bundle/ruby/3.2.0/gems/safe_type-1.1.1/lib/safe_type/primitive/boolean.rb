require 'safe_type/mixin/boolean'

module SafeType
  class Boolean < Rule
    def initialize(type: ::SafeType::BooleanMixin, **args)
      super
    end

    def self.default(value=false)
      new(default: value)
    end
  end
end
