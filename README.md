
ActsAsMessageable
=================

The Acts As Messageable allows communication between the models.

[![Build Status](http://travis-ci.org/LTe/acts-as-messageable.png)](http://github.com/LTe/acts-as-messageable)

Usage
=====

To use it, add it to your Gemfile:

```ruby
gem 'acts-as-messageable'
```

Post instalation
================

```
rails g acts-as-messageable:migration table_name # default 'messages'
rake db:migrate
```

Usage
=====

```ruby
class User < ActiveRecord::Base
  acts_as_messageable :table_name => "table_with_messages", # default 'messages'
                      :required   => :body                  # default [:topic, :body]
                      :class_name => "CustomMessages"       # default "ActsAsMessageable::Message"
  end
```

Upgrade
=======

Just type once again

```
rails g acts-as-messageable:migration
```

And new migrations should be created.

```
~$ rails g acts-as-messageable:migration
    create  db/migrate/20110811223435_add_recipient_permanent_delete_and_sender_permanent_delete_to_messages.rb
    Another migration is already named create_messages_table: /home/lite/work/acts_test/db/migrate/20110811184810_create_messages_table.rb
```

Send message
============

```ruby
@alice = User.first
@bob   = User.last

@alice.send_message(@bob, "Message topic", "Hi bob!")
@bob.send_message(@alice, "Re: Message topic", "Hi alice!")
```

With hash
=========

```ruby
@alice.send_message(@bob, { :body => "Hash body", :topic => "Hash topic" })
```

Custom required
===============

In User model

```ruby
class User < ActiveRecord::Base
  acts_as_messageable :required => :body
end

@alice.send_message(@bob, { :body => "Hash body" })
```

or

```ruby
@alice.send_message(@bob, "body")
```

Required sequence
=================

```ruby
class User < ActiveRecord::Base
  acts_as_messageable :required => [:body, :topic]
end

@alice.send_message(@bob, "body", "topic")
```

Conversation
============

```ruby
@message = @alice.send_message(@bob, "Hello bob!", "How are you?")
@reply_message = @bob.reply_to(@message, "Re: Hello bob!", "I'm fine!")
# or @bob.reply_to(@message, :topic => "Re: Hello bob!", :body => "I'm fine!")

@message.conversation #=> [@message, @reply_message]
@reply_message.conversation #=> [@message, @reply_message]
```

API
===

```ruby
@alice.messages # all messages connected with @alice (inbox/outbox)
@alice.received_messages # @alice inbox
@alice.sent_messages # @alice outbox

@alice.deleted_messages # all messages connected with @alice (trash)

@alice.messages.are_from(@bob) # all message form @bob
@alice.messages.are_to(@bob) # all message to @bob
@alice.messages.with_id(@id_of_message) # message with id id_of_message
@alice.messages.readed # all readed @alice  messages
@alice.messages.unread # all unreaded @alice messages

@alice.received_messages.are_from(@bob) # all messages from bob (inbox)
@alice.sent_messages.are_to(@bob) # all messages do bob (outbox)
```

You can use multiple filters at the same time

```ruby
@alice.messages.are_from(@bob).are_to(@alice).readed # all message from @bob to @alice and readed
@alice.deleted_messages.are_from(@bob) # all deleted messages from @bob
```

Delete message
==============

```ruby
@message = @alice.send_message(@bob, "Topic", "Body")

@alice.messages.process do |message|
    message.delete
end
```

Now we can find message in trash

```ruby
@alice.deleted_messages #=> [@message]

@alice.deleted_messages.process do |message|
  message.delete
end

@alice.delete_message #=> []
```

Message was permanent delete

Copyright © 2011 Piotr Niełacny (http://ruby-blog.pl), released under the MIT license
