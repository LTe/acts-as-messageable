# typed: strict
# frozen_string_literal: true

class CustomMessage < ActsAsMessageable::Message
  extend T::Sig

  sig { void }
  def custom_method; end
end
