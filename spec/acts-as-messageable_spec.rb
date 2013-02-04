require 'spec_helper'

describe "ActsAsMessageable" do
  before do
    User.acts_as_messageable
    @message = send_message
  end

  describe "send messages" do
    it "alice should have one message" do
      @alice.messages.count.should == 1
    end

    it "alice should have one message from bob" do
      @alice.messages.are_from(@bob).count.should == 1
    end

    it "bob should have one message" do
      @bob.messages.count.should == 1
    end

    it "bob should have one message to alice in outbox" do
      @bob.sent_messages.are_to(@alice).count.should == 1
    end

    it "bob should have one open message from alice" do
      @alice.messages.are_from(@bob).process { |m| m.open }
      @alice.messages.readed.count.should == 1
    end
  end

  describe "inheritance models" do
    it "men send message to alice" do
      send_message(@men, @alice)
      @men.sent_messages.size.should be_equal(1)
      @alice.received_messages.size.should be_equal(2)
    end

    it "messages method should receive all messages connected with user" do
      send_message(@men, @alice)
      @men.messages.size.should be_equal(1)
    end

    it "men send message and receive from alice" do
      send_message(@men, @alice)
      send_message(@alice, @men)

      @men.messages.size.should be_equal(2)
      @men.sent_messages.size.should be_equal(1)
      @men.received_messages.size.should be_equal(1)
    end
  end

  describe "reply to messages" do
    it "pat should not be able to reply to a message from bob to alice" do
      @reply_message =  @pat.reply_to(@message, "Re: Topic", "Body")
      @reply_message.should be_nil
    end

    it "alice should be able to reply to a message from bob to alice" do
      @reply_message =  @alice.reply_to(@message, "Re: Topic", "Body")
      @reply_message.should_not be_nil
      @bob.messages.are_from(@alice).count.should == 1
      @alice.sent_messages.are_to(@bob).count.should == 1
    end

    it "alice should be able to reply to a message using the message object" do
      @reply_message =  @message.reply("Re: Topic", "Body")
      @reply_message.should_not be_nil
      @bob.messages.are_from(@alice).count.should == 1
      @alice.sent_messages.are_to(@bob).count.should == 1
    end

    it "alice try to add something to conversation" do
      @reply_message = @bob.reply_to(@message, "Oh, I Forget", "1+1=2")
      @reply_message.from.should  == @message.from
      @reply_message.to.should    == @message.to
    end
  end

  describe "delete messages" do

    it "bob should have one deleted message from alice" do
      @bob.messages.process do |m|
        m.delete
      end

      @bob.messages.each do |m|
        m.recipient_delete.should == true
        m.sender_delete.should == false
      end

      @bob.deleted_messages.count.should == 1
      @bob.messages.count.should == 0
    end

    it "received_messages and sent_messages should work with .process method" do
      @bob.sent_messages.count.should == 1
      @alice.received_messages.count.should == 1

      @bob.sent_messages.process { |m| m.delete }
      @bob.sent_messages.count.should == 0
      @alice.received_messages.count.should == 1

      @alice.received_messages.process { |m| m.delete }
      @alice.received_messages.count.should == 0
    end

    it "message should permanent delete" do
      @alice.messages.process { |m| m.delete }
      @alice.messages.count.should == 0

      @alice.deleted_messages.count.should == 1
      @alice.deleted_messages.process { |m| m.delete }
      @alice.deleted_messages.count.should == 0

      @message.reload
      @message.recipient_permanent_delete.should == true

      @bob.sent_messages.count.should == 1
    end

    it "pat should not able to delete message" do
      lambda { @pat.delete_message(@message) }.should raise_error
    end
  end

  describe "restore message" do
    it "alice should restore message" do
      @alice.received_messages.process { |m| m.delete }
      @alice.restore_message(@message.reload)
      @alice.received_messages.count.should == 1
    end

    it "should works with relation" do
      @alice.received_messages.process { |m| m.delete }
      @alice.received_messages.count.should == 0
      @alice.deleted_messages.process { |m| m.restore }
      @alice.received_messages.count.should == 1
    end

    it "pat should not able to restore message" do
      lambda { @pat.restore_message(@message) }.should raise_error
    end
  end

  describe "read/unread feature" do
    it "alice should have one unread message from bob" do
      @alice.messages.are_from(@bob).unreaded.count.should == 1
      @alice.messages.are_from(@bob).readed.count.should == 0
    end

    it "alice should able to read message from bob" do
      @alice.messages.are_from(@bob).first.read
      @alice.messages.are_from(@bob).unreaded.count.should == 0
    end

    it "alice should able to unread message from bob" do
      @alice.messages.are_from(@bob).first.read
      @alice.messages.are_from(@bob).first.unread
      @alice.messages.are_from(@bob).unreaded.count.should == 1
    end
  end

  it "should be in database message with id ..." do
    message_id = send_message.id
    @bob.messages.with_id(message_id).count.should == 1
  end

  it "finds proper message" do
    @bob.messages.find(@message.id) == @message
  end

  it "message should have proper topic" do
    @bob.messages.count.should == 1
    @bob.messages.first.topic == "Topic"
  end

  describe "conversation" do
    it "bob send message to alice, and alice reply to bob message and show proper tree" do
      @reply_message =  @alice.reply_to(@message, "Re: Topic", "Body")

      @reply_message.conversation.size.should == 2
      @reply_message.conversation.last.topic.should == "Topic"
      @reply_message.conversation.first.topic.should == "Re: Topic"
    end

    it "bob send message to alice, alice answer, and bob answer for alice answer" do
      @reply_message = @alice.reply_to(@message, "Re: Topic", "Body")
      @reply_reply_message = @bob.reply_to(@reply_message, "Re: Re: Topic", "Body")

      [@message, @reply_message, @reply_reply_message].each do |m|
        m.conversation.size.should == 3
      end

      @message.conversation.first.should == @reply_reply_message
      @reply_reply_message.conversation.first.should == @reply_reply_message
    end
  end

  describe "conversations" do
    before do
      @reply_message = @message.reply("Re: Topic", "Body")
      @reply_reply_message = @reply_message.reply("Re: Re: Topic", "Body")
    end

    it "bob send message to alice and alice reply" do
      @bob.messages.conversations.should == [@reply_reply_message]
      @reply_message.conversation.should == [@reply_reply_message, @reply_message, @message]
    end

    it "show conversations in proper order" do
      @sec_message = @bob.send_message(@alice, "Hi", "Alice!")
      @sec_reply = @sec_message.reply("Re: Hi", "Fine!")
      @bob.received_messages.conversations.should == [@sec_reply, @reply_reply_message]
      @sec_reply.conversation.should == [@sec_reply, @sec_message]
    end
  end

  describe "send messages with hash" do
    it "send message with hash" do
      @message = @bob.send_message(@alice, {:body => "Body", :topic => "Topic"})
      @message.topic.should == "Topic"
      @message.body.should == "Body"
    end
  end

  it "messages should return in right order :created_at" do
    @message = send_message(@bob, @alice, "Example", "Example Body")
    @alice.messages.last.body.should == "Body"
  end

  it "received_messages should return ActiveRecord::Relation" do
    @alice.received_messages.class.should == ActiveRecord::Relation
  end

  it "sent_messages should return ActiveRecord::Relation" do
    @bob.sent_messages.class.should == ActiveRecord::Relation
  end

  describe "send messages between two different models (the same id)" do
    it "should have the same id" do
      @alice.id.should be_equal(@admin.id)
    end

    it "bob send message to admin (different model) with the same id" do
      @bob.send_message(@alice, "hello", "alice")
      @alice.messages.are_to(@alice).size.should be_equal(2)
      @alice.messages.are_to(@admin).size.should be_equal(0)
    end

    it "admin send message to bob" do
      @admin.send_message(@bob, "hello", "bob")
      @bob.messages.are_from(@admin).size.should be_equal(1)
      @bob.messages.are_from(@alice).size.should be_equal(0)
    end
  end

end
