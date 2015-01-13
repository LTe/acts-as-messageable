require 'spec_helper'

describe 'configuration' do
  before do
    ActsAsMessageable.search_scope_name = :text_search
    User.acts_as_messageable
    @message = send_message
  end

  describe "search text from messages using custom scope name" do
    before do
      @reply_message = @message.reply("Re: Topic", "Body : I am fine")
      @reply_reply_message = @reply_message.reply("Re: Re: Topic", "Fine too")
    end

    it "bob should be able to search text from messages" do
      recordset = @bob.messages.text_search("I am fine")
      recordset.count.should == 1
      recordset.should_not be_nil
    end
  end
end
