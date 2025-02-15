# typed: ignore
# frozen_string_literal: true

require 'sorbet-runtime'
T::Configuration.default_checked_level = :tests
T::Configuration.enable_checking_for_sigs_marked_checked_tests

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'active_record'
require 'coveralls'
Coveralls.wear!

require 'timecop'

require 'bundler/setup'
Bundler.require(:default)

require 'pry'
require 'acts-as-messageable'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

ActiveRecord::Migration.verbose = false

RSpec.configure do |config|
  config.before(:all) do
    establish_connection
    create_database

    @alice = User.create email: 'alice@example.com'
    @bob = User.create email: 'bob@example.com'
    @pat = User.create email: 'pat@example.com'
    @admin = Admin.create email: 'admin@example.com'
    @men = Men.create email: 'men@example.com'
    @custom_search_user = CustomSearchUser.create email: 'custom@example.com'
  end

  config.after(:all) do
    drop_database
  end

  config.after(:each) do
    User.messages_class_name.destroy_all
  end
end

def establish_connection
  ActiveRecord::Base.establish_connection(
    adapter: ENV.fetch('DATABASE_ADAPTER', 'sqlite3'),
    database: ENV.fetch('DATABASE_NAME', ':memory:'),
    password: ENV.fetch('DATABASE_PASSWORD', 'password'),
    host: 'localhost',
    user: 'postgres'
  )
end

def create_database
  ActiveRecord::Schema.define(version: 1) do
    enable_extension 'pgcrypto' if ENV.fetch('DATABASE_ADAPTER', '') == 'postgresql' && !extension_enabled?('pgcrypto')

    create_table(:messages, &TABLE_SCHEMA)
    create_table(:custom_messages, &TABLE_SCHEMA)
    create_table(:custom_messages_uuid, &TABLE_SCHEMA_UUID)

    create_table(:users, &USER_SCHEMA)
    create_table(:admins, &USER_SCHEMA)
    create_table(:custom_search_users, &USER_SCHEMA)
    create_table(:uuid_users, id: :uuid, &USER_SCHEMA)
  end
end

def drop_database
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
