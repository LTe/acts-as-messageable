# frozen_string_literal: true

class User < ActiveRecord::Base
  acts_as_messageable
end
