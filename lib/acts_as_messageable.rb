# typed: strong
# frozen_string_literal: true

require 'zeitwerk'
require 'sorbet-runtime'
require 'sorbet-rails'

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: true)
loader.ignore("#{__dir__}/generators")
loader.setup

module ActsAsMessageable
  extend T::Sig

  # @return [Class<ActsAsMessageable::Rails4>, Class<ActsAsMessageable::Rails6>, Class<ActsAsMessageable::Rails3>]
  #  API wrapper
  sig do
    returns(
      T.any(
        T.class_of(ActsAsMessageable::Rails4),
        T.class_of(ActsAsMessageable::Rails6),
        T.class_of(ActsAsMessageable::Rails3)
      )
    )
  end
  def self.rails_api
    if Rails::VERSION::MAJOR >= 6
      Rails6
    elsif Rails::VERSION::MAJOR >= 4
      Rails4
    else
      Rails3
    end
  end
end

require 'acts_as_messageable/railtie'
