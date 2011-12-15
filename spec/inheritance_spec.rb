require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "inheritance models" do
	it "men send message to alice" do
    send_message(@men, @alice)
    @men.sent_messages.size.should be_equal(1)
    @alice.received_messages.size.should be_equal(1)
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
