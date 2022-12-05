# typed: ignore
# frozen_string_literal: true

class CustomSearchUser < ActiveRecord::Base
  acts_as_messageable search_scope: :custom_search, class_name: 'CustomMessage'
end
