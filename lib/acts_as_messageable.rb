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

  extend T::Sig
end

require 'acts_as_messageable/railtie'
