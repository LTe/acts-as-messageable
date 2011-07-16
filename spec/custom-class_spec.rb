require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class CustomMessage < ActsAsMessageable::Message; end

describe "custom class" do
  before(:all) do
    User.acts_as_messageable :class_name => "CustomMessage"
  end

  it "message should have CustomMessage class" do
    message = @alice.send_message(@bob, :topic => "Helou bob!", :body => "What's up?")
    message.class.should == CustomMessage
  end
end

