# typed: false
# frozen_string_literal: true

require 'sorbet-runtime'
T::Configuration.default_checked_level = :tests
T::Configuration.enable_checking_for_sigs_marked_checked_tests

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'mongoid'
require 'timecop'
require 'bundler/setup'

Bundler.require(:default)

require 'pry'
require 'acts_as_messageable'
require 'acts_as_messageable/mongoid'

# Configure Mongoid for testing
Mongoid.configure do |config|
  config.clients.default = {
    hosts: [ENV.fetch('MONGODB_HOST', 'localhost:27017')],
    database: 'acts_as_messageable_test'
  }
  config.log_level = :warn
end

# Include Mongoid model support
Mongoid::Document::ClassMethods.include ActsAsMessageable::Mongoid::Model
Mongoid::Criteria.include ActsAsMessageable::Mongoid::Relation

# Define test models
class MongoidUser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String

  acts_as_messageable
end

class MongoidAdmin
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String

  acts_as_messageable
end

class MongoidMen < MongoidUser
end

class MongoidCustomSearchUser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String

  acts_as_messageable search_scope: :custom_search
end

def send_mongoid_message(from = @bob, to = @alice, topic = 'Topic', body = 'Body')
  from.send_message(to, topic, body)
end

RSpec.configure do |config|
  config.before(:all) do
    # Clean database
    Mongoid.purge!

    @alice = MongoidUser.create!(email: 'alice@example.com')
    @bob = MongoidUser.create!(email: 'bob@example.com')
    @pat = MongoidUser.create!(email: 'pat@example.com')
    @admin = MongoidAdmin.create!(email: 'admin@example.com')
    @men = MongoidMen.create!(email: 'men@example.com')
    @custom_search_user = MongoidCustomSearchUser.create!(email: 'custom@example.com')
  end

  config.after(:all) do
    Mongoid.purge!
  end

  config.after(:each) do
    ActsAsMessageable::Mongoid::Message.destroy_all
  end
end
