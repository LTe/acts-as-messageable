# typed: true
# frozen_string_literal: true

extend T::Sig

sig do
  params(from: ActiveRecord::Base, to: ActiveRecord::Base, topic: String,
         body: String).returns(ActsAsMessageable::Message)
end
def send_message(from = T.unsafe(@bob), to = T.unsafe(@alice), topic = 'Topic', body = 'Body')
  from.send_message(to, topic, body)
end
