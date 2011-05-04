$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'acts-as-messageable'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before(:all) do
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
    create_database

    @alice = User.create :email => "alice@example.com"
    @bob   = User.create :email => "bob@example.com"
  end

  config.after(:all) do
    drop_database
  end

  config.after(:each) do
    ActsAsMessageable::Message.destroy_all
  end
end

def create_database
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

def drop_database
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
