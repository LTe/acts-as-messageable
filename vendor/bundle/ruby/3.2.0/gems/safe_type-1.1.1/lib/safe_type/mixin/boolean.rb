module SafeType
  module BooleanMixin
  end
end

class TrueClass
  include SafeType::BooleanMixin
end

class FalseClass
  include SafeType::BooleanMixin
end
