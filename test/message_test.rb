require 'test/unit'
require "rubygems"

require File.expand_path('../../lib/acts-as-messageable.rb', __FILE__)

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def create_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :messages do |t|
      t.string :topic
      t.text :body
      t.references :received_messageable, :polymorphic => true
      t.references :sent_messageable, :polymorphic => true
      t.boolean :opened, :default => false
      t.boolean :opened, :default => false
      t.boolean :recipient_delete, :default => false
      t.boolean :sender_delete, :default => false
    end

    create_table :users do |t|
      t.string   :email
    end
  end


end

def drop_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class User < ActiveRecord::Base
  acts_as_messageable
end

class MessageTest < Test::Unit::TestCase
  def setup
    create_db
    User.create!(:email => "user1@users.com")
    User.create!(:email => "user2@users.com")
  end

  def teardown
    drop_db
  end

  def test_send_message
    u1 = User.first
    u2 = User.last

    u1.send_message(u2, "Topic", "Body")
    u2.send_message(u1, "Topic2", "Body2")

    assert_equal ["Topic", "Topic2"], ActsAsMessageable::Message.find(:all).map(&:topic)
    assert_equal ["Body", "Body2"], ActsAsMessageable::Message.find(:all).map(&:body)
    assert_equal u1.id, ActsAsMessageable::Message.find(:first, :conditions => { :topic => "Topic" }).sent_messageable_id
    assert_equal u2.id, ActsAsMessageable::Message.find(:first, :conditions => { :topic => "Topic" }).received_messageable_id

    assert_equal u2.id, ActsAsMessageable::Message.find(:first, :conditions => { :topic => "Topic2" }).sent_messageable_id
    assert_equal u1.id, ActsAsMessageable::Message.find(:first, :conditions => { :topic => "Topic2" }).received_messageable_id
  end

  def test_received
    u1 = User.first
    u2 = User.last

    u1.send_message(u2, "Topic", "Body")
    u1.send_message(u2, "Topic2", "Body2")

    assert_equal ["Topic", "Topic2"], u2.received.map(&:topic)
  end

  def test_sent
    u1 = User.first
    u2 = User.last

    u1.send_message(u2, "Topic", "Body")
    u1.send_message(u2, "Topic2", "Body2")

    assert_equal ["Topic", "Topic2"], u1.sent.map(&:topic)
  end

  def test_messages
    u1 = User.first
    u2 = User.last

    u1.send_message(u2, "Topic", "Body")
    u1.send_message(u2, "Topic2", "Body2")

    assert_equal ["Topic", "Topic2"], u2.messages(:from => u1).map(&:topic)
    assert_equal ["Topic", "Topic2"], u1.messages(:to => u2).map(&:topic)
    assert_equal ["Topic"], u1.messages(:to => u2, :id => 1).map(&:topic)
    assert_equal ["Topic2"], u1.messages(:id => 2).map(&:topic)
  end

  def test_delete_message
    u1 = User.first
    u2 = User.last

    u1.send_message(u2, "Topic", "Body")
    u1.send_message(u2, "Topic2", "Body2")

    u1.messages do |m|
      m.delete
    end

    assert_equal [], u1.messages
    assert_equal ["Topic", "Topic2"], u2.messages.map(&:topic)
  end

end
