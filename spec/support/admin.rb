class Admin < ActiveRecord::Base
  attr_accessible :email
  acts_as_messageable
end
