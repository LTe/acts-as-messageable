require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class User < ActiveRecord::Base
  acts_as_messageable
end

describe "ActsAsMessageable" do

  before(:all) do
    User.acts_as_messageable
  end

  it "should be two users in database" do
    User.count.should == 2
  end

  it "alice should have one message from bob" do
    @bob.send_message(@alice, "Topic", "Message body")
    @alice.messages.count.should == 1
    @alice.messages.are_from(@bob).count.should == 1
  end

  it "bob should have one message to alice in outbox" do
    @bob.send_message(@alice, "Topic", "Message body")
    @bob.messages.count.should == 1
    @bob.messages.are_to(@alice).count.should == 1
  end

  it "bob should have one open message from alice" do
    @message =  @alice.send_message(@bob, "Topic", "Message body")
    @bob.messages.are_from(@alice).process do |m|
      m.open
    end

    @bob.messages.readed.count.should == 1
  end

  it "bob should have one deleted message from alice" do
    @alice.send_message(@bob, "Topic", "Message body")
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

  it "alice should have one unread message from bob" do
    @bob.send_message(@alice, "Topic", "Message body")
    @alice.messages.are_from(@bob).unread.count.should == 1
    @alice.messages.are_from(@bob).readed.count.should == 0
  end

  it "should be in database message with id ..." do
    message_id = @bob.send_message(@alice, "Topic", "Message body").id
    @bob.messages.with_id(message_id).count.should == 1
  end

  it "message should have proper topic" do
    @bob.send_message(@alice, "Topic", "Message body")
    @bob.messages.count.should == 1
    @bob.messages.first.topic == "Topic"
    @bob.messages.first.body == "Message body"
  end

  it "bob send message to alice, and alice reply to bob message and show proper tree" do
    @message = @bob.send_message(@alice, "Topic", "Body")
    @reply_message =  @alice.reply_to(@message, "Re: Topic", "Body")
  
    @reply_message.conversation.size.should == 2
    @reply_message.conversation.first.topic.should == "Topic"
    @reply_message.conversation.last.topic.should == "Re: Topic"
  end

  it "bob send message to alice, alice answer, and bob answer for alice answer" do
    @message = @bob.send_message(@alice, "Topic", "Body")
    @reply_message =  @alice.reply_to(@message, "Re: Topic", "Body")
    @reply_reply_message = @bob.reply_to(@reply_message, "Re: Re: Topic", "Body")

    [@message, @reply_message, @reply_reply_message].each do |m|
      m.conversation.size.should == 3
    end

    @message.conversation.last.should == @reply_reply_message
    @reply_reply_message.conversation.last.should == @reply_reply_message
  end

  it "send message with hash" do
    @message = @bob.send_message(@alice, {:body => "Body", :topic => "Topic"})
    @message.topic.should == "Topic"
    @message.body.should == "Body"
  end
end
