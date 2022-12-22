# typed: strict
# frozen_string_literal: true

class Admin < ActiveRecord::Base
  extend ActsAsMessageable::Model::ClassMethods

  acts_as_messageable
end
