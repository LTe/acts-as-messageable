# typed: false
# frozen_string_literal: true

require 'rails/generators/migration'
require 'rails/generators/active_record'

module ActsAsMessageable
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    namespace 'acts_as_messageable:migration'

    source_root File.join(File.dirname(__FILE__), 'templates')
    argument :table_name, type: :string, default: 'messages'
    class_option :uuid, type: :boolean, default: false

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
        migration_template 'migration_permanent.rb',
                           'db/migrate/add_recipient_permanent_delete_and_sender_permanent_delete_to_messages.rb'
      rescue StandardError
        nil
      end
      begin
        migration_template 'migration_opened_as_datetime.rb', 'db/migrate/add_opened_at_to_messages.rb'
      rescue StandardError
        nil
      end
      begin
        migration_template 'migration_indexes.rb', 'db/migrate/add_indexes_to_messages.rb'
      rescue StandardError
        nil
      end
    end
  end
end
