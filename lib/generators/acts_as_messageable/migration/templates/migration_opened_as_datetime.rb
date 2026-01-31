# typed: ignore
class AddOpenedAtToMessages < ActiveRecord::Migration[7.0]
  class MigrationMessage < ActiveRecord::Base
    self.table_name = :<%= table_name %>
  end

  def up
    add_column :<%= table_name %>, :opened_at, :datetime
    MigrationMessage.where(opened: true).update_all(opened_at: Time.current)
  end

  def down
    MigrationMessage.where('opened_at is not null').update_all(opened: true)
    remove_column :<%= table_name %>, :opened_at
  end
end
