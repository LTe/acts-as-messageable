ActsAsMessageable
=================

The Acts As Messageable allows communication between the models.

[![Build Status](https://secure.travis-ci.org/LTe/acts-as-messageable.png)](http://travis-ci.org/LTe/acts-as-messageable) [![Dependency Status](https://gemnasium.com/LTe/acts-as-messageable.png)](https://gemnasium.com/LTe/acts-as-messageable)

Usage
=====

To use it, add it to your Gemfile:

### Rails 3

```ruby
gem 'acts-as-messageable'
```

### Rails 2

Use this [fork](http://github.com/openfirmware/acts-as-messageable)
Thanks for [@openfirmware](http://github.com/openfirmware)

```ruby
gem 'acts-as-messageable', :git => 'git://github.com/openfirmware/acts-as-messageable.git', 
                           :branch => 'rails2.3.11_compatible'
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
                      :class_name => "CustomMessages"       # default "ActsAsMessageable::Message",
                      :dependent  => :destroy               # default :nullify
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
```

Send message
============

```ruby
@alice = User.first
@bob   = User.last

@alice.send_message(@bob, "Message topic", "Hi bob!")
@bob.send_message(@alice, "Re: Message topic", "Hi alice!")
```

## With hash

```ruby
@alice.send_message(@bob, { :body => "Hash body", :topic => "Hash topic" })
```

Custom required (validation)
============================

In User model

```ruby
class User < ActiveRecord::Base
  acts_as_messageable :required => :body
end
```

## With hash

```ruby
@alice.send_message(@bob, { :body => "Hash body" })
```

## Normal

```ruby
@alice.send_message(@bob, "body")
```

## Required sequence

```ruby
class User < ActiveRecord::Base
  acts_as_messageable :required => [:body, :topic]
end

@alice.send_message(@bob, "body", "topic")
```

## First topic

```ruby
class User < ActiveRecord::Base
  acts_as_messageable :required => [:topic, :body]
end

@alice.send_message(@bob, "topic", "body")
```

Conversation
============

You can get conversation list from messages scope. For example:

```ruby
@message = @alice.send_message(@bob, "Hello bob!", "How are you?")
@reply_message = @bob.reply_to(@message, "Re: Hello bob!", "I'm fine!")

@alice.received_messages.conversations # => [@reply_message]
```

should receive list of latest messages in conversations (like in facebook).

To create conversation just reply to a message.

```ruby
@message = @alice.send_message(@bob, "Hello bob!", "How are you?")
@message.reply("Re: Hello bob!", "I'm fine")
```

**Or with hash**

```ruby
@message.reply(:topic => "Re: Hello bob!", :body => "I'm fine")
```

**Or in old style**

```ruby
@message = @alice.send_message(@bob, "Hello bob!", "How are you?")
@reply_message = @bob.reply_to(@message, "Re: Hello bob!", "I'm fine!")
```

## Get conversation for a specific message

```ruby
@message.conversation       #=> [@message, @reply_message]
@reply_message.conversation #=> [@message, @reply_message]
```

Search
======

### Inbox
```ruby
@alice.received_messages
```

### Outbox
```ruby
@alice.sent_messages
```
### Inbox + Outbox. All messages connected with __@alice__
```ruby
@alice.messages
```

### Trash
```ruby
@alice.deleted_messages
```

## Filters
==========

```ruby
@alice.messages.are_from(@bob) # all message form @bob
@alice.messages.are_to(@bob) # all message to @bob
@alice.messages.with_id(@id_of_message) # message with id id_of_message
@alice.messages.readed # all readed @alice  messages
@alice.messages.unreaded # all unreaded @alice messages
```


**You can use multiple filters at the same time**

```ruby
@alice.messages.are_from(@bob).are_to(@alice).readed # all message from @bob to @alice and readed
@alice.deleted_messages.are_from(@bob) # all deleted messages from @bob
```

Read messages
=============

### Read message

```ruby
@message.open # open message
@message.read
@message.mark_as_read
```

### Unread message

```ruby
@message.close # unread message
@message.mark_as_unread
```


Delete message
==============

**__We must know who delete message. That why we use *.process* method to save context__**

```ruby
@message = @alice.send_message(@bob, "Topic", "Body")

@alice.messages.process do |message|
  message.delete # @alice delete message
end
```

Now we can find message in **trash**

```ruby
@alice.deleted_messages #=> [@message]
```

We can delete the message **permanently**

```ruby
@alice.deleted_messages.process do |message|
  message.delete
end

@alice.delete_message #=> []
```

Message has been deleted **permanently**

## Delete message without context

```ruby
@alice.delete_message(@message) # @alice delete @message
```

Restore message
===============

```ruby
@alice.deleted_messages.process do |m|
  m.restore # @alice restore 'm' message from trash
end
```

## Restore message without context

```ruby
@alice.restore_message(@message) # @alice restore message from trash
```

Copyright © 2011 Piotr Niełacny (http://ruby-blog.pl), released under the MIT license
