module ActsAsMessageable
  class Message < ::ActiveRecord::Base
    belongs_to :users, :class_name => "ActsAsMessageable::User"
  end
end