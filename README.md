# ActsAsMessageable

ActsAsMessageable is a Ruby gem that provides a flexible and robust messaging system between models in Rails 
applications. With this gem, you can easily implement features such as private messaging between users, 
conversations, message search, and much more. This gem is perfect for applications where communication between 
users or other models is required.

[![Build Status](https://github.com/LTe/acts-as-messageable/actions/workflows/test.yml/badge.svg)](https://github.com/LTe/acts-as-messageable/actions/workflows/test.yml)
[![Code Climate](https://codeclimate.com/github/LTe/acts-as-messageable.png)](https://codeclimate.com/github/LTe/acts-as-messageable)
[![Coverage Status](https://coveralls.io/repos/LTe/acts-as-messageable/badge.png?branch=master)](https://coveralls.io/r/LTe/acts-as-messageable?branch=master)
[![Gem Version](https://badge.fury.io/rb/acts-as-messageable.png)](http://badge.fury.io/rb/acts-as-messageable)

<!-- START_TOC -->
* [ActsAsMessageable](#actsasmessageable)
* [Usage](#usage)
    * [Rails >= 3](#rails--3)
    * [Rails 2](#rails-2)
* [Post installation](#post-installation)
* [Usage](#usage-1)
* [Upgrade](#upgrade)
* [Send message](#send-message)
  * [With hash](#with-hash)
* [Custom required (validation)](#custom-required-validation)
  * [With hash](#with-hash-1)
  * [Normal](#normal)
  * [Required sequence](#required-sequence)
  * [First topic](#first-topic)
* [Custom class](#custom-class)
* [Conversation](#conversation)
  * [Get conversation for a specific message](#get-conversation-for-a-specific-message)
* [Search](#search)
    * [Search text from messages](#search-text-from-messages)
    * [Inbox](#inbox)
    * [Outbox](#outbox)
    * [Trash](#trash)
  * [Filters](#filters)
* [Read messages](#read-messages)
    * [Read message](#read-message)
    * [Unread message](#unread-message)
* [Delete message](#delete-message)
  * [Delete message without context](#delete-message-without-context)
* [Restore message](#restore-message)
  * [Restore message without context](#restore-message-without-context)
* [Group message](#group-message)
  * [Enable group messages](#enable-group-messages)
  * [How to join other users's conversation](#how-to-join-other-userss-conversation)
  * [Know the people involved in conversation](#know-the-people-involved-in-conversation)
* [Search](#search-1)
  * [Search text from messages](#search-text-from-messages-1)
* [License](#license)
* [Contributing](#contributing)
<!-- END_TOC -->

# Usage

To use it, add it to your Gemfile:

### Rails >= 3

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

# Post installation

```
rails g acts_as_messageable:migration [messages] [--uuid]
rake db:migrate
```

You need to run migration generator to create tables in database. You can do this with the `acts_as_messageable:migration`
generator. Default table name is `messages`, you can pass table name and uuid option to enable `uuid` support (by 
default disabled). UUID support is required in case when your user primary key is `uuid` type.

**Create `messages` table without `uuid` support**
```
rails g acts_as_messageable:migration 
```

**Create `messages` table with `uuid` support**
```
rails g acts_as_messageable:migration --uuid
```

**Create `my_messages` table without `uuid` support**
```
rails g acts_as_messageable:migration my_messages
```

**Create `my_messages` table with `uuid` support**
```
rails g acts_as_messageable:migration my_messages --uuid
```

# Usage

```ruby
class User < ActiveRecord::Base
  acts_as_messageable :table_name => "table_with_messages", # default 'messages'
                      :required   => :body,                 # default [:topic, :body]
                      :class_name => "CustomMessages",      # default "ActsAsMessageable::Message",
                      :dependent  => :destroy,              # default :nullify
                      :group_messages => true,              # default false
                      :search_scope => :custom_search       # default :search
end
```

# Upgrade

Just type once again

```
rails g acts-as-messageable:migration
```

And new migrations should be created.

```
~$ rails g acts-as-messageable:migration
    create  db/migrate/20110811223435_add_recipient_permanent_delete_and_sender_permanent_delete_to_messages.rb
```

# Send message

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

# Custom required (validation)

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

# Custom class

You can use your own class that will represent the message object. First of all create custom class

```ruby
class CustomMessage < ActsAsMessageable::Message
  def capitalize_title
    title.capitalize
  end
end
```

After that you can sepcify custom class in options.

```ruby
class User
  acts_as_messageable :class_name => "CustomMessage"
end
```

From now on, your message has custom class.

```ruby
@message = @alice.send_message(@bob, "hi!")
@message # => #<CustomMessage:0x000000024b6278>
@message.capitalize_title # => "Hi!"
```

# Conversation

You can get a conversation list from messages scope. For example:

```ruby
@message = @alice.send_message(@bob, "Hello bob!", "How are you?")
@reply_message = @bob.reply_to(@message, "Re: Hello bob!", "I'm fine!")

@alice.received_messages.conversations # => [@reply_message]
```

This should receive list of latest messages in conversations.

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

# Search

You can search for text within messages and get the records where a match exists.

### Search text from messages

```ruby
records = @alice.messages.search("Search me") # @alice searches for the text "Search me" in all messages"
```

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

```ruby
@alice.messages.are_from(@bob) # all message from @bob
@alice.messages.are_to(@bob) # all message to @bob
@alice.messages.with_id(@id_of_message) # message with id id_of_message
@alice.messages.readed # all read @alice messages
@alice.messages.unreaded # all unreaded @alice messages
```

**You can use multiple filters at the same time**

```ruby
@alice.messages.are_from(@bob).are_to(@alice).readed # all message from @bob to @alice and readed
@alice.deleted_messages.are_from(@bob) # all deleted messages from @bob
```

# Read messages

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


# Delete message

**__We must know who deleted the message. That's why we use the *.process* method to save context__**

```ruby
@message = @alice.send_message(@bob, "Topic", "Body")

@alice.messages.process do |message|
  message.delete # @alice delete message
end
```

Now we can find the message in the **trash**

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

The message has been deleted **permanently**

## Delete message without context

```ruby
@alice.delete_message(@message) # @alice delete @message
```

# Restore message

```ruby
@alice.deleted_messages.process do |m|
  m.restore # @alice restore 'm' message from trash
end
```

## Restore message without context

```ruby
@alice.restore_message(@message) # @alice restore message from the trash
```

# Group message

## Enable group messages

```ruby
class User
  acts_as_messageable :group_messages => true
end
```

## How to join other users's conversation

```ruby
@message =  @alice.send_message(@bob, :topic => "Helou bob!", :body => "What's up?")
@reply_message = @sukhi.reply_to(@message, "Hi there!", "I would like to join to this conversation!")
@sec_reply_message = @bob.reply_to(@message, "Hi!", "Fine!")
@third_reply_message = @alice.reply_to(@reply_message, "hi!", "no problem")
```

## Know the people involved in conversation

```ruby
@message.people # will give you participants users object
@message.people # => [@alice, @bob, @sukhi]
```

# Search

## Search text from messages

```ruby
@alice.messages.search("Search me") # @alice searches for the text "Search me" in all messages"
```

# License

ActsAsMessageable is released under the MIT License. See the bundled LICENSE file for details.

# Contributing

Contributions are welcome! To contribute:

1. Fork the project.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new Pull Request.
