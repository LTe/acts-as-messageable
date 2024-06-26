# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `bigdecimal` gem.
# Please instead update this file by running `bin/tapioca gem bigdecimal`.

class BigDecimal < ::Numeric
  def to_d; end
  def to_digits; end
end

BigDecimal::VERSION = T.let(T.unsafe(nil), String)

class Complex < ::Numeric
  def to_d(*args); end
end

class NilClass
  def to_d; end
end
