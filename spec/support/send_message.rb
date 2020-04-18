# frozen_string_literal: true

def send_message(from = @bob, to = @alice, topic = 'Topic', body = 'Body')
  from.send_message(to, topic, body)
end
