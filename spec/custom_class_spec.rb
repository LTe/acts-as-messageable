# frozen_string_literal: true

require 'spec_helper'

class CustomMessage < ActsAsMessageable::Message
  def custom_method; end
end

describe 'custom class' do
  let(:alice) { User.find_by_email('alice@example.com') }
  let(:bob) { User.find_by_email('bob@example.com') }

  before do
    User.acts_as_messageable class_name: 'CustomMessage', table_name: 'custom_messages'
    @message = alice.send_message(bob, topic: 'Helou bob!', body: "What's up?")
  end

  after { User.acts_as_messageable }

  it 'returns messages from alice with filter' do
    expect(bob.messages.are_from(alice)).to include(@message)
  end

  it 'uses new table name' do
    expect(CustomMessage.are_from(alice)).to include(@message)
  end

  it 'message should have CustomMessage class' do
    expect(@message.class).to eq(CustomMessage)
  end

  it 'responds to custom_method' do
    expect(@message).to respond_to(:custom_method)
  end

  it 'return proper class with ancestry methods' do
    @reply_message = @message.reply(topic: 'Re: Helou bob!', body: 'Fine!')
    expect(@reply_message.root).to eq(@message)
    expect(@reply_message.root.class).to eq(CustomMessage)
  end
end
