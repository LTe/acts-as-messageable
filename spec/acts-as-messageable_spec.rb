require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ActsAsMessageable" do
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
    @alice.send_message(@bob, "Topic", "Message body")
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
    message_id = @bob.send_message(@alice, "Topic", "Message body").first.id
    @bob.messages.id(message_id).count.should == 1
  end
end
