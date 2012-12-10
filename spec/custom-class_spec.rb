require "spec_helper"

class CustomMessage < ActsAsMessageable::Message
  def custom_method;end
end

describe "custom class" do
  let(:alice) { User.find_by_email("alice@example.com") }
  let(:bob)   { User.find_by_email("bob@example.com") }

  before do
    User.acts_as_messageable :class_name => "CustomMessage"
    @message = alice.send_message(bob, :topic => "Helou bob!", :body => "What's up?")
  end

  it "message should have CustomMessage class" do
    @message.class.should == CustomMessage
  end

  it "responds to custom_method" do
    @message.should respond_to(:custom_method)
  end

  it "return proper class with ancestry methods" do
    @reply_message = @message.reply(:topic => "Re: Helou bob!", :body => "Fine!")
    @reply_message.root.should == @message
    @reply_message.root.class.should == CustomMessage
  end
end

