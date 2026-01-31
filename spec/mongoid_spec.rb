# typed: false
# frozen_string_literal: true

require 'spec_helper'

describe 'ActsAsMessageable with Mongoid', skip: !MONGOID_SPECS_ENABLED do
  # Helper method for shared examples
  def send_test_message(from = @bob, to = @alice, topic = 'Topic', body = 'Body')
    send_mongoid_message(from, to, topic, body)
  end

  before(:all) do
    next unless MONGOID_SPECS_ENABLED

    # Clean and set up Mongoid database
    Mongoid.purge!

    @alice = MongoidUser.create!(email: 'alice@example.com')
    @bob = MongoidUser.create!(email: 'bob@example.com')
    @pat = MongoidUser.create!(email: 'pat@example.com')
    @admin = MongoidAdmin.create!(email: 'admin@example.com')
    @men = MongoidMen.create!(email: 'men@example.com')
    @custom_search_user = MongoidCustomSearchUser.create!(email: 'custom@example.com')
  end

  after(:all) do
    Mongoid.purge! if MONGOID_SPECS_ENABLED
  end

  after(:each) do
    ActsAsMessageable::Mongoid::Message.destroy_all if MONGOID_SPECS_ENABLED
  end

  before do
    next unless MONGOID_SPECS_ENABLED

    MongoidUser.acts_as_messageable
    @message = send_mongoid_message
  end

  include_examples 'acts_as_messageable', adapter: :mongoid

  # Mongoid-specific tests

  describe 'read/unread feature' do
    it 'alice should able to get datetime when he read bob message' do
      @alice.messages.are_from(@bob).first.read
      read_datetime = @alice.messages.are_from(@bob).first.updated_at
      expect(@alice.messages.are_from(@bob).order(updated_at: :asc).first.updated_at.to_i).to eq(read_datetime.to_i)
    end
  end
end
