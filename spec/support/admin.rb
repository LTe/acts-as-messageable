# typed: strict
# frozen_string_literal: true

class Admin < ActiveRecord::Base
  include ActsAsMessageable::Model

  acts_as_messageable
end
