$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'active_record/railtie'
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = 3

require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
Bundler.require(:default)

require 'acts-as-messageable'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.verbose = false

RSpec.configure do |config|
  config.before(:all) do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    create_database

    @alice = User.create  email: 'alice@example.com'
    @bob   = User.create  email: 'bob@example.com'
    @pat   = User.create  email: 'pat@example.com'
    @admin = Admin.create email: 'admin@example.com'
    @men   = Men.create   email: 'men@example.com'
  end

  config.after(:all) do
    drop_database
  end

  config.after(:each) do
    User.messages_class_name.destroy_all
  end
end

def create_database
  ActiveRecord::Schema.define(version: 1) do
    create_table :messages do |t|
      t.string :topic
      t.text :body
      t.references :received_messageable, polymorphic: true, index: false
      t.references :sent_messageable, polymorphic: true, index: false
      t.boolean :opened, default: false
      t.boolean :recipient_delete, default: false
      t.boolean :sender_delete, default: false
      t.boolean :recipient_permanent_delete, default: false
      t.boolean :sender_permanent_delete, default: false
      t.string :ancestry
      t.timestamps
    end

    create_table :custom_messages do |t|
      t.string :topic
      t.text :body
      t.references :received_messageable, polymorphic: true, index: false
      t.references :sent_messageable, polymorphic: true, index: false
      t.boolean :opened, default: false
      t.boolean :recipient_delete, default: false
      t.boolean :sender_delete, default: false
      t.boolean :recipient_permanent_delete, default: false
      t.boolean :sender_permanent_delete, default: false
      t.string :ancestry
      t.timestamps
    end
    create_table :users do |t|
      t.string :email
    end

    create_table :admins do |t|
      t.string :email
    end
  end
end

def drop_database
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
