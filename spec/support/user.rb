# frozen_string_literal: true

class User < ActiveRecord::Base
  acts_as_messageable
end

class Men < User
end

class CustomSearchUser < ActiveRecord::Base
end
