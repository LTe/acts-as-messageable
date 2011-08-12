require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class User < ActiveRecord::Base
  acts_as_messageable
end

def send_message(from=@bob, to=@alice, topic="Topic", body="Body")
  from.send_message(to, topic, body)
end

describe "ActsAsMessageable" do

  before(:all) do
    User.acts_as_messageable
  end

  describe "prepare for specs" do
    it "should be two users in database" do
      User.count.should == 2
    end
  end

  describe "send messages" do
    it "alice should have one message" do
      send_message
      @alice.messages.count.should == 1
    end

    it "alice should have one message from bob" do
      send_message
      @alice.messages.are_from(@bob).count.should == 1
    end

    it "bob should have one message" do
      send_message
      @bob.messages.count.should == 1
    end

    it "bob should have one message to alice in outbox" do
      send_message
      @bob.sent_messages.are_to(@alice).count.should == 1
    end

    it "bob should have one open message from alice" do
      send_message
      @alice.messages.are_from(@bob).process { |m| m.open }
      @alice.messages.readed.count.should == 1
    end
  end

  describe "delete messages" do
    it "bob should have one deleted message from alice" do
      send_message
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
      @message = send_message

      @bob.sent_messages.count.should == 1
      @alice.received_messages.count.should == 1

      @bob.sent_messages.process { |m| m.delete }
      @bob.sent_messages.count.should == 0
      @alice.received_messages.count.should == 1

      @alice.received_messages.process { |m| m.delete }
      @alice.received_messages.count.should == 0
    end

    it "message should permanent delete" do
      @message = send_message
      @alice.messages.process { |m| m.delete }
      @alice.messages.count.should == 0

      @alice.deleted_messages.count.should == 1
      @alice.deleted_messages.process { |m| m.delete }
      @alice.deleted_messages.count.should == 0

      @message.reload
      @message.recipient_permanent_delete.should == true

      @bob.sent_messages.count.should == 1
    end
  end

  describe "read/unread feature" do
    it "alice should have one unread message from bob" do
      send_message
      @alice.messages.are_from(@bob).unread.count.should == 1
      @alice.messages.are_from(@bob).readed.count.should == 0
    end
  end

  it "should be in database message with id ..." do
    message_id = send_message.id
    @bob.messages.with_id(message_id).count.should == 1
  end

  it "message should have proper topic" do
    send_message
    @bob.messages.count.should == 1
    @bob.messages.first.topic == "Topic"
  end

  describe "conversation" do
    it "bob send message to alice, and alice reply to bob message and show proper tree" do
      @message = send_message
      @reply_message =  @alice.reply_to(@message, "Re: Topic", "Body")

      @reply_message.conversation.size.should == 2
      @reply_message.conversation.first.topic.should == "Topic"
      @reply_message.conversation.last.topic.should == "Re: Topic"
    end

    it "bob send message to alice, alice answer, and bob answer for alice answer" do
      @message = send_message
      @reply_message = @alice.reply_to(@message, "Re: Topic", "Body")
      @reply_reply_message = @bob.reply_to(@reply_message, "Re: Re: Topic", "Body")

      [@message, @reply_message, @reply_reply_message].each do |m|
        m.conversation.size.should == 3
      end

      @message.conversation.last.should == @reply_reply_message
      @reply_reply_message.conversation.last.should == @reply_reply_message
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
    @message = send_message
    @message = send_message(@bob, @alice, "Example", "Example Body")
    @alice.messages.first.body.should == "Body"
  end

  it "received_messages should return ActiveRecord::Relation" do
    send_message
    @alice.received_messages.class.should == ActiveRecord::Relation
  end

  it "sent_messages should return ActiveRecord::Relation" do
    send_message
    @bob.sent_messages.class.should == ActiveRecord::Relation
  end
end
