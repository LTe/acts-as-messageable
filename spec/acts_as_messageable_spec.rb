# typed: false
# frozen_string_literal: true

require 'spec_helper'

describe 'ActsAsMessageable' do
  # Helper method for shared examples
  def send_test_message(from = @bob, to = @alice, topic = 'Topic', body = 'Body')
    send_message(from, to, topic, body)
  end

  before do
    User.acts_as_messageable
    @message = send_message
  end

  include_examples 'acts_as_messageable', adapter: :active_record

  # ActiveRecord-specific tests

  describe 'read/unread feature' do
    it 'alice should able to get datetime when he read bob message' do
      @alice.messages.are_from(@bob).first.read
      read_datetime = @alice.messages.are_from(@bob).first.updated_at
      expect(@alice.messages.are_from(@bob).reorder('updated_at asc').first.updated_at).to eq(read_datetime)
    end
  end

  it 'received_messages should return unloaded messages' do
    expect(@alice.received_messages.loaded?).to be_falsey
  end

  it 'sent_messages should return unloaded messages' do
    expect(@bob.sent_messages.loaded?).to be_falsey
  end

  describe 'send messages between two different models (the same id)' do
    it 'should have the same id' do
      expect(@alice.id).to be_equal(@admin.id)
    end
  end

  describe 'user primary key is uuid type' do # GH#107
    let(:bob) { UuidUser.create(id: SecureRandom.uuid, email: 'bob@example.com') }
    let(:alice) { UuidUser.create(id: SecureRandom.uuid, email: 'alice@example.com') }

    before do
      bob.send_message(alice, 'Subject', 'Body')
    end

    it 'returns messages for alice' do
      expect(alice.messages).not_to be_empty
    end
  end
end
