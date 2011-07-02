require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "custom require" do
  before(:each) do
    # Use clean version of Message class
    ActsAsMessageable.instance_eval { remove_const "Message" }
    load "acts-as-messageable/message.rb"
  end

  it "should work with non-array require" do
    User.acts_as_messageable :required => :body
    ActsAsMessageable::Message.required.should == ([:body])
  end

  it "should work with array require" do
    User.acts_as_messageable :required => [:body, :topic]
    ActsAsMessageable::Message.required.should == ([:body, :topic])
  end

  context "only body" do
    before(:each) do
      User.acts_as_messageable :required => :body
    end

    it "alice should able to send message to bob only with body" do
      @alice.send_message(@bob, "Hello bob!")
      @alice.messages.first.body.should == "Hello bob!"
      @bob.received_messages.first.body.should == "Hello bob!"
    end

    it "alice should able to send message to bob with hash" do
      @alice.send_message(@bob, :body => "Hi Bob! I'm hash master")
      @alice.messages.first.body.should == "Hi Bob! I'm hash master"
    end

    it "alice send message to bob with body and bob reply to alice" do
      @alice.send_message(@bob, "Hi Bob!")
      @message_from_alice = @bob.received_messages.first
      @message_from_alice.body.should == "Hi Bob!"
      @bob.reply_to(@message_from_alice, "Hi Alice!")
      @alice.received_messages.first.body.should == "Hi Alice!"
    end

    it "alice send message to bob and bob reply with hash" do
      @message_from_alice = @alice.send_message(@bob, "Hi Bob!")
      @bob.reply_to(@message_from_alice, :body => "Hi Alice!")
      @alice.received_messages.first.body.should == "Hi Alice!"
    end
  end

end
