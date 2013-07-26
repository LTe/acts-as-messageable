require "spec_helper"

describe "custom class" do
  let(:alice) { User.find_by_email("alice@example.com") }
  let(:bob)   { User.find_by_email("bob@example.com") }
  let(:pat)   { User.find_by_email("pat@example.com") }

  before do
    User.acts_as_messageable :class_name => "ActsAsMessageable::Message",
                             :group_messages => true
    @message = alice.send_message(bob, :topic => "Helou bob!", :body => "What's up?")
  end

  it "joins to conversation" do
    @reply_message = pat.reply_to(@message, "Hi there!", "I would like to join to this conversation!")
    @sec_reply_message = bob.reply_to(@message, "Hi!", "Fine!")
    @third_reply_message = alice.reply_to(@reply_message, "hi!", "no problem")
    @message.conversation.should == [@reply_message, @message]
  end

  it "alice,bob and pat should be involve into conversation" do
    @reply_message = pat.reply_to(@message, "Hi there!", "I would like to join to this conversation!")
    @sec_reply_message = bob.reply_to(@message, "Hi!", "Fine!")
    @third_reply_message = alice.reply_to(@reply_message, "hi!", "no problem")
    @message.people.should == [alice,bob,pat]
  end

end

