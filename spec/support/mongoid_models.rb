# typed: false
# frozen_string_literal: true

# Define test models for Mongoid
class MongoidUser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String

  acts_as_messageable
end

class MongoidAdmin
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String

  acts_as_messageable
end

class MongoidMen < MongoidUser
end

class MongoidCustomSearchUser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String

  acts_as_messageable search_scope: :custom_search
end

def send_mongoid_message(from = @bob, to = @alice, topic = 'Topic', body = 'Body')
  from.send_message(to, topic, body)
end
