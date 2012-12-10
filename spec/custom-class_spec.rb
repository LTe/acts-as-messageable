require "spec_helper"

class CustomMessage < ActsAsMessageable::Message
  def custom_method;end
end

describe "custom class" do
  before(:all) do
    User.acts_as_messageable :class_name => "CustomMessage"
  end

  it "message should have CustomMessage class" do
    message = @alice.send_message(@bob, :topic => "Helou bob!", :body => "What's up?")
    message.class.should == CustomMessage
  end

  it "responds to custom_method" do
    message = @alice.send_message(@bob, :topic => "Helou bob!", :body => "What's up?")
    message.should respond_to(:custom_method)
  end
end

