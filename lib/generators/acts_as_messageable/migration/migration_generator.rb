require 'rails/generators/migration'
require 'rails/generators/active_record'

module ActsAsMessageable
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.join(File.dirname(__FILE__), 'templates')
    argument :table_name, :type => :string, :default => "messages"

    def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/create_messages_table.rb'
    end

  end
end
