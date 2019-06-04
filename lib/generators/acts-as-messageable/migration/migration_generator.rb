require 'rails/generators/migration'
require 'rails/generators/active_record'

module ActsAsMessageable
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    namespace 'acts-as-messageable:migration'

    source_root File.join(File.dirname(__FILE__), 'templates')
    argument :table_name, type: :string, default: 'messages'

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def create_migration_file
      begin
        migration_template 'migration.rb', 'db/migrate/create_messages_table.rb'
      rescue StandardError
        nil
      end
      begin
        migration_template 'migration_permanent.rb', 'db/migrate/add_recipient_permanent_delete_and_sender_permanent_delete_to_messages.rb'
      rescue StandardError
        nil
      end
    end
  end
end
