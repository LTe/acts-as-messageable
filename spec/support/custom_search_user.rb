# typed: strict
# frozen_string_literal: true

class CustomSearchUser < ActiveRecord::Base
  extend ActsAsMessageable::Model::ClassMethods

  acts_as_messageable search_scope: :custom_search, class_name: 'CustomMessage'
end
