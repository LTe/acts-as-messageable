# typed: true
require 'sorbet-runtime'

module TypeCoerce
  module Configuration
    class << self
      extend T::Sig

      sig { returns(T::Boolean) }
      attr_accessor :raise_coercion_error
    end
  end
end

TypeCoerce::Configuration.raise_coercion_error = true
