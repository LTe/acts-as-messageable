# typed: strong
# frozen_string_literal: true

require 'sorbet-runtime'
require 'sorbet-rails'
require 'ancestry'

module ActsAsMessageable
  autoload :Model, 'acts_as_messageable/model'
  autoload :Scopes, 'acts_as_messageable/scopes'
  autoload :Message, 'acts_as_messageable/message'
  autoload :Relation, 'acts_as_messageable/relation'
  autoload :Rails3, 'acts_as_messageable/rails3'
  autoload :Rails4, 'acts_as_messageable/rails4'
  autoload :Rails6, 'acts_as_messageable/rails6'

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
