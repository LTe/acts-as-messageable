# typed: ignore
require 'sorbet-coerce/converter'

module TypeCoerce
  def self.[](type)
    TypeCoerce::Converter.new(type)
  end
end
